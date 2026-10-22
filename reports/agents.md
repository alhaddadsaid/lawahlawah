# Agent desk (paper trading)

Updated 2026-10-22 01:24 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 12 | 67 | -230.49 | -262.83 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 12 | 67 | -230.49 | -262.83 |
| control | meme | 100 | 21 | -4866.16 | -5766.97 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 103 | 21 | -4971.29 | -5887.95 |

Verdict: too early, 12 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- team: Speed long at 0.0005156, stop 0.00036092, target 0.000645626, opened 2026-10-22 01:18 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: EURUSD long at 1.12385, stop 1.12297, target 1.12516, opened 2026-10-22 00:01 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 01:24 UTC team all (memecoins), spent today $0.017

Lead: No new entries. GTACHI (19.6m old, h1 +108%) and DOPE (old, h1 -14%) fail the memecoin filter, and gold 41 still has room to its 4180 target. Sniper: Speed 119 is +10.7% and inside its 1.9h window, so hold to the existing stop and target. Scout: nothing new passed the filter; keep scanning for fresh coins under 10m with h1 above +1000%.

{"orders": [], "close": [], "note": "01:24 no orders. Hold gold 41 (4133, stop 4095, target 4180, ~9.3h left) and Speed 119 (+10.7%, stop 0.00036092, target 0.000646, ~1.9h left). GTACHI (19.6m, h1 +108%) and DOPE (old) fail filter. Watch next: fresh memecoins under 10m, h1>+1000%, top10<15%, liquidity."}


