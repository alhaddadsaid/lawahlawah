# Agent desk (paper trading)

Updated 2026-10-28 22:38 UTC. Runs so far: 40. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1031 | 32 | -26789.89 | -36677.2 |
| control | macro | 23 | 48 | 31.31 | -98.04 |
| control | all | 1054 | 32 | -26758.58 | -36775.24 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: three long at 0.0004739, stop 0.00037912, target 0.00066346, opened 2026-10-28 21:16 UTC
- control: GBPUSD long at 1.33245, stop 1.33106, target 1.33452, opened 2026-10-28 22:02 UTC
- control: FOMOCAT$ long at 0.0001006, stop 8.048e-05, target 0.00014084, opened 2026-10-28 22:08 UTC
- control: Something long at 8.373e-05, stop 6.6984e-05, target 0.000117222, opened 2026-10-28 22:27 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED Rapport (stop) P&L $-146.08 normal, $-152.59 pessimistic

