# Agent desk (paper trading)

Updated 2026-10-28 00:10 UTC. Runs so far: 36. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 913 | 32 | -24073.86 | -32820.54 |
| control | macro | 18 | 44 | -152.98 | -251.79 |
| control | all | 931 | 32 | -24226.84 | -33072.33 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4065, stop 4051.11, target 4085.83, opened 2026-10-27 15:00 UTC
- control: SF long at 0.0001515, stop 0.0001212, target 0.0002121, opened 2026-10-27 22:26 UTC
- control: Frongus long at 0.0002545, stop 0.0002036, target 0.0003563, opened 2026-10-27 23:15 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-28 00:10 UTC team macro (gold/forex), spent today $0.001

Lead: No trade. Gold (4076) and GBPUSD (1.33119) are both above their short triggers (below 4050 and below 1.3300 on a closed hourly bar), so nothing is armed to fire.
Scout: The gold short (stop 4090, target 3990, 12h) and GBP short (stop 1.3340, target 1.3240, 8h) remain pre-registered. Both wait for a closed-bar trigger.
FX Scout: GBP budget is about 12h away and FOMC about 18h, so no entry is allowed inside the 1h blackout windows.
Skeptic: Prior armed macro setups never filled. Ideas stay on watch, not orders, and the memecoin book's record (-$360) argues against forcing trades.

{"orders": [], "close": [], "note": "00:10 flat. Still armed, not filled: GOLD short 0.5% on closed hourly bar below 4050 (stop 4090, target 3990, max 12h). GBPUSD short 0.5% on closed hourly bar below 1.3300 (stop 1.3340, target 1.3240, max 8h). No entries within 1h of GBP budget (~12:30 UTC) or FOMC (~18:00-19:00 UTC). Review whether armed macro setups ever fill before adding new ones."}


