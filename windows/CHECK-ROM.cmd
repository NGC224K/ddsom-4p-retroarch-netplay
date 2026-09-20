z�謺v)�++��B�y�rا��,��^���
��vz-r��y�N��ڶ*'��iz���ם@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
if not exist "roms\ddsom.zip" (
  echo [실패] roms\ddsom.zip 파일이 없습니다.
  exit /b 2
)
powershell.exe -NoLogo -NoProfile -NonInteractive -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; $z=[IO.Compression.ZipFile]::OpenRead($args[0]); try { if (-not ($z.Entries | Where-Object { $_.FullName -ieq 'ddsom.key' })) { exit 3 } } finally { $z.Dispose() }" "roms\ddsom.zip"
if errorlevel 3 (
  echo [ROM 불완전] ddsom.zip 안에 ddsom.key가 없습니다.
  echo 이것은 별도 BIOS가 아니라 현재 FBNeo용 ddsom ROM 세트의 일부입니다.
  echo 필요한 파일: ddsom.key / CRC-32 541e425d
  exit /b 3
)
for /f "usebackq delims=" %%H in (`powershell.exe -NoLogo -NoProfile -NonInteractive -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath $args[0]).Hash" "roms\ddsom.zip"`) do if not defined ACTUAL set "ACTUAL=%%H"
if not defined ACTUAL (
  echo [실패] Windows의 SHA-256 검사 기능을 실행하지 못했습니다.
  exit /b 3
)
set "EXPECTED="
if exist "config\expected-rom-sha256.txt" set /p EXPECTED=<"config\expected-rom-sha256.txt"
set "EXPECTED=!EXPECTED: =!"
echo.
echo ROM SHA-256: !ACTUAL!
if not defined EXPECTED (
  echo [주의] 기준 해시가 아직 등록되지 않았습니다.
  echo 방장이 이 값을 참가자 모두와 비교해야 합니다.
  exit /b 0
)
if /i "!ACTUAL!"=="!EXPECTED!" (
  echo [통과] 방장이 등록한 ROM과 정확히 같습니다.
  exit /b 0
)
echo [불일치] 방장의 ROM과 다릅니다.
echo 기준 SHA-256: !EXPECTED!
exit /b 1
