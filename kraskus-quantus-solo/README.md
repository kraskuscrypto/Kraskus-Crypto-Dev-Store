# Quantus Solo (kraskus-quantus-solo) 0.1.1 — Dev Store

Quantus (QTC) mainnet full node for your own Quantus miners on the local network. **Dev testing release. Not a Main release.**

| Service | Published |
|---|---|
| UI | 33076 (via app_proxy) |
| HTTPS / operator access (sign-in, reward import, miner token) | 33078/tcp, LAN only |
| Miner ingress (QUIC, token + TLS pin) | 1935/udp → node 9833, LAN only, never forward from a router |
| Quantus P2P | 30333/tcp |

RPC (9944), node metrics (9615), miner metrics (9900) and the adapter are internal only.

Fixed policy:
- mainnet only;
- upstream telemetry off;
- mDNS off;
- optional local CPU miner off by default (testing only);
- no GPU miner;
- no developer fee;
- the app never accepts seed words.

## What's new in 0.1.1

This is an **adapter-only status-correctness maintenance release**.

- **Node verdicts:** a miner's self-reported `Completed` is no longer shown as if it were the node's verdict. The Miners table now shows what the node itself decided about each solution:
  - **Accepted by node:** the node took the solution as its next block. This does **not** mean a confirmed or found block: the block can still be orphaned. Found blocks appear only under "Blocks found by this node".
  - **Rejected by node:** the node refused the solution (the submit failed, or the seal was malformed).
  - **Submitted (no verdict):** the miner submitted, but the node logged no verdict. The job was stale or superseded, the result was dropped under load, or the decision is pending.
- **Unchanged components:** the node, miner and UI are the existing 0.1.0 binaries (same image digests). Only the adapter changed. Every component reports version 0.1.0 inside the app; the store version is 0.1.1.
- **Source:** the Corresponding Source for the node is now public and signed at https://github.com/kraskuscrypto/Quantus-Source-Mirror.

## First run

1. Open `https://<box IP>:33078/`. Compare the certificate fingerprint with:
   ```
   docker exec <ui container> kraskus-tls-fingerprint
   ```
2. Issue a one-time setup code on the host:
   ```
   docker exec <adapter container> python /app/operator_admin.py issue-setup-code
   ```
3. Set the operator passphrase with that code.
4. Import the wormhole reward address and inner hash.
   - Create them with the official Quantus wallet, or `quantus-node key quantus --scheme wormhole`, at account index 0.
5. The node syncs. Mining is held until it is synced.
6. Miners page → "Connect a miner": host IP, port 1935, TLS fingerprint and the auth token. Use quantus-miner 4.2.0.

Storage guidance is provisional: about 0.25 GB/day chain growth at current load.
