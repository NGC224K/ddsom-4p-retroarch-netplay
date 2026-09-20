@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title Dungeons & Dragons SOM 4P

:menu
cls
echo ================================================================
echo   D^&D: Shadow over Mystara - 4인 온라인 도우미
echo ================================================================
echo.
echo   [1] 방 참가 (JOIN / 고화질)
echo   [2] 방 만들기 (HOST / 고화질)
echo   [3] 처음사용설명서 열기
echo   [4] ROM 검사
echo   [5] RetroArch만 열기 (패드/키 설정)
echo   [6] 방 참가 (그래픽 호환 모드)
echo   [7] 방 만들기 (그래픽 호환 모드)
echo   [8] RetroArch 강제 종료
echo   [0] 닫기
echo.
set /p CHOICE=번호를 입력하고 Enter: 
if "%CHOICE%"=="1" goto join_high
if "%CHOICE%"=="2" goto host_high
if "%CHOICE%"=="3" goto open_guide
if "%CHOICE%"=="4" goto check_rom
if "%CHOICE%"=="5" goto open_retroarch
if "%CHOICE%"=="6" goto join_basic
if "%CHOICE%"=="7" goto host_basic
if "%CHOICE%"=="8" goto kill_retroarch
if "%CHOICE%"=="0" exit /b 0
goto menu

:open_guide
start "" "%~dp0FIRST-USE-GUIDE.html"
goto menu

:check_rom
call "%~dp0CHECK-ROM.cmd"
pause
goto menu

:open_retroarch
start "" /wait "%~dp0retroarch.exe" --config "%~dp0config\retroarch.cfg"
goto menu

:kill_retroarch
taskkill /IM retroarch.exe /T /F >nul 2>&1
echo RetroArch 종료 명령을 실행했습니다.
pause
goto menu

:join_high
set "NO_SHADER="
call :set_video_high
goto join

:join_basic
set "NO_SHADER=1"
call :set_video_compat
goto join

:host_high
set "NO_SHADER="
call :set_video_high
goto host

:host_basic
set "NO_SHADER=1"
call :set_video_compat
goto host

:join
if not exist "%~dp0roms\ddsom.zip" (
  echo.
  echo [오류] roms 폴더에 ddsom.zip이 없습니다.
  echo 처음사용설명서를 열어 1단계를 따라 하세요.
  pause
  goto menu
)
call "%~dp0CHECK-ROM.cmd"
if errorlevel 1 (
  echo.
  echo 안전을 위해 실행을 중단했습니다. 방장에게 해시값을 확인하세요.
  pause
  goto menu
)
echo.
set /p HOST=방장에게 받은 주소(IP 또는 도메인)를 입력: 
if not defined HOST goto menu
set /p NICK=게임에서 사용할 이름을 입력: 
if not defined NICK set "NICK=Friend"
echo.
echo 접속 중... Windows 방화벽 질문이 나오면 '액세스 허용'을 누르세요.
echo 접속 순서: 첫 친구=P2, 둘째=P3, 셋째=P4
if defined NO_SHADER (
  "%~dp0retroarch.exe" --config "%~dp0config\retroarch.cfg" --set-shader="" --connect="%HOST%" --port=55435 --nick="%NICK%" --verbose --log-file "%~dp0logs\last-join.log" -L "%~dp0cores\fbneo_libretro.dll" "%~dp0roms\ddsom.zip"
) else (
  "%~dp0retroarch.exe" --config "%~dp0config\retroarch.cfg" --set-shader="%~dp0shaders\shaders_slang\presets\scalefx-plus-smoothing\scalefx+rAA+aa.slangp" --connect="%HOST%" --port=55435 --nick="%NICK%" --verbose --log-file "%~dp0logs\last-join.log" -L "%~dp0cores\fbneo_libretro.dll" "%~dp0roms\ddsom.zip"
)
echo.
echo RetroArch가 닫혔습니다. 문제가 있었다면 logs\last-join.log를 방장에게 보내세요.
pause
goto menu

:host
if not exist "%~dp0roms\ddsom.zip" (
  echo.
  echo [오류] roms 폴더에 ddsom.zip이 없습니다.
  pause
  goto menu
)
call "%~dp0CHECK-ROM.cmd"
if errorlevel 1 (
  echo 안전을 위해 실행을 중단했습니다.
  pause
  goto menu
)
set "PUBLIC_IP="
for /f "usebackq delims=" %%I in (`powershell.exe -NoLogo -NoProfile -NonInteractive -Command "try { (Invoke-RestMethod -Uri 'https://api.ipify.org' -TimeoutSec 8).Trim() } catch {}"`) do if not defined PUBLIC_IP set "PUBLIC_IP=%%I"
echo.
if defined PUBLIC_IP (
  echo 공인 IPv4: !PUBLIC_IP!
  echo 접속 포트: TCP 55435
  echo 친구에게 알려줄 주소: !PUBLIC_IP!
) else (
  echo [안내] 공인 IPv4를 자동 확인하지 못했습니다. 포트는 TCP 55435입니다.
)
echo.
set /p NICK=방에 표시할 이름을 입력 [Host]: 
if not defined NICK set "NICK=Host"
echo Windows 방화벽 창이 나오면 개인 네트워크 액세스를 허용하세요.
if defined NO_SHADER (
  "%~dp0retroarch.exe" --config "%~dp0config\retroarch.cfg" --set-shader="" --host --port=55435 --nick="%NICK%" --verbose --log-file "%~dp0logs\last-host.log" -L "%~dp0cores\fbneo_libretro.dll" "%~dp0roms\ddsom.zip"
) else (
  "%~dp0retroarch.exe" --config "%~dp0config\retroarch.cfg" --set-shader="%~dp0shaders\shaders_slang\presets\scalefx-plus-smoothing\scalefx+rAA+aa.slangp" --host --port=55435 --nick="%NICK%" --verbose --log-file "%~dp0logs\last-host.log" -L "%~dp0cores\fbneo_libretro.dll" "%~dp0roms\ddsom.zip"
)
echo.
echo 호스트가 종료되었습니다.
pause
goto menu

:set_video_high
set "CFG=%~dp0config\retroarch.cfg"
set "TMP=%~dp0config\retroarch-video.tmp"
findstr /v /b /c:"video_shader =" /c:"video_shader_enable =" "!CFG!" > "!TMP!"
set "SHADER_PATH=%~dp0shaders\shaders_slang\presets\scalefx-plus-smoothing\scalefx+rAA+aa.slangp"
set "SHADER_PATH=!SHADER_PATH:\=/!"
>>"!TMP!" echo video_shader_enable = "true"
>>"!TMP!" echo video_shader = "!SHADER_PATH!"
move /y "!TMP!" "!CFG!" >nul
exit /b 0

:set_video_compat
set "CFG=%~dp0config\retroarch.cfg"
set "TMP=%~dp0config\retroarch-video.tmp"
findstr /v /b /c:"video_shader =" /c:"video_shader_enable =" "!CFG!" > "!TMP!"
>>"!TMP!" echo video_shader_enable = "false"
>>"!TMP!" echo video_shader = ""
move /y "!TMP!" "!CFG!" >nul
exit /b 0
