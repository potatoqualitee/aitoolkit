function Start-AITServer {
<#
    .SYNOPSIS
    Starts the AI Toolkit server.

    .DESCRIPTION
    The Start-AITServer function starts the Inference Service Agent for the AI Toolkit. It attempts to locate the agent executable automatically, but also allows for a custom path to be specified.

    .PARAMETER Path
    Specifies the custom path to the Inference Service Agent executable. If not provided, the function will attempt to locate it automatically.

    .PARAMETER ModelsPath
    Specifies the custom model directory path. If not provided, the function will use the default path.

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
        [string]$Path,
        [Parameter(HelpMessage = "Custom model directory path")]
        [string]$ModelsPath,
        [switch]$NoStream
    )
    begin {
        Write-Verbose "Initializing Start-AITServer."
        if (-not $Path) {
            Write-Verbose "No custom path provided, attempting to locate the executable automatically."
            $extension = "ms-windows-ai-studio.windows-ai-studio-*"
            $possibleBasePaths = @(
                if ($PSVersionTable.Platform -notmatch "nix") {
                    "$env:USERPROFILE\.vscode-insiders\extensions"
                    "$env:USERPROFILE\.vscode\extensions"
                } else {
                    "$HOME/.vscode-insiders/extensions"
                    "$HOME/.vscode/extensions"
                }
            )

            $agentName = if ($PSVersionTable.Platform -notmatch "nix") {
                "Inference.Service.Agent.exe"
            } else {
                "Inference.Service.Agent"
            }

            $AgentPath = $null
            foreach ($basePath in $possibleBasePaths) {
                Write-Verbose "Checking path: $basePath"
                $extensionPath = [System.IO.Directory]::GetDirectories($basePath, $extension)
                if ($extensionPath) {
                    $potentialPath = Join-Path -Path $extensionPath[0] -ChildPath bin
                    $potentialPath = Join-Path -Path $potentialPath -ChildPath $agentName
                    if (Test-Path $potentialPath) {
                        $AgentPath = $potentialPath
                        Write-Verbose "Executable found at: $potentialPath"
                        break
                    }
                }
            }

            if (-not $AgentPath) {
                Write-Verbose "Executable not found, throwing error."
                throw "Inference Service Agent not found. Please specify the path manually using the -Path parameter."
            }
        } else {
            $AgentPath = $Path
            Write-Verbose "Using provided path: $Path"
        }
    }
    process {
        $inferenceAgentName = "Inference.Service.Agent"
        $workspaceAgentName = "WorkspaceAutomation.Agent"

        Write-Verbose "Checking if the processes are already running."
        if (Get-Process -Name $inferenceAgentName -ErrorAction SilentlyContinue) {
            Write-Warning "The Inference Service Agent is already running."
            return
        }

        if (Get-Process -Name $workspaceAgentName -ErrorAction SilentlyContinue) {
            Write-Warning "The Workspace Automation Agent is already running."
            return
        }

        try {
            $binPath = Split-Path -Parent $AgentPath
            $inferenceAgentPath = Join-Path $binPath $inferenceAgentName
            $workspaceAgentPath = Join-Path $binPath $workspaceAgentName

            if (-not $ModelsPath) {
                $ModelsPath = Join-Path $HOME ".aitk\models"
            }

            $usestream = (-not $NoStream).ToString().ToLower()

            $commonArgs = @(
                "--Logging:LogLevel:Default=Debug"
                "--urls", "$script:aitoolkitBaseUrl"
                "--OpenAIServiceSettings:ModelDirPath=$ModelsPath"
                "--OpenAIServiceSettings:UseChatCompletionStreamAlways=$usestream"
            )

            Write-Verbose "Starting Inference Service Agent using args: $commonArgs"
            try {
                $splat = @{
                    FilePath     = $inferenceAgentPath
                    ArgumentList = $commonArgs
                    WindowStyle  = "Hidden"
                    ErrorAction  = "Stop"
                }
                $null = Start-Process @splat

                [pscustomobject]@{
                    ProcessName = "Inference.Service.Agent"
                    Status      = "Started"
                }
            } catch {
                [pscustomobject]@{
                    ProcessName = "Inference.Service.Agent"
                    Status      = "Failed: $PSItem"
                }
            }


            Write-Verbose "Starting Workspace Automation Agent"
            try {
                $splat = @{
                    FilePath     = $workspaceAgentPath
                    ArgumentList = "--Logging:LogLevel:Default=Debug"
                    WindowStyle  = "Hidden"
                    ErrorAction  = "Stop"
                }
                $null = Start-Process @splat

                [pscustomobject]@{
                    ProcessName = "WorkspaceAutomation.Agent"
                    Status      = "Started"
                }
            } catch {
                [pscustomobject]@{
                    ProcessName = "WorkspaceAutomation.Agent"
                    Status      = "Failed: $PSItem"
                }
            }
        } catch {
            Write-Verbose "Failed to start the AI Toolkit servers."
            throw $PSItem
        }
    }
}