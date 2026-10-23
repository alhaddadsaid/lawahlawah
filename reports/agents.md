# Agent desk (paper trading)

Updated 2026-10-23 11:37 UTC. Runs so far: 17. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 282 | 29 | -9346.21 | -11998.76 |
| control | macro | 8 | 62 | 327.77 | 290.38 |
| control | all | 290 | 30 | -9018.44 | -11708.38 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: ARCTIS long at 7.338e-05, stop 5.8704e-05, target 0.000102732, opened 2026-10-23 11:07 UTC
- control: MEOWE long at 9.409e-05, stop 7.5272e-05, target 0.000131726, opened 2026-10-23 11:13 UTC
- control: TRENCHERS long at 9.182e-05, stop 7.3456e-05, target 0.000128548, opened 2026-10-23 11:19 UTC
- control: PHP long at 0.0002326, stop 0.00018608, target 0.00032564, opened 2026-10-23 11:34 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

### 2026-10-23 11:37 UTC team macro (gold/forex), spent today $0.018

Scout: No macro trigger has fired. Gold 4043.9 is below the 4090 hourly-close trigger, EUR/USD 1.11957 is above the 1.11894 short trigger, and GBP/USD 1.33717 is below the 1.3418 long trigger. No high-impact events in 24h.
Lead: Stand aside. Our last 18 team trades lost $360 net, so no forced trades. Gold's 4070 stop in earlier notes is stale against the 4000.9 5d low, so any long needs a fresh stop.
Sniper: No orders staged.

{"orders": [], "close": [], "note": "11:37 flat, no orders. Gold 4043.9 needs hourly close >4090 for long 1%, stop below 4000.9 5d low (or 4070 only if reconciled), target 4120, max 12h. GBP/USD needs hourly close >1.3418 (long test). EUR/USD needs hourly close <1.11894 (short only if confirmed, no event in 24h). Watch the next high-impact calendar item; no macro trades without a trigger."}


