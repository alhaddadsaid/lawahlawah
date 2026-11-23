# Agent desk (paper trading)

Updated 2026-11-23 14:23 UTC. Runs so far: 131. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3666 | 31 | -91889.19 | -127132.95 |
| control | macro | 76 | 49 | 264.62 | -108.03 |
| control | all | 3742 | 31 | -91624.57 | -127240.98 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: CYBERLEEK long at 0.001409, stop 0.0011272, target 0.0019726, opened 2026-11-23 12:44 UTC
- control: DIGS long at 0.0002365, stop 0.0001892, target 0.0003311, opened 2026-11-23 13:12 UTC
- control: ZOL long at 8.149e-05, stop 6.5192e-05, target 0.000114086, opened 2026-11-23 13:21 UTC
- control: HUNG long at 0.0002846, stop 0.00022768, target 0.00039844, opened 2026-11-23 14:16 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED jingyu (time) P&L $27.3 normal, $16.34 pessimistic

