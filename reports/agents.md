# Agent desk (paper trading)

Updated 2026-10-22 10:40 UTC. Runs so far: 13. Model: claude-haiku-5-5.

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
- control: SHAV long at 0.0001601, stop 0.00012808, target 0.00022414, opened 2026-10-22 10:25 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 10:40 UTC team macro (gold/forex), spent today $0.107

Scout: no memecoin passes the h1>+1000%, top10<15%, age<10m gate. EUR/USD and GBP/USD show no setup, and there are no high-impact events in 24h.
Sniper: nothing to size or execute.
Lead: Hold gold 156 (entry 4108, stop 4082.5, target 4140.5). Its thesis is intact and it is near the 5d low, so no change. Journal shows memecoin filter has never produced a winner worth the costs; keep it watch-only.

{"orders": [], "close": [], "note": "10:40 no orders. Hold gold 156 (entry 4108, now 4107.3, stop 4082.5, target 4140.5, ~20h left). Watch: memecoin under 10m old with h1 over +1000%, top10 under 15%, adequate liquidity; gold break below 4082.5 or above 4140.5; forex only on clear setup."}

- control: order SHAV REJECTED by guardrails: SHAV already open

