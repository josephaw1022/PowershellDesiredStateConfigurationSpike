[DscLocalConfigurationManager()]
Configuration LCMConfig
{
    Node localhost
    {
        Settings
        {
            AllowModuleOverwrite = $true
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RebootNodeIfNeeded = $false
        }
    }
}

# Compile the LCM configuration to generate the necessary MOF files
LCMConfig -OutputPath "C:\DSCConfigurations"