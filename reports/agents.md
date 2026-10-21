# Agent desk (paper trading)

Updated 2026-10-21 11:29 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 3 | 67 | -29.59 | -36.53 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 3 | 67 | -29.59 | -36.53 |
| control | meme | 37 | 16 | -1631.63 | -1969.26 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 38 | 16 | -1736.29 | -2078.21 |

Verdict: too early, 3 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- team: YouTube long at 0.0005016, stop 0.000426409, target 0.000601524, opened 2026-10-21 11:26 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: startupSI long at 6.068e-05, stop 4.8544e-05, target 8.4952e-05, opened 2026-10-21 09:49 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: BACKERS long at 0.000301, stop 0.0002408, target 0.0004214, opened 2026-10-21 11:14 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 11:29 UTC team all (memecoins), spent today $0.032

Lead: No new trades. Gold 41 is still in its thesis range and holds with its stop and target unchanged.
Scout: NEKO AI (67m old, h1 +204%) and GATO fail the under-10-minute age filter. MrBeast, flagged earlier, is not in today's tradeable list.
Sniper: The open feed shows YouTube as id 47, with stop -15% and target +20%, which matches the 11:26 probe. The journal's "42 closed" note is stale, so I'm treating 47 as the live probe and leaving it running to its 4h limit. Nothing new to size.

{"orders": [], "close": [], "note": "11:29 no new orders. Hold gold 41 (stop 4095, target 4180). Open feed shows YouTube as id 47 (the 11:26 probe, stop 0.000426, target 0.000602, 4h), not 42; journal's 42-closed note is stale. Watch: memecoin under 10m old with h1 over +1000% and top10 under 15%. NEKO AI (67m) and MrBeast (14m, top10 14.2%) are the only near-candidates; recheck age on next scan."}

- control: order BACKERS REJECTED by guardrails: BACKERS already open

