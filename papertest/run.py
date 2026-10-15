"""Main loop: discover tokens, poll prices, run all strategies as paper trades.

Usage:
    python -m papertest.run                 # live, public APIs
    python -m papertest.run --fake          # offline simulation (for testing)
"""

import argparse
import csv
import datetime as dt
import gzip
import json
import os
import shutil
import time

from . import engine

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


class Runner:
    def __init__(self, cfg, src, out_dir, clock=time.time, sleep=time.sleep):
        self.cfg, self.src, self.out = cfg, src, out_dir
        self.clock, self.sleep = clock, sleep
        self.watch = {}          # mint -> last time seen in discovery
        self.rc = {}             # mint -> (time, rugcheck dict)
        self.last = {}           # mint -> last snapshot
        self.missing_since = {}  # mint -> time first missing while in a position
        self.open = {s: {} for s in cfg["strategies"]}
        self.cooldown = {}       # (strategy, mint) -> time allowed again
        self.n_closed = {s: 0 for s in cfg["strategies"]}
        os.makedirs(out_dir, exist_ok=True)
        self.f_ticks = open(os.path.join(out_dir, "ticks.csv"), "w", newline="")
        self.f_dec = open(os.path.join(out_dir, "decisions.csv"), "w", newline="")
        self.f_trades = open(os.path.join(out_dir, "trades.csv"), "w", newline="")
        self.w_ticks = csv.writer(self.f_ticks)
        self.w_dec = csv.writer(self.f_dec)
        self.w_trades = csv.writer(self.f_trades)
        self.w_ticks.writerow(["t", "mint", "symbol", "price", "liquidity_usd", "mcap", "m5_change"])
        self.w_dec.writerow(["t", "strategy", "mint", "symbol", "decision", "reason",
                             "age_min", "m5", "mcap", "liq_ratio", "holders", "top10", "insiders"])
        costs = cfg["costs_per_side"]
        self.w_trades.writerow(
            ["strategy", "mint", "symbol", "signal_t", "entry_t", "exit_t", "hold_min",
             "entry_price", "exit_reasons", "gross_ret"]
            + [f"net_ret_cost{int(c * 1000) / 10}pct" for c in costs]
            + ["max_gain", "max_drawdown", "age_min", "mcap", "liq_ratio", "holders", "top10", "insiders"])

    # -------------------------------------------------------------- helpers
    def features(self, mint, snap, with_rc):
        f = dict(snap)
        if with_rc:
            f.update(self.rugcheck(mint))
        return f

    def rugcheck(self, mint):
        now = self.clock()
        hit = self.rc.get(mint)
        if hit and now - hit[0] < self.cfg["rugcheck_refresh_minutes"] * 60:
            return hit[1]
        if self._rc_budget <= 0:
            return hit[1] if hit else {}
        self._rc_budget -= 1
        data = self.src.rugcheck(mint)
        self.rc[mint] = (now, data)
        return data

    def close_trade(self, strategy, pos):
        self.n_closed[strategy] += 1
        hold = (pos.fills[-1][3] - pos.entry_time) / 60 if pos.fills and pos.entry_time else 0
        ef = pos.entry_features
        row = [strategy, pos.mint, pos.symbol, round(pos.signal_time), round(pos.entry_time or 0),
               round(pos.fills[-1][3]) if pos.fills else "", round(hold, 2), pos.entry_price,
               "+".join(r for _, _, r, _ in pos.fills), _r(engine.net_return(pos, 0.0))]
        row += [_r(engine.net_return(pos, c)) for c in self.cfg["costs_per_side"]]
        row += [_r(pos.peak / pos.entry_price - 1) if pos.entry_price else "",
                _r(pos.trough / pos.entry_price - 1) if pos.entry_price else "",
                _r(ef.get("age_minutes")), _r(ef.get("mcap")), _r(ef.get("liq_ratio")),
                ef.get("holders"), _r(ef.get("top10_pct")), _r(ef.get("insider_pct"))]
        if pos.entry_price is not None:
            self.w_trades.writerow(row)
            self.f_trades.flush()
        self.cooldown[(strategy, pos.mint)] = self.clock() + self.cfg["reentry_cooldown_minutes"] * 60

    # ------------------------------------------------------------------ loop
    def run(self, minutes):
        cfg = self.cfg
        start = self.clock()
        end = start + minutes * 60
        next_disc = start
        next_log_dec = start
        while self.clock() < end:
            loop_t = self.clock()
            self._rc_budget = 3

            if loop_t >= next_disc:
                for m in self.src.discover():
                    self.watch[m] = loop_t
                # keep watchlist bounded: drop the stalest tokens not in a position
                held = {m for s in self.open.values() for m in s}
                if len(self.watch) > cfg["max_watchlist"]:
                    stale = sorted((t, m) for m, t in self.watch.items() if m not in held)
                    for _, m in stale[: len(self.watch) - cfg["max_watchlist"]]:
                        del self.watch[m]
                next_disc = loop_t + cfg["discovery_seconds"]

            held = {m for s in self.open.values() for m in s}
            snaps = self.src.poll_prices(set(self.watch) | held)
            now = self.clock()

            for m, s in snaps.items():
                self.last[m] = s
                self.w_ticks.writerow([round(s["t"], 1), m, s.get("symbol"), s["price"],
                                       _r(s.get("liquidity_usd")), _r(s.get("mcap")), s.get("m5_change")])

            # 1) manage open positions
            for strat, book in self.open.items():
                for m in list(book):
                    pos = book[m]
                    s = snaps.get(m)
                    if s is None:
                        self.missing_since.setdefault(m, now)
                        if now - self.missing_since[m] > 300:
                            lp = self.last.get(m, {}).get("price")
                            engine.force_close(pos, lp, now, "data_lost")
                    else:
                        self.missing_since.pop(m, None)
                        engine.on_tick(pos, s["price"], s["t"], cfg["exits"])
                    if not pos.is_open:
                        self.close_trade(strat, pos)
                        del book[m]

            # 2) look for new entries
            log_dec = now >= next_log_dec
            for strat, rules in cfg["strategies"].items():
                book = self.open[strat]
                for m, s in snaps.items():
                    if m in book or len(book) >= cfg["max_open_per_strategy"]:
                        continue
                    if self.cooldown.get((strat, m), 0) > now:
                        continue
                    # cheap checks first so RugCheck is only called when useful
                    ok, reason = engine.check_entry({**rules, "safety_checks": False}, s, [])
                    f = s
                    if ok and rules.get("safety_checks"):
                        f = self.features(m, s, True)
                        ok, reason = engine.check_entry(rules, f, cfg["name_blocklist"])
                    if log_dec or ok:
                        self._log_decision(now, strat, m, f, ok, reason)
                    if ok:
                        pos = engine.Position(strat, m, s.get("symbol"), s["t"], s["price"])
                        pos.entry_features = {**f, "liq_ratio": _ratio(f)}
                        book[m] = pos
            if log_dec:
                next_log_dec = now + cfg["discovery_seconds"]
                self.f_dec.flush()
                self.f_ticks.flush()

            spent = self.clock() - loop_t
            self.sleep(max(0.0, cfg["price_poll_seconds"] - spent))

        # end of run: close everything at last known price
        now = self.clock()
        for strat, book in self.open.items():
            for m, pos in list(book.items()):
                engine.force_close(pos, self.last.get(m, {}).get("price"), now, "run_end")
                self.close_trade(strat, pos)
            book.clear()
        for f in (self.f_ticks, self.f_dec, self.f_trades):
            f.close()

    def _log_decision(self, t, strat, m, f, ok, reason):
        self.w_dec.writerow([round(t), strat, m, f.get("symbol"), "ENTER" if ok else "skip", reason,
                             _r(f.get("age_minutes")), f.get("m5_change"), _r(f.get("mcap")),
                             _r(_ratio(f)), f.get("holders"), _r(f.get("top10_pct")),
                             _r(f.get("insider_pct"))])


