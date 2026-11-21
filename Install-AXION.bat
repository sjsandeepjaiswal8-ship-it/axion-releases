@echo off
setlocal
title AXION Studio Installer
echo ==========================================================================
echo    AXION Studio - Windows Native Installer
echo    Sovereign Autonomous AI Developer IDE
echo ==========================================================================
echo.

cd /d "%~dp0"

echo [1/3] Verifying and unblocking setup files...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0*' | Unblock-File -ErrorAction SilentlyContinue"

echo [2/3] Launching AXION Studio Native Setup...
if exist "%~dp0AXION-Setup-Pro.exe" (
    start "" "%~dp0AXION-Setup-Pro.exe"
) else (
    echo [!] AXION-Setup-Pro.exe not found in current folder.
    echo Running cloud installer instead...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://sjsandeepjaiswal8-ship-it.github.io/axion-studio/install.ps1 | iex"
)

echo [3/3] Done! Follow setup instructions on screen.
pause
