# Agent desk (paper trading)

Updated 2026-11-05 15:52 UTC. Runs so far: 69. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1921 | 31 | -51209.81 | -69599.3 |
| control | macro | 41 | 44 | -324.4 | -534.42 |
| control | all | 1962 | 31 | -51534.21 | -70133.72 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: WOJAK long at 0.001194, stop 0.0009552, target 0.0016716, opened 2026-11-05 14:42 UTC
- control: WEALTH long at 0.0001455, stop 0.0001164, target 0.0002037, opened 2026-11-05 15:43 UTC
- control: bul long at 9.832e-05, stop 7.8656e-05, target 0.000137648, opened 2026-11-05 15:52 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-05 15:52 UTC control: OPENED bul long at 9.832e-05 (stop 7.8656e-05, target 0.000137648) - control: frozen v3 rules

