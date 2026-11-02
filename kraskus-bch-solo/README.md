# Bitcoin Cash by Kraskus 0.5.1-dev

Development build for supervised BCH solo-mining tests. Hardware qualification of this packaging is pending.

- Walletless BCHN 29.2.0 node, pruned to about 10 GB of blocks; external CashAddr reward address.
- Mining capability enabled: TCP 1933. Each startup is paused. Save the reward address, wait for sync, then press Start in the authenticated app.
- Fixed 1% developer fee on found blocks; 99% to the configured reward address. No reward is guaranteed.
- BIP310 version rolling tested against BCHN with independently assembled rolled block headers; real-miner qualification is separate.
- No wallet UI or private keys. No changes to the existing Kraskus UI.

UI: loopback 33073 through the platform portal. Stratum: host TCP 1933, bind configurable with BCH_STRATUM_BIND_IP. Do not forward the development port from the internet. RPC remains private on the internal Docker network.

All images are digest-pinned to the exact public CI candidates qualified on VM100: 127 unit tests, 24 platform checks and BCHN regtest including restart recovery. Scan: no critical or fixable high findings; unfixed high findings remain in the base packages.

Source: private Kraskus-Mining-Platform, apps/bch-solo at 81ea0490fcfeb92287d6a187830e93ee3b5092db (access required). Third-party notices: LICENSES.md and license files embedded in the images. This store repository distributes the recipe, not the proprietary app source.

A fresh install uses fresh app state/token. Seed an existing chain only after clean shutdown, copying blocks and chainstate into a separate datadir. Never run two nodes on one writable datadir.

BCHN has a recorded RPC expiry of 2027-05-15 12:00 UTC; plan its update before that date.

## External-wallet UI gold-standard update

0.5.5-dev adopts the audited external-wallet design: local-HTTP Copy fallback, refresh-safe worker editing, single-render navigation, compact share/difficulty displays and the planned Kraskus Pool page. Backend coin rules and the fixed 1% fee remain unchanged from each release source branch; node and front-proxy pins are retained. BTC mining stays disabled in this store profile. The gold-standard tag certifies the design/function baseline, not mainnet launch qualification.
