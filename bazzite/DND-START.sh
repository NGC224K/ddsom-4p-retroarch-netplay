#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"
while true; do
  clear
  echo "=============================================================="
  echo " D&D Shadow over Mystara 4인 온라인"
  echo "=============================================================="
  echo " [1] 방 만들기 (HOST / 고화질)"
  echo " [2] 방 참가 (JOIN / 고화질)"
  echo " [3] 접속 상태 점검"
  echo " [4] 방 만들기 (그래픽 호환 모드)"
  echo " [5] 방 참가 (그래픽 호환 모드)"
  echo " [6] RetroArch 강제 종료"
  echo " [0] 닫기"
  echo
  read -r -p "번호를 입력하고 Enter: " choice
  case "$choice" in
    1) ./HOST-DND.sh ;;
    2) ./JOIN-DND.sh ;;
    3) ./CHECK-CONNECTION.sh ;;
    4) ./HOST-DND.sh --no-shader ;;
    5) ./JOIN-DND.sh --no-shader ;;
    6)
      pkill -TERM -f '[/]cores/fbneo_libretro\.so' 2>/dev/null || true
      pkill -TERM -f '[/]RetroArch-Linux-x86_64.AppImage' 2>/dev/null || true
      sleep 1
      pkill -KILL -f '[/]cores/fbneo_libretro\.so' 2>/dev/null || true
      pkill -KILL -f '[/]RetroArch-Linux-x86_64.AppImage' 2>/dev/null || true
      echo "RetroArch 종료 신호를 보냈습니다."
      ;;
    0) exit 0 ;;
  esac
  echo
  read -r -p "Enter를 누르면 메뉴로 돌아갑니다."
done
