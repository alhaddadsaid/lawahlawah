# Agent desk (paper trading)

Updated 2026-10-21 12:51 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 45 | 20 | -1785.5 | -2201.23 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 46 | 20 | -1890.16 | -2310.18 |

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

### 2026-10-21 12:51 UTC team all (memecoins), spent today $0.046

Scout: Datacenter (10.3m old, h1 +1414%) fails on top10 at 29% vs the <15% rule. Lovot fails age (30m) and h1 (+419%). No new memecoin setup.
Sniper: No clean entry. Gold 41 is inside its stop and target and has about 21.8h left, so I'm holding it.
Lead: Do nothing. The memecoin hypothesis stays paused, and I'll resume it only if a token passes all three filters.
{"orders": [], "close": [], "note": "12:51 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~21.8h left, +0.19%). Datacenter fails top10 (29%), Lovot fails age (30m). Memecoin hypothesis stays paused. Watch: under-10m, h1>+1000%, top10<15%. Calendar empty; no macro edge identified."}


