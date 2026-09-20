z�謺v)�++��B�y�rا��,��^���
��vz-r��y�N��ڶ*'��iz���ם# D&D Shadow over Mystara 4인 온라인 패키지

## 프로젝트 기술 명세·운영·유지보수 문서

- 문서 기준일: 2026-09-21
- 대상 게임: Dungeons & Dragons: Shadow over Mystara (`ddsom`)
- 에뮬레이션 구성: RetroArch + FinalBurn Neo libretro core
- 지원 배포판: Bazzite x86_64, Windows x86_64
- 네트플레이 규모: 방장 1명 + 참가자 최대 3명, 총 4명
- 배포 원칙: ROM과 BIOS 등 저작권 콘텐츠는 포함하지 않는다.

이 문서는 최종 배포판의 설계, 구성, 실행 흐름, 고정값, 운영 절차와 유지보수 규칙을 한곳에 정리한 프로젝트 기준 문서다. 최종 사용자용 간단한 사용법은 Windows 패키지의 `FIRST-USE-GUIDE.html`을 우선한다.

---

## 1. 프로젝트 목표

사용자가 운영체제에 관계없이 동일한 `ddsom.zip`을 준비한 뒤 하나의 실행 메뉴에서 다음 역할을 선택할 수 있게 한다.

1. 직접 방을 만드는 HOST
2. 다른 사람의 방에 들어가는 JOIN
3. 셰이더를 적용하는 고화질 모드
4. 셰이더를 사용하지 않는 그래픽 호환 모드

HOST를 선택한 기기가 항상 P1이다. 이후 접속 순서대로 P2, P3, P4가 배정된다. Bazzite와 Windows 모두 HOST와 JOIN 역할을 수행할 수 있다.

---

## 2. 최종 배포 파일

| 배포 파일 | 용도 |
|---|---|
| `DND-SOM-4P-Bazzite-Final.tar.gz` | Bazzite용 휴대형 패키지 |
| `DND-SOM-4P-Windows-Portable-Final.zip` | Windows용 휴대형 패키지 |
| `FIRST-USE-GUIDE.html` | 인터넷 없이 열 수 있는 한국어 초보자 설명서의 별도 사본 |
| `SHA256SUMS-Final.txt` | 최종 산출물 무결성 검사값 |
| `OWNER-TROUBLESHOOTING-NOTES.txt` | 소유자용 간단 메모 |
| `PROJECT-TECHNICAL-REFERENCE.md` | 본 프로젝트 전체 기술 문서 |

최종 패키지 내부의 파일명과 경로는 운영체제·압축 프로그램·문자 인코딩 차이로 인한 문제를 줄이기 위해 ASCII 영문으로 통일한다. 사용자에게 표시되는 안내 문구와 HTML 설명서 본문은 한국어다.

---

## 3. 고정 소프트웨어 버전

### 공통

- RetroArch: 1.22.2, Git `69a4f0e`
- FinalBurn Neo: 공식 x86_64 libretro nightly, 2026-09-21 취득본
- 메뉴 드라이버: Ozone
- 비디오 드라이버: Vulkan
- Netplay 전송 포트: TCP 55435

### Bazzite

- 실행 형식: Linux x86_64 AppImage
- AppImage SHA-256: `794b0f65d4efa918e2ad05cac34b444a4f3207ed6c74834b7c14eb5fb15e1cc4`
- `fbneo_libretro.so` SHA-256: `a154a08d0f97ff1c66e6ec22a5c209854f31eb2ed7d831b2cb4c0101d48a2448`
- 조이패드 드라이버: SDL2

### Windows

- 실행 형식: Windows x86_64 portable
- `retroarch.exe` SHA-256: `81c11b6f24932bf7918f05eee8928035bff3887335fd2a081507c75e9d94d06a`
- `fbneo_libretro.dll` SHA-256: `0a92f3b61dba68b34df0a93afe1b24b98debb3c25dfe63bf21c02034fdfa1179`
- 조이패드 드라이버: DirectInput

