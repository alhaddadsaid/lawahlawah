# Agent desk (paper trading)

Updated 2026-10-28 11:38 UTC. Runs so far: 38. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 975 | 32 | -24879.12 | -34241.06 |
| control | macro | 20 | 40 | -392.29 | -502.43 |
| control | all | 995 | 32 | -25271.41 | -34743.49 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- team: GBPUSD short at 1.32892, stop 1.334, target 1.324, opened 2026-10-28 06:14 UTC
- control: Frongus long at 0.0002264, stop 0.00018112, target 0.00031696, opened 2026-10-28 10:22 UTC
- control: OpenBot long at 0.0001047, stop 8.376e-05, target 0.00014658, opened 2026-10-28 11:17 UTC
- control: N64 long at 8.428e-05, stop 6.7424e-05, target 0.000117992, opened 2026-10-28 11:20 UTC
- control: Robotaxi long at 0.0002687, stop 0.00021496, target 0.00037618, opened 2026-10-28 11:26 UTC
- control: Stonker long at 0.0002045, stop 0.0001636, target 0.0002863, opened 2026-10-28 11:35 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order DICTATOR REJECTED by guardrails: desk already has the maximum open positions

