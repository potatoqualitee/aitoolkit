function Install-ModuleIfNeeded {
    param (
        [string]$ModuleName
    )

    if (-not (Get-Command Get-AITServerPath -ErrorAction SilentlyContinue)) {
        $install = Read-Host "Module '$ModuleName' is not installed. Do you want to install it now? (Y/N)"
        if ($install -match 'Y|yes') {
            try {
                Install-Module -Name $ModuleName -Force -Scope CurrentUser
                Import-Module -Name $ModuleName -ErrorAction Stop
                return $true
            } catch {
                Write-Error "Failed to install or import module '$ModuleName'."
                return $false
            }
        } else {
            return $false
        }
    } else {
        return $true
    }
}