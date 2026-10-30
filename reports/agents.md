# Agent desk (paper trading)

Updated 2026-10-30 16:39 UTC. Runs so far: 47. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1282 | 31 | -34574.68 | -46836.76 |
| control | macro | 27 | 44 | -173.82 | -322.19 |
| control | all | 1309 | 31 | -34748.5 | -47158.95 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: PINK long at 0.0001059, stop 8.472e-05, target 0.00014826, opened 2026-10-30 14:41 UTC
- control: FLUKE long at 0.0001607, stop 0.00012856, target 0.00022498, opened 2026-10-30 15:18 UTC
- control: SPACECAT long at 0.0001475, stop 0.000118, target 0.0002065, opened 2026-10-30 16:34 UTC
- control: CATPAD long at 7.334e-05, stop 5.8672e-05, target 0.000102676, opened 2026-10-30 16:37 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED HEXN (target) P&L $68.0 normal, $56.0 pessimistic

