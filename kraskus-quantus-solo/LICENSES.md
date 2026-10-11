# Licenses

Quantus Solo by Kraskus is a Kraskus Crypto application. This Store package is recipe-only. It does not mirror third-party source archives; see "quantus-node source" below.

## Components

- **Quantus Solo adapter, node and miner supervisors, UI, package recipe** (Kraskus-owned code):
  - licensed MIT OR Apache-2.0 (owner decision 2026-10-02);
  - the exact scope is in `apps/quantus-solo/LICENSING.md` (Kraskus-Mining-Platform for the 0.3.0 adapter, UI and node recipe; Kraskus-Crypto-Apps for the 0.1.0 miner supervisor) and in the adapter image under `/usr/share/doc/kraskus-quantus-solo/`;
  - the vendored Kraskus foundation (Python package and shared V3 UI) is Kraskus code vendored from Kraskus-Mining-Platform `foundation/`;
  - brand assets are excluded.
- **quantus-node** (node image):
  - Kraskus Quantus Solo uses the official Quantus node source as its base. Kraskus applies a disclosed developer-fee modification to block-template reward selection. The miner remains unmodified.
  - built by Kraskus from the official upstream source of Quantus-Network/chain at commit `482c5b9e02bec0adc70797eade0a67f60baf2619` (v1.0.2-Qm) plus the Kraskus patch `0001-kraskus-dev-fee.patch`. The patch changes `client/consensus/qpow/src/lib.rs` (block-template reward selection: 1 block height in 100 pays the Kraskus developer reward identity) and `node/build.rs` (version string `1.0.2-Qm-482c5b9e02b-kraskus-devfee1`). It is a **modified work**; the modification notice (GPLv3 §5(a), Apache-2.0 §4(b)) is `KRASKUS-MODIFICATIONS.md` in the image at `/usr/share/doc/quantus-node/`;
  - Kraskus Quantus Solo includes a 1% developer fee. One out of every 100 block heights is assigned to the Kraskus developer reward identity; all other heights use your configured reward identity. Because solo mining rewards depend on when blocks are actually found, your realized fee percentage over a short period may differ from 1%.
  - binary sha256 `24e28fd8e84b3e3b5bdd33d63bc61e6ab0b703275d5283bbf6389fadfd2859a3`; node image `sha256:4d0706016b544f511e3d37eb05a09042625d885297dc52ba8b6d5152a6f3f5cd`;
  - the repository LICENSE is MIT;
  - the linked dependencies include GPL-3.0, GPL-3.0-or-later WITH Classpath-exception-2.0 and MPL-2.0 crates, so the binary is treated as a GPL-3.0 combined work;
  - licence texts, third-party notices and build information are in the image at `/usr/share/doc/quantus-node/`.
- **quantus-miner** v4.2.0 (miner image): Apache-2.0, the unmodified upstream release binary (the miner remains unmodified). Licence and notices are at `/usr/share/doc/quantus-miner/`.
- **JavaScript packages compiled into the UI:** notices at `/usr/share/doc/kraskus-quantus-solo-ui/THIRD-PARTY-NOTICES.txt`.
- **shadcn/ui components:** MIT.
- **nginx, Debian, Alpine and Python base images:** see their upstream distributions and image notices.
- **Quantus Q emblem** (hero coin, brand mark, store icon): a Kraskus drawing of the Quantus Network Q mark, used to name the coin this app runs. Trademark permission is pending (release gate F6, open for Main).

## quantus-node source

The Corresponding Source for the shipped quantus-node binary is published by Kraskus at:

**https://github.com/kraskuscrypto/Quantus-Source-Mirror**

- **Dev-fee node (0.3.0): release `quantus-solo-v0.3.0`.** It holds the same unchanged upstream source and vendor archives as 0.1.0 (identical sha256), plus `0001-kraskus-dev-fee.patch`, `KRASKUS-MODIFICATIONS.md`, the build recipe, `SOURCE.md` and `MANIFEST.json`. Published and signed (key `78A44DE8F12BE5F68FDAA493C5AF5FF3489EDF25`) on 2026-10-11, before the dev-fee node image was pushed.
- **Unmodified 0.1.0 node image** (Quantus Solo 0.1.0 and 0.1.1): release `quantus-solo-v0.1.0`.

Each release contains:

- the chain source at the commit above;
- every vendored Rust dependency;
- the Kraskus build recipe and, for 0.3.0, the patch;
- the licence texts and notices;
- `SOURCE.md`, which maps each published image digest to its source.

Everything is covered by `SHA256SUMS`, signed with the Kraskus release key `78A44DE8F12BE5F68FDAA493C5AF5FF3489EDF25` (public key in the repository root). The mirror is the authoritative source location.
