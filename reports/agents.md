# Agent desk (paper trading)

Updated 2026-11-01 20:58 UTC. Runs so far: 56. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1483 | 31 | -39212.39 | -53417.13 |
| control | macro | 28 | 46 | -141.99 | -292.93 |
| control | all | 1511 | 31 | -39354.38 | -53710.06 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: KIM long at 0.0001877, stop 0.00015016, target 0.00026278, opened 2026-11-01 19:05 UTC
- control: BLUE long at 0.0001509, stop 0.00012072, target 0.00021126, opened 2026-11-01 19:54 UTC
- control: FLOAT long at 0.0006014, stop 0.00048112, target 0.00084196, opened 2026-11-01 20:18 UTC
- control: Kim long at 0.0002407, stop 0.00019256, target 0.00033698, opened 2026-11-01 20:21 UTC
- control: PI long at 9.009e-05, stop 7.2072e-05, target 0.000126126, opened 2026-11-01 20:58 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-01 20:58 UTC control: OPENED PI long at 9.009e-05 (stop 7.2072e-05, target 0.000126126) - control: frozen v3 rules

