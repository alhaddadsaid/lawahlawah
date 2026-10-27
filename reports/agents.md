# Agent desk (paper trading)

Updated 2026-10-27 18:30 UTC. Runs so far: 35. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 884 | 31 | -23483.8 | -31948.19 |
| control | macro | 17 | 47 | -35.82 | -129.12 |
| control | all | 901 | 32 | -23519.62 | -32077.31 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4065, stop 4051.11, target 4085.83, opened 2026-10-27 15:00 UTC
- control: maxxing long at 0.0004279, stop 0.00034232, target 0.00059906, opened 2026-10-27 18:05 UTC
- control: ** long at 7.757e-05, stop 6.2056e-05, target 0.000108598, opened 2026-10-27 18:15 UTC
- control: Darla long at 7.798e-05, stop 6.2384e-05, target 0.000109172, opened 2026-10-27 18:21 UTC
- control: HACHI long at 0.0001307, stop 0.00010456, target 0.00018298, opened 2026-10-27 18:30 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-27 18:30 UTC team macro (gold/forex), spent today $0.031

Lead: No trades. Gold is 4070.6, still above the 4020 trigger, so the GOLD short stays unarmed. Skeptic: the journal is -$360 over 18 trades, mostly from memecoin and gold scalps, so I won't add exposure without a pre-registered edge. FX Scout: GBPUSD has no complete entry, stop, target and hold yet; the budget release is about 18h out. Sniper: no orders.

{"orders": [], "close": [], "note": "Flat 18:30. Watch: GOLD short 1% only if price rebounds to ~4020 and an hourly close is below 4000; stop ~4045, target 3980, max 8h (5d low 3989.1). GBPUSD: pre-register entry, stop, target, max hold and net edge (after 1-1.6 pip costs) before GBP budget release (~18h). No memecoin trades until a filter passes out-of-sample."}

- 2026-10-27 18:30 UTC control: OPENED HACHI long at 0.0001307 (stop 0.00010456, target 0.00018298) - control: frozen v3 rules

