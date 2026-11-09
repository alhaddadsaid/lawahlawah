# Agent desk (paper trading)

Updated 2026-11-09 02:26 UTC. Runs so far: 82. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2351 | 31 | -62152.87 | -84671.94 |
| control | macro | 46 | 48 | 28.03 | -198.72 |
| control | all | 2397 | 31 | -62124.84 | -84870.66 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: george long at 0.0001566, stop 0.00012528, target 0.00021924, opened 2026-11-09 00:42 UTC
- control: LMAO! long at 0.0005129, stop 0.00041032, target 0.00071806, opened 2026-11-09 01:52 UTC
- control: GOLD short at 4132.9, stop 4152.43, target 4103.61, opened 2026-11-09 02:01 UTC
- control: PIRATE long at 0.0004761, stop 0.00038088, target 0.00066654, opened 2026-11-09 02:19 UTC
- control: QUINN long at 9.186e-05, stop 7.3488e-05, target 0.000128604, opened 2026-11-09 02:26 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-09 02:26 UTC control: OPENED QUINN long at 9.186e-05 (stop 7.3488e-05, target 0.000128604) - control: frozen v3 rules

