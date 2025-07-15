$zipUrl = "https://github.com/bergtobias/config/archive/refs/heads/main.zip"
$dest = "$env:USERPROFILE\config.zip"
$extractPath = "$env:USERPROFILE\config"

Invoke-WebRequest -Uri $zipUrl -OutFile $dest
Expand-Archive -Path $dest -DestinationPath $extractPath -Force
Remove-Item $dest

# The ZIP extracts to a subfolder named "config-main" — rename it:
Rename-Item -Path "$extractPath\config-main" -NewName "config"
Write-Host "Repository downloaded and extracted to $extractPath\config"