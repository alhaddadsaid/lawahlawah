# Agent desk (paper trading)

Updated 2026-10-23 08:40 UTC. Runs so far: 17. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 263 | 29 | -8771.57 | -11243.98 |
| control | macro | 8 | 62 | 327.77 | 290.38 |
| control | all | 271 | 30 | -8443.8 | -10953.6 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: POOT long at 6.946e-05, stop 5.5568e-05, target 9.7244e-05, opened 2026-10-23 07:36 UTC
- control: PHP long at 0.000196, stop 0.0001568, target 0.0002744, opened 2026-10-23 08:28 UTC
- control: GUST long at 0.0001466, stop 0.00011728, target 0.00020524, opened 2026-10-23 08:31 UTC
- control: zonki long at 0.0001114, stop 8.912e-05, target 0.00015596, opened 2026-10-23 08:34 UTC
- control: MEOWE long at 0.0001256, stop 0.00010048, target 0.00017584, opened 2026-10-23 08:40 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

- 2026-10-23 08:40 UTC control: OPENED MEOWE long at 0.0001256 (stop 0.00010048, target 0.00017584) - control: frozen v3 rules

