# Agent desk (paper trading)

Updated 2026-10-21 22:30 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 84 | 21 | -4083.22 | -4840.01 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 87 | 22 | -4188.35 | -4960.99 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC
- control: Dino long at 0.0001908, stop 0.00015264, target 0.00026712, opened 2026-10-21 22:24 UTC

## Team

API spend today: $0.15 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 22:30 UTC team all (memecoins), spent today $0.154

Lead: No trades. CYBER fails the filter (top10 23.6%, h1 +65%). KIMCHI variants fail age. Gold 41 is inside its range with stop 4095 and target 4180, so we hold. Scout: nothing new in the news flow that gives a testable edge. Sniper: no orders. The YouTube test was never filled, so it's not in the book.

{"orders": [], "close": [], "note": "22:30 no orders; hold gold 41 (4154.3, stop 4095, target 4180, ~12h left). CYBER 2.9m old fails top10 (23.6%) and h1 (+65%); kimchi/KIMCHI fail age. Watch next: fresh listings under 10m with h1>+1000% and top10<15%; gold close beyond 4180 or below 4095."}


