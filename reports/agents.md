# Agent desk (paper trading)

Updated 2026-10-25 17:04 UTC. Runs so far: 27. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 578 | 32 | -15197.43 | -20735.85 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 587 | 33 | -15004.06 | -20584.94 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: SHADOW long at 0.000221, stop 0.0001768, target 0.0003094, opened 2026-10-25 16:30 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-25 17:04 UTC team macro (gold/forex), spent today $0.026

Lead: No trades. GOLD, EURUSD and GBPUSD quotes are about 44 hours stale (age_min ~2640), so nothing can be verified or sized safely. Skeptic: the memecoin filter hypothesis has lost money in every variant (stops and agent exits), and the account is down $360. Scout: no fresh macro catalyst, and the calendar is empty for 24h. Sniper: no order without a live price and a pre-registered stop. Team stays flat until the feed is restored.

{"orders": [], "close": [], "note": "17:04 UTC flat, no orders. GOLD 4007.9, EURUSD 1.12045, GBPUSD 1.33749 still stale ~44h; do not trade stale prices. Priority: restore live feeds. Watch if live: GOLD short 1% only on hourly close below 4000 after failed rebound (stop above rebound high, target 3980ish, max 12h). Memecoin filter hypothesis (age<10m, h1>+1000%, top10<15%) has failed repeatedly; retire unless a new, tested variant is pre-registered."}


