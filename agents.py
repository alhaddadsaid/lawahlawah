"""Agent PAPER trading desk (no real money, no wallet, no broker).

Since 2026-10-21 the team desk is the EXPERIMENTAL self-organizing team in team.py (no strategy rules,
news and calendar feeds, journal, hire/fire, $3/day API cap). The description below is the original design.


Runs continuously on GitHub Actions (4 runs a day of almost 6 hours each). Every 3 minutes:
  1. Researcher  gathers free data: Solana memecoins (GeckoTerminal trending, DexScreener boosts and
                 profiles, RugCheck safety) plus gold, EUR/USD and GBP/USD (Yahoo Finance), and writes a brief.
  2. Analyst     challenges the brief using the rules and the desk's own track record.
  3. Sniper      turns what survives into exact paper orders (JSON). Code checks every order against
                 hard guardrails, opens paper positions, watches them about 48 minutes, and closes them on
                 stop, target or time limit.

A rule-based CONTROL desk trades alongside with fixed rules (frozen memecoin v3 entry rules, random-direction
macro trades). The agents only count as useful if, after enough trades, they beat the control desk and are
positive at pessimistic costs.

Discussion uses the Claude API (secret ANTHROPIC_API_KEY). Without the key only the control desk trades.
Files: agents/state.json, agents/trades.csv, agents/discussions/YYYY-MM-DD.md, reports/agents.md
"""
import csv
import datetime as dt
import json
import math
import os
import random
import re
import sys
import time
import urllib.error
import urllib.request

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

FAKE = os.environ.get("AGENTS_FAKE") == "1"
API_KEY = os.environ.get("ANTHROPIC_API_KEY", "")
MODEL = os.environ.get("AGENT_MODEL", "claude-haiku-5-5")
ANALYST_MODEL = os.environ.get("ANALYST_MODEL", MODEL)
RUN_MINUTES = float(os.environ.get("RUN_MINUTES", "345"))     # one GitHub run lasts almost 6 hours
SCAN_SECONDS = int(os.environ.get("SCAN_SECONDS", "180"))       # new memecoin scan every 3 minutes
MEME_POLL = 5                                                   # open memecoin positions checked every 5 s
MACRO_POLL = 30                                                 # open gold/forex positions every 30 s
MACRO_REVIEW_MIN = int(os.environ.get("MACRO_REVIEW_MIN", "15"))   # agents review gold/forex every 15 minutes
COOLDOWN_MIN = int(os.environ.get("COOLDOWN_MIN", "15"))         # a token is re-discussed / re-entered after 15 min
MAX_TALKS_PER_DAY = int(os.environ.get("MAX_TALKS_PER_DAY", "480"))   # hard cap: about $1 a day with Haiku
GIT_SYNC_MIN = 10
DIR = os.environ.get("AGENTS_DIR", "agents")
REPORT = os.environ.get("AGENTS_REPORT", "reports/agents.md")

CFG = {
    "start_cash": 10000.0,
    "max_open_per_desk": 5,
    "max_new_per_run": 3,
    "meme_size_usd": 200.0,
    "meme_cost_per_side": (0.025, 0.05),          # normal, pessimistic
    "meme_stop_range": (0.10, 0.30),              # stop 10-30% below entry
    "meme_target_range": (0.15, 1.50),            # target 15-150% above entry
    "meme_max_hours": 2.0,
    "macro_risk_usd": 100.0,                      # 1% of the paper account per macro trade
    "macro_stop_atr": (0.3, 3.0),
    "macro_target_atr": (0.3, 6.0),
    "macro_max_hours": 48.0,
    "macro_cost_rt": {"GOLD": (0.5, 1.0), "EURUSD": (0.00007, 0.00012), "GBPUSD": (0.0001, 0.00016)},
    "tradeable": dict(min_mcap=50000, max_mcap=20000000, min_liq=10000, min_vol_m5=1000),
    "v3": dict(min_age=30, min_holders=1000, min_liq_ratio=0.2, max_top10=0.3, max_insiders=0.1,
               m5_min=-20, m5_max=5),
    "eval_min_trades": 50,
}
MACRO = {"GOLD": "GC=F", "EURUSD": "EURUSD=X", "GBPUSD": "GBPUSD=X"}
BLOCK = ["trump", "melania", "elon", "musk", "tesla", "spacex", "openai", "chatgpt", "nvidia", "apple",
         "google", "binance", "coinbase", "solana", "usdc", "usdt", "tether", "official", "airdrop", "farm", "free"]


