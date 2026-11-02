# Bitcoin by Kraskus0.5.3

BCH0.5.9 interface standard, adapted to Bitcoin: original hero, six themes and independent light/dark, interactive graph, round best-share percentage, worker details, external payout confirmation and safe pruning. Kraskus Pool remains under development.

No native wallet or key controls. The existing1% developer output and Bitcoin-specific address/SegWit/version-rolling rules are preserved. This Store profile keeps mainnet mining disabled; syncing and separately approved activation remain necessary.

Pruning starts at30000MiB of block data, excluding chainstate/indexes. Adjusting1–1000GiB requires paused mining, fresh node telemetry and a clean node restart. Host-local resource overrides must be retained during updates, including their node command wrapper. Existing installations require the reviewed migration kit, which preserves chain/state paths, payout and limits. Never uninstall/purge to apply this update.

Software qualification:121 backend tests,12 real-node regtest checks, authenticated pruning restart and responsive/theme checks pass. Installed-platform migration is still pending. All app images are digest-pinned.
