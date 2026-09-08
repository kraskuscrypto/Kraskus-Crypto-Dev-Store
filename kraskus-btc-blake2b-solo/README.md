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

0.1.0-dev2 is a Developer test release. Runtime images are pinned by
immutable GHCR digest (adapter and UI rebuilt from the qualified source
commit; Knots and DATUM republished unchanged, not rebuilt — see
`5tratstore-review.yml` for exact digests).

Qualified:
- Wallet V7
- Native/External payout switching
- receive/new-address/QR
- wallet balance/history
- theme inheritance across all 8 themes
- encrypted send flow qualified on regtest
- mainnet send/encryption disabled by default
- 1% developer-fee policy packaged
- 100 GB pruning

Still under mining qualification:
- full Knots sync/tip
- BLAKE2b activation/tip behavior
- real BLAKE2b ASIC accepted shares
- real successful-block/dev-fee proof
- found-block path
- final reboot/recovery qualification

This is not an Official Store release and must not be promoted until
clean-install/update/uninstall/reboot qualification is complete.
