# Licenses

Quantus Solo by Kraskus is a Kraskus Crypto application. This Store package is recipe-only. It does not mirror third-party source archives; see "quantus-node source" below.

## Components

- **Quantus Solo adapter, node and miner supervisors, UI, package recipe** (Kraskus-owned code):
  - licensed MIT OR Apache-2.0 (owner decision 2026-10-02);
  - the exact scope is in `apps/quantus-solo/LICENSING.md` (Kraskus-Crypto-Apps) and in each image under `/usr/share/doc/kraskus-quantus-solo/`;
  - brand assets are excluded.
- **quantus-node** (node image):
  - built by Kraskus from the unmodified upstream source of Quantus-Network/chain at commit `482c5b9e02bec0adc70797eade0a67f60baf2619` (v1.0.2-Qm);
  - the repository LICENSE is MIT;
  - the linked dependencies include GPL-3.0, GPL-3.0-or-later WITH Classpath-exception-2.0 and MPL-2.0 crates, so the binary is treated as a GPL-3.0 combined work;
  - licence texts, third-party notices and build information are in the image at `/usr/share/doc/quantus-node/`.
- **quantus-miner** v4.2.0 (miner image): Apache-2.0, the unmodified upstream release binary. Licence and notices are at `/usr/share/doc/quantus-miner/`.
- **JavaScript packages compiled into the UI:** notices at `/usr/share/doc/kraskus-quantus-solo-ui/THIRD-PARTY-NOTICES.txt`.
- **shadcn/ui components:** MIT.
- **nginx, Debian, Alpine and Python base images:** see their upstream distributions and image notices.
- **Quantus Q emblem** (hero coin, brand mark, store icon): a Kraskus drawing of the Quantus Network Q mark, used to name the coin this app runs. Trademark permission is pending (release gate F6, open for Main).

## quantus-node source

The Corresponding Source for the shipped quantus-node binary is published by Kraskus at:

**https://github.com/kraskuscrypto/Quantus-Source-Mirror** (release `quantus-solo-v0.1.0`)

It contains:

- the chain source at the commit above;
- every vendored Rust dependency;
- the Kraskus build recipe;
- the licence texts and notices;
- `SOURCE.md`, which maps each published image digest to its source.

Everything is covered by `SHA256SUMS`, signed with the Kraskus release key `78A44DE8F12BE5F68FDAA493C5AF5FF3489EDF25` (public key in the repository root). The same node binary and image are used in 0.1.0 and 0.1.1. The `SOURCE.md` inside the node image was written before the mirror existed. The mirror is the authoritative source location.