def now():
    return time.time()


def iso(t=None):
    return dt.datetime.fromtimestamp(t or now(), dt.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")


# ------------------------------------------------------------------ data: memecoins
def meme_data():
    if FAKE:
        import agents_fake
        return agents_fake.meme_data()
    from papertest import sources
    mints = list(sources.discover())
    snap = sources.poll_prices(mints)
    T = CFG["tradeable"]
    rows = []
    for mint, s in snap.items():
        name = f"{s.get('symbol') or ''} {s.get('name') or ''}".lower()
        if any(b in name for b in BLOCK):
            continue
        mc, liq, v5 = s.get("mcap"), s.get("liquidity_usd"), s.get("vol_m5")
        if not (mc and liq and v5) or not (T["min_mcap"] <= mc <= T["max_mcap"]) or liq < T["min_liq"] \
                or liq > mc or v5 < T["min_vol_m5"]:
            continue
        rows.append(dict(mint=mint, **s))
    rows.sort(key=lambda r: -(r.get("vol_m5") or 0))
    rows = rows[:12]
    for r in rows:
        r.update(sources.rugcheck(r["mint"]))
    return rows


def meme_prices(mints):
    if FAKE:
        import agents_fake
        return agents_fake.meme_prices(mints)
    from papertest import sources
    return {m: s["price"] for m, s in sources.poll_prices(mints).items()}


# ------------------------------------------------------------------ data: gold and forex
def _yahoo(ticker, interval, rng):
    url = f"https://query1.finance.yahoo.com/v8/finance/chart/{ticker}?interval={interval}&range={rng}"
    for attempt in range(3):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=20) as r:
                d = json.loads(r.read().decode())
            res = d["chart"]["result"][0]
            q = res["indicators"]["quote"][0]
            bars = [(t, o, h, l, c) for t, o, h, l, c in zip(res["timestamp"], q["open"], q["high"], q["low"], q["close"])
                    if None not in (o, h, l, c)]
            return bars
        except Exception:
            time.sleep(3 * (attempt + 1))
    return []


def macro_data():
    if FAKE:
        import agents_fake
        return agents_fake.macro_data()
    out = {}
    for sym, tk in MACRO.items():
        h1 = _yahoo(tk, "60m", "1mo")
        m5 = _yahoo(tk, "5m", "1d")
        if len(h1) < 30:
            continue
        last_t, price = (m5[-1][0], m5[-1][4]) if m5 else (h1[-1][0], h1[-1][4])
        trs = [max(h1[i][2], h1[i - 1][4]) - min(h1[i][3], h1[i - 1][4]) for i in range(1, len(h1))]
        atr_h = sum(trs[-14:]) / 14
        days = {}
        for t, o, h, l, c in h1:
            days.setdefault(dt.datetime.fromtimestamp(t, dt.timezone.utc).date(), []).append((h, l))
        dr = [max(x[0] for x in v) - min(x[1] for x in v) for v in list(days.values())[-15:-1]]

        def chg(hours):
            t0 = last_t - hours * 3600
            past = [b for b in h1 if b[0] <= t0]
            return (price / past[-1][4] - 1) * 100 if past else None
        out[sym] = dict(price=price, age_min=(now() - last_t) / 60, atr_1h=atr_h,
                        day_range=sum(dr) / len(dr) if dr else atr_h * 5,
                        chg_1h=chg(1), chg_24h=chg(24), chg_5d=chg(120),
                        hi_5d=max(b[2] for b in h1[-120:]), lo_5d=min(b[3] for b in h1[-120:]))
    return out


