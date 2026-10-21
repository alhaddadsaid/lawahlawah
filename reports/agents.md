# Agent desk (paper trading)

Updated 2026-10-21 14:53 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 50 | 20 | -2034.84 | -2495.46 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 52 | 19 | -2266.99 | -2739.62 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: Gato long at 0.0001456, stop 0.00011648, target 0.00020384, opened 2026-10-21 13:28 UTC
- control: Pokémon long at 0.000364, stop 0.0002912, target 0.0005096, opened 2026-10-21 14:32 UTC
- control: HUMANOID long at 0.0001328, stop 0.00010624, target 0.00018592, opened 2026-10-21 14:53 UTC

## Team

API spend today: $0.07 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 14:53 UTC team all (memecoins), spent today $0.068

Lead: No memecoin passes the filter. HUMANOID (h1 -56%, age 112m) and Pokemon (age 3850m) both fail. Sniper: No macro catalyst, and gold 41 is inside its range with stop and target intact. Scout: Keep scanning for under-10m tokens with h1 above +1000% and top10 below 15%. Journal: Five closed trades net -$17, so the filter has no proven edge yet. Decision: no new orders, hold gold 41.

{"orders": [], "close": [], "note": "14:53 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~19.8h left, +0.25%). HUMANOID (h1 -56%) and Pokemon (3850m) fail filters. Watch next scan: under-10m, h1>+1000%, top10<15%; no macro events until gold levels are hit. Journal sample is small (5 trades, -$17), so do not size up on the memecoin hypothesis."}

- 2026-10-21 14:53 UTC control: OPENED HUMANOID long at 0.0001328 (stop 0.00010624, target 0.00018592) - control: frozen v3 rules

