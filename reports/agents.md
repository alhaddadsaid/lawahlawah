# Agent desk (paper trading)

Updated 2026-11-26 19:29 UTC. Runs so far: 139. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3844 | 31 | -96695.54 | -133641.74 |
| control | macro | 80 | 49 | 295.36 | -95.35 |
| control | all | 3924 | 31 | -96400.18 | -133737.09 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD short at 1.31055, stop 1.31158, target 1.309, opened 2026-11-26 17:00 UTC
- control: EURUSD short at 1.09745, stop 1.09825, target 1.09625, opened 2026-11-26 18:01 UTC
- control: DIGS long at 0.0002618, stop 0.00020944, target 0.00036652, opened 2026-11-26 19:20 UTC
- control: Zero long at 9.234e-05, stop 7.3872e-05, target 0.000129276, opened 2026-11-26 19:29 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-26 19:29 UTC control: OPENED Zero long at 9.234e-05 (stop 7.3872e-05, target 0.000129276) - control: frozen v3 rules

