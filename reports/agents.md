# Agent desk (paper trading)

Updated 2026-11-24 10:34 UTC. Runs so far: 133. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3715 | 31 | -92562.38 | -128291.46 |
| control | macro | 78 | 49 | 303.67 | -75.92 |
| control | all | 3793 | 31 | -92258.71 | -128367.38 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: SOLANGELES long at 0.0004212, stop 0.00033696, target 0.00058968, opened 2026-11-24 09:08 UTC
- control: MCAT long at 0.0001978, stop 0.00015824, target 0.00027692, opened 2026-11-24 09:17 UTC
- control: CYBERLEEK long at 0.001269, stop 0.0010152, target 0.0017766, opened 2026-11-24 09:30 UTC
- control: CLAUDIO long at 0.0001415, stop 0.0001132, target 0.0001981, opened 2026-11-24 10:22 UTC
- control: UCASH long at 7.388e-05, stop 5.9104e-05, target 0.000103432, opened 2026-11-24 10:28 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order WIZARD REJECTED by guardrails: desk already has the maximum open positions

