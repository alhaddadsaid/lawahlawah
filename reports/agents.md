# Agent desk (paper trading)

Updated 2026-10-22 14:24 UTC. Runs so far: 14. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 167 | 27 | -6135.13 | -7690.58 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 172 | 28 | -5958.02 | -7540.88 |

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

- control: order LASTCALL REJECTED by guardrails: LASTCALL already open

