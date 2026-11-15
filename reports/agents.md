# Agent desk (paper trading)

Updated 2026-11-15 07:40 UTC. Runs so far: 104. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2937 | 31 | -74183.87 | -102404.62 |
| control | macro | 60 | 52 | 454.48 | 160.55 |
| control | all | 2997 | 31 | -73729.39 | -102244.07 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GTA$ long at 0.0001094, stop 8.752e-05, target 0.00015316, opened 2026-11-15 06:09 UTC
- control: penny long at 5.731e-05, stop 4.5848e-05, target 8.0234e-05, opened 2026-11-15 06:42 UTC
- control: DIGS long at 0.0001198, stop 9.584e-05, target 0.00016772, opened 2026-11-15 06:45 UTC
- control: TAIL long at 7.779e-05, stop 6.2232e-05, target 0.000108906, opened 2026-11-15 07:34 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order DIGS REJECTED by guardrails: DIGS already open

