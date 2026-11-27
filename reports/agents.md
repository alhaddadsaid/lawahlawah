# Agent desk (paper trading)

Updated 2026-11-27 19:06 UTC. Runs so far: 142. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3903 | 31 | -97857.52 | -135379.06 |
| control | macro | 82 | 48 | 55.09 | -347.67 |
| control | all | 3985 | 31 | -97802.43 | -135726.73 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD short at 1.30964, stop 1.31067, target 1.30809, opened 2026-11-27 18:08 UTC
- control: Rizzmas long at 1.41e-06, stop 1.128e-06, target 1.974e-06, opened 2026-11-27 18:11 UTC
- control: WINSTON long at 0.000132, stop 0.0001056, target 0.0001848, opened 2026-11-27 18:23 UTC
- control: Kibo long at 9.303e-05, stop 7.4424e-05, target 0.000130242, opened 2026-11-27 18:26 UTC
- control: 67 long at 5.458e-05, stop 4.3664e-05, target 7.6412e-05, opened 2026-11-27 18:29 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order WINSTON REJECTED by guardrails: desk already has the maximum open positions

