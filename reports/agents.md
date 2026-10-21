# Agent desk (paper trading)

Updated 2026-10-21 19:17 UTC. Runs so far: 10. Model: claude-haiku-5-5.

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
- team: YouTube long at 0.0005088, stop 0.0003814, target 0.000636, opened 2026-10-21 19:14 UTC
- control: ALPENGLOW long at 9.25e-05, stop 7.4e-05, target 0.0001295, opened 2026-10-21 18:10 UTC
- control: DARKCAT long at 8.757e-05, stop 7.0056e-05, target 0.000122598, opened 2026-10-21 18:34 UTC
- control: Pokémon long at 0.0004, stop 0.00032, target 0.00056, opened 2026-10-21 18:40 UTC
- control: PsyopAnime long at 0.0005293, stop 0.00042344, target 0.00074102, opened 2026-10-21 19:08 UTC
- control: DacityCoin long at 0.000189, stop 0.0001512, target 0.0002646, opened 2026-10-21 19:17 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 19:17 UTC team all (memecoins), spent today $0.115

Lead: The memecoin filter is still empty. PHP2SHELL is +555% on the hour with 5% top10, but it is 79 minutes old, so it fails the under-10-minute rule. Others are old or weak. Gold 41 is near the middle of its range with no edge over the stop/target plan, so we hold. YouTube 86 is +5.9% with 2h left and a stop well below. Scout: no new hypothesis passes the filter. Sniper: no new orders. Hold both positions to their stops, targets and time limits.

{"orders": [], "close": [], "note": "19:17 no new orders. Hold gold 41 (price 4135.5, stop 4095, target 4180, ~15.4h left) and YouTube 86 (price 0.0005388, stop 0.000381, target 0.000636, ~2h left). Memecoin filter empty: PHP2SHELL 79m old fails age despite h1 +555% and top10 5%; KIMCHINU, Dacity, DacityCoin fail. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK. Hypothesis to keep testing: the under-10m rule is the core filter, so do not relax it for older coins."}

- 2026-10-21 19:17 UTC control: OPENED DacityCoin long at 0.000189 (stop 0.0001512, target 0.0002646) - control: frozen v3 rules

