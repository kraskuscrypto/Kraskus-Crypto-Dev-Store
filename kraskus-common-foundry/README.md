# Common Foundry (kraskus-common-foundry) 0.1.0 — Dev Store

A Common Foundry mainnet node on 5tratumOS, with wallet integration, model-bank verification, node status, block monitoring and Kraskus controls (top-left label **CMFD Kraskus**).

**Dev testing release. Not a Main release.**

It runs the official Common Foundry v1.0.0 `cmfd-node`, unmodified (`033d41e`). The node waits for the authenticated mainnet launch on 3 October 2026 at 17:00 UTC: until then the app shows a countdown and the official node does not run.

| Service | Published |
|---|---|
| UI | 33072 (via app_proxy) |
| Common Foundry P2P | 29444/tcp |

The official RPC (127.0.0.1:29443), the RPC proxy, the adapter and the UI are internal only.

Fixed policy:
- no telemetry;
- no mDNS;
- no developer fee.

## Wallet

The wallet is the official encrypted `wallet.key`. There is no recovery phrase: the encrypted backup file together with its passphrase is the only way to restore it.

- Wallet setup opens after the mainnet launch.
- Download the backup and confirm it before you use the wallet.
- Operator actions (node restart, sends) need the wallet passphrase.
- The passphrase is checked by the node container and is never shown, logged or sent anywhere else.

## Model bank

The 6.4 GB ForgeMatrix model bank is downloaded at runtime from the official Common Foundry sources and checked against its pinned SHA-256 (`5f9b213c…7d4e`). It is never part of the image.

## Not in 0.1.0

- **NVIDIA mining** is not included in the base 0.1.0 package. Official NVIDIA miner support will be added through the GPU companion package after 5tratumOS GPU qualification.
- **AMD mining** is not available in 0.1.0.

Common Foundry's own logo is not used; the emblem is original Kraskus artwork.
