# Agent desk (paper trading)

Updated 2026-10-21 11:51 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 40 | 20 | -1545.15 | -1915.76 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 41 | 20 | -1649.81 | -2024.71 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: startupSI long at 9.379e-05, stop 7.5032e-05, target 0.000131306, opened 2026-10-21 11:51 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 11:51 UTC team all (memecoins), spent today $0.036

Lead: No candidate passes the under-10-minute age gate. LASTAGENCY is 67m old (h1 +381%, top10 12.6%), so it fails. BACKERS, NEKO AI and Pokémon also fail age or momentum. Scout: no new macro catalyst beyond the crypto headlines, and BTC is holding near $82.5K. Sniper: no order, since the filter is unmet. Gold 41 stays open with its stop at 4095 and target at 4180. Watch for a memecoin under 10m old with h1 above +1000% and top10 under 15%.

{"orders": [], "close": [], "note": "11:51 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~22.8h left). Memecoin filter still empty: LASTAGENCY 67m (fails age), BACKERS 23380m, NEKO AI 88m, Pokemon 3667m. Watch next scan for under-10m, h1>+1000%, top10<15%."}

- 2026-10-21 11:51 UTC control: OPENED startupSI long at 9.379e-05 (stop 7.5032e-05, target 0.000131306) - control: frozen v3 rules

