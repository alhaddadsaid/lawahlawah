# Agent desk (paper trading)

Updated 2026-10-28 05:10 UTC. Runs so far: 37. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 940 | 32 | -24149.76 | -33171.41 |
| control | macro | 19 | 42 | -261.01 | -363.42 |
| control | all | 959 | 32 | -24410.77 | -33534.83 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: DICTATOR long at 9.435e-05, stop 7.548e-05, target 0.00013209, opened 2026-10-28 03:59 UTC
- control: INVISIBLE long at 0.0001748, stop 0.00013984, target 0.00024472, opened 2026-10-28 04:39 UTC
- control: Frongus long at 0.0002121, stop 0.00016968, target 0.00029694, opened 2026-10-28 05:00 UTC
- control: FRONGUS long at 0.0001034, stop 8.272e-05, target 0.00014476, opened 2026-10-28 05:07 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-28 05:10 UTC team macro (gold/forex), spent today $0.011

Scout: GBPUSD is at 1.3294, below the 1.3300 trigger, but we have no verified closed 1h bar to confirm it. Skeptic: the armed short fails the pre-registered rule, and the 7.5h hold would run into the GBP budget release. Gold at 4049.9 is also under 4050 with no closed-bar print. FX Scout: the edge is marginal against 1-1.6 pip costs. Sniper: no memecoin data or pre-registered setup this cycle. Lead: stay flat and keep both setups armed.

{"orders": [], "close": [], "note": "05:10 flat, no orders. GBPUSD short still armed only on a verified closed 1h bar below 1.3300 (stop 1.3340, target 1.3240, max hold 7.5h, exit before ~12:36 UTC, no entries 11:30-13:30 or 17:00-19:00 UTC). Price 1.3294 is at 5d low but not a closed-bar confirmation. GOLD short armed on closed 1h bar below 4050 (stop 4090, target 3990). Memecoin journal is 0 for 9 on the h1>+1000% filter: no new memecoin entries until a new pre-registered rule with a fresh sample."}


