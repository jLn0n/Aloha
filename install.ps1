# PowerShell script to install Lune (v0.8.9) and StyLua (v0.20.0) on Windows

$luneUrl = "https://github.com/lune-org/lune/releases/download/v0.8.9/lune-0.8.9-windows-x86_64.zip"
$styluaUrl = "https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-windows-x86_64.zip"

$luneZipPath = "$PSScriptRoot\lune-0.8.9-windows-x86_64.zip"
$styluaZipPath = "$PSScriptRoot\stylua-windows-x86_64.zip"
$luneExtractPath = "$PSScriptRoot\"
$styluaExtractPath = "$PSScriptRoot\"

Write-Output "Downloading Lune from $luneUrl..."
Invoke-WebRequest -Uri $luneUrl -OutFile $luneZipPath

Write-Output "Unzipping Lune..."
Expand-Archive -Path $luneZipPath -DestinationPath $luneExtractPath -Force

Remove-Item -Path $luneZipPath

Write-Output "Lune has been downloaded and unzipped to $luneExtractPath."

Write-Output "Downloading StyLua from $styluaUrl..."
Invoke-WebRequest -Uri $styluaUrl -OutFile $styluaZipPath

Write-Output "Unzipping StyLua..."
Expand-Archive -Path $styluaZipPath -DestinationPath $styluaExtractPath -Force

Remove-Item -Path $styluaZipPath

Write-Output "StyLua has been downloaded and unzipped to $styluaExtractPath."
Write-Output "Installation complete! Lune and StyLua are ready for use."