# Agent desk (paper trading)

Updated 2026-11-02 10:38 UTC. Runs so far: 58. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1567 | 31 | -41592.27 | -56597.56 |
| control | macro | 31 | 45 | -242.43 | -414.98 |
| control | all | 1598 | 31 | -41834.7 | -57012.54 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: WWIII long at 8.45e-05, stop 6.76e-05, target 0.0001183, opened 2026-11-02 10:13 UTC
- control: CYBERLEEK long at 0.001793, stop 0.0014344, target 0.0025102, opened 2026-11-02 10:17 UTC
- control: Bert long at 0.0001196, stop 9.568e-05, target 0.00016744, opened 2026-11-02 10:23 UTC
- control: Warcoin long at 6.287e-05, stop 5.0296e-05, target 8.8018e-05, opened 2026-11-02 10:32 UTC
- control: Catori long at 5.362e-05, stop 4.2896e-05, target 7.5068e-05, opened 2026-11-02 10:35 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order Bert REJECTED by guardrails: desk already has the maximum open positions

