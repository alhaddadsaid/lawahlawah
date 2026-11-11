# Agent desk (paper trading)

Updated 2026-11-11 12:30 UTC. Runs so far: 91. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2565 | 31 | -66018.48 | -90633.22 |
| control | macro | 54 | 52 | 524.8 | 257.86 |
| control | all | 2619 | 31 | -65493.68 | -90375.36 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD short at 4065.3, stop 4076.54, target 4048.45, opened 2026-11-11 07:02 UTC
- control: GTA long at 0.0001102, stop 8.816e-05, target 0.00015428, opened 2026-11-11 10:56 UTC
- control: DIGS long at 0.0001221, stop 9.768e-05, target 0.00017094, opened 2026-11-11 11:02 UTC
- control: woohao long at 0.0001855, stop 0.0001484, target 0.0002597, opened 2026-11-11 12:30 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-11 12:30 UTC control: OPENED woohao long at 0.0001855 (stop 0.0001484, target 0.0002597) - control: frozen v3 rules

