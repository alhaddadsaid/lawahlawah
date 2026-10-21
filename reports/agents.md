# Agent desk (paper trading)

Updated 2026-10-21 20:26 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 6 | 83 | -9.39 | -24.52 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 6 | 83 | -9.39 | -24.52 |
| control | meme | 74 | 23 | -3443.38 | -4114.01 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 77 | 23 | -3548.51 | -4234.99 |

Verdict: too early, 6 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- team: TikTok US long at 0.0005283, stop 0.000449, target 0.000634, opened 2026-10-21 20:26 UTC
- control: DARKCAT long at 8.757e-05, stop 7.0056e-05, target 0.000122598, opened 2026-10-21 18:34 UTC
- control: Pokémon long at 0.0004, stop 0.00032, target 0.00056, opened 2026-10-21 18:40 UTC
- control: PsyopAnime long at 0.0005293, stop 0.00042344, target 0.00074102, opened 2026-10-21 19:08 UTC
- control: DacityCoin long at 0.000189, stop 0.0001512, target 0.0002646, opened 2026-10-21 19:17 UTC
- control: KIMCHINU long at 0.0001942, stop 0.00015536, target 0.00027188, opened 2026-10-21 20:26 UTC

## Team

API spend today: $0.13 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 20:26 UTC team all (memecoins), spent today $0.128

Lead: Gold 41 is inside its plan (4153 vs stop 4095, target 4180), so we hold. Scout: TikTok US (7.6m old, h1 +1077%, top10 14.2%, $61k liquidity) passes the filter we set. Sniper: a small 1% test with a stop about 15% below and a 1-hour cap. Its m5 is already +15.8%, so entry risk is high. UMI fails on h1 and age is 25m. Hypothesis: a sub-10m filter pass continues +20% before costs.

{"orders": [{"market": "meme", "symbol": "TikTok US", "mint": "CRDEX8EUUChjmM5MwuwQEgu1YBuksFQVvYuSur55pump", "side": "long", "size_pct": 1, "stop": 0.000449, "target": 0.000634, "max_hours": 1, "by": "Sniper", "hypothesis": "Memecoin under 10m old with h1 over +1000% and top10 under 15% continues up 20% before costs; test at small size given extended m5"}], "close": [], "note": "20:26 hold gold 41 (stop 4095, target 4180, ~14h left). Opened TikTok US 1% test, stop 0.000449, target 0.000634, 1h cap. Watch: under-10m, h1>+1000%, top10<15%, liquidity adequate; avoid entries after m5 >+15%."}

- 2026-10-21 20:26 UTC team: OPENED TikTok US long 1.0% at 0.0005283 (stop 0.000449, target 0.000634, max 1.0h) [Sniper] Memecoin under 10m old with h1 over +1000% and top10 under 15% continues up 20% before costs; test at small size given extended m5
- 2026-10-21 20:26 UTC control: OPENED KIMCHINU long at 0.0001942 (stop 0.00015536, target 0.00027188) - control: frozen v3 rules

