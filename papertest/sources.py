"""Public market-data clients (no API keys needed).

- GeckoTerminal: discovery of trending Solana pools
- DexScreener: discovery (boosts, profiles) and fast price polling
- RugCheck: holder distribution, insiders, mint/freeze authority

All calls are defensive: on any error they return None / empty and the
caller treats missing data as "do not trade".
"""

import json
import time
import urllib.error
import urllib.request

UA = "Mozilla/5.0 (paper-trading research script; no trading)"

SKIP_MINTS = {
    "So11111111111111111111111111111111111111112",  # wSOL
    "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",  # USDC
    "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",  # USDT
}

_last_call = {}


def _get(url, min_interval=0.0, accept="application/json", timeout=15, retries=2):
    host = url.split("/")[2]
    wait = _last_call.get(host, 0) + min_interval - time.time()
    if wait > 0:
        time.sleep(wait)
    for attempt in range(retries + 1):
        _last_call[host] = time.time()
        try:
            req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": accept})
            with urllib.request.urlopen(req, timeout=timeout) as r:
                return json.loads(r.read().decode("utf-8"))
        except urllib.error.HTTPError as e:
            if e.code == 429 and attempt < retries:
                time.sleep(5 * (attempt + 1))
                continue
            if e.code >= 500 and attempt < retries:
                time.sleep(2)
                continue
            return None
        except Exception:
            if attempt < retries:
                time.sleep(2)
                continue
            return None
    return None


def _f(x):
    try:
        return float(x)
    except (TypeError, ValueError):
        return None


# ------------------------------------------------------------------ discovery

def discover():
    """Return a set of candidate Solana token mints from several public feeds."""
    mints = set()

    for q in ("", "?duration=5m", "?duration=1h"):
        d = _get(
            f"https://api.geckoterminal.com/api/v2/networks/solana/trending_pools{q}",
            min_interval=2.5,
            accept="application/json;version=20230302",
        )
        for pool in (d or {}).get("data", []) or []:
            try:
                tid = pool["relationships"]["base_token"]["data"]["id"]
                if tid.startswith("solana_"):
                    mints.add(tid[len("solana_"):])
            except (KeyError, TypeError):
                pass

    for path in ("token-boosts/latest/v1", "token-boosts/top/v1", "token-profiles/latest/v1"):
        d = _get(f"https://api.dexscreener.com/{path}", min_interval=1.1)
        if isinstance(d, list):
            for item in d:
                if isinstance(item, dict) and item.get("chainId") == "solana" and item.get("tokenAddress"):
                    mints.add(item["tokenAddress"])

    return mints - SKIP_MINTS


# --------------------------------------------------------------------- prices

def poll_prices(mints):
    """Fetch current market data for up to N mints (batched 30 per call).

    Returns {mint: snapshot}. Uses the most liquid pair for each token.
    """
    out = {}
    mints = list(mints)
    for i in range(0, len(mints), 30):
        batch = mints[i:i + 30]
        d = _get("https://api.dexscreener.com/tokens/v1/solana/" + ",".join(batch), min_interval=0.25)
        if not isinstance(d, list):
            continue
        best = {}
        for p in d:
            try:
                mint = p["baseToken"]["address"]
            except (KeyError, TypeError):
                continue
            if mint not in batch:
                continue
            liq = _f((p.get("liquidity") or {}).get("usd")) or 0
            if mint not in best or liq > best[mint][0]:
                best[mint] = (liq, p)
        now = time.time()
        for mint, (liq, p) in best.items():
            price = _f(p.get("priceUsd"))
            if not price:
                continue
            created = p.get("pairCreatedAt")
            out[mint] = {
                "t": now,
                "price": price,
                "symbol": (p.get("baseToken") or {}).get("symbol"),
                "name": (p.get("baseToken") or {}).get("name"),
                "dex": p.get("dexId"),
                "pair": p.get("pairAddress"),
                "liquidity_usd": _f((p.get("liquidity") or {}).get("usd")),
                "mcap": _f(p.get("marketCap")) or _f(p.get("fdv")),
                "m5_change": _f((p.get("priceChange") or {}).get("m5")),
                "h1_change": _f((p.get("priceChange") or {}).get("h1")),
                "vol_m5": _f((p.get("volume") or {}).get("m5")),
                "age_minutes": (now * 1000 - created) / 60000 if created else None,
            }
    return out


# ------------------------------------------------------------------- rugcheck

def rugcheck(mint):
    """Holder / safety features. Returns dict (values None when unknown)."""
    d = _get(f"https://api.rugcheck.xyz/v1/tokens/{mint}/report", min_interval=1.5, timeout=25)
    res = {
        "holders": None, "top10_pct": None, "insider_pct": None,
        "mint_authority": None, "freeze_authority": None, "rugged": None,
        "rc_score": None,
    }
    if not isinstance(d, dict):
        return res

    token = d.get("token") or {}
    supply = _f(token.get("supply"))
    res["holders"] = d.get("totalHolders")
    res["rugged"] = bool(d.get("rugged", False))
    res["rc_score"] = d.get("score_normalised", d.get("score"))
    if "mintAuthority" in token or "mintAuthority" in d:
        res["mint_authority"] = bool(token.get("mintAuthority", d.get("mintAuthority")))
    if "freezeAuthority" in token or "freezeAuthority" in d:
        res["freeze_authority"] = bool(token.get("freezeAuthority", d.get("freezeAuthority")))

    holders = d.get("topHolders")
    if not isinstance(holders, list) or not holders:
        return res

    # Accounts that are pools / lockers, not real holders.
    known = d.get("knownAccounts") or {}
    pool_like = {a for a, info in known.items()
                 if isinstance(info, dict) and str(info.get("type", "")).upper() in ("AMM", "LOCKER")}
    for m in d.get("markets") or []:
        if isinstance(m, dict):
            for k in ("pubkey", "liquidityA", "liquidityB", "liquidityAAccount", "liquidityBAccount"):
                if isinstance(m.get(k), str):
                    pool_like.add(m[k])

    def share(h):
        amt = _f(h.get("amount"))
        if supply and amt is not None:
            return amt / supply
        pct = _f(h.get("pct"))
        return pct / 100.0 if pct is not None else None

    real, insider = [], 0.0
    for h in holders:
        if not isinstance(h, dict):
            continue
        if h.get("address") in pool_like or h.get("owner") in pool_like:
            continue
        s = share(h)
        if s is None:
            continue
        real.append(s)
        if h.get("insider"):
            insider += s
    if real:
        res["top10_pct"] = sum(sorted(real, reverse=True)[:10])
        res["insider_pct"] = insider
    return res
