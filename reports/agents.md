# Agent desk (paper trading)

Updated 2026-11-08 07:07 UTC. Runs so far: 79. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2256 | 30 | -60385.64 | -81975.7 |
| control | macro | 46 | 48 | 28.03 | -198.72 |
| control | all | 2302 | 31 | -60357.61 | -82174.42 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: MAGGIE long at 0.0002142, stop 0.00017136, target 0.00029988, opened 2026-11-08 06:00 UTC
- control: APU long at 0.0005066, stop 0.00040528, target 0.00070924, opened 2026-11-08 06:27 UTC
- control: GATOGLITCH long at 0.0004308, stop 0.00034464, target 0.00060312, opened 2026-11-08 07:04 UTC
- control: MARS long at 7.676e-05, stop 6.1408e-05, target 0.000107464, opened 2026-11-08 07:07 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-08 07:07 UTC control: OPENED MARS long at 7.676e-05 (stop 6.1408e-05, target 0.000107464) - control: frozen v3 rules

