# This is meant to be referenced in the instructions of the readme
# This script will install Chocolatey, Git, clone the repository, and run the SetupDSC.ps1 script

# Step 1: Install Chocolatey
Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Step 2: Install Git using Chocolatey
Write-Host "Installing Git..."
choco install git -y

# Step 3: Ensure the source\repos directory exists
$reposDir = "C:\Users\$env:USERNAME\source\repos"
if (-not (Test-Path -Path $reposDir)) {
    Write-Host "Creating $reposDir..."
    New-Item -ItemType Directory -Path $reposDir
}

# Step 4: Clone the GitHub repository into the source\repos directory
Write-Host "Cloning the repository..."
$repoUrl = "https://github.com/josephaw1022/PowershellDesiredStateConfigurationSpike.git"
$cloneDir = "$reposDir\PowershellDesiredStateConfigurationSpike"
git clone $repoUrl $cloneDir

# Step 5: Run the SetupDSC.ps1 script from the cloned repository
Write-Host "Running SetupDSC.ps1..."
Set-Location -Path $cloneDir
.\SetupDSC.ps1

Write-Host "Setup completed successfully!"
