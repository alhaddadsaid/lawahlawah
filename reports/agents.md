# Agent desk (paper trading)

Updated 2026-11-02 06:28 UTC. Runs so far: 58. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1538 | 31 | -40530.39 | -55265.45 |
| control | macro | 29 | 45 | -262.25 | -418.81 |
| control | all | 1567 | 31 | -40792.64 | -55684.26 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: KIM long at 9.549e-05, stop 7.6392e-05, target 0.000133686, opened 2026-11-02 05:15 UTC
- control: Peace  long at 5.988e-05, stop 4.7904e-05, target 8.3832e-05, opened 2026-11-02 05:54 UTC
- control: STEALTH long at 0.0001382, stop 0.00011056, target 0.00019348, opened 2026-11-02 06:10 UTC
- control: PEACE long at 0.0001946, stop 0.00015568, target 0.00027244, opened 2026-11-02 06:13 UTC
- control: Catori long at 0.0001025, stop 8.2e-05, target 0.0001435, opened 2026-11-02 06:25 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order PEACE REJECTED by guardrails: desk already has the maximum open positions

