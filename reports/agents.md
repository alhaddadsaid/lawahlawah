# Agent desk (paper trading)

Updated 2026-11-05 10:08 UTC. Runs so far: 68. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1897 | 31 | -50684.94 | -68841.75 |
| control | macro | 41 | 44 | -324.4 | -534.42 |
| control | all | 1938 | 31 | -51009.34 | -69376.17 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: PIRATE long at 0.0003833, stop 0.00030664, target 0.00053662, opened 2026-11-05 08:54 UTC
- control: AI long at 0.0001579, stop 0.00012632, target 0.00022106, opened 2026-11-05 09:19 UTC
- control: CYBERLEEK long at 0.002372, stop 0.0018976, target 0.0033208, opened 2026-11-05 09:46 UTC
- control: HeeHaw long at 0.0002362, stop 0.00018896, target 0.00033068, opened 2026-11-05 10:02 UTC
- control: STONKS long at 0.0004547, stop 0.00036376, target 0.00063658, opened 2026-11-05 10:08 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.
- 2026-11-05 10:08 UTC control: OPENED STONKS long at 0.0004547 (stop 0.00036376, target 0.00063658) - control: frozen v3 rules

