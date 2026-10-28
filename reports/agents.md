# Agent desk (paper trading)

Updated 2026-10-28 06:59 UTC. Runs so far: 37. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 951 | 32 | -24266.05 | -33397.56 |
| control | macro | 19 | 42 | -261.01 | -363.42 |
| control | all | 970 | 32 | -24527.06 | -33760.98 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- team: GBPUSD short at 1.32892, stop 1.334, target 1.324, opened 2026-10-28 06:14 UTC
- control: Robotaxi long at 7.066e-05, stop 5.6528e-05, target 9.8924e-05, opened 2026-10-28 06:04 UTC
- control: DORA long at 5.987e-05, stop 4.7896e-05, target 8.3818e-05, opened 2026-10-28 06:14 UTC
- control: wiener long at 5.537e-05, stop 4.4296e-05, target 7.7518e-05, opened 2026-10-28 06:44 UTC
- control: Frongus long at 0.0002501, stop 0.00020008, target 0.00035014, opened 2026-10-28 06:53 UTC
- control: SI long at 0.0001892, stop 0.00015136, target 0.00026488, opened 2026-10-28 06:59 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-28 06:59 UTC control: OPENED SI long at 0.0001892 (stop 0.00015136, target 0.00026488) - control: frozen v3 rules

