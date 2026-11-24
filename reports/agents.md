# Agent desk (paper trading)

Updated 2026-11-24 22:11 UTC. Runs so far: 134. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3735 | 31 | -93641.76 | -129548.3 |
| control | macro | 78 | 49 | 303.67 | -75.92 |
| control | all | 3813 | 31 | -93338.09 | -129624.22 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: DUVAL long at 0.0001587, stop 0.00012696, target 0.00022218, opened 2026-11-24 21:11 UTC
- control: MCAT long at 0.0001417, stop 0.00011336, target 0.00019838, opened 2026-11-24 21:17 UTC
- control: Holders long at 0.000112, stop 8.96e-05, target 0.0001568, opened 2026-11-24 21:23 UTC
- control: jingyu long at 0.0001063, stop 8.504e-05, target 0.00014882, opened 2026-11-24 22:08 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Holders REJECTED by guardrails: Holders already open

