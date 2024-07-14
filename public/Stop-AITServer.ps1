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
        $processName = "Inference.Service.Agent"
        $process = Get-Process | Where-Object { $_.ProcessName -eq $processName -or $_.ProcessName -eq $processName.Replace(".exe", "") }

        if ($process) {
            try {
                Stop-Process -InputObject $process -Force
                Write-Host "AI Toolkit server stopped successfully."
            } catch {
                Write-Error "Failed to stop AI Toolkit server: $_"
            }
        } else {
            Write-Warning "The AI Toolkit server is not currently running."
        }
    }
}