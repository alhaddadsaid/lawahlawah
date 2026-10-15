"""Live paper-trading run: discover tokens, poll prices, apply all strategies.

Usage:
    python -m papertest.run                 # live, public APIs
    python -m papertest.run --fake          # offline simulation (for testing)

Everything needed to replay the run exactly is saved:
  ticks.csv(.gz)  every price snapshot, with loop index n and loop time
  rugcheck.csv    every holder/safety snapshot, with the loop index it was fetched in
  tokens.csv      symbol and name of each token
  trades.csv, decisions.csv, meta.json
"""

import argparse
import csv
import datetime as dt
import gzip
import json
import os
import shutil
import time
from collections import Counter

from . import engine
from .core import Strategist, ratio

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

TICK_COLS = ["n", "now", "t", "mint", "price", "liquidity_usd", "mcap", "m5_change", "h1_change", "vol_m5",
             "age_minutes"]
RC_COLS = ["n", "t", "mint", "holders", "top10_pct", "insider_pct", "mint_authority",
           "freeze_authority", "rugged", "rc_score"]


def trade_header(cfg):
    return (["strategy", "mint", "symbol", "signal_t", "entry_t", "exit_t", "hold_min",
             "entry_price", "exit_reasons", "gross_ret"]
            + [f"net_ret_cost{int(c * 1000) / 10}pct" for c in cfg["costs_per_side"]]
            + ["max_gain", "max_drawdown", "age_min", "mcap", "liq_ratio", "holders", "top10", "insiders"])


def trade_row(cfg, strat, pos):
    hold = (pos.fills[-1][3] - pos.entry_time) / 60 if pos.fills and pos.entry_time else 0
    ef = pos.entry_features
    row = [strat, pos.mint, pos.symbol, round(pos.signal_time), round(pos.entry_time or 0),
           round(pos.fills[-1][3]) if pos.fills else "", round(hold, 2), pos.entry_price,
           "+".join(r for _, _, r, _ in pos.fills), _r(engine.net_return(pos, 0.0))]
    row += [_r(engine.net_return(pos, c)) for c in cfg["costs_per_side"]]
    row += [_r(pos.peak / pos.entry_price - 1), _r(pos.trough / pos.entry_price - 1),
            _r(ef.get("age_minutes")), _r(ef.get("mcap")), _r(ef.get("liq_ratio")),
            ef.get("holders"), _r(ef.get("top10_pct")), _r(ef.get("insider_pct"))]
    return row


