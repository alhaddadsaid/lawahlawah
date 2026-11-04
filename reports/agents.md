# Agent desk (paper trading)

Updated 2026-11-04 12:50 UTC. Runs so far: 65. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1798 | 31 | -48593.13 | -65788.13 |
| control | macro | 37 | 43 | -389.1 | -583.13 |
| control | all | 1835 | 31 | -48982.23 | -66371.26 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4054.2, stop 4033.26, target 4085.61, opened 2026-11-04 10:02 UTC
- control: TTPRO long at 8.517e-05, stop 6.8136e-05, target 0.000119238, opened 2026-11-04 11:40 UTC
- control: STONKS long at 0.0007479, stop 0.00059832, target 0.00104706, opened 2026-11-04 11:43 UTC
- control: Mag long at 0.0001081, stop 8.648e-05, target 0.00015134, opened 2026-11-04 12:04 UTC
- control: CAPY long at 0.0004387, stop 0.00035096, target 0.00061418, opened 2026-11-04 12:50 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-04 12:50 UTC control: OPENED CAPY long at 0.0004387 (stop 0.00035096, target 0.00061418) - control: frozen v3 rules

