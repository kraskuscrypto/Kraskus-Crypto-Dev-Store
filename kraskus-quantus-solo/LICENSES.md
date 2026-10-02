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

The Corresponding Source for the shipped quantus-node binary (the chain source at the commit above plus the vendored crate sources) is prepared by Kraskus. It will be published in `kraskuscrypto/Quantus-Source-Mirror` before any Main release (release gate G5a).

During Dev testing, the exact upstream source is available at https://github.com/Quantus-Network/chain/tree/482c5b9e02bec0adc70797eade0a67f60baf2619
