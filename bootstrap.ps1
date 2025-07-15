# Force UTF-8 output for consistency
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"
Clear-Host

Write-Output "==> DevShell Bootstrap Starting"

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    exit 1
}

Write-Host "`n=== STEP 1: Checking WSL & Ubuntu installation ==="

$wslDistros = wsl -l -q 2>$null

if ($wslDistros -contains "Ubuntu") {
    Write-Host "Ubuntu is already installed."
} else {
    Write-Host "Ubuntu not found. Installing..."
    wsl --install --distribution Ubuntu
    Write-Host "Reboot if prompted. Re-run this script after Ubuntu has initialized."
    Read-Host "Press Enter AFTER Ubuntu has been opened once and initialized..."
}

Write-Host "`n=== STEP 2: Installing Git ==="
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing via winget..."
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Git is already installed."
}

Write-Host "`n=== STEP 3: Installing VS Code and Remote WSL Extension ==="

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "VS Code not found. Installing via winget..."
    winget install --id Microsoft.VisualStudioCode -e --source winget --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "VS Code is already installed."
}

$extName = "ms-vscode-remote.remote-wsl"
$installedExtensions = code --list-extensions

if ($installedExtensions -contains $extName) {
    Write-Host "Remote WSL extension already installed. Updating..."
    code --install-extension $extName --force
} else {
    Write-Host "Installing Remote WSL extension..."
    code --install-extension $extName
}

Write-Host "`n=== STEP 4: Updating VS Code Keybindings ==="

$localKeybindings = ".\vscode\keybindings.json"
$vsCodeKeybindingsPath = Join-Path $env:APPDATA "Code\User\keybindings.json"

if (Test-Path $localKeybindings) {
    $localBindings = Get-Content $localKeybindings -Raw | ConvertFrom-Json
    if ($localBindings -isnot [System.Collections.IEnumerable]) { $localBindings = @($localBindings) }

    if (Test-Path $vsCodeKeybindingsPath) {
        $existingBindings = Get-Content $vsCodeKeybindingsPath -Raw | ConvertFrom-Json
        if ($null -eq $existingBindings) { $existingBindings = @() }
        if ($existingBindings -isnot [System.Collections.IEnumerable]) {
            $existingBindings = @($existingBindings)
        }
    } else {
        $existingBindings = @()
    }

    $existingKeys = $existingBindings | ForEach-Object { $_.key }
    $toAdd = $localBindings | Where-Object { $existingKeys -notcontains $_.key }
    $mergedBindings = $existingBindings + $toAdd

    $mergedBindings | ConvertTo-Json -Depth 5 | Set-Content $vsCodeKeybindingsPath -Encoding utf8
    Write-Host "Keybindings merged."
} else {
    Write-Host "No local keybindings.json found in ./vscode. Skipping."
}

Write-Host "`n=== STEP 5: Updating VS Code Settings ==="

$localSettings = ".\vscode\settings.json"
$vsCodeSettingsPath = Join-Path $env:APPDATA "Code\User\settings.json"

if (Test-Path $localSettings) {
    $localRaw = Get-Content $localSettings -Raw | ConvertFrom-Json
    $existingRaw = if (Test-Path $vsCodeSettingsPath) {
        Get-Content $vsCodeSettingsPath -Raw | ConvertFrom-Json
    } else {
        @{}
    }

    $localSettingsData = @{}
    $existingSettingsData = @{}

    foreach ($prop in $localRaw.PSObject.Properties) {
        $localSettingsData[$prop.Name] = $prop.Value
    }

    foreach ($prop in $existingRaw.PSObject.Properties) {
        $existingSettingsData[$prop.Name] = $prop.Value
    }

    foreach ($key in $localSettingsData.Keys) {
        $existingSettingsData[$key] = $localSettingsData[$key]
    }

    $existingSettingsData | ConvertTo-Json -Depth 10 | Set-Content $vsCodeSettingsPath -Encoding utf8
    Write-Host "VS Code settings updated."
} else {
    Write-Host "No local settings.json found in ./vscode. Skipping."
}

Write-Host "`n=== STEP 6: Running install.sh in WSL ==="
wsl -- bash -l -c "./install.sh; cd ~; exec zsh -l"
# Force UTF-8 output for consistency
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"
Clear-Host

Write-Output "==> DevShell Bootstrap Starting"

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    exit 1
}

Write-Host "`n=== STEP 1: Checking WSL & Ubuntu installation ==="

