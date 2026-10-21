# Agent desk (paper trading)

Updated 2026-10-21 21:20 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 8 | 75 | -98.27 | -121.37 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 8 | 75 | -98.27 | -121.37 |
| control | meme | 80 | 22 | -3547.79 | -4277.28 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 83 | 23 | -3652.92 | -4398.26 |

Verdict: too early, 8 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: 4 long at 0.0001746, stop 0.00013968, target 0.00024444, opened 2026-10-21 21:20 UTC

## Team

API spend today: $0.14 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 21:20 UTC team all (memecoins + gold/forex), spent today $0.139

Lead: No new orders. Kimchipad (9 min old) fails the filter at +228% 1h and 22% top10. Dacity and LARPCHECK are old. Macro calendar is empty and crypto news isn't a clear catalyst. Gold 41 stays open under its stop 4095 and target 4180. Scout: the under-10m, +1000% 1h, top10<15% memecoin setup has had no passes in this session's scans. Sniper: no orders. Speed 93 appears in the notes but not in the live open-position list, so it needs checking before anything else is done with it.

{"orders": [], "close": [], "note": "21:20 no new orders; hold gold 41 (4159.5, stop 4095, target 4180, ~13.3h left). Kimchipad 9m old fails (h1 +228%, top10 22%). Speed 93 is in notes but not in live open list; verify. Watch next: under-10m listings with h1>+1000%, top10<15%, adequate liquidity."}

- 2026-10-21 21:20 UTC control: OPENED 4 long at 0.0001746 (stop 0.00013968, target 0.00024444) - control: frozen v3 rules

