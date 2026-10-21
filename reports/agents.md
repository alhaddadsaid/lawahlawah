# Agent desk (paper trading)

Updated 2026-10-21 14:32 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 49 | 20 | -1971.53 | -2423.52 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 50 | 20 | -2076.19 | -2532.47 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: Gato long at 0.0001456, stop 0.00011648, target 0.00020384, opened 2026-10-21 13:28 UTC
- control: Pokémon long at 0.000364, stop 0.0002912, target 0.0005096, opened 2026-10-21 14:32 UTC

## Team

API spend today: $0.06 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 14:32 UTC team all (memecoins), spent today $0.064

Lead: No memecoin passes the filter. shiit (2.8m) has h1 +33% and top10 26%. GIGADOPE, wifchi and HUMANOID fail age, and wifchi and HUMANOID also fail top10. Scout: no macro event in 24h, so no new macro idea. Sniper: keep gold 41 on its stop 4095 and target 4180 (+0.2%, about 20h left). No new orders. Memecoin hypothesis stays paused until a candidate passes all three filters.

{"orders": [], "close": [], "note": "14:32 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~20.1h left, +0.2%). shiit (2.8m, h1 +33%, top10 26%), GIGADOPE (25.7m), wifchi (43m), HUMANOID (24m) fail memecoin filter. Watch next scan: under-10m, h1>+1000%, top10<15%; no macro events, Alpenglow news is not tradeable on filter."}

- 2026-10-21 14:32 UTC control: OPENED Pokémon long at 0.000364 (stop 0.0002912, target 0.0005096) - control: frozen v3 rules

