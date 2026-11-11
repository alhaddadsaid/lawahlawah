# Agent desk (paper trading)

Updated 2026-11-11 23:58 UTC. Runs so far: 92. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2610 | 31 | -66939.22 | -91991.88 |
| control | macro | 55 | 53 | 670.35 | 398.96 |
| control | all | 2665 | 31 | -66268.87 | -91592.92 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 3994.5, stop 3983.34, target 4011.24, opened 2026-11-11 21:01 UTC
- control: SQUIRE long at 0.0002523, stop 0.00020184, target 0.00035322, opened 2026-11-11 22:29 UTC
- control: X long at 8.344e-05, stop 6.6752e-05, target 0.000116816, opened 2026-11-11 23:55 UTC
- control: Mustache long at 7.055e-05, stop 5.644e-05, target 9.877e-05, opened 2026-11-11 23:58 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-11 23:58 UTC control: OPENED Mustache long at 7.055e-05 (stop 5.644e-05, target 9.877e-05) - control: frozen v3 rules

