"""Experimental, self-organizing agent team for the PAPER desk (no real money).

No strategy rules. The team decides what to trade, direction, size (up to 10% of the paper account),
whether to use a stop or target, how long to hold, and when to exit, from market data, news, the economic
calendar and its own journal of past hypotheses and results.

Team: agents with a name, role, mission ("meme", "macro" or "all") and instructions. The lead reviews results
once a day (and after a losing streak) and may hire (max 6 agents), fire, or change missions.

Cost control: every cycle is ONE model call per mission group (the group's agents debate inside that call).
Spend is measured from the API's token counts. Hard cap $3 a day; the desk paces itself to about $1.50 a day
and skips quiet cycles when it is ahead of that pace.

What stays fixed (accounting, not strategy): real prices from the data feeds, realistic costs, the paper
account, memecoins long only (they cannot be shorted in practice), and the rule-based control desk.
"""
import datetime as dt
import json
import re
import time
import urllib.request
import xml.etree.ElementTree as ET

PRICE_IN = 0.10 / 1e6            # Claude Haiku 5.5, $ per input token (prompts up to 100k tokens)
PRICE_OUT = 0.50 / 1e6
HARD_CAP = 3.0                   # $ per UTC day
SOFT_PACE = 1.5                  # $ per day the desk aims for
MAX_AGENTS = 6
MAX_SIZE_PCT = 10.0
MAX_OPEN = 8
MACRO_LEVERAGE = 10              # macro notional = size% x account x 10 (retail forex/gold leverage is 20-30x)
REVIEW_HOURS = 24
LOSING_STREAK_REVIEW = 5
NEWS_EVERY_MIN = 15
MEME_IDLE_REVIEW_MIN = 15        # with nothing new, the memecoin group still looks every 15 min if it holds positions
MACRO_REVIEW_MIN = 20

FEEDS = {
    "crypto": ["https://www.coindesk.com/arc/outboundfeeds/rss/", "https://cointelegraph.com/rss"],
    "macro": ["https://www.fxstreet.com/rss/news"],
}
CALENDAR = "https://nfs.faireconomy.media/ff_calendar_thisweek.json"

DEFAULT_TEAM = [
    dict(name="Lead", role="team lead and analyst", mission="all",
         instructions="Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets."),
    dict(name="Scout", role="researcher", mission="all",
         instructions="Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis."),
    dict(name="Sniper", role="execution", mission="all",
         instructions="Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits."),
]

ORDER_FORMAT = ('Reply with a short discussion (under 90 words, plain text), then on the LAST line JSON only: '
                '{"orders": [{"market": "meme" or "macro", "symbol": str, "mint": str (memecoin only), '
                '"side": "long" or "short", "size_pct": number 0.5-10, "stop": price or null, "target": price or null, '
                '"max_hours": number, "by": agent name, "hypothesis": short testable reason}], '
                '"close": [ids of open positions to exit now], "note": one line for the journal, including any plan or watch list for next time}. '
                'Use empty lists when you do nothing.')


# ------------------------------------------------------------------ news and calendar
def _get(url, timeout=15):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (paper trading research)"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()


def headlines(kind, limit=10):
    out = []
    for url in FEEDS[kind]:
        try:
            root = ET.fromstring(_get(url))
        except Exception:
            continue
        for it in root.iter("item"):
            t = (it.findtext("title") or "").strip()
            pd = (it.findtext("pubDate") or "").strip()
            if t:
                out.append((pd, t))
    seen, res = set(), []
    for pd, t in out:
        k = t.lower()[:60]
        if k in seen:
            continue
        seen.add(k)
        try:
            age = (dt.datetime.now(dt.timezone.utc) - dt.datetime.strptime(pd[:25].strip(), "%a, %d %b %Y %H:%M:%S")
                   .replace(tzinfo=dt.timezone.utc)).total_seconds() / 3600
            when = f"{age:.0f}h ago"
        except Exception:
            age, when = 99, ""
        res.append((age, f"{t} ({when})" if when else t))
    res.sort(key=lambda x: x[0])
    return [t for _, t in res[:limit]]


