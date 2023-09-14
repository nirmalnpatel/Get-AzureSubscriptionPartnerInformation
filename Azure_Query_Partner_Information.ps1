
Connect-AzAccount

$subs = Get-AzSubscription

$output = @()

### Get accesss token from portal
$token = "Bearer eyJ0eXAiOiJ"


foreach ($sub in $subs)
{
### Get Partner Information
$partnerInfo = $null
$uri = "https://service.bmx.azure.com/api/Billing/Subscription/GetPartnerInformation?api-version=2019-01-14&subscriptionGuid=" + $sub.Id
$partnerInfo = Invoke-RestMethod -Method Get -Uri $uri -Headers @{ "Authorization" = $token }
$item = '' | Select-Object SubscriptionName,SubscriptionId,TenantId,partnerId,partnerName
$item.SubscriptionId = $sub.Id
$item.SubscriptionName = $sub.Name
$item.TenantId = $sub.TenantId
$item.partnerId = $partnerInfo.partnerId
$item.partnerName = $partnerInfo.partnerName
$item
$output += $item

}

$output | Export-Csv -Path C:\Temp\partnerinfo.csv -NoTypeInformation


### Remove Partner Information. Below 2 lines can be used for removing partner information from subscription
#$uri = "https://service.bmx.azure.com/api/Billing/Subscription/GetPartnerInformation?api-version=2019-01-14&subscriptionGuid=" + $sub.Id
#Invoke-RestMethod -Method Delete  -Uri $uri -Headers @{ "Authorization" = $token }

