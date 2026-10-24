# Agent desk (paper trading)

Updated 2026-10-24 02:09 UTC. Runs so far: 20. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 356 | 30 | -10692.42 | -14069.42 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 365 | 31 | -10499.05 | -13918.51 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: PHP long at 0.000296, stop 0.0002368, target 0.0004144, opened 2026-10-24 00:34 UTC
- control: e/acc long at 0.0004813, stop 0.00038504, target 0.00067382, opened 2026-10-24 00:37 UTC
- control: YMB long at 7.653e-05, stop 6.1224e-05, target 0.000107142, opened 2026-10-24 01:23 UTC
- control: baldcat long at 5.671e-05, stop 4.5368e-05, target 7.9394e-05, opened 2026-10-24 02:03 UTC
- control: ELIZABETH long at 0.0001509, stop 0.00012072, target 0.00021126, opened 2026-10-24 02:06 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order TRUTH REJECTED by guardrails: desk already has the maximum open positions

