# Agent desk (paper trading)

Updated 2026-10-25 23:29 UTC. Runs so far: 28. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 623 | 31 | -17660.39 | -23597.2 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 632 | 31 | -17467.02 | -23446.29 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GME long at 0.0001215, stop 9.72e-05, target 0.0001701, opened 2026-10-25 22:34 UTC
- control: Spidoge long at 5.55e-05, stop 4.44e-05, target 7.77e-05, opened 2026-10-25 23:04 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED LINKR (stop) P&L $-56.22 normal, $-65.04 pessimistic

