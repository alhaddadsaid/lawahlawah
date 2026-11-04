# Agent desk (paper trading)

Updated 2026-11-04 02:29 UTC. Runs so far: 63. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1745 | 31 | -46726.85 | -63426.14 |
| control | macro | 35 | 43 | -426.72 | -614.59 |
| control | all | 1780 | 31 | -47153.57 | -64040.73 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: CAPY long at 0.0003407, stop 0.00027256, target 0.00047698, opened 2026-11-04 00:48 UTC
- control: GOLD long at 3958.4, stop 3940.09, target 3985.87, opened 2026-11-04 02:02 UTC
- control: ARNOLD long at 0.00012, stop 9.6e-05, target 0.000168, opened 2026-11-04 02:11 UTC
- control: CHICKPOT long at 8.435e-05, stop 6.748e-05, target 0.00011809, opened 2026-11-04 02:29 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-04 02:29 UTC control: OPENED CHICKPOT long at 8.435e-05 (stop 6.748e-05, target 0.00011809) - control: frozen v3 rules

