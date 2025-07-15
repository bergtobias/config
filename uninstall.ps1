# Requires running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator."
    exit 1
}

Write-Host "Unregistering all WSL distros..." -ForegroundColor Cyan
$distros = wsl --list --quiet 2>$null

foreach ($distro in $distros) {
    Write-Host "Unregistering distro: $distro"
    wsl --unregister $distro
}

Write-Host "Disabling WSL and Virtual Machine Platform features..." -ForegroundColor Cyan
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart

Write-Host "Removing leftover WSL files..." -ForegroundColor Cyan
$pathsToRemove = @(
    "$env:USERPROFILE\AppData\Local\Packages\CanonicalGroupLimited*",
    "$env:USERPROFILE\.wslconfig",
    "$env:USERPROFILE\.wsl"
)

foreach ($path in $pathsToRemove) {
    if (Test-Path $path) {
        Write-Host "Removing $path"
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "Path not found: $path"
    }
}

Write-Host "Reboot your system to complete uninstall before reinstalling." -ForegroundColor Yellow

# Optional: Uncomment below to re-enable WSL features immediately
# Write-Host "Re-enabling WSL and Virtual Machine Platform features..." -ForegroundColor Cyan
# dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# Write-Host "Reboot your system again after enabling features." -ForegroundColor Yellow
