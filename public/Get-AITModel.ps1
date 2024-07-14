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
    process {
        try {
            foreach ($model in (Invoke-RestMethod -Uri "$script:AIToolsBaseUrl/openai/models")) {
                [PSCustomObject]@{
                    Model = $model
                }
            }
        } catch {
            throw $PSItem
        }
    }
}