def macro_prices(syms):
    if FAKE:
        import agents_fake
        return agents_fake.macro_prices(syms)
    out = {}
    for s in syms:
        b = _yahoo(MACRO[s], "1m", "1d")
        if b:
            out[s] = (b[-1][4], b[-1][2], b[-1][3])   # last, high, low of the last minute
    return out


# ------------------------------------------------------------------ state
def load_state():
    p = f"{DIR}/state.json"
    if os.path.exists(p):
        return json.load(open(p))
    return {"desks": {d: {"cash": CFG["start_cash"], "open": []} for d in ("team", "control")},
            "next_id": 1, "runs": 0, "created": iso()}


def save_state(st):
    os.makedirs(DIR, exist_ok=True)
    json.dump(st, open(f"{DIR}/state.json", "w"), indent=1)


TRADE_COLS = ["id", "desk", "market", "symbol", "mint", "side", "opened", "closed", "entry", "exit", "stop",
              "target", "size", "reason_exit", "pnl_normal", "pnl_pessimistic", "thesis"]


def closed_trades():
    p = f"{DIR}/trades.csv"
    if not os.path.exists(p):
        return []
    return list(csv.DictReader(open(p)))


def write_trade(t):
    os.makedirs(DIR, exist_ok=True)
    p = f"{DIR}/trades.csv"
    new = not os.path.exists(p)
    with open(p, "a", newline="") as f:
        w = csv.DictWriter(f, fieldnames=TRADE_COLS)
        if new:
            w.writeheader()
        w.writerow({k: t.get(k, "") for k in TRADE_COLS})


def record_summary(trades):
    out = {}
    for desk in ("team", "control"):
        tt = [t for t in trades if t["desk"] == desk]
        for mk in ("meme", "macro", "all"):
            x = [t for t in tt if mk == "all" or t["market"] == mk]
            pn = [float(t["pnl_normal"]) for t in x]
            pp = [float(t["pnl_pessimistic"]) for t in x]
            out[f"{desk}_{mk}"] = dict(n=len(x), win=round(100 * sum(p > 0 for p in pn) / len(x)) if x else 0,
                                       pnl_normal=round(sum(pn), 2), pnl_pess=round(sum(pp), 2))
    return out


# ------------------------------------------------------------------ Claude
LAST_USAGE = {}


def ask(system, user, max_tokens=500):
    """Claude call that also returns token usage (for the team's budget)."""
    LAST_USAGE.clear()
    text = claude(system, user, MODEL, max_tokens)
    if FAKE:
        LAST_USAGE.update(input_tokens=len(system + user) // 4, output_tokens=len(text) // 4)
    return text, dict(LAST_USAGE)


def claude(system, user, model, max_tokens=900):
    if FAKE:
        import agents_fake
        return agents_fake.claude(system, user)
    body = json.dumps({"model": model, "max_tokens": max_tokens, "system": system,
                       "messages": [{"role": "user", "content": user}]}).encode()
    req = urllib.request.Request("https://api.anthropic.com/v1/messages", data=body, headers={
        "x-api-key": API_KEY, "anthropic-version": "2023-06-01", "content-type": "application/json"})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=90) as r:
                d = json.loads(r.read().decode())
            LAST_USAGE.clear()
            LAST_USAGE.update(d.get("usage", {}))
            LAST_USAGE["stop_reason"] = d.get("stop_reason")
            return "".join(b.get("text", "") for b in d.get("content", []))
        except urllib.error.HTTPError as e:
            try:
                detail = json.loads(e.read().decode()).get("error", {}).get("message", "")
            except Exception:
                detail = ""
            err = f"HTTP {e.code}: {detail or e.reason}"
            if e.code in (400, 401, 403, 404):          # account or request problem: retrying will not help
                break
            time.sleep(5 * (attempt + 1))
        except Exception as e:
            err = str(e)
            time.sleep(5 * (attempt + 1))
    return f"(model call failed: {err[:300]})"


