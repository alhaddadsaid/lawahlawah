# Agent desk (paper trading)

Updated 2026-10-21 09:37 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 2 | 100 | 14.9 | 9.39 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 2 | 100 | 14.9 | 9.39 |
| control | meme | 31 | 19 | -1275.06 | -1560.29 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 31 | 19 | -1275.06 | -1560.29 |

Verdict: too early, 2 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: COMPUTE long at 0.0002347, stop 0.00018776, target 0.00032858, opened 2026-10-21 08:32 UTC
- control: MEME long at 0.0001472, stop 0.00011776, target 0.00020608, opened 2026-10-21 09:25 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 09:37 UTC team all (memecoins + gold/forex), spent today $0.011

Lead: No trade. No live memecoin passes the under-10-min, >1000% 1h filter. LOAN (+66% 1h, 263 min old) and the others fail it.
Scout: Macro is quiet. No high-impact calendar events in 24h, and the macro news gives no clear FX or gold edge.
Sniper: Nothing to size. Staying flat and watching for the next fresh token with h1 over 1000%, then logging its price path for the reversal-vs-continuation test.

{"orders": [], "close": [], "note": "Flat, no trades. Watch: next token under 10 min old with h1 over 1000%; log price path for reversal-vs-continuation test. Track TikTok US, MONEYBIZ, GATO, LWK, LARRY only for filter changes. Macro: no calendar events, no edge."}


