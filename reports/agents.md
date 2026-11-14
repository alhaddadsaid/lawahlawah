# Agent desk (paper trading)

Updated 2026-11-14 04:54 UTC. Runs so far: 100. Model: claude-haiku-5-5.

Money is paper, $10,000 per desk. Memecoin costs 2.5% (normal) and 5% (pessimistic) per side. Team desk: experimental, no strategy rules, sizes up to 10% (gold/forex with 10x leverage). Control desk: frozen v3 memecoin rules ($200 per trade) and random gold/forex trades risking $100.

| desk | market | closed trades | win % | P&L normal $ | P&L pessimistic $ |
|---|---|---|---|---|---|
| team | meme | 15 | 60 | -344.86 | -383.02 |
| team | macro | 4 | 0 | -15.18 | -15.5 |
| team | all | 19 | 47 | -360.04 | -398.52 |
| control | meme | 2801 | 31 | -71281.09 | -98181.38 |
| control | macro | 59 | 51 | 389.92 | 99.5 |
| control | all | 2860 | 31 | -70891.17 | -98081.88 |

Verdict: too early, 19 of 50 team trades needed before judging.

## Open positions

- control: GOLD long at 3876.6, stop 3862.35, target 3897.98, opened 2026-11-13 20:02 UTC
- control: SWJ long at 0.000248, stop 0.0001984, target 0.0003472, opened 2026-11-14 04:48 UTC
- control: UP long at 8.457e-05, stop 6.7656e-05, target 0.000118398, opened 2026-11-14 04:51 UTC
- control: HARAMBE long at 4.989e-05, stop 3.9912e-05, target 6.9846e-05, opened 2026-11-14 04:54 UTC

## Team

API spend today: $0.00 (cap $3, aiming for about $1.50)
- Lead (team lead and analyst, mission all): Decide what the team trades. Weigh every idea against costs and the journal. Look for repeatable edges, not one-off bets.
- Scout (researcher, mission macro): Bring ideas from prices, news, the economic calendar and politics. State each idea as a testable hypothesis.
- Sniper (execution, mission macro): Turn approved ideas into exact orders: size, optional stop and target, holding time, and early exits.
- FX Scout (FX researcher, mission macro): Propose testable EUR/USD and GBP/USD hypotheses from the economic calendar and news. Each idea needs entry, stop, target, max holding time and expected net edge after 0.7-1.6 pips round trip. No memecoin ideas.
- Skeptic (backtest and cost auditor, mission all): Before any trade, check the hypothesis against the journal and costs. Reject any idea without a pre-registered entry, stop, target, max hold and expected net edge. Track hit rate and net P&L per hypothesis.

## Last run

- team: model call failed:  HTTP 400: Your credit balance is too low to access the Anthropic API. Please go to Plans & Billing to upgrade or purchase credits.
- 2026-11-14 04:54 UTC control: OPENED HARAMBE long at 4.989e-05 (stop 3.9912e-05, target 6.9846e-05) - control: frozen v3 rules

