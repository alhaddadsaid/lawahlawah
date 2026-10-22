# Agent desk (paper trading)

Updated 2026-10-22 05:28 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 14 | 64 | -296.97 | -333.87 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 14 | 64 | -296.97 | -333.87 |
| control | meme | 121 | 22 | -5563.58 | -6661.89 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 126 | 24 | -5386.47 | -6512.19 |

Verdict: too early, 14 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Gato long at 0.0003445, stop 0.0002756, target 0.0004823, opened 2026-10-22 03:38 UTC
- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC
- control: CYBER long at 0.0002618, stop 0.00020944, target 0.00036652, opened 2026-10-22 05:01 UTC
- control: PATCHED long at 9.798e-05, stop 7.8384e-05, target 0.000137172, opened 2026-10-22 05:25 UTC
- control: ヤギ long at 0.0001539, stop 0.00012312, target 0.00021546, opened 2026-10-22 05:28 UTC

## Team

API spend today: $0.07 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 05:28 UTC team all (memecoins), spent today $0.065

Lead: Hold GOLD 41. Price is 4103.9, just above the 4095 stop, with target 4180 and about 5.2h left. Entry was 4138, so this is a -0.83% drawdown inside the planned risk.
Scout: No memecoin passes age under 10m, h1 above +1000% and top10 under 15%. NOOX (137m old), CRAWL, PHP and GOAT all fail the age test.
Sniper: No new orders. Hard stop stays at 4095 on GOLD. Watch OA (top10 2.8%, liq $235k, h1 +24%) only. No entry without a fresh pump signal.
Journal: Rockstar stop breach (-$75) is a reminder that stops must be enforced at the level, not discretionary.

{"orders": [], "close": [], "note": "05:28 no orders. Hold GOLD 41 (4103.9 vs entry 4138.1, stop 4095, target 4180, ~5.2h left). No memecoin passes age<10m + h1>+1000% + top10<15%; NOOX, CRAWL, PHP, GOAT fail. Watch: OA (top10 2.8%, liq $235k, h1 +24%) as low-top10 test, entry only on fresh pump signal. Enforce hard stops at level (Rockstar breach)."}

- 2026-10-22 05:28 UTC control: OPENED ヤギ long at 0.0001539 (stop 0.00012312, target 0.00021546) - control: frozen v3 rules

