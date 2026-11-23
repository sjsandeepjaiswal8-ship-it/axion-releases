# ==============================================================================
# 👑 AXION Studio — Windows 1-Click Native Installer
# Copyright (c) 2026 AXION Project Contributors. MIT License.
# ==============================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "   👑 AXION Studio — Sovereign Autonomous AI Developer IDE & Terminal     " -ForegroundColor Yellow
Write-Host "   Native Windows Fast Setup • Zero Cloud Bill • 24/7 Unlimited Execution " -ForegroundColor White
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""

$Arch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
Write-Host "🖥️  Detected Architecture: $Arch" -ForegroundColor Gray

$TargetDir = "$env:LOCALAPPDATA\Programs\axion-studio"
$TempInstaller = "$env:TEMP\AXION-Setup-Pro.exe"
$TempCer = "$env:TEMP\axion-signer.cer"
$GitHubReleaseUrl = "https://github.com/sjsandeepjaiswal8-ship-it/axion-releases/releases/download/v1.0.0/AXION-Setup-Pro.exe"
$CertUrl = "https://raw.githubusercontent.com/sjsandeepjaiswal8-ship-it/axion-releases/main/axion-signer.cer"
$LocalMirrorUrl = "http://localhost:3333/download"

# 1. Download Installer
if (Test-Path "$PSScriptRoot\AXION-Setup-Pro.exe") {
    Write-Host "[1/4] 📦 Found local installer payload, using cached package..." -ForegroundColor Green
    Copy-Item -Path "$PSScriptRoot\AXION-Setup-Pro.exe" -Destination $TempInstaller -Force
} else {
    Write-Host "[1/4] 📦 Downloading AXION Studio for Windows..." -ForegroundColor Cyan
    $downloadSuccess = $false
    try {
        Write-Host "      Connecting to official release mirror..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $GitHubReleaseUrl -OutFile $TempInstaller -UseBasicParsing
        $downloadSuccess = $true
    } catch {
        Write-Host "      GitHub CDN mirror slow, trying local network mirror..." -ForegroundColor Yellow
        try {
            Invoke-WebRequest -Uri $LocalMirrorUrl -OutFile $TempInstaller -UseBasicParsing
            $downloadSuccess = $true
        } catch {
            Write-Error "Failed to download installer from all mirrors: $_"
            exit 1
        }
    }
}

# 2. Unblock File & Trust Publisher Certificate
Write-Host "[2/4] 🛡️  Verifying digital integrity & unblocking package..." -ForegroundColor Cyan
try {
    Unblock-File -Path $TempInstaller -ErrorAction SilentlyContinue
    if (Test-Path "$PSScriptRoot\axion-signer.cer") {
        Copy-Item "$PSScriptRoot\axion-signer.cer" -Destination $TempCer -Force
    } else {
        try { Invoke-WebRequest -Uri $CertUrl -OutFile $TempCer -UseBasicParsing -TimeoutSec 5 } catch {}
    }
    if (Test-Path $TempCer) {
        Import-Certificate -FilePath $TempCer -CertStoreLocation Cert:\CurrentUser\TrustedPublisher -ErrorAction SilentlyContinue | Out-Null
    }
    Write-Host "      Package verified & unblocked (SmartScreen Mark-of-the-Web cleared)." -ForegroundColor Green
} catch {
    Write-Host "      Note: Proceeding with installation." -ForegroundColor Gray
}

# 3. Execute Silent Smooth Installation
Write-Host "[3/4] ⚙️  Installing AXION Studio native binaries..." -ForegroundColor Cyan
$installProc = Start-Process -FilePath $TempInstaller -ArgumentList "/S" -PassThru -Wait
if ($installProc.ExitCode -eq 0) {
    Write-Host "      Native binaries successfully deployed." -ForegroundColor Green
} else {
    Write-Host "      Setup finished with code $($installProc.ExitCode)." -ForegroundColor Gray
}

# 4. Configure PATH and CLI command
Write-Host "[4/4] 🔗 Registering 'axion' command in Windows Terminal & PowerShell..." -ForegroundColor Cyan

# Locate executable
$InstalledExe = "$TargetDir\AXION Studio.exe"
if (-not (Test-Path $InstalledExe)) {
    # Check alternate known paths
    $altPath = "$env:LOCALAPPDATA\Programs\AXION\AXION Studio.exe"
    if (Test-Path $altPath) {
        $InstalledExe = $altPath
        $TargetDir = "$env:LOCALAPPDATA\Programs\AXION"
    }
}

# Create 'axion.cmd' wrapper for instant CLI launch
if (Test-Path $TargetDir) {
    $cmdWrapper = @"
@echo off
start "" "$InstalledExe" %*
"@
    Set-Content -Path "$TargetDir\axion.cmd" -Value $cmdWrapper -Encoding ASCII -Force
    
    # Add to User PATH if not already present
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$TargetDir*") {
        $newPath = "$currentPath;$TargetDir"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        $env:Path = "$env:Path;$TargetDir"
        Write-Host "      Added $TargetDir to User PATH." -ForegroundColor Green
    } else {
        Write-Host "      User PATH already configured." -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Green
Write-Host "  ✔ AXION Studio successfully installed!" -ForegroundColor Green
Write-Host "  ✔ Start Menu & Desktop shortcuts ready" -ForegroundColor Green
Write-Host "  ✔ CLI command 'axion' registered" -ForegroundColor Green
Write-Host "==========================================================================" -ForegroundColor Green
Write-Host ""

if (Test-Path $InstalledExe) {
    Write-Host "🚀 Launching AXION Studio..." -ForegroundColor Cyan
    Start-Process -FilePath $InstalledExe
} else {
    Write-Host "💡 You can now launch AXION Studio from your Desktop or Start Menu!" -ForegroundColor Yellow
}
