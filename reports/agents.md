# Agent desk (paper trading)

Updated 2026-10-24 02:39 UTC. Runs so far: 20. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 361 | 30 | -10679.78 | -14108.39 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 370 | 31 | -10486.41 | -13957.48 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: TRUTH long at 0.0001906, stop 0.00015248, target 0.00026684, opened 2026-10-24 02:18 UTC
- control: McRib long at 0.0002784, stop 0.00022272, target 0.00038976, opened 2026-10-24 02:33 UTC
- control: YMB long at 0.0001823, stop 0.00014584, target 0.00025522, opened 2026-10-24 02:39 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-24 02:39 UTC control: OPENED YMB long at 0.0001823 (stop 0.00014584, target 0.00025522) - control: frozen v3 rules

