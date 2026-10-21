# Agent desk (paper trading)

Updated 2026-10-21 23:09 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 86 | 22 | -4067.63 | -4845.34 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 89 | 22 | -4172.76 | -4966.32 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC
- control: CABBAGE long at 0.0001412, stop 0.00011296, target 0.00019768, opened 2026-10-21 23:06 UTC

## Team

API spend today: $0.16 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 23:09 UTC team all (memecoins), spent today $0.162

Lead: No new trades. Memecoin filter (age under 10m, h1 over +1000%, top10 under 15%) fails on all three feed names. CC is 7.6m old with h1 +853% and top10 42.8%. X is 5m old with h1 +37% and top10 24%. CABBAGE is 37m old. Scout: no macro catalyst beyond general crypto news, so no macro idea. Sniper: hold gold 41 with its existing stop and target.

{"orders": [], "close": [], "note": "23:09 no orders. Hold gold 41 (4147.8, +0.23%, stop 4095, target 4180, ~11.6h left). CC 7.6m fails h1 (+853%) and top10 (42.8%); X 5m fails h1 (+37%) and top10 (24%); CABBAGE 37m fails age. Watch next: fresh memecoins under 10m with h1>+1000% and top10<15%; the filter has passed zero names in this session, so keep waiting rather than loosening it."}