class LiveRunner:
    def __init__(self, cfg, src, out_dir, clock=time.time, sleep=time.sleep, verbose=True):
        self.cfg, self.src, self.out = cfg, src, out_dir
        self.clock, self.sleep, self.verbose = clock, sleep, verbose
        self.watch = {}
        self.rc = {}            # mint -> (time, data)
        self.names = {}
        self.n = 0
        os.makedirs(out_dir, exist_ok=True)
        self.files = {k: open(os.path.join(out_dir, f"{k}.csv"), "w", newline="")
                      for k in ("ticks", "loops", "rugcheck", "tokens", "trades", "decisions")}
        self.w = {k: csv.writer(f) for k, f in self.files.items()}
        self.w["ticks"].writerow(TICK_COLS)
        self.w["loops"].writerow(["n", "now"])
        self.w["rugcheck"].writerow(RC_COLS)
        self.w["tokens"].writerow(["mint", "symbol", "name"])
        self.w["trades"].writerow(trade_header(cfg))
        self.w["decisions"].writerow(["t", "strategy", "mint", "symbol", "decision", "reason", "age_min",
                                      "m5", "mcap", "liq_ratio", "holders", "top10", "insiders"])
        self.skips = {s: Counter() for s in cfg["strategies"]}
        self.core = Strategist(cfg, self.get_rc, self.on_trade, self.on_decision, self.on_event)

    # ---------------------------------------------------------- rugcheck
    def fetch_rc(self, mint, avail_n):
        """avail_n = first loop index whose decisions may use this snapshot."""
        data = self.src.rugcheck(mint) or {}
        self.rc[mint] = (self.clock(), data)
        self.w["rugcheck"].writerow([avail_n, repr(self.clock()), mint] + [_f(data.get(k)) for k in RC_COLS[3:]])
        return data

    def get_rc(self, mint, n):
        hit = self.rc.get(mint)
        if hit and self.clock() - hit[0] < self.cfg["rugcheck_refresh_minutes"] * 60:
            return hit[1]
        if self.rc_budget <= 0:
            return hit[1] if hit else {}
        self.rc_budget -= 1
        return self.fetch_rc(mint, n)

    def prefetch_rc(self, snaps):
        """Spend leftover budget refreshing holder data for tradeable tokens,
        so the replay can also test rules this run's strategies did not use."""
        for m, s in snaps.items():
            if self.rc_budget <= 0:
                return
            if not engine.check_tradeable(self.cfg["tradeable"], s)[0]:
                continue
            hit = self.rc.get(m)
            if hit and self.clock() - hit[0] < self.cfg["rugcheck_refresh_minutes"] * 60:
                continue
            self.rc_budget -= 1
            self.fetch_rc(m, self.n + 1)

    # ---------------------------------------------------------- callbacks
    def on_trade(self, strat, pos):
        self.w["trades"].writerow(trade_row(self.cfg, strat, pos))
        self.files["trades"].flush()
        net = engine.net_return(pos, self.cfg["costs_per_side"][0])
        self.say(f"CLOSED {strat:<13} {pos.symbol}  net {net:+.1%} after costs  "
                 f"({'+'.join(r for _, _, r, _ in pos.fills)})")

    def on_decision(self, now, strat, m, f, ok, reason):
        if not ok:
            self.skips[strat][reason] += 1
        self.w["decisions"].writerow([round(now), strat, m, f.get("symbol"), "ENTER" if ok else "skip", reason,
                                      _r(f.get("age_minutes")), f.get("m5_change"), _r(f.get("mcap")),
                                      _r(ratio(f)), f.get("holders"), _r(f.get("top10_pct")),
                                      _r(f.get("insider_pct"))])

    def on_event(self, kind, strat, pos, info):
        if kind == "SIGNAL":
            f = info
            self.say(f"SIGNAL {strat:<13} {pos.symbol}  age {_int(f.get('age_minutes'))} min | "
                     f"5m {_num(f.get('m5_change'))}% | mcap {_k(f.get('mcap'))} | "
                     f"liq {_k(f.get('liquidity_usd'))} ({_pct(ratio(f))}) | vol5m {_k(f.get('vol_m5'))} | "
                     f"holders {f.get('holders', '-')} | top10 {_pct(f.get('top10_pct'))} | "
                     f"insiders {_pct(f.get('insider_pct'))}")
        elif kind == "BUY":
            self.say(f"   BUY  {strat:<13} {pos.symbol}  at mcap {_k(info.get('mcap'))}")
        elif kind == "SELL":
            frac, px, why, _ = info
            self.say(f"   SELL {strat:<13} {pos.symbol}  {int(frac * 100)}% {why}  "
                     f"{px / pos.entry_price - 1:+.1%} vs entry")

    def say(self, msg):
        if self.verbose:
            print(f"{dt.datetime.now(dt.timezone.utc):%H:%M:%S} {msg}", flush=True)

    # ---------------------------------------------------------------- loop
    def run(self, minutes):
        cfg = self.cfg
        start = self.clock()
        end = start + minutes * 60
        next_disc = next_log = next_status = start
        while self.clock() < end:
            loop_t = self.clock()
            self.rc_budget = 3
            if loop_t >= next_disc:
                for m in self.src.discover():
                    self.watch[m] = loop_t
                held = self.core.held()
                if len(self.watch) > cfg["max_watchlist"]:
                    stale = sorted((t, m) for m, t in self.watch.items() if m not in held)
                    for _, m in stale[: len(self.watch) - cfg["max_watchlist"]]:
                        del self.watch[m]
                next_disc = loop_t + cfg["discovery_seconds"]

            snaps = self.src.poll_prices(set(self.watch) | self.core.held())
            now = self.clock()
            for m, s in snaps.items():
                if m not in self.names:
                    self.names[m] = (s.get("symbol"), s.get("name"))
                    self.w["tokens"].writerow([m, s.get("symbol"), s.get("name")])
                self.w["ticks"].writerow([self.n, repr(now), _f(s.get("t")), m]
                                         + [_f(s.get(k)) for k in TICK_COLS[4:]])
            self.w["loops"].writerow([self.n, repr(now)])

            log_dec = now >= next_log
            self.core.step(self.n, now, snaps, log_decisions=log_dec)
            self.prefetch_rc(snaps)
            if log_dec:
                next_log = now + cfg["discovery_seconds"]
                for f in self.files.values():
                    f.flush()
            if now >= next_status and self.verbose:
                next_status = now + 300
                opened = {s: len(b) for s, b in self.core.open.items()}
                print(f"\n[{dt.datetime.now(dt.timezone.utc):%H:%M} UTC] watching {len(self.watch)} tokens | "
                      f"open {opened} | closed {self.core.n_closed}", flush=True)
                for st, c in self.skips.items():
                    print(f"   skipped by {st}: " + ", ".join(f"{k} {v}" for k, v in c.most_common(4)), flush=True)
                self.skips = {st: Counter() for st in cfg["strategies"]}
                print("", flush=True)
            self.n += 1
            self.sleep(max(0.0, cfg["price_poll_seconds"] - (self.clock() - loop_t)))

        self.final_now = self.clock()
        with open(os.path.join(self.out, "end.json"), "w") as fh:
            json.dump({"n": self.n, "now": repr(self.final_now)}, fh)
        self.core.finish(self.final_now)
        for f in self.files.values():
            f.close()


