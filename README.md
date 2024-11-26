# PowerShell Desired State Configuration (DSC) for Development Environment

This repository automates the setup of a development environment using **PowerShell Desired State Configuration (DSC)** and **Chocolatey**.

## Features

- Automates the installation of development tools using **Chocolatey**.
- Ensures Chocolatey is installed if not already present.
- Supports adding or removing tools with minimal configuration changes.
- Uses DSC to apply the desired state, ensuring consistency across environments.

## Repository Structure

```plaintext
.
├── LCMConfig.ps1         # Configures the Local Configuration Manager (LCM)
├── DevEnvironment.ps1    # Declares the tools to be installed or removed
├── SetupDSC.ps1          # Orchestrates the entire DSC configuration process
├── LaptopSetup.ps1       # Installs Chocolatey, Git, and clones the repo
└── README.md             # This README file
```

## How to Use

1. Open the repository in PowerShell with **Administrator** permissions.
2. Run the following command to run the **LaptopSetup.ps1** script directly from the GitHub URL and set up your environment:

   ```powershell
   Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/josephaw1022/PowershellDesiredStateConfigurationSpike/main/LaptopSetup.ps1'))
   ```

3. The script will:
   - Install Chocolatey if it's not already installed.
   - Install Git.
   - Clone the repository.
   - Run the `SetupDSC.ps1` script to configure your development environment.