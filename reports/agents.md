# Agent desk (paper trading)

Updated 2026-11-23 00:08 UTC. Runs so far: 129. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3621 | 31 | -90488.66 | -125306.78 |
| control | macro | 74 | 49 | 250.49 | -114.61 |
| control | all | 3695 | 31 | -90238.17 | -125421.39 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: snowball long at 8.546e-05, stop 6.8368e-05, target 0.000119644, opened 2026-11-22 23:07 UTC
- control: DIGS long at 0.0002306, stop 0.00018448, target 0.00032284, opened 2026-11-22 23:22 UTC
- control: Max long at 0.0004559, stop 0.00036472, target 0.00063826, opened 2026-11-22 23:28 UTC
- control: MCAT long at 0.0004674, stop 0.00037392, target 0.00065436, opened 2026-11-23 00:08 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED XMAS (target) P&L $68.0 normal, $56.0 pessimistic

