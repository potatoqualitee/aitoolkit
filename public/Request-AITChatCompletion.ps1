function Request-AITChatCompletion {
    <#
    .SYNOPSIS
    Creates a chat completion using the specified model and input in the AI Toolkit API.

    .DESCRIPTION
    The Request-AITChatCompletion cmdlet sends a POST request to the AI Toolkit API to create a chat completion using the specified model and input.

    .PARAMETER Model
    The name of the model to use for the chat completion.

    .PARAMETER Message
    The input message for the chat completion.

    .PARAMETER Temperature
    The sampling temperature for generating the completion. Higher values result in more random outputs.

    .PARAMETER MaxToken
    The maximum number of tokens to generate in the completion.

    .PARAMETER TopP
    The cumulative probability threshold for token sampling.

    .PARAMETER FrequencyPenalty
    The penalty factor for repeated tokens.

    .PARAMETER PresencePenalty
    The penalty factor for new tokens not present in the input.

    .PARAMETER Stream
    Indicates whether to receive the completion as a stream of tokens.

    .EXAMPLE
    Request-AITChatCompletion -Model "gpt-3.5-turbo" -Message "Hello, how are you?"

    This command creates a chat completion using the "gpt-3.5-turbo" model with the input message "Hello, how are you?".
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Model,
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [double]$Temperature,
        [int]$MaxToken,
        [double]$TopP,
        [double]$FrequencyPenalty,
        [double]$PresencePenalty,
        [switch]$Stream
    )

    $endpoint = "$script:aitoolsBaseUrl/v1/chat/completions"

    $requestBody = @{
        model             = $Model
        messages          = @(
            @{
                role    = "user"
                content = $Message
            }
        )
        temperature       = $Temperature
        max_tokens        = $MaxToken
        top_p             = $TopP
        frequency_penalty = $FrequencyPenalty
        presence_penalty  = $PresencePenalty
        stream            = $Stream.IsPresent
    }

    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Post -Body ($requestBody | ConvertTo-Json) -ContentType "application/json"
        return $response
    } catch {
        Write-Error "Failed to create chat completion. Error: $($_.Exception.Message)"
    }
}