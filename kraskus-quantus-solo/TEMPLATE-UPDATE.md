# Quantus 0.4.0 template update

Shared six-page UI, true light/dark and Quantus amber/violet/silver themes, appearance preferences, fixed original face and matching header emblem, graph and Copy controls. External wormhole address and matching inner hash remain validated by the unchanged adapter. Credentials remain masked until explicitly revealed; token reveal, rotation and certificate regeneration retain their existing authorization rules. The optional local CPU miner remains off by default.

Quantus uses authenticated LAN-only QUIC, not Stratum. The connection panel preserves IP, token-file and certificate-pin instructions. Solutions are distinct from shares: unsupported best-share statistics are explicitly unavailable. No invented mining pause switch is offered; the node manages the endpoint. Do not forward UDP1935 to the internet.

The approved height-based developer fee is unchanged (height modulo100 equals0). The node, adapter/init and miner images, data mounts and credential paths are unchanged. This release changes only the web image. Existing users retain configured identities; fresh catalog installs stay unconfigured. Only the owner's separate VM100 migration may use the developer identity when missing, without starting services.

Checks: 18 responsive page checks; six themes; fixed original face/header match; endpoint Copy and masked token Copy; actual bind-source container creation/init; exact-image web serving and anonymous digest pull. These checks do not newly clear existing Main-store legal/artwork gates or claim a hardware mining test.

## Live phone layout follow-up — 0.4.1

Long live node-sync labels and setup actions wrap at320px. Verified on all six pages against the running APIs at1280/375/320px; zero browser errors. Web image only; nodes and mining controls unchanged.
