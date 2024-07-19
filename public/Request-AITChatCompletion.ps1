function Request-AITChatCompletion {
    <#
    .SYNOPSIS
    Creates a chat completion using the specified model and input in the AI Toolkit API.

    .DESCRIPTION
    The Request-AITChatCompletion cmdlet sends a POST request to the AI Toolkit API to create a chat completion using the specified model and input. It includes various parameters with defaults to fine-tune the AI's response.

    .PARAMETER Model
    The name of the model to use for the chat completion.

    .PARAMETER Message
    The input message for the chat completion.

    .PARAMETER Temperature
    The sampling temperature for generating the completion. Higher values result in more random outputs. Default is 0.7.

    .PARAMETER MaxToken
    The maximum number of tokens to generate in the completion. Default is 100.

    .PARAMETER TopP
    The cumulative probability threshold for token sampling. Default is 1.0.

    .PARAMETER FrequencyPenalty
    The penalty factor for repeated tokens. Default is 0.0.

    .PARAMETER PresencePenalty
    The penalty factor for new tokens not present in the input. Default is 0.0.

    .PARAMETER NoStream
    Indicates whether to disable streaming of the response. By default, streaming is enabled.

    .PARAMETER Raw
    Returns the raw API response instead of parsed content. Raw is only for non-streaming requests.

    .EXAMPLE
    Request-AITChatCompletion -Model mistral-7b-v02-int4-cpu -Message "Hello, how are you?"

    This command creates a chat completion using the mistral-7b-v02-int4-cpu model with the input message "Hello, how are you?" using default parameter settings.
    #>
    [CmdletBinding()]
    param(
        [string]$Model = $script:mountedmodel,
        [Parameter(Mandatory)]
        [string]$Message,
        [double]$Temperature = 0.7,
        [int]$MaxToken = 100,
        [double]$TopP = 1.0,
        [double]$FrequencyPenalty = 0.0,
        [double]$PresencePenalty = 0.0,
        [switch]$NoStream,
        [switch]$Raw
    )
    process {
        Write-Verbose "Starting Request-AITChatCompletion"

        if (-not $Model) {
            Write-Error "No model is currently loaded. Use the Mount-AITModel cmdlet to load a model."
            return
        }

        Write-Verbose "Using model: $Model"

        $endpoint = "$script:aitoolkitBaseUrl/v1/chat/completions"
        Write-Verbose "Endpoint: $endpoint"

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
            stream            = (-not $NoStream)
        }

        try {
            $splat = @{
                Uri         = $endpoint
                Method      = "POST"
                Body        = ($requestBody | ConvertTo-Json)
                ContentType = "application/json"
            }

            Write-Verbose "Sending request to AI Toolkit API"

            if ($NoStream) {
                Write-Progress -Activity "Requesting AI Chat Completion" -Status "Sending request..."
                $response = Invoke-RestMethod @splat
                Write-Progress -Activity "Requesting AI Chat Completion" -Status "Complete"

                if ($Raw) {
                    return $response
                } else {
                    # This is a simplified parsing. Adjust based on your actual response structure.
                    if ($response.choices -and $response.choices.Count -gt 0) {
                        return $response.choices[0].message.content
                    } else {
                        Write-Warning "Unexpected response structure"
                        return $response
                    }
                }
            } else {
                $responseStream = Invoke-WebRequest @splat -UseBasicParsing -ErrorAction Stop -TimeoutSec 0
                $reader = [System.IO.StreamReader]::new($responseStream.RawContentStream)
                $responseBuilder = [System.Text.StringBuilder]::new()

                while (-not $reader.EndOfStream) {
                    $line = $reader.ReadLine()
                    if ($line.StartsWith("data: ")) {
                        $data = $line.Substring(6)
                        if ($data -eq "[DONE]") {
                            break
                        }
                        
                        try {
                            $jsonData = $data | ConvertFrom-Json
                            $content = $jsonData.choices[0].delta.content
                            if ($content) {
                                Write-Host $content -NoNewline
                                $null = $responseBuilder.Append($content)
                            }
                        } catch {
                            Write-Error "Failed to parse JSON: $_"
                        }
                    }
                }
                return $responseBuilder.ToString()
            }
        } catch {
            throw $PSItem
        } finally {
            Write-Progress -Activity "Requesting AI Chat Completion" -Completed
        }
    }
}