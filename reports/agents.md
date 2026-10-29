# Agent desk (paper trading)

Updated 2026-10-29 04:06 UTC. Runs so far: 41. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1066 | 32 | -27287.76 | -37521.26 |
| control | macro | 24 | 46 | -78.34 | -212.02 |
| control | all | 1090 | 32 | -27366.1 | -37733.28 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: OPUS long at 0.0007083, stop 0.00056664, target 0.00099162, opened 2026-10-29 03:42 UTC
- control: Tucker long at 6.095e-05, stop 4.876e-05, target 8.533e-05, opened 2026-10-29 03:51 UTC
- control: Rapport long at 4.216e-05, stop 3.3728e-05, target 5.9024e-05, opened 2026-10-29 04:00 UTC
- control: SLEGO long at 0.0001691, stop 0.00013528, target 0.00023674, opened 2026-10-29 04:03 UTC
- control: CPU long at 0.0003107, stop 0.00024856, target 0.00043498, opened 2026-10-29 04:06 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-29 04:06 UTC control: OPENED CPU long at 0.0003107 (stop 0.00024856, target 0.00043498) - control: frozen v3 rules

