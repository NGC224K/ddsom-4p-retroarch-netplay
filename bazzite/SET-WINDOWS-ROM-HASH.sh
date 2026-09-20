z�謺v)�++��B�y�rا��,��^���
��vz-r��y�N��ڶ*'��iz���ם#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"
win_dir="${1:-../DND-SOM-4P-Windows}"
rom="roms/ddsom.zip"
target="$win_dir/config/expected-rom-sha256.txt"
[[ -f "$rom" ]] || { echo "roms/ddsom.zip이 없습니다."; exit 2; }
key_crc="$(unzip -v "$rom" 2>/dev/null | awk '$NF == "ddsom.key" { print tolower($(NF-1)); exit }')"
[[ "$key_crc" == "541e425d" ]] || { echo "ROM 검사 실패: ddsom.key가 없거나 CRC-32가 541e425d가 아닙니다."; exit 3; }
[[ -d "$win_dir/config" ]] || { echo "Windows 폴더를 찾지 못했습니다: $win_dir"; exit 2; }
hash="$(sha256sum "$rom" | cut -d' ' -f1)"
printf '%s\n' "$hash" > config/expected-rom-sha256.txt
printf '%s\n' "$hash" > "$target"
echo "등록 완료: $hash"
echo "Windows 폴더를 ZIP으로 압축해 친구에게 배포하세요."
