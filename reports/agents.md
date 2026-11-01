# Agent desk (paper trading)

Updated 2026-11-01 07:26 UTC. Runs so far: 54. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1407 | 31 | -37258.44 | -50733.75 |
| control | macro | 28 | 46 | -141.99 | -292.93 |
| control | all | 1435 | 31 | -37400.43 | -51026.68 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: Kim long at 5.981e-05, stop 4.7848e-05, target 8.3734e-05, opened 2026-11-01 05:29 UTC
- control: WASTED long at 9.644e-05, stop 7.7152e-05, target 0.000135016, opened 2026-11-01 06:05 UTC
- control: KIM long at 0.0002418, stop 0.00019344, target 0.00033852, opened 2026-11-01 06:34 UTC
- control: tipr long at 0.0001848, stop 0.00014784, target 0.00025872, opened 2026-11-01 06:52 UTC
- control: LUMI long at 6.456e-05, stop 5.1648e-05, target 9.0384e-05, opened 2026-11-01 07:20 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order tipr REJECTED by guardrails: desk already has the maximum open positions

