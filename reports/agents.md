# Agent desk (paper trading)

Updated 2026-10-28 08:26 UTC. Runs so far: 38. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 959 | 32 | -24459.1 | -33667.72 |
| control | macro | 19 | 42 | -261.01 | -363.42 |
| control | all | 978 | 32 | -24720.11 | -34031.14 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- team: GBPUSD short at 1.32892, stop 1.334, target 1.324, opened 2026-10-28 06:14 UTC
- control: SIB long at 0.0003261, stop 0.00026088, target 0.00045654, opened 2026-10-28 07:51 UTC
- control: DICTATOR long at 5.922e-05, stop 4.7376e-05, target 8.2908e-05, opened 2026-10-28 07:54 UTC
- control: Grokbot long at 0.0001302, stop 0.00010416, target 0.00018228, opened 2026-10-28 08:00 UTC
- control: Robotaxi long at 0.0002537, stop 0.00020296, target 0.00035518, opened 2026-10-28 08:03 UTC
- control: Frongus long at 0.0001879, stop 0.00015032, target 0.00026306, opened 2026-10-28 08:20 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Grokbot REJECTED by guardrails: desk already has the maximum open positions

