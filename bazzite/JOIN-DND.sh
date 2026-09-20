#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"
rom="roms/ddsom.zip"
if [[ ! -f "$rom" ]]; then
  echo "[오류] roms/ddsom.zip이 없습니다."
  read -r -p "Enter를 누르면 닫힙니다."
  exit 2
fi
key_crc="$(unzip -v "$rom" 2>/dev/null | awk '$NF == "ddsom.key" { print tolower($(NF-1)); exit }')"
if [[ "$key_crc" != "541e425d" ]]; then
  echo "[ROM 검사 실패] ddsom.key가 없거나 CRC-32가 맞지 않습니다."
  read -r -p "Enter를 누르면 닫힙니다."
  exit 3
fi
actual="$(sha256sum "$rom" | cut -d' ' -f1)"
expected="$(tr -d '[:space:]' < config/expected-rom-sha256.txt 2>/dev/null || true)"
echo "ROM SHA-256: $actual"
if [[ -n "$expected" && "$actual" != "$expected" ]]; then
  echo "[불일치] 등록된 기준 ROM과 다릅니다."
  read -r -p "Enter를 누르면 닫힙니다."
  exit 1
fi
read -r -p "방장의 공인 IP 또는 주소: " host
[[ -n "$host" ]] || exit 2
read -r -p "방에 표시할 이름 [Friend]: " nick
nick="${nick:-Friend}"
if [[ "${1:-}" != "--no-shader" ]]; then
  ./SET-VIDEO-MODE.sh high
  shader_args=(--set-shader="$(pwd)/shaders/shaders_slang/presets/scalefx-plus-smoothing/scalefx-aa-fast.slangp")
else
  ./SET-VIDEO-MODE.sh compat
  shader_args=(--set-shader="")
fi
echo "방장 $host 의 TCP 55435에 접속합니다."
mkdir -p "$(pwd)/logs"
LIBRETRO_ASSETS_DIRECTORY="$(pwd)/assets" APPIMAGE_EXTRACT_AND_RUN=1 ./RetroArch-Linux-x86_64.AppImage \
  --config "$(pwd)/config/retroarch.cfg" \
  "${shader_args[@]}" --connect="$host" --port=55435 --nick="$nick" \
  --verbose --log-file "$(pwd)/logs/last-join.log" \
  -L "$(pwd)/cores/fbneo_libretro.so" "$(pwd)/roms/ddsom.zip"
