function Dismount-AITModel {
    <#
    .SYNOPSIS
    Unloads a specific model from the AI Toolkit API.

    .DESCRIPTION
    The Dismount-AITModel cmdlet sends a GET request to the AI Toolkit API to unload a specific model.

    .PARAMETER Model
    The name of the model to unload.

    .PARAMETER Force
    Indicates whether to force the unloading of the model even if it is in use.

    .EXAMPLE
    Dismount-AITModel -Model "gpt-3.5-turbo"

    This command unloads the "gpt-3.5-turbo" model from the AI Toolkit API.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Model,
        [switch]$Force
    )

    $baseUrl = $script:AIToolsBaseUrl
    $endpoint = "$baseUrl/openai/unload/$Model"

    if ($Force) {
        $endpoint += "?force=true"
    }

    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Get
        Write-Output "Model '$Model' unloaded successfully."
    }
    catch {
        Write-Error "Failed to unload model '$Model'. Error: $($_.Exception.Message)"
    }
}