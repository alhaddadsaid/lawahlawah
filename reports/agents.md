# Agent desk (paper trading)

Updated 2026-11-18 18:28 UTC. Runs so far: 115. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3250 | 31 | -81745.82 | -112982.85 |
| control | macro | 69 | 51 | 445.3 | 101.6 |
| control | all | 3319 | 31 | -81300.52 | -112881.25 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: CYBERLEEK long at 0.0013, stop 0.00104, target 0.00182, opened 2026-11-18 16:32 UTC
- control: GOLD long at 3743.3, stop 3724.55, target 3771.43, opened 2026-11-18 17:02 UTC
- control: DCTY long at 0.0002385, stop 0.0001908, target 0.0003339, opened 2026-11-18 17:42 UTC
- control: APCY long at 0.0001165, stop 9.32e-05, target 0.0001631, opened 2026-11-18 18:28 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-18 18:28 UTC control: OPENED APCY long at 0.0001165 (stop 9.32e-05, target 0.0001631) - control: frozen v3 rules

