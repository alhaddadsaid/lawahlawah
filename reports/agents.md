# Agent desk (paper trading)

Updated 2026-10-26 09:18 UTC. Runs so far: 29. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 682 | 31 | -19138.09 | -25642.13 |
| control | macro | 10 | 50 | 72.9 | 22.91 |
| control | all | 692 | 31 | -19065.19 | -25619.22 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Bow long at 8.031e-05, stop 6.4248e-05, target 0.000112434, opened 2026-10-26 08:18 UTC
- control: PRESIDENT long at 0.0001841, stop 0.00014728, target 0.00025774, opened 2026-10-26 08:39 UTC
- control: STM long at 0.0001449, stop 0.00011592, target 0.00020286, opened 2026-10-26 09:16 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED Bunnett (stop) P&L $-62.87 normal, $-71.51 pessimistic

