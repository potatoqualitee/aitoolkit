
$script:PSModuleRoot = $script:ModuleRoot = $PSScriptRoot
$script:aitoolkitBaseUrl = "http://localhost:5272"

function Import-ModuleFile {
    [CmdletBinding()]
    Param (
        [string]$Path
    )
    if ($doDotSource) { . $Path }
    else { $ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText($Path))), $null, $null) }
}

# Import all internal functions
foreach ($function in (Get-ChildItem "$ModuleRoot\private\" -Filter "*.ps1" -Recurse -ErrorAction Ignore)) {
    . Import-ModuleFile -Path $function.FullName
}

# Import all public functions
foreach ($function in (Get-ChildItem "$ModuleRoot\public" -Filter "*.ps1" -Recurse -ErrorAction Ignore)) {
    . Import-ModuleFile -Path $function.FullName
}

try {
    if (-not $PSDefaultParameterValues['Invoke-RestMethod:TimeoutSec']) {
        $removetimeout = $true
        $PSDefaultParameterValues['Invoke-RestMethod:TimeoutSec'] = 1
    }
    $script:mountedmodel = Get-AITMountedModel -ErrorAction Stop | Select-Object -Last 1 -ExpandProperty Model
    if ($removetimeout) {
        $null = $PSDefaultParameterValues.Remove('Invoke-RestMethod:TimeoutSec')
    }
} catch {
    # don't care
}