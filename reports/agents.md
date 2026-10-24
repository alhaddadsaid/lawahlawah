# Agent desk (paper trading)

Updated 2026-10-24 10:45 UTC. Runs so far: 21. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 415 | 30 | -11743.74 | -15698.9 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 424 | 31 | -11550.37 | -15547.99 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: SHADOW long at 0.0001502, stop 0.00012016, target 0.00021028, opened 2026-10-24 09:04 UTC
- control: YMB long at 0.0003175, stop 0.000254, target 0.0004445, opened 2026-10-24 10:08 UTC
- control: GORD long at 0.0002022, stop 0.00016176, target 0.00028308, opened 2026-10-24 10:36 UTC
- control: COIL long at 0.000138, stop 0.0001104, target 0.0001932, opened 2026-10-24 10:39 UTC
- control: HUG long at 9.047e-05, stop 7.2376e-05, target 0.000126658, opened 2026-10-24 10:45 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- 2026-10-24 10:45 UTC control: OPENED HUG long at 9.047e-05 (stop 7.2376e-05, target 0.000126658) - control: frozen v3 rules

