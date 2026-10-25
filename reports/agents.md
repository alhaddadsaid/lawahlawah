# Agent desk (paper trading)

Updated 2026-10-25 21:18 UTC. Runs so far: 27. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 607 | 31 | -16966.22 | -22756.72 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 616 | 32 | -16772.85 | -22605.81 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions


## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 21:18 UTC team macro (gold/forex), spent today $0.032

Lead: Prices are stale (GOLD age about 48h, FX about 48h), so no execution is safe. Skeptic: no pre-registered entry is verifiable on current data, and costs can't be audited. Sniper: no order. FX Scout: no live EUR/USD or GBP/USD levels, so no valid hypothesis. Scout: the GOLD short idea (1% on an hourly close below 4000 after a failed rebound toward 4020) stays on watch until live feeds return. Decision: stand flat.

{"orders": [], "close": [], "note": "21:18 UTC flat, no orders. GOLD 4007.9, EURUSD 1.12045, GBPUSD 1.33749 still stale ~48h; do not trade stale prices. Priority: restore live feeds. Watch if live: GOLD short 1% only on hourly close below 4000 after a failed rebound toward 4020, stop above rebound high, target 3980, max 12h. No high-impact calendar events in next 24h. Memecoin filter ideas: 0 trades, journal 18 trades -360 net, keep sidelined until edge re-tested."}


