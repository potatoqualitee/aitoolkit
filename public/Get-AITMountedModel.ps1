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
    process {
        try {
            $loadedModels = Invoke-RestMethod -Uri "$script:AIToolsBaseUrl/openai/loadedmodels"
            foreach ($model in $loadedModels) {
                [PSCustomObject]@{
                    Model = $model
                }
            }
        } catch {
            throw $PSItem
        }
    }
}