# Agent desk (paper trading)

Updated 2026-10-21 13:01 UTC. Runs so far: 9. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 4 | 75 | -22.7 | -32.38 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 4 | 75 | -22.7 | -32.38 |
| control | meme | 45 | 20 | -1785.5 | -2201.23 |
| control | macro | 1 | 0 | -104.66 | -108.95 |
| control | all | 46 | 20 | -1890.16 | -2310.18 |

Verdict: too early, 4 of 50 team trades needed before judging.

## Open positions

- team: GOLD long at 4138.1, stop 4095, target 4180, opened 2026-10-21 10:41 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: EURUSD long at 1.12334, stop 1.12269, target 1.12432, opened 2026-10-21 11:02 UTC
- control: COMPUTE long at 0.0001422, stop 0.00011376, target 0.00019908, opened 2026-10-21 12:24 UTC

## Team

API spend today: $0.05 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission all): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission all): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.

## Last run

### 2026-10-21 13:01 UTC team all (memecoins), spent today $0.048

Scout: Grok is under 10 minutes old but its 1h gain is +79%, far below the +1000% filter. Every other memecoin fails age or top10, so the memecoin hypothesis stays paused.
Sniper: No valid entry. Gold 41 keeps its stop at 4095 and target at 4180.
Lead: No new orders. Hold gold 41 and keep the memecoin filter on watch.

{"orders": [], "close": [], "note": "13:01 flat, no new orders. Hold gold 41 (stop 4095, target 4180, ~21.5h left). Grok 6m old but h1 +79%, fails +1000% filter; memecoin hypothesis stays paused. Watch next scan: under-10m, h1>+1000%, top10<15%. No macro catalyst beyond gold range."}

- control: order EURUSD REJECTED by guardrails: EURUSD already open

