"""Paper-trading engine: entry filters, exit rules and cost model.

Everything here is pure logic (no network), so it can be unit tested.

Fill model, deliberately pessimistic:
- Entry fills at the FIRST price tick after the signal, not at the signal price.
- Every exit fills at the tick price that triggered it, so if price gaps
  through a stop (crash between two ticks) we take the worse price.
- Costs are charged on both sides (platform fee + slippage + priority fee).
"""

import re
from dataclasses import dataclass, field


@dataclass
class Position:
    strategy: str
    mint: str
    symbol: str
    signal_time: float
    signal_price: float
    entry_time: float = None
    entry_price: float = None
    peak: float = None
    trough: float = None
    remaining: float = 1.0
    half_sold: bool = False
    time_checked: bool = False
    fills: list = field(default_factory=list)  # (fraction, price, reason, time)
    entry_features: dict = field(default_factory=dict)

    @property
    def is_open(self):
        return self.remaining > 1e-9

    @property
    def is_pending(self):
        return self.entry_price is None


def on_tick(pos: Position, price: float, t: float, exits: dict):
    """Advance a position by one price observation. Returns list of new fills."""
    if price is None or price <= 0 or not pos.is_open:
        return []

    # Pending entry: fill at the first tick after the signal.
    if pos.is_pending:
        if t <= pos.signal_time:
            return []
        pos.entry_price = price
        pos.entry_time = t
        pos.peak = price
        pos.trough = price
        return []

    new = []
    pos.peak = max(pos.peak, price)
    pos.trough = min(pos.trough, price)
    e = pos.entry_price
    held_min = (t - pos.entry_time) / 60.0

    def sell(frac, reason):
        frac = min(frac, pos.remaining)
        pos.remaining -= frac
        f = (frac, price, reason, t)
        pos.fills.append(f)
        new.append(f)

    if not pos.half_sold:
        if price <= e * (1 - exits["stop_loss"]):
            sell(pos.remaining, "stop_loss")
        elif price >= e * (1 + exits["take_half_at"]):
            sell(0.5, "take_half")
            pos.half_sold = True
        elif not pos.time_checked and held_min >= exits["time_stop_minutes"]:
            pos.time_checked = True
            if price < e:
                sell(pos.remaining, "time_stop")
    else:
        if price <= pos.peak * (1 - exits["trail_from_peak"]):
            sell(pos.remaining, "trailing_stop")

    if pos.is_open and held_min >= exits["max_hold_minutes"]:
        sell(pos.remaining, "max_hold")
    return new


def force_close(pos: Position, price: float, t: float, reason: str):
    if pos.is_pending:
        pos.remaining = 0
        return
    if pos.is_open and price:
        frac = pos.remaining
        pos.remaining = 0
        pos.fills.append((frac, price, reason, t))


def net_return(pos: Position, cost_per_side: float):
    """Net return of a closed trade after costs on both sides."""
    if pos.entry_price is None or not pos.fills:
        return None
    cost_in = pos.entry_price * (1 + cost_per_side)
    proceeds = sum(frac * px * (1 - cost_per_side) for frac, px, _, _ in pos.fills)
    return proceeds / cost_in - 1


# ---------------------------------------------------------------- entry filter

def check_tradeable(t: dict, f: dict):
    """Token must be alive and tradeable. Applies to every strategy."""
    mcap, liq, vol = f.get("mcap"), f.get("liquidity_usd"), f.get("vol_m5")
    if mcap is None:
        return False, "missing_mcap"
    if liq is None:
        return False, "missing_liquidity_usd"
    if vol is None:
        return False, "missing_vol_m5"
    if mcap < t["min_mcap"]:
        return False, "mcap_too_small"
    if mcap > t["max_mcap"]:
        return False, "mcap_too_big"
    if liq < t["min_liquidity_usd"]:
        return False, "liquidity_too_small"
    if mcap > 0 and liq / mcap > t["max_liq_ratio"]:
        return False, "broken_liquidity_data"
    if vol < t["min_vol_m5_usd"]:
        return False, "no_recent_volume"
    return True, "ok"


def check_entry(strategy: dict, f: dict, blocklist: list):
    """Return (ok, reason). f is a dict of features for one token.

    Any missing data needed by a rule means REJECT (strict, never guess).
    """
    def need(key):
        v = f.get(key)
        if v is None:
            raise _Missing(key)
        return v

    try:
        age = need("age_minutes")
        if age < strategy["min_age_minutes"]:
            return False, "too_young"

        m5 = need("m5_change")
        if not (strategy["pullback_m5_min"] <= m5 <= strategy["pullback_m5_max"]):
            return False, "no_pullback"

        if not strategy.get("safety_checks"):
            return True, "ok"

        name = (str(f.get("symbol", "")) + " " + str(f.get("name", ""))).lower()
        for word in blocklist:
            if re.search(r"(^|[^a-z])" + re.escape(word) + r"([^a-z]|$)", name):
                return False, "blocked_name"

        mcap = need("mcap")
        liq = need("liquidity_usd")
        ratio = liq / mcap if mcap > 0 else 0
        min_ratio = strategy["min_liq_ratio_above_200k"] if mcap >= 200_000 else strategy["min_liq_ratio"]
        if ratio < min_ratio:
            return False, "low_liquidity"

        if need("rugged"):
            return False, "rugged"
        if need("mint_authority") or need("freeze_authority"):
            return False, "authority_not_revoked"

        if need("holders") < strategy["min_holders"]:
            return False, "few_holders"
        if need("top10_pct") > strategy["max_top10"]:
            return False, "top10_concentrated"
        if need("insider_pct") > strategy["max_insiders"]:
            return False, "insiders"
        return True, "ok"
    except _Missing as m:
        return False, f"missing_{m.key}"


class _Missing(Exception):
    def __init__(self, key):
        self.key = key
