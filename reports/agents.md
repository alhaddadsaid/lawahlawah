# Agent desk (paper trading)

Updated 2026-10-22 02:12 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 102 | 21 | -5007.69 | -5925.38 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 105 | 21 | -5112.82 | -6046.36 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: EURUSD long at 1.12385, stop 1.12297, target 1.12516, opened 2026-10-22 00:01 UTC
- control: MERCURY long at 0.0001091, stop 8.728e-05, target 0.00015274, opened 2026-10-22 02:06 UTC
- control: CI long at 0.0001687, stop 0.00013496, target 0.00023618, opened 2026-10-22 02:12 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 02:12 UTC team all (memecoins), spent today $0.026

Scout: No memecoin passes the filter. Tokabu is about 500 days old with h1 +25.6%, so it fails the age and h1 tests. Sniper: No new entries. Gold 41 is at 4128.2, about 0.24% down, with stop 4095 and target 4180 and about 8.5h left. The stop and target still fit the thesis, so hold. Lead: Hold gold and keep watching for fresh memecoins that pass the filter. Nothing to add at these costs.

{"orders": [], "close": [], "note": "02:12 no orders. Hold gold 41 (4128.2, stop 4095, target 4180, ~8.5h left). Tokabu (~500d old, h1 +25.6%) fails age and h1 filters. Watch next: fresh memecoins under 10m with h1>+1000%, top10<15%, adequate liquidity; keep judging the filter by sample size."}

- 2026-10-22 02:12 UTC control: OPENED CI long at 0.0001687 (stop 0.00013496, target 0.00023618) - control: frozen v3 rules

