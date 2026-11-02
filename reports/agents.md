# Agent desk (paper trading)

Updated 2026-11-02 20:21 UTC. Runs so far: 59. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1601 | 31 | -42729.38 | -58054.26 |
| control | macro | 33 | 45 | -205.92 | -386.53 |
| control | all | 1634 | 31 | -42935.3 | -58440.79 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: DIGS long at 8.806e-05, stop 7.0448e-05, target 0.000123284, opened 2026-11-02 18:37 UTC
- control: PEACE long at 0.0001017, stop 8.136e-05, target 0.00014238, opened 2026-11-02 19:38 UTC
- control: GBPUSD short at 1.34111, stop 1.34261, target 1.33886, opened 2026-11-02 20:00 UTC
- control: CAPY long at 0.0003215, stop 0.0002572, target 0.0004501, opened 2026-11-02 20:18 UTC
- control: CAPYTISTAS long at 5.807e-05, stop 4.6456e-05, target 8.1298e-05, opened 2026-11-02 20:21 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-02 20:21 UTC control: OPENED CAPYTISTAS long at 5.807e-05 (stop 4.6456e-05, target 8.1298e-05) - control: frozen v3 rules

