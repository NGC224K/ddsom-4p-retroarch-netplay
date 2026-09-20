z�謺v)�++��B�y�rا��,��^���
��vz-r��y�N��ڶ*'��iz���ם#!/usr/bin/env bash
set -u
PORT=55435

pause_end() {
  echo
  read -r -p "Enter를 누르면 닫힙니다."
}

line() { printf '%s\n' "----------------------------------------------------------------"; }
ok()   { printf '[정상] %s\n' "$1"; }
warn() { printf '[확인] %s\n' "$1"; }
bad()  { printf '[문제] %s\n' "$1"; }

clear
echo "D&D SOM 4인방 — 방장 접속 점검"
line
echo "검사 포트: TCP $PORT"
echo "접속 방식: 공인 IPv4 직접접속 (RetroArch 릴레이 OFF)"
echo "중요: 정확한 외부 검사를 하려면 HOST-DND.sh로 게임을 먼저 켜 둔 뒤"
echo "      이 스크립트를 별도로 실행해야 합니다."
line

local_ips="$(hostname -I 2>/dev/null | xargs || true)"
if [[ -n "$local_ips" ]]; then
  echo "내부 IP: $local_ips"
else
  warn "내부 IP를 자동으로 찾지 못했습니다."
fi

public_ip="$(curl -4fsS --max-time 8 https://api.ipify.org 2>/dev/null || true)"
if [[ -z "$public_ip" ]]; then
  public_ip="$(curl -4fsS --max-time 8 https://ifconfig.me/ip 2>/dev/null || true)"
fi
if [[ "$public_ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "공인 IPv4: $public_ip"
  echo "친구에게 보낼 주소: $public_ip  (포트는 참가기가 $PORT 사용)"
else
  bad "공인 IPv4를 확인하지 못했습니다. 인터넷 연결 또는 IPv4 제공 여부를 확인하세요."
  public_ip=""
fi
line

if command -v ss >/dev/null 2>&1 && ss -ltnH "sport = :$PORT" 2>/dev/null | grep -q .; then
  ok "RetroArch가 TCP $PORT에서 접속을 기다리고 있습니다."
  listening=yes
else
  bad "현재 TCP $PORT에서 기다리는 프로그램이 없습니다."
  echo "       HOST-DND.sh로 게임을 먼저 실행하고, 게임 창을 닫지 않은 채 다시 검사하세요."
  listening=no
fi

if command -v firewall-cmd >/dev/null 2>&1; then
  fw_state="$(firewall-cmd --state 2>/dev/null || true)"
  if [[ "$fw_state" == "running" ]]; then
    if firewall-cmd --quiet --query-port="$PORT/tcp" 2>/dev/null; then
      ok "Bazzite 방화벽에 $PORT/tcp 허용 규칙이 있습니다."
    else
      warn "Bazzite 방화벽에 $PORT/tcp 명시적 허용 규칙이 없습니다."
      echo "       필요하면 터미널에서 다음 두 줄을 실행하세요:"
      echo "       sudo firewall-cmd --add-port=$PORT/tcp"
      echo "       sudo firewall-cmd --permanent --add-port=$PORT/tcp"
    fi
  else
    echo "방화벽: firewalld가 실행 중이지 않습니다."
  fi
else
  echo "방화벽: firewall-cmd가 없어 자동 확인을 건너뜁니다."
fi
line

if [[ "$listening" == "yes" && -n "$public_ip" ]]; then
  echo "외부 포트는 웹 검사 페이지에서 TCP $PORT를 입력해 확인할 수 있습니다."
  read -r -p "portcheck.ing 검사 페이지를 열까요? [y/N]: " consent
  if [[ "$consent" =~ ^[Yy]$ ]]; then
    xdg-open 'https://portcheck.ing/?_lang=ko' >/dev/null 2>&1 || true
    echo "페이지에서 포트 $PORT를 입력하세요. 호스트가 실행 중일 때 '열림'이면 정상입니다."
  else
    echo "페이지 열기를 건너뛰었습니다. 공인 IP는 친구 외에는 공유하지 마세요."
  fi
else
  echo "호스트가 포트를 듣고 있지 않거나 공인 IPv4가 없어 외부 검사를 건너뜁니다."
fi

line
echo "참고: 같은 집/공유기 안의 친구는 내부 IP로 접속합니다."
echo "      인터넷 친구는 공인 IPv4로 접속하며 TCP $PORT 포트 전달이 필요할 수 있습니다."
pause_end
