"""History study: replay entry and exit rules on past 1-minute prices.

    python3 history.py                 # fetch from GeckoTerminal, then test
    python3 history.py --fake          # offline test with simulated candles

Tokens studied: everything our live runs recorded as trending (including tokens
that later died, to limit survivorship bias) plus today's trending and top
volume pools. For each pool, about 2 days of 1-minute candles are fetched.

Pessimistic fill model on 1-minute candles:
- entry at the open of the next candle after the signal
- if a stop and a target are both touched in the same candle, the stop wins
- stops fill 5% worse than the stop level (bounded by the candle low), or at
  the open if the candle opens below the stop (a gap)
- costs on both sides (2.5% and 5% per side reported)

Not testable on history (judged only on live data): holder count, top 10
share, insiders, liquidity ratio. These need snapshots from the time.
"""

import bisect
import copy
import csv
import glob
import gzip
import json
import os
import random
import statistics
import sys
import time
import urllib.error
import urllib.request

ROOT = os.path.dirname(os.path.abspath(__file__))
CACHE = os.path.join(ROOT, "data", "history")
GT = "https://api.geckoterminal.com/api/v2/networks/solana"
UA = "Mozilla/5.0 (paper-trading research; no trading)"
QUOTES = {"So11111111111111111111111111111111111111112", "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
          "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB"}
STOP_SLIP = 0.05      # stops fill 5% below the stop level (live runs showed -27% to -34% on -20% stops)
COSTS = (0.025, 0.05)

# ------------------------------------------------------------------ fetching
_last = [0.0]


def get(path, retries=3):
    for attempt in range(retries + 1):
        wait = _last[0] + 2.3 - time.time()           # about 26 requests per minute
        if wait > 0:
            time.sleep(wait)
        _last[0] = time.time()
        try:
            req = urllib.request.Request(GT + path, headers={"User-Agent": UA,
                                                             "Accept": "application/json;version=20230302"})
            with urllib.request.urlopen(req, timeout=20) as r:
                return json.loads(r.read().decode())
        except urllib.error.HTTPError as e:
            if e.code == 429 and attempt < retries:
                time.sleep(20)
                continue
            return None
        except Exception:
            if attempt < retries:
                time.sleep(3)
                continue
            return None


def pool_info(p):
    a = p.get("attributes", {})
    try:
        base = p["relationships"]["base_token"]["data"]["id"].split("_", 1)[1]
    except (KeyError, TypeError, IndexError):
        base = None
    price = _f(a.get("base_token_price_usd"))
    fdv = _f(a.get("fdv_usd"))
    return {"pool": a.get("address"), "name": a.get("name"), "base": base,
            "created": a.get("pool_created_at"), "supply": fdv / price if fdv and price else None}


def _f(x):
    try:
        return float(x)
    except (TypeError, ValueError):
        return None


def recorded_mints():
    """Tokens our live runs saw while they were trending (newest runs first)."""
    seen = []
    for path in sorted(glob.glob(os.path.join(ROOT, "results", "*", "*", "tokens.csv")), reverse=True):
        with open(path) as fh:
            for r in csv.DictReader(fh):
                if r["mint"] not in seen:
                    seen.append(r["mint"])
    if not seen:  # older runs only have trades/decisions
        for path in glob.glob(os.path.join(ROOT, "results", "*", "*", "decisions.csv")):
            with open(path) as fh:
                for r in csv.DictReader(fh):
                    if r["mint"] not in seen:
                        seen.append(r["mint"])
    return seen


