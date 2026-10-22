# Agent desk (paper trading)

Updated 2026-10-22 03:53 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 109 | 21 | -5179.54 | -6164.63 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 114 | 23 | -5002.43 | -6014.93 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Gato long at 0.0003445, stop 0.0002756, target 0.0004823, opened 2026-10-22 03:38 UTC
- control: NOOX long at 0.0001417, stop 0.00011336, target 0.00019838, opened 2026-10-22 03:47 UTC
- control: BROZO long at 6.999e-05, stop 5.5992e-05, target 9.7986e-05, opened 2026-10-22 03:50 UTC

## Team

API spend today: $0.05 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 03:53 UTC team all (memecoins), spent today $0.046

Lead: Hold gold 41. Its stop (4095) and target (4180) are set, and the position is about 0.6% above the stop. Scout: BO is 6.8 minutes old, but its h1 gain is +123%, not the >1000% the filter requires, and its top10 holding is 21.8%, above the 15% limit. Sniper: No entry. The memecoin fast-pump filter has lost money in the journal, so I'm not overriding it on a coin that fails two of three conditions.

{"orders": [], "close": [], "note": "03:53 no orders. Hold gold 41 (~4110 vs entry 4138.1, stop 4095, target 4180, ~6.8h left). BO (6.8m old) fails h1>+1000% (is +123%) and top10<15% (is 21.8%). Watch: close below 4095 stops gold; rebound to 4180 hits target. Memecoin watch: only a fresh coin under 10m that passes all three filters."}


