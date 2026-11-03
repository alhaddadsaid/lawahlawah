# Agent desk (paper trading)

Updated 2026-11-03 09:09 UTC. Runs so far: 61. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1657 | 31 | -44077.23 | -59941.93 |
| control | macro | 34 | 44 | -314.46 | -499.07 |
| control | all | 1691 | 31 | -44391.69 | -60441.0 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: CAPY long at 0.0005641, stop 0.00045128, target 0.00078974, opened 2026-11-03 07:21 UTC
- control: ARNOLD long at 0.0001055, stop 8.44e-05, target 0.0001477, opened 2026-11-03 07:54 UTC
- control: Slingoor long at 8.653e-05, stop 6.9224e-05, target 0.000121142, opened 2026-11-03 08:55 UTC
- control: UNPOOLED long at 5.563e-05, stop 4.4504e-05, target 7.7882e-05, opened 2026-11-03 09:04 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED XDG (target) P&L $68.0 normal, $56.0 pessimistic

