# Agent desk (paper trading)

Updated 2026-10-24 22:54 UTC. Runs so far: 23. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 485 | 32 | -12931.01 | -17573.66 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 494 | 32 | -12737.64 | -17422.75 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Bunnett long at 0.0001817, stop 0.00014536, target 0.00025438, opened 2026-10-24 21:53 UTC
- control: WILDWOOD long at 6.339e-05, stop 5.0712e-05, target 8.8746e-05, opened 2026-10-24 22:48 UTC
- control: Moustache long at 0.000175, stop 0.00014, target 0.000245, opened 2026-10-24 22:51 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-24 22:54 UTC team macro (gold/forex), spent today $0.036

Scout: Gold is at 4007.9, still above the 4000 trigger, and every feed is about 25 to 26 hours stale, so nothing is verifiable.
Skeptic: The watch-list short has no live hourly close below 4000 and no confirmed 4020 retest. Costs also rule out fresh memecoin and FX entries without live data.
Lead: Stay flat and restore the live feed before any new hypothesis. The recent gold and memecoin losses argue against forcing a trade.

{"orders": [], "close": [], "note": "22:54 UTC flat, no orders; feeds stale about 26h (GOLD age 1560m, FX 1530m). Watch list unchanged: GOLD short 1% on live hourly close below 4000 with failed 4020 retest, stop 4035, max 12h. Priority: restore live feed before any new trade."}