RetroArch와 FBNeo 버전을 한쪽만 교체하면 Netplay 호환성이 깨질 수 있으므로 두 운영체제의 실행 파일과 코어는 한 세트로 관리한다.

---

## 4. ROM 기준과 검증 정책

### 승인된 ROM

- 파일명: `ddsom.zip`
- 설치 위치: `roms/ddsom.zip`
- 전체 SHA-256: `3a6ee47309fa049ea2f99bee7b90c223043acd081ea296e215a42b800882b385`
- ZIP 내부 필수 항목: `ddsom.key`
- `ddsom.key` CRC-32: `541e425d`
- 별도 CPS-2 BIOS: 필요 없음

`ddsom.key`는 별도 BIOS가 아니라 현재 FBNeo용 `ddsom` ROM 세트의 구성 요소다. ROM ZIP은 압축을 풀지 않고 그대로 `roms` 폴더에 넣는다.

### 실행 전 검증

Bazzite HOST/JOIN 스크립트는 다음 순서로 검사한다.

1. `roms/ddsom.zip` 존재 여부
2. ZIP 내부 `ddsom.key` 존재 여부
3. `ddsom.key`의 CRC-32
4. ROM 전체 SHA-256
5. `config/expected-rom-sha256.txt`의 기준값과 일치 여부

Windows는 `CHECK-ROM.cmd`에서 ROM 존재 여부, `ddsom.key` 존재 여부와 전체 SHA-256을 검사한다. 전체 SHA-256이 승인값과 일치하면 내부 파일도 승인된 세트와 동일한 것으로 판정한다.

ROM이 일치하지 않으면 안전하게 실행을 중단한다. 파일명만 같은 다른 ROM 세트는 허용하지 않는다.

### 관리 도구

- `REGISTER-ROM.sh`: Bazzite ROM의 SHA-256을 기준 파일에 등록한다.
- `SET-WINDOWS-ROM-HASH.sh`: 같은 기준값을 Bazzite와 Windows 패키지 양쪽에 기록한다.
- `CHECK-ROM.cmd`: Windows에서 현재 ROM을 기준값과 비교한다.

최종 배포본에는 승인 해시가 이미 기록되어 있다.

---

## 5. Netplay 설계

### 연결 모델

```text
HOST = P1
  ├─ 첫 번째 JOIN = P2
  ├─ 두 번째 JOIN = P3
  └─ 세 번째 JOIN = P4
```

- 직접 접속 방식
- TCP 55435 사용
- 최대 외부 연결 수: 3
- 총 플레이어 수: HOST 포함 4
- RetroArch MITM 릴레이: 사용 안 함
- UPnP/NAT 자동 포트 매핑: 사용 안 함
- 공개 방 목록 등록: 사용 안 함
- 요청 장치 고정: P1~P4 모두 사용 안 함

주요 설정값은 다음과 같다.

```ini
netplay_ip_port = "55435"
netplay_use_mitm_server = "false"
netplay_nat_traversal = "false"
netplay_max_connections = "3"
netplay_public_announce = "false"
netplay_allow_slaves = "false"
netplay_request_device_p1 = "false"
netplay_request_device_p2 = "false"
netplay_request_device_p3 = "false"
netplay_request_device_p4 = "false"
```

`netplay_max_connections = 3`은 3인 게임이라는 의미가 아니다. HOST를 제외한 외부 접속자 수가 최대 3명이므로 총 4인 구성이다.

### HOST 네트워크 조건

- 공유기 외부 TCP 55435를 HOST PC의 내부 IPv4 TCP 55435로 전달한다.
- 운영체제 방화벽에서 TCP 55435를 허용한다.
- 외부 포트 검사는 HOST 게임이 실행되어 실제로 포트를 수신 중일 때 수행한다.
- 같은 공유기 내부 참가자는 HOST의 내부 IP를 사용할 수 있다.
- 인터넷 참가자는 HOST의 공인 IPv4 또는 해당 주소를 가리키는 도메인을 사용한다.

