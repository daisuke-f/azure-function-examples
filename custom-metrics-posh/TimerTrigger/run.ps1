param($Timer, $TriggerMetadata)

# Import helper functions
. "$PSScriptRoot/../lib/Get-MSIAccessToken.ps1"
. "$PSScriptRoot/../lib/Send-CustomMetric.ps1"

$token = Get-MSIAccessToken

# Get subscription ID, resource group, and app name from environment variables.
# See: https://learn.microsoft.com/en-us/azure/app-service/reference-app-settings
$appName = $env:WEBSITE_SITE_NAME
$subscriptionId = $env:WEBSITE_OWNER_NAME.Substring(0, 36)
$resourceGroup = $env:WEBSITE_RESOURCE_GROUP
$region = $env:REGION_NAME.Replace(' ', '')

if ([string]::IsNullOrEmpty($resourceGroup)) {
    $resourceGroup = $env:APPSETTING_RESOURCE_GROUP

    if ([string]::IsNullOrEmpty($resourceGroup)) {
        throw "Resource group name is not set. Please set the resource group name as an app setting 'RESOURCE_GROUP'."
    }
}

$value = Get-Random -Minimum 1 -Maximum 100

$data = @{
    time = (Get-Date).ToUniversalTime().ToString("o")
    data = @{
        baseData = @{
            metric = "CustomMetric1"
            namespace = "CustomMetricsNamespace"
            # dimNames = @("Dimension1", "Dimension2")
            series = @(
                @{
                    # dimValues = @("Value1", "Value2")
                    min = $value
                    max = $value
                    sum = $value
                    count = 1
                }
            )
        }
    }
}

$params = @{
    Region      = $region
    ResourceId  = "subscriptions/${subscriptionId}/resourceGroups/${resourceGroup}/providers/Microsoft.Web/sites/${appName}"
    AccessToken = $token
    MetricData  = $data | ConvertTo-Json -Depth 5
}

Send-CustomMetric @params