# Agent desk (paper trading)

Updated 2026-10-26 14:23 UTC. Runs so far: 30. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 714 | 31 | -19732.53 | -26549.52 |
| control | macro | 11 | 45 | -58.52 | -116.18 |
| control | all | 725 | 31 | -19791.05 | -26665.7 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Chop long at 0.0001145, stop 9.16e-05, target 0.0001603, opened 2026-10-26 13:37 UTC
- control: GME long at 0.0001096, stop 8.768e-05, target 0.00015344, opened 2026-10-26 13:40 UTC
- control: Shitcoin long at 0.0001753, stop 0.00014024, target 0.00024542, opened 2026-10-26 14:07 UTC
- control: ANT long at 0.0002346, stop 0.00018768, target 0.00032844, opened 2026-10-26 14:23 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-26 14:23 UTC team macro (gold/forex), spent today $0.023

Lead: No trade. Gold at 4016 is still below the 4020 rebound level, and the short trigger needs a failed rebound plus an hourly close under 4000. That hasn't happened.
Scout: Gold short hypothesis is still live but unconfirmed. Watch 4020 rejection and the 4000 close.
Skeptic: The memecoin filter has lost money across 9 trades (all long, mostly stopped or early-exited). No new setups pass. FX has no high-impact events in the next 24h, and the calendar is empty, so there is no edge to test.
Sniper: No orders.

{"orders": [], "close": [], "note": "14:23 flat, no orders. Gold 4016 (5d low 3989.1, high 4197.1). Watch: GOLD short 1% only after failed rebound to ~4020 and hourly close <4000; stop 4030, target 3980, max 8h, net of costs. Memecoin filter paused: 9 losing longs, no new setups. FX: no high-impact events in 24h, no trade."}

- 2026-10-26 14:23 UTC control: OPENED ANT long at 0.0002346 (stop 0.00018768, target 0.00032844) - control: frozen v3 rules

