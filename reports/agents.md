# Agent desk (paper trading)

Updated 2026-11-18 07:40 UTC. Runs so far: 114. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3223 | 31 | -80895.11 | -111877.06 |
| control | macro | 66 | 48 | 12.52 | -319.08 |
| control | all | 3289 | 31 | -80882.59 | -112196.14 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EURUSD short at 1.09938, stop 1.10065, target 1.09749, opened 2026-11-18 00:00 UTC
- control: GOLD short at 3790, stop 3807.63, target 3763.56, opened 2026-11-18 04:08 UTC
- control: COIL long at 0.0001819, stop 0.00014552, target 0.00025466, opened 2026-11-18 07:28 UTC
- control: Calypso long at 7.5e-05, stop 6e-05, target 0.000105, opened 2026-11-18 07:40 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-18 07:40 UTC control: OPENED Calypso long at 7.5e-05 (stop 6e-05, target 0.000105) - control: frozen v3 rules

