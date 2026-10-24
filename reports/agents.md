# Agent desk (paper trading)

Updated 2026-10-24 17:50 UTC. Runs so far: 23. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 458 | 31 | -12698.91 | -17070.59 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 467 | 31 | -12505.54 | -16919.68 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: SHADOW long at 0.0001767, stop 0.00014136, target 0.00024738, opened 2026-10-24 17:07 UTC
- control: PRIVACY long at 8.614e-05, stop 6.8912e-05, target 0.000120596, opened 2026-10-24 17:40 UTC
- control: HeeHaw long at 0.0002343, stop 0.00018744, target 0.00032802, opened 2026-10-24 17:43 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order SHADOW REJECTED by guardrails: SHADOW already open

