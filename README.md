# Getting Started

1. Open **PowerShell as Administrator**



## Improved flow

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bergtobias/config/main/install.ps1" -OutFile "$env:USERPROFILE\install.ps1"

```

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; . .\bootstrap.ps1
```