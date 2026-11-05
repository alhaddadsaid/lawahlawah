# Agent desk (paper trading)

Updated 2026-11-05 17:54 UTC. Runs so far: 69. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1931 | 31 | -51656.97 | -70137.56 |
| control | macro | 41 | 44 | -324.4 | -534.42 |
| control | all | 1972 | 31 | -51981.37 | -70671.98 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: AI long at 0.0001626, stop 0.00013008, target 0.00022764, opened 2026-11-05 16:56 UTC
- control: ALON long at 0.002428, stop 0.0019424, target 0.0033992, opened 2026-11-05 17:08 UTC
- control: PIRATE long at 0.0002794, stop 0.00022352, target 0.00039116, opened 2026-11-05 17:15 UTC
- control: ZELDA long at 8.108e-05, stop 6.4864e-05, target 0.000113512, opened 2026-11-05 17:48 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

## Run ended 2026-11-05 17:54 UTC

