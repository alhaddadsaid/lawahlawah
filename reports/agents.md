# Agent desk (paper trading)

Updated 2026-11-12 01:55 UTC. Runs so far: 93. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2615 | 31 | -67001.58 | -92103.93 |
| control | macro | 56 | 52 | 561.9 | 286.03 |
| control | all | 2671 | 31 | -66439.68 | -91817.9 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: BURNIE long at 0.0009337, stop 0.00074696, target 0.00130718, opened 2026-11-12 00:16 UTC
- control: PAYDAY long at 0.0001703, stop 0.00013624, target 0.00023842, opened 2026-11-12 01:40 UTC
- control: Max long at 0.0002877, stop 0.00023016, target 0.00040278, opened 2026-11-12 01:43 UTC
- control: BACKERS long at 0.000173, stop 0.0001384, target 0.0002422, opened 2026-11-12 01:55 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED X (time) P&L $-3.9 normal, $-14.06 pessimistic

