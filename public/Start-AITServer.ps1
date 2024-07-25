function Start-AITServer {
    <#
    .SYNOPSIS
    Starts the AI Toolkit server.

    .DESCRIPTION
    The Start-AITServer function starts the Inference Service Agent for the AI Toolkit. It attempts to locate the agent executable automatically, but also allows for a custom path to be specified.

    .PARAMETER Path
    Specifies the custom path to the Inference Service Agent executable. If not provided, the function will attempt to locate it automatically.

    .PARAMETER ModelDirPath
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
        [string]$ModelPath,
        [switch]$Standalone,
        [switch]$NoStream
    )
    begin {
        $executable = if ($PSVersionTable.Platform -notmatch "nix") {
            "Inference.Service.Agent.exe"
        } else {
            "Inference.Service.Agent"
        }

        if ($Path) {
            $agentpath = $Path
            Write-Verbose "Using provided path: $Path"
        } else {
            if ($Standalone) {
                if ((Install-ModuleIfNeeded -ModuleName 'aitoolkit.server')) {
                    try {
                        $agentpath = Get-AITServerPath
                        Write-Verbose "Using AIT server path: $agentpath"
                    } catch {
                        throw "Failed to get AIT server path. Please specify the path manually using the -Path parameter."
                    }
                } else {
                    throw "Inference Service Agent not found. Please specify the path manually using the -Path parameter."
                }
            } else {
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

                $agentpath = $null
                foreach ($basePath in $possibleBasePaths) {
                    Write-Verbose "Checking path: $basePath"
                    $extensionPath = [System.IO.Directory]::GetDirectories($basePath, $extension)
                    if ($extensionPath) {
                        $potentialPath = Join-Path -Path $extensionPath[0] -ChildPath bin
                        $potentialPath = Join-Path -Path $potentialPath -ChildPath $executable
                        if (Test-Path $potentialPath) {
                            $agentpath = $potentialPath
                            Write-Verbose "Executable found at: $potentialPath"
                            break
                        }
                    }
                }

                if (-not $agentpath) {
                    Write-Verbose "Executable not found in the default paths."
                    if ((Install-ModuleIfNeeded -ModuleName 'aitoolkit.server')) {
                        try {
                            $agentpath = Get-AITServerPath
                        } catch {
                            throw "Failed to get AIT server path. Please specify the path manually using the -Path parameter."
                        }
                    } else {
                        throw "Inference Service Agent not found. Please specify the path manually using the -Path parameter."
                    }
                }
            }
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
            if ($Standalone) {
                $binPath = $agentpath
            } else {
                $binPath = Split-Path -Parent $agentpath
            }

            $inferenceAgentPath = Join-Path $binPath $inferenceAgentName
            $workspaceAgentPath = Join-Path $binPath $workspaceAgentName

            Write-Verbose "Inference Service Agent path: $inferenceAgentPath"
            Write-Verbose "Workspace Automation Agent path: $workspaceAgentPath"

            if (-not $ModelPath) {
                $ModelPath = Join-Path $HOME ".aitk\models"
            }

            # if model path matches \ then escape it
            $ModelPath = $ModelPath -replace '\\', '/'
            $ModelPath = "$ModelPath".ToLower()

            Write-Verbose "Model directory path: $ModelPath"

            $usestream = "$(-not $NoStream)".ToLower()

            $logPath = Join-Path $HOME "aitoolkit_logs"
            New-Item -ItemType Directory -Force -Path $logPath | Out-Null

            $commonArgs = @(
                "--Logging:LogLevel:Default=Debug"
                "--Logging:LogLevel:Microsoft=Warning"
                "--Logging:LogLevel:Microsoft.Hosting.Lifetime=Information"
                "--Logging:File:Path=$logPath/log-{Date}.txt"
                "--Logging:File:FileSizeLimitBytes=10485760"
                "--Logging:File:MaxRollingFiles=5"
                "--urls", "$script:aitoolkitBaseUrl"
                "--OpenAIServiceSettings:ModelDirPath=$ModelPath"
                "--OpenAIServiceSettings:UseChatCompletionStreamAlways=$usestream"
            )

            Write-Verbose "Starting Inference Service Agent using args: $commonArgs"
            try {
                $splat = @{
                    FilePath     = $inferenceAgentPath
                    ArgumentList = $commonArgs
                    # WindowStyle  = "Hidden"
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
                    #WindowStyle  = "Hidden"
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