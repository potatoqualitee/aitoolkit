#
# Module manifest for module 'aitoolkit'
#
# Generated by: Chrissy LeMaire
#
# Generated on: 4/7/2024
#
@{
    # Version number of this module.
    ModuleVersion     = '0.0.2'

    RootModule        = 'aitoolkit.psm1'

    # ID used to uniquely identify this module
    GUID              = 'be7e6a35-00ca-4d93-8f51-1cb47ab19dc6'

    # Author of this module
    Author            = 'Chrissy LeMaire'

    # Company or vendor of this module
    CompanyName       = 'cl'

    # Copyright statement for this module
    Copyright         = '2024'

    # Description of the functionality provided by this module
    Description       = 'PowerShell module for interacting with the AI Toolkit API'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @()

    FunctionsToExport = @(
        'Dismount-AITModel',
        'Get-AITModel',
        'Get-AITMountedModel',
        'Get-AITServer',
        'Mount-AITModel',
        'Request-AITChatCompletion',
        'Set-AITConfig',
        #'Start-AITServer',
        #'Stop-AITServer',
        'Test-AITServerStatus'
    )
    AliasesToExport   = @(
        'Load-AITModel',
        'Unload-AITModel'
    )

    PrivateData       = @{
        # PSData is module packaging and gallery metadata embedded in PrivateData
        # It's for rebuilding PowerShellGet (and PoshCode) NuGet-style packages
        # We had to do this because it's the only place we're allowed to extend the manifest
        # https://connect.microsoft.com/PowerShell/feedback/details/421837
        PSData = @{
            # The primary categorization of this module (from the TechNet Gallery tech tree).
            Category     = "AI"

            # Keyword tags to help users find this module via navigations and search.
            Tags         = @('ai', 'chatgpt', 'openai', 'api', 'ml')

            # The web address of an icon which can be used in galleries to represent this module
            IconUri      = ""

            # Indicates this is a pre-release/testing version of the module.
            IsPrerelease = 'False'
        }
    }
}