# Agent desk (paper trading)

Updated 2026-11-17 06:10 UTC. Runs so far: 111. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3142 | 31 | -79043.53 | -109242.18 |
| control | macro | 63 | 49 | 112.17 | -202.74 |
| control | all | 3205 | 31 | -78931.36 | -109444.92 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EURUSD long at 1.10084, stop 1.09996, target 1.10215, opened 2026-11-17 03:40 UTC
- control: bul long at 0.0002074, stop 0.00016592, target 0.00029036, opened 2026-11-17 05:00 UTC
- control: WIGGLES long at 0.000125, stop 0.0001, target 0.000175, opened 2026-11-17 05:42 UTC
- control: MELNOK long at 9.253e-05, stop 7.4024e-05, target 0.000129542, opened 2026-11-17 05:45 UTC
- control: KINS long at 0.0004156, stop 0.00033248, target 0.00058184, opened 2026-11-17 06:04 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.

