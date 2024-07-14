function Mount-AITModel {
    <#
    .SYNOPSIS
    Loads specific models in the AI Toolkit API.

    .DESCRIPTION
    The Mount-AITModel command sends a GET request to the AI Toolkit API to load specific models. This command can handle multiple models if provided in an array.

    .PARAMETER Model
    The names of the models to load. Can be a single model name or an array of names.

    .PARAMETER Unload
    Indicates whether to unload a model if any are already loaded before loading new ones.

    .EXAMPLE
    Mount-AITModel -Model mistral-7b-v02-int4-cpu

    This command loads the mistral-7b-v02-int4-cpu model in the AI Toolkit API.

    .EXAMPLE
    Mount-AITModel -Model mistral-7b-v02-int4-cpu, gpt-3.5-turbo -Unload

    This command unloads any currently loaded models and then loads the mistral-7b-v02-int4-cpu and gpt-3.5-turbo models in the AI Toolkit API.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Model,
        [switch]$Unload
    )
    process {
        foreach ($item in $Model) {
            $endpoint = "$script:AIToolsBaseUrl/openai/load/$item"

            if ($Unload) {
                $endpoint += "?unload=true"
            }

            try {
                $splat = @{
                    Activity =  "Loading Models"
                    Status = "Loading model $item"
                }
                Write-Progress @splat
                Invoke-RestMethod -Uri $endpoint
                $script:mountedmodel = $item
            } catch {
                throw $PSItem
            }
        }
    }
}