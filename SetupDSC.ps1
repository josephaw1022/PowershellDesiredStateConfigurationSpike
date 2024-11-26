# Ensure running as Admin for setting policies
Function Test-ProcessAdminRights {
    $adminCheck = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $adminCheck.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# If not running as admin, restart the script with admin rights
If (-not (Test-ProcessAdminRights)) {
    Write-Host "Script is not running with administrator rights. Restarting with elevated privileges..."
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    Exit
}

# Step 1: Force Execution Policy to Bypass for all scopes
Write-Host "Setting Execution Policy to Bypass for all scopes..."
Set-ExecutionPolicy Bypass -Scope Process -Force
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
Set-ExecutionPolicy Bypass -Scope LocalMachine -Force

# Step 2: Manually override the registry if policies override settings
Write-Host "Attempting to modify Execution Policy registry settings..."
$ExecutionPolicyRegistryPath = "HKCU:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"

# Override policy if necessary
if (Test-Path $ExecutionPolicyRegistryPath) {
    Set-ItemProperty -Path $ExecutionPolicyRegistryPath -Name ExecutionPolicy -Value "Bypass"
} else {
    Write-Host "Execution Policy registry path not found. Attempting to create it..."
    New-Item -Path "HKCU:\Software\Microsoft\PowerShell\1\ShellIds" -Force
    Set-ItemProperty -Path $ExecutionPolicyRegistryPath -Name ExecutionPolicy -Value "Bypass"
}

# Repeat same for the Local Machine (machine-wide policy)
$ExecutionPolicyMachinePath = "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
if (Test-Path $ExecutionPolicyMachinePath) {
    Set-ItemProperty -Path $ExecutionPolicyMachinePath -Name ExecutionPolicy -Value "Bypass"
} else {
    Write-Host "Execution Policy machine registry path not found. Attempting to create it..."
    New-Item -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds" -Force
    Set-ItemProperty -Path $ExecutionPolicyMachinePath -Name ExecutionPolicy -Value "Bypass"
}

Write-Host "Execution Policy set to Bypass at all scopes (and registry override)."

# Now, continue with the rest of your script
Write-Host "Setting script directory to current location..."
Set-Location -Path "$PSScriptRoot"

# Ensure the cChoco Module is installed
Write-Host "Ensuring cChoco module is installed..."
if (-not (Get-Module -ListAvailable -Name cChoco)) {
    Write-Host "cChoco module not found. Installing from PowerShell Gallery..."
    Install-Module -Name cChoco -RequiredVersion 2.6.0.0 -Scope AllUsers -Force
} else {
    Write-Host "cChoco module is already installed."
}

# Ensure WinRM is configured for DSC
Write-Host "Ensuring WinRM is configured for DSC..."
winrm quickconfig -q

# Run LCMConfig.ps1 to configure the Local Configuration Manager (LCM)
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

# Run DevEnvironment.ps1 to install development environment tools
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
