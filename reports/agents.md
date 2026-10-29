# Agent desk (paper trading)

Updated 2026-10-29 05:46 UTC. Runs so far: 41. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1075 | 32 | -27401.51 | -37724.41 |
| control | macro | 24 | 46 | -78.34 | -212.02 |
| control | all | 1099 | 32 | -27479.85 | -37936.43 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: SIB long at 0.0003695, stop 0.0002956, target 0.0005173, opened 2026-10-29 04:30 UTC
- control: CPU long at 0.0004421, stop 0.00035368, target 0.00061894, opened 2026-10-29 04:36 UTC
- control: PODCAT long at 0.0001086, stop 8.688e-05, target 0.00015204, opened 2026-10-29 05:22 UTC
- control: SPERM long at 9.961e-05, stop 7.9688e-05, target 0.000139454, opened 2026-10-29 05:46 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-29 05:46 UTC control: OPENED SPERM long at 9.961e-05 (stop 7.9688e-05, target 0.000139454) - control: frozen v3 rules

