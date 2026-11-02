# Agent desk (paper trading)

Updated 2026-11-02 00:00 UTC. Runs so far: 57. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1502 | 31 | -39498.33 | -53890.61 |
| control | macro | 28 | 46 | -141.99 | -292.93 |
| control | all | 1530 | 31 | -39640.32 | -54183.54 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: RAM long at 0.000117, stop 9.36e-05, target 0.0001638, opened 2026-11-01 22:01 UTC
- control: ARNOLD long at 8.163e-05, stop 6.5304e-05, target 0.000114282, opened 2026-11-01 22:04 UTC
- control: CHAD long at 0.0005415, stop 0.0004332, target 0.0007581, opened 2026-11-01 23:34 UTC
- control: CYBERLEEK long at 0.001755, stop 0.001404, target 0.002457, opened 2026-11-01 23:40 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED PI (stop) P&L $-56.53 normal, $-65.34 pessimistic

