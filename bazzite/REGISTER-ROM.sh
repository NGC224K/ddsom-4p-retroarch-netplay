z�謺v)�++��B�y�rا��,��^���
��vz-r��y�N��ڶ*'��iz���ם#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"
rom="roms/ddsom.zip"
[[ -f "$rom" ]] || { echo "roms/ddsom.zip이 없습니다."; read -r; exit 2; }
key_crc="$(unzip -v "$rom" 2>/dev/null | awk '$NF == "ddsom.key" { print tolower($(NF-1)); exit }')"
[[ "$key_crc" == "541e425d" ]] || { echo "ROM 검사 실패: ddsom.key가 없거나 CRC-32가 541e425d가 아닙니다."; read -r; exit 3; }
hash="$(sha256sum "$rom" | cut -d' ' -f1)"
printf '%s\n' "$hash" > config/expected-rom-sha256.txt
echo "기준 SHA-256: $hash"
echo
echo "Windows 배포본을 압축하기 전에 같은 값을"
echo "config/expected-rom-sha256.txt에 넣어야 자동 검사가 작동합니다."
read -r -p "Enter를 누르면 닫힙니다."
