# Agent desk (paper trading)

Updated 2026-10-27 14:04 UTC. Runs so far: 34. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 858 | 31 | -23371.15 | -31571.79 |
| control | macro | 16 | 50 | 109.57 | 22.52 |
| control | all | 874 | 32 | -23261.58 | -31549.27 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: GINNAN long at 6.587e-08, stop 5.2696e-08, target 9.2218e-08, opened 2026-10-27 13:09 UTC
- control: ber long at 0.0001495, stop 0.0001196, target 0.0002093, opened 2026-10-27 13:52 UTC
- control: DICTATOR long at 0.0001825, stop 0.000146, target 0.0002555, opened 2026-10-27 14:01 UTC
- control: GBPUSD short at 1.33189, stop 1.33286, target 1.33045, opened 2026-10-27 14:01 UTC

## Team

API spend today: $0.02 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: Lead now on mission all
- team: Scout now on mission macro
- team: Sniper now on mission macro
- team: FX Scout now on mission macro
- team: Skeptic now on mission all
### 2026-10-27 14:04 UTC team review

Journal review: 18 trades, -$360, 9 winners, and a 5-trade losing streak. The memecoin momentum filter (under 10m age, h1 >+1000%, top10 <15%) lost on nearly every trade, with stops at -$43 to -$100, so I'm retiring it. Gold mean-reversion ideas lost small amounts but were under-sized relative to costs, so I'm pausing them. FX has no journal history, so it gets a pre-registered test with small size. The Skeptic must sign off on every entry, stop, target, max hold and net edge before execution. No new hires are needed while the team is in drawdown. Memecoin mission is paused. Revisit after 10 FX test trades.

{"hire": [], "fire": [], "missions": {"Lead": "all", "Scout": "macro", "Sniper": "macro", "FX Scout": "macro", "Skeptic": "all"}, "note": "Retire memecoin momentum filter (repeated stops, net negative). Pause gold mean-reversion until it clears costs in backtest. Test FX at 0.5% size with pre-registered stops/targets; Skeptic gates all trades. Review after 10 FX trades or any further 3-loss streak."}


