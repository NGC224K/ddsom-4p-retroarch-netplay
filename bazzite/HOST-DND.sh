z�謺v)�++��B�y�rا��,��^���
��vz-r��y�N��ڶ*'��iz���ם#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"
rom="roms/ddsom.zip"
if [[ ! -f "$rom" ]]; then
  echo "[오류] roms/ddsom.zip이 없습니다. 압축을 풀지 않은 파일을 넣어 주세요."
  read -r -p "Enter를 누르면 닫힙니다."
  exit 2
fi
key_crc="$(unzip -v "$rom" 2>/dev/null | awk '$NF == "ddsom.key" { print tolower($(NF-1)); exit }')"
if [[ -z "$key_crc" ]]; then
  echo "[ROM 불완전] ddsom.zip 안에 ddsom.key가 없습니다."
  echo "이 파일은 별도 CPS-2 BIOS가 아니라 ddsom ROM 세트의 일부입니다."
  echo "현재 FBNeo에 맞는 완전한 ddsom.zip을 합법적으로 다시 준비해 주세요."
  echo "필요 항목: ddsom.key / CRC-32 541e425d"
  read -r -p "Enter를 누르면 닫힙니다."
  exit 3
fi
if [[ "$key_crc" != "541e425d" ]]; then
  echo "[ROM 불일치] ddsom.key의 CRC-32가 맞지 않습니다."
  echo "현재 값: $key_crc / 필요한 값: 541e425d"
  read -r -p "Enter를 누르면 닫힙니다."
  exit 3
fi
actual="$(sha256sum "$rom" | cut -d' ' -f1)"
expected="$(tr -d '[:space:]' < config/expected-rom-sha256.txt 2>/dev/null || true)"
echo "ROM SHA-256: $actual"
if [[ -n "$expected" && "$actual" != "$expected" ]]; then
  echo "[불일치] 등록된 기준 ROM과 다릅니다. 실행하지 않습니다."
  read -r -p "Enter를 누르면 닫힙니다."
  exit 1
fi
if [[ -z "$expected" ]]; then
  printf '%s\n' "$actual" > config/expected-rom-sha256.txt
  echo "[등록] 이 ddsom.zip을 기준 ROM으로 등록했습니다."
fi
public_ip="$(curl -4fsS --max-time 8 https://api.ipify.org 2>/dev/null || true)"
echo
if [[ "$public_ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "공인 IPv4: $public_ip"
  echo "접속 포트: TCP 55435"
  echo "친구에게 알려줄 주소: $public_ip"
else
  echo "[안내] 공인 IPv4를 자동 확인하지 못했습니다."
  echo "접속 포트는 TCP 55435입니다. 게임은 계속 실행합니다."
fi
echo
read -r -p "방에 표시할 이름 [Host]: " nick
nick="${nick:-Host}"
echo "호스트 시작: P1=방장, 이후 접속 순서대로 P2/P3/P4"
echo "친구에게 이 PC의 접속 주소를 알려 주세요. 포트: TCP 55435"
if [[ "${1:-}" != "--no-shader" ]]; then
  ./SET-VIDEO-MODE.sh high
  shader_args=(--set-shader="$(pwd)/shaders/shaders_slang/presets/scalefx-plus-smoothing/scalefx-aa-fast.slangp")
  echo "그래픽: 고화질 모드 적용"
else
  ./SET-VIDEO-MODE.sh compat
  shader_args=(--set-shader="")
  echo "그래픽: 호환 모드 (셰이더 없음)"
fi
mkdir -p "$(pwd)/logs"
LIBRETRO_ASSETS_DIRECTORY="$(pwd)/assets" APPIMAGE_EXTRACT_AND_RUN=1 ./RetroArch-Linux-x86_64.AppImage \
  --config "$(pwd)/config/retroarch.cfg" \
  "${shader_args[@]}" --host --port=55435 --nick="$nick" \
  --verbose --log-file "$(pwd)/logs/last-host.log" \
  -L "$(pwd)/cores/fbneo_libretro.so" "$(pwd)/roms/ddsom.zip"