def collect(max_pools, max_minutes, pages_per_pool):
    deadline = time.time() + max_minutes * 60
    pools = {}

    def add(p):
        info = pool_info(p)
        if info["pool"] and info["base"] and info["base"] not in QUOTES and info["pool"] not in pools:
            pools[info["pool"]] = info

    for q in ("?page=1", "?page=2", "?duration=5m", "?duration=1h", "?duration=6h&page=1", "?duration=6h&page=2"):
        d = get("/trending_pools" + q)
        for p in (d or {}).get("data", []) or []:
            add(p)
    for page in (1, 2):
        d = get(f"/pools?page={page}&sort=h24_tx_count_desc")
        for p in (d or {}).get("data", []) or []:
            add(p)
    print(f"Pools from current lists: {len(pools)}", flush=True)

    # tokens our runs saw, including ones that have since died
    for mint in recorded_mints()[:60]:
        if len(pools) >= max_pools or time.time() > deadline - 5 * 60:
            break
        if any(v["base"] == mint for v in pools.values()):
            continue
        d = get(f"/tokens/{mint}/pools?page=1")
        lst = (d or {}).get("data", []) or []
        if lst:
            add(lst[0])
    print(f"Pools including recorded tokens: {len(pools)}", flush=True)

    os.makedirs(CACHE, exist_ok=True)
    done = 0
    for pool, info in list(pools.items())[:max_pools]:
        if time.time() > deadline:
            break
        path = os.path.join(CACHE, f"{pool}.json.gz")
        if os.path.exists(path):
            done += 1
            continue
        candles, before = [], None
        for _ in range(pages_per_pool):
            q = f"/pools/{pool}/ohlcv/minute?aggregate=1&limit=1000&currency=usd"
            if before:
                q += f"&before_timestamp={before}"
            d = get(q)
            lst = (((d or {}).get("data") or {}).get("attributes") or {}).get("ohlcv_list") or []
            if not lst:
                break
            candles += lst
            before = min(c[0] for c in lst)
            if len(lst) < 1000:
                break
        if candles:
            with gzip.open(path, "wt") as fh:
                json.dump({"info": info, "candles": candles}, fh)
            done += 1
        if done % 10 == 0:
            print(f"  fetched {done} pools", flush=True)
    print(f"Pools with candles: {done}", flush=True)


# ------------------------------------------------------------------ data
def load_all():
    out = []
    for path in glob.glob(os.path.join(CACHE, "*.json.gz")):
        with gzip.open(path, "rt") as fh:
            d = json.load(fh)
        cs = sorted({int(c[0]): c for c in d["candles"]}.values(), key=lambda c: c[0])
        if len(cs) < 60:
            continue
        info = d["info"]
        created = info.get("created")
        ct = None
        if created:
            import datetime as dt
            ct = dt.datetime.fromisoformat(created.replace("Z", "+00:00")).timestamp()
        out.append({"pool": info["pool"], "name": info.get("name"), "supply": info.get("supply"),
                    "created": ct, "ts": [int(c[0]) for c in cs],
                    "o": [float(c[1]) for c in cs], "h": [float(c[2]) for c in cs],
                    "l": [float(c[3]) for c in cs], "c": [float(c[4]) for c in cs],
                    "v": [float(c[5]) for c in cs]})
    return out


def close_at(tok, t):
    """Last close at or before time t (None if none within 30 minutes)."""
    i = bisect.bisect_right(tok["ts"], t) - 1
    if i < 0 or t - tok["ts"][i] > 1800:
        return None
    return tok["c"][i]


def breadth_map(tokens):
    """Share of tokens up over the previous hour, per minute."""
    minutes = sorted({t for tok in tokens for t in tok["ts"]})
    out = {}
    for t in minutes[::5]:
        ups = n = 0
        for tok in tokens:
            a, b = close_at(tok, t), close_at(tok, t - 3600)
            if a and b:
                n += 1
                ups += a > b
        if n >= 5:
            for k in range(5):
                out[t + 60 * k] = ups / n
    return out


# ------------------------------------------------------------------ simulation
BASE = {
    "min_age_minutes": 30, "pullback_m5_min": -20, "pullback_m5_max": 5,
    "min_mcap": 50_000, "max_mcap": 20_000_000, "min_vol5_usd": 1_000,
    "stop_loss": 0.20, "take_half_at": 0.30, "trail_from_peak": 0.20,
    "time_stop_minutes": 10, "max_hold_minutes": 120, "cooldown_minutes": 5,
}
VARIANTS = {
    "current_v3_rules": {},
    "stop_15": {"stop_loss": 0.15}, "stop_25": {"stop_loss": 0.25}, "stop_35": {"stop_loss": 0.35},
    "take_half_20": {"take_half_at": 0.20}, "take_half_50": {"take_half_at": 0.50},
    "trail_15": {"trail_from_peak": 0.15}, "trail_30": {"trail_from_peak": 0.30},
    "time_stop_5": {"time_stop_minutes": 5}, "time_stop_20": {"time_stop_minutes": 20},
    "max_hold_60": {"max_hold_minutes": 60},
    "pullback_-10_5": {"pullback_m5_min": -10}, "pullback_-30_0": {"pullback_m5_min": -30, "pullback_m5_max": 0},
    "age_60": {"min_age_minutes": 60},
    "market_up_1h_50": {"min_breadth": 0.50},
    "market_up_1h_60": {"min_breadth": 0.60},
    "momentum_5_30": {"pullback_m5_min": 5, "pullback_m5_max": 30},
    "momentum_5_30_market_up": {"pullback_m5_min": 5, "pullback_m5_max": 30, "min_breadth": 0.50},
    "mcap_over_500k": {"min_mcap": 500_000},
    "control_any_entry": {"pullback_m5_min": -1000, "pullback_m5_max": 1000},
}


