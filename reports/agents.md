# Agent desk (paper trading)

Updated 2026-10-28 18:37 UTC. Runs so far: 39. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1004 | 32 | -26061.48 | -35690.53 |
| control | macro | 23 | 48 | 31.31 | -98.04 |
| control | all | 1027 | 32 | -26030.17 | -35788.57 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: MOGZBOT long at 2.347e-06, stop 1.8776e-06, target 3.2858e-06, opened 2026-10-28 16:50 UTC
- control: Nothing long at 0.0002462, stop 0.00019696, target 0.00034468, opened 2026-10-28 17:03 UTC
- control: Something long at 0.0001773, stop 0.00014184, target 0.00024822, opened 2026-10-28 18:13 UTC
- control: Frongus long at 9.771e-05, stop 7.8168e-05, target 0.000136794, opened 2026-10-28 18:16 UTC
- control: Rapport long at 0.0002089, stop 0.00016712, target 0.00029246, opened 2026-10-28 18:25 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Something REJECTED by guardrails: desk already has the maximum open positions

