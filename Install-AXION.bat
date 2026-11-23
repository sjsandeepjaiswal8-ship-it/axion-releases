@echo off
setlocal
title AXION Studio Installer
echo ==========================================================================
echo    AXION Studio - Windows Native Installer
echo    Sovereign Autonomous AI Developer IDE (100%% Standalone)
echo ==========================================================================
echo.

cd /d "%~dp0"

echo [1/4] Verifying and unblocking setup files...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0*' | Unblock-File -ErrorAction SilentlyContinue"

echo [2/4] Launching AXION Studio Native Setup...
if exist "%~dp0AXION-Setup-Pro.exe" (
    start /wait "" "%~dp0AXION-Setup-Pro.exe"
) else (
    echo [!] AXION-Setup-Pro.exe not found in current folder.
    echo Running official HTTPS cloud installer instead...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/sjsandeepjaiswal8-ship-it/axion-releases/main/install.ps1 | iex"
)

echo [3/4] Checking Local AI Engine (Ollama) for Offline / CPU Mode...
where ollama >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [i] Ollama not detected on PATH. AXION works with Cloud Providers (Groq/DeepSeek/OpenRouter) immediately.
    echo [i] For 100%% offline local models, install Ollama from https://ollama.com and run: ollama pull qwen2.5-coder:1.5b
) else (
    echo [OK] Ollama detected! Ensuring starter lightweight model (qwen2.5:0.5b) is ready...
    ollama list | findstr /I "qwen2.5" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        ollama pull qwen2.5:0.5b
    )
)

echo [4/4] Done! Launch AXION Studio from Desktop or Start Menu.
pause
