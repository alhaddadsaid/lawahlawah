# Agent desk (paper trading)

Updated 2026-10-23 10:33 UTC. Runs so far: 17. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 276 | 29 | -9047.4 | -11646.07 |
| control | macro | 8 | 62 | 327.77 | 290.38 |
| control | all | 284 | 30 | -8719.63 | -11355.69 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: MEOWE long at 9.683e-05, stop 7.7464e-05, target 0.000135562, opened 2026-10-23 08:59 UTC
- control: GUST long at 0.0001495, stop 0.0001196, target 0.0002093, opened 2026-10-23 09:29 UTC
- control: zonki long at 0.0001222, stop 9.776e-05, target 0.00017108, opened 2026-10-23 10:30 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

### 2026-10-23 10:33 UTC team macro (gold/forex), spent today $0.016

Lead: No trade. Gold is 4038.6, well below the 4090 hourly-close trigger. EURUSD is 1.11995, above the 1.11894 5d low, so no confirmed break. GBPUSD is 1.33777, below the 1.3418 trigger. No high-impact events in 24h. Scout and FX Scout have no new edge, and costs would eat any small move. Staying flat.

{"orders": [], "close": [], "note": "10:33 flat, no orders. Gold 4038.6 needs hourly close >4090 (long 1%, stop 4070, target 4120, max 12h). Note 5d low now 4000.9, so stop-levels from earlier notes may be stale. EURUSD 1.11995 needs hourly close <1.11894 (short only if confirmed, no event in 24h). GBPUSD 1.33777 needs hourly close >1.3418 (long test). Meme desk: no fresh data this cycle, nothing to test."}


