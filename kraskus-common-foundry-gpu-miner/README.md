# Common Foundry GPU Miner (kraskus-common-foundry-gpu-miner) 0.1.3 — Dev Store

Mines Common Foundry on a supported NVIDIA GPU with the official Common Foundry v1.0.8 miner, unmodified, behind the Kraskus interface (top-left label **CMFD Kraskus**).

**Dev testing release. Not a Main release.**

## Before you install: host requirements

This app needs an NVIDIA GPU host prepared by the operator. 5tratumOS does not provide GPU support itself, and the app never installs or changes host components.

- **NVIDIA driver:** open kernel modules. Blackwell (RTX 50-series) needs driver 570 or newer; qualified with 615.71.09.
- **NVIDIA Container Toolkit:** with the Docker runtime configured (`nvidia-ctk runtime configure --runtime=docker`).
- **Power limit (optional):** if you cap the GPU's power, use a boot-time service. `nvidia-smi -pl` alone resets on every reboot.

Without the NVIDIA runtime the miner cannot start. Docker reports `could not select device driver "nvidia"`.

## What it does

- **Model bank:** downloads its own copy of the 6.4 GB ForgeMatrix model bank from the official Common Foundry sources and checks it against the pinned SHA-256.
- **Pool mining only.** You choose the pool (the official pool address is `cmfd+tls://…?pin=…`, as published by Common Foundry), a worker name and the Common Foundry address that receives payouts. The payout is checked by typing back its last 8 characters.
- **No wallet:** it holds no wallet, keys or passphrase. Start, Stop and all settings need no passphrase. It works with or without the Common Foundry node app.
- **Mining never starts on its own.** Diagnostics are collapsed by default.

| Service | Published |
|---|---|
| UI | 33077 (via app_proxy) |

No inbound ports, no telemetry, no developer fee.
