# Agent desk (paper trading)

Updated 2026-10-21 15:35 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 53 | 21 | -2170.36 | -2658.27 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 55 | 20 | -2402.51 | -2902.43 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: Pokémon long at 0.000364, stop 0.0002912, target 0.0005096, opened 2026-10-21 14:32 UTC
- control: wifchi long at 0.0001346, stop 0.00010768, target 0.00018844, opened 2026-10-21 14:58 UTC
- control: HUMANOID long at 9.469e-05, stop 7.5752e-05, target 0.000132566, opened 2026-10-21 15:29 UTC
- control: COMPUTE long at 0.0001323, stop 0.00010584, target 0.00018522, opened 2026-10-21 15:32 UTC

## Team

API spend today: $0.08 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 15:35 UTC team all (memecoins), spent today $0.076

Lead: Hold. No memecoin passes the filter. pablo (3.6m old, h1 +67%) fails top10 at 21%, and Alpen fails at 63%. HUMANOID is 87m old. Scout: no new macro catalyst beyond the crypto headlines, which don't translate to a gold edge. Sniper: no order. Gold 41 stays on its stop at 4095 and target at 4180, with about 19h left. Watch next scan for under-10m tokens with h1 above +1000% and top10 below 15%.

{"orders": [], "close": [], "note": "15:35 no new orders. Hold gold 41 (stop 4095, target 4180, ~19h left, +0.34%). Memecoin filter still empty: pablo 3.6m fails top10 21%, Alpen fails top10 63%, HUMANOID 87m fails age. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity adequate."}


