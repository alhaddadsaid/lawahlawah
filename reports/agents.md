# Agent desk (paper trading)

Updated 2026-11-20 22:18 UTC. Runs so far: 122. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3439 | 31 | -86274.93 | -119334.39 |
| control | macro | 73 | 49 | 253.03 | -107.23 |
| control | all | 3512 | 31 | -86021.9 | -119441.62 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: Punch long at 0.0002274, stop 0.00018192, target 0.00031836, opened 2026-11-20 20:53 UTC
- control: GBPUSD long at 1.30811, stop 1.30687, target 1.30997, opened 2026-11-20 21:02 UTC
- control: PATRICK long at 0.0001356, stop 0.00010848, target 0.00018984, opened 2026-11-20 21:48 UTC
- control: Trader long at 0.0001888, stop 0.00015104, target 0.00026432, opened 2026-11-20 22:09 UTC
- control: Singularity long at 0.0001017, stop 8.136e-05, target 0.00014238, opened 2026-11-20 22:15 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order monke  REJECTED by guardrails: desk already has the maximum open positions

