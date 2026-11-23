# Agent desk (paper trading)

Updated 2026-11-23 21:12 UTC. Runs so far: 132. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 3671 | 31 | -92147.5 | -127435.91 |
| control | macro | 76 | 49 | 264.62 | -108.03 |
| control | all | 3747 | 31 | -91882.88 | -127543.94 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: MCAT long at 0.000237, stop 0.0001896, target 0.0003318, opened 2026-11-23 21:12 UTC
- control: EURUSD short at 1.09063, stop 1.09218, target 1.08831, opened 2026-11-23 21:12 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

## Run started 2026-11-23 21:11 UTC
- control: CLOSED CYBERLEEK (time, while away) P&L $-12.35 normal, $-22.29 pessimistic
- control: CLOSED DIGS (time, while away) P&L $-20.97 normal, $-30.68 pessimistic
- control: CLOSED ZOL (time, while away) P&L $-27.56 normal, $-37.11 pessimistic
- control: CLOSED HUNG (stop, while away) P&L $-153.91 normal, $-160.22 pessimistic
- control: CLOSED MCAT (time, while away) P&L $-43.52 normal, $-52.66 pessimistic
- team: model call failed:  HTTP 401: invalid x-api-key
- 2026-11-23 21:12 UTC control: OPENED MCAT long at 0.000237 (stop 0.0001896, target 0.0003318) - control: frozen v3 rules
- 2026-11-23 21:12 UTC control: OPENED EURUSD short at 1.09063 (stop 1.09218, target 1.08831) - control: random direction

