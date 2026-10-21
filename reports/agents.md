# Agent desk (paper trading)

Updated 2026-10-21 23:22 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 87 | 22 | -4149.24 | -4935.11 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 90 | 22 | -4254.37 | -5056.09 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC
- control: CABBAGE long at 0.0001412, stop 0.00011296, target 0.00019768, opened 2026-10-21 23:06 UTC
- control: CI long at 0.0002152, stop 0.00017216, target 0.00030128, opened 2026-10-21 23:22 UTC

## Team

API spend today: $0.16 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 23:22 UTC team all (memecoins), spent today $0.164

Lead: Hold gold 41. It sits inside the thesis range with stop 4095 and target 4180, and no new edge has appeared.
Scout: No memecoin passes. KIMCHI is down 65% on the hour and Dacity is 4+ months old. Neither fits the under-10-minute, h1>1000%, top10<15% setup.
Sniper: No orders. Keep the existing stop and target. Re-check memecoins at the next scan.

{"orders": [], "close": [], "note": "23:22 no orders. Hold gold 41 (4143.7, +0.14%, stop 4095, target 4180, ~11.3h left). KIMCHI (h1 -66%) and Dacity (age ~10 days) fail. Watch next: fresh memecoins under 10m with h1>+1000% and top10<15%, verified against live age and holder data before entry."}

- 2026-10-21 23:22 UTC control: OPENED CI long at 0.0002152 (stop 0.00017216, target 0.00030128) - control: frozen v3 rules

