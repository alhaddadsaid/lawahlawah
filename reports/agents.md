# Agent desk (paper trading)

Updated 2026-10-22 12:43 UTC. Runs so far: 13. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 2 | 0 | -11.67 | -11.84 |
| team | all | 17 | 53 | -356.53 | -394.86 |
| control | meme | 157 | 24 | -6404.6 | -7850.58 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 162 | 25 | -6227.49 | -7700.88 |

Verdict: too early, 17 of 50 team trades needed before judging.

## Open positions

- control: MONEYBIZ long at 0.0002003, stop 0.00016024, target 0.00028042, opened 2026-10-22 11:20 UTC
- control: SHAV long at 0.0002057, stop 0.00016456, target 0.00028798, opened 2026-10-22 12:43 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

- 2026-10-22 12:43 UTC control: OPENED SHAV long at 0.0002057 (stop 0.00016456, target 0.00028798) - control: frozen v3 rules

