# Agent desk (paper trading)

Updated 2026-10-26 20:30 UTC. Runs so far: 31. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 756 | 31 | -21101.62 | -28314.24 |
| control | macro | 11 | 45 | -58.52 | -116.18 |
| control | all | 767 | 31 | -21160.14 | -28430.42 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GOLD short at 4032.1, stop 4044.41, target 4013.64, opened 2026-10-26 17:00 UTC
- control: Grokbot long at 5.35e-05, stop 4.28e-05, target 7.49e-05, opened 2026-10-26 18:34 UTC
- control: RAYPAD long at 0.0001825, stop 0.000146, target 0.0002555, opened 2026-10-26 19:05 UTC
- control: Shitcoin long at 0.0001406, stop 0.00011248, target 0.00019684, opened 2026-10-26 19:29 UTC
- control: PRESIDENT long at 0.0002007, stop 0.00016056, target 0.00028098, opened 2026-10-26 20:09 UTC

## Team

API spend today: $0.03 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- control: order REM REJECTED by guardrails: desk already has the maximum open positions

