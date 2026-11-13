# Agent desk (paper trading)

Updated 2026-11-13 04:39 UTC. Runs so far: 96. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2715 | 31 | -69256.37 | -95326.52 |
| control | macro | 57 | 53 | 704.25 | 422.92 |
| control | all | 2772 | 31 | -68552.12 | -94903.6 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD short at 1.32298, stop 1.32424, target 1.32109, opened 2026-11-12 18:08 UTC
- control: EURUSD long at 1.10583, stop 1.10467, target 1.10756, opened 2026-11-12 20:01 UTC
- control: HUNG long at 0.0002678, stop 0.00021424, target 0.00037492, opened 2026-11-13 03:09 UTC
- control: JENSWAN long at 0.000106, stop 8.48e-05, target 0.0001484, opened 2026-11-13 04:28 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED Huang (stop) P&L $-50.45 normal, $-59.42 pessimistic

