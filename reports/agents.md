# Agent desk (paper trading)

Updated 2026-10-21 10:50 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 3 | 67 | -29.59 | -36.53 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 3 | 67 | -29.59 | -36.53 |
| control | meme | 34 | 18 | -1451.32 | -1762.8 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 34 | 18 | -1451.32 | -1762.8 |

Verdict: too early, 3 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: startupSI long at 6.068e-05, stop 4.8544e-05, target 8.4952e-05, opened 2026-10-21 09:49 UTC
- control: MEME long at 5.51e-05, stop 4.408e-05, target 7.714e-05, opened 2026-10-21 10:19 UTC
- control: BAKDINU long at 7.749e-05, stop 6.1992e-05, target 0.000108486, opened 2026-10-21 10:50 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 10:50 UTC team all (memecoins), spent today $0.024

Lead: Filter still unmet. LASTAGENCY is 6.7 min old with top10 at 11%, but h1 is +217%, not the +1000% the rule needs. EXFIL is 26,000 min old. No new memecoin trade.
Scout: No new macro price data, so no fresh gold idea. Gold 41 stays on its stop and target.
Sniper: No orders. Journal shows YouTube 42 open, but the open-positions feed lists only 41. Reconcile before the next cycle.

{"orders": [], "close": [], "note": "10:50 flat, no new orders. LASTAGENCY (6.7m, h1 +217%, top10 11%) fails h1>1000% filter; EXFIL fails age. Hold gold 41 (stop 4095, target 4180, 24h). Discrepancy: journal lists YouTube 42 open but open feed shows only 41; verify. Watch: tokens under 10m with h1>1000% and top10<15%; log LASTAGENCY price at 5/15/30/60m as a near-miss reference."}

- 2026-10-21 10:50 UTC control: OPENED BAKDINU long at 7.749e-05 (stop 6.1992e-05, target 0.000108486) - control: frozen v3 rules

