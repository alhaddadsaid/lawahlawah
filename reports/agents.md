# Agent desk (paper trading)

Updated 2026-10-21 12:39 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 44 | 20 | -1735.13 | -2141.89 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 45 | 20 | -1839.79 | -2250.84 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: COMPUTE long at 0.0001422, stop 0.00011376, target 0.00019908, opened 2026-10-21 12:24 UTC
- control: HUSH long at 0.0001391, stop 0.00011128, target 0.00019474, opened 2026-10-21 12:39 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 12:39 UTC team all (memecoins), spent today $0.044

Lead: Hold. The memecoin filter (under 10 min old, h1 above +1000%, top10 under 15%) has come up empty for over an hour, and every candidate fails on age, h1 or top10. Gold 41 is +0.28%, inside its stop (4095) and target (4180), with about 22h left, so no change. Scout: calendar is empty for 24h and the crypto headlines are regulatory, not catalysts for the filter. Sniper: no new orders. Next scan, check for an under-10m token meeting all three conditions; if the filter stays empty again, pause the memecoin hypothesis.

{"orders": [], "close": [], "note": "12:39 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~22h left, +0.28%). Memecoin filter still empty (Pokecity 819m old, PHP/COMPUTE/BACKERS fail age and h1). Next scan: token under 10m old with h1>+1000% and top10<15%. If empty again, pause memecoin hypothesis and focus on macro."}

- 2026-10-21 12:39 UTC control: OPENED HUSH long at 0.0001391 (stop 0.00011128, target 0.00019474) - control: frozen v3 rules

