# Agent desk (paper trading)

Updated 2026-11-21 13:37 UTC. Runs so far: 124. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3502 | 31 | -88506.94 | -122155.34 |
| control | macro | 73 | 49 | 253.03 | -107.23 |
| control | all | 3575 | 31 | -88253.91 | -122262.57 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.30811, stop 1.30687, target 1.30997, opened 2026-11-20 21:02 UTC
- control: CYBERLEEK long at 0.001746, stop 0.0013968, target 0.0024444, opened 2026-11-21 12:08 UTC
- control: Singularity long at 9.943e-05, stop 7.9544e-05, target 0.000139202, opened 2026-11-21 12:11 UTC
- control: jingyu long at 9.503e-05, stop 7.6024e-05, target 0.000133042, opened 2026-11-21 12:27 UTC
- control: DIGS long at 0.0002649, stop 0.00021192, target 0.00037086, opened 2026-11-21 12:45 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order jingyu REJECTED by guardrails: desk already has the maximum open positions

