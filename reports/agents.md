# Agent desk (paper trading)

Updated 2026-10-22 06:16 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 130 | 23 | -5744.92 | -6930.88 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 135 | 24 | -5567.81 | -6781.18 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC
- control: SURY long at 0.0001996, stop 0.00015968, target 0.00027944, opened 2026-10-22 05:52 UTC
- control: NOOX long at 6.232e-05, stop 4.9856e-05, target 8.7248e-05, opened 2026-10-22 06:04 UTC

## Team

API spend today: $0.07 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 06:16 UTC team all (memecoins), spent today $0.075

Lead: No trade. The age<10m memecoin filter is paused after losses. FOMO is 32.6m old, so it fails the age gate. NOOX has h1 at -80%, so it fails the momentum gate. Gold at 4103.9 has no clear setup and the dip hypothesis is unproven. Scout: watch CYBER if top10 drops below 15% with volume. Sniper: no orders. We stay flat until a hypothesis is written and tested.

{"orders": [], "close": [], "note": "06:16 no orders, flat at $9,650. Memecoin age<10m+h1>+1000%+top10<15% filter stays paused. FOMO (32.6m, h1 +2032%) fails age gate; NOOX (h1 -80%) fails momentum. Watch: CYBER if top10<15% with volume; gold 4103.9 lower-range dip only with a defined stop/target and clear hypothesis."}

- control: order SURY REJECTED by guardrails: SURY already open

