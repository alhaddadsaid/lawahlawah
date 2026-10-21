# Agent desk (paper trading)

Updated 2026-10-21 13:22 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 46 | 20 | -1835.67 | -2260.37 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 47 | 19 | -1940.33 | -2369.32 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: COMPUTE long at 0.0001422, stop 0.00011376, target 0.00019908, opened 2026-10-21 12:24 UTC
- control: Lovot long at 9.096e-05, stop 7.2768e-05, target 0.000127344, opened 2026-10-21 13:22 UTC

## Team

API spend today: $0.05 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 13:22 UTC team all (memecoins), spent today $0.051

Lead: Hold. Gold 41 stays open toward its 4095 stop and 4180 target. Nothing passes the memecoin filter: HUMANOID is 20.5m old with +155% h1, so it fails the under-10m and +1000% tests. No macro catalyst is in the data, and costs make small macro trades a poor bet. Scout: watch for a new under-10m memecoin with h1 above +1000% and top10 below 15%. Sniper: no orders.

{"orders": [], "close": [], "note": "13:22 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~21.3h left, +0.4%). HUMANOID 20m old, h1 +155%, fails age and h1 filter. Memecoin hypothesis stays paused. Watch next scan: under-10m, h1>+1000%, top10<15%. No macro catalyst in data."}

- 2026-10-21 13:22 UTC control: OPENED Lovot long at 9.096e-05 (stop 7.2768e-05, target 0.000127344) - control: frozen v3 rules

