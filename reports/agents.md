# Agent desk (paper trading)

Updated 2026-11-15 18:38 UTC. Runs so far: 106. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2991 | 31 | -75280.01 | -104026.47 |
| control | macro | 60 | 52 | 454.48 | 160.55 |
| control | all | 3051 | 31 | -74825.53 | -103865.92 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: fone long at 0.0009263, stop 0.00074104, target 0.00129682, opened 2026-11-15 16:57 UTC
- control: FOOD long at 0.0002141, stop 0.00017128, target 0.00029974, opened 2026-11-15 17:04 UTC
- control: DIGS long at 0.0001711, stop 0.00013688, target 0.00023954, opened 2026-11-15 17:13 UTC
- control: Socks long at 0.0001471, stop 0.00011768, target 0.00020594, opened 2026-11-15 17:28 UTC
- control: Nyajira long at 6.71e-05, stop 5.368e-05, target 9.394e-05, opened 2026-11-15 18:26 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order BEAR REJECTED by guardrails: desk already has the maximum open positions

