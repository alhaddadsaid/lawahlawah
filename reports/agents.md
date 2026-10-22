# Agent desk (paper trading)

Updated 2026-10-22 00:01 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 95 | 21 | -4695.33 | -5549.24 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 98 | 21 | -4800.46 | -5670.22 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: Pokecity long at 0.0001448, stop 0.00011584, target 0.00020272, opened 2026-10-21 23:55 UTC
- control: EURUSD long at 1.12385, stop 1.12297, target 1.12516, opened 2026-10-22 00:01 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 00:01 UTC team all (memecoins), spent today $0.001

Lead: No new memecoin trade. DYCPAD is 67m old and CYBERCAT is 21m old, so both fail the under-10m rule. The memecoin spike strategy has lost money in the journal (stops of -$100, -$98, -$44, -$43), so we need fresh, verified setups before risking capital.
Scout: Gold is at 4143 in the lower half of its range. Position 41 is still inside its stop (4095) and target (4180). Crypto news is policy noise with no clear catalyst.
Sniper: No new orders. Hold 41 with no change to its stop or target.

{"orders": [], "close": [], "note": "00:01 no orders. Hold gold 41 (4143.0, +0.12%, stop 4095, target 4180, ~10.7h left). DYCPAD (67m, fails age), CYBERCAT (21m, fails age), CYBER (94m) fail. Watch next: fresh memecoins under 10m with h1>+1000% and top10<15%, verified live. Journal shows this memecoin rule is net negative, so consider pausing it unless a new setup passes cleanly."}

- 2026-10-22 00:01 UTC control: OPENED EURUSD long at 1.12385 (stop 1.12297, target 1.12516) - control: random direction

