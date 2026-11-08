# Agent desk (paper trading)

Updated 2026-11-08 04:04 UTC. Runs so far: 79. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2241 | 30 | -60111.25 | -81554.52 |
| control | macro | 46 | 48 | 28.03 | -198.72 |
| control | all | 2287 | 31 | -60083.22 | -81753.24 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: Percolator long at 0.0001845, stop 0.0001476, target 0.0002583, opened 2026-11-08 03:13 UTC
- control: TAOLF long at 0.0001149, stop 9.192e-05, target 0.00016086, opened 2026-11-08 03:37 UTC
- control: HABIBI long at 0.000111, stop 8.88e-05, target 0.0001554, opened 2026-11-08 04:01 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED p402 (stop) P&L $-144.61 normal, $-151.16 pessimistic

