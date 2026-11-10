# Agent desk (paper trading)

Updated 2026-11-10 01:00 UTC. Runs so far: 86. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2470 | 30 | -65235.34 | -88895.88 |
| control | macro | 48 | 48 | -3.39 | -239.93 |
| control | all | 2518 | 31 | -65238.73 | -89135.81 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EURUSD short at 1.12259, stop 1.12351, target 1.1212, opened 2026-11-09 20:01 UTC
- control: Pepetide long at 0.00037, stop 0.000296, target 0.000518, opened 2026-11-10 00:17 UTC
- control: HWAN long at 7.184e-05, stop 5.7472e-05, target 0.000100576, opened 2026-11-10 00:32 UTC
- control: PIRATE long at 0.0002058, stop 0.00016464, target 0.00028812, opened 2026-11-10 00:41 UTC
- control: GBPUSD long at 1.34354, stop 1.34255, target 1.34503, opened 2026-11-10 01:00 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Pepetide REJECTED by guardrails: Pepetide already open
- 2026-11-10 01:00 UTC control: OPENED GBPUSD long at 1.34354 (stop 1.34255, target 1.34503) - control: random direction

