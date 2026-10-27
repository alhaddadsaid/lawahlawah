# Agent desk (paper trading)

Updated 2026-10-27 12:45 UTC. Runs so far: 34. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 847 | 31 | -23259.72 | -31350.38 |
| control | macro | 16 | 50 | 109.57 | 22.52 |
| control | all | 863 | 32 | -23150.15 | -31327.86 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Blackout long at 5.418e-05, stop 4.3344e-05, target 7.5852e-05, opened 2026-10-27 11:07 UTC
- control: Wifoween long at 0.0001774, stop 0.00014192, target 0.00024836, opened 2026-10-27 11:14 UTC
- control: RAYPAD long at 0.0001418, stop 0.00011344, target 0.00019852, opened 2026-10-27 11:38 UTC
- control: DICTATOR long at 0.0001312, stop 0.00010496, target 0.00018368, opened 2026-10-27 12:15 UTC
- control: GINNAN long at 8.293e-08, stop 6.6344e-08, target 1.16102e-07, opened 2026-10-27 12:27 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order DICTATOR REJECTED by guardrails: desk already has the maximum open positions

