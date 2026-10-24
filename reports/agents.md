# Agent desk (paper trading)

Updated 2026-10-24 11:58 UTC. Runs so far: 21. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 422 | 31 | -11851.47 | -15875.66 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 431 | 31 | -11658.1 | -15724.75 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: YMB long at 0.0003175, stop 0.000254, target 0.0004445, opened 2026-10-24 10:08 UTC
- control: ELIZABETH long at 0.0001678, stop 0.00013424, target 0.00023492, opened 2026-10-24 10:54 UTC
- control: COIL long at 6.078e-05, stop 4.8624e-05, target 8.5092e-05, opened 2026-10-24 11:43 UTC
- control: MERGE long at 0.0001016, stop 8.128e-05, target 0.00014224, opened 2026-10-24 11:55 UTC
- control: HUG long at 0.0001661, stop 0.00013288, target 0.00023254, opened 2026-10-24 11:58 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

## Run ended 2026-10-24 11:58 UTC

