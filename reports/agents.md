# Agent desk (paper trading)

Updated 2026-11-21 04:03 UTC. Runs so far: 123. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3469 | 31 | -87241.07 | -120583.43 |
| control | macro | 73 | 49 | 253.03 | -107.23 |
| control | all | 3542 | 31 | -86988.04 | -120690.66 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.30811, stop 1.30687, target 1.30997, opened 2026-11-20 21:02 UTC
- control: PAID long at 0.001049, stop 0.0008392, target 0.0014686, opened 2026-11-21 02:20 UTC
- control: PATRICK long at 0.0001037, stop 8.296e-05, target 0.00014518, opened 2026-11-21 03:24 UTC
- control: CYBERLEEK long at 0.001645, stop 0.001316, target 0.002303, opened 2026-11-21 03:45 UTC
- control: PENNY long at 0.000141, stop 0.0001128, target 0.0001974, opened 2026-11-21 04:03 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-21 04:03 UTC control: OPENED PENNY long at 0.000141 (stop 0.0001128, target 0.0001974) - control: frozen v3 rules

