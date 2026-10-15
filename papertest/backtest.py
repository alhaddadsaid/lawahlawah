"""Replay saved runs through the same decision logic, with any rule set.

Because live and replay share papertest.core.Strategist, replaying a run with
the rules it ran with reproduces its live trades exactly (tested in
test_engine.ReplayMatchesLive). Replaying with different rules answers
"what would have happened if...".
"""

import csv
import gzip
import json
import os
from collections import defaultdict

from .core import Strategist

FLOAT_COLS = {"now", "t", "price", "liquidity_usd", "mcap", "m5_change", "h1_change", "vol_m5", "age_minutes",
              "top10_pct", "insider_pct", "rc_score"}


def _parse(k, v):
    if v == "" or v is None:
        return None
    if v in ("True", "False"):
        return v == "True"
    if k in FLOAT_COLS:
        return float(v)
    if k in ("n", "holders"):
        return int(float(v))
    return v


def _open(path):
    if os.path.exists(path + ".gz"):
        return gzip.open(path + ".gz", "rt", newline="")
    if os.path.exists(path):
        return open(path, newline="")
    return None


def load_run(run_dir):
    """Return a dict with loops, snaps per loop, rugcheck history, end time.
    Returns None for runs saved before replay logging existed."""
    fl = _open(os.path.join(run_dir, "loops.csv"))
    ft = _open(os.path.join(run_dir, "ticks.csv"))
    if fl is None or ft is None:
        return None
    with fl:
        loops = [(int(r["n"]), float(r["now"])) for r in csv.DictReader(fl)]
    names = {}
    fn = _open(os.path.join(run_dir, "tokens.csv"))
    if fn:
        with fn:
            for r in csv.DictReader(fn):
                names[r["mint"]] = (r["symbol"], r["name"])
    snaps = defaultdict(dict)
    with ft:
        for r in csv.DictReader(ft):
            n, m = int(r["n"]), r["mint"]
            s = {k: _parse(k, v) for k, v in r.items() if k not in ("n", "now", "mint")}
            sym, name = names.get(m, (None, None))
            s["symbol"], s["name"] = sym, name
            snaps[n][m] = s
    rc = defaultdict(list)
    fr = _open(os.path.join(run_dir, "rugcheck.csv"))
    if fr:
        with fr:
            for r in csv.DictReader(fr):
                d = {k: _parse(k, v) for k, v in r.items() if k not in ("n", "t", "mint")}
                rc[r["mint"]].append((int(r["n"]), d))
        for v in rc.values():
            v.sort(key=lambda x: x[0])
    end_now = loops[-1][1] if loops else None
    ep = os.path.join(run_dir, "end.json")
    if os.path.exists(ep):
        with open(ep) as fh:
            end_now = float(json.load(fh)["now"])
    return {"dir": run_dir, "loops": loops, "snaps": snaps, "rc": rc, "end_now": end_now}


def replay(cfg, run):
    """Replay one loaded run with config cfg. Returns the Strategist (trades in .trades)."""
    rc = run["rc"]

    def get_rc(mint, n):
        best = None
        for avail_n, d in rc.get(mint, ()):
            if avail_n <= n:
                best = d
            else:
                break
        return best or {}

    core = Strategist(cfg, get_rc)
    for n, now in run["loops"]:
        core.step(n, now, run["snaps"].get(n, {}))
    if run["end_now"] is not None:
        core.finish(run["end_now"])
    return core


def find_runs(results_root, round_name):
    base = os.path.join(results_root, round_name)
    if not os.path.isdir(base):
        return []
    return sorted(os.path.join(base, d) for d in os.listdir(base) if os.path.isdir(os.path.join(base, d)))
