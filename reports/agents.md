# Agent desk (paper trading)

Updated 2026-11-16 15:55 UTC. Runs so far: 109. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3087 | 31 | -76811.72 | -106503.52 |
| control | macro | 63 | 49 | 112.17 | -202.74 |
| control | all | 3150 | 32 | -76699.55 | -106706.26 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: Socks long at 9.029e-05, stop 7.2232e-05, target 0.000126406, opened 2026-11-16 13:58 UTC
- control: DIGS long at 0.0001774, stop 0.00014192, target 0.00024836, opened 2026-11-16 14:50 UTC
- control: bill long at 0.0001257, stop 0.00010056, target 0.00017598, opened 2026-11-16 15:06 UTC
- control: hello long at 0.0001135, stop 9.08e-05, target 0.0001589, opened 2026-11-16 15:21 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order hello REJECTED by guardrails: hello already open

