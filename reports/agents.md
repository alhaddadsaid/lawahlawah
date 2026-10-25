# Agent desk (paper trading)

Updated 2026-10-25 12:47 UTC. Runs so far: 26. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 551 | 32 | -14688.49 | -19963.02 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 560 | 32 | -14495.12 | -19812.11 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: PMUP long at 0.0001755, stop 0.0001404, target 0.0002457, opened 2026-10-25 12:38 UTC
- control: Marvin long at 0.0001016, stop 8.128e-05, target 0.00014224, opened 2026-10-25 12:44 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 12:47 UTC team macro (gold/forex), spent today $0.019

Lead: Gold and FX prices are about 40 hours stale (gold age 2388 min, EUR/USD 2363 min). A stop or target set on a stale price could fire at the wrong level, so no trade is allowed until live data returns.
Skeptic: Rejects any order without a live price. The memecoin pattern (under-10m filter) has lost money across 18 trades, so it is not reopened.
Sniper: Standing by. Gold short 1% is pre-registered only if the feed is live and an hourly close prints below 4000 after a failed rebound.
FX Scout: No live EUR/USD or GBP/USD levels, no calendar events in 24h, so no hypothesis is tested.

{"orders": [], "close": [], "note": "12:47 UTC flat, no orders. GOLD (4007.9, age 2388m) and FX (EURUSD 1.12045, GBPUSD 1.33749, age 2363m) still stale ~39h. Priority: restore live feed. If live: GOLD short 1% only on hourly close below 4000 after failed rebound (stop above rebound high, target 3989 low, max 12h); FX only with live levels and a calendar event; memecoin filter remains retired after 18 losing-or-flat trades."}


