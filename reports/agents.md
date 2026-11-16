# Agent desk (paper trading)

Updated 2026-11-16 14:05 UTC. Runs so far: 109. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3075 | 31 | -76584.04 | -106158.59 |
| control | macro | 62 | 50 | 221.89 | -87.52 |
| control | all | 3137 | 32 | -76362.15 | -106246.11 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: bill long at 0.0001749, stop 0.00013992, target 0.00024486, opened 2026-11-16 12:24 UTC
- control: DOUG long at 0.0001266, stop 0.00010128, target 0.00017724, opened 2026-11-16 13:49 UTC
- control: BUTTHOLE long at 0.0007328, stop 0.00058624, target 0.00102592, opened 2026-11-16 13:55 UTC
- control: Socks long at 9.029e-05, stop 7.2232e-05, target 0.000126406, opened 2026-11-16 13:58 UTC
- control: GBPUSD long at 1.32003, stop 1.31894, target 1.32166, opened 2026-11-16 14:02 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Stumpy REJECTED by guardrails: desk already has the maximum open positions

