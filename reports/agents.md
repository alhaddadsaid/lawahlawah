# Agent desk (paper trading)

Updated 2026-10-28 06:29 UTC. Runs so far: 37. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 947 | 32 | -24310.35 | -33399.7 |
| control | macro | 19 | 42 | -261.01 | -363.42 |
| control | all | 966 | 32 | -24571.36 | -33763.12 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- team: GBPUSD short at 1.32892, stop 1.334, target 1.324, opened 2026-10-28 06:14 UTC
- control: INVISIBLE long at 0.0001748, stop 0.00013984, target 0.00024472, opened 2026-10-28 04:39 UTC
- control: Frongus long at 0.0002121, stop 0.00016968, target 0.00029694, opened 2026-10-28 05:00 UTC
- control: Robotaxi long at 7.066e-05, stop 5.6528e-05, target 9.8924e-05, opened 2026-10-28 06:04 UTC
- control: DICTATOR long at 8.715e-05, stop 6.972e-05, target 0.00012201, opened 2026-10-28 06:11 UTC
- control: DORA long at 5.987e-05, stop 4.7896e-05, target 8.3818e-05, opened 2026-10-28 06:14 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Robotaxi REJECTED by guardrails: desk already has the maximum open positions

