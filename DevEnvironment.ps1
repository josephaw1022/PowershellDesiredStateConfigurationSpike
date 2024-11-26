

Configuration DevEnvironment
{

    Import-DscResource -ModuleName @{ModuleName = "cChoco"; RequiredVersion = "2.6.0.0" }

    Node localhost
    {


        # Install Chocolatey if it's not already installed
        cChocoInstaller InstallChoco {
            InstallDir = "C:\choco"
        }
        
        # Chocolatey Package List
        $packages = @(
            "7zip",
            "ansiblevaultcmd",
            "autohotkey",
            "azure-cli",
            "cilium-cli",
            "docker-desktop",
            "git",
            "golang",
            "go-task",
            "graalvm",
            "jq",
            "k3d",
            "k9s",
            "kind",
            "kubectx",
            "kubens",
            "kubernetes-cli",
            "headlamp",
            "kubernetes-helm",
            "make",
            "nmap",
            "nvm",
            "openjdk",
            "openssl",
            "pgadmin4",
            "podman-desktop",
            "python312",
            "vim"
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
