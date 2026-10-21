# Agent desk (paper trading)

Updated 2026-10-21 18:55 UTC. Runs so far: 10. Model: claude-haiku-5-5.

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
- control: ALPENGLOW long at 9.25e-05, stop 7.4e-05, target 0.0001295, opened 2026-10-21 18:10 UTC
- control: DARKCAT long at 8.757e-05, stop 7.0056e-05, target 0.000122598, opened 2026-10-21 18:34 UTC
- control: Pokémon long at 0.0004, stop 0.00032, target 0.00056, opened 2026-10-21 18:40 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 18:55 UTC team all (memecoins), spent today $0.110

Lead: Hold. No memecoin passes the under-10-minute filter: PLAZA is 82 minutes old with h1 at -5.8%, and the rest are older. Scout: No fresh macro catalyst beyond crypto headlines, which are regulatory and not gold-specific. Sniper: Gold 41 stays on its existing stop 4095 and target 4180, about 16 hours left. Watch list: the under-10m, h1 above +1000%, top10 below 15% filter, with liquidity OK. Cost discipline matters, since the journal is net negative after costs.

{"orders": [], "close": [], "note": "18:55 no new orders. Hold gold 41 (stop 4095, target 4180, price 4156.2, ~15.8h left). Memecoin filter empty again: PLAZA 82m old, h1 -5.8%, fails. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK. Journal still net negative after costs; keep sizing small and test the under-10m hypothesis only when a coin passes."}

- control: order Pokémon REJECTED by guardrails: Pokémon already open

