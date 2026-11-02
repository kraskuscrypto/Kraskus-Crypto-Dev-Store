# Monero by Kraskus 0.3.0

BCH-standard external-wallet mining interface adapted to Monero. No user-facing native wallet, seed, send, restore or wallet-balance controls.

- RandomX Stratum TCP1921; UI33065; Monero P2P18080. No wallet or daemon RPC is published.
- A confirmed external primary address or subaddress receives99% of each found coinbase reward. The remaining1%, rounded down to whole piconero, is a separate developer output. Both mature under Monero's60-block rule.
- A fresh install or native-wallet migration starts paused. After the operator explicitly starts external mining, that Start/Stop choice is retained across ordinary restarts.
- Protocol-defined pruning has no arbitrary GiB slider. Unavailable telemetry stays unavailable.
- Legacy wallet directories, keys, funds and backup files must be preserved. This edition does not mount or sweep them. Keep the old compose and encrypted backups for recovery with the previous wallet tooling.
- Kraskus Pool is under development; no pool forwarding is enabled.

Release checks and migration qualification must pass before this candidate is published or installed. See `qualification/external-wallet/RESULTS.md` in the source repository.
