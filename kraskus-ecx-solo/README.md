# ECX by Kraskus — preview recipe

ECX is the ecash.com Drivechain fork, not XEC. Linux amd64 only.

Mainnet mining is deliberately locked off. No Stratum, P2P, node RPC or enforcer RPC port is published. The preview supports node status and external-payout configuration, not live mainnet mining. There is no native wallet.

The recipe image contains the Kraskus app and MIT simplepool. First start downloads the pinned official node archive and enforcer release asset directly from their publishers into vendor/, checks SHA256 before execution and records executable hashes. No enforcer binary is mirrored in the Kraskus image. Node archive build attestations were independently checked during qualification; the enforcer has an upstream asset digest, not a claimed signature.

A fresh full chain requires a data filesystem with at least 1 TiB free (conservative installation policy, not a consensus rule). Under that threshold, the UI says Storage needed and no chain download starts. An existing chain pauses below 20 GiB free. ECX cannot be pruned while using this enforcer. VM100 currently lacks capacity for a fresh mainnet chain; this recipe is not installed there.

The image is pinned to the immutable GHCR digest in release-manifest.json. Do not substitute a mutable tag. The image is currently private; anonymous installation is blocked until the owner approves public package visibility. Preserve all APP_DATA_DIR directories on updates and rollback. Restart always leaves mining paused. This is a new app ID, not a migration of BTC or another chain.

The developer destination is public; the separate developer wallet and recovery files are never included in this recipe. No miner payout address is prefilled.

Remaining mainnet gates: dedicated storage, live-chain/enforcer qualification, physical ASIC tests and explicit mining activation. Regtest does not prove all firmware or all live Drivechain proposal/withdrawal combinations.
