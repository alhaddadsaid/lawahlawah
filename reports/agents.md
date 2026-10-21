# Agent desk (paper trading)

Updated 2026-10-21 14:11 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 47 | 19 | -2035.43 | -2465.27 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 48 | 19 | -2140.09 | -2574.22 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: COMPUTE long at 0.0001422, stop 0.00011376, target 0.00019908, opened 2026-10-21 12:24 UTC
- control: Gato long at 0.0001456, stop 0.00011648, target 0.00020384, opened 2026-10-21 13:28 UTC

## Team

API spend today: $0.06 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 14:11 UTC team all (memecoins), spent today $0.060

Lead: No new trades. Gold 41 is working toward its target, and its stop and target stay in place.
Scout: No memecoin passes under-10m age, h1>+1000%, and top10<15%. chud is 24.8m old with h1 +20%, so it fails. No macro events in 24h.
Sniper: No orders. Hold gold 41 (stop 4095, target 4180).

{"orders": [], "close": [], "note": "14:11 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~20.5h left, +0.21%). chud (24.8m, h1 +20%) fails age filter. No macro events in 24h. Watch next scan: under-10m, h1>+1000%, top10<15%; memecoin hypothesis stays paused."}


