# Agent desk (paper trading)

Updated 2026-11-19 22:01 UTC. Runs so far: 119. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3346 | 31 | -84432.27 | -116585.06 |
| control | macro | 71 | 49 | 223.65 | -125.55 |
| control | all | 3417 | 31 | -84208.62 | -116710.61 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: AI long at 8.684e-05, stop 6.9472e-05, target 0.000121576, opened 2026-11-19 21:28 UTC
- control: ONI long at 8.322e-05, stop 6.6576e-05, target 0.000116508, opened 2026-11-19 21:37 UTC
- control: CYBERLEEK long at 0.001827, stop 0.0014616, target 0.0025578, opened 2026-11-19 21:53 UTC
- control: PIPI long at 0.0002385, stop 0.0001908, target 0.0003339, opened 2026-11-19 21:56 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED CATMARIO (stop) P&L $-81.65 normal, $-89.81 pessimistic

