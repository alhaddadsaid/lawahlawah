# Agent desk (paper trading)

Updated 2026-11-01 09:46 UTC. Runs so far: 54. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1421 | 31 | -37333.86 | -50950.83 |
| control | macro | 28 | 46 | -141.99 | -292.93 |
| control | all | 1449 | 32 | -37475.85 | -51243.76 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: INVERSE long at 7.968e-05, stop 6.3744e-05, target 0.000111552, opened 2026-11-01 08:17 UTC
- control: niketyson long at 0.000146, stop 0.0001168, target 0.0002044, opened 2026-11-01 09:19 UTC
- control: KIM long at 0.0002412, stop 0.00019296, target 0.00033768, opened 2026-11-01 09:22 UTC
- control: BNB long at 5.346e-05, stop 4.2768e-05, target 7.4844e-05, opened 2026-11-01 09:43 UTC
- control: paws long at 0.0001232, stop 9.856e-05, target 0.00017248, opened 2026-11-01 09:46 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-01 09:46 UTC control: OPENED paws long at 0.0001232 (stop 9.856e-05, target 0.00017248) - control: frozen v3 rules

