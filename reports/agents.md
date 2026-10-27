# Agent desk (paper trading)

Updated 2026-10-27 05:38 UTC. Runs so far: 33. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 813 | 31 | -22680.72 | -30437.51 |
| control | macro | 11 | 45 | -58.52 | -116.18 |
| control | all | 824 | 31 | -22739.24 | -30553.69 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD short at 4032.1, stop 4044.41, target 4013.64, opened 2026-10-26 17:00 UTC
- control: EURUSD short at 1.11744, stop 1.11801, target 1.11659, opened 2026-10-27 03:01 UTC
- control: Wifoween long at 0.0001047, stop 8.376e-05, target 0.00014658, opened 2026-10-27 04:25 UTC
- control: Shitcoin long at 7.638e-05, stop 6.1104e-05, target 0.000106932, opened 2026-10-27 04:49 UTC
- control: HACHI long at 0.000167, stop 0.0001336, target 0.0002338, opened 2026-10-27 05:38 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-27 05:38 UTC control: OPENED HACHI long at 0.000167 (stop 0.0001336, target 0.0002338) - control: frozen v3 rules

