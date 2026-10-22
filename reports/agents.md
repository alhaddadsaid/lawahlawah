# Agent desk (paper trading)

Updated 2026-10-22 17:27 UTC. Runs so far: 14. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 179 | 27 | -6536.11 | -8204.33 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 184 | 28 | -6359.0 | -8054.63 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: BURNIE long at 0.0008249, stop 0.00065992, target 0.00115486, opened 2026-10-22 15:52 UTC
- control: MONEYBIZ long at 0.0001235, stop 9.88e-05, target 0.0001729, opened 2026-10-22 17:24 UTC
- control: SOLYA long at 0.0001297, stop 0.00010376, target 0.00018158, opened 2026-10-22 17:27 UTC

## Team

API spend today: $0.12 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

### 2026-10-22 17:27 UTC team macro (gold/forex), spent today $0.118

Scout: Gold at 4058.4 is still below the 4059.5 no-long line and near the 5d low of 4049.1. No reclaim of 4090, so the long trigger hasn't fired.
Lead: The journal's memecoin and gold losses argue against forcing trades. No memecoin candidates are in the feed. EUR/USD is near its 5d low with no high-impact events in 24h, so there's no edge after costs. GBP/USD is mid-range.
Sniper: No orders. Gold long only on an hourly close above 4090.
FX Scout: No EUR/USD or GBP/USD setup. Waiting for a catalyst.

{"orders": [], "close": [], "note": "22 17:27 no orders. Gold 4058.4 below 4059.5 no-long line, 5d low 4049.1. Watch: hourly close above 4090 = gold long 1%, stop 4070, target 4120, max 12h. Memecoin filter (age<10m, h1>+1000%, top10<15%, adequate liquidity) still needs candidates. EUR/USD near 5d low, GBP/USD mid-range, no events 24h."}

- 2026-10-22 17:27 UTC control: OPENED SOLYA long at 0.0001297 (stop 0.00010376, target 0.00018158) - control: frozen v3 rules

