# Agent desk (paper trading)

Updated 2026-11-17 23:05 UTC. Runs so far: 113. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3191 | 31 | -80242.19 | -110912.68 |
| control | macro | 66 | 48 | 12.52 | -319.08 |
| control | all | 3257 | 31 | -80229.67 | -111231.76 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GROKIA long at 0.0001305, stop 0.0001044, target 0.0001827, opened 2026-11-17 22:10 UTC
- control: bul long at 6.342e-05, stop 5.0736e-05, target 8.8788e-05, opened 2026-11-17 22:26 UTC
- control: GEKKO long at 5.812e-05, stop 4.6496e-05, target 8.1368e-05, opened 2026-11-17 22:32 UTC
- control: pwease long at 0.002046, stop 0.0016368, target 0.0028644, opened 2026-11-17 22:44 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order GROKIA REJECTED by guardrails: GROKIA already open

