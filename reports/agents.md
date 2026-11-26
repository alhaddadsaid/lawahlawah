# Agent desk (paper trading)

Updated 2026-11-26 17:27 UTC. Runs so far: 139. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3835 | 31 | -96485.0 | -133344.29 |
| control | macro | 80 | 49 | 295.36 | -95.35 |
| control | all | 3915 | 31 | -96189.64 | -133439.64 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: SITTINGDUK long at 8.229e-05, stop 6.5832e-05, target 0.000115206, opened 2026-11-26 16:51 UTC
- control: Zero long at 0.0001588, stop 0.00012704, target 0.00022232, opened 2026-11-26 16:54 UTC
- control: GBPUSD short at 1.31055, stop 1.31158, target 1.309, opened 2026-11-26 17:00 UTC
- control: DIGS long at 0.0002538, stop 0.00020304, target 0.00035532, opened 2026-11-26 17:12 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED duk (stop) P&L $-58.01 normal, $-66.78 pessimistic

