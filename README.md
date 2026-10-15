# Memecoin paper test

Paper trading only. No wallet, no keys, no real money. The script reads public market data (GeckoTerminal, DexScreener, RugCheck) and simulates trades with fixed rules.

## What runs

GitHub Actions starts a run 4 times a day (00:05, 06:05, 12:05 and 18:05 UTC), each about 340 minutes, so data is collected almost around the clock. A daily research job (11:50 UTC) replays all data with a fixed list of rule variants and writes `reports/latest.md`. How rules may change is fixed in `RESEARCH_RULES.md`. Every run saves its files in `results/<round>/<run time>/`:

- `trades.csv` every closed paper trade, with net results at 2.5% and 5% costs per side
- `decisions.csv` why each token was entered or skipped
- `ticks.csv.gz`, `loops.csv`, `rugcheck.csv`, `tokens.csv` everything needed to replay the run exactly with any rules
- `meta.json` run info

## Strategies tested side by side

- **v3** the frozen rules (primary)
- **v3_tiered_liq** same, but 10% liquidity is enough above 200K market cap (declared before the test)
- **baseline** no safety filter, only age and pullback, to see whether the filter adds value

## Tradeable filter (all strategies, including baseline)

Market cap between $50K and $20M, liquidity at least $10K and not above market cap, and at least $1K traded in the last 5 minutes. Added in round 2 because the data feeds also list dead coins.

## Rules (frozen for the whole round)

Entry: age at least 30 min, at least 1,000 holders, liquidity at least 20% of market cap, top 10 holders at most 30% (pools excluded), insiders at most 10%, mint and freeze authority revoked, no brand or farm names, 5-minute change between -20% and +5%. Any missing data means no trade.

Exit: stop at -20% on the full position. At +30% sell half, then trail the rest 20% below the highest price. At 10 minutes exit only if below entry. Hard cap of 120 minutes.

Fills are pessimistic: entry at the next price after the signal, exits at the price that triggered them (crashes through a stop fill at the crash price).

## Known gaps

- Bundle percentage is not available from free sources, so that v3 rule is not applied.
- Prices are checked every 5 seconds, not every trade.
- Real fills on thin tokens can still be worse than simulated.

## Results

Run `python3 analyze.py` to combine all runs, or ask Claude to analyze the results folder.

To stop the test early: Actions tab, select the workflow, click "..." then Disable workflow.
