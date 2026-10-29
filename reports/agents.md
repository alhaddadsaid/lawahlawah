# Agent desk (paper trading)

Updated 2026-10-29 15:42 UTC. Runs so far: 43. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1139 | 32 | -29514.63 | -40439.74 |
| control | macro | 25 | 44 | -187.08 | -325.97 |
| control | all | 1164 | 32 | -29701.71 | -40765.71 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33565, stop 1.33418, target 1.33785, opened 2026-10-29 15:00 UTC
- control: PODCAT long at 0.0001376, stop 0.00011008, target 0.00019264, opened 2026-10-29 15:12 UTC
- control: CHILLHOUSE long at 0.0009126, stop 0.00073008, target 0.00127764, opened 2026-10-29 15:27 UTC
- control: ELOOONG long at 0.0001494, stop 0.00011952, target 0.00020916, opened 2026-10-29 15:42 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED PURR (target) P&L $68.0 normal, $56.0 pessimistic

