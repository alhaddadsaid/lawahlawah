# Agent desk (paper trading)

Updated 2026-10-21 20:59 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 7 | 86 | 1.73 | -18.81 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 7 | 86 | 1.73 | -18.81 |
| control | meme | 78 | 23 | -3528.55 | -4238.02 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 81 | 23 | -3633.68 | -4359.0 |

Verdict: too early, 7 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: PsyopAnime long at 0.0005293, stop 0.00042344, target 0.00074102, opened 2026-10-21 19:08 UTC
- control: DacityCoin long at 0.000189, stop 0.0001512, target 0.0002646, opened 2026-10-21 19:17 UTC

## Team

API spend today: $0.13 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 20:59 UTC team all (memecoins + gold/forex), spent today $0.135

Scout: no memecoin passes. KIMCHI (top10 56%) and BABYKIMCHI (h1 +58%) fail, and KATCHI and "4" fail on h1 and age.
Sniper: no new memecoin entries. Gold 41 is still inside its stop and target, so it stays open.
Lead: no new orders. Hold gold 41 (4157.6, stop 4095, target 4180, ~13.8h left). Keep the under-10m, h1>+1000%, top10<15% filter. Economic calendar is empty and gold ATR is about $14/hour, so there is no edge to add.

{"orders": [], "close": [], "note": "20:59 no new orders; hold gold 41 (4157.6, stop 4095, target 4180, ~13.8h left). Memecoin scan: KIMCHI 4m old top10 56% fails; BABYKIMCHI 2m old h1 +58% fails; KATCHI h1 +1% fails; 4 and PHP fail. Watch next: under-10m listings with h1>+1000%, top10<15%, adequate liquidity; avoid chasing near-misses."}


