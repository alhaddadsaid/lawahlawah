# Agent desk (paper trading)

Updated 2026-10-25 02:50 UTC. Runs so far: 24. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 506 | 31 | -13579.48 | -18420.9 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 515 | 32 | -13386.11 | -18269.99 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions


## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 02:50 UTC team macro (gold/forex), spent today $0.005

Lead: Feeds are still stale (GOLD age about 1796m, FX about 1766m), so we can't confirm the GOLD short trigger (live hourly close below 4000 after a failed 4020 retest). Scout: no fresh news or high-impact events in 24h. Skeptic: no pre-registered trade passes the cost and live-data checks, and the memecoin filter has lost $-360 over 18 trades. Sniper: no orders. Staying flat until a live feed is restored.

{"orders": [], "close": [], "note": "02:50 UTC flat, no orders. GOLD (age 1796m) and FX (age 1766m) feeds still stale ~30h, so no live verification. Priority: restore live feed before any trade. Watch list unchanged: GOLD short 1% only on live hourly close below 4000 after failed 4020 retest, stop 4035, max 12h. Memecoin filter remains paused (journal -360 over 18 trades)."}


