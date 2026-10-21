# Agent desk (paper trading)

Updated 2026-10-21 23:40 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 92 | 22 | -4420.5 | -5250.68 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 95 | 22 | -4525.63 | -5371.66 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC
- control: Pokecity long at 0.0002047, stop 0.00016376, target 0.00028658, opened 2026-10-21 23:40 UTC

## Team

API spend today: $0.17 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 23:40 UTC team all (memecoins), spent today $0.168

Scout: FOMO shows h1 +1159% and top10 14.1%, but age is 10.96 min, which fails our under-10-minute rule. Pokecity, DOOD, and CHOO fail on age or h1. Sniper: no entry. Lead: the memecoin rule has lost money in the journal, so no chase. Gold 41 is at 4144.3, inside its stop and target band with about 11h left. Hold it.

{"orders": [], "close": [], "note": "23:40 no orders. Hold gold 41 (4144.3, +0.15%, stop 4095, target 4180, ~11h left). FOMO 11.0m old, h1 +1159%, top10 14.1%: fails the under-10m age rule by about a minute. Pokecity (h1 -74%), DOOD (old), CHOO (290m old) fail. Watch next: fresh memecoins under 10m with h1>+1000% and top10<15%, verified against live age at entry; consider whether the age cutoff is too tight given the journal's stop losses."}

- 2026-10-21 23:40 UTC control: OPENED Pokecity long at 0.0002047 (stop 0.00016376, target 0.00028658) - control: frozen v3 rules

