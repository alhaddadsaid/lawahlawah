# Agent desk (paper trading)

Updated 2026-10-21 22:51 UTC. Runs so far: 11. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 11 | 64 | -233.48 | -263.24 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 11 | 64 | -233.48 | -263.24 |
| control | meme | 85 | 21 | -4135.63 | -4901.34 |
| control | macro | 3 | 33 | -105.13 | -120.98 |
| control | all | 88 | 22 | -4240.76 | -5022.32 |

Verdict: too early, 11 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.3389, stop 1.33788, target 1.34044, opened 2026-10-21 21:02 UTC
- control: CYBERLEEK long at 0.002543, stop 0.0020344, target 0.0035602, opened 2026-10-21 21:32 UTC
- control: Pokémon long at 0.0003666, stop 0.00029328, target 0.00051324, opened 2026-10-21 21:44 UTC
- control: KIMCHI long at 0.0001, stop 8e-05, target 0.00014, opened 2026-10-21 22:51 UTC

## Team

API spend today: $0.16 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 22:51 UTC team all (memecoins), spent today $0.158

Lead: Hold. No memecoin passes the rule: KIMCHI is 104m old with h1 at -68.7%, and Dacity and DOOD are far too old and lack momentum. Scout: Gold hypothesis (lower half of 5d range, target 4180) is still live; no fresh macro catalyst in the news feed. Sniper: No new orders. Gold 41 keeps stop 4095, target 4180, about 11.8h left. Watch for new listings under 10m with h1 above +1000% and top10 below 15%. Note the feed's "tradeable filter passed" label is unreliable and must be checked against the rule.

{"orders": [], "close": [], "note": "22:51 no orders; hold gold 41 (4151.2, +0.32%, stop 4095, target 4180, ~11.8h left). KIMCHI fails (age 104m, h1 -68.7%); Dacity and DOOD fail age/momentum. Feed 'filter passed' label unreliable, verify age, h1 and top10 ourselves. Watch next: fresh memecoins under 10m with h1>+1000% and top10<15%."}

- 2026-10-21 22:51 UTC control: OPENED KIMCHI long at 0.0001 (stop 8e-05, target 0.00014) - control: frozen v3 rules

