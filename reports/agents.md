# Agent desk (paper trading)

Updated 2026-10-28 12:30 UTC. Runs so far: 38. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 982 | 32 | -25245.54 | -34669.89 |
| control | macro | 20 | 40 | -392.29 | -502.43 |
| control | all | 1002 | 32 | -25637.83 | -35172.32 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: N64 long at 8.428e-05, stop 6.7424e-05, target 0.000117992, opened 2026-10-28 11:20 UTC
- control: EURUSD long at 1.11321, stop 1.11263, target 1.11409, opened 2026-10-28 12:00 UTC
- control: OpenBot long at 6.499e-05, stop 5.1992e-05, target 9.0986e-05, opened 2026-10-28 12:27 UTC
- control: Xingxing long at 0.0001771, stop 0.00014168, target 0.00024794, opened 2026-10-28 12:30 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-28 12:30 UTC control: OPENED Xingxing long at 0.0001771 (stop 0.00014168, target 0.00024794) - control: frozen v3 rules

