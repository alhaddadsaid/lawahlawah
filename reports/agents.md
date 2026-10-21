# Agent desk (paper trading)

Updated 2026-10-21 21:38 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 9 | 78 | -92.68 | -118.46 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 9 | 78 | -92.68 | -118.46 |
| control | meme | 82 | 22 | -3825.69 | -4568.57 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 85 | 22 | -3930.82 | -4689.55 |

Verdict: too early, 9 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC

## Team

API spend today: $0.14 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 21:38 UTC team all (memecoins), spent today $0.143

Lead: No new trades. Scout's scan finds no memecoin under 10 minutes old with h1 above +1000% and top10 under 15%. PULLBACK is 178m old, CHOO 169m, Pokecity 1358m, DOPE and DOOD are far older, and COMPUTE is 3441m. Sniper: keep gold 41 on its existing stop 4095 and target 4180. Speed 93 and YouTube 95 are not in the live open list, so they are treated as closed. Watch next: fresh listings meeting all three filters.

{"orders": [], "close": [], "note": "No orders. Hold gold 41 (4159.5, stop 4095, target 4180, ~13h left). Speed 93 and YouTube 95 treated as closed (not in live list). Memecoin scan: no passes on under-10m age, h1>+1000%, top10<15%. Watch next: fresh listings meeting all three criteria."}


