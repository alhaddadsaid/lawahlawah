# Agent desk (paper trading)

Updated 2026-10-22 03:14 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 107 | 21 | -5188.3 | -6152.65 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 112 | 22 | -5011.19 | -6002.95 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: CI long at 7.741e-05, stop 6.1928e-05, target 0.000108374, opened 2026-10-22 02:50 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 03:14 UTC team all (memecoins), spent today $0.038

Lead: Hold gold 41. It is at 4127.6, down 0.25%, with the stop at 4095 and the target at 4180, and about 7.4h remain. Nothing new on macro.

Scout: BROZO (17.8m old, h1 +112%, top10 24%) fails the under-10m and top10<15% filter. No new hypothesis; the filter has produced net losses so far.

Sniper: No new orders. Holding 41 with the existing stop and target.

{"orders": [], "close": [], "note": "03:14 no orders. Hold gold 41 (4127.6 vs entry 4138.1, stop 4095, target 4180, ~7.4h left). BROZO (17.8m, h1 +112%, top10 24%) fails age and top10 filters. No macro events 24h. Watch next: fresh memecoins under 10m with h1>+1000%, top10<15%, adequate liquidity; consider whether the filter needs a different entry rule given losses on chasing spikes."}


