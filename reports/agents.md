# Agent desk (paper trading)

Updated 2026-10-24 08:43 UTC. Runs so far: 21. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 401 | 30 | -11697.9 | -15510.64 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 410 | 30 | -11504.53 | -15359.73 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: ARCTIS long at 0.0001357, stop 0.00010856, target 0.00018998, opened 2026-10-24 07:08 UTC
- control: BURNIE long at 0.000622, stop 0.0004976, target 0.0008708, opened 2026-10-24 08:19 UTC
- control: COIL long at 0.0001122, stop 8.976e-05, target 0.00015708, opened 2026-10-24 08:34 UTC
- control: ███ long at 9.175e-05, stop 7.34e-05, target 0.00012845, opened 2026-10-24 08:37 UTC
- control: ODIE long at 0.0001324, stop 0.00010592, target 0.00018536, opened 2026-10-24 08:40 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order YMB REJECTED by guardrails: desk already has the maximum open positions

