# Agent desk (paper trading)

Updated 2026-10-28 01:35 UTC. Runs so far: 36. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 921 | 32 | -23985.93 | -32816.91 |
| control | macro | 18 | 44 | -152.98 | -251.79 |
| control | all | 939 | 32 | -24138.91 | -33068.7 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4065, stop 4051.11, target 4085.83, opened 2026-10-27 15:00 UTC
- control: Frongus long at 0.0001973, stop 0.00015784, target 0.00027622, opened 2026-10-28 01:14 UTC
- control: Stonkz long at 0.0001729, stop 0.00013832, target 0.00024206, opened 2026-10-28 01:20 UTC
- control: DICTATOR long at 8.788e-05, stop 7.0304e-05, target 0.000123032, opened 2026-10-28 01:29 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-28 01:35 UTC team macro (gold/forex), spent today $0.004

Lead: Flat again. GBPUSD is at 1.33053, above the armed 1.3300 trigger, and gold is at 4075, well above the 4050 short trigger. Neither has a closed hourly bar that qualifies.
Scout: The GBP budget (~12:30 UTC) and FOMC (~18:00 UTC) windows block entries anyway, so the armed setups stay on watch.
Skeptic: Memecoin filters have lost money in the journal (-$360 net), so I'm not reopening them.
FX Scout: GBPUSD short stays armed: below 1.3300 on a closed 1h bar, stop 1.3340, target 1.3240, max 8h.
Sniper: No orders until a trigger closes.

{"orders": [], "close": [], "note": "01:35 flat, no orders. Still armed, not filled: GBPUSD short 0.5% on closed 1h bar below 1.3300 (stop 1.3340, target 1.3240, max 8h), blocked 11:30-13:30 and 17:00-19:00 UTC. GOLD short 0.5% on closed 1h bar below 4050 (stop 4090, target 3990, max 12h). Memecoin filter ideas remain suspended after -$360 journal record."}

- control: order Frongus REJECTED by guardrails: Frongus already open

