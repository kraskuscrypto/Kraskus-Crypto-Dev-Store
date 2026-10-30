# Bitcoin Cash (Development Preview) -- kraskus-bch-solo 0.5.1-dev

**Development preview. Mining is disabled. Not for production or live mining.**

* Pruned Bitcoin Cash Node 29.2.0 (about 10 GB of block data), wallet disabled, P2P listening off.
* Solo-mining dashboard with an external CashAddr payout address only (no wallet, never asks for secrets).
* Fixed 1 percent developer fee on found blocks only (separate coinbase output); 99 percent to the miner.
* Stratum supports BIP310 version rolling (Bitaxe / BM1366 / BM1370 compatible) for the later mining release.
* In this preview no Stratum port is published and the start control is refused.

Ports: UI `127.0.0.1:33073` (portal route only). Data: `${APP_DATA_DIR}/data/{node,state,apptoken}`.
A fresh install starts with no payout address, no history and its own app token.

Bitcoin Cash Node 29.2.0 has a built-in RPC expiry on 2027-05-15 12:00 UTC; an updated release ships before then.
Initial sync downloads and validates the whole chain; on a shared host, apply host-local disk limits
(a compose override in the app directory) rather than editing this recipe.
