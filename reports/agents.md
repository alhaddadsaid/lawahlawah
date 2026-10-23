# Agent desk (paper trading)

Updated 2026-10-23 04:08 UTC. Runs so far: 16. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 234 | 29 | -8075.21 | -10268.06 |
| control | macro | 7 | 71 | 471.34 | 438.17 |
| control | all | 241 | 30 | -7603.87 | -9829.89 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: EURUSD long at 1.12196, stop 1.12077, target 1.12374, opened 2026-10-22 20:00 UTC
- control: GLOOB long at 7.641e-05, stop 6.1128e-05, target 0.000106974, opened 2026-10-23 03:29 UTC
- control: POOT long at 6.832e-05, stop 5.4656e-05, target 9.5648e-05, opened 2026-10-23 04:05 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.

## Last run

### 2026-10-23 04:08 UTC team macro (gold/forex), spent today $0.007

Scout: no trigger. Gold is 4030.8, far below the 4090 hourly-close trigger. GBP/USD is 1.33948, below the 1.3418 trigger. No high-impact events in 24h.
Lead: The journal shows gold longs losing on early entries, so I won't chase. Memecoin filters are net negative (-$360 over 18 trades), so no memecoin trades.
Sniper: No orders. Plans stay on watch.

{"orders": [], "close": [], "note": "04:08 flat, no orders. Gold 4030.8 (5d low 4030.8, hi 4220.4), needs hourly close above 4090 for 1% long, stop 4070, target 4120, max 12h, only if trend stabilises. GBP/USD 1.33948, long only on hourly close above 1.3418. No high-impact events 24h. Memecoin filter strategy net negative, avoid until evidence changes."}

- control: order GLOOB REJECTED by guardrails: GLOOB already open