DESK = ("You are part of a three-person PAPER trading desk (fake money, results are logged and judged). "
        "Markets: Solana memecoins and gold, EUR/USD, GBP/USD. Judged on profit after costs versus a "
        "rule-based control desk over at least 50 trades. Memecoin costs are 2.5-5% per side and most new "
        "tokens collapse, so only clear setups are worth it. Doing nothing is a valid and often correct choice. "
        "Be concise, specific, and skeptical of hype. Never invent data: use only the numbers provided.")


def fmt_meme(rows):
    keep = ["symbol", "mint", "price", "mcap", "liquidity_usd", "vol_m5", "m5_change", "h1_change", "age_minutes",
            "holders", "top10_pct", "insider_pct"]
    out = []
    for r in rows[:8]:
        out.append({k: (round(r[k], 4) if isinstance(r.get(k), float) else r.get(k)) for k in keep})
    return json.dumps(out)


def fmt_macro(m):
    return json.dumps({k: {kk: (round(vv, 5) if isinstance(vv, float) else vv) for kk, vv in v.items()} for k, v in m.items()})


ORDER_SPEC = ("{\"orders\": [{\"market\": \"meme\" or \"macro\", \"symbol\": str, \"mint\": str (memecoin only), "
              "\"side\": \"long\" or \"short\" (memecoins long only), \"stop\": price, \"target\": price, "
              "\"max_hours\": number, \"thesis\": short str}]}. Memecoin stops 10-30% below entry, targets 15-150% "
              "above, max 2 hours. Macro stops 0.3-3 atr_1h from price, targets 0.3-6 atr_1h, max 48 hours.")


def _orders(text):
    m = re.search(r"\{.*\}", text, re.S)
    if not m:
        return []
    try:
        return json.loads(m.group(0)).get("orders", []) or []
    except Exception:
        return []


def discuss(meme, macro, st, record):
    """Cheap mode: ONE call where researcher, analyst and sniper debate briefly and the sniper writes orders.
    Only if that produces orders does a SECOND call run: an independent analyst who must approve each order.
    Most cycles end with no trade, so most cycles cost one small call."""
    opn = [{k: p[k] for k in ("symbol", "market", "side", "entry", "stop", "target")} for p in st["desks"]["team"]["open"]]
    data = (f"Time: {iso()}\nOpen team positions: {json.dumps(opn)}\nTrack record: {json.dumps(record)}\n"
            f"Memecoin candidates (tradeable filter passed): {fmt_meme(meme)}\n"
            + (f"Macro snapshot (price, atr_1h, day_range, % changes, 5-day high/low): {fmt_macro(macro)}" if macro else "Macro: not reviewed this cycle."))
    debate = claude(DESK + " Play all three desk roles in one short note: RESEARCHER (at most 2 ideas, key numbers), "
                    "ANALYST (APPROVE, MODIFY or REJECT each, with the reason), SNIPER (final decision). Under 150 words "
                    "of prose, then on the last line JSON only: " + ORDER_SPEC + " Use {\"orders\": []} when nothing is good.",
                    data, MODEL, 450)
    if debate.startswith("(model call failed"):
        return debate, "", "", []
    orders = _orders(debate)
    if not orders:
        return debate, "", "", []
    check = claude(DESK + " Your role: INDEPENDENT ANALYST. Another member of the desk wants to place the orders below. "
                   "Be the skeptic: rug or manipulation risk, chasing a spike, costs, data quality. Keep only orders you "
                   "would bet on. Under 80 words, then on the last line JSON only with the orders you approve, "
                   "unchanged or corrected: " + ORDER_SPEC,
                   data + "\n\nProposed by the desk:\n" + json.dumps(orders), ANALYST_MODEL, 350)
    if check.startswith("(model call failed"):
        return debate, check, "", []                 # no second opinion, no trade
    return debate, check, json.dumps({"orders": _orders(check)}), _orders(check)


