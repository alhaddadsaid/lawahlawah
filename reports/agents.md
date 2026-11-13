# Agent desk (paper trading)

Updated 2026-11-13 21:52 UTC. Runs so far: 98. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2774 | 31 | -70614.65 | -97255.11 |
| control | macro | 59 | 51 | 389.92 | 99.5 |
| control | all | 2833 | 31 | -70224.73 | -97155.61 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 3876.6, stop 3862.35, target 3897.98, opened 2026-11-13 20:02 UTC
- control: Punch long at 0.0003392, stop 0.00027136, target 0.00047488, opened 2026-11-13 20:39 UTC
- control: Sakura long at 0.0001993, stop 0.00015944, target 0.00027902, opened 2026-11-13 21:34 UTC
- control: plumber long at 0.0001062, stop 8.496e-05, target 0.00014868, opened 2026-11-13 21:43 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

## Run ended 2026-11-13 21:52 UTC

