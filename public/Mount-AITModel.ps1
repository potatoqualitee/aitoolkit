function Mount-AITModel {
    <#
    .SYNOPSIS
    Loads a specific model in the AI Toolkit API.

    .DESCRIPTION
    The Mount-AITModel cmdlet sends a GET request to the AI Toolkit API to load a specific model.

    .PARAMETER Model
    The name of the model to load.

    .PARAMETER Unload
    Indicates whether to unload the model if it is already loaded.

    .EXAMPLE
    Mount-AITModel -Model "gpt-3.5-turbo"

    This command loads the "gpt-3.5-turbo" model in the AI Toolkit API.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Model,
        [switch]$Unload
    )

    $baseUrl = $script:AIToolsBaseUrl
    $endpoint = "$baseUrl/openai/load/$Model"

    if ($Unload) {
        $endpoint += "?unload=true"
    }

    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Get
        Write-Output "Model '$Model' loaded successfully."
    } catch {
        Write-Error "Failed to load model '$Model'. Error: $($_.Exception.Message)"
    }
}