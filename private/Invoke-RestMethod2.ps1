function Invoke-RestMethod2 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri,
        [Parameter(Mandatory = $true)]
        [ValidateSet("Get", "Post", "Put", "Delete")]
        [string]$Method,
        [object]$Body,
        [string]$ContentType = "application/json"
    )

    if (-not $script:aitoolsSession) {
        Connect-AIToolkit
    }

    $params = @{
        Uri         = $Uri
        Method      = $Method
        ContentType = $ContentType
        WebSession  = $script:aitoolsSession
    }

    if ($Body) {
        $params.Body = $Body
    }

    try {
        Invoke-RestMethod @params
    } catch {
        Write-Error "API request failed. Error: $($_.Exception.Message)"
    }
}