HOST 실행기는 `api.ipify.org`를 통해 공인 IPv4를 확인하고 화면에 TCP 포트와 함께 표시한다. 조회 실패가 게임 실행을 막지는 않는다.

### Bazzite 연결 점검

`CHECK-CONNECTION.sh`는 다음 항목을 확인한다.

1. 내부 IP 주소
2. 공인 IPv4
3. TCP 55435 수신 여부
4. firewalld의 55435/tcp 허용 여부
5. 사용자가 동의하면 `portcheck.ing` 검사 페이지 열기

외부 IP는 친구에게 개인적으로만 전달한다.

---

## 6. 그래픽 설계

### 공통 기본값

```ini
video_driver = "vulkan"
video_fullscreen = "false"
video_windowed_fullscreen = "true"
video_aspect_ratio_auto = "true"
video_vsync = "true"
video_smooth = "false"
```

- 게임 원본의 4:3 비율을 보존한다.
- 기본 시작은 창 모드다.
- 선형 보간은 끄고 셰이더가 화면 확대와 가장자리 처리를 담당한다.

### 고화질 모드

- Bazzite 프리셋: `scalefx-aa-fast.slangp`
- Windows 프리셋: `scalefx+rAA+aa.slangp`

고화질 실행 시 실행기가 `retroarch.cfg`의 셰이더 상태와 현재 패키지의 절대경로를 갱신한다. 실제 프리셋 적용은 RetroArch 공식 명령행 옵션인 `--set-shader`를 사용하며, 이 옵션을 코어의 `-L` 및 ROM 경로보다 앞에 전달한다.

### 그래픽 호환 모드

- `video_shader_enable = "false"`
- `video_shader = ""`
- `--set-shader=""`

직전 실행이나 수동 설정과 관계없이 셰이더를 명시적으로 해제한다. Vulkan 자체가 지원되지 않는 Windows 환경은 그래픽 드라이버 설치 상태를 먼저 점검해야 한다.

### 모드 설정 구현

Bazzite의 `SET-VIDEO-MODE.sh`와 Windows 실행기의 `set_video_high`/`set_video_compat` 루틴은 기존 `video_shader` 관련 줄을 제거한 뒤 선택한 모드의 값을 기록한다. 임시 파일을 만든 후 원래 설정 파일과 교체하여 부분 기록을 방지한다.

셰이더는 화면 출력만 바꾸므로 정상적인 속도를 유지하는 한 Netplay 게임 상태에는 영향을 주지 않는다. 프레임 저하나 검은 화면이 발생하면 모든 참가자가 아니라 문제가 있는 PC만 그래픽 호환 모드를 사용해도 된다.

---

## 7. 입력 장치와 조작

### 공통

- 자동 입력 감지: 활성화
- 최대 사용자 수: 4
- 메뉴 호출: `F1`
- 전체화면 전환: `F`
- 종료: `Esc`

### Windows 기본 키보드 게임 조작

| 동작 | 키 |
|---|---|
| 이동 | 방향키 |
| 공격 | `Z` |
| 점프 | `X` |
| 아이템 선택 | `A` |
| 아이템 사용 | `S` |
| 코인/Select | 오른쪽 `Shift` |
| Start | `Enter` |

### 컨트롤러

공식 RetroArch autoconfig 프로필을 패키지에 포함한다.

- Bazzite: SDL2 프로필과 `input_joypad_driver = "sdl2"`
- Windows: DirectInput을 기본으로 하며 dinput, hid, sdl2, xinput 프로필 포함
- Xbox, PlayStation, 일반 USB 패드는 자동 감지를 우선한다.
- 자동 인식되지 않으면 `Settings → Input → RetroPad Binds → Port 1 Controls`에서 장치를 선택하고 전체 버튼을 매핑한다.
- 컨트롤러별 매핑은 `Save Controller Profile`로 저장한다.

