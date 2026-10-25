# Agent desk (paper trading)

Updated 2026-10-25 09:14 UTC. Runs so far: 25. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 531 | 31 | -14260.43 | -19340.79 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 540 | 32 | -14067.06 | -19189.88 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Moustache long at 0.0001275, stop 0.000102, target 0.0001785, opened 2026-10-25 07:31 UTC
- control: Marvin long at 0.0001217, stop 9.736e-05, target 0.00017038, opened 2026-10-25 08:59 UTC
- control: Chubby long at 0.0001437, stop 0.00011496, target 0.00020118, opened 2026-10-25 09:05 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 09:14 UTC team macro (gold/forex), spent today $0.014

Lead: Feeds are still stale (GOLD age about 36h, FX about 36h), so we cannot verify live prices, stops or spreads. Skeptic: no pre-registered entry is valid on stale data. Scout and FX Scout: no high-impact calendar events in the next 24h, so there is no event edge to test. Sniper: no order can be sized safely. Journal shows 18 trades at -$360 net, and the memecoin filter has repeatedly failed. Decision: stay flat again and keep the feed-restore priority.

{"orders": [], "close": [], "note": "10-25 09:14 UTC flat, no orders. Feeds stale ~36h (GOLD 4007.9, EURUSD 1.12045, GBPUSD 1.33749), no live verification. Priority: restore live feed before any trade. Watch: GOLD short 1% only on a live hourly close below 4000 after a failed bounce, stop above the bounce high, target 5d low area; FX only on a live print with no high-impact event in 24h. Memecoin filter (age<10m, h1>+1000%, top10<15%) has lost money in 8 of 9 trades; do not trade it without a new hypothesis."}


