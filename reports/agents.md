# Agent desk (paper trading)

Updated 2026-10-22 02:45 UTC. Runs so far: 12. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 13 | 69 | -222.15 | -257.21 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 13 | 69 | -222.15 | -257.21 |
| control | meme | 106 | 21 | -5135.14 | -6090.59 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 109 | 21 | -5240.27 | -6211.57 |

Verdict: too early, 13 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: EURUSD long at 1.12385, stop 1.12297, target 1.12516, opened 2026-10-22 00:01 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

- control: CLOSED Au (target) P&L $68.0 normal, $56.0 pessimistic

