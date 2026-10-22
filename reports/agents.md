# Agent desk (paper trading)

Updated 2026-10-22 02:35 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 104 | 20 | -5149.85 | -6084.41 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 107 | 21 | -5254.98 | -6205.39 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: EURUSD long at 1.12385, stop 1.12297, target 1.12516, opened 2026-10-22 00:01 UTC
- control: Au long at 0.0001802, stop 0.00014416, target 0.00025228, opened 2026-10-22 02:21 UTC
- control: CI long at 0.0001109, stop 8.872e-05, target 0.00015526, opened 2026-10-22 02:29 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 02:35 UTC team all (memecoins), spent today $0.030

Lead: Hold gold 41. Price is near entry and inside stop and target, with about 8h left.
Scout: MrBeast (7.7m old, h1 +1131%, top10 14.2%, liquidity $61k) technically passes the age, h1 and top10 filter. OA fails on h1 (+258%). Neither is a new edge. The filter has net losses in the journal, and a 2.5-5% per-side cost means a 20% target needs a large move.
Sniper: No entry. The filter test has already produced its evidence, so I won't spend risk on another spike chase.

{"orders": [], "close": [], "note": "02:35 hold gold 41 (4132.7, stop 4095, target 4180, ~8h left). Passed on MrBeast (7.7m, h1 +1131%, top10 14.2%, liq 61k) and OA (6.5m, h1 +258%, fails h1 filter): filter has net losses in journal and entries chase spikes. Watch next: fresh memecoins under 10m with h1>+1000%, top10<15%, liq adequate; only test if entry is after a pullback, not at the spike. Consider a non-meme macro idea if gold hits stop or target."}


