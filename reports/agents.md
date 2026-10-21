# Agent desk (paper trading)

Updated 2026-10-21 21:29 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 8 | 75 | -98.27 | -121.37 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 8 | 75 | -98.27 | -121.37 |
| control | meme | 81 | 22 | -3747.94 | -4482.56 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 84 | 23 | -3853.07 | -4603.54 |

Verdict: too early, 8 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- team: YouTube long at 0.0004972, stop 0.000422874, target 0.000596998, opened 2026-10-21 21:26 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC

## Team

API spend today: $0.14 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 21:29 UTC team all (memecoins), spent today $0.141

Lead: No new trades. Gold 41 stays open under its plan (stop 4095, target 4180). YouTube 95 is +6.9% with about 1h left, so it runs to its time stop with its stop in place. KIMCHI (34m old, h1 +1649%, top10 1.4%) and KIMCHI 2 (22m old) fail the under-10-minute age rule, so no memecoin entries. Scout: the rule still needs a fresh under-10m listing. Sniper: Speed 93 is in the notes but not in the live book, so it needs checking before anything else is done with it.

{"orders": [], "close": [], "note": "21:29 no new orders; hold gold 41 (4159.5, stop 4095, target 4180, ~13.2h left) and YouTube 95 (+6.9%, stop 0.000423, target 0.000597, ~1h to time stop). KIMCHI 34m and KIMCHI 2 22m fail age rule. Speed 93 still unverified, not in live book. Watch next: under-10m listings with h1>+1000%, top10<15%, liquidity adequate."}


