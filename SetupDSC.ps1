# Check if the script is running with administrator rights
Function Test-ProcessAdminRights {
    $adminCheck = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $adminCheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Ensure the script runs with admin rights
If (-not (Test-ProcessAdminRights)) {
    Write-Host "Script is not running with administrator rights. Restarting with elevated privileges..."
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    Exit
}

# Ensure the script runs in the correct directory
Write-Host "Setting script directory to current location..."
Set-Location -Path "$PSScriptRoot"

# Step 1: Ensure cChoco Module is Installed
Write-Host "Ensuring cChoco module is installed..."
if (-not (Get-Module -ListAvailable -Name cChoco)) {
    Write-Host "cChoco module not found. Installing from PowerShell Gallery..."
    Install-Module -Name cChoco -RequiredVersion 2.6.0.0 -Scope AllUsers -Force
} else {
    Write-Host "cChoco module is already installed."
}

# Step 2: Ensure WinRM is Configured for DSC (Simplified)
Write-Host "Ensuring WinRM is configured for DSC..."
# Enable WinRM service (needed for DSC to work)
winrm quickconfig -q

# Step 3: Run LCMConfig.ps1 to configure the Local Configuration Manager (LCM)
Write-Host "Running LCMConfig.ps1 to configure LCM..."
if (Test-Path ".\LCMConfig.ps1") {
    .\LCMConfig.ps1
    if (Test-Path "C:\DSCConfigurations\localhost.meta.mof") {
        Write-Host "Applying LCM configuration..."
        Set-DscLocalConfigurationManager -Path "C:\DSCConfigurations" -Verbose
    } else {
        Write-Host "LCM configuration not generated. Ensure LCMConfig.ps1 created the MOF file." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "LCMConfig.ps1 not found. Please ensure the file exists in the current directory." -ForegroundColor Red
}

# Step 4: Run DevEnvironment.ps1 to install development environment tools
Write-Host "Running DevEnvironment.ps1 to install development environment tools..."

if (Test-Path ".\DevEnvironment.ps1") {
    .\DevEnvironment.ps1
    if (Test-Path "C:\DSCConfigurations\localhost.mof") {
        Write-Host "Applying DevEnvironment configuration..."
        Start-DscConfiguration -Path "C:\DSCConfigurations" -Wait -Verbose -Force
    } else {
        Write-Host "DevEnvironment configuration not generated. Ensure DevEnvironment.ps1 created the MOF file." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "DevEnvironment.ps1 not found. Please ensure the file exists in the current directory." -ForegroundColor Red
}

Write-Host "DSC configuration completed successfully." -ForegroundColor Green
exit 0
