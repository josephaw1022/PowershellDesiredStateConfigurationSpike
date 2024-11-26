

Configuration DevEnvironment
{

    Import-DscResource -ModuleName @{ModuleName = "cChoco"; }

    Node localhost
    {


        # Install Chocolatey if it's not already installed
        cChocoInstaller InstallChoco {
            InstallDir = "C:\choco"
        }
        
        # Chocolatey Package List
        $packages = @(
            "headlamp"
        )

        # Install Each Package
        foreach ($package in $packages) {
            cChocoPackageInstaller $($package.Replace(".", "_")) {
                Name      = $package
                Ensure    = "Present"
                Source    = "https://community.chocolatey.org/api/v2/"
                DependsOn = "[cChocoInstaller]InstallChoco"
            }
        }



    }
}

# Generate the MOF file
DevEnvironment -OutputPath "C:\DSCConfigurations"
