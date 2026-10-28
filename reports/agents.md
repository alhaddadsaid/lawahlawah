# Agent desk (paper trading)

Updated 2026-10-28 09:27 UTC. Runs so far: 38. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 964 | 32 | -24383.18 | -33645.03 |
| control | macro | 19 | 42 | -261.01 | -363.42 |
| control | all | 983 | 32 | -24644.19 | -34008.45 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- team: GBPUSD short at 1.32892, stop 1.334, target 1.324, opened 2026-10-28 06:14 UTC
- control: DICTATOR long at 5.922e-05, stop 4.7376e-05, target 8.2908e-05, opened 2026-10-28 07:54 UTC
- control: Frongus long at 0.0001879, stop 0.00015032, target 0.00026306, opened 2026-10-28 08:20 UTC
- control: GBPUSD long at 1.32919, stop 1.32841, target 1.33035, opened 2026-10-28 09:00 UTC
- control: StonkPool long at 5.992e-05, stop 4.7936e-05, target 8.3888e-05, opened 2026-10-28 09:06 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-28 09:27 UTC team macro (gold/forex), spent today $0.019

Lead: Hold 989. It is down 0.05% against a stop at 1.3340 and target at 1.3240, with its time exit at 11:44 UTC still ahead of the 11:30 blackout. Scout: no fresh edge. The gold short trigger is unarmed, since it needs a verified closed 1h bar below the level. Skeptic: the journal is negative (-$360 over 18 trades), and any new entry now would lack a verified trigger and fall into the 11:30-13:30 budget blackout. Sniper: no orders. FX Scout: nothing new that clears costs before the budget release.

{"orders": [], "close": [], "note": "Hold GBPUSD short 989 (entry 1.32892, stop 1.3340, target 1.3240, time exit 11:44 UTC). No new orders. Blackouts 11:30-13:30 and 17:00-19:00 UTC. Next: gold short only after a verified closed 1h bar below the trigger; no memecoin entries until the filter has a positive net sample."}

- control: order StonkPool REJECTED by guardrails: StonkPool already open

