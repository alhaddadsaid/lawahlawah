# Agent desk (paper trading)

Updated 2026-10-22 09:58 UTC. Runs so far: 13. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 144 | 24 | -6038.56 | -7360.59 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 149 | 26 | -5861.45 | -7210.89 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4108, stop 4082.5, target 4140.5, opened 2026-10-22 06:56 UTC
- control: NOOX long at 6.638e-05, stop 5.3104e-05, target 9.2932e-05, opened 2026-10-22 09:58 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 09:58 UTC team macro (gold/forex), spent today $0.106

Lead: Hold gold 156. Price is 4100.8, inside the stop (4082.5) and target (4140.5) band, with about 21 hours left, and no new scouting data supports a change.
Scout: No memecoin candidates in this feed. The filter (age under 10m, h1 over +1000%, top10 under 15%, adequate liquidity) has no passes. No high-impact events in 24h.
Sniper: No new orders. Stop and target stay as set on position 156.

{"orders": [], "close": [], "note": "09:58 no orders. Hold gold 156 (entry 4108, now 4100.8, stop 4082.5, target 4140.5, ~21h left). No memecoin candidates in feed; filter still unmet. No high-impact events in 24h. Watch: any memecoin under 10m old with h1 over +1000%, top10 under 15%, adequate liquidity; and gold reaction if it nears 4082.5 stop."}

- 2026-10-22 09:58 UTC control: OPENED NOOX long at 6.638e-05 (stop 5.3104e-05, target 9.2932e-05) - control: frozen v3 rules

