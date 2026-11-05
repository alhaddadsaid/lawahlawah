# Agent desk (paper trading)

Updated 2026-11-05 02:31 UTC. Runs so far: 67. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1869 | 30 | -50974.81 | -68837.0 |
| control | macro | 39 | 44 | -351.26 | -551.13 |
| control | all | 1908 | 31 | -51326.07 | -69388.13 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EURUSD short at 1.12511, stop 1.12641, target 1.12316, opened 2026-11-05 01:00 UTC
- control: PIRATE long at 0.0003642, stop 0.00029136, target 0.00050988, opened 2026-11-05 02:25 UTC
- control: SLOP long at 0.0001107, stop 8.856e-05, target 0.00015498, opened 2026-11-05 02:31 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-05 02:31 UTC control: OPENED SLOP long at 0.0001107 (stop 8.856e-05, target 0.00015498) - control: frozen v3 rules

