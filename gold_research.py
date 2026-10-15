"""Gold intraday research (alerts only, no trading).

Downloads free 1-minute spot gold (XAUUSD) candles from Dukascopy, which track
COMEX gold futures very closely during the day, and tests a short list of
intraday rules that were fixed BEFORE looking at any result.

Money is shown for 1 micro gold future (MGC, 10 oz, $10 per $1 move).
Fills are pessimistic: entries pay slippage, stop wins if stop and target are
hit in the same minute, gaps through a stop fill at the worse open price,
targets need the price to trade one tick through.

Periods: 2018-2022 = "older" (first look), 2023-now = "recent" (the judge).
No parameter is tuned on either period. Writes reports/gold.md.
"""
import datetime as dt
import gzip
import json
import lzma
import os
import random
import struct
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from zoneinfo import ZoneInfo

NY = ZoneInfo("America/New_York")
LDN = ZoneInfo("Europe/London")
START = dt.date(2018, 1, 1)
END = dt.date(2026, 9, 30)
SPLIT_YEAR = 2023
CACHE = "data/gold"
TICK = 0.1
COST_NORMAL = 0.5     # $ per oz: about $3 commission+fees and 2 ticks slippage per MGC round trip
COST_PESSIMISTIC = 1.0
USD_PER_OZ = 10       # MGC = 10 oz
URL = "https://datafeed.dukascopy.com/datafeed/XAUUSD/{y}/{m:02d}/{d:02d}/BID_candles_min_1.bi5"


# ---------------------------------------------------------------- data
def fetch_day(day):
    url = URL.format(y=day.year, m=day.month - 1, d=day.day)
    last = ""
    for attempt in range(4):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=20) as r:
                raw = r.read()
            if not raw:
                return day, []
            data = lzma.decompress(raw)
            rows = [struct.unpack(">5if", data[i:i + 24]) for i in range(0, len(data) - 23, 24)]
            return day, rows
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return day, []
            last = f"HTTP {e.code}"
            time.sleep(2 + attempt * 3)
        except Exception as e:
            last = repr(e)[:200]
            time.sleep(2 + attempt * 3)
    print("failed", day, last, flush=True)
    return day, None