권바 드론은 Bazzite에서 PS3 모드를 사용한다.

### 사용자 설정 저장

패드, 키, 음량 등 사용자가 유지할 설정을 변경한 뒤에는 다음 메뉴를 실행한다.

`Main Menu → Configuration File → Save Current Configuration`

자동 종료 저장은 비활성화되어 있으므로 명시적으로 저장해야 한다. Netplay, Core, Drivers 등 패키지 호환성에 영향을 주는 설정은 변경하지 않는다.

---

## 8. 동기화 안전 설정

다음 기능은 Netplay 중 비활성화하거나 사용하지 않는다.

- Run-Ahead
- Rewind
- Save State / Load State
- Cheats
- Fast Forward
- 코어 교체 또는 업데이트
- Core Options 및 DIP Switch의 임의 변경
- Netplay Request Device 1~4 변경

관련 기본값:

```ini
rewind_enable = "false"
run_ahead_enabled = "false"
pause_nonactive = "false"
save_on_exit = "false"
config_save_on_exit = "false"
```

---

## 9. Bazzite 패키지 구조와 실행 흐름

### 주요 파일

| 파일 | 역할 |
|---|---|
| `DND-START.sh` | 통합 시작 메뉴 |
| `HOST-DND.sh` | HOST 검증 및 실행 |
| `JOIN-DND.sh` | JOIN 검증 및 실행 |
| `HOST-NO-SHADER.sh` | HOST 호환 모드 바로 실행 |
| `JOIN-NO-SHADER.sh` | JOIN 호환 모드 바로 실행 |
| `SET-VIDEO-MODE.sh` | 고화질/호환 모드에 맞게 설정 갱신 |
| `CHECK-CONNECTION.sh` | IP, 수신 포트, 방화벽 점검 |
| `REGISTER-ROM.sh` | ROM 기준 해시 등록 |
| `SET-WINDOWS-ROM-HASH.sh` | Windows 패키지에 같은 해시 전달 |
| `RetroArch-Linux-x86_64.AppImage` | 고정 RetroArch 실행 파일 |
| `cores/fbneo_libretro.so` | 고정 FBNeo 코어 |
| `config/retroarch.cfg` | 패키지 전용 설정 |
| `config/expected-rom-sha256.txt` | 승인 ROM 해시 |
| `assets/` | Ozone 아이콘, 기호와 커서 리소스 |
| `autoconfig/` | 공식 조이패드 자동 설정 |
| `shaders/` | 셰이더와 프리셋 |
| `logs/last-host.log` | 최근 HOST 로그 |
| `logs/last-join.log` | 최근 JOIN 로그 |

### 메뉴

```text
[1] 방 만들기 (HOST / 고화질)
[2] 방 참가 (JOIN / 고화질)
[3] 접속 상태 점검
[4] 방 만들기 (그래픽 호환 모드)
[5] 방 참가 (그래픽 호환 모드)
[6] RetroArch 강제 종료
[0] 닫기
```

강제 종료는 우선 TERM 신호를 보내고, 1초 뒤 남은 해당 패키지의 RetroArch/FBNeo 프로세스에 KILL 신호를 보낸다.

AppImage는 `APPIMAGE_EXTRACT_AND_RUN=1`로 실행한다. Ozone 리소스는 `LIBRETRO_ASSETS_DIRECTORY`에 패키지 내부 절대경로를 전달한다.

---

## 10. Windows 패키지 구조와 실행 흐름

### 주요 파일

| 파일 | 역할 |
|---|---|
| `DND-START.bat` | 사용자 진입점 |
| `START-DND.cmd` | 통합 메뉴와 HOST/JOIN 실행 로직 |
| `CHECK-ROM.cmd` | ROM 사전 검사 |
| `OPEN-GUIDE.bat` | HTML 설명서 열기 |
| `FIRST-USE-GUIDE.html` | 오프라인 한국어 초보자 설명서 |
| `retroarch.exe` | 고정 RetroArch 실행 파일 |
| `cores/fbneo_libretro.dll` | 고정 FBNeo 코어 |
| `config/retroarch.cfg` | 패키지 전용 설정 |
| `config/expected-rom-sha256.txt` | 승인 ROM 해시 |

