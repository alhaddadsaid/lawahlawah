# Agent desk (paper trading)

Updated 2026-11-01 22:53 UTC. Runs so far: 56. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1496 | 31 | -39420.15 | -53752.89 |
| control | macro | 28 | 46 | -141.99 | -292.93 |
| control | all | 1524 | 31 | -39562.14 | -54045.82 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: Kim long at 0.0001644, stop 0.00013152, target 0.00023016, opened 2026-11-01 21:13 UTC
- control: BLUE long at 8.572e-05, stop 6.8576e-05, target 0.000120008, opened 2026-11-01 21:34 UTC
- control: RAM long at 0.000117, stop 9.36e-05, target 0.0001638, opened 2026-11-01 22:01 UTC
- control: ARNOLD long at 8.163e-05, stop 6.5304e-05, target 0.000114282, opened 2026-11-01 22:04 UTC
- control: FLOAT long at 0.0009485, stop 0.0007588, target 0.0013279, opened 2026-11-01 22:25 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order uni REJECTED by guardrails: desk already has the maximum open positions

