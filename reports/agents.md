# Agent desk (paper trading)

Updated 2026-10-21 17:24 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 67 | 19 | -3175.36 | -3781.07 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 69 | 19 | -3407.51 | -4025.23 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: COMPUTE long at 0.0001323, stop 0.00010584, target 0.00018522, opened 2026-10-21 15:32 UTC
- control: Pokémon long at 0.0003028, stop 0.00024224, target 0.00042392, opened 2026-10-21 17:18 UTC

## Team

API spend today: $0.10 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 17:24 UTC team all (memecoins + gold/forex), spent today $0.095

Scout: The memecoin filter is empty again. Murad (~46 days old) and PILL (~37 days old) fail the under-10-minute age test, and there is no macro catalyst in the calendar or news.

Lead: No new trades. Gold 41 is inside its plan (price 4149.9, stop 4095, target 4180, about 17h left), so we hold. Opening anything now would be forcing trades without an edge.

Sniper: No orders. Nothing to adjust on 41.

{"orders": [], "close": [], "note": "17:24 no new orders. Hold gold 41 (stop 4095, target 4180, price 4149.9, ~17.3h left). Memecoin filter empty: Murad ~46d old, PILL ~37d old. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK; no macro catalyst in 24h calendar."}


