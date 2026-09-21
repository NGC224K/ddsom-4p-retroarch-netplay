# D&D Shadow over Mystara 4P RetroArch Netplay

한국어 사용자를 위한 *Dungeons & Dragons: Shadow over Mystara* 4인 RetroArch + FinalBurn Neo 온라인 플레이 포터블 설정입니다. Bazzite와 Windows 패키지를 제공합니다.

Korean-language portable setup for four-player *Dungeons & Dragons: Shadow over Mystara* netplay on Bazzite and Windows.

> Unofficial community project. Not affiliated with or endorsed by Capcom, Libretro, RetroArch, or FinalBurn Neo.

## Important

- No ROM, BIOS, encryption key, or other copyrighted game content is included.
- You must supply a legally obtained `ddsom.zip` yourself.
- The package expects the approved ROM SHA-256 documented in [`docs/PROJECT-TECHNICAL-REFERENCE.md`](docs/PROJECT-TECHNICAL-REFERENCE.md).
- RetroArch, FinalBurn Neo, assets, controller profiles, and shader bundles are distributed by their respective projects and remain subject to their own licenses.
- Redistribution details, upstream source links, and third-party notices are listed in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md).

## Features

- Either Bazzite or Windows can host or join.
- Host is P1; subsequent connections become P2, P3, and P4.
- Direct TCP netplay on port `55435`.
- Pre-launch ROM verification.
- High-quality ScaleFX shader mode and no-shader compatibility mode.
- Offline Korean first-use guide.
- Controller autoconfiguration support in packaged builds.

## Windows test status

The Korean Windows launcher patch uses CP949-encoded, CRLF-terminated batch
files. A Windows user confirmed that JOIN, game display, the default shader,
and controls work with this patch. Windows HOST has not yet been tested by
that user. Bazzite behavior is unchanged.

## Repository contents

- `bazzite/`: Linux launchers and configuration source
- `windows/`: Windows launchers and configuration source
- `docs/`: user and technical documentation

Large third-party binaries and data bundles are intentionally not committed to Git. Portable builds should be attached separately to GitHub Releases after their third-party license notices have been reviewed.

## Documentation

- [Project technical reference](docs/PROJECT-TECHNICAL-REFERENCE.md)
- [Offline Korean first-use guide](docs/FIRST-USE-GUIDE.html)
- [Third-party software and data notices](THIRD-PARTY-NOTICES.md)

## Network summary

- Protocol: TCP
- Port: `55435`
- MITM relay: disabled
- UPnP automatic mapping: disabled
- Router port forwarding may be required for the host.

## Copyright

This repository contains configuration, launch scripts, and original documentation for interoperability and convenience. Game content is not provided. Names and trademarks belong to their respective owners.
