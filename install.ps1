$zipUrl = "https://github.com/bergtobias/config/archive/refs/heads/main.zip"
$dest = ".\config.zip"
$extractPath = ".\"  # Extract here

Invoke-WebRequest -Uri $zipUrl -OutFile $dest
Expand-Archive -Path $dest -DestinationPath $extractPath -Force
Remove-Item $dest

$extractedFolder = ".\config-main"
$targetFolder = ".\config"

# Remove existing 'config' folder if exists
if (Test-Path $targetFolder) {
    Remove-Item -Path $targetFolder -Recurse -Force
}

# Rename extracted folder
if (Test-Path $extractedFolder) {
    Rename-Item -Path $extractedFolder -NewName "config"
} else {
    Write-Warning "Extracted folder '$extractedFolder' not found."
}

Write-Host "Repository downloaded and extracted to $targetFolder"
