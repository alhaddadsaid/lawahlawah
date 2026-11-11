# Agent desk (paper trading)

Updated 2026-11-11 09:29 UTC. Runs so far: 90. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2553 | 31 | -65781.69 | -90279.42 |
| control | macro | 54 | 52 | 524.8 | 257.86 |
| control | all | 2607 | 31 | -65256.89 | -90021.56 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD short at 4065.3, stop 4076.54, target 4048.45, opened 2026-11-11 07:02 UTC
- control: DIGS long at 0.0001108, stop 8.864e-05, target 0.00015512, opened 2026-11-11 08:03 UTC
- control: If long at 0.0001229, stop 9.832e-05, target 0.00017206, opened 2026-11-11 08:12 UTC
- control: FAIR long at 0.0001132, stop 9.056e-05, target 0.00015848, opened 2026-11-11 09:20 UTC
- control: :3 long at 6.696e-05, stop 5.3568e-05, target 9.3744e-05, opened 2026-11-11 09:29 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-11 09:29 UTC control: OPENED :3 long at 6.696e-05 (stop 5.3568e-05, target 9.3744e-05) - control: frozen v3 rules

