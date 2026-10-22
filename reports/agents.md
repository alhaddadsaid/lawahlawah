# Agent desk (paper trading)

Updated 2026-10-22 05:58 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 128 | 22 | -5880.92 | -7042.88 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 133 | 23 | -5703.81 | -6893.18 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC
- control: CYBER long at 0.0002618, stop 0.00020944, target 0.00036652, opened 2026-10-22 05:01 UTC
- control: SURY long at 0.0001996, stop 0.00015968, target 0.00027944, opened 2026-10-22 05:52 UTC
- control: ヤギ long at 0.0001719, stop 0.00013752, target 0.00024066, opened 2026-10-22 05:58 UTC

## Team

API spend today: $0.07 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 05:58 UTC team all (memecoins), spent today $0.072

Lead: No trade. The age<10m, h1>+1000%, top10<15% filter is paused after repeated losses, and no candidate passes it. CYBER (h1 +41%, top10 15.04%, age 451m) fails the filter. PHP and NOOX are falling and DOOD is a large-cap. Gold has no open position, and the last price we have (4094.4) sits on the stop level we already breached, so there is no clean setup. Scout watch list: CYBER only if top10 drops under 15% and h1 holds a breakout; PHP only on a reclaim. Sniper: no orders.

{"orders": [], "close": [], "note": "No orders at 05:58. Flat account, no positions. Memecoin filter remains paused. Watch: CYBER (top10 15.04%, h1 +41%) if top10 falls below 15% with continued volume; PHP and NOOX only on a confirmed reversal. Gold: no setup, last print 4094.4 at prior stop; revisit only on a clean reclaim of the 5-day range midpoint with a defined stop."}

- 2026-10-22 05:58 UTC control: OPENED ヤギ long at 0.0001719 (stop 0.00013752, target 0.00024066) - control: frozen v3 rules

