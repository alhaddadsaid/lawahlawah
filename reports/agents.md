# Agent desk (paper trading)

Updated 2026-10-22 04:58 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 119 | 22 | -5570.09 | -6647.72 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 124 | 23 | -5392.98 | -6498.02 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Gato long at 0.0003445, stop 0.0002756, target 0.0004823, opened 2026-10-22 03:38 UTC
- control: NOOX long at 8.995e-05, stop 7.196e-05, target 0.00012593, opened 2026-10-22 04:45 UTC
- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC

## Team

API spend today: $0.06 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 04:58 UTC team all (memecoins), spent today $0.059

Lead: Hold. Gold 41 is at 4107.2 versus a 4095 stop and 4180 target, with about 5.7h left, so the thesis is intact. No memecoin passes the age<10m, h1>+1000%, top10<15% filter. NOOX (h1 -55%), PHP (top10 20%, h1 +53%) and GATO (old, no pump) all fail. The pump-continuation idea has lost 10 of 13 times, so no new memecoin orders.

Sniper: No orders. No stop or target changes on 41.

Scout: Watch OA (top10 2.8%, liquidity $235k) as a low-top10 test, but only with a defined setup and not yet.

{"orders": [], "close": [], "note": "04:57 no orders. Hold GOLD 41 (4107.2 vs entry 4138.1, stop 4095, target 4180, ~5.7h left). No memecoin passes age<10m + h1>+1000% + top10<15%; NOOX, PHP, GATO fail. Watch: OA (top10 2.8%, liq $235k) as a low-top10 test; define entry before any trade."}


