# Agent desk (paper trading)

Updated 2026-10-31 18:54 UTC. Runs so far: 52. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 1356 | 31 | -36739.79 | -49705.32 |
| control | macro | 28 | 46 | -141.99 | -292.93 |
| control | all | 1384 | 31 | -36881.78 | -49998.25 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: LumiBot long at 0.0001007, stop 8.056e-05, target 0.00014098, opened 2026-10-31 18:16 UTC
- control: LUMI long at 0.0002121, stop 0.00016968, target 0.00029694, opened 2026-10-31 18:19 UTC
- control: Jimothy long at 0.001349, stop 0.0010792, target 0.0018886, opened 2026-10-31 18:28 UTC
- control: QI long at 0.0002009, stop 0.00016072, target 0.00028126, opened 2026-10-31 18:45 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED Pikmin (target) P&L $68.0 normal, $56.0 pessimistic

