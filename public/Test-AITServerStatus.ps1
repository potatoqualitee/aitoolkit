function Test-AITServerStatus {
    <#
    .SYNOPSIS
    Tests the connection to the AI Toolkit server.

    .DESCRIPTION
    This function attempts to connect to the AI Toolkit server and retrieve the list of available models.
    It serves as a quick check to ensure the server is running and responsive.

    .PARAMETER ServerUrl
    The URL of the AI Toolkit server. Defaults to "http://localhost:5272".

    .EXAMPLE
    Test-AITServerStatus

    This example tests the connection to the default server URL.

    .EXAMPLE
    Test-AITServerStatus -ServerUrl "http://localhost:8080"

    This example tests the connection to a custom server URL.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$ServerUrl = "http://localhost:5272"
    )

    try {
        $null = Invoke-RestMethod -Uri "$ServerUrl/openai/models" -Method Get -ErrorAction Stop
        return $true
    } catch {
        Write-Error "Failed to connect to AI Toolkit server: $_"
        return $false
    }
}