# Agent desk (paper trading)

Updated 2026-11-05 00:30 UTC. Runs so far: 67. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1851 | 30 | -50281.77 | -67977.1 |
| control | macro | 38 | 45 | -241.49 | -437.9 |
| control | all | 1889 | 31 | -50523.26 | -68415.0 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EURUSD short at 1.12334, stop 1.12479, target 1.12118, opened 2026-11-04 21:02 UTC
- control: SLOP long at 5.951e-05, stop 4.7608e-05, target 8.3314e-05, opened 2026-11-05 00:18 UTC
- control: STONKS long at 0.0005729, stop 0.00045832, target 0.00080206, opened 2026-11-05 00:27 UTC
- control: AI long at 0.0001497, stop 0.00011976, target 0.00020958, opened 2026-11-05 00:30 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED GOLD (target) P&L $147.61 normal, $145.23 pessimistic

