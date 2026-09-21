@echo off
chcp 949 >nul
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
set "ROM_PATH=%~dp0roms\ddsom.zip"
if not exist "roms\ddsom.zip" (
  echo [실패] roms\ddsom.zip 파일이 없습니다.
  exit /b 2
)
powershell.exe -NoLogo -NoProfile -NonInteractive -Command "$ErrorActionPreference='Stop'; try { Add-Type -AssemblyName System.IO.Compression.FileSystem; $z=[IO.Compression.ZipFile]::OpenRead($env:ROM_PATH); try { if (-not ($z.Entries | Where-Object { $_.FullName -ieq 'ddsom.key' })) { exit 3 } } finally { $z.Dispose() } } catch { Write-Error $_; exit 4 }"
if errorlevel 4 goto zip_error
if errorlevel 3 goto key_missing
set "ACTUAL="
for /f "delims=" %%H in ('powershell.exe -NoLogo -NoProfile -NonInteractive -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath $env:ROM_PATH).Hash"') do if not defined ACTUAL set "ACTUAL=%%H"
if not defined ACTUAL (
  echo [실패] ROM의 SHA-256 값을 계산하지 못했습니다.
  exit /b 3
)
set "EXPECTED="
if exist "config\expected-rom-sha256.txt" set /p EXPECTED=<"config\expected-rom-sha256.txt"
set "EXPECTED=!EXPECTED: =!"
echo ROM SHA-256: !ACTUAL!
if not defined EXPECTED (
  echo [주의] 기준 해시가 없습니다. 방장과 직접 비교하세요.
  exit /b 0
)
if /i "!ACTUAL!"=="!EXPECTED!" (
  echo [통과] ROM 해시가 기준값과 일치합니다.
  exit /b 0
)
echo [불일치] 방장의 ROM과 다릅니다.
echo 기준 SHA-256: !EXPECTED!
exit /b 1

:key_missing
echo [ROM 불완전] ddsom.zip 안에 ddsom.key가 없습니다.
echo 이 파일은 별도 BIOS가 아니라 ROM 세트 내부 파일입니다.
exit /b 3

:zip_error
echo [실패] ROM ZIP을 열 수 없습니다. 파일 경로와 ZIP 손상 여부를 확인하세요.
exit /b 4
