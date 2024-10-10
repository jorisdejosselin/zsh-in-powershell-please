# Zsh-like PowerShell Setup

This repository contains a PowerShell script to set up a zsh-like environment in PowerShell on Windows. It installs and configures various tools to enhance your PowerShell experience.

## Features

- Installs Oh My Posh for a customizable prompt
- Installs PSReadLine for improved command-line editing
- Installs Terminal-Icons for file and folder icons
- Installs a Nerd Font (CaskaydiaCove NF) for proper symbol display
- Configures PowerShell profile with zsh-like settings

## Prerequisites

- Windows 10 or later
- PowerShell 5.1 or later
- Administrator privileges

## Installation

### Option 1: Remote Execution (Recommended)

You can run the script directly without cloning the repository. Open PowerShell as Administrator and run the following command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/jorisdejosselin/zsh-in-powershell-please/refs/heads/main/setup.ps1'))
```

This command will download and execute the script directly from the GitHub repository.

### Option 2: Local Execution

If you prefer to examine the script before running it:

1. Clone this repository or download the ZIP file and extract it.
2. Open PowerShell as Administrator.
3. Navigate to the directory containing the script.
4. Run the following command:

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; .\setup.ps1
   ```

5. Follow the on-screen instructions.

## Post-Installation

After running the script:

1. Restart your PowerShell session or Windows Terminal.
2. If using Windows Terminal, update your settings to use the Nerd Font:
   - Open Windows Terminal settings (Ctrl+,)
   - Click on your PowerShell profile
   - Scroll down to "Appearance"
   - Change "Font face" to "CaskaydiaCove NF"
   - Click "Save" and restart Windows Terminal

## Troubleshooting

If you encounter any issues or have questions, please open an issue in this repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.