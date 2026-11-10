# Agent desk (paper trading)

Updated 2026-11-10 19:28 UTC. Runs so far: 88. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2507 | 31 | -65624.51 | -89654.51 |
| control | macro | 52 | 50 | 233.2 | -26.95 |
| control | all | 2559 | 31 | -65391.31 | -89681.46 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: PUSSY long at 0.0007398, stop 0.00059184, target 0.00103572, opened 2026-11-10 17:32 UTC
- control: GTA long at 0.0001268, stop 0.00010144, target 0.00017752, opened 2026-11-10 17:59 UTC
- control: VC long at 8.696e-05, stop 6.9568e-05, target 0.000121744, opened 2026-11-10 18:57 UTC
- control: PPP long at 9.016e-05, stop 7.2128e-05, target 0.000126224, opened 2026-11-10 19:13 UTC
- control: If long at 8.092e-05, stop 6.4736e-05, target 0.000113288, opened 2026-11-10 19:25 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.
- control: order BOXCAT REJECTED by guardrails: desk already has the maximum open positions

