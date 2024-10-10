# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

# Function to check if a font is installed
function Test-Font {
    param (
        [string]$FontName
    )
    $fontKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    return (Get-ItemProperty -Path $fontKey -Name "*$FontName*" -ErrorAction SilentlyContinue) -ne $null
}

# Function to install a Nerd Font
function Install-NerdFont {
    $fontName = "CaskaydiaCove NF"
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip"
    $tempZip = Join-Path $env:TEMP "CascadiaCode.zip"
    $tempFolder = Join-Path $env:TEMP "CascadiaCode"
    $fontFolder = "C:\Windows\Fonts"

    # Download the font
    Invoke-WebRequest -Uri $fontUrl -OutFile $tempZip

    # Extract the zip file
    Expand-Archive -Path $tempZip -DestinationPath $tempFolder -Force

    # Install the font
    $fontFile = Get-ChildItem -Path $tempFolder -Filter "CaskaydiaCoveNerdFont-Regular.ttf" -Recurse | Select-Object -First 1
    if ($fontFile) {
        $font = $fontFile.FullName
        $shell = New-Object -ComObject Shell.Application
        $shell.Namespace($fontFolder).CopyHere($font)
        Write-Host "Installed $fontName"
    } else {
        Write-Host "Font file not found in the downloaded package."
    }

    # Clean up
    Remove-Item $tempZip -Force
    Remove-Item $tempFolder -Recurse -Force
}

Write-Host "Setting up zsh-like environment in PowerShell..."

# Install Oh My Posh
Write-Host "Installing Oh My Posh..."
winget install JanDeDobbeleer.OhMyPosh -e

# Install PSReadLine
Write-Host "Installing PSReadLine..."
if (Get-Module -ListAvailable -Name PSReadLine) {
    Update-Module -Name PSReadLine -Force
} else {
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
}

# Install Terminal-Icons
Write-Host "Installing Terminal-Icons..."
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
}

# Check and install Nerd Font
$nerdFonts = @(
    "CaskaydiaCove NF",
    "DejaVuSansMono NF",
    "FiraCode NF",
    "Hack NF",
    "JetBrainsMono NF"
)

$installedNerdFonts = $nerdFonts | Where-Object { Test-Font $_ }

if ($installedNerdFonts) {
    Write-Host "Installed Nerd Fonts found:"
    $installedNerdFonts | ForEach-Object { Write-Host "- $_" }
} else {
    Write-Host "No Nerd Fonts found. Installing CaskaydiaCove NF..."
    Install-NerdFont
}

# Create or update PowerShell profile
$profileContent = @"
# Oh My Posh initialization
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\agnoster.omp.json" | Invoke-Expression

# PSReadLine configuration
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Emacs
}

# Import Terminal-Icons
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}
"@

$profilePath = $PROFILE.CurrentUserCurrentHost
if (!(Test-Path -Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force
}
Set-Content -Path $profilePath -Value $profileContent

# Update Oh My Posh to the latest version
Write-Host "Updating Oh My Posh..."
winget upgrade JanDeDobbeleer.OhMyPosh

Write-Host "`nSetup complete! Please restart your PowerShell session."
Write-Host "If you're using Windows Terminal, update your settings to use the Nerd Font:"
Write-Host @'
1. Open Windows Terminal settings (Ctrl+,)
2. Click on your PowerShell profile
3. Scroll down to "Appearance"
4. Change "Font face" to "CaskaydiaCove NF" (or your preferred Nerd Font)
5. Click "Save" and restart Windows Terminal
'@

Write-Host "`nTesting symbol display:"
Write-Host " Folder:  Networking:  Git: "

Write-Host "`nIf you still see question marks or boxes instead of symbols above, try the following:"
Write-Host "1. Make sure you've set your terminal font to CaskaydiaCove NF."
Write-Host "2. Restart your terminal after changing the font."
Write-Host "3. If issues persist, please seek further assistance."