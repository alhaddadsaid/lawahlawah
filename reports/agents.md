# Agent desk (paper trading)

Updated 2026-10-22 05:07 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 121 | 22 | -5563.58 | -6661.89 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 126 | 24 | -5386.47 | -6512.19 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Gato long at 0.0003445, stop 0.0002756, target 0.0004823, opened 2026-10-22 03:38 UTC
- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC
- control: CYBER long at 0.0002618, stop 0.00020944, target 0.00036652, opened 2026-10-22 05:01 UTC

## Team

API spend today: $0.06 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 05:07 UTC team all (memecoins), spent today $0.060

Lead: Hold GOLD 41. It is above its stop at 4095 and still has room to the 4180 target.
Scout: OA fails the age (127m) and h1 (+27.8%) tests of the pump hypothesis. Its low top10 (2.8%) alone isn't an edge.
Sniper: No new orders. Pump-continuation has lost repeatedly, so we don't force a trade.

{"orders": [], "close": [], "note": "05:07 no orders. Hold GOLD 41 (4108.1 vs entry 4138.1, stop 4095, target 4180, ~5.6h left). OA fails age (127m) and h1 (+27.8%) so no pump entry; keep on watch only. Next: check whether the pump filter has any passing candidate before forcing a trade."}


