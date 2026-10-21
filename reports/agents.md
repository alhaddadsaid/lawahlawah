# Agent desk (paper trading)

Updated 2026-10-21 13:52 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 47 | 19 | -2035.43 | -2465.27 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 48 | 19 | -2140.09 | -2574.22 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: COMPUTE long at 0.0001422, stop 0.00011376, target 0.00019908, opened 2026-10-21 12:24 UTC
- control: Gato long at 0.0001456, stop 0.00011648, target 0.00020384, opened 2026-10-21 13:28 UTC

## Team

API spend today: $0.06 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 13:52 UTC team all (memecoins + gold/forex), spent today $0.057

Scout: No memecoin passes the under-10-minute, h1 above +1000%, top10 below 15% filter. Chupacabra is 13.7 minutes old with h1 +67%, and HUMANOID is 51 minutes old. Macro has no high-impact events in 24h and no fresh catalyst. Crypto headlines are not actionable.
Sniper: No new entries. Gold 41 is at +0.36%, inside its stop (4095) and target (4180), so no change.
Lead: Costs (2.5-5% per side on memes, about $0.5-1/oz on gold) and no edge mean we do nothing. Hold gold 41 and keep watching the memecoin filter.

{"orders": [], "close": [], "note": "13:52 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~20.7h left, +0.36%). Chupacabra (13.7m, h1 +67%) and HUMANOID (51m) fail the filter. No macro events in 24h. Watch next scan: under-10m, h1>+1000%, top10<15%; gold range 4095-4220."}