# ------------------------------------------------------------------ guardrails and paper broker
def check_order(o, meme, macro, desk):
    if len(desk["open"]) >= CFG["max_open_per_desk"]:
        return None, "desk already has the maximum open positions"
    mk, sym = o.get("market"), str(o.get("symbol", ""))
    if any(p["symbol"] == sym for p in desk["open"]):
        return None, f"{sym} already open"
    try:
        stop, target = float(o["stop"]), float(o["target"])
        hours = float(o.get("max_hours", 1))
    except Exception:
        return None, "stop/target missing or not numbers"
    if mk == "meme":
        c = next((r for r in meme if r["mint"] == o.get("mint") or (not o.get("mint") and r.get("symbol") == sym)), None)
        if not c:
            return None, f"{sym} not in today's tradeable candidate list"
        if c.get("rugged") or c.get("mint_authority") or c.get("freeze_authority"):
            return None, f"{sym} fails basic safety (rugged, mint or freeze authority active)"
        px = c["price"]
        s_lo, s_hi = CFG["meme_stop_range"]
        t_lo, t_hi = CFG["meme_target_range"]
        if not (px * (1 - s_hi) <= stop <= px * (1 - s_lo)):
            return None, f"stop {stop} outside 10-30% below price {px}"
        if not (px * (1 + t_lo) <= target <= px * (1 + t_hi)):
            return None, f"target {target} outside 15-150% above price {px}"
        return dict(market="meme", symbol=c.get("symbol") or sym, mint=c["mint"], side=1, entry_ref=px, stop=stop,
                    target=target, max_hours=min(hours, CFG["meme_max_hours"]), thesis=str(o.get("thesis", ""))[:200]), "ok"
    if mk == "macro":
        sym = sym.upper().replace("/", "").replace("XAUUSD", "GOLD")
        m = macro.get(sym)
        if not m:
            return None, f"{sym} not available"
        if m["age_min"] > 30:
            return None, f"{sym} market closed or data stale"
        side = 1 if str(o.get("side", "long")).lower().startswith("l") else -1
        px, a = m["price"], m["atr_1h"]
        sd, td = (px - stop) * side, (target - px) * side
        if not (CFG["macro_stop_atr"][0] * a <= sd <= CFG["macro_stop_atr"][1] * a):
            return None, f"stop distance {sd:.5f} outside 0.3-3 x atr_1h {a:.5f}"
        if not (CFG["macro_target_atr"][0] * a <= td <= CFG["macro_target_atr"][1] * a):
            return None, f"target distance {td:.5f} outside 0.3-6 x atr_1h {a:.5f}"
        return dict(market="macro", symbol=sym, mint="", side=side, entry_ref=px, stop=stop, target=target,
                    max_hours=min(hours, CFG["macro_max_hours"]), thesis=str(o.get("thesis", ""))[:200]), "ok"
    return None, "unknown market"


def open_pos(st, desk_name, o, price):
    desk = st["desks"][desk_name]
    # keep the planned distances if the live price moved since the plan
    if o["market"] == "macro":
        shift = price - o["entry_ref"]
        o["stop"] += shift
        o["target"] += shift
        size = CFG["macro_risk_usd"] / abs(price - o["stop"])  # ounces or currency units
    else:
        k = price / o["entry_ref"]
        o["stop"] *= k
        o["target"] *= k
        size = CFG["meme_size_usd"] / price                    # tokens
    p = dict(id=st["next_id"], desk=desk_name, market=o["market"], symbol=o["symbol"], mint=o["mint"], side=o["side"],
             opened=now(), entry=price, stop=o["stop"], target=o["target"], size=size,
             deadline=now() + o["max_hours"] * 3600, thesis=o["thesis"])
    st["next_id"] += 1
    desk["open"].append(p)
    return p


