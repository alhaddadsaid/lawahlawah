# Agent desk (paper trading)

Updated 2026-10-23 17:07 UTC. Runs so far: 18. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 316 | 31 | -9665.26 | -12658.36 |
| control | macro | 8 | 62 | 327.77 | 290.38 |
| control | all | 324 | 32 | -9337.49 | -12367.98 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: TRENCHERS long at 8.533e-05, stop 6.8264e-05, target 0.000119462, opened 2026-10-23 16:19 UTC
- control: GUST long at 8.1e-05, stop 6.48e-05, target 0.0001134, opened 2026-10-23 16:58 UTC
- control: SAM long at 7.951e-05, stop 6.3608e-05, target 0.000111314, opened 2026-10-23 17:01 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED mil (target) P&L $68.0 normal, $56.0 pessimistic

