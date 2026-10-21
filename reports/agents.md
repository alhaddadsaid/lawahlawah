# Agent desk (paper trading)

Updated 2026-10-21 10:07 UTC. Runs so far: 9. Model: claude-haiku-5-5.

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

### 2026-10-21 10:07 UTC team all (memecoins), spent today $0.016

Scout: no memecoin in today's filtered list is under 10 minutes old with h1 over +1000%. KIMCHI, PHP and Pokecity are all hours old and fading or flat. GTA 6 Coin was +950% at 10:01 but is not in the current feed, so I can't verify its age or price now.

Lead: the entry rule is unmet, and the journal shows a tiny sample (2 trades). Chasing a stale or unverified print adds risk without evidence. Sniper: no order. Stay flat and keep logging the watch list.

{"orders": [], "close": [], "note": "No trades, flat. Filter unmet: KIMCHI 617m, PHP 293m, Pokecity 667m, none under 10m with h1 over 1000%. GTA 6 Coin not in current feed, so unverifiable; last seen h1 +950% at age 6.0m (10:01). Watch: any token under 10 min old with h1 over 1000%, log its price path for the reversal-vs-continuation test and the fomo target-too-tight observation."}

- control: order MEME REJECTED by guardrails: desk already has the maximum open positions