def calendar(hours=24):
    try:
        ev = json.loads(_get(CALENDAR))
    except Exception:
        return []
    nowt = dt.datetime.now(dt.timezone.utc)
    out = []
    for e in ev:
        if e.get("impact") != "High" or e.get("country") not in ("USD", "EUR", "GBP", "All"):
            continue
        try:
            t = dt.datetime.fromisoformat(e["date"])
        except Exception:
            continue
        h = (t - nowt).total_seconds() / 3600
        if -3 <= h <= hours:
            out.append(f"{e['country']} {e['title']} {'in' if h >= 0 else 'was'} {abs(h):.1f}h"
                       + (f", forecast {e['forecast']}" if e.get("forecast") else "")
                       + (f", previous {e['previous']}" if e.get("previous") else ""))
    return out[:8]


def news(st, fake=False):
    t = time.time()
    cache = st.setdefault("news", {})
    if fake or t - cache.get("t", 0) >= NEWS_EVERY_MIN * 60:
        if fake:
            cache.update(t=t, crypto=["Fake: SEC delays ETF decision (1h ago)"], macro=["Fake: Fed speaker hints at cut (2h ago)"],
                         calendar=["USD CPI m/m in 5.0h, forecast 0.3%"])
        else:
            cache.update(t=t, crypto=headlines("crypto"), macro=headlines("macro"), calendar=calendar())
    return cache


# ------------------------------------------------------------------ budget
def spend_today(st):
    day = str(dt.datetime.now(dt.timezone.utc).date())
    sp = st.setdefault("spend", {})
    for k in [k for k in sp if k < day]:
        del sp[k]
    return day, sp.get(day, 0.0)


def add_spend(st, usage):
    day, cur = spend_today(st)
    st["spend"][day] = round(cur + usage.get("input_tokens", 0) * PRICE_IN + usage.get("output_tokens", 0) * PRICE_OUT, 6)


def budget_ok(st, urgent=False):
    """Hard cap always. Soft pace: stay near SOFT_PACE spread over the day, unless something urgent
    (open positions to manage, or fresh memecoins) and we are still under the hard cap."""
    _, cur = spend_today(st)
    if cur >= HARD_CAP:
        return False
    n = dt.datetime.now(dt.timezone.utc)
    frac = (n.hour * 60 + n.minute) / 1440
    pace = SOFT_PACE * frac + 0.10
    return cur <= pace or (urgent and cur <= HARD_CAP * frac + 0.10)


# ------------------------------------------------------------------ prompts
DESK = ("You are part of an EXPERIMENTAL paper trading team (fake money, results logged and judged against a "
        "rule-based control desk). There are no strategy rules: you decide what to trade, size (0.5-10% of the "
        "account), stops, targets, holding time and early exits. Use prices, news, politics, the economic calendar "
        "and your journal. Your goal is to discover a strategy that makes money after costs, so state every trade as "
        "a testable hypothesis and learn from the journal. Costs: memecoins 2.5-5% per side, gold about $0.5-1/oz "
        "round trip, EUR/USD about 0.7-1.2 pips, GBP/USD about 1-1.6 pips. Memecoins can only be bought (long). "
        "Never invent numbers; use only the data given.")


def team_for(st, mission):
    return [a for a in st["team"] if a["mission"] in (mission, "all")]


def journal_text(trades, n=12):
    tt = [t for t in trades if t["desk"] == "team"]
    if not tt:
        return "No closed team trades yet."
    pn = [float(t["pnl_normal"]) for t in tt]
    lines = [f"{len(tt)} closed team trades, total ${sum(pn):.0f} after normal costs, "
             f"{sum(p > 0 for p in pn)} winners."]
    for t in tt[-n:]:
        lines.append(f"- {t['symbol']} {t['side']} {t['reason_exit']} ${float(t['pnl_normal']):.0f}: {t['thesis'][:90]}")
    return "\n".join(lines)


