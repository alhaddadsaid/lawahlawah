# Agent desk (paper trading)

Updated 2026-10-24 09:13 UTC. Runs so far: 21. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 403 | 30 | -11656.71 | -15491.02 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 412 | 31 | -11463.34 | -15340.11 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: BURNIE long at 0.000622, stop 0.0004976, target 0.0008708, opened 2026-10-24 08:19 UTC
- control: ███ long at 9.175e-05, stop 7.34e-05, target 0.00012845, opened 2026-10-24 08:37 UTC
- control: ODIE long at 0.0001324, stop 0.00010592, target 0.00018536, opened 2026-10-24 08:40 UTC
- control: SHADOW long at 0.0001502, stop 0.00012016, target 0.00021028, opened 2026-10-24 09:04 UTC
- control: COIL long at 0.0001748, stop 0.00013984, target 0.00024472, opened 2026-10-24 09:10 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order PUMP DEV REJECTED by guardrails: desk already has the maximum open positions

