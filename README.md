# Getting Started

1. Open **PowerShell as Administrator**



## Improved flow

```powershell

```

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bergtobias/config/refs/heads/main/install.ps1" -OutFile "./install.ps1"
./install.ps1
```