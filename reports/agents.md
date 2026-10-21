# Agent desk (paper trading)

Updated 2026-10-21 09:49 UTC. Runs so far: 9. Model: claude-haiku-5-5.

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

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 09:49 UTC team all (memecoins), spent today $0.013

Lead: No live setup passes our own filter. startupSI is 3,795 min old with h1 +7.9%, so it fails the age and momentum tests. GTA 6 Coin is at 4.3 min and h1 +897%, just short of the +1000% trigger, so it stays on watch. Scout: no macro calendar events, and the news flow gives no tradeable edge. Sniper: no order without a valid trigger. Stay flat.

{"orders": [], "close": [], "note": "No trades, flat. Filter unmet: startupSI 3795 min old, h1 +7.9%. Watch GTA 6 Coin (EGjvnJtmo2ChNYxP8XvTVix3jCfMHjsoAjNNyGBjpump, h1 +897%, age 4.3m): enter only if h1 passes +1000% while age is under 10 min, and log its price path. Still open: whether fomo's early exit (0.0006977 vs later 0.001378) signals target-too-tight; need more samples before changing rules."}

- 2026-10-21 09:49 UTC control: OPENED startupSI long at 6.068e-05 (stop 4.8544e-05, target 8.4952e-05) - control: frozen v3 rules

