# Agent desk (paper trading)

Updated 2026-11-10 18:57 UTC. Runs so far: 88. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2505 | 31 | -65616.24 | -89625.94 |
| control | macro | 52 | 50 | 233.2 | -26.95 |
| control | all | 2557 | 31 | -65383.04 | -89652.89 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: HWAN long at 0.0001079, stop 8.632e-05, target 0.00015106, opened 2026-11-10 17:11 UTC
- control: forg long at 0.0001138, stop 9.104e-05, target 0.00015932, opened 2026-11-10 17:17 UTC
- control: PUSSY long at 0.0007398, stop 0.00059184, target 0.00103572, opened 2026-11-10 17:32 UTC
- control: GTA long at 0.0001268, stop 0.00010144, target 0.00017752, opened 2026-11-10 17:59 UTC
- control: VC long at 8.696e-05, stop 6.9568e-05, target 0.000121744, opened 2026-11-10 18:57 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-10 18:57 UTC control: OPENED VC long at 8.696e-05 (stop 6.9568e-05, target 0.000121744) - control: frozen v3 rules

