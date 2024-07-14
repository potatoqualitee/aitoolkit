function Set-AITConfig {
    <#
    .SYNOPSIS
    Sets the configuration values for the aitools module.

    .DESCRIPTION
    The Set-AITConfig cmdlet sets the configuration values for the aitools module, such as the base URL for the AI Toolkit API.

    .PARAMETER BaseUrl
    The base URL of the AI Toolkit API.

    .EXAMPLE
    Set-AITConfig -BaseUrl "http://localhost:8080"

    This command sets the base URL for the AI Toolkit API to "http://localhost:8080".
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$BaseUrl
    )

    $script:aitoolsBaseUrl = $BaseUrl
    Write-Output "AI Toolkit API base URL set to '$script:aitoolsBaseUrl'."
}