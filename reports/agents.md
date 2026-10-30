# Agent desk (paper trading)

Updated 2026-10-30 04:51 UTC. Runs so far: 45. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1218 | 31 | -32722.21 | -44375.4 |
| control | macro | 26 | 46 | -43.88 | -186.86 |
| control | all | 1244 | 31 | -32766.09 | -44562.26 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: OREN long at 8.256e-05, stop 6.6048e-05, target 0.000115584, opened 2026-10-30 03:13 UTC
- control: three long at 0.0007172, stop 0.00057376, target 0.00100408, opened 2026-10-30 04:08 UTC
- control: FLOAT long at 0.0008722, stop 0.00069776, target 0.00122108, opened 2026-10-30 04:29 UTC
- control: FLUKE long at 0.0001703, stop 0.00013624, target 0.00023842, opened 2026-10-30 04:32 UTC
- control: LIQUID long at 8.291e-05, stop 6.6328e-05, target 0.000116074, opened 2026-10-30 04:51 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-30 04:51 UTC control: OPENED LIQUID long at 8.291e-05 (stop 6.6328e-05, target 0.000116074) - control: frozen v3 rules