### 메뉴

```text
[1] 방 참가 (JOIN / 고화질)
[2] 방 만들기 (HOST / 고화질)
[3] 처음사용설명서 열기
[4] ROM 검사
[5] RetroArch만 열기 (패드/키 설정)
[6] 방 참가 (그래픽 호환 모드)
[7] 방 만들기 (그래픽 호환 모드)
[8] RetroArch 강제 종료
[0] 닫기
```

Windows 강제 종료는 `taskkill /IM retroarch.exe /T /F`로 RetroArch 프로세스 트리를 종료한다.

---

## 11. 로그와 진단

실행기는 상세 로그를 활성화한다.

- HOST: `logs/last-host.log`
- JOIN: `logs/last-join.log`

확인 우선순위:

1. ROM SHA-256 통과 여부
2. FBNeo 코어 로드 여부
3. `ddsom` 드라이버 초기화 여부
4. Vulkan GPU 선택 여부
5. 고화질 모드의 Slang 셰이더 컴파일 및 적용 여부
6. HOST의 TCP 55435 수신 여부
7. JOIN의 연결 대상 주소와 포트
8. 조이패드 autoconfig 적용 여부

로그를 공유할 때 공인 IP, 내부 IP, 사용자명과 로컬 경로가 포함될 수 있으므로 외부 공개 전에 확인한다.

---

## 12. 최종 사용자 문서 정책

`FIRST-USE-GUIDE.html`은 다음 조건을 만족한다.

- 한국어
- 큰 글씨와 단계별 번호 사용
- 경고·팁·정상 안내 상자 사용
- 외부 CDN, 웹폰트, 이미지 서버에 의존하지 않음
- 인터넷 없이 로컬에서 열림
- 실제 실행 메뉴를 단순화한 자체 화면 도식 포함
- ROM 설치, HOST/JOIN, 영상, 키보드, 패드, 플레이어 순서, 음량, 종료, 문제 해결, 변경 금지 설정 설명
- 설정 변경 후 `Save Current Configuration` 실행 안내
- Windows 메뉴의 강제 종료 기능 안내

기술 이력이나 개발 과정은 최종 사용자 설명서에 넣지 않는다. 이 문서와 소유자용 메모에만 유지보수 정보를 둔다.

---

## 13. 보안·개인정보·저작권 원칙

- ROM, BIOS, 복호화 키 파일을 배포 패키지에 포함하지 않는다.
- 사용자는 합법적으로 보유한 ROM을 직접 준비한다.
- 공인 IP는 함께 플레이할 사람에게만 전달한다.
- Windows 방화벽은 일반적으로 개인 네트워크만 허용한다.
- 포트 전달 대상은 현재 HOST PC의 내부 IP로 제한한다.
- 외부 포트 검사는 HOST 실행 중에만 실시한다.
- 패키지는 공개 방 목록과 MITM 릴레이를 사용하지 않는다.

---

## 14. 유지보수 규칙

### 변경 시 반드시 함께 갱신할 항목

RetroArch 또는 FBNeo를 교체할 때:

1. Bazzite와 Windows 양쪽 버전을 함께 맞춘다.
2. 실행 파일 및 코어 SHA-256을 다시 계산한다.
3. `PACKAGE-VERSIONS.txt`를 갱신한다.
4. 동일 ROM으로 양쪽 사전 검사를 실행한다.
5. HOST/JOIN 교차 연결을 확인한다.
6. 셰이더 프리셋의 모든 참조 파일이 존재하는지 확인한다.
7. 컨트롤러 autoconfig 호환성을 확인한다.
8. 최종 압축본과 `SHA256SUMS-Final.txt`를 다시 만든다.

