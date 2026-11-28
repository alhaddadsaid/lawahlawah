# Agent desk (paper trading)

Updated 2026-11-28 05:35 UTC. Runs so far: 143. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3943 | 31 | -98569.65 | -136483.16 |
| control | macro | 82 | 48 | 55.09 | -347.67 |
| control | all | 4025 | 31 | -98514.56 | -136830.83 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD short at 1.30964, stop 1.31067, target 1.30809, opened 2026-11-27 18:08 UTC
- control: RICE long at 8.57e-05, stop 6.856e-05, target 0.00011998, opened 2026-11-28 05:11 UTC
- control: Kibo long at 8.657e-05, stop 6.9256e-05, target 0.000121198, opened 2026-11-28 05:35 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-28 05:35 UTC control: OPENED Kibo long at 8.657e-05 (stop 6.9256e-05, target 0.000121198) - control: frozen v3 rules

