# Agent desk (paper trading)

Updated 2026-11-09 09:18 UTC. Runs so far: 84. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2391 | 31 | -62850.14 | -85761.58 |
| control | macro | 47 | 49 | 175.47 | -53.84 |
| control | all | 2438 | 31 | -62674.67 | -85815.42 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: JENSEN long at 6.932e-05, stop 5.5456e-05, target 9.7048e-05, opened 2026-11-09 07:53 UTC
- control: PIRATE long at 0.0004722, stop 0.00037776, target 0.00066108, opened 2026-11-09 08:05 UTC
- control: COGE long at 0.0001299, stop 0.00010392, target 0.00018186, opened 2026-11-09 08:36 UTC
- control: JASON long at 0.000127, stop 0.0001016, target 0.0001778, opened 2026-11-09 08:54 UTC
- control: Steve long at 6.088e-05, stop 4.8704e-05, target 8.5232e-05, opened 2026-11-09 09:12 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.

