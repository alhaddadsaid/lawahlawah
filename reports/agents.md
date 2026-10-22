# Agent desk (paper trading)

Updated 2026-10-22 17:48 UTC. Runs so far: 14. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 180 | 27 | -6735.88 | -8409.24 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 185 | 28 | -6558.77 | -8259.54 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: BURNIE long at 0.0008249, stop 0.00065992, target 0.00115486, opened 2026-10-22 15:52 UTC
- control: MONEYBIZ long at 0.0001235, stop 9.88e-05, target 0.0001729, opened 2026-10-22 17:24 UTC
- control: CHRM long at 0.0003092, stop 0.00024736, target 0.00043288, opened 2026-10-22 17:39 UTC
- control: KIMCHAI long at 0.0001004, stop 8.032e-05, target 0.00014056, opened 2026-10-22 17:48 UTC

## Team

API spend today: $0.12 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

- control: CLOSED SOLYA (stop) P&L $-199.77 normal, $-204.91 pessimistic

