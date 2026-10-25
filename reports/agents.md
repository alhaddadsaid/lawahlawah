# Agent desk (paper trading)

Updated 2026-10-25 13:51 UTC. Runs so far: 26. Model: claude-haiku-5-5.

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

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 13:51 UTC team macro (gold/forex), spent today $0.021

Lead: Feeds are still stale (GOLD age about 2452 min, FX about 2427 min). Every entry, stop and target would rest on prices that may no longer be current, so no trade is testable yet.
Scout: No live macro catalyst. The calendar shows no high-impact events in 24h.
FX Scout: EURUSD and GBPUSD have no fresh levels to set a stop and target against.
Skeptic: Reject any order until feed age is under about 60 minutes and the pre-registered GOLD short setup (hourly close below 4000 after a failed rebound) can be checked.
Decision: stay flat again.

{"orders": [], "close": [], "note": "13:51 UTC: flat. GOLD 4007.9, EURUSD 1.12045, GBPUSD 1.33749 still stale ~41h, so no live verification. Priority: restore live feed. Watch if live: GOLD short 1% only on hourly close below 4000 after a failed rebound (stop above rebound high, target 3989 low, max 12h). FX: no setup until fresh data."}

- control: order KURUMI REJECTED by guardrails: KURUMI already open

