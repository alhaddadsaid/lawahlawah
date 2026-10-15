"""Daily research: replay all saved data with a fixed list of rule variants and
decide, by the pre-registered rules in RESEARCH_RULES.md, whether any variant
should replace the current champion (the "v3" strategy in config.json).

    python3 research.py            # writes reports/latest.md and reports/<date>.md

The script only reports. Applying a switch is done by editing config.json,
bumping test_round and recording it in research_state.json (see the rules).
"""

import copy
import datetime as dt
import json
import os
import random
import statistics
import sys

from papertest import backtest, engine

ROOT = os.path.dirname(os.path.abspath(__file__))
COST = 0.05            # judge at the pessimistic cost level
RULES = {
    "validation_share": 0.30,
    "min_val_trades": 30,
    "min_margin": 0.02,
    "min_boot_prob": 0.90,
    "min_days_between_switches": 7,
    "boot_samples": 2000,
    "stop_after_trades": 150,
    "final_min_trades": 50,
    "final_min_tokens": 30,
}

# Pre-registered variants: each changes ONE thing from the champion.
VARIANTS = {
    "stop_15":        {"exits": {"stop_loss": 0.15}},
    "stop_25":        {"exits": {"stop_loss": 0.25}},
    "take_half_20":   {"exits": {"take_half_at": 0.20}},
    "take_half_50":   {"exits": {"take_half_at": 0.50}},
    "trail_15":       {"exits": {"trail_from_peak": 0.15}},
    "trail_30":       {"exits": {"trail_from_peak": 0.30}},
    "time_stop_5":    {"exits": {"time_stop_minutes": 5}},
    "time_stop_20":   {"exits": {"time_stop_minutes": 20}},
    "max_hold_60":    {"exits": {"max_hold_minutes": 60}},
    "holders_2000":   {"rules": {"min_holders": 2000}},
    "holders_3000":   {"rules": {"min_holders": 3000}},
    "pullback_-10_5": {"rules": {"pullback_m5_min": -10, "pullback_m5_max": 5}},
    "pullback_-30_0": {"rules": {"pullback_m5_min": -30, "pullback_m5_max": 0}},
    "age_60":         {"rules": {"min_age_minutes": 60}},
    "liq_tiered_10":  {"rules": {"min_liq_ratio_above_200k": 0.10}},
    "top10_20":       {"rules": {"max_top10": 0.20}},
    # added 2026-10-15 from the padre recorder session, before any round-2 results existed
    "market_up_1h_50": {"rules": {"min_breadth_1h": 0.50}},
    "momentum_5_30":  {"rules": {"pullback_m5_min": 5, "pullback_m5_max": 30}},
}


def build_cfg(base, patch):
    cfg = copy.deepcopy(base)
    rules = copy.deepcopy(base["strategies"]["v3"])
    rules.update(patch.get("rules", {}))
    cfg["strategies"] = {"x": rules}
    cfg["exits"].update(patch.get("exits", {}))
    cfg["tradeable"].update(patch.get("tradeable", {}))
    return cfg


def trade_record(pos, run_name):
    return {"run": run_name, "mint": pos.mint, "symbol": pos.symbol, "entry_t": pos.entry_time,
            "ret": engine.net_return(pos, COST), "ret_low": engine.net_return(pos, 0.025)}


def mean(xs):
    return statistics.mean(xs) if xs else None


def boot_prob(a, b, n, rng):
    """P(mean(a) > mean(b)) by resampling each list independently."""
    if not a or not b:
        return 0.0
    wins = 0
    for _ in range(n):
        ma = sum(rng.choice(a) for _ in a) / len(a)
        mb = sum(rng.choice(b) for _ in b) / len(b)
        wins += ma > mb
    return wins / n


def without_best_token(trades):
    by = {}
    for t in trades:
        by[t["mint"]] = by.get(t["mint"], 0) + t["ret"]
    if not by:
        return 0.0, None
    best = max(by, key=by.get)
    return sum(by.values()) - by[best], next(t["symbol"] for t in trades if t["mint"] == best)


