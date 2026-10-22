# Agent desk (paper trading)

Updated 2026-10-22 06:38 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 131 | 23 | -5857.08 | -7050.42 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 136 | 24 | -5679.97 | -6900.72 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC
- control: SURY long at 0.0001996, stop 0.00015968, target 0.00027944, opened 2026-10-22 05:52 UTC

## Team

API spend today: $0.08 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 06:38 UTC team all (memecoins), spent today $0.079

Lead: Filter stays paused. None of the six memecoins pass the age<10m, h1>+1000%, top10<15% gate (OA is 218m old, h1 +26%). Scout's gold dip idea is unproven; the last gold trade lost $5 and costs eat most of a small move. Sniper: no orders, nothing to size or stop. Flat until a candidate clears every gate or a gold setup has a clear trigger.

{"orders": [], "close": [], "note": "06:38 no orders, flat at $9,650. Memecoin filter paused: OA (218m, h1 +26%), MONEYBIZ, PANGEA, Dacity, GATO, CRAWL all fail age/h1 gates. Watch: CYBER if top10<15% with volume; GTA6 if h1 reaches +1000% with top10<15%; gold 4113 near lower 5d range, revisit only with a clear trigger."}

- control: order SURY REJECTED by guardrails: SURY already open

