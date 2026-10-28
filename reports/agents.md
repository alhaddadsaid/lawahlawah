# Agent desk (paper trading)

Updated 2026-10-28 17:15 UTC. Runs so far: 39. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 998 | 32 | -25725.66 | -35301.79 |
| control | macro | 23 | 48 | 31.31 | -98.04 |
| control | all | 1021 | 32 | -25694.35 | -35399.83 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: e/acc long at 0.000504, stop 0.0004032, target 0.0007056, opened 2026-10-28 16:17 UTC
- control: Robotaxi long at 0.0001519, stop 0.00012152, target 0.00021266, opened 2026-10-28 16:23 UTC
- control: MOGZBOT long at 2.347e-06, stop 1.8776e-06, target 3.2858e-06, opened 2026-10-28 16:50 UTC
- control: Nothing long at 0.0002462, stop 0.00019696, target 0.00034468, opened 2026-10-28 17:03 UTC
- control: Frongus long at 0.0001197, stop 9.576e-05, target 0.00016758, opened 2026-10-28 17:15 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-28 17:15 UTC control: OPENED Frongus long at 0.0001197 (stop 9.576e-05, target 0.00016758) - control: frozen v3 rules

