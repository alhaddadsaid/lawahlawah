# Agent desk (paper trading)

Updated 2026-10-26 16:23 UTC. Runs so far: 31. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 732 | 31 | -20549.97 | -27530.61 |
| control | macro | 11 | 45 | -58.52 | -116.18 |
| control | all | 743 | 31 | -20608.49 | -27646.79 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: SIB long at 0.000288, stop 0.0002304, target 0.0004032, opened 2026-10-26 15:50 UTC
- control: RAYPAD long at 0.0001619, stop 0.00012952, target 0.00022666, opened 2026-10-26 15:53 UTC
- control: Shitcoin long at 0.0001549, stop 0.00012392, target 0.00021686, opened 2026-10-26 16:14 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED Ginnan (target) P&L $68.0 normal, $56.0 pessimistic

