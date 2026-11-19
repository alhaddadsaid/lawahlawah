# Agent desk (paper trading)

Updated 2026-11-19 03:52 UTC. Runs so far: 117. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3288 | 31 | -82664.62 | -114267.85 |
| control | macro | 70 | 50 | 329.03 | -17.33 |
| control | all | 3358 | 31 | -82335.59 | -114285.18 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: Dacity long at 0.0003139, stop 0.00025112, target 0.00043946, opened 2026-11-19 03:39 UTC
- control: DCTC long at 0.0001278, stop 0.00010224, target 0.00017892, opened 2026-11-19 03:49 UTC
- control: BUNC long at 0.0001972, stop 0.00015776, target 0.00027608, opened 2026-11-19 03:52 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.
- 2026-11-19 03:52 UTC control: OPENED BUNC long at 0.0001972 (stop 0.00015776, target 0.00027608) - control: frozen v3 rules

