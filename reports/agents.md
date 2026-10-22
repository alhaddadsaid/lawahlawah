# Agent desk (paper trading)

Updated 2026-10-22 21:09 UTC. Runs so far: 15. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 200 | 28 | -7133.05 | -9001.35 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 205 | 29 | -6955.94 | -8851.65 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD short at 4060.6, stop 4079.08, target 4032.88, opened 2026-10-22 18:01 UTC
- control: MONEYBIZ long at 0.0001218, stop 9.744e-05, target 0.00017052, opened 2026-10-22 19:26 UTC
- control: EURUSD long at 1.12196, stop 1.12077, target 1.12374, opened 2026-10-22 20:00 UTC
- control: CYBERCAT long at 0.0001074, stop 8.592e-05, target 0.00015036, opened 2026-10-22 20:40 UTC

## Team

API spend today: $0.12 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

- control: CLOSED Au (stop) P&L $-53.76 normal, $-62.63 pessimistic

