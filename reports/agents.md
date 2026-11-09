# Agent desk (paper trading)

Updated 2026-11-09 13:26 UTC. Runs so far: 84. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2411 | 31 | -63208.13 | -86315.51 |
| control | macro | 47 | 49 | 175.47 | -53.84 |
| control | all | 2458 | 31 | -63032.66 | -86369.35 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: STOKE long at 0.0001866, stop 0.00014928, target 0.00026124, opened 2026-11-09 12:15 UTC
- control: CATPAD long at 0.0001323, stop 0.00010584, target 0.00018522, opened 2026-11-09 12:28 UTC
- control: BANK long at 0.0001215, stop 9.72e-05, target 0.0001701, opened 2026-11-09 13:16 UTC
- control: PIRATE long at 0.0004394, stop 0.00035152, target 0.00061516, opened 2026-11-09 13:20 UTC
- control: CURVD long at 5.64e-05, stop 4.512e-05, target 7.896e-05, opened 2026-11-09 13:23 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order shiken REJECTED by guardrails: desk already has the maximum open positions

