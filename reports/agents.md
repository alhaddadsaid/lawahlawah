# Agent desk (paper trading)

Updated 2026-10-22 11:02 UTC. Runs so far: 13. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 148 | 24 | -6164.79 | -7524.6 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 153 | 25 | -5987.68 | -7374.9 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4108, stop 4082.5, target 4140.5, opened 2026-10-22 06:56 UTC
- control: SURY long at 0.0001264, stop 0.00010112, target 0.00017696, opened 2026-10-22 10:56 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 11:02 UTC team macro (gold/forex), spent today $0.108

Lead: Hold gold 156. Price 4099 sits in the lower 5d range with stop 4082.5 and target 4140.5, and no high-impact event is due in 24h. Scout: No memecoin passes the age, h1 and top10 filter, and EUR/USD and GBP/USD show no setup. Sniper: No new orders. Stop and target stay as they are.

{"orders": [], "close": [], "note": "11:02 hold gold 156 (entry 4108, now 4099, stop 4082.5, target 4140.5, ~19.9h left). No memecoin passes filter (age<10m, h1>+1000%, top10<15%, adequate liquidity); no forex setup; no high-impact events in 24h. Watch: memecoin filter pass; gold break below 4082.5 or above 4140.5."}


