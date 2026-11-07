# Agent desk (paper trading)

Updated 2026-11-07 15:01 UTC. Runs so far: 76. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2143 | 31 | -56810.28 | -77333.12 |
| control | macro | 45 | 47 | -2.88 | -226.41 |
| control | all | 2188 | 31 | -56813.16 | -77559.53 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4069.6, stop 4054.07, target 4092.89, opened 2026-11-06 17:23 UTC
- control: ARNOLD long at 0.000179, stop 0.0001432, target 0.0002506, opened 2026-11-07 13:32 UTC
- control: SLOPCORE long at 0.0002573, stop 0.00020584, target 0.00036022, opened 2026-11-07 14:03 UTC
- control: duge long at 0.0001735, stop 0.0001388, target 0.0002429, opened 2026-11-07 14:39 UTC
- control: debtdog long at 0.000153, stop 0.0001224, target 0.0002142, opened 2026-11-07 15:01 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-11-07 15:01 UTC control: OPENED debtdog long at 0.000153 (stop 0.0001224, target 0.0002142) - control: frozen v3 rules

