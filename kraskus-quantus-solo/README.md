# Quantus Solo (kraskus-quantus-solo)

Quantus (QTC) mainnet full node for your own Quantus miners on the local network. **Dev Store release. Not a Main release.**

## 0.3.1

Fresh-install fix for stock 5tratumOS (no P2 secure proxy). Full notes: `apps/quantus-solo/docs/RELEASE-NOTES-0.3.1.md` (Kraskus-Mining-Platform).

- **First run works in the app.** Home shows *Reward identity required — Add your Quantus reward identity to start the node.* with the import form. The first reward identity is saved once; after that the first-run setup is closed for good and the node starts by itself.
- **Miner token in the app.** Settings → Mining → Miner token → Reveal shows the existing token (read-only) so you can set up your miner.
- **Still protected.** Changing the reward identity, rotating the miner token and regenerating the TLS certificate still need the platform's own secure login.
- Unchanged: the 1% developer fee and its disclosure, the node image, the miner, ports, data paths and payout accounting.

## 0.3.0

The first Kraskus V3 version of Quantus: the shared Kraskus V3 interface (foundation 1.7.0) with wallet-less rewards, the QUIC miner endpoint and the developer-fee disclosure. Full notes: `apps/quantus-solo/docs/RELEASE-NOTES-0.3.0.md` (Kraskus-Mining-Platform).

- **Developer fee.** Kraskus Quantus Solo includes a 1% developer fee. One out of every 100 block heights is assigned to the Kraskus developer reward identity; all other heights use your configured reward identity. Because solo mining rewards depend on when blocks are actually found, your realized fee percentage over a short period may differ from 1%.
  - Kraskus Quantus Solo uses the official Quantus node source as its base. Kraskus applies a disclosed developer-fee modification to block-template reward selection. The miner remains unmodified.
  - The fee is built into the Kraskus node (`node/patches/0001-kraskus-dev-fee.patch`, two files: block-template reward selection and the version string), so the node reports `1.0.2-Qm-482c5b9e02b-kraskus-devfee1`. It is not user-editable: there is no setting or route that changes it. Overview and Settings → Mining show it, and `GET /api/mining/dev-fee` reports it.
  - "Developer blocks" counts only blocks attributable to this install's own dev-fee templates. Developer blocks found by other installs are never counted. "Blocks found" are your blocks only.
  - The node image (binary sha256 `24e28fd8…59a3`) is pinned by its GHCR digest `4d070601…f3f5cd`.
- **New interface.** The shared V3 UI replaces the 0.1.x Template V2 pages. Rewards: the imported wormhole address, the masked inner hash and a pending-restart note. Mining: the miner endpoint (QUIC/UDP 1935, listening state, auth rejections), the TLS certificate fingerprint and the Copy Mining Configuration text (node address, port, fingerprint, where to get the token; never the token itself). Miner connections keep the 0.1.1 node verdicts: **Accepted by node**, **Rejected by node**, **Submitted (no verdict)**. "Accepted by node" is not a found block; found blocks are listed under Blocks (orphaned blocks are not listed).
- **No operator layer.** The 0.1.x operator passphrase, sessions, setup codes, `operator_admin.py` and the encrypted page on **port 33078 are gone**. Bookmarks to `https://<box>:33078/` stop working: open the app from the 5tratumOS dashboard (or Umbrel). The platform login protects the app.
- **Platform secure login required for secrets.** Changing the reward address and inner hash, revealing or rotating the miner token and regenerating the miner TLS certificate are accepted only through the platform's own secure login: the 5tratumOS P2 secure app proxy, or, on Umbrel, Umbrel's logged-in app proxy (the Umbrel package declares the Umbrel deployment and publishes no UI or adapter port; foundation 1.6.0, owner YES 2026-10-10). On stock 5tratumOS without P2 these actions are refused ("needs the platform's own secure login") and nothing changes; reading status, switching the local CPU miner and everything else keep working. An install that already has a reward address keeps mining to it. **Consequence (owner decision D5 = S3, kept for 5tratumOS):** on a fresh stock 5tratumOS install without P2 the reward address cannot be imported in the app, so the node does not start, and the miner token cannot be revealed in the app.
- **Nothing to reconfigure.** The 0.1.x data paths are kept exactly (`node/`, `config/rewards.json`, `config/settings.json`, `state/blocks.json`, `runtime/`, `miner-creds/`): the reward identity carries over without re-import, the node does not resync, and remote miners keep the same token and TLS pin.
- **Leftovers quarantined, not deleted.** `state/operator-auth.json` moves to `state/legacy-0.1.x/`; `tls/` stays in place with a marker file and is made root-only. 0.3.0 never reads either for authentication. Remove them yourself if you no longer need them.
- **Mixed component versions.** The local CPU miner is the unchanged 0.1.0 image (same digest; the miner is unmodified). The node is rebuilt by Kraskus with the developer-fee patch. The adapter and the UI are rebuilt and report 0.3.0.

## What runs

| Service | Image | Published |
|---|---|---|
| `init` | adapter image, one-shot (root, no network) | — |
| `node` | quantus-node v1.0.2-Qm (`482c5b9e`) + Kraskus dev-fee patch (`1.0.2-Qm-482c5b9e02b-kraskus-devfee1`) + supervisor. Image `sha256:4d070601…f3f5cd` | 30333/tcp (P2P), 1935/udp → 9833 (miners, LAN only) |
| `miner-local` | quantus-miner 4.2.0 + supervisor, **0.1.0 image** `sha256:e378ecd0…9988`; OFF by default | — |
| `adapter` | V3 adapter 0.3.1 | — (internal network only) |
| `ui` | shared V3 UI 0.3.1 (nginx) | 33076/tcp (127.0.0.1 under P2) |

RPC (9944), node metrics (9615), miner metrics (9900) and the adapter are internal only. Fixed policy: mainnet only, upstream telemetry off, mDNS off, local CPU miner off by default (testing only, not profitable), no GPU miner, a 1% developer fee (block heights with height % 100 == 0; deterministic, built into the node, not user-editable), seed words never accepted.

## First run

1. Open Quantus Solo from the 5tratumOS dashboard.
2. Home shows **Reward identity required**: paste the wormhole reward address and its inner hash and tick the three statements, then Save (first run only; this can be done once). Create them with the official Quantus wallet, or `quantus-node key quantus --scheme wormhole`, at account index 0. The app never asks for your 24 words.
3. The node starts and syncs. Mining is held until it is synced and the tip is fresh.
4. Mining → Copy Mining Configuration: node address (this computer's LAN IP), UDP port 1935, the TLS fingerprint. Settings → Mining → Miner token → Reveal, save it as `./miner-auth-token` next to quantus-miner 4.2.0 (save the fingerprint as `./miner-tls-cert-sha256`).

## Data under `${APP_DATA_DIR}`

| Path | Contents |
|---|---|
| `node/` | Chain database (archive; about 0.25 GB/day growth, provisional), node key, miner TLS certificate and key |
| `config/` | `rewards.json` (address + inner hash), `settings.json` (local CPU miner) |
| `state/` | `blocks.json` (blocks found and this install's developer-fee blocks; schema 2 since 0.3.0), `app-token/` (V3 app-token fallback), `legacy-0.1.x/` (quarantined 0.1.x operator sign-in file) |
| `runtime/` | Status files, the redacted node log, readiness for the local miner, restart requests |
| `miner-creds/` | Miner auth token (0600) and the public TLS pin |
| `tls/` | 0.1.x HTTPS certificate, unused since 0.3.0 (marked, kept) |

Uninstall-keep-data preserves all of it. Purge removes it.
