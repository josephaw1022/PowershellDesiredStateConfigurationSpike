# Step 1: Install Chocolatey
Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Step 2: Install Git using Chocolatey
Write-Host "Installing Git..."
choco install git -y

# Step 3: Ensure Git is available in the current session
Write-Host "Waiting for Git to be available..."
Start-Sleep -Seconds 5  # Wait for 5 seconds to allow environment to update

# Verify Git is installed and available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not available in the current session. Restarting PowerShell..." -ForegroundColor Red
    exit 1
}

# Step 4: Ensure the source\repos directory exists
$reposDir = "C:\Users\$env:USERNAME\source\repos"
if (-not (Test-Path -Path $reposDir)) {
    Write-Host "Creating $reposDir..."
    New-Item -ItemType Directory -Path $reposDir
}

# Step 5: Clone the GitHub repository into the source\repos directory
Write-Host "Cloning the repository..."
$repoUrl = "https://github.com/josephaw1022/PowershellDesiredStateConfigurationSpike.git"
$cloneDir = "$reposDir\PowershellDesiredStateConfigurationSpike"
git clone $repoUrl $cloneDir

# Step 6: Run the SetupDSC.ps1 script from the cloned repository
Write-Host "Running SetupDSC.ps1..."
Set-Location -Path $cloneDir
.\SetupDSC.ps1

Write-Host "Setup completed successfully!"
