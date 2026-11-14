# Agent desk (paper trading)

Updated 2026-11-14 13:09 UTC. Runs so far: 101. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2846 | 31 | -71560.12 | -98914.81 |
| control | macro | 59 | 51 | 389.92 | 99.5 |
| control | all | 2905 | 32 | -71170.2 | -98815.31 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 3876.6, stop 3862.35, target 3897.98, opened 2026-11-13 20:02 UTC
- control: fone long at 0.001046, stop 0.0008368, target 0.0014644, opened 2026-11-14 11:40 UTC
- control: WISHMAS long at 0.0001087, stop 8.696e-05, target 0.00015218, opened 2026-11-14 11:43 UTC
- control: Sakura long at 8.218e-05, stop 6.5744e-05, target 0.000115052, opened 2026-11-14 12:53 UTC
- control: Punch long at 0.0002639, stop 0.00021112, target 0.00036946, opened 2026-11-14 13:06 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order ZAPZEKE REJECTED by guardrails: desk already has the maximum open positions

