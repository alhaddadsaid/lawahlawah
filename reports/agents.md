# Agent desk (paper trading)

Updated 2026-10-21 11:20 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 3 | 67 | -29.59 | -36.53 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 3 | 67 | -29.59 | -36.53 |
| control | meme | 37 | 16 | -1631.63 | -1969.26 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 38 | 16 | -1736.29 | -2078.21 |

Verdict: too early, 3 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: startupSI long at 6.068e-05, stop 4.8544e-05, target 8.4952e-05, opened 2026-10-21 09:49 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: BACKERS long at 0.000301, stop 0.0002408, target 0.0004214, opened 2026-10-21 11:14 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 11:20 UTC team all (memecoins), spent today $0.030

Lead: Hold. The memecoin filter is age under 10 min, h1 over +1000%, top10 under 15%. MrBeast (14 min, top10 14.2%) is just outside age, LASTAGENCY (37 min) and BACKERS fail, so no new trade. Gold 41 stays on its plan: stop 4095, target 4180, about 23 hours left. Scout: nothing new in the news flow that changes the gold thesis. Sniper: no orders. Still treating YouTube 42 as closed, not in the open feed; to verify.

{"orders": [], "close": [], "note": "11:20 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~23h left). MrBeast 14m old, top10 14.2%, h1 +1519%: fails the under-10m age filter, watch next scan. Verify YouTube 42 closed. Watch: memecoin under 10m with h1 over +1000% and top10 under 15%."}


