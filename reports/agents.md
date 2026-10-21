# Agent desk (paper trading)

Updated 2026-10-21 10:59 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 3 | 67 | -29.59 | -36.53 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 3 | 67 | -29.59 | -36.53 |
| control | meme | 35 | 17 | -1522.08 | -1842.01 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 36 | 17 | -1626.74 | -1950.96 |

Verdict: too early, 3 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: startupSI long at 6.068e-05, stop 4.8544e-05, target 8.4952e-05, opened 2026-10-21 09:49 UTC
- control: BAKDINU long at 7.749e-05, stop 6.1992e-05, target 0.000108486, opened 2026-10-21 10:50 UTC
- control: COMPUTE long at 0.0001575, stop 0.000126, target 0.0002205, opened 2026-10-21 10:53 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 10:59 UTC team all (memecoins), spent today $0.026

Scout: MONEYBIZ passes liquidity and top10, but it is 1311 minutes old with +10% 1h, so it fails the age and momentum filter. No other memecoin qualifies. Gold 41 is at +0.16% with stop 4095 and target 4180, so holding is the plan. Lead: no new orders. YouTube 42 looks closed by its stop; the open feed shows only gold 41, so I'm not closing anything. Sniper: nothing to size.

{"orders": [], "close": [], "note": "10:59 flat, no new orders. MONEYBIZ (22h old, h1 +10%) fails age/h1 filters. Hold gold 41 (stop 4095, target 4180, 24h). Verify YouTube 42 is closed (journal says stopped, feed shows only 41). Watch: any token under 10m with h1 over +1000% and top10 under 15%; log price at 5/15/30/60m if one appears."}

- control: order startupSI REJECTED by guardrails: startupSI already open

