# Agent desk (paper trading)

Updated 2026-10-22 11:23 UTC. Runs so far: 13. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 152 | 24 | -6372.86 | -7768.36 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 157 | 25 | -6195.75 | -7618.66 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4108, stop 4082.5, target 4140.5, opened 2026-10-22 06:56 UTC
- control: MONEYBIZ long at 0.0002003, stop 0.00016024, target 0.00028042, opened 2026-10-22 11:20 UTC
- control: SHAV long at 0.0001602, stop 0.00012816, target 0.00022428, opened 2026-10-22 11:23 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 11:23 UTC team macro (gold/forex), spent today $0.108

Scout: No memecoin passes the filter (age under 10m, h1 over +1000%, top10 under 15%). No forex setup and no high-impact events in 24h.
Sniper: Gold 156 is down 0.45% and sits about 0.2% above its 4082.5 stop, near the 5d low (4082.4). Stop and target stay as set.
Lead: Hold 156 and place no new orders. Costs are high relative to the edge, and the filter is unmet.

{"orders": [], "close": [], "note": "11:23 no orders. Hold gold 156 (entry 4108, now 4089.4, stop 4082.5, target 4140.5, ~19.5h left); stop is close to the 5d low at 4082.4. Watch: memecoin under 10m old with h1 over +1000%, top10 under 15%, adequate liquidity; gold break below 4082.5 (stop) or above 4140 (target); EURUSD/GBPUSD no setup."}

- 2026-10-22 11:23 UTC control: OPENED SHAV long at 0.0001602 (stop 0.00012816, target 0.00022428) - control: frozen v3 rules

