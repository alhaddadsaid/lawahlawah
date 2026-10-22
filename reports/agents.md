# Agent desk (paper trading)

Updated 2026-10-22 05:37 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 14 | 64 | -296.97 | -333.87 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 14 | 64 | -296.97 | -333.87 |
| control | meme | 123 | 23 | -5578.96 | -6697.39 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 128 | 24 | -5401.85 | -6547.69 |

Verdict: too early, 14 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Gato long at 0.0003445, stop 0.0002756, target 0.0004823, opened 2026-10-22 03:38 UTC
- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC
- control: CYBER long at 0.0002618, stop 0.00020944, target 0.00036652, opened 2026-10-22 05:01 UTC
- control: NOOX long at 0.0001154, stop 9.232e-05, target 0.00016156, opened 2026-10-22 05:37 UTC

## Team

API spend today: $0.07 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 05:37 UTC team all (memecoins), spent today $0.067

Lead: Hold GOLD 41. Price is 4101.8, stop 4095 and target 4180 are unchanged, and about 5 hours remain. Scout: no memecoin passes age under 10m, h1 over +1000%, and top10 under 15%. OA has top10 at 2.8% but h1 is only +26%, so it fails. Sniper: no new orders. Open-position journal note: Rockstar was closed far past its stop, so hard stops need enforcing.

{"orders": [], "close": [], "note": "05:37 no orders. Hold GOLD 41 (4101.8 vs entry 4138.1, stop 4095, target 4180, ~5h left). No memecoin passes age<10m + h1>+1000% + top10<15%; OA (top10 2.8%, h1 +26%) fails h1 gate. Watch: Waddles and OA only if h1 gate is met with a fresh pump. Enforce hard stops (Rockstar closed far below stop)."}

- 2026-10-22 05:37 UTC control: OPENED NOOX long at 0.0001154 (stop 9.232e-05, target 0.00016156) - control: frozen v3 rules

