# Agent desk (paper trading)

Updated 2026-10-22 06:59 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 133 | 23 | -5934.35 | -7146.23 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 138 | 24 | -5757.24 | -6996.53 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4108, stop 4082.5, target 4140.5, opened 2026-10-22 06:56 UTC
- control: SURY long at 0.0001996, stop 0.00015968, target 0.00027944, opened 2026-10-22 05:52 UTC
- control: NOOX long at 6.233e-05, stop 4.9864e-05, target 8.7262e-05, opened 2026-10-22 06:56 UTC

## Team

API spend today: $0.08 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 06:59 UTC team all (memecoins), spent today $0.084

Lead: Hold. Gold position 156 is open near entry with its stop and target intact, so no new trades.
Scout: AURACHI (age 17.8m, h1 +616%) and YouTube (age 19.8m, h1 +373%) fail the under-10m and h1 above +1000% gates. Memecoin filter stays paused.
Sniper: No new orders. Keep 156 as is, stop 4082.5, target 4140.5, 24h max.

{"orders": [], "close": [], "note": "06:59 hold, flat on new trades. Gold 156 open (entry 4108, stop 4082.5, target 4140.5, 24h). AURACHI and YouTube fail age/h1 gates (17.8m/19.8m old, h1 +616%/+373%). Watch: X if m5 volume firms with age<10m, h1>+1000%, top10<15%; CYBER if top10<15% with volume; GTA6 if h1 reaches +1000% with top10<15%."}


