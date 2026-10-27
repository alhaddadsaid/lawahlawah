# Agent desk (paper trading)

Updated 2026-10-27 09:22 UTC. Runs so far: 34. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 833 | 31 | -22942.3 | -30897.49 |
| control | macro | 14 | 50 | 119.36 | 44.36 |
| control | all | 847 | 31 | -22822.94 | -30853.13 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: SIB long at 0.0002282, stop 0.00018256, target 0.00031948, opened 2026-10-27 07:28 UTC
- control: Shitcoin long at 0.0001056, stop 8.448e-05, target 0.00014784, opened 2026-10-27 08:57 UTC
- control: GINNAN long at 3.884e-08, stop 3.1072e-08, target 5.4376e-08, opened 2026-10-27 09:09 UTC
- control: RAYPAD long at 0.000149, stop 0.0001192, target 0.0002086, opened 2026-10-27 09:12 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: CLOSED N64 (time) P&L $-12.4 normal, $-22.34 pessimistic

