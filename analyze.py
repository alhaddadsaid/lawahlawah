"""Combine all runs of a test round and print the results per strategy.

    python3 analyze.py                 # uses test_round from config.json
    python3 analyze.py v3-round1
"""

import csv
import glob
import json
import os
import statistics
import sys

ROOT = os.path.dirname(os.path.abspath(__file__))


def load(round_name):
    rows = []
    for path in sorted(glob.glob(os.path.join(ROOT, "results", round_name, "*", "trades.csv"))):
        run = os.path.basename(os.path.dirname(path))
        with open(path) as fh:
            for r in csv.DictReader(fh):
                r["run"] = run
                rows.append(r)
    return rows


def stats(trades, col):
    rets = [float(t[col]) for t in trades if t.get(col) not in ("", None)]
    if not rets:
        return None
    equity, peak, max_dd = 1.0, 1.0, 0.0
    for r in sorted_by_time(trades, col):
        equity *= 1 + r * 0.1          # risking 10% of the bankroll per trade
        peak = max(peak, equity)
        max_dd = min(max_dd, equity / peak - 1)
    by_token = {}
    for t in trades:
        if t.get(col) not in ("", None):
            by_token[t["symbol"] or t["mint"]] = by_token.get(t["symbol"] or t["mint"], 0) + float(t[col])
    total = sum(rets)
    best_token = max(by_token.items(), key=lambda kv: kv[1]) if by_token else (None, 0)
    return {
        "trades": len(rets),
        "tokens": len(by_token),
        "win_rate": sum(r > 0 for r in rets) / len(rets),
        "avg": statistics.mean(rets),
        "median": statistics.median(rets),
        "sum": total,
        "worst": min(rets),
        "best": max(rets),
        "max_drawdown_10pct_sizing": max_dd,
        "best_token": best_token[0],
        "profit_without_best_token": total - best_token[1],
    }


def sorted_by_time(trades, col):
    return [float(t[col]) for t in sorted(trades, key=lambda t: (t["run"], t["entry_t"]))
            if t.get(col) not in ("", None)]


def main():
    cfg = json.load(open(os.path.join(ROOT, "config.json")))
    round_name = sys.argv[1] if len(sys.argv) > 1 else cfg["test_round"]
    rows = load(round_name)
    runs = sorted({r["run"] for r in rows})
    print(f"Round {round_name}: {len(runs)} runs, {len(rows)} closed trades\n")
    cols = [c for c in (rows[0].keys() if rows else []) if c.startswith("net_ret_cost")]
    summary = {}
    for strat in cfg["strategies"]:
        tr = [r for r in rows if r["strategy"] == strat]
        summary[strat] = {c: stats(tr, c) for c in cols}
        print(f"== {strat}")
        for c, s in summary[strat].items():
            if not s:
                print(f"   {c}: no trades")
                continue
            print(f"   {c}: {s['trades']} trades on {s['tokens']} tokens | win {s['win_rate']:.0%} | "
                  f"avg {s['avg']:+.1%} | median {s['median']:+.1%} | worst {s['worst']:+.1%} | "
                  f"drawdown {s['max_drawdown_10pct_sizing']:+.1%} | "
                  f"without best token ({s['best_token']}) {s['profit_without_best_token']:+.2f}")
        print()
    with open(os.path.join(ROOT, "results", round_name, "summary.json"), "w") as fh:
        json.dump(summary, fh, indent=2)


if __name__ == "__main__":
    main()
