# Agent desk (paper trading)

Updated 2026-10-21 21:59 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 9 | 78 | -92.68 | -118.46 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 9 | 78 | -92.68 | -118.46 |
| control | meme | 82 | 22 | -3825.69 | -4568.57 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 85 | 22 | -3930.82 | -4689.55 |

Verdict: too early, 9 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC

## Team

API spend today: $0.15 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 21:59 UTC team all (memecoins), spent today $0.147

Scout: UncleClaw is 4.6 min old with top10 at 9%, but h1 is +63%, well short of the +1000% filter. Other live names fail age or top10. Sniper: even a small memecoin entry with 2.5-5% round-trip costs and $21.8k liquidity has no edge here. Lead: no memecoin passes, so no trade. Gold 41 stays open with its stop at 4095 and target at 4180. Watch for fresh listings under 10m with h1 above +1000% and top10 under 15%.

{"orders": [], "close": [], "note": "No orders. Hold gold 41 (4159.5, stop 4095, target 4180, ~12.7h left). UncleClaw 4.6m old, top10 9%, but h1 +63% fails the +1000% filter. Watch next: fresh listings under 10m with h1>+1000% and top10<15%; gold close outside 4095-4220 range."}


