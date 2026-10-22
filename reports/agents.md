# Agent desk (paper trading)

Updated 2026-10-22 14:36 UTC. Runs so far: 14. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 168 | 27 | -6307.76 | -7869.04 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 173 | 28 | -6130.65 | -7719.34 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: MONEYBIZ long at 0.0002307, stop 0.00018456, target 0.00032298, opened 2026-10-22 13:31 UTC
- control: SHAV long at 0.0001756, stop 0.00014048, target 0.00024584, opened 2026-10-22 14:12 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

### 2026-10-22 14:36 UTC team macro (gold/forex), spent today $0.114

Lead: No trade. Gold is at 4065, just above the 5d low of 4059.5, and the last two gold longs lost. The reclaim-4090 trigger is not met.
Scout: No new hypothesis clears a filter. No high-impact events in 24h.
Sniper: Nothing to size. Gold, EUR/USD and GBP/USD have no setup, and no memecoin passes the age, h1 and top10 filter.
FX Scout: EUR/USD is near its 5d low and GBP/USD is mid-range. Neither has an entry that covers 0.7-1.6 pips round trip with a clear edge.

{"orders": [], "close": [], "note": "14:36 no orders. Gold 4065 near 5d low 4059.5, no setup. Watch: gold closes above 4090 (test long, stop 4070, target 4120, max 12h); a break below 4059.5 with momentum is no-long. Memecoin filter (age<10m, h1>+1000%, top10<15%, adequate liquidity) and EUR/USD/GBP/USD setups still unmet."}

- control: order MONEYBIZ REJECTED by guardrails: MONEYBIZ already open