ROM 기준을 변경할 때:

1. 새 ROM의 출처와 합법적 보유 여부를 확인한다.
2. FBNeo가 요구하는 내부 파일이 모두 있는지 확인한다.
3. Bazzite에서 기준 SHA-256을 등록한다.
4. Windows 패키지에도 같은 값을 기록한다.
5. 기존 사용자에게 ROM 기준 변경을 명확히 알린다.

스크립트를 변경할 때:

1. 패키지 내부 경로는 영문 ASCII를 유지한다.
2. 항상 스크립트 자신의 디렉터리로 이동한 후 상대경로를 사용한다.
3. ROM 검사를 통과하기 전에는 RetroArch를 실행하지 않는다.
4. 셰이더 옵션은 `-L`과 ROM 경로보다 앞에 둔다.
5. 호환 모드는 빈 셰이더를 명시적으로 전달한다.
6. HOST와 JOIN 양쪽에 같은 변경을 적용한다.
7. 로그 경로가 존재하도록 실행 전에 생성한다.

---

## 15. 출시 전 검증 체크리스트

- [ ] 패키지 내부에 `ddsom.zip`, `.key`, BIOS 파일이 없다.
- [ ] 패키지 내부 파일명과 경로가 ASCII 영문이다.
- [ ] Bazzite 셸 스크립트 문법 검사를 통과한다.
- [ ] Bazzite 실행 파일에 실행 권한이 있다.
- [ ] Windows ZIP 무결성 검사를 통과한다.
- [ ] Bazzite tar.gz 무결성 검사를 통과한다.
- [ ] RetroArch와 FBNeo 버전이 양쪽에서 일치한다.
- [ ] 승인 ROM SHA-256이 양쪽 패키지에서 같다.
- [ ] HOST와 JOIN 모두 ROM 불일치를 차단한다.
- [ ] HOST가 TCP 55435를 수신한다.
- [ ] HOST 공인 IPv4 안내가 표시된다.
- [ ] P1/P2/P3/P4 순서가 정상이다.
- [ ] 고화질 모드에서 지정 셰이더가 적용된다.
- [ ] 호환 모드에서 셰이더가 해제된다.
- [ ] Ozone 아이콘, 버튼 기호와 커서가 정상 표시된다.
- [ ] 주요 Xbox, PlayStation, 일반 USB 패드 자동 감지가 동작한다.
- [ ] 강제 종료 메뉴가 동작한다.
- [ ] HTML 설명서가 인터넷 없이 열린다.
- [ ] HTML 설명서에 외부 URL 리소스 의존성이 없다.
- [ ] 최종 압축본 SHA-256을 다시 기록한다.

---

## 16. 확정된 운영 기준 요약

| 항목 | 확정값 |
|---|---|
| 게임 | D&D Shadow over Mystara |
| ROM 파일 | `roms/ddsom.zip` |
| 별도 BIOS | 없음 |
| RetroArch | 1.22.2 |
| 코어 | FinalBurn Neo 고정본 |
| 비디오 | Vulkan |
| 고화질 셰이더 | ScaleFX 계열 Slang 프리셋 |
| 화면비율 | 자동, 원본 4:3 보존 |
| 네트플레이 | 공인 IPv4 직접 접속 |
| 포트 | TCP 55435 |
| 릴레이 | 사용 안 함 |
| UPnP | 사용 안 함 |
| 총 인원 | HOST 포함 4명 |
| 역할 | HOST=P1, 접속 순서대로 P2~P4 |
| Bazzite 패드 드라이버 | SDL2 |
| Windows 패드 드라이버 | DirectInput |
| 사용자 문서 | 오프라인 한국어 HTML |
| 패키지 내부 파일명 | ASCII 영문 |
| 저작권 콘텐츠 | 미포함 |

이 표와 본문의 고정값이 최종 배포판의 기준선이다.