def _f(x):
    if x is None:
        return ""
    return repr(x) if isinstance(x, float) else x


def _k(x):
    if not x:
        return "-"
    return f"{x / 1e6:.2f}M" if x >= 1e6 else f"{x / 1e3:.0f}K"


def _int(x):
    return "-" if x is None else int(x)


def _num(x):
    return "-" if x is None else f"{x:+.1f}"


def _pct(x):
    return "-" if x is None else f"{x:.0%}"


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
    ap.add_argument("--seed", type=int, default=7)
    args = ap.parse_args()

    with open(os.path.join(ROOT, "config.json")) as fh:
        cfg = json.load(fh)

    now = dt.datetime.now(dt.timezone.utc)
    end_date = dt.datetime.fromisoformat(cfg["end_date_utc"].replace("Z", "+00:00"))
    if now >= end_date and not args.fake:
        print(f"Test ended on {end_date}. Nothing to do.")
        return

    run_id = now.strftime("%Y%m%d-%H%M")
    out = args.out or os.path.join(ROOT, "results", cfg["test_round"], run_id)
    minutes = args.minutes or cfg["run_minutes"]

    if args.fake:
        from . import fake
        src = fake.FakeMarket(seed=args.seed)
        r = LiveRunner(cfg, src, out, clock=src.clock, sleep=src.sleep)
    else:
        from . import sources
        found = sources.discover()
        sample = list(found)[:30]
        prices = sources.poll_prices(sample)
        rc = sources.rugcheck(sample[0]) if sample else {}
        print(f"Connection check: discovered {len(found)} tokens, prices for {len(prices)}/{len(sample)}, "
              f"rugcheck holders={rc.get('holders')} top10={rc.get('top10_pct')}", flush=True)
        if not found or not prices:
            print("WARNING: market data not reachable from this runner.", flush=True)
        r = LiveRunner(cfg, sources, out)

    print(f"Run {run_id} ({cfg['test_round']}): {minutes} minutes, writing to {out}", flush=True)
    r.run(minutes)
    gzip_file(os.path.join(out, "ticks.csv"))
    meta = {"run_id": run_id, "test_round": cfg["test_round"], "minutes": minutes,
            "fake": args.fake, "closed_trades": r.core.n_closed,
            "finished_utc": dt.datetime.now(dt.timezone.utc).isoformat()}
    with open(os.path.join(out, "meta.json"), "w") as fh:
        json.dump(meta, fh, indent=2)
    print(json.dumps(meta, indent=2))


if __name__ == "__main__":
    main()
