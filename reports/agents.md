# Agent desk (paper trading)

Updated 2026-10-21 19:08 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 72 | 22 | -3417.42 | -4068.2 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 75 | 23 | -3522.55 | -4189.18 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: ALPENGLOW long at 9.25e-05, stop 7.4e-05, target 0.0001295, opened 2026-10-21 18:10 UTC
- control: DARKCAT long at 8.757e-05, stop 7.0056e-05, target 0.000122598, opened 2026-10-21 18:34 UTC
- control: Pokémon long at 0.0004, stop 0.00032, target 0.00056, opened 2026-10-21 18:40 UTC
- control: PsyopAnime long at 0.0005293, stop 0.00042344, target 0.00074102, opened 2026-10-21 19:08 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 19:08 UTC team all (memecoins), spent today $0.113

Lead: Hold. Gold 41 is near entry (4136.9 vs 4138.1), with the stop at 4095 and target at 4180 still intact. No memecoin passes the filter: Kimchi is 18.6m old, and its top10 is 26%. Scout: the memecoin hypothesis needs under-10m age, h1 above +1000% and top10 below 15%, and no coin meets that. Sniper: no new orders. Gold stays open.

{"orders": [], "close": [], "note": "19:08 no new orders. Hold gold 41 (stop 4095, target 4180, price 4136.9, ~15.6h left). Memecoin filter empty: Kimchi 18.6m old, h1 +27%, top10 26% fails; others old or weak. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK. Hypothesis to test when one passes: continuation of +20% within the hold window, with a stop at -10% and max 4h."}

- 2026-10-21 19:08 UTC control: OPENED PsyopAnime long at 0.0005293 (stop 0.00042344, target 0.00074102) - control: frozen v3 rules

