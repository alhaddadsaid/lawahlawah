# Agent desk (paper trading)

Updated 2026-11-06 22:35 UTC. Runs so far: 73. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2077 | 31 | -54507.41 | -74412.37 |
| control | macro | 45 | 47 | -2.88 | -226.41 |
| control | all | 2122 | 31 | -54510.29 | -74638.78 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4069.6, stop 4054.07, target 4092.89, opened 2026-11-06 17:23 UTC
- control: three long at 0.0005547, stop 0.00044376, target 0.00077658, opened 2026-11-06 21:28 UTC
- control: Degen long at 0.0001328, stop 0.00010624, target 0.00018592, opened 2026-11-06 22:08 UTC
- control: TIRED long at 6.363e-05, stop 5.0904e-05, target 8.9082e-05, opened 2026-11-06 22:29 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED PI (stop) P&L $-49.48 normal, $-58.46 pessimistic

