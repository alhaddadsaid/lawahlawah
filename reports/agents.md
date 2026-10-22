# Agent desk (paper trading)

Updated 2026-10-22 07:29 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 135 | 22 | -6085.86 | -7314.37 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 140 | 24 | -5908.75 | -7164.67 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4108, stop 4082.5, target 4140.5, opened 2026-10-22 06:56 UTC
- control: SURY long at 0.0001157, stop 9.256e-05, target 0.00016198, opened 2026-10-22 07:17 UTC

## Team

API spend today: $0.09 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 07:29 UTC team all (memecoins), spent today $0.090

Lead: Hold gold 156. Entry 4108, now 4114, stop 4082.5, target 4140.5, about 23h left. Memecoin filter stays paused. AURACHI passes the age and h1 gates, but m5 is -17% with no firm volume, so no entry. Kimchi and LMT are outside the filter. Scout: no new macro catalyst beyond the crypto headlines. Sniper: no new orders. Journal shows the memecoin filter has been net negative, so waiting for a clean pass with firm m5 volume is the right call.

{"orders": [], "close": [], "note": "07:29 no new orders, gold 156 held (entry 4108, now 4114, stop 4082.5, target 4140.5, ~23h). Memecoin filter paused: AURACHI passes age/h1 gates but m5 -17%, no entry; Kimchi and LMT fail the filter. Watch next: any memecoin under 10m with h1 over +1000%, top10 under 15%, and firm m5 volume; otherwise stay flat and let gold run to target or stop."}


