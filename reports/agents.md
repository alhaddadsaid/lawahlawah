# Agent desk (paper trading)

Updated 2026-11-27 23:31 UTC. Runs so far: 142. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3921 | 31 | -98281.26 | -135976.56 |
| control | macro | 82 | 48 | 55.09 | -347.67 |
| control | all | 4003 | 31 | -98226.17 | -136324.23 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD short at 1.30964, stop 1.31067, target 1.30809, opened 2026-11-27 18:08 UTC
- control: Zero long at 0.0001564, stop 0.00012512, target 0.00021896, opened 2026-11-27 22:33 UTC
- control: Zhaki long at 9.071e-05, stop 7.2568e-05, target 0.000126994, opened 2026-11-27 22:39 UTC
- control: BASKET long at 0.00032, stop 0.000256, target 0.000448, opened 2026-11-27 23:28 UTC
- control: Split long at 0.0001368, stop 0.00010944, target 0.00019152, opened 2026-11-27 23:31 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-27 23:31 UTC control: OPENED Split long at 0.0001368 (stop 0.00010944, target 0.00019152) - control: frozen v3 rules

