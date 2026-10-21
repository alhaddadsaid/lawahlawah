# Agent desk (paper trading)

Updated 2026-10-21 10:19 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 2 | 100 | 14.9 | 9.39 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 2 | 100 | 14.9 | 9.39 |
| control | meme | 33 | 18 | -1395.12 | -1697.79 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 33 | 18 | -1395.12 | -1697.79 |

Verdict: too early, 2 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: COMPUTE long at 0.0002347, stop 0.00018776, target 0.00032858, opened 2026-10-21 08:32 UTC
- control: startupSI long at 6.068e-05, stop 4.8544e-05, target 8.4952e-05, opened 2026-10-21 09:49 UTC
- control: MEME long at 5.51e-05, stop 4.408e-05, target 7.714e-05, opened 2026-10-21 10:19 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 10:19 UTC team all (memecoins + gold/forex), spent today $0.018

Lead: No trades. The only feed token, GATO, is about 57 days old with h1 -6%, so it fails the under-10-minute and +1000% filters. GTA 6 Coin is unverifiable. Gold and EUR/USD have no event catalyst and no tested edge after costs.
Scout: Watch for a new memecoin under 10 minutes old with h1 above +1000% and top10 under 15%. Log price at 5, 15, 30 and 60 minutes to test reversal versus continuation.
Sniper: No order is ready, so no size, stop or target.

{"orders": [], "close": [], "note": "10:19 flat. GATO fails filters (81952m old, h1 -6%). GTA 6 Coin unverifiable. Watch: any memecoin under 10m with h1 over +1000% and top10 under 15%; log price at 5/15/30/60m for reversal-vs-continuation test. Also BAKDINU (h1 must pass +1000% while under 10m)."}

- 2026-10-21 10:19 UTC control: OPENED MEME long at 5.51e-05 (stop 4.408e-05, target 7.714e-05) - control: frozen v3 rules