def open_text(st, prices=None):
    def now_px(p):
        try:
            v = prices(p["market"], p["mint"] or p["symbol"]) if prices else None
        except Exception:
            v = None
        return None if v is None else float(f"{v:.6g}")

    def pnl_pct(p, v):
        return None if v is None else round(p["side"] * (v / p["entry"] - 1) * 100, 2)
    rows = []
    for p in st["desks"]["team"]["open"]:
        v = now_px(p)
        rows.append({"id": p["id"], "symbol": p["symbol"], "market": p["market"], "side": "long" if p["side"] > 0 else "short",
                     "entry": float(f"{p['entry']:.6g}"), "price_now": v, "move_pct": pnl_pct(p, v), "stop": p["stop"],
                     "target": p["target"], "hours_left": round((p["deadline"] - time.time()) / 3600, 1),
                     "thesis": p["thesis"][:60]})
    return json.dumps(rows)


def parse_json(text, keys=None):
    """Return the outermost JSON object in the text (the decision line), ignoring prose and stray braces.
    With keys, only objects containing at least one of them count (so a lone order cut from a truncated
    reply is never mistaken for the decision)."""
    dec = json.JSONDecoder()
    best, key = {}, None
    for m in re.finditer(r"\{", text):
        try:
            obj, n = dec.raw_decode(text[m.start():])
        except Exception:
            continue
        k = (m.start() + n, -m.start())          # ends last, and among those starts first = outermost object
        if keys and not any(x in obj for x in keys) if isinstance(obj, dict) else True:
            continue
        if isinstance(obj, dict) and obj and (key is None or k > key):
            best, key = obj, k
    return best


# ------------------------------------------------------------------ order checks (accounting only)
def check(o, meme, macro, st, equity):
    mk = o.get("market")
    sym = str(o.get("symbol", ""))
    if len(st["desks"]["team"]["open"]) >= MAX_OPEN:
        return None, f"already {MAX_OPEN} open positions"
    try:
        size = float(o.get("size_pct", 2))
    except Exception:
        return None, "size_pct not a number"
    size = max(0.5, min(size, MAX_SIZE_PCT))
    stop = o.get("stop")
    target = o.get("target")
    try:
        stop = float(stop) if stop not in (None, "", "null") else None
        target = float(target) if target not in (None, "", "null") else None
        hours = float(o.get("max_hours", 4))
    except Exception:
        return None, "stop/target/max_hours not numbers"
    if mk == "meme":
        c = next((r for r in meme if r["mint"] == o.get("mint") or (not o.get("mint") and r.get("symbol") == sym)), None)
        if not c:
            return None, f"{sym} not in the current memecoin data"
        side, px, hours = 1, c["price"], min(hours, 24)
        sym, mint = c.get("symbol") or sym, c["mint"]
    elif mk == "macro":
        sym = sym.upper().replace("/", "").replace("XAUUSD", "GOLD")
        m = macro.get(sym)
        if not m:
            return None, f"{sym} not available"
        if m["age_min"] > 30:
            return None, f"{sym} market closed or data stale"
        side = 1 if str(o.get("side", "long")).lower().startswith("l") else -1
        px, hours, mint = m["price"], min(hours, 72), ""
    else:
        return None, "unknown market"
    if any(p["symbol"] == sym for p in st["desks"]["team"]["open"]):
        return None, f"{sym} already open"
    if stop is not None and (stop - px) * side >= 0:
        return None, f"stop {stop} is on the wrong side of price {px}"
    if target is not None and (target - px) * side <= 0:
        return None, f"target {target} is on the wrong side of price {px}"
    by = str(o.get("by", "team"))[:20]
    hyp = str(o.get("hypothesis", ""))[:160]
    return dict(market=mk, symbol=sym, mint=mint, side=side, entry_ref=px, stop=stop, target=target,
                max_hours=max(hours, 0.1), size_pct=size, thesis=f"[{by}] {hyp}"), "ok"


def open_team(st, o, price, equity, next_id):
    k = price / o["entry_ref"]
    stop = o["stop"] * k if o["stop"] is not None else None
    target = o["target"] * k if o["target"] is not None else None
    notional = equity * o["size_pct"] / 100 * (MACRO_LEVERAGE if o["market"] == "macro" else 1)
    p = dict(id=next_id, desk="team", market=o["market"], symbol=o["symbol"], mint=o["mint"], side=o["side"],
             opened=time.time(), entry=price, stop=stop, target=target, size=notional / price,
             deadline=time.time() + o["max_hours"] * 3600, thesis=o["thesis"], size_pct=o["size_pct"])
    st["desks"]["team"]["open"].append(p)
    return p


