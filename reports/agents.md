# Agent desk (paper trading)

Updated 2026-11-15 23:40 UTC. Runs so far: 107. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3021 | 31 | -75928.18 | -104965.72 |
| control | macro | 60 | 52 | 454.48 | 160.55 |
| control | all | 3081 | 32 | -75473.7 | -104805.17 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GTA6 long at 0.0001351, stop 0.00010808, target 0.00018914, opened 2026-11-15 22:19 UTC
- control: bill long at 0.0002671, stop 0.00021368, target 0.00037394, opened 2026-11-15 22:43 UTC
- control: BUTTHOLE long at 0.0005535, stop 0.0004428, target 0.0007749, opened 2026-11-15 22:49 UTC
- control: WISHMAS long at 0.0001851, stop 0.00014808, target 0.00025914, opened 2026-11-15 22:52 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED WIGGLES (stop) P&L $-55.49 normal, $-64.33 pessimistic

