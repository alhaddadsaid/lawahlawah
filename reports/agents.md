# Agent desk (paper trading)

Updated 2026-11-20 04:33 UTC. Runs so far: 120. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3373 | 31 | -84936.44 | -117353.23 |
| control | macro | 71 | 49 | 223.65 | -125.55 |
| control | all | 3444 | 31 | -84712.79 | -117478.78 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EMBER long at 0.0002835, stop 0.0002268, target 0.0003969, opened 2026-11-20 02:42 UTC
- control: DacityCoin long at 0.0003472, stop 0.00027776, target 0.00048608, opened 2026-11-20 03:50 UTC
- control: PIPI long at 0.0001364, stop 0.00010912, target 0.00019096, opened 2026-11-20 04:02 UTC
- control: HNYDRIP long at 9.663e-05, stop 7.7304e-05, target 0.000135282, opened 2026-11-20 04:26 UTC
- control: AI long at 5.96e-05, stop 4.768e-05, target 8.344e-05, opened 2026-11-20 04:30 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order CATMARIO REJECTED by guardrails: desk already has the maximum open positions