# ------------------------------------------------------------------ the team cycle
def cycle(st, meme, fresh, macro, trades, log, ask, prices, close_pos, iso, fake=False):
    """ask(system, user, max_tokens) -> (text, usage). prices(market, symbol_or_mint) -> live price or None."""
    if "team" not in st:
        st["team"] = [dict(a) for a in DEFAULT_TEAM]
        log.append("- team: experimental team created: " + ", ".join(a["name"] for a in st["team"]))
    t = time.time()
    review(st, trades, log, ask, iso)
    nw = news(st, fake)
    equity = st["desks"]["team"]["cash"]
    missions = sorted({a["mission"] for a in st["team"]} - {"all"}) or ["all"]
    # agents with mission "all" join every group
    groups = ["all"] if missions == ["all"] else missions
    opn = st["desks"]["team"]["open"]
    for g in groups:
        has_meme = g in ("all", "meme")
        has_macro = g in ("all", "macro")
        held = [p for p in opn if (p["market"] == "meme" and has_meme) or (p["market"] == "macro" and has_macro)]
        due_meme = has_meme and (fresh or (held and t - st.get(f"last_meme_{g}", 0) >= MEME_IDLE_REVIEW_MIN * 60))
        due_macro = has_macro and bool(macro) and t - st.get(f"last_macro_{g}", 0) >= MACRO_REVIEW_MIN * 60
        if not (due_meme or due_macro):
            continue
        if not budget_ok(st, urgent=bool(held) or bool(fresh)):
            if st.get("budget_logged") != int(t // 3600):
                log.append(f"- team: pausing to stay on budget (spent ${spend_today(st)[1]:.2f} today)")
                st["budget_logged"] = int(t // 3600)
            return
        members = team_for(st, g)
        roster = "\n".join(f"- {a['name']} ({a['role']}): {a['instructions']}" for a in members)
        data = [f"Time: {iso()}. Paper account cash ${equity:,.0f}.",
                f"Open team positions (price_now is live): {open_text(st, prices)}",
                f"Journal:\n{journal_text(trades)}",
                "Your recent notes (plans, watch lists, hypotheses to test):\n" + ("\n".join(st.get("notes", [])[-8:]) or "none yet")]
        if due_meme:
            from agents import fmt_meme                        # same compact format as the rest of the desk
            data += [f"Memecoins (tradeable filter passed): {fmt_meme(fresh or meme[:6])}",
                     "Crypto news: " + " | ".join(nw.get("crypto", [])[:8])]
        if due_macro:
            from agents import fmt_macro
            data += [f"Gold and forex: {fmt_macro(macro)}",
                     "Macro and political news: " + " | ".join(nw.get("macro", [])[:8]),
                     "Economic calendar (high impact, next 24h): " + (" | ".join(nw.get("calendar", [])) or "none")]
        system = (DESK + f"\nYour team for this mission ({g}):\n{roster}\nDebate briefly in your roles, then decide. "
                  + ORDER_FORMAT)
        text, usage = ask(system, "\n".join(data), 2000)
        add_spend(st, usage)
        if due_meme:
            st[f"last_meme_{g}"] = t
        if due_macro:
            st[f"last_macro_{g}"] = t
        if text.startswith("(model call failed"):
            log.append(f"- team: model call failed: {text[19:-1]}")
            return
        j = parse_json(text, ("orders", "close", "note"))
        if j.get("note"):
            st.setdefault("notes", []).append(f"{iso()} [{g}] {str(j['note'])[:220]}")
            st["notes"] = st["notes"][-20:]
        if not j:
            log.append(f"- team: reply had no decision (stop reason {usage.get('stop_reason')}, {len(text)} chars), skipped")
        log += [f"### {iso()} team {g} ({'memecoins' if due_meme else ''}{' + ' if due_meme and due_macro else ''}"
                f"{'gold/forex' if due_macro else ''}), spent today ${spend_today(st)[1]:.3f}", "", text.strip(), ""]
        for pid in j.get("close", []) or []:
            p = next((q for q in st["desks"]["team"]["open"] if str(q["id"]) == str(pid)), None)
            if not p:
                continue
            px = prices(p["market"], p["mint"] or p["symbol"])
            if px:
                e = close_pos(st, p, px, "agent exit")
                log.append(f"- team: CLOSED {e['symbol']} (agent exit) P&L ${e['pnl_normal']} normal, ${e['pnl_pessimistic']} pessimistic")
        for o in (j.get("orders", []) or [])[:3]:
            chk, why = check(o, meme, macro, st, equity)
            if not chk:
                log.append(f"- team: order {o.get('symbol')} not placed: {why}")
                continue
            px = prices(chk["market"], chk["mint"] or chk["symbol"])
            if not px:
                log.append(f"- team: {chk['symbol']} skipped, no live price")
                continue
            p = open_team(st, chk, px, equity, st["next_id"])
            st["next_id"] += 1
            fmt = lambda v: "none" if v is None else f"{v:.6g}"
            log.append(f"- {iso()} team: OPENED {p['symbol']} {'long' if p['side'] > 0 else 'short'} {p['size_pct']:.1f}% at {px:.6g} "
                       f"(stop {fmt(p['stop'])}, target {fmt(p['target'])}, max {chk['max_hours']:.1f}h) {p['thesis']}")


def review(st, trades, log, ask, iso):
    """Lead reviews the team: hire, fire, change missions. Daily, or after a losing streak."""
    t = time.time()
    tt = [x for x in trades if x["desk"] == "team"]
    streak = 0
    for x in reversed(tt):
        if float(x["pnl_normal"]) < 0:
            streak += 1
        else:
            break
    due = t - st.get("last_review", t) >= REVIEW_HOURS * 3600 or (streak >= LOSING_STREAK_REVIEW and st.get("reviewed_streak_at") != len(tt))
    st.setdefault("last_review", t)
    if not due or not budget_ok(st):
        return
    st["last_review"] = t
    st["reviewed_streak_at"] = len(tt)
    roster = "\n".join(f"- {a['name']} ({a['role']}, mission {a['mission']}): {a['instructions']}" for a in st["team"])
    system = (DESK + " You are the TEAM LEAD running the team's review. You may hire agents (max " + str(MAX_AGENTS)
              + " in total, each costs budget), fire agents whose ideas keep losing, and set missions "
              "(meme, macro or all) to split work. Keep the team small unless more agents clearly help. Reply with "
              "under 120 words, then on the last line JSON only: {\"hire\": [{\"name\": str, \"role\": str, "
              "\"mission\": \"meme\"|\"macro\"|\"all\", \"instructions\": str}], \"fire\": [names], "
              "\"missions\": {name: mission}, \"note\": str}.")
    text, usage = ask(system, f"Team:\n{roster}\n\nJournal:\n{journal_text(trades, 25)}\nLosing streak: {streak}.", 2000)
    add_spend(st, usage)
    if text.startswith("(model call failed"):
        return
    j = parse_json(text, ("hire", "fire", "missions", "note"))
    lead = st["team"][0]["name"]
    for name in j.get("fire", []) or []:
        if name != lead and any(a["name"] == name for a in st["team"]):
            st["team"] = [a for a in st["team"] if a["name"] != name]
            log.append(f"- team: lead FIRED {name}")
    for name, mis in (j.get("missions", {}) or {}).items():
        for a in st["team"]:
            if a["name"] == name and mis in ("meme", "macro", "all"):
                a["mission"] = mis
                log.append(f"- team: {name} now on mission {mis}")
    for h in j.get("hire", []) or []:
        if len(st["team"]) >= MAX_AGENTS:
            log.append(f"- team: hire of {h.get('name')} refused, team already at {MAX_AGENTS}")
            break
        name = str(h.get("name", ""))[:20]
        if not name or any(a["name"] == name for a in st["team"]):
            continue
        mis = h.get("mission") if h.get("mission") in ("meme", "macro", "all") else "all"
        st["team"].append(dict(name=name, role=str(h.get("role", ""))[:60], mission=mis,
                               instructions=str(h.get("instructions", ""))[:300]))
        log.append(f"- team: lead HIRED {name} ({h.get('role')}, mission {mis})")
    log += [f"### {iso()} team review", "", text.strip(), ""]
