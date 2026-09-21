@echo off
chcp 949 >nul
echo.
echo DND 4인 온라인 실행기를 시작합니다...
if not exist "%~dp0START-DND.cmd" (
  echo [오류] 같은 폴더에 START-DND.cmd가 없습니다.
  echo 패치의 세 파일을 기존 게임 폴더에 덮어쓰세요.
  pause
  exit /b 2
)
call "%~dp0START-DND.cmd"
echo.
echo [안내] 실행기가 종료되었습니다. 위쪽 오류 메시지가 있다면 방장에게 보내세요.
pause
