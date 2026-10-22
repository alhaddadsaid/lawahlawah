# Agent desk (paper trading)

Updated 2026-10-22 14:15 UTC. Runs so far: 14. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 166 | 27 | -6203.13 | -7746.58 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 171 | 27 | -6026.02 | -7596.88 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: MONEYBIZ long at 0.0002307, stop 0.00018456, target 0.00032298, opened 2026-10-22 13:31 UTC
- control: LASTCALL long at 0.0005142, stop 0.00041136, target 0.00071988, opened 2026-10-22 14:06 UTC
- control: SHAV long at 0.0001756, stop 0.00014048, target 0.00024584, opened 2026-10-22 14:12 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

### 2026-10-22 14:15 UTC team macro (gold/forex), spent today $0.114

Lead: No trade. Gold is 4067.6, just above its 5-day low of 4064.1, after two losing gold longs. Its 1h change is flat, so there is no reclaim signal yet. No memecoin data passes the filter (age<10m, h1>+1000%, top10<15%). EUR/USD sits near its 5-day low with no event catalyst, and the calendar is empty for 24h. Scout: the gold hypothesis (reclaim of 4090 after a 5d low) is unproven and costs about $0.5-1/oz, so waiting is better. FX Scout: no edge above 0.7-1.6 pip costs. Sniper: no orders.

{"orders": [], "close": [], "note": "14:15 no orders. Gold 4067.6 just above 5d low 4064.1, down 1.95% 24h, no high-impact events. EUR/USD near 5d low, GBP/USD mid-range; no forex setup. No memecoin passes filter. Watch: gold reclaims 4090 (test long, stop 4062, target 4120, max 12h) or breaks below 4064.1 with momentum (no long). Memecoin filter (age<10m, h1>+1000%, top10<15%, adequate liquidity) still unmet."}

- control: order MONEYBIZ REJECTED by guardrails: MONEYBIZ already open

