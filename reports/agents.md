# Agent desk (paper trading)

Updated 2026-10-27 17:48 UTC. Runs so far: 35. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 881 | 32 | -23320.27 | -31758.09 |
| control | macro | 17 | 47 | -35.82 | -129.12 |
| control | all | 898 | 32 | -23356.09 | -31887.21 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 4065, stop 4051.11, target 4085.83, opened 2026-10-27 15:00 UTC
- control: Darla long at 0.000119, stop 9.52e-05, target 0.0001666, opened 2026-10-27 17:32 UTC
- control: HACHI long at 0.0001997, stop 0.00015976, target 0.00027958, opened 2026-10-27 17:41 UTC
- control: ** long at 0.0001363, stop 0.00010904, target 0.00019082, opened 2026-10-27 17:44 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED DICTATOR (target) P&L $68.0 normal, $56.0 pessimistic

