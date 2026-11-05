# Agent desk (paper trading)

Updated 2026-11-05 15:00 UTC. Runs so far: 69. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1915 | 31 | -51076.6 | -69407.97 |
| control | macro | 41 | 44 | -324.4 | -534.42 |
| control | all | 1956 | 31 | -51401.0 | -69942.39 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: AI long at 0.0001194, stop 9.552e-05, target 0.00016716, opened 2026-11-05 13:16 UTC
- control: ZELDA long at 0.0001106, stop 8.848e-05, target 0.00015484, opened 2026-11-05 14:11 UTC
- control: WOJAK long at 0.001194, stop 0.0009552, target 0.0016716, opened 2026-11-05 14:42 UTC
- control: PIRATE long at 0.0004336, stop 0.00034688, target 0.00060704, opened 2026-11-05 14:51 UTC
- control: RICO long at 0.0001564, stop 0.00012512, target 0.00021896, opened 2026-11-05 14:54 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.

