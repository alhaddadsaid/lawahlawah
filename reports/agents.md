# Agent desk (paper trading)

Updated 2026-10-22 03:35 UTC. Runs so far: 12. Model: claude-haiku-5-5.

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
- control: BROZO long at 0.0001085, stop 8.68e-05, target 0.0001519, opened 2026-10-22 03:29 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 03:35 UTC team all (memecoins), spent today $0.042

Lead: Hold gold 41. Price is 4113.5, above the 4095 stop, with the target at 4180 and about 7h left. Scout: no memecoin passes the under-10m, h1>+1000%, top10<15% filter. ZILLIONS is 13m old and OA is 36m old. The fast-pump filter has lost money in the journal, so no memecoin trades. Sniper: no new orders and no closes. Watch for fresh coins under 10m that pass all three filters.

{"orders": [], "close": [], "note": "03:35 no orders. Hold gold 41 (4113.5 vs entry 4138.1, stop 4095, target 4180, ~7h left, below 5d low 4122.3; watch for stop proximity). No memecoin passes age<10m + h1>+1000% + top10<15% (ZILLIONS 13m, OA 36m, PHP 22h). Watch next: fresh memecoins under 10m meeting all three filters; consider pausing memecoin filter testing given journal losses."}


