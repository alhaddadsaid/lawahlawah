# Agent desk (paper trading)

Updated 2026-10-30 14:47 UTC. Runs so far: 47. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1268 | 31 | -34249.76 | -46376.58 |
| control | macro | 27 | 44 | -173.82 | -322.19 |
| control | all | 1295 | 31 | -34423.58 | -46698.77 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: PQC long at 0.0001023, stop 8.184e-05, target 0.00014322, opened 2026-10-30 12:51 UTC
- control: three long at 0.0005968, stop 0.00047744, target 0.00083552, opened 2026-10-30 13:00 UTC
- control: Foxii long at 0.0001862, stop 0.00014896, target 0.00026068, opened 2026-10-30 14:20 UTC
- control: PINK long at 0.0001059, stop 8.472e-05, target 0.00014826, opened 2026-10-30 14:41 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Foxii REJECTED by guardrails: Foxii already open