def close_pos(st, p, price, why):
    desk = st["desks"][p["desk"]]
    desk["open"] = [q for q in desk["open"] if q["id"] != p["id"]]
    gross = p["side"] * (price - p["entry"]) * p["size"]
    if p["market"] == "meme":
        cn, cp = CFG["meme_cost_per_side"]
        notional = p["entry"] * p["size"] + price * p["size"]
        pn, pp = gross - cn * notional, gross - cp * notional
    else:
        cn, cp = CFG["macro_cost_rt"][p["symbol"]]
        pn, pp = gross - cn * p["size"], gross - cp * p["size"]
    desk["cash"] += pn
    t = dict(p, opened=iso(p["opened"]), closed=iso(), exit=price, reason_exit=why,
             pnl_normal=round(pn, 2), pnl_pessimistic=round(pp, 2), side="long" if p["side"] > 0 else "short")
    write_trade(t)
    return t


def check_exits(st, mp, xp):
    """mp: memecoin prices {mint: price}; xp: macro {sym: (last, high, low)}. Pessimistic: stop first."""
    events = []
    for desk in st["desks"].values():
        for p in list(desk["open"]):
            if p["market"] == "meme":
                px = mp.get(p["mint"])
                if px is None:
                    continue
                hi = lo = px
            else:
                q = xp.get(p["symbol"])
                if not q:
                    continue
                px, hi, lo = q
            s = p["side"]
            hit_stop = p["stop"] is not None and ((lo <= p["stop"]) if s > 0 else (hi >= p["stop"]))
            hit_tgt = p["target"] is not None and ((hi >= p["target"]) if s > 0 else (lo <= p["target"]))
            if hit_stop:
                fill = min(p["stop"], px) if s > 0 else max(p["stop"], px)   # gaps fill at the worse price
                events.append(close_pos(st, p, fill, "stop"))
            elif hit_tgt:
                events.append(close_pos(st, p, p["target"], "target"))
            elif now() >= p["deadline"]:
                events.append(close_pos(st, p, px, "time"))
    return events


