# Agent desk (paper trading)

Updated 2026-10-21 04:02 UTC. Runs so far: 5. Model: claude-haiku-5-5.

Money is paper. Memecoins $200 per trade, costs 2.5% (normal) and 5% (pessimistic) per side. Macro trades risk $100 each (1% of $10,000).

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 0 | 0 | 0 | 0 |
| team | macro | 0 | 0 | 0 | 0 |
| team | all | 0 | 0 | 0 | 0 |
| control | meme | 16 | 12 | -736.38 | -881.57 |
| control | macro | 0 | 0 | 0 | 0 |
| control | all | 16 | 12 | -736.38 | -881.57 |

Verdict: too early, 0 of 50 team trades needed before judging.

## Open positions

- control: GBPUSD long at 1.33811, stop 1.33656, target 1.34045, opened 2026-10-20 18:01 UTC
- control: GOLD short at 4133.8, stop 4145.46, target 4116.31, opened 2026-10-20 23:48 UTC
- control: onboard long at 0.0002611, stop 0.00020888, target 0.00036554, opened 2026-10-21 02:08 UTC
- control: Trencher long at 0.0001189, stop 9.512e-05, target 0.00016646, opened 2026-10-21 04:02 UTC

## Last run

### 2026-10-21 04:02 UTC discussion (5 new tokens)

**Desk debate**

**RESEARCHER:** Two ideas. PILLED (mcap $67k, h1 +544%, m5 +66%, 26 min old) has 5-minute volume ($74k) above liquidity ($54k), so it is a parabolic chase with no defined base. Nodrel (mcap $81k, liquidity $23k, h1 +84%, m5 -2.4%) is cooling after a spike, but liquid
- 2026-10-21 04:02 UTC control: OPENED Trencher long at 0.0001189 (stop 9.512e-05, target 0.00016646) - control: frozen v3 rules
- control: order GOLD REJECTED by guardrails: GOLD already open

