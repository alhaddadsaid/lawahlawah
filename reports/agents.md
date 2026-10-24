# Agent desk (paper trading)

Updated 2026-10-24 13:49 UTC. Runs so far: 22. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 435 | 30 | -12561.89 | -16701.2 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 444 | 30 | -12368.52 | -16550.29 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: HUG long at 0.0001031, stop 8.248e-05, target 0.00014434, opened 2026-10-24 12:32 UTC
- control: YMB long at 0.0002047, stop 0.00016376, target 0.00028658, opened 2026-10-24 13:03 UTC
- control: PHP long at 0.0001722, stop 0.00013776, target 0.00024108, opened 2026-10-24 13:06 UTC
- control: SHADOW long at 0.0002092, stop 0.00016736, target 0.00029288, opened 2026-10-24 13:30 UTC
- control: mil long at 0.0001606, stop 0.00012848, target 0.00022484, opened 2026-10-24 13:49 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-24 13:49 UTC control: OPENED mil long at 0.0001606 (stop 0.00012848, target 0.00022484) - control: frozen v3 rules

