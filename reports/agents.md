# Agent desk (paper trading)

Updated 2026-10-21 09:19 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 2 | 100 | 14.9 | 9.39 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 2 | 100 | 14.9 | 9.39 |
| control | meme | 29 | 21 | -1009.68 | -1281.2 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 29 | 21 | -1009.68 | -1281.2 |

Verdict: too early, 2 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: COMPUTE long at 0.0002347, stop 0.00018776, target 0.00032858, opened 2026-10-21 08:32 UTC
- control: earth long at 6.647e-05, stop 5.3176e-05, target 9.3058e-05, opened 2026-10-21 08:38 UTC
- control: GUZZLEGOAT long at 0.0004156, stop 0.00033248, target 0.00058184, opened 2026-10-21 09:06 UTC

## Team

API spend today: $0.01 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 09:19 UTC team all (memecoins), spent today $0.008

Lead: No trade. LWK is 6.6 minutes old, but its 1h gain is +144%, far short of the >1000% filter we are testing. Liquidity is $27k against $131k of 5m volume, so round-trip costs of 5-10% would swamp any small move. Scout: the crypto news (ETF outflows, Solana Alpenglow Wednesday) gives no clear BTC/ETH edge. Sniper: no order, since a 0.5% position in thin memecoin liquidity isn't worth the slippage risk. Watch LWK only to see whether it reverses, which tests the next hypothesis, not the current one.

{"orders": [], "close": [], "note": "No trades. Watch LWK (AE7V..., 6.6 min, h1 +144%, liq $27k, top10 10%): fails the >1000% 1h filter, so track only. Next test: does 1h gain >1000% reverse? Log LWK price path for a reversal check. Macro: still no edge; watch the Solana Alpenglow go-live Wednesday."}

- control: order MEME REJECTED by guardrails: desk already has the maximum open positions