def simulate(tok, P, breadth):
    trades = []
    ts, o, h, l, c, v = tok["ts"], tok["o"], tok["h"], tok["l"], tok["c"], tok["v"]
    n = len(ts)
    i, next_ok = 0, 0
    while i < n - 1:
        t = ts[i]
        if t < next_ok:
            i += 1
            continue
        # entry checks at the close of candle i
        ok = True
        if tok["created"] and (t - tok["created"]) / 60 < P["min_age_minutes"]:
            ok = False
        ref = close_at(tok, t - 300) if ok else None
        if ok and not ref:
            ok = False
        if ok:
            m5 = (c[i] / ref - 1) * 100
            ok = P["pullback_m5_min"] <= m5 <= P["pullback_m5_max"]
        if ok and tok["supply"]:
            mcap = c[i] * tok["supply"]
            ok = P["min_mcap"] <= mcap <= P["max_mcap"]
        elif ok:
            ok = False
        if ok:
            j0 = bisect.bisect_left(ts, t - 299)
            ok = sum(v[j0:i + 1]) >= P["min_vol5_usd"]
        if ok and "min_breadth" in P:
            b = breadth.get(t)
            ok = b is not None and b >= P["min_breadth"]
        if not ok:
            i += 1
            continue
        k = i + 1
        if ts[k] - t > 300:           # no trading right after the signal
            i += 1
            continue
        e, et = o[k], ts[k]
        fills, half, peak, checked = [], False, e, False
        rem = 1.0
        j = k
        while j < n and rem > 0:
            first = j == k
            if not half:
                sp = e * (1 - P["stop_loss"])
                if not first and o[j] <= sp:
                    fills.append((rem, o[j], "stop_gap")); rem = 0; break
                if l[j] <= sp:
                    fills.append((rem, max(l[j], sp * (1 - STOP_SLIP)), "stop")); rem = 0; break
                if h[j] >= e * (1 + P["take_half_at"]):
                    fills.append((0.5, e * (1 + P["take_half_at"]), "take_half")); rem = 0.5; half = True
            else:
                tp = peak * (1 - P["trail_from_peak"])
                if o[j] <= tp:
                    fills.append((rem, o[j], "trail_gap")); rem = 0; break
                if l[j] <= tp:
                    fills.append((rem, max(l[j], tp * (1 - STOP_SLIP / 2)), "trail")); rem = 0; break
            peak = max(peak, h[j])
            held = (ts[j] + 60 - et) / 60
            if not checked and held >= P["time_stop_minutes"]:
                checked = True
                if c[j] < e:
                    fills.append((rem, c[j], "time_stop")); rem = 0; break
            if held >= P["max_hold_minutes"]:
                fills.append((rem, c[j], "max_hold")); rem = 0; break
            j += 1
        if rem > 0:
            fills.append((rem, c[min(j, n - 1)], "data_end"))
            j = n - 1
        trades.append({"pool": tok["pool"], "name": tok["name"], "entry_t": et, "e": e, "fills": fills,
                       "ret": {cst: sum(f * px * (1 - cst) for f, px, _ in fills) / (e * (1 + cst)) - 1
                               for cst in COSTS}})
        next_ok = ts[min(j, n - 1)] + P["cooldown_minutes"] * 60
        i = bisect.bisect_left(ts, next_ok)
    return trades


def stats(trades, cost):
    rets = [t["ret"][cost] for t in trades]
    if not rets:
        return None
    by = {}
    for t in trades:
        by[t["pool"]] = by.get(t["pool"], 0) + t["ret"][cost]
    best = max(by, key=by.get)
    return {"n": len(rets), "tokens": len(by), "win": sum(r > 0 for r in rets) / len(rets),
            "avg": statistics.mean(rets), "median": statistics.median(rets),
            "without_best": (sum(rets) - by[best]) / max(1, len(rets) - sum(1 for t in trades if t["pool"] == best)),
            "worst": min(rets), "best": max(rets)}


def boot_positive(rets, rng, n=1000):
    if not rets:
        return 0
    return sum(sum(rng.choice(rets) for _ in rets) > 0 for _ in range(n)) / n


