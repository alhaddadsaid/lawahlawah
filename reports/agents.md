# Agent desk (paper trading)

Updated 2026-10-23 12:04 UTC. Runs so far: 17. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 283 | 29 | -9278.21 | -11942.76 |
| control | macro | 8 | 62 | 327.77 | 290.38 |
| control | all | 291 | 30 | -8950.44 | -11652.38 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: ARCTIS long at 7.338e-05, stop 5.8704e-05, target 0.000102732, opened 2026-10-23 11:07 UTC
- control: TRENCHERS long at 9.182e-05, stop 7.3456e-05, target 0.000128548, opened 2026-10-23 11:19 UTC
- control: PHP long at 0.0002326, stop 0.00018608, target 0.00032564, opened 2026-10-23 11:34 UTC
- control: PRB long at 9.944e-05, stop 7.9552e-05, target 0.000139216, opened 2026-10-23 12:04 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

- 2026-10-23 12:04 UTC control: OPENED PRB long at 9.944e-05 (stop 7.9552e-05, target 0.000139216) - control: frozen v3 rules

