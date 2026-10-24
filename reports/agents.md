# Agent desk (paper trading)

Updated 2026-10-24 23:38 UTC. Runs so far: 24. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 490 | 31 | -13104.75 | -17794.22 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 499 | 32 | -12911.38 | -17643.31 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Bunnett long at 0.0001817, stop 0.00014536, target 0.00025438, opened 2026-10-24 21:53 UTC
- control: Moustache long at 0.000175, stop 0.00014, target 0.000245, opened 2026-10-24 22:51 UTC
- control: WILDWOOD long at 0.0001325, stop 0.000106, target 0.0001855, opened 2026-10-24 23:35 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-24 23:38 UTC team macro (gold/forex), spent today $0.037

Lead: Feeds are about 26h stale (GOLD age 1604m, FX 1574m), so any entry, stop or target would rest on old prices. Scout: the GOLD short trigger (hourly close below 4000 with a failed 4020 retest) is not armed, since last print is 4007.9. Skeptic: no pre-registered hypothesis can be checked against live quotes, so no order passes. Sniper: no size. Decision: flat, keep the watch list, and make restoring the live feed the priority.

{"orders": [], "close": [], "note": "23:38 UTC flat, no orders. Feeds stale ~26h (GOLD age 1604m, FX 1574m); last GOLD 4007.9 is above the 4000 trigger, so the short is not armed. Watch list: GOLD short 1% on live hourly close below 4000 with failed 4020 retest, stop 4035, max 12h, only on live quotes. Priority: restore live feed, then re-check."}

- control: order Moustache REJECTED by guardrails: Moustache already open

