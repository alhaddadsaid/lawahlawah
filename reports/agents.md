# Agent desk (paper trading)

Updated 2026-10-21 20:40 UTC. Runs so far: 10. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 7 | 86 | 1.73 | -18.81 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 7 | 86 | 1.73 | -18.81 |
| control | meme | 77 | 23 | -3448.03 | -4149.31 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 80 | 24 | -3553.16 | -4270.29 |

Verdict: too early, 7 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: PsyopAnime long at 0.0005293, stop 0.00042344, target 0.00074102, opened 2026-10-21 19:08 UTC
- control: DacityCoin long at 0.000189, stop 0.0001512, target 0.0002646, opened 2026-10-21 19:17 UTC

## Team

API spend today: $0.13 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

## Run ended 2026-10-21 20:40 UTC

