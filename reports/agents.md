# Agent desk (paper trading)

Updated 2026-11-11 03:09 UTC. Runs so far: 89. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2535 | 31 | -65586.47 | -89904.6 |
| control | macro | 52 | 50 | 233.2 | -26.95 |
| control | all | 2587 | 31 | -65353.27 | -89931.55 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4042.7, stop 4024.89, target 4069.41, opened 2026-11-10 21:02 UTC
- control: EURUSD short at 1.11607, stop 1.11732, target 1.11419, opened 2026-11-10 22:00 UTC
- control: 我的刀盾 long at 0.0002053, stop 0.00016424, target 0.00028742, opened 2026-11-11 02:57 UTC
- control: PAID long at 0.00134, stop 0.001072, target 0.001876, opened 2026-11-11 03:09 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-11 03:09 UTC control: OPENED PAID long at 0.00134 (stop 0.001072, target 0.001876) - control: frozen v3 rules

