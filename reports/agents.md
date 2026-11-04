# Agent desk (paper trading)

Updated 2026-11-04 03:55 UTC. Runs so far: 64. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1756 | 31 | -47151.77 | -63952.99 |
| control | macro | 36 | 42 | -534.29 | -724.89 |
| control | all | 1792 | 31 | -47686.06 | -64677.88 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: ARNOLD long at 0.00012, stop 9.6e-05, target 0.000168, opened 2026-11-04 02:11 UTC
- control: STONKS long at 0.0008589, stop 0.00068712, target 0.00120246, opened 2026-11-04 02:39 UTC
- control: EURUSD short at 1.12562, stop 1.12707, target 1.12344, opened 2026-11-04 03:00 UTC
- control: L0ng long at 6.599e-05, stop 5.2792e-05, target 9.2386e-05, opened 2026-11-04 03:52 UTC
- control: CAPY long at 0.0005621, stop 0.00044968, target 0.00078694, opened 2026-11-04 03:55 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-04 03:55 UTC control: OPENED CAPY long at 0.0005621 (stop 0.00044968, target 0.00078694) - control: frozen v3 rules

