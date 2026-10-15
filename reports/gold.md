# Gold intraday research

Monthly files that could not be downloaded: none.
Data: HistData.com 1-minute spot gold (XAUUSD, bid), 2018-01-22 to 2026-09-30, 2236 trading days.
Money is for 1 micro gold future (MGC, 10 oz). Normal costs $5 per round trip, pessimistic $10.
Older period 2018-2022, recent period 2023-now. Rules were fixed before any result.

Pass bar (all must hold): recent period positive at pessimistic costs, older period positive at pessimistic costs,
at least 100 recent trades, profit factor above 1.15 recent, positive in at least 70% of years,
bootstrap chance of a positive recent average at least 95%, and better than the random control in both periods.

## Summary (pessimistic costs, $ per trade for 1 MGC)

| rule | older trades | older avg $ | recent trades | recent avg $ | recent avg $ (normal costs) | recent win % | recent PF | recent max DD $ | years positive | bootstrap % | verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|
| orb_ny_15 | 1273 | -12.0 | 907 | -7.2 | -2.2 | 37 | 0.84 | 8779 | 0/9 | 3 | fail |
| orb_ny_30 | 1263 | -13.5 | 898 | -15.1 | -10.1 | 35 | 0.76 | 14105 | 0/9 | 0 | fail |
| london_orb_30 | 1257 | -11.3 | 948 | -3.5 | 1.5 | 36 | 0.93 | 7644 | 1/9 | 22 | fail |
| trend_day | 260 | -13.0 | 164 | -8.3 | -3.3 | 41 | 0.87 | 2605 | 2/9 | 27 | fail |
| vwap_revert | 566 | -12.2 | 438 | -16.4 | -11.4 | 39 | 0.73 | 8619 | 0/9 | 0 | fail |
| random_control | 1274 | -13.0 | 962 | -16.5 | -11.5 | 40 | 0.74 | 15926 | 0/9 | 0 | control |

## Profit per year, pessimistic costs, $ for 1 MGC

| rule | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 | 2025 | 2026 |
|---|---|---|---|---|---|---|---|---|---|
| orb_ny_15 | -2238 | -2768 | -3513 | -3676 | -3140 | -2040 | -1121 | -1599 | -1778 |
| orb_ny_30 | -2581 | -3598 | -6268 | -2519 | -2146 | -2367 | -2195 | -682 | -8317 |
| london_orb_30 | -2599 | -3165 | -1362 | -4087 | -2987 | -3867 | -934 | -643 | 2081 |
| trend_day | -609 | -992 | -37 | -576 | -1177 | 202 | -380 | 132 | -1308 |
| vwap_revert | -859 | -1444 | -1423 | -2294 | -875 | -2196 | -1280 | -1550 | -2148 |
| random_control | -3253 | -2368 | -3584 | -4584 | -2727 | -3209 | -2346 | -3515 | -6771 |

## How trades ended (all years)

| rule | stop | target | time |
|---|---|---|---|
| orb_ny_15 | 1348 | 630 | 202 |
| orb_ny_30 | 1258 | 520 | 383 |
| london_orb_30 | 1380 | 645 | 180 |
| trend_day | 173 | 0 | 251 |
| vwap_revert | 472 | 254 | 278 |
| random_control | 728 | 197 | 1311 |

## Rules

- orb_ny_15: New York open range breakout, range 8:20-8:35 ET, stop other side, target 2x risk, out by 13:30 ET
- orb_ny_30: Same with a 30 minute range, 8:20-8:50 ET
- london_orb_30: London open range breakout, range 8:00-8:30 London, out by 16:00 London
- trend_day: At 10:30 ET, if gold moved more than 0.4 day-ranges since 8:20, follow it, stop 0.3 range, out by 13:30
- vwap_revert: 9:30-12:00 ET, if price is more than 0.35 day-ranges from the session average, fade it back to the average
- random_control: Benchmark: random time and random direction, stop 0.3 range, target 0.6 range

Runtime 146s. Spot gold is a proxy for futures; real fills may differ slightly.
