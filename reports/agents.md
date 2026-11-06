# Agent desk (paper trading)

Updated 2026-11-06 01:37 UTC. Runs so far: 70. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1962 | 31 | -52140.64 | -70926.77 |
| control | macro | 41 | 44 | -324.4 | -534.42 |
| control | all | 2003 | 31 | -52465.04 | -71461.19 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: PIRATE long at 0.0002354, stop 0.00018832, target 0.00032956, opened 2026-11-06 00:39 UTC
- control: GOLD short at 4104.9, stop 4128.58, target 4069.38, opened 2026-11-06 01:01 UTC
- control: COGE long at 9.958e-05, stop 7.9664e-05, target 0.000139412, opened 2026-11-06 01:16 UTC
- control: coin long at 0.0001214, stop 9.712e-05, target 0.00016996, opened 2026-11-06 01:25 UTC
- control: sssdfg long at 0.0001584, stop 0.00012672, target 0.00022176, opened 2026-11-06 01:28 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order ZELDA REJECTED by guardrails: desk already has the maximum open positions