def summarize(trades):
    rets = [t["ret"] for t in trades]
    if not rets:
        return {"trades": 0}
    rest, best = without_best_token(trades)
    return {"trades": len(rets), "tokens": len({t["mint"] for t in trades}),
            "win_rate": sum(r > 0 for r in rets) / len(rets), "mean": mean(rets),
            "mean_low_cost": mean([t["ret_low"] for t in trades]), "worst": min(rets),
            "sum_without_best_token": rest, "best_token": best}


def fmt(s):
    if not s or not s.get("trades"):
        return "no trades"
    return (f"{s['trades']} trades / {s['tokens']} tokens, win {s['win_rate']:.0%}, "
            f"avg {s['mean']:+.1%} at 5% costs ({s['mean_low_cost']:+.1%} at 2.5%), worst {s['worst']:+.1%}")


def main():
    with open(os.path.join(ROOT, "config.json")) as fh:
        base = json.load(fh)
    state_path = os.path.join(ROOT, "research_state.json")
    state = json.load(open(state_path)) if os.path.exists(state_path) else {"last_switch_utc": None, "history": []}
    rng = random.Random(42)

    # all replayable runs, from every round (market data does not depend on the rules)
    runs = []
    res_root = os.path.join(ROOT, "results")
    for rnd in sorted(os.listdir(res_root)) if os.path.isdir(res_root) else []:
        for d in backtest.find_runs(res_root, rnd):
            if os.path.exists(os.path.join(d, "loops.csv")) or os.path.exists(os.path.join(d, "loops.csv.gz")):
                runs.append(d)
    runs.sort(key=lambda d: os.path.basename(d))

    configs = {"champion": build_cfg(base, {})}
    configs["baseline"] = copy.deepcopy(base)
    configs["baseline"]["strategies"] = {"x": base["strategies"]["baseline"]}
    for name, patch in VARIANTS.items():
        configs[name] = build_cfg(base, patch)

    trades = {k: [] for k in configs}
    run_loops = []
    for d in runs:
        run = backtest.load_run(d)
        if not run or not run["loops"]:
            continue
        run_loops.append((d, len(run["loops"])))
        for name, cfg in configs.items():
            core = backtest.replay(cfg, run)
            trades[name] += [trade_record(p, os.path.basename(d)) for p in core.trades]
        del run

    total = sum(n for _, n in run_loops)
    cut, acc, val_runs = total * (1 - RULES["validation_share"]), 0, set()
    for d, n in run_loops:
        if acc >= cut:
            val_runs.add(os.path.basename(d))
        acc += n

    split = {k: ([t for t in v if t["run"] not in val_runs], [t for t in v if t["run"] in val_runs])
             for k, v in trades.items()}
    champ_tr, champ_val = split["champion"]
    train_means = {k: mean([t["ret"] for t in split[k][0]]) for k in VARIANTS}
    ranked = sorted((m, k) for k, m in train_means.items() if m is not None)
    candidate = ranked[-1][1] if ranked else None

    lines = [f"# Research report {dt.datetime.now(dt.timezone.utc):%Y-%m-%d %H:%M} UTC", "",
             f"Replayable runs: {len(run_loops)} ({total} price polls, about {total * 5 / 3600:.1f} hours). "
             f"Validation (unseen) runs: {len(val_runs)}. All results at 5% costs per side unless noted.", ""]
    lines += ["## Champion (current v3 rules)", "",
              f"- All data: {fmt(summarize(trades['champion']))}",
              f"- Train: {fmt(summarize(champ_tr))}", f"- Validation: {fmt(summarize(champ_val))}",
              f"- Control group (no safety filter), all data: {fmt(summarize(trades['baseline']))}", ""]

    decision, reasons = "KEEP", []
    if candidate:
        cand_tr, cand_val = split[candidate]
        cs, vs = summarize(cand_val), summarize(champ_val)
        p = boot_prob([t["ret"] for t in cand_val], [t["ret"] for t in champ_val], RULES["boot_samples"], rng)
        lines += [f"## Best variant on training data: `{candidate}` {json.dumps(VARIANTS[candidate])}", "",
                  f"- Train: {fmt(summarize(cand_tr))}", f"- Validation: {fmt(cs)}",
                  f"- Probability it beats the champion on validation (bootstrap): {p:.0%}", ""]
        checks = [
            ("train mean above champion", (train_means[candidate] or -9) > (mean([t['ret'] for t in champ_tr]) or -9)),
            (f"at least {RULES['min_val_trades']} validation trades each",
             cs.get("trades", 0) >= RULES["min_val_trades"] and vs.get("trades", 0) >= RULES["min_val_trades"]),
            (f"validation mean at least {RULES['min_margin']:.0%} above champion",
             cs.get("trades") and vs.get("trades") and cs["mean"] > vs["mean"] + RULES["min_margin"]),
            ("validation mean positive", cs.get("trades") and cs["mean"] > 0),
            ("profit not from one token", cs.get("trades") and cs["sum_without_best_token"] > 0),
            (f"bootstrap probability at least {RULES['min_boot_prob']:.0%}", p >= RULES["min_boot_prob"]),
        ]
        last = state.get("last_switch_utc")
        days = (dt.datetime.now(dt.timezone.utc) - dt.datetime.fromisoformat(last)).days if last else 999
        checks.append((f"at least {RULES['min_days_between_switches']} days since last switch",
                       days >= RULES["min_days_between_switches"]))
        lines += ["Switch checks:"] + [f"- [{'x' if ok else ' '}] {name}" for name, ok in checks] + [""]
        if all(ok for _, ok in checks):
            decision = f"SWITCH to {candidate}"
        reasons = [name for name, ok in checks if not ok]

    lines += ["## All variants (train mean / validation mean at 5% costs)", "",
              "| variant | train trades | train avg | val trades | val avg |", "|---|---|---|---|---|"]
    for k in ["champion"] + list(VARIANTS):
        tr, va = split[k]
        tm, vm = mean([t["ret"] for t in tr]), mean([t["ret"] for t in va])
        lines.append(f"| {k} | {len(tr)} | {'' if tm is None else f'{tm:+.1%}'} | {len(va)} | "
                     f"{'' if vm is None else f'{vm:+.1%}'} |")
    lines.append("")

    all_c = summarize(trades["champion"])
    base_s = summarize(trades["baseline"])
    final = [
        (f"at least {RULES['final_min_trades']} trades", all_c.get("trades", 0) >= RULES["final_min_trades"]),
        (f"at least {RULES['final_min_tokens']} tokens", all_c.get("tokens", 0) >= RULES["final_min_tokens"]),
        ("average positive at 5% costs", all_c.get("trades") and all_c["mean"] > 0),
        ("profit not from one token", all_c.get("trades") and all_c["sum_without_best_token"] > 0),
        ("beats the control group", all_c.get("trades") and base_s.get("trades") and all_c["mean"] > base_s["mean"]),
        ("validation also positive", vs.get("trades") and vs["mean"] > 0 if candidate else False),
    ]
    lines += ["## Final bar for the champion (all must pass before any real money)", ""]
    lines += [f"- [{'x' if ok else ' '}] {name}" for name, ok in final] + [""]
    stop = (all_c.get("trades", 0) >= RULES["stop_after_trades"] and
            all((mean([t["ret"] for t in split[k][1]]) or -1) < 0 for k in ["champion"] + list(VARIANTS)))
    if stop:
        decision = "STOP: no version is positive on unseen data after enough trades"
    elif all(ok for _, ok in final):
        decision += " (champion passes the final bar)"

    lines = [f"**Decision: {decision}**", ""] + ([f"Not switching because: {', '.join(reasons)}.", ""] if reasons and decision.startswith("KEEP") else []) + lines
    os.makedirs(os.path.join(ROOT, "reports"), exist_ok=True)
    text = "\n".join(lines) + "\n"
    for name in ("latest.md", f"{dt.datetime.now(dt.timezone.utc):%Y-%m-%d}.md"):
        with open(os.path.join(ROOT, "reports", name), "w") as fh:
            fh.write(text)
    print(text)


if __name__ == "__main__":
    sys.exit(main())
