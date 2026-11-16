# Agent desk (paper trading)

Updated 2026-11-16 00:29 UTC. Runs so far: 107. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3024 | 31 | -76033.84 | -105099.43 |
| control | macro | 60 | 52 | 454.48 | 160.55 |
| control | all | 3084 | 32 | -75579.36 | -104938.88 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: BUTTHOLE long at 0.0005535, stop 0.0004428, target 0.0007749, opened 2026-11-15 22:49 UTC
- control: WISHMAS long at 0.0001851, stop 0.00014808, target 0.00025914, opened 2026-11-15 22:52 UTC
- control: JENSEN long at 8.404e-05, stop 6.7232e-05, target 0.000117656, opened 2026-11-15 23:46 UTC
- control: CYBERDACITY long at 0.0001134, stop 9.072e-05, target 0.00015876, opened 2026-11-16 00:17 UTC
- control: BAWSAQ long at 0.0002328, stop 0.00018624, target 0.00032592, opened 2026-11-16 00:23 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order bill REJECTED by guardrails: desk already has the maximum open positions

