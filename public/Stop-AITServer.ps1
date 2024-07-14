function Stop-AITServer {
<#
.SYNOPSIS
Stops the AI Toolkit server.

.DESCRIPTION
The Stop-AITServer function stops the running Inference Service Agent for the AI Toolkit.

.EXAMPLE
Stop-AITServer

This example stops the running AI Toolkit server.

.NOTES
This function works across Windows, macOS, and Linux platforms.
#>
    [CmdletBinding()]
    param()
    process {
        try {
            $aiprocesses = Get-Process | Where-Object Path -match "extensions.*ai-studio"
            foreach ($aiprocess in $aiprocesses) {
                Stop-Process -Id $aiprocess.Id -Force
                [pscustomobject]@{
                    ProcessName = $aiprocess.ProcessName
                    Status = "Stopped"
                }
            }
        } catch {
            Write-Error "Failed to stop AI Toolkit server: $PSItem"
        }
    }
}