# ------------------------------------------------------------------ control desk (fixed rules)
def control_orders(meme, macro, st):
    out = []
    V = CFG["v3"]
    for r in meme:
        ok = (r.get("age_minutes") or 0) >= V["min_age"] and (r.get("holders") or 0) >= V["min_holders"] \
            and r.get("liquidity_usd") and r.get("mcap") and r["liquidity_usd"] / r["mcap"] >= V["min_liq_ratio"] \
            and r.get("top10_pct") is not None and r["top10_pct"] <= V["max_top10"] \
            and r.get("insider_pct") is not None and r["insider_pct"] <= V["max_insiders"] \
            and r.get("mint_authority") is False and r.get("freeze_authority") is False and not r.get("rugged") \
            and r.get("m5_change") is not None and V["m5_min"] <= r["m5_change"] <= V["m5_max"]
        if ok and f"control:{r['mint']}" not in st.get("cool", {}):
            out.append(dict(market="meme", symbol=r.get("symbol"), mint=r["mint"], side="long",
                            stop=r["price"] * 0.8, target=r["price"] * 1.4, max_hours=2, thesis="control: frozen v3 rules"))
            break
    hour = int(now() // 3600)
    rnd = random.Random(hour)
    if macro and st.get("ctrl_macro_hour") != hour and rnd.random() < 0.25:   # about 6 random macro trades a day
        st["ctrl_macro_hour"] = hour
        sym = rnd.choice(sorted(macro))
        m = macro[sym]
        s = rnd.choice((1, -1))
        out.append(dict(market="macro", symbol=sym, side="long" if s > 0 else "short", stop=m["price"] - s * m["atr_1h"],
                        target=m["price"] + s * 1.5 * m["atr_1h"], max_hours=24, thesis="control: random direction"))
    return out


# ------------------------------------------------------------------ report
def write_report(st, record, last):
    L = ["# Agent desk (paper trading)", "",
         f"Updated {iso()}. Runs so far: {st['runs']}. Model: {MODEL}"
         + ("" if API_KEY or FAKE else " (NO API KEY: team desk is idle, add the ANTHROPIC_API_KEY secret)") + ".", "",
         "Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. "
         "Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). "
         "Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.", "",
         "| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |", "|---|---|---|---|---|---|"]
    for desk in ("team", "control"):
        for mk in ("meme", "macro", "all"):
            r = record[f"{desk}_{mk}"]
            L.append(f"| {desk} | {mk} | {r['n']} | {r['win']} | {r['pnl_normal']} | {r['pnl_pess']} |")
    t, c = record["team_all"], record["control_all"]
    if t["n"] >= CFG["eval_min_trades"]:
        good = t["pnl_pess"] > 0 and t["pnl_pess"] > c["pnl_pess"]
        L += ["", f"**Verdict after {t['n']} team trades: {'agents beat control and are positive at pessimistic costs' if good else 'agents have NOT shown an edge'}.**"]
    else:
        L += ["", f"Verdict: too early, {t['n']} of {CFG['eval_min_trades']} team trades needed before judging."]
    L += ["", "## Open positions", ""]
    for d in ("team", "control"):
        for p in st["desks"][d]["open"]:
            f6 = lambda v: "none" if v is None else f"{v:.6g}"
            L.append(f"- {d}: {p['symbol']} {'long' if p['side'] > 0 else 'short'} at {p['entry']:.6g}, stop {f6(p['stop'])}, "
                     f"target {f6(p['target'])}, opened {iso(p['opened'])}")
    if st.get("team"):
        sp = sorted(st.get("spend", {}).items())
        L += ["", "## Team", "", f"API spend today: ${sp[-1][1]:.2f} (cap $3, aiming for about $1.50)" if sp else "API spend today: $0"]
        L += [f"- {x['name']} ({x['role']}, mission {x['mission']}): {x['instructions']}" for x in st["team"]]
    L += ["", "## Last run", "", last]
    os.makedirs(os.path.dirname(REPORT), exist_ok=True)
    open(REPORT, "w").write("\n".join(L) + "\n")


# ------------------------------------------------------------------ main
def basic_safe(r):
    return not r.get("rugged") and r.get("mint_authority") is False and r.get("freeze_authority") is False


def git_sync(msg="agent desk update"):
    if os.environ.get("AGENTS_GIT") != "1":
        return
    import subprocess
    sh = lambda *a: subprocess.run(list(a), capture_output=True, text=True)
    sh("git", "add", DIR, REPORT)
    if sh("git", "diff", "--cached", "--quiet").returncode == 0:
        return
    sh("git", "commit", "-m", msg)
    for _ in range(4):
        # -X theirs: when replaying our commit, our own desk files win any conflict with an older save
        p = sh("git", "pull", "--rebase", "--autostash", "-X", "theirs")
        if p.returncode != 0:
            sh("git", "rebase", "--abort")
            print(f"git pull failed: {(p.stderr or p.stdout)[-300:]}", flush=True)
        else:
            q = sh("git", "push")
            if q.returncode == 0:
                return
            print(f"git push failed: {(q.stderr or q.stdout)[-300:]}", flush=True)
        time.sleep(5)


def flush(st, log):
    if not log:
        return
    text = "\n".join(log) + "\n"
    os.makedirs(f"{DIR}/discussions", exist_ok=True)
    with open(f"{DIR}/discussions/{dt.datetime.now(dt.timezone.utc).date()}.md", "a") as f:
        f.write(text + "\n")
    save_state(st)
    write_report(st, record_summary(closed_trades()), text)
    print(text, flush=True)
    log.clear()


def log_close(log, e, extra=""):
    log.append(f"- {e['desk']}: CLOSED {e['symbol']} ({e['reason_exit']}{extra}) P&L ${e['pnl_normal']} normal, "
               f"${e['pnl_pessimistic']} pessimistic")


def scan(st, log):
    """One cycle: fresh data, the experimental team (when the API key is set), and the rule-based control desk."""
    import team
    meme = meme_data()
    macro = macro_data()
    t = now()
    cool = st.setdefault("cool", {})
    for k in [k for k in cool if cool[k] < t]:
        del cool[k]
    fresh = [r for r in meme if f"seen:{r['mint']}" not in cool][:8]
    for r in fresh:
        cool[f"seen:{r['mint']}"] = t + COOLDOWN_MIN * 60
    if API_KEY or FAKE:
        def live(market, key):
            if market == "meme":
                return meme_prices([key]).get(key)
            q = macro_prices([key]).get(key)
            return q[0] if q else None
        team.cycle(st, meme, fresh, macro, closed_trades(), log, ask, live, close_pos, iso, fake=FAKE)
    for desk_name, ords in (("control", control_orders(meme, macro, st)),):
        for o in ords:
            chk, why = check_order(o, meme, macro, st["desks"][desk_name])
            if not chk:
                log.append(f"- {desk_name}: order {o.get('symbol')} REJECTED by guardrails: {why}")
                continue
            key = f"{desk_name}:{chk['mint'] or chk['symbol']}"
            if key in cool:
                continue                                   # traded this recently, wait out the cooldown
            if chk["market"] == "meme":
                px = meme_prices([chk["mint"]]).get(chk["mint"])
            else:
                q = macro_prices([chk["symbol"]]).get(chk["symbol"])
                px = q[0] if q else None
            if not px:
                log.append(f"- {desk_name}: {chk['symbol']} skipped, no live price")
                continue
            p = open_pos(st, desk_name, chk, px)
            cool[key] = now() + COOLDOWN_MIN * 60
            log.append(f"- {iso()} {desk_name}: OPENED {p['symbol']} {'long' if p['side'] > 0 else 'short'} at {px:.6g} "
                       f"(stop {p['stop']:.6g}, target {p['target']:.6g}) - {p['thesis']}")


def main():
    t0 = now()
    st = load_state()
    st["runs"] += 1
    log = [f"## Run started {iso()}" + ("" if API_KEY or FAKE else " (team desk idle: no ANTHROPIC_API_KEY secret)")]
    import signal

    def stop(signum, frame):                         # GitHub cancel or timeout: save everything first
        log.append(f"## Run stopped {iso()}")
        flush(st, log)
        git_sync("agent desk run (stopped)")
        sys.exit(0)
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    opn = [p for d in st["desks"].values() for p in d["open"]]
    for e in check_exits(st, meme_prices([p["mint"] for p in opn if p["market"] == "meme"]),
                         macro_prices(sorted({p["symbol"] for p in opn if p["market"] == "macro"}))):
        log_close(log, e, ", while away")
    end = t0 + RUN_MINUTES * 60
    next_scan = next_macro = 0.0
    last_sync = now()
    while True:
        t = now()
        if t >= next_scan:
            try:
                scan(st, log)
            except Exception as ex:                       # a bad feed must never stop the desk
                log.append(f"- scan error: {repr(ex)[:200]}")
            next_scan = t + SCAN_SECONDS
            flush(st, log)
        opn = [p for d in st["desks"].values() for p in d["open"]]
        mm = [p["mint"] for p in opn if p["market"] == "meme"]
        xs = sorted({p["symbol"] for p in opn if p["market"] == "macro"}) if now() >= next_macro else []
        if xs:
            next_macro = now() + MACRO_POLL
        try:
            ev = check_exits(st, meme_prices(mm) if mm else {}, macro_prices(xs) if xs else {})
        except Exception as ex:
            ev = []
            log.append(f"- price check error: {repr(ex)[:200]}")
        for e in ev:
            log_close(log, e)
        if ev:
            flush(st, log)
        if now() - last_sync >= GIT_SYNC_MIN * 60:
            git_sync()
            last_sync = now()
        if FAKE or now() >= end:
            break
        time.sleep(MEME_POLL)
    log.append(f"## Run ended {iso()}")
    flush(st, log)
    git_sync("agent desk run")


if __name__ == "__main__":
    main()
