# Agent desk (paper trading)

Updated 2026-10-21 15:23 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 52 | 19 | -2175.36 | -2652.89 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 54 | 19 | -2407.51 | -2897.05 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: Gato long at 0.0001456, stop 0.00011648, target 0.00020384, opened 2026-10-21 13:28 UTC
- control: Pokémon long at 0.000364, stop 0.0002912, target 0.0005096, opened 2026-10-21 14:32 UTC
- control: wifchi long at 0.0001346, stop 0.00010768, target 0.00018844, opened 2026-10-21 14:58 UTC

## Team

API spend today: $0.07 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 15:23 UTC team all (memecoins), spent today $0.074

Scout: no memecoin passes the under-10m, h1 above +1000%, top10 below 15% filter. KIMCHI (38m) and Pokémon (65h) fail age, and GATO fails h1 and age.
Sniper: no entry, so no order.
Lead: no new trades. Gold 41 stays open with its stop at 4095 and target at 4180. Its edge is unproven, but the stop and target are already set, so no change now. Keep scanning memecoins for the filter.

{"orders": [], "close": [], "note": "15:22 no new orders. Hold gold 41 (stop 4095, target 4180, ~19.3h left, +0.17%). Memecoin filter still empty: KIMCHI 38m, GATO, Pokémon fail. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity adequate."}

- control: order wifchi REJECTED by guardrails: wifchi already open

