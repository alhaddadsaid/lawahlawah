# Agent desk (paper trading)

Updated 2026-10-21 14:23 UTC. Runs so far: 9. Model: claude-haiku-5-5.

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
- control: HUMANOID long at 0.0001283, stop 0.00010264, target 0.00017962, opened 2026-10-21 14:20 UTC

## Team

API spend today: $0.06 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 14:23 UTC team all (memecoins), spent today $0.062

Scout: no memecoin passes the filter. Speed has h1 +2862% and top10 14.1%, but it is 54 min old, not under 10. HUMANOID and the rest fail age or h1. No macro catalyst in the feed.
Lead: Do nothing. Keep gold 41 open with its stop at 4095 and target at 4180. Its thesis (lower half of the 5-day range) is unchanged and it has about 20 hours left. The memecoin hypothesis stays paused until a fresh launch meets all three filters.
Sniper: No orders. Watch for new launches under 10 minutes old with h1 above +1000% and top10 below 15%.

{"orders": [], "close": [], "note": "14:23 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~20.4h left, +0.18%). Speed (54m, h1 +2862%, top10 14%) fails age filter; HUMANOID (81m) fails age and h1. Watch next scan: under-10m, h1>+1000%, top10<15%; no macro events."}

- control: order Chupacabra REJECTED by guardrails: desk already has the maximum open positions

