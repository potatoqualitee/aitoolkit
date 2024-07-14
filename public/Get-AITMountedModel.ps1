function Get-AITMountedModel {
    <#
    .SYNOPSIS
    Retrieves the list of currently loaded models from the AI Toolkit API.

    .DESCRIPTION
    The Get-AITMountedModel cmdlet sends a GET request to the AI Toolkit API to retrieve the list of currently loaded models.

    .EXAMPLE
    Get-AITMountedModel

    This command retrieves the list of currently loaded models from the AI Toolkit API.
    #>
    [CmdletBinding()]
    param()

    $endpoint = "$script:aitoolsBaseUrl/openai/loadedmodels"

    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Get
        $models = $response | Select-Object -ExpandProperty data
        return $models
    } catch {
        Write-Error "Failed to retrieve loaded models from the AI Toolkit API. Error: $($_.Exception.Message)"
    }
}