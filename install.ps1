$zipUrl = "https://github.com/bergtobias/config/archive/refs/heads/main.zip"
$dest = ".\config.zip"
$extractParent = "."  # Extract to current directory

Invoke-WebRequest -Uri $zipUrl -OutFile $dest
Expand-Archive -Path $dest -DestinationPath $extractParent -Force
Remove-Item $dest

# Rename extracted folder from 'config-main' to 'config'
Rename-Item -Path ".\config-main" -NewName "config"

Write-Host "Repository downloaded and extracted to .\config"
