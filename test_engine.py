import json
import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from papertest import engine  # noqa: E402

CFG = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "config.json")))
EX = CFG["exits"]


def run(prices, step=5.0):
    """Signal at t=0 with price prices[0]; ticks every `step` seconds."""
    p = engine.Position("v3", "M", "TK", 0.0, prices[0])
    t = 0.0
    for px in prices:
        t += step
        engine.on_tick(p, px, t, EX)
        if not p.is_open:
            break
    return p


class ExitRules(unittest.TestCase):
    def test_entry_fills_at_next_tick(self):
        p = run([100, 105, 106])
        self.assertEqual(p.entry_price, 100)  # first tick after signal

    def test_stop_loss_gap_fills_worse(self):
        p = run([100, 95, 50])
        self.assertEqual(p.fills[-1][2], "stop_loss")
        self.assertEqual(p.fills[-1][1], 50)  # crash fills at the gap price, not 80
        self.assertAlmostEqual(engine.net_return(p, 0), -0.5)

    def test_take_half_then_trail(self):
        p = run([100, 131, 160, 150, 127])  # peak 160, trail at 128
        reasons = [f[2] for f in p.fills]
        self.assertEqual(reasons, ["take_half", "trailing_stop"])
        self.assertAlmostEqual(engine.net_return(p, 0), 0.5 * 0.31 + 0.5 * 0.27)

    def test_time_stop_only_cuts_losers(self):
        loser = run([100] + [99] * 200)
        self.assertEqual(loser.fills[-1][2], "time_stop")
        winner = run([100] + [104] * 200)
        self.assertNotIn("time_stop", [f[2] for f in winner.fills])

    def test_max_hold(self):
        p = run([100] + [104] * 2000)
        self.assertEqual(p.fills[-1][2], "max_hold")
        self.assertAlmostEqual((p.fills[-1][3] - p.entry_time) / 60, EX["max_hold_minutes"], delta=0.1)

    def test_costs_both_sides(self):
        p = run([100, 100, 100])
        engine.force_close(p, 100, 99, "run_end")
        self.assertAlmostEqual(engine.net_return(p, 0.025), 0.975 / 1.025 - 1)  # about -4.9%


class EntryFilter(unittest.TestCase):
    good = {"symbol": "ABC", "name": "Abc", "age_minutes": 60, "m5_change": -8,
            "mcap": 150_000, "liquidity_usd": 40_000, "holders": 1500, "top10_pct": 0.2,
            "insider_pct": 0.02, "mint_authority": False, "freeze_authority": False, "rugged": False}

    def check(self, **over):
        f = {**self.good, **over}
        return engine.check_entry(CFG["strategies"]["v3"], f, CFG["name_blocklist"])

    def test_good_passes(self):
        self.assertEqual(self.check(), (True, "ok"))

    def test_rules(self):
        self.assertEqual(self.check(age_minutes=20)[1], "too_young")
        self.assertEqual(self.check(m5_change=12)[1], "no_pullback")
        self.assertEqual(self.check(m5_change=-30)[1], "no_pullback")
        self.assertEqual(self.check(liquidity_usd=20_000)[1], "low_liquidity")
        self.assertEqual(self.check(holders=900)[1], "few_holders")
        self.assertEqual(self.check(top10_pct=0.35)[1], "top10_concentrated")
        self.assertEqual(self.check(insider_pct=0.2)[1], "insiders")
        self.assertEqual(self.check(freeze_authority=True)[1], "authority_not_revoked")
        self.assertEqual(self.check(name="Official Trump")[1], "blocked_name")
        self.assertEqual(self.check(name="Pineapple")[0], True)  # whole words only

    def test_missing_data_rejects(self):
        self.assertEqual(self.check(holders=None)[1], "missing_holders")

    def test_tiered_liquidity_variant(self):
        f = {**self.good, "mcap": 500_000, "liquidity_usd": 60_000}  # 12%
        self.assertFalse(engine.check_entry(CFG["strategies"]["v3"], f, [])[0])
        self.assertTrue(engine.check_entry(CFG["strategies"]["v3_tiered_liq"], f, [])[0])


class Tradeable(unittest.TestCase):
    T = CFG["tradeable"]
    ok = {"mcap": 150_000, "liquidity_usd": 40_000, "vol_m5": 5_000}

    def check(self, **over):
        return engine.check_tradeable(self.T, {**self.ok, **over})

    def test_rules(self):
        self.assertEqual(self.check(), (True, "ok"))
        self.assertEqual(self.check(mcap=3_000, liquidity_usd=3_500)[1], "mcap_too_small")  # dead coin
        self.assertEqual(self.check(mcap=56_000_000)[1], "mcap_too_big")
        self.assertEqual(self.check(liquidity_usd=8_000)[1], "liquidity_too_small")
        self.assertEqual(self.check(mcap=60_000, liquidity_usd=70_000)[1], "broken_liquidity_data")
        self.assertEqual(self.check(vol_m5=200)[1], "no_recent_volume")
        self.assertEqual(self.check(vol_m5=None)[1], "missing_vol_m5")


if __name__ == "__main__":
    unittest.main()
