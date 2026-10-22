# Agent desk (paper trading)

Updated 2026-10-22 08:09 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 136 | 22 | -6139.66 | -7377.05 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 141 | 23 | -5962.55 | -7227.35 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4108, stop 4082.5, target 4140.5, opened 2026-10-22 06:56 UTC
- control: SURY long at 0.0001157, stop 9.256e-05, target 0.00016198, opened 2026-10-22 07:17 UTC
- control: ClapCat long at 7.35e-05, stop 5.88e-05, target 0.0001029, opened 2026-10-22 08:09 UTC

## Team

API spend today: $0.10 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 08:09 UTC team all (memecoins), spent today $0.099

Lead: Hold gold 156. Price is about 4101, near entry 4108, with the stop at 4082.5 and target at 4140.5. No high-impact events in 24h, so there's no reason to add or cut.
Scout: No memecoin passes the filter. Rockstar fails the age gate at 50m, and OA, MONEYBIZ, Dacity, PHP and ClapCat all fail h1 or age.
Sniper: No new orders. Keep the existing stop and target. Watch for any memecoin under 10m old with h1 above +1000%, top10 under 15% and adequate liquidity.

{"orders": [], "close": [], "note": "08:09 no orders. Hold gold 156 (entry 4108, now ~4101.4, stop 4082.5, target 4140.5, ~22h left). No memecoin passes filter (Rockstar 50m old fails age gate despite h1 +4006%; OA, MONEYBIZ, Dacity, PHP, ClapCat fail). Watch: any memecoin under 10m with h1 >+1000%, top10 <15%, adequate liquidity and firm m5 volume."}

- 2026-10-22 08:09 UTC control: OPENED ClapCat long at 7.35e-05 (stop 5.88e-05, target 0.0001029) - control: frozen v3 rules

