# Agent desk (paper trading)

Updated 2026-10-28 05:28 UTC. Runs so far: 37. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 941 | 32 | -24081.76 | -33115.41 |
| control | macro | 19 | 42 | -261.01 | -363.42 |
| control | all | 960 | 32 | -24342.77 | -33478.83 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: DICTATOR long at 9.435e-05, stop 7.548e-05, target 0.00013209, opened 2026-10-28 03:59 UTC
- control: INVISIBLE long at 0.0001748, stop 0.00013984, target 0.00024472, opened 2026-10-28 04:39 UTC
- control: Frongus long at 0.0002121, stop 0.00016968, target 0.00029694, opened 2026-10-28 05:00 UTC
- control: FRONGUS long at 0.0001806, stop 0.00014448, target 0.00025284, opened 2026-10-28 05:28 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-28 05:28 UTC control: OPENED FRONGUS long at 0.0001806 (stop 0.00014448, target 0.00025284) - control: frozen v3 rules

