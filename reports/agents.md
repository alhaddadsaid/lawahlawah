# Agent desk (paper trading)

Updated 2026-10-25 20:36 UTC. Runs so far: 27. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 600 | 32 | -16393.67 | -22127.07 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 609 | 32 | -16200.3 | -21976.16 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: goon long at 6.965e-05, stop 5.572e-05, target 9.751e-05, opened 2026-10-25 19:17 UTC
- control: AMC long at 0.0001641, stop 0.00013128, target 0.00022974, opened 2026-10-25 20:06 UTC
- control: LUCIASS long at 8.128e-05, stop 6.5024e-05, target 0.000113792, opened 2026-10-25 20:33 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 20:36 UTC team macro (gold/forex), spent today $0.031

Lead: Gold and FX quotes are about 47 hours stale, so no edge can be checked against live prices.
Scout: Only stale-price ideas are available, and they can't be verified.
FX Scout: No EUR/USD or GBP/USD setup is valid without live quotes, and the calendar has no high-impact events in the next 24h.
Skeptic: Any entry, stop, or target would rest on unverified prices. Rejected.
Sniper: Standing by. Nothing to execute.
Decision: flat. Restore live feeds first.

{"orders": [], "close": [], "note": "20:36 UTC flat, no orders. GOLD 4007.9, EURUSD 1.12045, GBPUSD 1.33749 still stale ~47h. Priority: restore live feeds. Watch if live: GOLD short 1% only on hourly close below 4000 after a failed rebound toward 4020, stop above rebound high, target 3980 area. No calendar events in 24h."}


