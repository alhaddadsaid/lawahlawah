# Agent desk (paper trading)

Updated 2026-10-21 17:46 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 68 | 21 | -3152.79 | -3769.33 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 70 | 20 | -3384.94 | -4013.49 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: Pokémon long at 0.0003028, stop 0.00024224, target 0.00042392, opened 2026-10-21 17:18 UTC

## Team

API spend today: $0.10 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 17:46 UTC team all (memecoins + gold/forex), spent today $0.099

Scout: MrBeast is +1177% in 1h with top10 at 13.9%, but it is 17.6 min old, so it fails the under-10-min rule. JOCAT (26.8m) and KICITY (14.5m) also fail age, and the rest are mature or have weak 1h moves.
Sniper: No order passes the filter, so there is no entry.
Lead: Hold gold 41 unchanged. Its stop and target are intact, and the 5-day range position still supports the thesis. Nothing qualifies, so no trades.

{"orders": [], "close": [], "note": "17:46 no new orders. Hold gold 41 (stop 4095, target 4180, price 4151.7, ~16.9h left). Memecoin filter empty: MrBeast h1 +1177% and top10 13.9% pass but age 17.6m fails under-10m; JOCAT 26.8m, KICITY 14.5m fail age. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK; MrBeast re-check only if it is still tradeable and passes age (it will not). No macro catalyst in 24h."}


