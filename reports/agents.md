# Agent desk (paper trading)

Updated 2026-10-21 13:10 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 46 | 20 | -1835.67 | -2260.37 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 47 | 19 | -1940.33 | -2369.32 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: COMPUTE long at 0.0001422, stop 0.00011376, target 0.00019908, opened 2026-10-21 12:24 UTC

## Team

API spend today: $0.05 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 13:10 UTC team all (memecoins + gold/forex), spent today $0.049

Scout: Pokecity (849m old, h1 +51%) and PHP (476m old, h1 -9%) fail the under-10-minute, h1 above +1000%, top10 under 15% filter. Memecoin hypothesis stays paused.
Sniper: No clean setup. No new orders.
Lead: Hold gold 41 with its stop at 4095 and target at 4180. No macro catalyst and no calendar events in 24h, so no new macro entry. Stay flat on memecoins.

{"orders": [], "close": [], "note": "13:10 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~21.4h left). Pokecity 849m and PHP 476m fail age/h1 filter; memecoin hypothesis stays paused. Watch next scan: under-10m, h1>+1000%, top10<15%. No macro catalyst or high-impact calendar events in next 24h."}


