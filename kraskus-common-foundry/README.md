# Common Foundry Solo (kraskus-common-foundry) 0.1.4: Dev/Test release

**External GPU qualification required. Not Main-qualified, not a production release.**

**What it is:** a Common Foundry mainnet node with its encrypted wallet behind the Kraskus interface, plus **true solo mining**.
- The official `cmfd-miner` connects to this node on port **29445**, using the Common Foundry native protocol over TLS.
- Block rewards go straight to your own wallet: no pool, no payout ledger, and no developer fee.

**Solo needs a prover.** It requires a **paired LAN GPU prover** (`kraskus-cmfd-prover`), and the miner endpoint opens only after that prover reports ready.
- **Prover hardware:** an NVIDIA GPU with **at least 16 GB VRAM**; **24 GB is recommended** (RTX 4090 or RTX 5090). This release's v1.0.8 workers support RTX 40 and RTX 50 cards only.
- **Kraskus hardware can't finish qualification:** Kraskus internal hardware cannot complete the final real prover/mining qualification. This release is intended for external tester validation before Main publication.
- **Tester guide:** [Kraskus-Crypto-Apps `apps/common-foundry/docs/SOLO-DEV-TESTER-GUIDE.md`](https://github.com/kraskuscrypto/Kraskus-Crypto-Apps/blob/feature/common-foundry-gpu-companion/apps/common-foundry/docs/SOLO-DEV-TESTER-GUIDE.md).

| Service | Published |
|---|---|
| UI | 33072 (via app_proxy) |
| Common Foundry P2P | 29444/tcp |
| Solo miner endpoint | 29445/tcp: listens **only** while Solo Prover Ready holds |

The official RPC, the RPC proxy, the adapter and the UI are internal only.

**Node:** the Kraskus solo build of `cmfd-node` 1.0.8.
- It's built reproducibly from [kraskuscrypto/Kraskus-Common-Foundry-Solo](https://github.com/kraskuscrypto/Kraskus-Common-Foundry-Solo) at `ef3ccfe`, on top of upstream v1.0.8 `3aa5369`.
- Its SHA-256 `532de83f…c52e` is pinned and checked again during the image build.
- The rest of the runtime is the official signed v1.0.8 release.

**Wallet:** the official encrypted `wallet.key`. Download and confirm its backup before you rely on it. The passphrase is needed only to send, back up, restore or forget the wallet; pairing a prover never needs it.

**Storage:** a first start needs about **250 GB free**, for the chain, one day of growth and the reserve. With internet access the mainnet node always uses public P2P.

**Model bank:** the 6.4 GB ForgeMatrix model bank is downloaded at runtime from the official sources and checked against its pinned SHA-256. It is never part of the image.

## 0.1.4 qualification status

| Area | Status |
|---|---|
| Build, unit and UI tests, package validation | PASS |
| Isolated non-GPU runtime QA: startup, relay closed while the prover isn't ready, pairing/unpairing without a node restart, wallet and config persistence, clean stop/start, truthful status, no extra host ports | PASS |
| Real GPU prover self-test | PENDING EXTERNAL HARDWARE QUALIFICATION |
| Real external `cmfd-miner` connection | PENDING EXTERNAL HARDWARE QUALIFICATION |
| Live proving and mining behaviour | PENDING EXTERNAL HARDWARE QUALIFICATION |
| Accepted, rejected and stale truth under real proving | PENDING EXTERNAL HARDWARE QUALIFICATION |
| Restart during active proving and mining | PENDING EXTERNAL HARDWARE QUALIFICATION |
| Mainnet block-production proof | PENDING EXTERNAL HARDWARE QUALIFICATION |

**Known issue (wording only):** before the node's first start, the endpoint check reads "this node build has no solo endpoint". The node simply hasn't reported yet.

The icon is the official Common Foundry CF emblem.
