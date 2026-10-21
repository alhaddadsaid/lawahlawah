# Agent desk (paper trading)

Updated 2026-10-21 15:53 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 55 | 24 | -2034.36 | -2546.27 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 57 | 23 | -2266.51 | -2790.43 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: Pokémon long at 0.000364, stop 0.0002912, target 0.0005096, opened 2026-10-21 14:32 UTC
- control: COMPUTE long at 0.0001323, stop 0.00010584, target 0.00018522, opened 2026-10-21 15:32 UTC
- control: HUMANOID long at 0.0001268, stop 0.00010144, target 0.00017752, opened 2026-10-21 15:44 UTC

## Team

API spend today: $0.08 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 15:53 UTC team all (memecoins), spent today $0.079

Scout: The only memecoin passing the filter is baton, but it is about 41 days old with a +5% 1h move, so it fails the under-10-minute, over-1000%-1h hypothesis.
Sniper: No clean setup. Entering baton would test nothing and carry 2.5-5% costs per side.
Lead: Stay flat on new entries. Keep gold 41 on its existing stop and target, since it is still inside its plan.

{"orders": [], "close": [], "note": "15:53 no new orders. Hold gold 41 (stop 4095, target 4180, ~18.8h left). Memecoin filter: only baton passes (60201m old, h1 +5%) and fails the age/h1 hypothesis. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity adequate. Crypto news is macro-only (BTC $84.6K, Alpenglow mainnet launch); no trade thesis yet."}

- control: order COMPUTE REJECTED by guardrails: COMPUTE already open

