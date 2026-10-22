# Agent desk (paper trading)

Updated 2026-10-22 13:34 UTC. Runs so far: 13. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 2 | 0 | -11.67 | -11.84 |
| team | all | 17 | 53 | -356.53 | -394.86 |
| control | meme | 162 | 26 | -6229.69 | -7731.44 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 167 | 27 | -6052.58 | -7581.74 |

Verdict: too early, 17 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4092.4, stop 4069.5, target 4119.5, opened 2026-10-22 12:49 UTC
- control: SHAV long at 0.000186, stop 0.0001488, target 0.0002604, opened 2026-10-22 13:22 UTC
- control: CODEX long at 7.609e-05, stop 6.0872e-05, target 0.000106526, opened 2026-10-22 13:28 UTC
- control: MONEYBIZ long at 0.0002307, stop 0.00018456, target 0.00032298, opened 2026-10-22 13:31 UTC
- control: YAPROACH long at 0.000377, stop 0.0003016, target 0.0005278, opened 2026-10-22 13:34 UTC

## Team

API spend today: $0.11 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

- 2026-10-22 13:34 UTC control: OPENED YAPROACH long at 0.000377 (stop 0.0003016, target 0.0005278) - control: frozen v3 rules

