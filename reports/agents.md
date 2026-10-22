# Agent desk (paper trading)

Updated 2026-10-22 04:36 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 115 | 22 | -5280.2 | -6324.23 |
| control | macro | 5 | 60 | 177.11 | 149.7 |
| control | all | 120 | 23 | -5103.09 | -6174.53 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: Gato long at 0.0003445, stop 0.0002756, target 0.0004823, opened 2026-10-22 03:38 UTC
- control: BROZO long at 0.0001031, stop 8.248e-05, target 0.00014434, opened 2026-10-22 04:27 UTC

## Team

API spend today: $0.05 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-22 04:36 UTC team all (memecoins), spent today $0.054

Lead: No new orders. GOLD 41 is still inside its stop (4095) and target (4180) range, so I'm holding it. Dolly (7.6m old) fails the journal's losing filter: h1 is +49%, not +1000%, and top10 is 23%, not under 15%. Scout's pump idea stays a loser. Sniper: no entry. OA is 97m old with top10 2.8%, but it has no momentum signal to test, so it's a watch only.

{"orders": [], "close": [], "note": "04:36 no orders. Hold GOLD 41 (4103.8 vs entry 4138.1, stop 4095, target 4180, ~6h left). Dolly (7.6m, h1 +49%, top10 23%) fails the pump filter. Watch: OA (97m, top10 2.8%) as a possible low-top10 test; no trade yet."}


