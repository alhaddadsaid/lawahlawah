# Agent desk (paper trading)

Updated 2026-11-10 11:06 UTC. Runs so far: 87. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2489 | 31 | -65364.59 | -89216.66 |
| control | macro | 52 | 50 | 233.2 | -26.95 |
| control | all | 2541 | 31 | -65131.39 | -89243.61 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: HWAN long at 5.764e-05, stop 4.6112e-05, target 8.0696e-05, opened 2026-11-10 09:07 UTC
- control: GTA long at 6.093e-05, stop 4.8744e-05, target 8.5302e-05, opened 2026-11-10 10:14 UTC
- control: Punch long at 0.0002134, stop 0.00017072, target 0.00029876, opened 2026-11-10 10:20 UTC
- control: X long at 7.782e-05, stop 6.2256e-05, target 0.000108948, opened 2026-11-10 10:57 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.

