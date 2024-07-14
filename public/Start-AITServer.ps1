function Start-AITServer {
<#
    .SYNOPSIS
    Starts the AI Toolkit server.

    .DESCRIPTION
    The Start-AITServer function starts the Inference Service Agent for the AI Toolkit. It attempts to locate the agent executable automatically, but also allows for a custom path to be specified.

    .PARAMETER Path
    Specifies the custom path to the Inference Service Agent executable. If not provided, the function will attempt to locate it automatically.

    .EXAMPLE
    Start-AITServer

    This example starts the AI Toolkit server using the default path.

    .EXAMPLE
    Start-AITServer -Path "/custom/path/to/Inference.Service.Agent"

    This example starts the AI Toolkit server using a custom path.

    .NOTES
    This function works across Windows, macOS, and Linux platforms.
#>
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Custom path to the Inference Service Agent executable")]
        [string]$Path
    )
    begin {
        if (-not $Path) {
            $extension = "ms-windows-ai-studio.windows-ai-studio-*"
            $possibleBasePaths = @(
                if ($PSVersionTable.Platform -eq "Win32NT") {
                    "$env:USERPROFILE\.vscode-insiders\extensions"
                    "$env:USERPROFILE\.vscode\extensions"
                } elseif ($IsMacOS) {
                    "$HOME/.vscode-insiders/extensions"
                    "$HOME/.vscode/extensions"
                } else {
                    "$HOME/.vscode-server-insiders/extensions"
                    "$HOME/.vscode-server/extensions"
                }
            )

            $agentName = if ($PSVersionTable.Platform -eq "Win32NT") { "Inference.Service.Agent.exe" } else { "Inference.Service.Agent" }

            $AgentPath = $null
            foreach ($basePath in $possibleBasePaths) {
                $extensionPath = [System.IO.Directory]::GetDirectories($basePath, $extension)
                if ($extensionPath) {
                    $potentialPath = Join-Path $extensionPath[0] "bin" $agentName
                    if (Test-Path $potentialPath) {
                        $AgentPath = $potentialPath
                        break
                    }
                }
            }

            if (-not $AgentPath) {
                throw "Inference Service Agent not found. Please specify the path manually using the -Path parameter."
            }
        } else {
            $AgentPath = $Path
        }
    }
    process {
        $processName = "Inference.Service.Agent"
        if (Get-Process -Name $processName -ErrorAction SilentlyContinue) {
            Write-Warning "The AI Toolkit server is already running."
            return
        }

        try {
            if ($PSVersionTable.Platform -eq "Win32NT") {
                Start-Process -FilePath $AgentPath -WindowStyle Hidden
            } else {
                # For Unix-like systems, we need to make sure the file is executable
                chmod +x $AgentPath
                Start-Process -FilePath $AgentPath
            }
            Write-Host "AI Toolkit server started successfully."
        } catch {
            Write-Error "Failed to start AI Toolkit server: $_"
        }
    }
}