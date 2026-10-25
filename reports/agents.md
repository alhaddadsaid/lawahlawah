# Agent desk (paper trading)

Updated 2026-10-25 14:13 UTC. Runs so far: 26. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 560 | 32 | -14814.24 | -20177.87 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 569 | 32 | -14620.87 | -20026.96 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: LAUNCH long at 0.0002006, stop 0.00016048, target 0.00028084, opened 2026-10-25 13:24 UTC
- control: KURUMI long at 0.0001704, stop 0.00013632, target 0.00023856, opened 2026-10-25 13:36 UTC
- control: BASE long at 0.000102, stop 8.16e-05, target 0.0001428, opened 2026-10-25 14:03 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 14:13 UTC team macro (gold/forex), spent today $0.022

Lead: Feeds are still stale (GOLD age ~2473 min, FX ~2448 min), so the 4007.9 and FX prices can't be verified against live markets. Scout: the GOLD short idea needs a live hourly close below 4000. FX Scout: no high-impact events in 24h and no live FX levels, so nothing to size. Skeptic: any stop, target, or fill set on stale data fails the audit. Memecoin book is 18 trades, -$360, so no new memecoin entries. Sniper: no orders. Decision: stay flat until live data returns.

{"orders": [], "close": [], "note": "14:12 UTC flat, no orders. GOLD 4007.9 and EURUSD/GBPUSD feeds stale ~41h, no live verification. Priority: restore live feed. Watch if live: GOLD short 1% only on hourly close below 4000 after failed rebound (stop above rebound high, target 3989, max hold 12h); FX only with fresh levels and a pre-registered stop/target/hold. Memecoin book -$360 over 18 trades; no new memecoin entries."}

- control: order KURUMI REJECTED by guardrails: KURUMI already open