$wslDistros = wsl -l -q 2>$null

if ($wslDistros -contains "Ubuntu") {
    Write-Host "Ubuntu is already installed."
} else {
    Write-Host "Ubuntu not found. Installing..."
    wsl --install --distribution Ubuntu
    Write-Host "Reboot if prompted. Re-run this script after Ubuntu has initialized."
    Read-Host "Press Enter AFTER Ubuntu has been opened once and initialized..."
}

Write-Host "`n=== STEP 2: Installing Git ==="
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing via winget..."
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Git is already installed."
}

# Copy .gitconfig from a global config source path to the user's home directory (default global location)
$gitConfigSource = "C:\Path\To\Your\Global\.gitconfig"
$gitConfigDestination = Join-Path $env:USERPROFILE ".gitconfig"

if (Test-Path $gitConfigSource) {
    Copy-Item -Path $gitConfigSource -Destination $gitConfigDestination -Force
    Write-Host "Git configuration copied to $gitConfigDestination"
} else {
    Write-Host "Global .gitconfig not found at $gitConfigSource. Skipping copy."
}

Write-Host "`n=== STEP 3: Installing VS Code and Remote WSL Extension ==="

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "VS Code not found. Installing via winget..."
    winget install --id Microsoft.VisualStudioCode -e --source winget --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "VS Code is already installed."
}

$extName = "ms-vscode-remote.remote-wsl"
$installedExtensions = code --list-extensions

if ($installedExtensions -contains $extName) {
    Write-Host "Remote WSL extension already installed. Updating..."
    code --install-extension $extName --force
} else {
    Write-Host "Installing Remote WSL extension..."
    code --install-extension $extName
}

Write-Host "`n=== STEP 4: Updating VS Code Keybindings ==="

$localKeybindings = ".\vscode\keybindings.json"
$vsCodeKeybindingsPath = Join-Path $env:APPDATA "Code\User\keybindings.json"

if (Test-Path $localKeybindings) {
    $localBindings = Get-Content $localKeybindings -Raw | ConvertFrom-Json
    if ($localBindings -isnot [System.Collections.IEnumerable]) { $localBindings = @($localBindings) }

    if (Test-Path $vsCodeKeybindingsPath) {
        $existingBindings = Get-Content $vsCodeKeybindingsPath -Raw | ConvertFrom-Json
        if ($null -eq $existingBindings) { $existingBindings = @() }
        if ($existingBindings -isnot [System.Collections.IEnumerable]) {
            $existingBindings = @($existingBindings)
        }
    } else {
        $existingBindings = @()
    }

    $existingKeys = $existingBindings | ForEach-Object { $_.key }
    $toAdd = $localBindings | Where-Object { $existingKeys -notcontains $_.key }
    $mergedBindings = $existingBindings + $toAdd

    $mergedBindings | ConvertTo-Json -Depth 5 | Set-Content $vsCodeKeybindingsPath -Encoding utf8
    Write-Host "Keybindings merged."
} else {
    Write-Host "No local keybindings.json found in ./vscode. Skipping."
}

Write-Host "`n=== STEP 5: Updating VS Code Settings ==="

$localSettings = ".\vscode\settings.json"
$vsCodeSettingsPath = Join-Path $env:APPDATA "Code\User\settings.json"

if (Test-Path $localSettings) {
    $localRaw = Get-Content $localSettings -Raw | ConvertFrom-Json
    $existingRaw = if (Test-Path $vsCodeSettingsPath) {
        Get-Content $vsCodeSettingsPath -Raw | ConvertFrom-Json
    } else {
        @{}
    }

    $localSettingsData = @{}
    $existingSettingsData = @{}

    foreach ($prop in $localRaw.PSObject.Properties) {
        $localSettingsData[$prop.Name] = $prop.Value
    }

    foreach ($prop in $existingRaw.PSObject.Properties) {
        $existingSettingsData[$prop.Name] = $prop.Value
    }

    foreach ($key in $localSettingsData.Keys) {
        $existingSettingsData[$key] = $localSettingsData[$key]
    }

    $existingSettingsData | ConvertTo-Json -Depth 10 | Set-Content $vsCodeSettingsPath -Encoding utf8
    Write-Host "VS Code settings updated."
} else {
    Write-Host "No local settings.json found in ./vscode. Skipping."
}

Write-Host "`n=== STEP 6: Running install.sh in WSL ==="
wsl -- bash -l -c "./install.sh; cd ~; exec zsh -l"
