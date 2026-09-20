#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"
mode="${1:-}"
cfg="$(pwd)/config/retroarch.cfg"
tmp="${cfg}.tmp"
shader="$(pwd)/shaders/shaders_slang/presets/scalefx-plus-smoothing/scalefx-aa-fast.slangp"

awk '!/^video_shader(_enable)?[[:space:]]*=/' "$cfg" > "$tmp"
case "$mode" in
  high)
    printf 'video_shader_enable = "true"\nvideo_shader = "%s"\n' "$shader" >> "$tmp"
    ;;
  compat)
    printf 'video_shader_enable = "false"\nvideo_shader = ""\n' >> "$tmp"
    ;;
  *)
    rm -f "$tmp"
    echo "Usage: $0 high|compat" >&2
    exit 2
    ;;
esac
mv -f "$tmp" "$cfg"
