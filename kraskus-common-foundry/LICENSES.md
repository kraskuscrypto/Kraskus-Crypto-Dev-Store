# Licenses

Common Foundry (CMFD Kraskus) is a Kraskus Crypto application.

Runtime components:

- **Kraskus adapter, supervisors and UI:** Kraskus project licence.
- **Common Foundry `cmfd-node`, `cmfd-miner`, `cmfd-v4-replay`:** official, unmodified binaries from the signed Common Foundry release named in the image label `ai.commonfoundry.profile`. MIT License, "Copyright (c) 2026 CommonFoundry contributors". The licence text is shipped in each image at `/usr/share/doc/common-foundry/LICENSE`.
- **NVIDIA CUTLASS headers** (compiled into the official CUDA worker): BSD-3-Clause. The notice is at `/usr/share/doc/common-foundry/THIRD_PARTY_NOTICES.md`.
- **ForgeMatrix model bank and proving inputs:** downloaded at runtime from the official Common Foundry sources (`downloads.commonfoundry.ai`, with the GitHub release as fallback) and SHA-256 authenticated. They are never included in any Kraskus image or in this package.
- **Base images:** Python and Debian (image `org.opencontainers.image.base.name`), nginx and Node for the UI. See their upstream distributions.

This store package is recipe-only and does not mirror third-party archives.
