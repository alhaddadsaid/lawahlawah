# Research rules (written 2026-10-15, before any round-2 results existed)

These rules decide when the strategy changes. They exist so that changes follow evidence, not hope, and so the strategy is never tuned to fit noise.

## Data
- Every paper run saves every price (every 5 seconds), every holder/safety snapshot and its timing, so any rule set can be replayed exactly. A test checks that replaying a run with its own rules reproduces its live trades trade for trade.
- Research uses all replayable runs from all rounds, because market data does not depend on our rules.
- The oldest 70% of the data is the training set. The newest 30% is the validation set. Only the validation result counts.

## Variants
- A fixed list of variants is defined in research.py. Each changes one thing from the champion (stop level, take-profit level, trailing distance, time stop, holder minimum, pullback window, token age, liquidity rule, top 10 limit, market-mood filter, momentum entry).
- New variants may be added only with a dated note explaining why, and never because of how they score on data already seen.

## Switch rule (all must be true)
1. The candidate is the variant with the best average on the training set.
2. At least 30 validation trades for both candidate and champion.
3. Candidate validation average at 5% costs per side is at least 2 percentage points above the champion.
4. Candidate validation average is positive.
5. Candidate validation profit is still positive without its single best token.
6. Bootstrap probability that the candidate beats the champion on validation is at least 90%.
7. At least 7 days since the last switch.

When all pass, Claude applies the switch: update the v3 rules in config.json, start a new test round, record it in research_state.json, and tell Said what changed and why. If any check fails, the champion stays.

## Stop rule
If the champion has at least 150 trades and the champion and every variant are negative on validation at 5% costs, the recommendation is to stop: no edge found.

## Final bar before any real money (all must pass, on all data)
- At least 50 trades on at least 30 different tokens
- Average positive at 5% costs per side
- Profit not dependent on one token
- Beats the no-filter control group
- Validation also positive

Passing the bar only allows moving to alerts mode (Said places trades himself), never straight to automated trading.
