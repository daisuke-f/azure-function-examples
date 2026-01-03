function Send-CustomMetric {
    param (
        [string]$Region,
        [string]$ResourceId,
        [securestring]$AccessToken,
        [string]$MetricDataJson
    )

    # see https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/metrics-store-custom-rest-api
    $params = @{
        Method        = 'Post'
        Uri           = "https://${Region}.monitoring.azure.com/$($ResourceId.Trim('/'))/metrics"
        Authentication = 'Bearer'
        Token         = $AccessToken
        ContentType   = 'application/json'
        Body          = $MetricDataJson
    }

    try {
        $resp = Invoke-WebRequest @params
    } catch {
        throw
    }
}