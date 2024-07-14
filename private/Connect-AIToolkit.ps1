function Connect-AIToolkit {
    [CmdletBinding()]
    param(
        [string]$BaseUrl = $script:aitoolsBaseUrl
    )

    $script:aitoolsBaseUrl = $BaseUrl
    $script:aitoolsSession = New-RestSessionHelper -BaseUri $script:aitoolsBaseUrl
}
