# KDA Solo by Kraskus 0.1.0

A Kadena (KDA) Chainweb node, a Kadena wallet, and a true-solo Stratum endpoint for Kadena
(Blake2s) ASICs, packaged for 5tratumOS.

## Which Kadena network

Kadena LLC stopped operating in October 2025, and its original network stopped producing blocks
on 2025-11-15. Since then the Kadena network has been run by independent miners on the
**community edition** of chainweb-node, maintained by `github.com/kda-community`. It uses the
same `mainnet01` history, accounts and balances up to the fork point.

- This app runs that community node (**chainweb-node 3.2.1**).
- Exchanges and wallets that still follow Kadena should be on this network. Check yours before
  you deposit.

## What it does

- **Node.** Validates all **20 chains**.
  - The UI shows sync **per chain**: "N of 20 chains synced", with a per-chain table. Chainweb
    has no single block height.
  - The first start downloads a **~59 GB** community database snapshot and checks its BLAKE2
    checksums. After that the node validates everything that follows.
  - The snapshot's state is trusted as published by the community snapshot service. That is
    disclosed here and in the UI.
- **Wallet.** One Kadena **`k:` account** (`k:` + your Ed25519 public key).
  - Recovery phrase: 24 BIP39 words, SLIP-0010 path `m/44'/626'/0'` (the Kadena standard).
    They are shown **once** and confirmed with a 4-word check. Mining stays paused until you
    complete this.
  - An optional encrypted backup file is also available.
  - Balances are shown **per chain**.
  - **Same-chain send** requires your password and a typed confirmation.
  - **Cross-chain transfers are not offered** in this version.
- **Mining.**
  - Point Kadena ASICs at `stratum+tcp://<this machine's IP>:1917`.
  - Blocks pay your wallet directly.
  - The Blocks page lists only blocks the network actually accepted, and marks them confirmed
    at 20 blocks deep on their chain.

## Connect a miner

| Setting | Value |
|---|---|
| Pool URL | `stratum+tcp://<LAN IP of your 5tratumOS box>:1917` |
| Username / worker | `anything.WORKERNAME`. Only `WORKERNAME` is used. Rewards always go to this app's wallet. |
| Password | anything (e.g. `x`) |

Mining starts only when these are all true:
- the node is synced on at least 17 of 20 chains;
- the wallet backup is confirmed;
- the node has restarted with your payout key. This happens once, automatically.

The Mining page states the exact reason whenever mining is paused.

**ASIC support: unverified.** No Kadena ASIC has been tested on this gateway yet. It speaks the Kadena ASIC Stratum
dialect (the one that `chainweb-mining-client` and the major pools serve), but no model is claimed until a tester completes
`docs/asic-tester-checklist.md` on a named firmware version.

## Developer fee

A fixed **1%** of every **confirmed** block reward is paid to the Kraskus developer account.
- It is paid on the same chain the reward landed on, by a transfer this app signs automatically.
- Chainweb pays each block reward to a single account, so the fee cannot be split out of the
  block itself.
- Nothing else is ever signed without your confirmation.
- If a fee cannot be paid for 24 h, mining pauses and says why. The usual cause is that that
  chain's balance was swept to zero.

## Storage, ports, resources

| Item | Value |
|---|---|
| Disk | ~59 GB at install, growing. Keep **≥ 80 GB free**; the snapshot download refuses to start below that. |
| RAM | 4–8 GB for the node |
| CPU | x86-64 only: mining coordination is refused by chainweb-node on other architectures. |
| Ports | 1917/tcp Stratum (LAN), 1789/tcp Chainweb P2P, and 33075 for the UI via app proxy |

The node runs in **private P2P mode** by default. It fetches blocks only from the community
bootstrap nodes and does not ask other nodes to connect back to it, so it works behind a
home router with no port forwarding. Serving the network as a public node requires forwarding
TCP 1789; public mode is not offered in the UI yet.

## Security notes

- **The wallet key is sealed under your wallet password.** Nothing on this machine can open it without the password: no
  machine key is stored. A copy of the app's data (a backup, a stolen disk) holds only the encrypted file, so choose a
  strong password.
- **The wallet starts locked after every restart.** Mining continues while it is locked (the node only needs the public
  key). Sending and developer-fee settlement need an unlock: open Wallet and enter the password. Fees earned while locked
  are recorded and settle after the unlock. If fees wait more than 72 hours because the wallet stays locked, mining pauses
  until you unlock.
- **While unlocked, anyone who controls this machine can use the key** (root, or a compromised app container). Lock it
  from the Wallet page when you do not need it; the key is then dropped from memory.
- Forgot the password? Forget the wallet and restore it from your 24 words or your encrypted backup file with a new
  password. The words and the backup file are the only recovery; the app cannot reset the password.
- If the machine may be compromised, restore your 24 words on another device and move your KDA on every chain.
- Keep large amounts elsewhere; sweep rewards to a wallet this machine never sees.
- Keys and passwords are never logged.

## Stopping safely

chainweb-node needs time to close its databases. The app gives it up to 6 minutes. Prefer
stopping the app from the 5tratumOS UI rather than force-removing its containers.

## Limitations (0.1.0)

- Same-chain sends only. Cross-chain transfers are planned; the compacted database may not
  serve the SPV proofs they need.
- Incoming transfers are listed from the install height onward; there is no external indexer.
- Chainweaver legacy wallets (BIP32-Ed25519) cannot be restored.
- Pruning is limited to what chainweb-node itself does; the database grows over time.
