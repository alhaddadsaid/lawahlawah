# Agent desk (paper trading)

Updated 2026-11-18 02:03 UTC. Runs so far: 113. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3201 | 31 | -80304.51 | -111075.97 |
| control | macro | 66 | 48 | 12.52 | -319.08 |
| control | all | 3267 | 31 | -80291.99 | -111395.05 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EURUSD short at 1.09938, stop 1.10065, target 1.09749, opened 2026-11-18 00:00 UTC
- control: CHAR long at 0.0001535, stop 0.0001228, target 0.0002149, opened 2026-11-18 00:46 UTC
- control: GEKKO long at 6.65e-05, stop 5.32e-05, target 9.31e-05, opened 2026-11-18 00:55 UTC
- control: Spud long at 5.572e-05, stop 4.4576e-05, target 7.8008e-05, opened 2026-11-18 02:03 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-18 02:03 UTC control: OPENED Spud long at 5.572e-05 (stop 4.4576e-05, target 7.8008e-05) - control: frozen v3 rules

