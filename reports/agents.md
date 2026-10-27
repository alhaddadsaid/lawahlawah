# Agent desk (paper trading)

Updated 2026-10-27 23:03 UTC. Runs so far: 36. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 908 | 31 | -23972.81 | -32670.81 |
| control | macro | 18 | 44 | -152.98 | -251.79 |
| control | all | 926 | 32 | -24125.79 | -32922.6 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4065, stop 4051.11, target 4085.83, opened 2026-10-27 15:00 UTC
- control: Wifoween long at 8.616e-05, stop 6.8928e-05, target 0.000120624, opened 2026-10-27 21:34 UTC
- control: SF long at 0.0001515, stop 0.0001212, target 0.0002121, opened 2026-10-27 22:26 UTC
- control: Stonkz long at 0.0002092, stop 0.00016736, target 0.00029288, opened 2026-10-27 23:03 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-27 23:03 UTC control: OPENED Stonkz long at 0.0002092 (stop 0.00016736, target 0.00029288) - control: frozen v3 rules

