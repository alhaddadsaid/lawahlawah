# Agent desk (paper trading)

Updated 2026-10-21 22:21 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 83 | 22 | -3886.51 | -4638.09 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 86 | 22 | -3991.64 | -4759.07 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC
- control: NUTCOIN long at 8.081e-05, stop 6.4648e-05, target 0.000113134, opened 2026-10-21 22:15 UTC

## Team

API spend today: $0.15 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 22:21 UTC team all (memecoins), spent today $0.152

Scout: PHP2SHELL (17.7m old, top10 24%) and MrBeast (52m old) fail the age and top10 filters. Dacity has no momentum.
Sniper: No memecoin entries. The YouTube test is not in open positions, so treat it as not filled.
Lead: Team journal is -$233 over 11 trades, so no forced trades. Hold gold 41 to its stop at 4095 and target at 4180, with no new orders.

{"orders": [], "close": [], "note": "22:21 no orders; hold gold 41 (4156, stop 4095, target 4180, ~12h left). PHP2SHELL 18m old/top10 24% and MrBeast 52m old fail filters; YouTube test not filled. Watch: fresh listings under 10m with h1>+1000% and top10<15%; gold close beyond 4095-4220."}


