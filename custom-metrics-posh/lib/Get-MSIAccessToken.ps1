function Get-MSIAccessToken {
    param (
        $Resource = "https://monitoring.azure.com/"
    )
    
    # see https://learn.microsoft.com/en-us/azure/app-service/reference-app-settings?tabs=kudu%2Cdotnet#managed-identity
    # see https://learn.microsoft.com/en-us/azure/app-service/overview-managed-identity?tabs=portal%2Chttp#rest-endpoint-reference
    $params = @{
        Uri = $env:IDENTITY_ENDPOINT +
            "?api-version=2019-08-01&resource=" +
            [Uri]::EscapeDataString($Resource)
        Method = 'GET'
        Headers = @{
            'X-IDENTITY-HEADER' = $env:IDENTITY_HEADER
        }
    }

    $params | ConvertTo-Json | Write-Verbose

    try {
        $token = Invoke-RestMethod @params
    } catch {
        throw [Exception]::new("Failed to acquire token from managed identity.", $Error[0].Exception)
    }

    $token.access_token | ConvertTo-SecureString -AsPlainText | Write-Output
}