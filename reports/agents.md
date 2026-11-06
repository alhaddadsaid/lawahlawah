# Agent desk (paper trading)

Updated 2026-11-06 21:04 UTC. Runs so far: 73. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2068 | 31 | -54328.47 | -74145.72 |
| control | macro | 45 | 47 | -2.88 | -226.41 |
| control | all | 2113 | 31 | -54331.35 | -74372.13 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4069.6, stop 4054.07, target 4092.89, opened 2026-11-06 17:23 UTC
- control: CAPY long at 0.0003886, stop 0.00031088, target 0.00054404, opened 2026-11-06 19:09 UTC
- control: Bubbles long at 0.0001308, stop 0.00010464, target 0.00018312, opened 2026-11-06 19:57 UTC
- control: FUSE long at 0.0001376, stop 0.00011008, target 0.00019264, opened 2026-11-06 21:01 UTC
- control: GLITCHPEPE long at 0.0003952, stop 0.00031616, target 0.00055328, opened 2026-11-06 21:04 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-06 21:04 UTC control: OPENED GLITCHPEPE long at 0.0003952 (stop 0.00031616, target 0.00055328) - control: frozen v3 rules

