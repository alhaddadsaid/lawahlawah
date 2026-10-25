# Agent desk (paper trading)

Updated 2026-10-25 16:45 UTC. Runs so far: 26. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 575 | 32 | -15111.9 | -20621.74 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 584 | 33 | -14918.53 | -20470.83 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Bunnett long at 0.0001804, stop 0.00014432, target 0.00025256, opened 2026-10-25 14:46 UTC
- control: Marvin long at 6.387e-05, stop 5.1096e-05, target 8.9418e-05, opened 2026-10-25 14:49 UTC
- control: SHADOW long at 0.000221, stop 0.0001768, target 0.0003094, opened 2026-10-25 16:30 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Bunnett REJECTED by guardrails: Bunnett already open

