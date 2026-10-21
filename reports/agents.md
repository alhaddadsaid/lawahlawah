# Agent desk (paper trading)

Updated 2026-10-21 18:16 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 68 | 21 | -3152.79 | -3769.33 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 71 | 21 | -3257.92 | -3890.31 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Pokémon long at 0.0003028, stop 0.00024224, target 0.00042392, opened 2026-10-21 17:18 UTC
- control: ALPENGLOW long at 9.25e-05, stop 7.4e-05, target 0.0001295, opened 2026-10-21 18:10 UTC

## Team

API spend today: $0.10 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 18:16 UTC team all (memecoins), spent today $0.104

Scout: The memecoin scan still has no candidate. JOCAT (57m old, h1 +548%) and KICITY (45m old) fail the under-10m and h1>+1000% filters. Macro news doesn't give a clear gold catalyst.
Sniper: No order passes the filter, so no entry.
Lead: Hold gold 41 with its stop at 4095 and target at 4180. Exiting now would pay costs for no new edge. No new orders.

{"orders": [], "close": [], "note": "18:16 no new orders. Hold gold 41 (stop 4095, target 4180, price 4157.8, ~16.4h left). Memecoin filter empty: JOCAT 57m old h1 +548% and KICITY 45m old fail. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK."}


