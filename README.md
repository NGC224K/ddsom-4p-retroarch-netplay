# D&D Shadow over Mystara 4P RetroArch Netplay

Portable Bazzite and Windows launch/configuration files for four-player *Dungeons & Dragons: Shadow over Mystara* netplay using RetroArch and FinalBurn Neo.

> Unofficial community project. Not affiliated with or endorsed by Capcom, Libretro, RetroArch, or FinalBurn Neo.

## Important

- No ROM, BIOS, encryption key, or other copyrighted game content is included.
- You must supply a legally obtained `ddsom.zip` yourself.
- The package expects the approved ROM SHA-256 documented in [`docs/PROJECT-TECHNICAL-REFERENCE.md`](docs/PROJECT-TECHNICAL-REFERENCE.md).
- RetroArch, FinalBurn Neo, assets, controller profiles, and shader bundles are distributed by their respective projects and remain subject to their own licenses.

## Features

- Either Bazzite or Windows can host or join.
- Host is P1; subsequent connections become P2, P3, and P4.
- Direct TCP netplay on port `55435`.
- Pre-launch ROM verification.
- High-quality ScaleFX shader mode and no-shader compatibility mode.
- Offline Korean first-use guide.
- Controller autoconfiguration support in packaged builds.

## Repository contents

- `bazzite/`: Linux launchers and configuration source
- `windows/`: Windows launchers and configuration source
- `docs/`: user and technical documentation

Large third-party binaries and data bundles are intentionally not committed to Git. Portable builds should be attached separately to GitHub Releases after their third-party license notices have been reviewed.

## Documentation

- [Project technical reference](docs/PROJECT-TECHNICAL-REFERENCE.md)
- [Offline Korean first-use guide](docs/FIRST-USE-GUIDE.html)

## Network summary

- Protocol: TCP
- Port: `55435`
- MITM relay: disabled
- UPnP automatic mapping: disabled
- Router port forwarding may be required for the host.

## Copyright

This repository contains configuration, launch scripts, and original documentation for interoperability and convenience. Game content is not provided. Names and trademarks belong to their respective owners.
