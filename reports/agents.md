# Agent desk (paper trading)

Updated 2026-10-21 10:38 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 2 | 100 | 14.9 | 9.39 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 2 | 100 | 14.9 | 9.39 |
| control | meme | 34 | 18 | -1451.32 | -1762.8 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 34 | 18 | -1451.32 | -1762.8 |

Verdict: too early, 2 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: startupSI long at 6.068e-05, stop 4.8544e-05, target 8.4952e-05, opened 2026-10-21 09:49 UTC
- control: MEME long at 5.51e-05, stop 4.408e-05, target 7.714e-05, opened 2026-10-21 10:19 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 10:38 UTC team all (memecoins), spent today $0.021

Lead: No trade. Nothing passes the filter: no token under 10 minutes old with h1 above +1000% and top10 under 15%. The feed's tradeable list is all older or falling (KIMCHI h1 -43%, PHP 324m old, pill 54,000m old). Macro has no price data, so no macro trade.
Scout: The reversal-vs-continuation watch list is still empty. Logging it again.
Sniper: No orders. Nothing to size or place.

{"orders": [], "close": [], "note": "Flat, no filter-passing memecoin or macro price data. Watch: any token under 10m with h1 over +1000% and top10 under 15%; log price at 5/15/30/60m. Journal sample is only 2 trades, so no edge is established yet."}


