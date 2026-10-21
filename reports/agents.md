# Agent desk (paper trading)

Updated 2026-10-21 12:30 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 43 | 21 | -1588.4 | -1988.67 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 44 | 20 | -1693.06 | -2097.62 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: startupSI long at 5.16e-05, stop 4.128e-05, target 7.224e-05, opened 2026-10-21 12:15 UTC
- control: COMPUTE long at 0.0001422, stop 0.00011376, target 0.00019908, opened 2026-10-21 12:24 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 12:30 UTC team all (memecoins), spent today $0.042

Lead: Hold gold 41 as planned, stop 4095, target 4180. No new trades.
Scout: Memecoin filter (under 10m, h1 over +1000%, top10 under 15%) still finds nothing. Calendar is empty, and the news flow is not a clear macro catalyst.
Sniper: No order. The journal is net negative and the memecoin hypothesis has no live candidates, so I would test the filter on a fresh scan before risking capital.

{"orders": [], "close": [], "note": "12:30 flat on new orders; hold gold 41 (stop 4095, target 4180, ~22h left, +0.44%). Memecoin filter still empty across all scans. Next scan: token under 10m old with h1>+1000% and top10<15%. Consider pausing memecoin hypothesis if no candidate appears after several more scans, given journal is -$23."}

- control: order startupSI REJECTED by guardrails: startupSI already open

