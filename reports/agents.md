# Agent desk (paper trading)

Updated 2026-11-12 15:10 UTC. Runs so far: 94. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2673 | 31 | -68426.98 | -94087.64 |
| control | macro | 57 | 53 | 704.25 | 422.92 |
| control | all | 2730 | 31 | -67722.73 | -93664.72 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: FLC long at 0.0001195, stop 9.56e-05, target 0.0001673, opened 2026-11-12 14:52 UTC
- control: BUTTHOLE long at 0.0004567, stop 0.00036536, target 0.00063938, opened 2026-11-12 15:01 UTC
- control: KRESS long at 6.319e-05, stop 5.0552e-05, target 8.8466e-05, opened 2026-11-12 15:04 UTC
- control: PUSSY long at 0.0008003, stop 0.00064024, target 0.00112042, opened 2026-11-12 15:07 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order FLC REJECTED by guardrails: FLC already open

