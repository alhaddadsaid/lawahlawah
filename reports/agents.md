# Agent desk (paper trading)

Updated 2026-10-22 10:19 UTC. Runs so far: 13. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 146 | 25 | -6042.34 | -7384.78 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 151 | 26 | -5865.23 | -7235.08 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4108, stop 4082.5, target 4140.5, opened 2026-10-22 06:56 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 10:19 UTC team macro (gold/forex), spent today $0.107

Lead: Hold gold 156. Price is 4104.8 against entry 4108, stop 4082.5, target 4140.5, with about 20 hours left. Nothing in the 24h calendar is high impact, so there's no reason to add or cut.
Scout: No memecoin passes the filter (age under 10m, h1 over +1000%, top10 under 15%, adequate liquidity). The feed has no candidates. EUR/USD and GBP/USD show no clear setup and would cost more than a small edge.
Sniper: No new orders. Keep the existing stop and target.

{"orders": [], "close": [], "note": "Hold gold 156 (entry 4108, now 4104.8, stop 4082.5, target 4140.5, ~20.6h left). No memecoin passes filter; no forex setup. Watch: memecoin under 10m old with h1 over +1000%, top10 under 15%, adequate liquidity; gold break below 4082.5 stop or above 4140.5 target."}


