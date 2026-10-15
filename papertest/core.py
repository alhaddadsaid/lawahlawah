"""Decision logic shared by the live run and the replay backtester.

Given one poll of prices (snaps) at loop index n and time now, Strategist.step
manages open paper positions and opens new ones for every strategy. It does no
network or file work itself: rugcheck data comes from get_rc(mint, n) and all
output goes through callbacks, so live and replay produce identical decisions.
"""

from . import engine


def ratio(f):
    try:
        return f["liquidity_usd"] / f["mcap"] if f.get("mcap") else None
    except (TypeError, KeyError):
        return None


class Strategist:
    def __init__(self, cfg, get_rc, on_trade=None, on_decision=None, on_event=None):
        self.cfg = cfg
        self.get_rc = get_rc
        self.on_trade = on_trade or (lambda *a: None)
        self.on_decision = on_decision or (lambda *a: None)
        self.on_event = on_event or (lambda *a: None)
        self.open = {s: {} for s in cfg["strategies"]}
        self.cooldown = {}
        self.missing_since = {}
        self.last = {}
        self.n_closed = {s: 0 for s in cfg["strategies"]}
        self.trades = []          # closed positions, in order

    def held(self):
        return {m for book in self.open.values() for m in book}

    def _close(self, strat, pos, now):
        self.n_closed[strat] += 1
        if pos.entry_price is not None:
            self.trades.append(pos)
            self.on_trade(strat, pos)
        self.cooldown[(strat, pos.mint)] = now + self.cfg["reentry_cooldown_minutes"] * 60

    def step(self, n, now, snaps, log_decisions=False):
        cfg = self.cfg
        for m, s in snaps.items():
            self.last[m] = s

        # 1) manage open positions
        for strat, book in self.open.items():
            for m in list(book):
                pos = book[m]
                s = snaps.get(m)
                if s is None:
                    self.missing_since.setdefault(m, now)
                    if now - self.missing_since[m] > 300:
                        engine.force_close(pos, self.last.get(m, {}).get("price"), now, "data_lost")
                else:
                    self.missing_since.pop(m, None)
                    was_pending = pos.is_pending
                    new = engine.on_tick(pos, s["price"], s["t"], cfg["exits"])
                    if was_pending and not pos.is_pending:
                        self.on_event("BUY", strat, pos, s)
                    for fill in new:
                        self.on_event("SELL", strat, pos, fill)
                if not pos.is_open:
                    self._close(strat, pos, now)
                    del book[m]

        # market mood: share of tradeable tokens up over the last hour
        ups = [s["h1_change"] > 0 for s in snaps.values()
               if s.get("h1_change") is not None and engine.check_tradeable(cfg["tradeable"], s)[0]]
        breadth = sum(ups) / len(ups) if len(ups) >= 5 else None

        # 2) new entries
        for strat, rules in cfg["strategies"].items():
            book = self.open[strat]
            for m, s0 in snaps.items():
                s = {**s0, "breadth_1h": breadth}
                if m in book or len(book) >= cfg["max_open_per_strategy"]:
                    continue
                if self.cooldown.get((strat, m), 0) > now:
                    continue
                ok, reason = engine.check_tradeable(cfg["tradeable"], s)
                if ok:
                    ok, reason = engine.check_entry({**rules, "safety_checks": False}, s, [])
                f = s
                if ok and rules.get("safety_checks"):
                    f = {**s, **(self.get_rc(m, n) or {})}
                    ok, reason = engine.check_entry(rules, f, cfg["name_blocklist"])
                if log_decisions or ok:
                    self.on_decision(now, strat, m, f, ok, reason)
                if ok:
                    pos = engine.Position(strat, m, s.get("symbol"), s["t"], s["price"])
                    pos.entry_features = {**f, "liq_ratio": ratio(f)}
                    book[m] = pos
                    self.on_event("SIGNAL", strat, pos, f)

    def finish(self, now):
        for strat, book in self.open.items():
            for m, pos in list(book.items()):
                engine.force_close(pos, self.last.get(m, {}).get("price"), now, "run_end")
                self._close(strat, pos, now)
            book.clear()
