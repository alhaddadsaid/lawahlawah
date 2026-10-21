# Agent desk (paper trading)

Updated 2026-10-21 09:58 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 2 | 100 | 14.9 | 9.39 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 2 | 100 | 14.9 | 9.39 |
| control | meme | 32 | 19 | -1325.73 | -1619.92 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 32 | 19 | -1325.73 | -1619.92 |

Verdict: too early, 2 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: COMPUTE long at 0.0002347, stop 0.00018776, target 0.00032858, opened 2026-10-21 08:32 UTC
- control: startupSI long at 6.068e-05, stop 4.8544e-05, target 8.4952e-05, opened 2026-10-21 09:49 UTC
- control: MEME long at 8.835e-05, stop 7.068e-05, target 0.00012369, opened 2026-10-21 09:52 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 09:58 UTC team all (memecoins + gold/forex), spent today $0.015

Sniper: SHELLSHOCK is 3.9 min old, but its h1 is +116%, well short of the >1000% filter. Its m5 volume (~$97k) is about 4x its liquidity ($25k), so slippage on a memecoin entry would eat the 2.5-5% per-side cost. No trade.

Scout: GOLD, EURUSD and GBPUSD show no calendar catalyst in the next 24h and small 1h moves against ATR, so there is no macro edge to test.

Lead: Stay flat. Keep the filter test running and log SHELLSHOCK's path in case it reaches the threshold while still under 10 minutes old.

{"orders": [], "close": [], "note": "No trades, flat. Filter unmet: SHELLSHOCK 3.9m old but h1 +116%, liq $25k vs m5 vol $97k (slippage risk). Watch SHELLSHOCK (9yxQvtqzsdHay96y7kxE8ikrGdi2FnytaCmMr9c9pump): enter only if h1 passes +1000% while age is under 10 min and liquidity holds; log its price path for reversal-vs-continuation. Still track fomo target-too-tight observation. No macro events in 24h."}


