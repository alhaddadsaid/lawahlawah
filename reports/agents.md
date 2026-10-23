# Agent desk (paper trading)

Updated 2026-10-23 06:07 UTC. Runs so far: 16. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 249 | 29 | -8326.58 | -10666.83 |
| control | macro | 7 | 71 | 471.34 | 438.17 |
| control | all | 256 | 30 | -7855.24 | -10228.66 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: EURUSD long at 1.12196, stop 1.12077, target 1.12374, opened 2026-10-22 20:00 UTC
- control: OA long at 0.0002151, stop 0.00017208, target 0.00030114, opened 2026-10-23 05:49 UTC
- control: POOT long at 8.273e-05, stop 6.6184e-05, target 0.000115822, opened 2026-10-23 05:52 UTC
- control: zonki long at 0.0001279, stop 0.00010232, target 0.00017906, opened 2026-10-23 06:01 UTC
- control: MEOWE long at 0.0002185, stop 0.0001748, target 0.0003059, opened 2026-10-23 06:07 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

- 2026-10-23 06:07 UTC control: OPENED MEOWE long at 0.0002185 (stop 0.0001748, target 0.0003059) - control: frozen v3 rules

