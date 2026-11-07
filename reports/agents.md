# Agent desk (paper trading)

Updated 2026-11-07 23:08 UTC. Runs so far: 78. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2203 | 30 | -58977.78 | -80060.38 |
| control | macro | 46 | 48 | 28.03 | -198.72 |
| control | all | 2249 | 31 | -58949.75 | -80259.1 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: FUSE long at 0.0001783, stop 0.00014264, target 0.00024962, opened 2026-11-07 22:34 UTC
- control: Percolator long at 0.000645, stop 0.000516, target 0.000903, opened 2026-11-07 22:50 UTC
- control: TAOLF long at 0.0004395, stop 0.0003516, target 0.0006153, opened 2026-11-07 22:59 UTC
- control: Jose long at 0.0003381, stop 0.00027048, target 0.00047334, opened 2026-11-07 23:08 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-07 23:08 UTC control: OPENED Jose long at 0.0003381 (stop 0.00027048, target 0.00047334) - control: frozen v3 rules

