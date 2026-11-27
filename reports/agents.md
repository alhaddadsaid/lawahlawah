# Agent desk (paper trading)

Updated 2026-11-27 09:33 UTC. Runs so far: 141. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3881 | 31 | -96961.8 | -134280.65 |
| control | macro | 82 | 48 | 55.09 | -347.67 |
| control | all | 3963 | 31 | -96906.71 | -134628.32 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: BASKET long at 0.000431, stop 0.0003448, target 0.0006034, opened 2026-11-27 08:23 UTC
- control: NETWORK long at 7.863e-05, stop 6.2904e-05, target 0.000110082, opened 2026-11-27 08:26 UTC
- control: Investor long at 5.481e-05, stop 4.3848e-05, target 7.6734e-05, opened 2026-11-27 08:50 UTC
- control: Kibo long at 7.281e-05, stop 5.8248e-05, target 0.000101934, opened 2026-11-27 09:15 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order BASKET REJECTED by guardrails: BASKET already open

