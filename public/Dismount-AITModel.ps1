function Dismount-AITModel {
    <#
    .SYNOPSIS
    Unloads specific models from the AI Toolkit API.

    .DESCRIPTION
    The Dismount-AITModel command sends a GET request to the AI Toolkit API to unload specific models. This command can handle multiple models if provided in an array.

    .PARAMETER Model
    The names of the models to unload. Can be a single model name or an array of names.

    .PARAMETER Force
    Indicates whether to force the unloading of the model(s) even if they are in use.

    .EXAMPLE
    Dismount-AITModel -Model mistral-7b-v02-int4-cpu

    This command unloads the mistral-7b-v02-int4-cpu model from the AI Toolkit API.

    .EXAMPLE
    Dismount-AITModel -Model mistral-7b-v02-int4-cpu, gpt-3.5-turbo -Force

    This command forcefully unloads the mistral-7b-v02-int4-cpu and gpt-3.5-turbo models from the AI Toolkit API.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]$Model,
        [switch]$Force
    )
    process {
        foreach ($item in $Model) {
            Write-Verbose "Unloading model $item..."
            $endpoint = "$script:aitoolkitBaseUrl/openai/unload/$item"

            if ($Force) {
                $endpoint += "?force=true"
            }

            try {
                $splat = @{
                    Activity = "Unloading Models"
                    Status   = "Ubloading model $item"
                }
                Write-Progress @splat
                Invoke-RestMethod -Uri $endpoint
                if ($item -eq $script:mountedmodel) {
                    $script:mountedmodel = $null
                }
            } catch {
                throw $PSItem
            }
        }
    }
}
