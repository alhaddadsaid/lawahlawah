# Agent desk (paper trading)

Updated 2026-10-26 10:10 UTC. Runs so far: 30. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 685 | 31 | -19238.83 | -25771.05 |
| control | macro | 10 | 50 | 72.9 | 22.91 |
| control | all | 695 | 31 | -19165.93 | -25748.14 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Bow long at 8.031e-05, stop 6.4248e-05, target 0.000112434, opened 2026-10-26 08:18 UTC
- control: LAB long at 0.0002987, stop 0.00023896, target 0.00041818, opened 2026-10-26 09:22 UTC
- control: FOMOPAD long at 0.0001188, stop 9.504e-05, target 0.00016632, opened 2026-10-26 09:34 UTC
- control: PAIR long at 0.0001739, stop 0.00013912, target 0.00024346, opened 2026-10-26 09:37 UTC
- control: GBPUSD short at 1.33453, stop 1.33531, target 1.33335, opened 2026-10-26 10:01 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order LAB REJECTED by guardrails: desk already has the maximum open positions

