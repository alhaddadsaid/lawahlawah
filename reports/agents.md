# Agent desk (paper trading)

Updated 2026-11-10 10:14 UTC. Runs so far: 87. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2487 | 31 | -65320.67 | -89153.36 |
| control | macro | 52 | 50 | 233.2 | -26.95 |
| control | all | 2539 | 31 | -65087.47 | -89180.31 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: CYBERLEEK long at 0.00172, stop 0.001376, target 0.002408, opened 2026-11-10 08:55 UTC
- control: Steve long at 0.0001393, stop 0.00011144, target 0.00019502, opened 2026-11-10 09:04 UTC
- control: HWAN long at 5.764e-05, stop 4.6112e-05, target 8.0696e-05, opened 2026-11-10 09:07 UTC
- control: GTA long at 6.093e-05, stop 4.8744e-05, target 8.5302e-05, opened 2026-11-10 10:14 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-10 10:14 UTC control: OPENED GTA long at 6.093e-05 (stop 4.8744e-05, target 8.5302e-05) - control: frozen v3 rules

