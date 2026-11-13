# Agent desk (paper trading)

Updated 2026-11-13 10:29 UTC. Runs so far: 97. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2736 | 31 | -69476.59 | -95756.48 |
| control | macro | 58 | 52 | 596.31 | 310.22 |
| control | all | 2794 | 31 | -68880.28 | -95446.26 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: EURUSD long at 1.10583, stop 1.10467, target 1.10756, opened 2026-11-12 20:01 UTC
- control: Punch long at 0.0003726, stop 0.00029808, target 0.00052164, opened 2026-11-13 09:49 UTC
- control: WRENCHP long at 0.0001162, stop 9.296e-05, target 0.00016268, opened 2026-11-13 09:56 UTC
- control: HUNG long at 0.0002307, stop 0.00018456, target 0.00032298, opened 2026-11-13 10:17 UTC
- control: Huang long at 0.0001148, stop 9.184e-05, target 0.00016072, opened 2026-11-13 10:20 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Punch REJECTED by guardrails: desk already has the maximum open positions

