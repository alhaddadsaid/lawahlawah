# Agent desk (paper trading)

Updated 2026-10-28 03:29 UTC. Runs so far: 37. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 927 | 32 | -24248.0 | -33133.8 |
| control | macro | 18 | 44 | -152.98 | -251.79 |
| control | all | 945 | 32 | -24400.98 | -33385.59 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4065, stop 4051.11, target 4085.83, opened 2026-10-27 15:00 UTC
- control: DICTATOR long at 8.788e-05, stop 7.0304e-05, target 0.000123032, opened 2026-10-28 01:29 UTC
- control: HACHI long at 8.324e-05, stop 6.6592e-05, target 0.000116536, opened 2026-10-28 01:53 UTC
- control: PRIVACY long at 7.331e-05, stop 5.8648e-05, target 0.000102634, opened 2026-10-28 03:23 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED FRONGUS (stop) P&L $-51.12 normal, $-60.07 pessimistic

