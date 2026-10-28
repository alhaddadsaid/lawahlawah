# Agent desk (paper trading)

Updated 2026-10-28 10:07 UTC. Runs so far: 38. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 970 | 32 | -24699.8 | -34015.08 |
| control | macro | 20 | 40 | -392.29 | -502.43 |
| control | all | 990 | 32 | -25092.09 | -34517.51 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- team: GBPUSD short at 1.32892, stop 1.334, target 1.324, opened 2026-10-28 06:14 UTC
- control: Frongus long at 0.0001879, stop 0.00015032, target 0.00026306, opened 2026-10-28 08:20 UTC
- control: CA long at 6.599e-05, stop 5.2792e-05, target 9.2386e-05, opened 2026-10-28 10:01 UTC
- control: OpenBot long at 0.0001544, stop 0.00012352, target 0.00021616, opened 2026-10-28 10:07 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-28 10:07 UTC control: OPENED OpenBot long at 0.0001544 (stop 0.00012352, target 0.00021616) - control: frozen v3 rules

