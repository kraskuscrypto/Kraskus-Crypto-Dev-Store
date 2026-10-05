# Common Foundry (kraskus-common-foundry) 0.1.2 — Dev Store

A Common Foundry mainnet node on 5tratumOS, with an encrypted wallet, model-bank verification, node status, block monitoring and Kraskus controls (top-left label **CMFD Kraskus**).

**Dev testing release. Not a Main release.**

It runs the official Common Foundry v1.0.8 `cmfd-node`, unmodified (`3aa5369`), from its signed release.

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

- Download the backup and confirm it before you use the wallet.
- The wallet passphrase is needed only to send, back up, restore or forget the wallet. Mining controls, pool and worker settings and node restart do not ask for it.
- The passphrase is checked by the node container and is never shown, logged or sent anywhere else.

## Storage

The node stops before the disk runs out (below 28 GiB free) and starts again above 52 GiB free. The app warns when the disk is 80% used or is projected to fill within 7 days. Chain data is never pruned or deleted.

## Model bank

The 6.4 GB ForgeMatrix model bank is downloaded at runtime from the official Common Foundry sources and checked against its pinned SHA-256 (`5f9b213c…7d4e`). It is never part of the image.

## Updating from 0.1.0

Update and keep your data. The wallet, chain and model bank are kept; 0.1.0's node could not sync past height 0, and 0.1.2 syncs from the network.

## Not in 0.1.2

- **NVIDIA mining** is not included in the base package. Official NVIDIA miner support will be added through the GPU companion package after 5tratumOS GPU qualification.
- **AMD mining** is not available.

The icon is the official Common Foundry CF emblem.
