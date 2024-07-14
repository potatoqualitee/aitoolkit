function Get-AITServer {
    <#
.SYNOPSIS
Gets the AI Toolkit server processes.

.DESCRIPTION
The Get-AITServer function retrieves the running Inference Service Agent processes for the AI Toolkit.

.EXAMPLE
Get-AITServer

This example gets the running AI Toolkit server processes.

.NOTES
This function works across Windows, macOS, and Linux platforms.
#>
    [CmdletBinding()]
    param()
    process {
        try {
            $aiprocesses = Get-Process | Where-Object Path -match "extensions.*ai-studio"
            foreach ($aiprocess in $aiprocesses) {
                [pscustomobject]@{
                    ProcessName = $aiprocess.ProcessName
                    Id          = $aiprocess.Id
                    Path        = $aiprocess.Path
                    CPU         = $aiprocess.CPU
                    Memory      = $aiprocess.WorkingSet64 / 1MB  # Convert to MB
                    StartTime   = $aiprocess.StartTime
                }
            }

            if (-not $aiprocesses) {
                Write-Host "No AI Toolkit server processes found."
            }
        } catch {
            Write-Error "Failed to get AI Toolkit server processes: $PSItem"
        }
    }
}