# Agent desk (paper trading)

Updated 2026-11-12 01:27 UTC. Runs so far: 93. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2613 | 31 | -66947.3 | -92030.52 |
| control | macro | 56 | 52 | 561.9 | 286.03 |
| control | all | 2669 | 31 | -66385.4 | -91744.49 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: X long at 8.344e-05, stop 6.6752e-05, target 0.000116816, opened 2026-11-11 23:55 UTC
- control: HOLD long at 0.0002226, stop 0.00017808, target 0.00031164, opened 2026-11-12 00:04 UTC
- control: BURNIE long at 0.0009337, stop 0.00074696, target 0.00130718, opened 2026-11-12 00:16 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

## Run started 2026-11-12 01:27 UTC
- control: CLOSED SQUIRE (time, while away) P&L $0.36 normal, $-9.91 pessimistic
- control: CLOSED Mustache (stop, while away) P&L $-76.44 normal, $-84.73 pessimistic
- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.

