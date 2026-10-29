# Bitcoin (Development Preview) -- kraskus-btc-solo 0.5.0-dev

**Development preview. Mining is disabled. Not for production or live mining.**

* Pruned Bitcoin Core 32.1 node (about 30 GB of block data), wallet disabled, P2P listening off.
* Solo-mining dashboard with an external payout address only (no wallet, never asks for secrets).
* Fixed 1 percent developer fee on found blocks only (separate coinbase output); 99 percent to the miner.
* In this preview no Stratum port is published and the start control is refused.

Ports: UI `127.0.0.1:33079` (portal route only). Data: `${APP_DATA_DIR}/data/{node,state,apptoken}`.
A fresh install starts with no payout address, no history and its own app token.

Initial sync downloads and validates the whole chain; on a shared host, apply host-local disk limits
(a compose override in the app directory) rather than editing this recipe.
