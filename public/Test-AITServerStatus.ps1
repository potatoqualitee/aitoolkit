function Test-AITServerStatus {
    <#
    .SYNOPSIS
    Tests the connection to the AI Toolkit server.

    .DESCRIPTION
    This function attempts to connect to the AI Toolkit server and retrieve the list of available models.
    It serves as a quick check to ensure the server is running and responsive.

    .PARAMETER ServerUrl
    The URL of the AI Toolkit server. Defaults to "http://localhost:5272".

    .PARAMETER TimeoutSec
    The timeout in seconds for the connection attempt. Defaults to 1 second.

    .EXAMPLE
    Test-AITServerStatus

    This example tests the connection to the default server URL.

    .EXAMPLE
    Test-AITServerStatus -ServerUrl "http://localhost:8080"

    This example tests the connection to a custom server URL.
    #>

    [CmdletBinding()]
    param(
        [string]$ServerUrl = "http://localhost:5272",
        [int]$TimeoutSec = 1
    )

    try {
        $splat = @{
            Uri         = "$ServerUrl/openai/models"
            ErrorAction = "Stop"
            TimeoutSec  = $TimeoutSec
        }
        $null = Invoke-RestMethod @splat
        return $true
    } catch {
        Write-Verbose "Failed to connect to AI Toolkit server: $PSItem"
        return $false
    }
}