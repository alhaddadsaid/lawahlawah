# Agent desk (paper trading)

Updated 2026-11-25 13:41 UTC. Runs so far: 136. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3771 | 31 | -94438.54 | -130693.87 |
| control | macro | 79 | 48 | 154.08 | -231.41 |
| control | all | 3850 | 31 | -94284.46 | -130925.28 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: PERRO long at 0.0001545, stop 0.0001236, target 0.0002163, opened 2026-11-25 13:02 UTC
- control: GBPUSD short at 1.3069, stop 1.30805, target 1.30518, opened 2026-11-25 13:02 UTC
- control: DUVAL long at 6.715e-05, stop 5.372e-05, target 9.401e-05, opened 2026-11-25 13:14 UTC
- control: JaoJiu long at 0.000134, stop 0.0001072, target 0.0001876, opened 2026-11-25 13:17 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order JaoJiu REJECTED by guardrails: JaoJiu already open

