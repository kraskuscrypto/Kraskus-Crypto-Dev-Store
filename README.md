# Kraskus App Store for 5tratumOS

A custom 5tratStore repository maintained by Kraskus.

## Compatibility setup

For older 5tratumOS hosts that still need the custom-channel compatibility repair, use the qualified terminal fallback documented in COMPATIBILITY-SETUP.md. The one-time Compatibility app is no longer distributed in this store.

## Current apps

### Kraskus ZEC Solo

Runs a Zebra-backed Zcash full node and local solo-mining service with a Kraskus-branded interface. Normal users configure their payout address and miner connection without managing Zebra, RPC, Docker, Linux, JSON, or Stratum internals.

### Kraskus XMR Solo

Runs a Monero full node, local wallet, and restricted direct-daemon true solo-mining appliance with the Kraskus Solo interface. Blockchain, wallet, and runtime state persist in native 5tratumOS app storage. The app uses the approved Divinity XMR emblem and exposes only Monero P2P plus the dedicated miner endpoint required for solo mining.

### MystNodes by Kraskus

Runs the official Mysterium node container with a MystNodes-style 5tratumOS launcher.

New MystNodes users are directed through this disclosed Kraskus referral URL:

`https://mystnodes.co/?referral_code=CJSoelVnKkllilXIgv7JqeroUv1jhnZ4KWE4G6E4`

Existing MystNodes users can skip new-account signup and connect their own API key.

## Repository layout

```text
Kraskus-Crypto-Store/
├── COMPATIBILITY-SETUP.md
├── umbrel-app-store.yml
├── README.md
├── kraskus-zec-solo/
├── kraskus-xmr-solo/
├── mysterium-node/
└── scripts/
    ├── install-kraskus-compat.sh
    ├── fix-5tratumos-dynamic-custom-channels.sh
    ├── new-app.sh
    ├── pin-images.sh
    ├── validate-compose.sh
    └── validate_store.py
```

## Before publishing

Run `scripts/pin-images.sh` on a Docker host. It resolves immutable RepoDigests
for the official Mysterium and nginx images and writes them into
`mysterium-node/docker-compose.yml`.

Do not publish a recipe containing `__MYST_IMAGE__` or `__PORTAL_IMAGE__`.

---

## Kraskus Reference App SDK

This store includes a small local SDK for creating consistent 5tratStore apps.

Create a new application skeleton:

```bash
scripts/new-app.sh my-app
```

Validate the entire store:

```bash
python3 scripts/validate_store.py
```

Validate a single app's Docker Compose recipe:

```bash
scripts/validate-compose.sh mysterium-node
```

See `REFERENCE-APP-STANDARD.md` for the packaging, security, provenance, and
onboarding standard used by Kraskus apps.
