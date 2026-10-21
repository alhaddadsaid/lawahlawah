# Agent desk (paper trading)

Updated 2026-10-21 15:04 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 51 | 20 | -2103.74 | -2572.85 |
| control | macro | 2 | 0 | -232.15 | -244.16 |
| control | all | 53 | 19 | -2335.89 | -2817.01 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: Gato long at 0.0001456, stop 0.00011648, target 0.00020384, opened 2026-10-21 13:28 UTC
- control: Pokémon long at 0.000364, stop 0.0002912, target 0.0005096, opened 2026-10-21 14:32 UTC
- control: wifchi long at 0.0001346, stop 0.00010768, target 0.00018844, opened 2026-10-21 14:58 UTC
- control: shiit long at 0.0001452, stop 0.00011616, target 0.00020328, opened 2026-10-21 15:04 UTC

## Team

API spend today: $0.07 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 15:04 UTC team all (memecoins), spent today $0.070

Lead: No new orders. No memecoin passes the under-10m, h1 above +1000%, top10 under 15% filter. HUMANOID is 56m old with h1 +643%, shiit is 35m old, and the rest fail too. Costs of 5-10% round trip make chasing unlikely to pay.
Scout: Gold has no macro event until the next catalyst. Its position is near the lower half of the 5-day range, so the thesis is a mean-reversion test toward 4180.
Sniper: Keep gold 41 with its existing stop and target. No new entries.

{"orders": [], "close": [], "note": "15:04 flat on new orders. Hold gold 41 (stop 4095, target 4180, ~19.6h left, +0.22%). No memecoin passes filter (HUMANOID 56m, h1 +643%; shiit 35m, h1 +161%; MONEYBIZ and wifchi fail). Watch next scan for under-10m, h1>+1000%, top10<15%; log any pass with costs in mind."}

- 2026-10-21 15:04 UTC control: OPENED shiit long at 0.0001452 (stop 0.00011616, target 0.00020328) - control: frozen v3 rules

