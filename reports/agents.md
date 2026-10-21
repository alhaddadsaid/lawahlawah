# Agent desk (paper trading)

Updated 2026-10-21 17:15 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 64 | 20 | -2868.99 | -3451.79 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 66 | 20 | -3101.14 | -3695.95 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: COMPUTE long at 0.0001323, stop 0.00010584, target 0.00018522, opened 2026-10-21 15:32 UTC
- control: ALPENGLOW long at 0.0001213, stop 9.704e-05, target 0.00016982, opened 2026-10-21 16:39 UTC
- control: KIMBULL long at 0.0001663, stop 0.00013304, target 0.00023282, opened 2026-10-21 17:00 UTC
- control: QUARTZ long at 7.014e-05, stop 5.6112e-05, target 9.8196e-05, opened 2026-10-21 17:12 UTC

## Team

API spend today: $0.09 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 17:15 UTC team all (memecoins), spent today $0.094

Lead: No new orders. Gold 41 is inside its plan (stop 4095, target 4180, about 17.5h left), so we hold it.
Scout: NIU is 3.7 min old with h1 +36%, but top10 is 22.4% against our <15% filter, and it's a memecoin where costs of 2.5-5% per side would eat a small move. Nothing else passes.
Sniper: No entries. Watch NIU if top10 falls under 15% and h1 is still very strong; the journal's memecoin edge is unproven and the filter has been empty for hours.

{"orders": [], "close": [], "note": "17:15 no new orders. Hold gold 41 (stop 4095, target 4180, ~17.4h left, price ~4148.5). Memecoin filter empty: NIU 3.7m old, h1 +36%, top10 22.4% fails top10<15%. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity adequate; recheck NIU top10 trend."}

- control: order Pokémon REJECTED by guardrails: desk already has the maximum open positions

