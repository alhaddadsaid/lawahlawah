# Agent desk (paper trading)

Updated 2026-10-21 12:00 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 41 | 20 | -1603.8 | -1983.16 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 42 | 19 | -1708.46 | -2092.11 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: HUSH long at 5.752e-05, stop 4.6016e-05, target 8.0528e-05, opened 2026-10-21 12:00 UTC

## Team

API spend today: $0.04 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 12:00 UTC team all (memecoins), spent today $0.037

Lead: Hold. Gold 41 is +0.46% with stop 4095 and target 4180 intact. No memecoin passes the under-10m, h1>+1000%, top10<15% filter. HUSH is 65m old and falls 14% on the hour, and GATO and CBUCKS are old with flat or negative h1. Scout: the filter has been empty all day, so we are not forcing trades. Sniper: no new orders.

{"orders": [], "close": [], "note": "12:00 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~22.7h left). Memecoin filter still empty (HUSH 65m, GATO 82k min, CBUCKS 21k min all fail). Next scan: token under 10m old with h1>+1000% and top10<15%; if none, stay flat."}

- 2026-10-21 12:00 UTC control: OPENED HUSH long at 5.752e-05 (stop 4.6016e-05, target 8.0528e-05) - control: frozen v3 rules

