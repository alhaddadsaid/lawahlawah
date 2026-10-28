# Agent desk (paper trading)

Updated 2026-10-28 16:35 UTC. Runs so far: 39. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 996 | 32 | -25743.08 | -35298.25 |
| control | macro | 22 | 45 | -109.27 | -232.96 |
| control | all | 1018 | 32 | -25852.35 | -35531.21 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33028, stop 1.32922, target 1.33187, opened 2026-10-28 15:55 UTC
- control: Rapport long at 8.112e-05, stop 6.4896e-05, target 0.000113568, opened 2026-10-28 16:01 UTC
- control: e/acc long at 0.000504, stop 0.0004032, target 0.0007056, opened 2026-10-28 16:17 UTC
- control: Robotaxi long at 0.0001519, stop 0.00012152, target 0.00021266, opened 2026-10-28 16:23 UTC
- control: LAUNCH long at 0.0001211, stop 9.688e-05, target 0.00016954, opened 2026-10-28 16:29 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order e/acc REJECTED by guardrails: desk already has the maximum open positions

