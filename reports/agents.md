# Agent desk (paper trading)

Updated 2026-10-22 01:12 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 100 | 21 | -4866.16 | -5766.97 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 103 | 21 | -4971.29 | -5887.95 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- team: MrBeast long at 0.0005146, stop 0.000386199, target 0.000617122, opened 2026-10-22 01:12 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: EURUSD long at 1.12385, stop 1.12297, target 1.12516, opened 2026-10-22 00:01 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 01:12 UTC team all (memecoins), spent today $0.014

Scout: MrBeast passes every filter (5.4m old, h1 +1062%, top10 14.2%, liquidity $60.6k). Lead: the same filter has lost on most journal trades, with four stops, so this is only a small test, not a bet. Sniper: 0.5% size, stop -25% (0.000388), target +20% (0.00062), 2h max. Gold 41 stays open, with no new macro idea and no calendar events in 24h. GATO, FRENS and the other names fail the age or h1 filters.

{"orders": [{"market": "meme", "symbol": "MrBeast", "mint": "A7qC5p5MmBwGSQbJi5bFEwZaFQTv96LKDdmriru1pump", "side": "long", "size_pct": 0.5, "stop": 0.000388, "target": 0.00062, "max_hours": 2, "by": "Sniper", "hypothesis": "Filter (under 10m old, h1>+1000%, top10<15%) continues up 20% within 2h, net of 2.5-5% costs per side; small test of a historically losing setup"}], "close": [], "note": "01:11 Hold gold 41 (4128, stop 4095, target 4180, ~9.5h left). Test 0.5% MrBeast under the memecoin filter; journal shows this filter lost on most trades, so judge by sample size. Watch next: fresh memecoins under 10m, h1>+1000%, top10<15%; if MrBeast stops, pause new memecoin entries and review filter."}

- 2026-10-22 01:12 UTC team: OPENED MrBeast long 0.5% at 0.0005146 (stop 0.000386199, target 0.000617122, max 2.0h) [Sniper] Filter (under 10m old, h1>+1000%, top10<15%) continues up 20% within 2h, net of 2.5-5% costs per side; small test of a historically losing setup

