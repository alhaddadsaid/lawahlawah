# Agent desk (paper trading)

Updated 2026-10-30 22:28 UTC. Runs so far: 48. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1320 | 31 | -35767.57 | -48388.8 |
| control | macro | 27 | 44 | -173.82 | -322.19 |
| control | all | 1347 | 31 | -35941.39 | -48710.99 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD short at 3905.6, stop 3925.08, target 3876.38, opened 2026-10-30 17:01 UTC
- control: FLUKE long at 7.598e-05, stop 6.0784e-05, target 0.000106372, opened 2026-10-30 21:24 UTC
- control: Jason long at 6.581e-05, stop 5.2648e-05, target 9.2134e-05, opened 2026-10-30 22:13 UTC
- control: ONBOARD long at 0.0001638, stop 0.00013104, target 0.00022932, opened 2026-10-30 22:19 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED Nought (stop) P&L $-52.54 normal, $-61.45 pessimistic