def report(tokens):
    rng = random.Random(1)
    breadth = breadth_map(tokens)
    t_all = sorted(t for tok in tokens for t in tok["ts"])
    mid = t_all[len(t_all) // 2] if t_all else 0
    hours = (t_all[-1] - t_all[0]) / 3600 if t_all else 0
    rows = []
    for name, patch in VARIANTS.items():
        P = {**BASE, **patch}
        tr = [x for tok in tokens for x in simulate(tok, P, breadth)]
        s25, s5 = stats(tr, 0.025), stats(tr, 0.05)
        early = stats([x for x in tr if x["entry_t"] < mid], 0.05)
        late = stats([x for x in tr if x["entry_t"] >= mid], 0.05)
        odd = stats([x for x in tr if sum(map(ord, x["pool"])) % 2], 0.05)
        even = stats([x for x in tr if not sum(map(ord, x["pool"])) % 2], 0.05)
        p_pos = boot_positive([x["ret"][0.05] for x in tr], rng)
        rows.append((name, s25, s5, early, late, odd, even, p_pos))

    def pct(s, k="avg"):
        return "" if not s else f"{s[k]:+.1%}"

    lines = ["# History study", "",
             f"{len(tokens)} tokens, about {hours:.0f} hours of 1-minute prices. Same entry and exit rules as the live "
             f"test, with pessimistic fills. Holder, top-10, insider and liquidity rules cannot be tested on history.", "",
             "| rules | trades | tokens | win rate | avg 2.5% costs | avg 5% costs | median 5% | first half | second half | half A tokens | half B tokens | chance avg > 0 |",
             "|---|---|---|---|---|---|---|---|---|---|---|---|"]
    for name, s25, s5, early, late, odd, even, p in rows:
        if not s5:
            lines.append(f"| {name} | 0 | | | | | | | | | | |")
            continue
        lines.append(f"| {name} | {s5['n']} | {s5['tokens']} | {s5['win']:.0%} | {pct(s25)} | {pct(s5)} | "
                     f"{pct(s5, 'median')} | {pct(early)} | {pct(late)} | {pct(odd)} | {pct(even)} | {p:.0%} |")
    good = [r for r in rows if r[2] and r[2]["n"] >= 50 and r[2]["avg"] > 0 and r[3] and r[4] and r[3]["avg"] > 0
            and r[4]["avg"] > 0 and r[5] and r[6] and r[5]["avg"] > 0 and r[6]["avg"] > 0]
    lines += ["", "**Consistent winners** (50+ trades, positive at 5% costs in both time halves and both token halves): "
              + (", ".join(r[0] for r in good) if good else "none"), ""]
    text = "\n".join(lines) + "\n"
    os.makedirs(os.path.join(ROOT, "reports"), exist_ok=True)
    with open(os.path.join(ROOT, "reports", "history.md"), "w") as fh:
        fh.write(text)
    print(text, flush=True)


# ------------------------------------------------------------------ fake data
def make_fake(n_tokens=40, seed=5):
    import math
    rng = random.Random(seed)
    os.makedirs(CACHE, exist_ok=True)
    t0 = 1_760_000_000 - 3000 * 60
    for k in range(n_tokens):
        price, cs = 1e-4 * (1 + k), []
        for i in range(3000):
            r = rng.gauss(0, 0.02) + (rng.choice([0.5, -0.6]) if rng.random() < 0.002 else 0)
            o = price
            price *= math.exp(r)
            hi, lo = max(o, price) * (1 + abs(rng.gauss(0, 0.01))), min(o, price) * (1 - abs(rng.gauss(0, 0.01)))
            if rng.random() < 0.9:
                cs.append([t0 + 60 * i, o, hi, lo, price, rng.uniform(100, 5000)])
        info = {"pool": f"FAKEPOOL{k}", "name": f"TK{k} / SOL", "base": f"MINT{k}",
                "created": "2025-10-01T00:00:00Z", "supply": 1e9 * (0.5 + rng.random()) / (1 + k) * 2}
        with gzip.open(os.path.join(CACHE, f"FAKEPOOL{k}.json.gz"), "wt") as fh:
            json.dump({"info": info, "candles": cs[::-1]}, fh)


def main():
    if "--fake" in sys.argv:
        global CACHE
        CACHE = os.path.join(ROOT, "data", "history_fake")
        make_fake()
    else:
        collect(max_pools=int(os.environ.get("MAX_POOLS", 150)),
                max_minutes=float(os.environ.get("MAX_FETCH_MINUTES", 14)),
                pages_per_pool=int(os.environ.get("PAGES_PER_POOL", 3)))
    tokens = load_all()
    print(f"Studying {len(tokens)} tokens", flush=True)
    report(tokens)


if __name__ == "__main__":
    main()