def detect_layout(rows):
    """Find which of the 4 int fields is high and which is low, and the price divisor."""
    hi = [0] * 4
    lo = [0] * 4
    for r in rows:
        v = r[1:5]
        hi[v.index(max(v))] += 1
        lo[v.index(min(v))] += 1
    h = hi.index(max(hi))
    l = lo.index(max(lo))
    rest = [i for i in range(4) if i not in (h, l)]
    o, c = rest[0], rest[1]
    med = sorted(r[1 + c] for r in rows)[len(rows) // 2]
    div = 1
    for d in (1, 10, 100, 1000, 10000):
        if 200 <= med / d <= 20000:
            div = d
            break
    return o, h, l, c, div


def load_month(y, m, layout_box):
    os.makedirs(CACHE, exist_ok=True)
    path = f"{CACHE}/{y}-{m:02d}.csv.gz"
    if os.path.exists(path):
        with gzip.open(path, "rt") as f:
            return [tuple(float(x) for x in line.split(",")) for line in f]
    days = []
    d = dt.date(y, m, 1)
    while d.month == m:
        if START <= d <= END:
            days.append(d)
        d += dt.timedelta(days=1)
    with ThreadPoolExecutor(4) as ex:
        res = list(ex.map(fetch_day, days))
    if any(r is None for _, r in res):
        raise SystemExit(f"download incomplete for {y}-{m:02d}")
    out = []
    for day, rows in res:
        if not rows:
            continue
        if layout_box[0] is None and len(rows) > 500:
            layout_box[0] = detect_layout(rows)
            print("layout", layout_box[0], flush=True)
        o, h, l, c, div = layout_box[0] or detect_layout(rows)
        base = int(dt.datetime(day.year, day.month, day.day, tzinfo=dt.timezone.utc).timestamp())
        for r in rows:
            v = r[1:5]
            out.append((base + r[0], v[o] / div, v[h] / div, v[l] / div, v[c] / div, max(r[5], 0.0)))
    with gzip.open(path, "wt") as f:
        for b in out:
            f.write(",".join(f"{x:.3f}" if i else str(int(x)) for i, x in enumerate(b)) + "\n")
    return out


def load_all():
    layout = [None]
    bars = []
    y, m = START.year, START.month
    while (y, m) <= (END.year, END.month):
        t0 = time.time()
        mb = load_month(y, m, layout)
        bars.extend(mb)
        print(f"{y}-{m:02d}: {len(mb)} bars ({time.time() - t0:.0f}s)", flush=True)
        m += 1
        if m == 13:
            y, m = y + 1, 1
    bars.sort()
    return bars


def build_days(bars):
    """Group by New York date, keep 00:00-16:59 ET. Each bar: (et_min, ldn_min, o, h, l, c, v)."""
    days = {}
    for ts, o, h, l, c, v in bars:
        t = dt.datetime.fromtimestamp(ts, dt.timezone.utc)
        e = t.astimezone(NY)
        if e.hour >= 17 or e.weekday() >= 5:
            continue
        lt = t.astimezone(LDN)
        days.setdefault(e.date(), []).append((e.hour * 60 + e.minute, lt.hour * 60 + lt.minute, o, h, l, c, v))
    keys = sorted(days)
    atr = {}
    ranges = []
    for k in keys:
        if len(ranges) >= 14:
            atr[k] = sum(ranges[-14:]) / 14
        b = days[k]
        if len(b) > 600:
            ranges.append(max(x[3] for x in b) - min(x[4] for x in b))
    return [(k, days[k], atr.get(k)) for k in keys if atr.get(k) and len(days[k]) > 600]


# ---------------------------------------------------------------- simulator
def run_trade(bars, j, d, entry, stop, target, exit_min, key=0, same_bar_check=True):
    """Trade already filled in bar j at `entry`. Returns (exit_price, reason)."""
    # same bar as a stop-order fill: only the stop can be hit (pessimistic)
    if same_bar_check:
        b = bars[j]
        if (d > 0 and b[4] <= stop) or (d < 0 and b[3] >= stop):
            return stop - d * TICK, "stop"
    for k in range(j + 1, len(bars)):
        _, _, o, h, l, c, _ = bars[k][:7]
        tm = bars[k][key]
        if d > 0:
            if l <= stop:
                return min(stop, o) - TICK, "stop"
            if target is not None and h >= target + TICK:
                return target, "target"
        else:
            if h >= stop:
                return max(stop, o) + TICK, "stop"
            if target is not None and l <= target - TICK:
                return target, "target"
        if tm >= exit_min:
            return c - d * TICK, "time"
    return bars[-1][5] - d * TICK, "time"


def orb(bars, atr, key, r0, r1, last_entry, exit_min):
    rng = [b for b in bars if r0 <= b[key] < r1]
    if len(rng) < (r1 - r0) * 0.6:
        return None
    rh = max(b[3] for b in rng)
    rl = min(b[4] for b in rng)
    for j, b in enumerate(bars):
        tm = b[key]
        if tm < r1:
            continue
        if tm > last_entry:
            return None
        o, h, l = b[2], b[3], b[4]
        up = h >= rh + TICK
        dn = l <= rl - TICK
        if up and dn:
            return None
        if up or dn:
            d = 1 if up else -1
            lvl = rh + TICK if up else rl - TICK
            entry = (max(lvl, o) if up else min(lvl, o)) + d * TICK
            stop = rl if up else rh
            risk = abs(entry - stop)
            if risk <= 0:
                return None
            return d, entry, run_trade(bars, j, d, entry, stop, entry + d * 2 * risk, exit_min, key)
    return None


def s_orb_ny_15(bars, atr, day):
    return orb(bars, atr, 0, 500, 515, 690, 810)


def s_orb_ny_30(bars, atr, day):
    return orb(bars, atr, 0, 500, 530, 690, 810)


def s_london_orb_30(bars, atr, day):
    return orb(bars, atr, 1, 480, 510, 660, 960)


def next_bar_entry(bars, j, d, stop_dist, target, exit_min):
    if j + 1 >= len(bars):
        return None
    entry = bars[j + 1][2] + d * TICK
    stop = entry - d * stop_dist
    if target is not None and (target - entry) * d <= 0:
        return None
    return d, entry, run_trade(bars, j + 1, d, entry, stop, target, exit_min, 0, same_bar_check=True)


def s_trend_day(bars, atr, day):
    first = next((b for b in bars if b[0] >= 500), None)
    if not first or first[0] > 505:
        return None
    for j, b in enumerate(bars):
        if b[0] >= 630:
            if b[0] > 635:
                return None
            move = b[5] - first[2]
            if abs(move) < 0.4 * atr:
                return None
            return next_bar_entry(bars, j, 1 if move > 0 else -1, 0.3 * atr, None, 810)
    return None


def s_vwap_revert(bars, atr, day):
    pv = vv = 0.0
    for j, b in enumerate(bars):
        if b[0] < 500:
            continue
        tp = (b[3] + b[4] + b[5]) / 3
        w = b[6] if b[6] > 0 else 1.0
        pv += tp * w
        vv += w
        if b[0] < 570:
            continue
        if b[0] > 720:
            return None
        vwap = pv / vv
        dev = b[5] - vwap
        if abs(dev) > 0.35 * atr:
            d = -1 if dev > 0 else 1
            return next_bar_entry(bars, j, d, 0.25 * atr, vwap, 810)
    return None


def s_random(bars, atr, day):
    rnd = random.Random(day.toordinal())
    t = rnd.randrange(515, 720)
    d = rnd.choice((1, -1))
    for j, b in enumerate(bars):
        if b[0] >= t:
            if j + 1 >= len(bars):
                return None
            entry = bars[j + 1][2] + d * TICK
            return d, entry, run_trade(bars, j + 1, d, entry, entry - d * 0.3 * atr,
                                       entry + d * 0.6 * atr, 810, 0)
    return None


STRATEGIES = {
    "orb_ny_15": ("New York open range breakout, range 8:20-8:35 ET, stop other side, target 2x risk, out by 13:30 ET", s_orb_ny_15),
    "orb_ny_30": ("Same with a 30 minute range, 8:20-8:50 ET", s_orb_ny_30),
    "london_orb_30": ("London open range breakout, range 8:00-8:30 London, out by 16:00 London", s_london_orb_30),
    "trend_day": ("At 10:30 ET, if gold moved more than 0.4 day-ranges since 8:20, follow it, stop 0.3 range, out by 13:30", s_trend_day),
    "vwap_revert": ("9:30-12:00 ET, if price is more than 0.35 day-ranges from the session average, fade it back to the average", s_vwap_revert),
    "random_control": ("Benchmark: random time and random direction, stop 0.3 range, target 0.6 range", s_random),
}


# ---------------------------------------------------------------- stats
def stats(pnls):
    n = len(pnls)
    if not n:
        return dict(n=0)
    wins = [p for p in pnls if p > 0]
    loss = -sum(p for p in pnls if p < 0)
    eq = peak = dd = 0.0
    for p in pnls:
        eq += p
        peak = max(peak, eq)
        dd = max(dd, peak - eq)
    return dict(n=n, win=100 * len(wins) / n, avg=sum(pnls) / n, total=sum(pnls),
                pf=(sum(wins) / loss) if loss else 99.0, dd=dd)


def boot(pnls, it=4000):
    if len(pnls) < 10:
        return 0.0
    rnd = random.Random(7)
    n = len(pnls)
    pos = sum(1 for _ in range(it) if sum(rnd.choice(pnls) for _ in range(n)) > 0)
    return 100 * pos / it


def money(pnl_oz, cost):
    return (pnl_oz - cost) * USD_PER_OZ


def probe():
    """Print exactly what the data server answers, so a failure is easy to diagnose."""
    import subprocess
    url = URL.format(y=2024, m=2, d=5)
    for ua in ("Mozilla/5.0", None):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": ua} if ua else {})
            with urllib.request.urlopen(req, timeout=20) as r:
                print("probe urllib", ua, r.status, len(r.read()), flush=True)
        except Exception as e:
            print("probe urllib", ua, "error", repr(e)[:300], flush=True)
    try:
        out = subprocess.run(["curl", "-sS", "-o", "/dev/null", "-w", "%{http_code} %{size_download} %{remote_ip}", "--max-time", "20", url],
                             capture_output=True, text=True)
        print("probe curl", out.stdout, out.stderr[:300], flush=True)
    except Exception as e:
        print("probe curl error", e, flush=True)


def main():
    t0 = time.time()
    probe()
    bars = load_all()
    if len(bars) < 100000:
        raise SystemExit("too little data")
    days = build_days(bars)
    print(f"{len(bars)} bars, {len(days)} trading days, {time.time() - t0:.0f}s", flush=True)
    lo = min(b[3] for b in bars[:5000])
    print("sanity first price", bars[0][1], "first low", lo, flush=True)

    trades = {k: [] for k in STRATEGIES}
    for day, b, atr in days:
        for k, (_, fn) in STRATEGIES.items():
            r = fn(b, atr, day)
            if r:
                d, entry, (exitp, why) = r
                trades[k].append((day, d * (exitp - entry), why))

    years = sorted({d.year for d, _, _ in days})
    L = ["# Gold intraday research", "",
         f"Data: Dukascopy 1-minute spot gold (XAUUSD), {days[0][0]} to {days[-1][0]}, {len(days)} trading days.",
         "Money is for 1 micro gold future (MGC, 10 oz). Normal costs $5 per round trip, pessimistic $10.",
         f"Older period 2018-{SPLIT_YEAR - 1}, recent period {SPLIT_YEAR}-now. Rules were fixed before any result.", "",
         "Pass bar (all must hold): recent period positive at pessimistic costs, older period positive at pessimistic costs,",
         "at least 100 recent trades, profit factor above 1.15 recent, positive in at least 70% of years,",
         "bootstrap chance of a positive recent average at least 95%, and better than the random control in both periods.", ""]
    summary = {}
    rc = {}
    for k in STRATEGIES:
        tr = trades[k]
        old = [money(p, COST_PESSIMISTIC) for d, p, _ in tr if d.year < SPLIT_YEAR]
        new = [money(p, COST_PESSIMISTIC) for d, p, _ in tr if d.year >= SPLIT_YEAR]
        newn = [money(p, COST_NORMAL) for d, p, _ in tr if d.year >= SPLIT_YEAR]
        yr = {y: sum(money(p, COST_PESSIMISTIC) for d, p, _ in tr if d.year == y) for y in years}
        summary[k] = dict(old=stats(old), new=stats(new), newn=stats(newn), yr=yr,
                          boot=boot(new), why={w: sum(1 for *_, x in tr if x == w) for w in ("stop", "target", "time")})
    ctrl = summary["random_control"]
    L += ["## Summary (pessimistic costs, $ per trade for 1 MGC)", "",
          "| rule | older trades | older avg $ | recent trades | recent avg $ | recent avg $ (normal costs) | recent win % | recent PF | recent max DD $ | years positive | bootstrap % | verdict |",
          "|---|---|---|---|---|---|---|---|---|---|---|---|"]
    for k, s in summary.items():
        o, nw, nn = s["old"], s["new"], s["newn"]
        if not nw.get("n") or not o.get("n"):
            L.append(f"| {k} | no trades | | | | | | | | | | |")
            continue
        yp = sum(1 for v in s["yr"].values() if v > 0)
        ok = (k != "random_control" and nw["avg"] > 0 and o["avg"] > 0 and nw["n"] >= 100 and nw["pf"] > 1.15
              and yp >= 0.7 * len(years) and s["boot"] >= 95
              and nw["avg"] > ctrl["new"].get("avg", 0) and o["avg"] > ctrl["old"].get("avg", 0))
        verdict = "control" if k == "random_control" else ("PASS" if ok else "fail")
        rc[k] = verdict
        L.append(f"| {k} | {o['n']} | {o['avg']:.1f} | {nw['n']} | {nw['avg']:.1f} | {nn['avg']:.1f} | {nw['win']:.0f} | "
                 f"{nw['pf']:.2f} | {nw['dd']:.0f} | {yp}/{len(years)} | {s['boot']:.0f} | {verdict} |")
    L += ["", "## Profit per year, pessimistic costs, $ for 1 MGC", "",
          "| rule | " + " | ".join(str(y) for y in years) + " |", "|---" * (len(years) + 1) + "|"]
    for k, s in summary.items():
        L.append(f"| {k} | " + " | ".join(f"{s['yr'][y]:.0f}" for y in years) + " |")
    L += ["", "## How trades ended (all years)", "", "| rule | stop | target | time |", "|---|---|---|---|"]
    for k, s in summary.items():
        w = s["why"]
        L.append(f"| {k} | {w['stop']} | {w['target']} | {w['time']} |")
    L += ["", "## Rules", ""] + [f"- {k}: {d}" for k, (d, _) in STRATEGIES.items()]
    L += ["", f"Runtime {time.time() - t0:.0f}s. Spot gold is a proxy for futures; real fills may differ slightly."]
    os.makedirs("reports", exist_ok=True)
    with open("reports/gold.md", "w") as f:
        f.write("\n".join(L) + "\n")
    with open("reports/gold.json", "w") as f:
        json.dump({"verdicts": rc, "summary": {k: {kk: vv for kk, vv in v.items() if kk != "yr"} for k, v in summary.items()}},
                  f, default=str, indent=1)
    print("\n".join(L), flush=True)


if __name__ == "__main__":
    main()
