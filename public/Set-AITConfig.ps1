function Set-AITConfig {
    <#
    .SYNOPSIS
    Sets the configuration values for the aitools module.

    .DESCRIPTION
    The Set-AITConfig cmdlet sets the configuration values for the aitools module, such as the base URL for the AI Toolkit API.

    .PARAMETER BaseUrl
    The base URL of the AI Toolkit API.

    .PARAMETER Model
    The name of the model to set as default.

    .EXAMPLE
    Set-AITConfig -BaseUrl http://localhost:8080

    This command sets the base URL for the AI Toolkit API to "http://localhost:8080".

    .EXAMPLE
    Set-AITConfig -Model mistral-7b-v02-int4-cpu

    This command sets the default model to mistral-7b-v02-int4-cpu.
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BaseUrl,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Model
    )

    if ($BaseUrl) {
        $script:aitoolsBaseUrl = $BaseUrl
    }

    if ($Model) {
        $script:mountedmodel = $Model
    }

    [pscustomobject]@{
        BaseUrl = $script:aitoolsBaseUrl
        Model = $script:mountedmodel
    }
}