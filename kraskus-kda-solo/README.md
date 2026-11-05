# Kadena by Kraskus 0.2.1

Community Chainweb node with the shared Home, Mining, Blocks, Blockchain,
Kraskus Pool and Settings interface. Per-chain sync status is retained.

Rewards use a separate internal custody signer. After the existing 20-block
reward confirmation, the signer forwards the external miner reward and the
existing 1% developer fee in one same-chain transaction. Gas is separate.
Unused reserved gas remains miner credit and is carried into a later payout
without another developer fee. If mining stops, retained credit remains in
custody; it is not silently donated. Payouts are confirmed on their own chain.

No native-wallet, seed, private-key, send or unlock controls are exposed in
the UI/API. Legacy wallet files, balances and history are preserved without
automatic adoption or sweeping. Syncing works without signer setup. New
mining requires an external single-key `k:` account and an owner-configured
signer with a verified encrypted recovery backup. Destination changes after
mining starts require reconciliation, so pending rewards cannot be redirected.

The developer destination, node binary, Stratum binary, chain rules, snapshot
bootstrap and network ports remain unchanged. Kraskus Pool is under development.
Chainweb pruning is not offered as a user-adjustable Bitcoin-style setting.

## Qualification

Backend/API/recovery tests, all six responsive UI pages at desktop/375/320px,
light/dark themes, fixed hero/header artwork, best-share display and Copy
controls. Actual-bind create-before-init startup and restart were tested with
the real development node, no wallet setup and mining paused. Financial
integration used two real CPU-mined development rewards and synthetic gateway
events, with real Pact signatures, same-chain confirmations, restart after send,
retained-gas credit and duplicate-trigger checks. This is not ASIC qualification.

## Owner setup

Installation does not create a mainnet key or start mining. The owner-terminal
custody helper creates a separate signer and encrypted backup, then verifies a
restore. It leaves approval and off-host-backup flags disabled. An unlock
credential is needed for unattended signing; the internal signer is a hot
custody account, not a user-owned external wallet. Keep the encrypted recovery
copy outside the app before approving signer operation. Never paste credentials
or backup passwords into chat.

The snapshot helper uses the platform-recognized `bootstrap-init` name so a successful one-shot does not leave the app marked degraded.

## Kraskus Pool integration — Under Development

The Pool tab previews planned solo/pool switching, scheduled times with an explicit time zone, invite-only private mining groups, optional connection fallback and clear mode/fee/reward status. These controls are not implemented yet; support depends on the coin and pool. The introduction does not change current mining, payout addresses or fees. See pool-tab-update.json for the exact UI image and validation scope.
