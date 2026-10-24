# Agent desk (paper trading)

Updated 2026-10-24 00:27 UTC. Runs so far: 19. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 347 | 30 | -10433.9 | -13725.24 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 356 | 31 | -10240.53 | -13574.33 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: Peekhole long at 0.0001605, stop 0.0001284, target 0.0002247, opened 2026-10-23 23:14 UTC
- control: POP long at 5.876e-05, stop 4.7008e-05, target 8.2264e-05, opened 2026-10-23 23:47 UTC
- control: TRUTH long at 0.0002115, stop 0.0001692, target 0.0002961, opened 2026-10-24 00:21 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

### 2026-10-24 00:27 UTC team macro (gold/forex), spent today $0.001

Scout: Gold (4010) and EURUSD (1.12045) are both still above their short triggers, so no trigger is met. Skeptic: the journal is -$360 over 18 trades, and the memecoin filter has lost repeatedly, so I won't add exposure. Lead: no orders. Keep the watch list. The GOLD and EURUSD price feeds are about 3 hours old, so re-check live prices before any trigger.

{"orders": [], "close": [], "note": "00:27 flat, no triggers met (GOLD 4010 vs <4000 close; EURUSD 1.12045 vs <1.11894 close). Price feeds ~3h stale, verify live before acting. Watch unchanged: GOLD short 1% on hourly close <4000 with failed 4020 retest (stop 4035, target 3960, max 12h); EURUSD short 0.5% on hourly close <1.11894 (stop 1.1215, target 1.1160, max 12h). Memecoin h1>+1000% filter: 0 of 9 trades profitable, do not trade until a new pre-registered edge is written."}


