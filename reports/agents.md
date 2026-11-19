# Agent desk (paper trading)

Updated 2026-11-19 15:31 UTC. Runs so far: 118. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3324 | 31 | -83609.27 | -115557.52 |
| control | macro | 70 | 50 | 329.03 | -17.33 |
| control | all | 3394 | 31 | -83280.24 | -115574.85 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 3715.8, stop 3698.15, target 3742.28, opened 2026-11-19 12:49 UTC
- control: ANT long at 0.0001095, stop 8.76e-05, target 0.0001533, opened 2026-11-19 15:10 UTC
- control: DacityCoin long at 0.0004583, stop 0.00036664, target 0.00064162, opened 2026-11-19 15:16 UTC
- control: Apocrycoin long at 0.0002099, stop 0.00016792, target 0.00029386, opened 2026-11-19 15:31 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-19 15:31 UTC control: OPENED Apocrycoin long at 0.0002099 (stop 0.00016792, target 0.00029386) - control: frozen v3 rules

