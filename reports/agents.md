# Agent desk (paper trading)

Updated 2026-10-26 22:42 UTC. Runs so far: 32. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 769 | 31 | -21434.91 | -28772.35 |
| control | macro | 11 | 45 | -58.52 | -116.18 |
| control | all | 780 | 31 | -21493.43 | -28888.53 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD short at 4032.1, stop 4044.41, target 4013.64, opened 2026-10-26 17:00 UTC
- control: RAYPAD long at 0.0001274, stop 0.00010192, target 0.00017836, opened 2026-10-26 21:44 UTC
- control: KANE long at 7.534e-05, stop 6.0272e-05, target 0.000105476, opened 2026-10-26 22:36 UTC
- control: NOMO long at 0.0001582, stop 0.00012656, target 0.00022148, opened 2026-10-26 22:42 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-26 22:42 UTC control: OPENED NOMO long at 0.0001582 (stop 0.00012656, target 0.00022148) - control: frozen v3 rules

