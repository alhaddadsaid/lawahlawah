"""Offline fake market used only to test the code (no network).

Prices follow noisy random walks with occasional pumps and crashes, and the
clock is simulated so a 2-hour run finishes in seconds.
"""

import math
import random


class FakeMarket:
    def __init__(self, seed=1, n_tokens=25):
        self.rng = random.Random(seed)
        self.t = 1_760_000_000.0
        self.tokens = {}
        for i in range(n_tokens):
            safe = i % 2 == 0
            self.tokens[f"MINT{i:03d}"] = {
                "symbol": f"TK{i}",
                "name": "Elon Farm" if i == 4 else f"Token {i}",
                "price": 1e-4 * (1 + i),
                "hist": [],
                "created": self.t - self.rng.uniform(5, 600) * 60,
                "supply_mcap": self.rng.uniform(5e4, 2e6),
                "liq_ratio": self.rng.uniform(0.12, 0.35) if safe else self.rng.uniform(0.03, 0.12),
                "rc": {
                    "holders": self.rng.randint(1200, 8000) if safe else self.rng.randint(100, 900),
                    "top10_pct": self.rng.uniform(0.12, 0.28) if safe else self.rng.uniform(0.3, 0.7),
                    "insider_pct": self.rng.uniform(0, 0.06) if safe else self.rng.uniform(0.1, 0.4),
                    "mint_authority": False, "freeze_authority": False, "rugged": False,
                    "rc_score": 1,
                },
                "vol": self.rng.uniform(0.005, 0.03),
                "alive": True,
            }
        self.base_price = {m: k["price"] for m, k in self.tokens.items()}

    # simulated time
    def clock(self):
        return self.t

    def sleep(self, s):
        self._advance(max(s, 0.5))

    def _advance(self, s):
        steps = max(1, int(s))
        for _ in range(steps):
            self.t += s / steps
            for k in self.tokens.values():
                if not k["alive"]:
                    continue
                r = self.rng.gauss(0, k["vol"] / math.sqrt(5))
                if self.rng.random() < 0.0008:
                    r += self.rng.choice([0.4, -0.5])  # pump or crash
                k["price"] *= math.exp(r)
                k["hist"].append((self.t, k["price"]))
                if len(k["hist"]) > 600:
                    k["hist"] = k["hist"][-600:]
                if self.rng.random() < 0.00002:
                    k["alive"] = False  # token disappears (rug)

    def discover(self):
        self._advance(3)
        return set(m for m, k in self.tokens.items() if k["alive"])

    def poll_prices(self, mints):
        self._advance(1)
        out = {}
        for m in mints:
            k = self.tokens.get(m)
            if not k or not k["alive"]:
                continue
            past = [p for (tt, p) in k["hist"] if tt <= self.t - 300]
            ref = past[-1] if past else (k["hist"][0][1] if k["hist"] else k["price"])
            mcap = k["supply_mcap"] * k["price"] / self.base_price[m]
            out[m] = {
                "t": self.t, "price": k["price"], "symbol": k["symbol"], "name": k["name"],
                "dex": "fake", "pair": m, "liquidity_usd": mcap * k["liq_ratio"], "mcap": mcap,
                "m5_change": (k["price"] / ref - 1) * 100, "h1_change": None, "vol_m5": self.rng.uniform(500, 20000),
                "age_minutes": (self.t - k["created"]) / 60,
            }
        return out

    def rugcheck(self, mint):
        self._advance(1.5)
        return dict(self.tokens[mint]["rc"])
