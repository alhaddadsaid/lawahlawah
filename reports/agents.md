# Agent desk (paper trading)

Updated 2026-10-26 13:43 UTC. Runs so far: 30. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 709 | 31 | -19609.18 | -26378.05 |
| control | macro | 11 | 45 | -58.52 | -116.18 |
| control | all | 720 | 32 | -19667.7 | -26494.23 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: SIB long at 0.0002343, stop 0.00018744, target 0.00032802, opened 2026-10-26 12:15 UTC
- control: world long at 0.0001641, stop 0.00013128, target 0.00022974, opened 2026-10-26 12:21 UTC
- control: Bow long at 7.318e-05, stop 5.8544e-05, target 0.000102452, opened 2026-10-26 13:07 UTC
- control: Chop long at 0.0001145, stop 9.16e-05, target 0.0001603, opened 2026-10-26 13:37 UTC
- control: GME long at 0.0001096, stop 8.768e-05, target 0.00015344, opened 2026-10-26 13:40 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order LAB REJECTED by guardrails: desk already has the maximum open positions

