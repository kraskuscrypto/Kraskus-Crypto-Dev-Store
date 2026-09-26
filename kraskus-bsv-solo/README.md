# Bitcoin Satoshi Vision

Bitcoin Satoshi Vision (SV Node 1.2.2, pruned) node and private solo-mining controller for
5tratumOS. Miners connect to `stratum+tcp://<host>:1922` with any worker name;
rewards pay the address configured in the app (external address or the
built-in wallet). 1% of each block reward is a developer-fee coinbase output.

## 0.3.3

Home hero coin face only; everything else is unchanged from 0.3.2.

- The hero coin is gold: engraved legend band from the Satoshi Vision
  reference coin, BSV side marks, circuit traces and a dragon coiled behind the struck B, drawn
  in code (`ui-v2/components/bsv-coin-face.tsx`, no image asset). The coin's
  size, float and tilt, orbits and glow are unchanged.

## 0.3.2

SV Node shutdown hardening; everything else is unchanged from 0.3.1.

- Every SV Node stop is logged by the node supervisor:
  `BSV_NODE_SHUTDOWN_BEGIN`, then `BSV_NODE_SHUTDOWN_CLEAN`,
  `BSV_NODE_SHUTDOWN_UNCLEAN` or `BSV_NODE_SHUTDOWN_TIMEOUT`.
- A clean exit leaves `.kraskus-node-clean-shutdown` in the node datadir; a
  stop that runs out of time exits 137 instead of reporting success; a start
  after an unconfirmed stop logs `BSV_NODE_PREVIOUS_SHUTDOWN_UNCONFIRMED`.
- `bsv-safe-stop.sh` (in this package) stops SV Node with up to 900 s to
  flush and refuses to continue an update or reinstall unless the clean exit
  is confirmed. Run it before any update, `app down` or `app uninstall`:

      sudo bash /opt/5tratumos/store/<channel>/kraskus-bsv-solo/bsv-safe-stop.sh --then update

## 0.3.1

Stratum job-lifecycle hotfix; everything else is unchanged from 0.3.0.

- Same-tip template refreshes keep earlier jobs valid (`clean_jobs=false`);
  each job for the current block is honoured for 10 minutes, up to 64 jobs.
  Refreshes are published at most every 30 s; a new block is published at
  once with `clean_jobs=true` and retires every older job.
- Share replies distinguish `stale job` (old block), `Job not found
  (expired)` and `Job not found` (never issued).
- A transient node condition (an RPC call timing out while SV Node is busy)
  holds the gate open with the issued jobs for up to 90 s instead of
  disconnecting every miner; the cause is logged (`BSV_GATE_HOLD`).
- Every Stratum disconnect is logged with its reason
  (`BSV_STRATUM_DISCONNECT`) and counted in the controller status.

## 0.3.0

- Images rebuilt from committed source (`apps/bsv-solo/build.sh`), labelled
  with version and source revision; hero artwork restored in source.
- SV Node always runs with `-excessiveblocksize=10000000000` (10 GB),
  appended last by the node supervisor and verified via `getsettings`.
- One readiness model for Home, Mining, Stratum and the API; Stratum 1922
  refuses miners with a reason until the node is synced, has peers, a payout
  is configured and (for the built-in wallet) its backup is confirmed.
- Built-in wallet: create, encrypted full `wallet.dat` backup, verify and
  confirm, forget, restore (Kraskus backup or raw `wallet.dat`) to the same
  address, pruned-history rebuild. Sending removed.
- Blocks from a durable ledger with confirmed / maturing / orphaned /
  rejected states; "no blocks found" is distinct from "block data
  unavailable".
- Upgrading from 0.2.2-beta keeps chain data, settings and the node wallet
  (same address); the legacy UI and backup-export services are removed. If
  the 0.2.x built-in wallet was the mining payout, mining to it pauses until
  an encrypted backup is downloaded, verified and confirmed, then resumes.
- The wallet password is an app password (backup download, restore/replace,
  Forget), not a spending password.
