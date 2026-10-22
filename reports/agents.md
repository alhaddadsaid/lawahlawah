# Agent desk (paper trading)

Updated 2026-10-22 01:33 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 100 | 21 | -4866.16 | -5766.97 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 103 | 21 | -4971.29 | -5887.95 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: EURUSD long at 1.12385, stop 1.12297, target 1.12516, opened 2026-10-22 00:01 UTC
- control: SURY long at 0.0001972, stop 0.00015776, target 0.00027608, opened 2026-10-22 01:27 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 01:33 UTC team all (memecoins), spent today $0.019

Scout: fAu (11 min old, h1 +37%, top10 19.9%) misses the under-10-minute age cut. MERCURY (top10 20.2%) and Speed (23 min old) also fail. No memecoin passes the filter.
Sniper: no entries, so no orders.
Lead: Hold gold 41 at 4126.6 with stop 4095 and target 4180 (about 9 hours left). The memecoin filter has lost on most trades, so I won't force a trade into a marginal setup. Gold's stop and target are unchanged.

{"orders": [], "close": [], "note": "01:33 no orders. Hold gold 41 (4126.6, stop 4095, target 4180, ~9h left). fAu (11m, h1 +37%, top10 19.9%), MERCURY (top10 20.2%) and Speed (23m) fail filter. Watch next: fresh memecoins under 10m, h1>+1000%, top10<15%, liquidity; fAu turns too old within minutes."}


