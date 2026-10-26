# Agent desk (paper trading)

Updated 2026-10-26 05:26 UTC. Runs so far: 29. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 657 | 32 | -18285.94 | -24555.44 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 666 | 32 | -18092.57 | -24404.53 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33828, stop 1.33748, target 1.33947, opened 2026-10-26 03:02 UTC
- control: ROFLAMP long at 0.0001689, stop 0.00013512, target 0.00023646, opened 2026-10-26 04:44 UTC
- control: Bow long at 0.0002006, stop 0.00016048, target 0.00028084, opened 2026-10-26 05:17 UTC
- control: ApeLax long at 0.000114, stop 9.12e-05, target 0.0001596, opened 2026-10-26 05:20 UTC
- control: Shinagami long at 0.0001326, stop 0.00010608, target 0.00018564, opened 2026-10-26 05:26 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-26 05:26 UTC control: OPENED Shinagami long at 0.0001326 (stop 0.00010608, target 0.00018564) - control: frozen v3 rules

