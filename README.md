# PowerShell Desired State Configuration (DSC) for Development Environment

This repository automates the setup of a development environment using **PowerShell Desired State Configuration (DSC)** and **Chocolatey**.

## Repository Structure

```plaintext
.
├── LCMConfig.ps1         # Configures the Local Configuration Manager (LCM)
├── DevEnvironment.ps1    # Declares the tools to be installed or removed
├── SetupDSC.ps1          # Orchestrates the entire DSC configuration process
└── README.md             # This README file
```

## How to Use

1. Open the repository in PowerShell with **Administrator** permissions.
2. Run the following command to configure and install the development environment tools:

   ```powershell
   .\SetupDSC.ps1
   ```