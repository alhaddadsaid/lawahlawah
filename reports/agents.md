# Agent desk (paper trading)

Updated 2026-10-21 18:07 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 5 | 80 | -17.06 | -29.44 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 5 | 80 | -17.06 | -29.44 |
| control | meme | 68 | 21 | -3152.79 | -3769.33 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 71 | 21 | -3257.92 | -3890.31 |

Verdict: too early, 5 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Pokémon long at 0.0003028, stop 0.00024224, target 0.00042392, opened 2026-10-21 17:18 UTC

## Team

API spend today: $0.10 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 18:07 UTC team all (memecoins + gold/forex), spent today $0.102

Lead: No new trade. KIMCHI is 19 minutes old, so it fails the under-10m age filter despite a +191% 1h move and 4.4% top10. OGDOGE is old and down 34% over 1h. Scout: the memecoin edge is still untested, so I won't force one. Sniper: keep gold 41 on its stop at 4095 and target at 4180 (about 16.6h left). Gold is 4154.7, roughly flat over 1h, with no economic releases in the next 24h.

{"orders": [], "close": [], "note": "18:07 no new orders. Hold gold 41 (stop 4095, target 4180, price 4154.7, ~16.6h left). KIMCHI 19.3m old, h1 +191%, top10 4.4%, fails age; recheck at under-10m if it stays on the scan. OGDOGE old, h1 -34%, passes nothing. Watch next scan: under-10m, h1>+1000%, top10<15%, liquidity OK."}


