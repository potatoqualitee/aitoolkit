function Get-AITModel {
    <#
    .SYNOPSIS
    Retrieves the list of available models from the AI Toolkit API.

    .DESCRIPTION
    The Get-AITModel cmdlet sends a GET request to the AI Toolkit API to retrieve the list of available models.

    .EXAMPLE
    Get-AITModel

    This command retrieves the list of available models from the AI Toolkit API.
    #>
    [CmdletBinding()]
    param()

    $endpoint = "$script:AIToolsBaseUrl/openai/models"

    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Get
        $response | Select-Object -ExpandProperty data
    } catch {
        Write-Error "Failed to retrieve models from the AI Toolkit API. Error: $($_.Exception.Message)"
    }
}