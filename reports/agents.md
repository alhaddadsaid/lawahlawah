# Agent desk (paper trading)

Updated 2026-10-21 16:36 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 60 | 22 | -2407.93 | -2961.54 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 62 | 21 | -2640.08 | -3205.7 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: COMPUTE long at 0.0001323, stop 0.00010584, target 0.00018522, opened 2026-10-21 15:32 UTC
- control: DCY long at 7.994e-05, stop 6.3952e-05, target 0.000111916, opened 2026-10-21 16:36 UTC

## Team

API spend today: $0.09 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 16:36 UTC team all (memecoins), spent today $0.087

Lead: No new orders. The memecoin filter is still empty. DCT is 3.6 min old, but its 1h gain is only +37%, far below the +1000% test. MILK is 39 min old and fails the age test. ALPENGLOW is 6 days old. Gold 41 stays open at +0.34% against its 4095 stop and 4180 target. Scout: the strategy's hypothesis still needs a candidate that passes all three filters (under 10 min, h1 over +1000%, top10 under 15%). Sniper: nothing to size, so no orders.

{"orders": [], "close": [], "note": "16:35 no new orders. Hold gold 41 (stop 4095, target 4180, price 4152.2, ~18h left). Memecoin filter empty: DCT 3.6m old but h1 +37%, top10 30% fails; MILK 39m fails age; ALPENGLOW old. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity adequate."}

- 2026-10-21 16:36 UTC control: OPENED DCY long at 7.994e-05 (stop 6.3952e-05, target 0.000111916) - control: frozen v3 rules