def _ratio(f):
    try:
        return f["liquidity_usd"] / f["mcap"] if f.get("mcap") else None
    except (TypeError, KeyError):
        return None


def _r(x, n=4):
    if x is None:
        return ""
    return round(x, n) if isinstance(x, float) else x


def gzip_file(path):
    if os.path.exists(path) and os.path.getsize(path) > 0:
        with open(path, "rb") as fi, gzip.open(path + ".gz", "wb") as fo:
            shutil.copyfileobj(fi, fo)
        os.remove(path)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fake", action="store_true", help="offline simulation")
    ap.add_argument("--minutes", type=float, help="override run length")
    ap.add_argument("--out", help="output folder")
    args = ap.parse_args()

    with open(os.path.join(ROOT, "config.json")) as fh:
        cfg = json.load(fh)

    now = dt.datetime.now(dt.timezone.utc)
    end_date = dt.datetime.fromisoformat(cfg["end_date_utc"].replace("Z", "+00:00"))
    if now >= end_date and not args.fake:
        print(f"Test round ended on {end_date}. Nothing to do.")
        return

    run_id = now.strftime("%Y%m%d-%H%M")
    out = args.out or os.path.join(ROOT, "results", cfg["test_round"], run_id)
    minutes = args.minutes or cfg["run_minutes"]

    if args.fake:
        from . import fake
        src = fake.FakeMarket(seed=7)
        r = Runner(cfg, src, out, clock=src.clock, sleep=src.sleep)
    else:
        from . import sources
        r = Runner(cfg, sources, out)

    print(f"Run {run_id}: {minutes} minutes, writing to {out}")
    r.run(minutes)
    gzip_file(os.path.join(out, "ticks.csv"))
    meta = {"run_id": run_id, "test_round": cfg["test_round"], "minutes": minutes,
            "fake": args.fake, "closed_trades": r.n_closed,
            "finished_utc": dt.datetime.now(dt.timezone.utc).isoformat()}
    with open(os.path.join(out, "meta.json"), "w") as fh:
        json.dump(meta, fh, indent=2)
    print(json.dumps(meta, indent=2))


if __name__ == "__main__":
    main()
