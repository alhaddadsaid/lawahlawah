# Agent desk (paper trading)

Updated 2026-10-22 06:47 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 1 | 0 | -5.3 | -5.36 |
| team | all | 16 | 56 | -350.16 | -388.38 |
| control | meme | 132 | 23 | -5911.34 | -7113.55 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 137 | 24 | -5734.23 | -6963.85 |

Verdict: too early, 16 of 50 team trades needed before judging.

## Open positions

- control: Tokabu long at 0.001439, stop 0.0011512, target 0.0020146, opened 2026-10-22 04:54 UTC
- control: SURY long at 0.0001996, stop 0.00015968, target 0.00027944, opened 2026-10-22 05:52 UTC

## Team

API spend today: $0.08 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 06:47 UTC team all (memecoins), spent today $0.081

Lead: Journal is -$350 over 16 trades, and the memecoin filter has failed repeatedly. No memecoin passes the gates (BIRB is over a year old, PHP and SURY are down on the hour, DOOD is 8.8 days old and down). Gold's setup still lacks a live quote and a calendar check, so no trade. Scout: the PHP security story is a risk-off signal for that name, not a long. Sniper: nothing to size. Stay flat and keep the watch list.

{"orders": [], "close": [], "note": "06:47 no orders, flat at $9,650. Memecoin filter stays paused; no candidate passes (BIRB 384k min old, PHP h1 -6.86%, DOOD 764k min old, SURY h1 -10.5%). Gold 4103.9 idea still needs live quote and high-impact calendar check before any trade. Watch: CYBER if top10<15% with volume; GTA6 if h1 reaches +1000% with top10<15%; Gato if top10<15% and h1 holds."}

- control: order SURY REJECTED by guardrails: SURY already open

