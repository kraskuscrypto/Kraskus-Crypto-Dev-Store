# Kraskus BTC BLAKE2b Solo

Native 5tratumOS Dev Store package for the Kraskus BTC BLAKE2b
true-solo appliance.

## Ports

- 33066 — 5tratumOS application proxy entry
- 8333/tcp — Bitcoin Knots P2P
- 23334/tcp — CONVOY DATUM Stratum V1 miner endpoint

Knots RPC, DATUM API, and the adapter API are not published to the host.

## Persistent data

All persistent state lives below `${APP_DATA_DIR}`:

- blockchain/
- runtime/
- secrets/

The first-run initializer creates local RPC and DATUM administrative
credentials under the protected secrets directory.

## Developer fee

The DATUM image contains the Kraskus 1% successful-block coinbase split.
Miner hashrate is not redirected.

## Development qualification

0.1.0-dev1 is a VM120-only Dev Store candidate. It is not an Official
Store release and must not be promoted until immutable image digests and
full install/update/uninstall/reboot qualification are recorded.
