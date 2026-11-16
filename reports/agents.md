# Agent desk (paper trading)

Updated 2026-11-16 08:10 UTC. Runs so far: 108. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3058 | 31 | -76982.65 | -106372.63 |
| control | macro | 61 | 51 | 336.31 | 32.39 |
| control | all | 3119 | 31 | -76646.34 | -106340.24 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: bill long at 0.0001285, stop 0.0001028, target 0.0001799, opened 2026-11-16 06:41 UTC
- control: BUTTHOLE long at 0.000376, stop 0.0003008, target 0.0005264, opened 2026-11-16 07:33 UTC
- control: AURA long at 0.0001039, stop 8.312e-05, target 0.00014546, opened 2026-11-16 07:45 UTC
- control: Socks long at 8.299e-05, stop 6.6392e-05, target 0.000116186, opened 2026-11-16 07:51 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order bill REJECTED by guardrails: bill already open

