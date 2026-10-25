# Agent desk (paper trading)

Updated 2026-10-25 14:00 UTC. Runs so far: 26. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 3 | 0 | -15.11 | -15.4 |
| team | all | 18 | 50 | -359.97 | -398.42 |
| control | meme | 560 | 32 | -14814.24 | -20177.87 |
| control | macro | 9 | 56 | 193.37 | 150.91 |
| control | all | 569 | 32 | -14620.87 | -20026.96 |

Verdict: too early, 18 of 50 team trades needed before judging.

## Open positions

- control: LAUNCH long at 0.0002006, stop 0.00016048, target 0.00028084, opened 2026-10-25 13:24 UTC
- control: KURUMI long at 0.0001704, stop 0.00013632, target 0.00023856, opened 2026-10-25 13:36 UTC

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
### 2026-10-25 14:00 UTC team review

**Review:** The memecoin momentum filter (under 10m old, h1 over +1000%, top10 under 15%) has lost most of the money, and the losing streak is at 5. Gold trades are small losers. I'm pausing memecoin trading until a pre-registered backtest shows a net edge after 2.5-5% per side costs. No new hires or firings this round, since the existing team is small and the problem is the hypothesis, not the people. Scout and Sniper move to macro. FX Scout keeps EUR/USD and GBP/USD. Skeptic must reject any trade without a pre-registered entry, stop, target, max hold and expected net edge. Gold ideas need the same test and a bigger sample before more capital.

{"hire": [], "fire": [], "missions": {"Lead": "all", "Scout": "macro", "Sniper": "macro", "FX Scout": "macro", "Skeptic": "all"}, "note": "Memecoin momentum paused pending a pre-registered backtest net of 2.5-5% per side costs. Gold and FX ideas must pass Skeptic's pre-registration check. Track hit rate and net P&L per hypothesis."}

- control: order KURUMI REJECTED by guardrails: KURUMI already open

