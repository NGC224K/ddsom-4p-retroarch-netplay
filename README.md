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

## 게임을 4인 모드로 설정하기

`ddsom.zip`을 다른 지역판 ROM으로 바꿀 필요는 없습니다. *Shadow over Mystara*의 참가 인원은 게임 내부의 캐비닛 설정에서 정합니다. 새로 설치한 패키지에서는 다음을 확인하세요.

1. 게임 실행 중 `F1`을 눌러 `빠른 메뉴 → 코어 옵션 → Diagnostic Input`에서 진단 메뉴 호출 키를 지정합니다.
2. 게임으로 돌아가 지정한 키를 눌러 게임의 테스트 메뉴를 엽니다.
3. `CONFIGURATION → SYSTEM → CHUTE TYPE`에서 `4 PLAYERS 4 CHUTES MULTI`를 선택합니다. 이 설정은 실제 게임 화면에서 4인용 타이틀 배치가 나타나는 것을 확인했습니다.
4. 게임 테스트 메뉴의 `SAVE & EXIT`로 저장하고 게임을 재시작합니다.

타이틀에 `PRESS START`/`INSERT COIN` 자리가 네 개 보이면 4인 캐비닛 설정이 적용된 것입니다. 다만 **온라인 4인 플레이의 최종 확인**은 P3·P4 참가자가 실제로 캐릭터를 선택하고 조작할 수 있는지까지 시험해야 합니다.

`4 CHUTES MULTI`는 플레이어마다 크레딧을 따로 쓰는 방식입니다. P3·P4 크레딧 입력이 불편하다면 `4 PLAYERS 1 CHUTE SINGLE`(공용 크레딧)도 시험할 수 있습니다. 변경 후에는 다시 `SAVE & EXIT`로 저장하세요. ROM 해시 검사나 `retroarch.cfg`를 수정하는 설정이 아닙니다.

## Network summary

- Protocol: TCP
- Port: `55435`
- MITM relay: disabled
- UPnP automatic mapping: disabled
- Router port forwarding may be required for the host.

## Copyright

This repository contains configuration, launch scripts, and original documentation for interoperability and convenience. Game content is not provided. Names and trademarks belong to their respective owners.
