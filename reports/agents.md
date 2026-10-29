# Agent desk (paper trading)

Updated 2026-10-29 14:44 UTC. Runs so far: 42. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1132 | 32 | -29373.37 | -40230.3 |
| control | macro | 25 | 44 | -187.08 | -325.97 |
| control | all | 1157 | 32 | -29560.45 | -40556.27 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: PODCAT long at 0.0002111, stop 0.00016888, target 0.00029554, opened 2026-10-29 14:23 UTC
- control: CPU long at 0.0001407, stop 0.00011256, target 0.00019698, opened 2026-10-29 14:35 UTC
- control: OREN long at 0.0002015, stop 0.0001612, target 0.0002821, opened 2026-10-29 14:41 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED PINO (stop) P&L $-50.11 normal, $-59.08 pessimistic

