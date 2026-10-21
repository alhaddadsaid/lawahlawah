# Agent desk (paper trading)

Updated 2026-10-21 19:38 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 6 | 83 | -9.39 | -24.52 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 6 | 83 | -9.39 | -24.52 |
| control | meme | 72 | 22 | -3417.42 | -4068.2 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 75 | 23 | -3522.55 | -4189.18 |

Verdict: too early, 6 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: ALPENGLOW long at 9.25e-05, stop 7.4e-05, target 0.0001295, opened 2026-10-21 18:10 UTC
- control: DARKCAT long at 8.757e-05, stop 7.0056e-05, target 0.000122598, opened 2026-10-21 18:34 UTC
- control: Pokémon long at 0.0004, stop 0.00032, target 0.00056, opened 2026-10-21 18:40 UTC
- control: PsyopAnime long at 0.0005293, stop 0.00042344, target 0.00074102, opened 2026-10-21 19:08 UTC
- control: DacityCoin long at 0.000189, stop 0.0001512, target 0.0002646, opened 2026-10-21 19:17 UTC

## Team

API spend today: $0.12 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 19:38 UTC team all (memecoins), spent today $0.119

Lead: No new trades. Memecoin filter is still empty. "4" is 7 minutes old, but h1 is +106% (needs >1000%) and top10 is 25.6% (needs <15%). MADE, JONATHAN and PHP fail on age. Gold 41 is up about 0.05% from entry, with the stop at 4095 and target at 4180. Thesis is intact, so we hold.

Scout: The crypto news flow (SpaceX earnings, BTC at $84.6K, MiCA/DeFi regulation pieces) gives no clear memecoin catalyst. Nothing to test this scan.

Sniper: No orders. Gold 41 keeps its existing stop and target.

Hypothesis for next scan: under-10m memecoins with h1 above +1000% and top10 below 15% keep rising 20% or more. Our closed sample for that rule is mixed and small, so keep size at 0.5%.

{"orders": [], "close": [], "note": "19:38 no new orders. Hold gold 41 (price 4140.2, stop 4095, target 4180, ~15h left). Memecoin scan: '4' 7m old but h1 +106% and top10 25.6% fail; MADE/JONATHAN/PHP fail age. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK; keep size at 0.5% for any entry."}

- control: order KIMCHI REJECTED by guardrails: desk already has the maximum open positions

