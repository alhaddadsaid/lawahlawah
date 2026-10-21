# Agent desk (paper trading)

Updated 2026-10-21 08:44 UTC. Runs so far: 6. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 0 | 0 | 0 | 0 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 0 | 0 | 0 | 0 |
| control | meme | 28 | 18 | -1077.68 | -1337.2 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 28 | 18 | -1077.68 | -1337.2 |

Verdict: too early, 0 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: COMPUTE long at 0.0002347, stop 0.00018776, target 0.00032858, opened 2026-10-21 08:32 UTC
- control: GUZZLEGOAT long at 0.0003, stop 0.00024, target 0.00042, opened 2026-10-21 08:35 UTC
- control: earth long at 6.647e-05, stop 5.3176e-05, target 9.3058e-05, opened 2026-10-21 08:38 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 08:44 UTC team all (memecoins), spent today $0.002

**Discussion**

- **Scout:** CBUCKS is up 11% over both

- control: order BACKERS REJECTED by guardrails: desk already has the maximum open positions

