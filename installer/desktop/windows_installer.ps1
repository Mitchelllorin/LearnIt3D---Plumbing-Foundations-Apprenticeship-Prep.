# FILE: /installer/desktop/windows_installer.ps1
# LearnIt3D - Plumbing Foundations Apprenticeship Prep
# Windows Desktop Installer Script
# --------------------------------------------------
# Requirements: PowerShell 5.1+ | Windows 10/11 (x64)
# Usage:  Right-click > "Run with PowerShell"  (or)
#         powershell -ExecutionPolicy Bypass -File windows_installer.ps1
# --------------------------------------------------

#Requires -Version 5.1

[CmdletBinding()]
param (
    [string]$InstallDir  = "$env:ProgramFiles\LearnIt3D\PlumbingPrep",
    [string]$DataDir     = "$env:APPDATA\LearnIt3D\PlumbingPrep",
    [switch]$Silent,
    [switch]$Uninstall
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Constants ────────────────────────────────────────────────────────────────
$AppName        = "LearnIt3D – Plumbing Foundations Apprenticeship Prep"
$AppVersion     = "1.0.0"
$Publisher      = "LearnIt3D"
$AppExe         = "LearnIt3DPlumbing.exe"
$RegistryKey    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\LearnIt3DPlumbing"
$ShortcutDesktop = "$env:PUBLIC\Desktop\$AppName.lnk"
$ShortcutStart   = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\$AppName.lnk"
$LogFile         = "$env:TEMP\LearnIt3D_install.log"

# ── Helpers ──────────────────────────────────────────────────────────────────
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
    if (-not $Silent) { Write-Host $line }
}

function Assert-Admin {
    $identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Log "Installer must be run as Administrator. Relaunching elevated..." "WARN"
        $args = "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
        Start-Process powershell -ArgumentList $args -Verb RunAs
        exit 0
    }
}

function New-Shortcut {
    param([string]$Target, [string]$Destination, [string]$Description)
    $wsh  = New-Object -ComObject WScript.Shell
    $link = $wsh.CreateShortcut($Destination)
    $link.TargetPath       = $Target
    $link.WorkingDirectory = Split-Path $Target
    $link.Description      = $Description
    $link.IconLocation     = "$Target,0"
    $link.Save()
    Write-Log "Shortcut created: $Destination"
}

function Register-Uninstaller {
    if (-not (Test-Path $RegistryKey)) {
        New-Item -Path $RegistryKey -Force | Out-Null
    }
    $props = @{
        DisplayName          = $AppName
        DisplayVersion       = $AppVersion
        Publisher            = $Publisher
        InstallLocation      = $InstallDir
        UninstallString      = "powershell -ExecutionPolicy Bypass -File `"$InstallDir\windows_installer.ps1`" -Uninstall"
        DisplayIcon          = "$InstallDir\$AppExe,0"
        NoModify             = 1
        NoRepair             = 1
        EstimatedSize        = 150000   # KB
        InstallDate          = (Get-Date -Format "yyyyMMdd")
    }
    foreach ($key in $props.Keys) {
        Set-ItemProperty -Path $RegistryKey -Name $key -Value $props[$key]
    }
    Write-Log "Registered in Programs & Features."
}

# ── Uninstall ────────────────────────────────────────────────────────────────
function Invoke-Uninstall {
    Write-Log "Starting uninstall of $AppName v$AppVersion"

    # Stop running process
    Get-Process -Name ([System.IO.Path]::GetFileNameWithoutExtension($AppExe)) -ErrorAction SilentlyContinue |
        Stop-Process -Force

    # Remove files
    if (Test-Path $InstallDir) {
        Remove-Item -Path $InstallDir -Recurse -Force
        Write-Log "Removed: $InstallDir"
    }

    # Remove data (optional – ask user unless -Silent)
    if (-not $Silent) {
        $choice = Read-Host "Remove user data at $DataDir? [Y/N]"
    } else {
        $choice = "N"
    }
    if ($choice -eq "Y" -and (Test-Path $DataDir)) {
        Remove-Item -Path $DataDir -Recurse -Force
        Write-Log "Removed user data: $DataDir"
    }

    # Remove shortcuts
    foreach ($link in @($ShortcutDesktop, $ShortcutStart)) {
        if (Test-Path $link) { Remove-Item $link -Force; Write-Log "Removed shortcut: $link" }
    }

    # Remove registry entry
    if (Test-Path $RegistryKey) {
        Remove-Item -Path $RegistryKey -Recurse -Force
        Write-Log "Removed registry key."
    }

    Write-Log "Uninstall complete."
}

# ── Install ──────────────────────────────────────────────────────────────────
function Invoke-Install {
    Write-Log "Starting install of $AppName v$AppVersion"
    Write-Log "Install dir : $InstallDir"
    Write-Log "Data dir    : $DataDir"

    # Create directories
    foreach ($dir in @($InstallDir, $DataDir)) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Log "Created: $dir"
        }
    }

    # ── Placeholder: copy application files ──────────────────────────────────
    # In production, replace this section with actual file extraction / MSIX
    # deployment, e.g.:
    #
    #   Expand-Archive -Path ".\LearnIt3DPlumbing.zip" -DestinationPath $InstallDir -Force
    #
    # For now, write a placeholder launcher stub so shortcuts resolve.
    $stubPath = Join-Path $InstallDir $AppExe
    if (-not (Test-Path $stubPath)) {
        Set-Content -Path $stubPath -Value "# LearnIt3D Plumbing Launcher stub" -Encoding UTF8
        Write-Log "Wrote launcher stub: $stubPath"
    }

    # Copy installer alongside app for future uninstall
    Copy-Item -Path $PSCommandPath -Destination "$InstallDir\windows_installer.ps1" -Force
    Write-Log "Copied installer to $InstallDir"

    # Copy icon if present alongside this script
    $iconSrc = Join-Path (Split-Path $PSCommandPath) "..\..\src\assets\icons\learnit3d_icon.ico"
    if (Test-Path $iconSrc) {
        Copy-Item -Path $iconSrc -Destination "$InstallDir\learnit3d_icon.ico" -Force
        Write-Log "Copied icon."
    }

    # Create shortcuts
    New-Shortcut -Target "$InstallDir\$AppExe" `
                 -Destination $ShortcutDesktop `
                 -Description $AppName
    New-Shortcut -Target "$InstallDir\$AppExe" `
                 -Destination $ShortcutStart `
                 -Description $AppName

    # Register uninstaller
    Register-Uninstaller

    Write-Log "Install complete."
    if (-not $Silent) {
        [System.Windows.Forms.MessageBox]::Show(
            "$AppName has been installed successfully.`nVersion: $AppVersion",
            "Installation Complete",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
}

# ── Entry point ───────────────────────────────────────────────────────────────
Assert-Admin

if ($Uninstall) {
    Invoke-Uninstall
} else {
    Add-Type -AssemblyName System.Windows.Forms   # needed for MessageBox
    Invoke-Install
}
