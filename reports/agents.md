# Agent desk (paper trading)

Updated 2026-10-25 20:27 UTC. Runs so far: 27. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 598 | 32 | -16398.71 | -22111.47 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 607 | 32 | -16205.34 | -21960.56 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: goon long at 6.965e-05, stop 5.572e-05, target 9.751e-05, opened 2026-10-25 19:17 UTC
- control: LAUNCHCAT long at 0.0001668, stop 0.00013344, target 0.00023352, opened 2026-10-25 19:41 UTC
- control: Bunnett long at 0.0001933, stop 0.00015464, target 0.00027062, opened 2026-10-25 20:03 UTC
- control: AMC long at 0.0001641, stop 0.00013128, target 0.00022974, opened 2026-10-25 20:06 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order AMC REJECTED by guardrails: AMC already open

