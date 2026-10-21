# Agent desk (paper trading)

Updated 2026-10-21 22:39 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 85 | 21 | -4135.63 | -4901.34 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 88 | 22 | -4240.76 | -5022.32 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC

## Team

API spend today: $0.16 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 22:39 UTC team all (memecoins), spent today $0.156

Lead: Hold. Gold 41 is still inside its thesis (stop 4095, target 4180), so no change.
Scout: CABBAGE is 6.6m old and top10 13.9%, but h1 is +207%, far below the +1000% filter. Fails momentum.
Sniper: No new orders. The 0.5% YouTube test was never filled, so it isn't tracked.
Watch next scan: fresh memecoins under 10m with h1 above +1000% and top10 under 15%. Riot Games/Speed-type listings are borderline on age.

{"orders": [], "close": [], "note": "22:39 no orders. Hold gold 41 (4153.5, +0.37%, stop 4095, target 4180, ~12h left). CABBAGE 6.6m old, top10 13.9%, but h1 +207% fails the +1000% filter. Watch next: fresh memecoins under 10m with h1>+1000% and top10<15%; gold 41 still valid."}


