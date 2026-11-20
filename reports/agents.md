# Agent desk (paper trading)

Updated 2026-11-20 07:50 UTC. Runs so far: 120. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3394 | 31 | -85127.31 | -117754.59 |
| control | macro | 71 | 49 | 223.65 | -125.55 |
| control | all | 3465 | 31 | -84903.66 | -117880.14 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: CATMARIO long at 0.0001323, stop 0.00010584, target 0.00018522, opened 2026-11-20 06:31 UTC
- control: Apocrycoin long at 0.0001761, stop 0.00014088, target 0.00024654, opened 2026-11-20 06:49 UTC
- control: QUATS long at 6.013e-05, stop 4.8104e-05, target 8.4182e-05, opened 2026-11-20 07:05 UTC
- control: apocry  long at 9.329e-05, stop 7.4632e-05, target 0.000130606, opened 2026-11-20 07:14 UTC
- control: PATRICK long at 6.468e-05, stop 5.1744e-05, target 9.0552e-05, opened 2026-11-20 07:41 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order apocry  REJECTED by guardrails: desk already has the maximum open positions

