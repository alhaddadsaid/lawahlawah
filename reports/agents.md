# Agent desk (paper trading)

Updated 2026-10-20 18:01 UTC. Runs so far: 4. Model: claude-haiku-5-5.

Money is paper. Memecoins $200 per trade, costs 2.5% (normal) and 5% (pessimistic) per side. Macro trades risk $100 each (1% of $10,000).

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 0 | 0 | 0 | 0 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 0 | 0 | 0 | 0 |
| control | meme | 3 | 0 | -132.6 | -159.96 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 3 | 0 | -132.6 | -159.96 |

Verdict: too early, 0 of 50 team trades needed before judging.

## Open positions

- control: COLLECTOOOR long at 0.0001948, stop 0.00015584, target 0.00027272, opened 2026-10-20 17:33 UTC
- control: pika long at 8.551e-05, stop 6.8408e-05, target 0.000119714, opened 2026-10-20 17:43 UTC
- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC

## Last run

### 2026-10-20 18:01 UTC discussion (1 new tokens)

**Researcher**

**Recommendation: no trade now. Watch PACKCOIN only.**

**Macro (EUR/USD, GBP/USD, gold):** No ideas. The macro snapshot is empty, so I have no prices, ATR, ranges, or changes to build a thesis from.

**Memecoin: PACKCOIN (watch, no entry)**
- **Thesis:** Early momentum with real participation could continue, but the entry is chased and the exit liquidity is thin.
- **Numbers:** mcap $69.7k, liquidity $48.3k, vol_m5 $86.1k (about 1.8x liquidity), m5 +146%, h1 +647%, age 11.5 min, 1,915 holders, top10 16.5%, insider 0%, mint and freeze authority disabled, rc_score 52.
- **Why not now:** A round trip costs roughly 5-10%, and a +146% five-minute move usually means the easy part is done. Selling about $5k into a $48k pool could move price sharply. The rc_score of 52 is middling, and the control desk lost on all 3 memecoin trades.
- **Would become a candidate if:** Price holds a higher low on falling volume for several 5-minute

**Analyst**

**Analyst review (2026-10-20 18:01 UTC)**

**Macro (EUR/USD, GBP/USD, gold): REJECT / no idea.** Macro snapshot is empty. No prices, ATR, ranges, or changes, so there is no basis for a thesis or sizing. Team macro track record is 0 trades.

**PACKCOIN: REJECT for entry now. Keep on watch.**

Agree with the researcher's conclusion, with some additions:
- **Data quality:** Age is 11.5 minutes. Holders, top10 and rc_score are from a very young token and can change quickly. rc_score 52 is middling, not a clean pass.
- **Costs:** At 2.5-5% per side, a round trip is 5-10%. A +146% m5 and +647% h1 move means the spread and slippage on entry are likely wide. Any fill is probably far from the quoted price.
- **Liquidity:** vol_m5 is about 1.8x pool liquidity. That is a sign of heavy churn, which can be organic or wash. Exit depth of ~$48k is thin for any meaningful size.
- **Rug and manipulation risk:** Mint and freeze are disabled, which helps, but 16.5% top10 and a fresh launch leave room for coordinated dumps. Insider 0% is self-reported and unverified.
- **Crowding:** No open team positions, but the control desk is already in memecoins and lost on all 3 trades. The team should not copy a chase.
- **Track record:** Team memecoin n=0. No evidence yet that this filter beats the control.

**Watch conditions:** Only reconsider if price forms a higher low on falling vol_m5 across several 5-minute candles, liquidity holds or grows, and the round-trip cost estimate is checked against the actual quote. Size must stay small relative to pool depth.

**Sniper**

```
{"orders": []}
```
- 2026-10-20 18:01 UTC control: OPENED GBPUSD long at 1.33811 (stop 1.33656, target 1.34045) - control: random direction

