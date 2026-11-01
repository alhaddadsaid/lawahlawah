# Agent desk (paper trading)

Updated 2026-11-01 14:02 UTC. Runs so far: 55. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1444 | 31 | -38114.97 | -51947.81 |
| control | macro | 28 | 46 | -141.99 | -292.93 |
| control | all | 1472 | 32 | -38256.96 | -52240.74 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: KIM long at 0.0001884, stop 0.00015072, target 0.00026376, opened 2026-11-01 12:28 UTC
- control: RAM long at 8.687e-05, stop 6.9496e-05, target 0.000121618, opened 2026-11-01 13:08 UTC
- control: WASTED long at 0.0001022, stop 8.176e-05, target 0.00014308, opened 2026-11-01 13:14 UTC
- control: BNB long at 5.232e-05, stop 4.1856e-05, target 7.3248e-05, opened 2026-11-01 13:47 UTC
- control: REGRETAMINE long at 8.86e-05, stop 7.088e-05, target 0.00012404, opened 2026-11-01 13:59 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order REGRETAMINE REJECTED by guardrails: desk already has the maximum open positions
- control: order GBPUSD REJECTED by guardrails: desk already has the maximum open positions

