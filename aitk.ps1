# API URL and Headers
$apiUrl = 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery'
$headers = @{
    'Content-Type' = 'application/json'
    'Accept'       = 'application/json; api-version=6.0-preview.1'
}

# Request Body
$body = @{
    filters    = @(
        @{
            criteria   = @(
                @{
                    filterType = 8
                    value      = "Microsoft.VisualStudio.Code"
                },
                @{
                    filterType = 10
                    value      = "ms-windows-ai-studio.windows-ai-studio"
                }
            )
            pageNumber = 1
            pageSize   = 1
            sortBy     = 0
            sortOrder  = 0
        }
    )
    assetTypes = @()
    flags      = 0
} | ConvertTo-Json -Depth 10

# Send the request
$response = Invoke-RestMethod -Method Post -Uri $apiUrl -Headers $headers -Body $body

# Extracting the latest version
$version = $response.results.extensions.versions.version | Select-Object -First 1

$url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-windows-ai-studio/vsextensions/windows-ai-studio/$version/vspackage?targetPlatform="

# Construct download URL for a specific platform, e.g., win32-x64
foreach ($os in @('win32-x64','win32-arm64','linux-x64')) {
    
}