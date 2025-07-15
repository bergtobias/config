$zipUrl = "https://github.com/bergtobias/config/archive/refs/heads/main.zip"
$dest = ".\config.zip"
$extractPath = ".\"  # extract in current dir

Invoke-WebRequest -Uri $zipUrl -OutFile $dest
Expand-Archive -Path $dest -DestinationPath $extractPath -Force
Remove-Item $dest

$extractedFolder = ".\config-main"
$targetFolder = ".\config"

if (Test-Path $targetFolder) {
    Remove-Item -Path $targetFolder -Recurse -Force
}

if (Test-Path $extractedFolder) {
    Rename-Item -Path $extractedFolder -NewName "config"
} else {
    Write-Warning "Extracted folder '$extractedFolder' not found."
}

Write-Host "Repository downloaded and extracted to $targetFolder"
