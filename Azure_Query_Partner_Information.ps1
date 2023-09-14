<#
-----------------------------------------------------------------------------
LEGAL DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys’ fees, that arise or result
from the use or distribution of the Sample Code.
 
This posting is provided "AS IS" with no warranties, and confers no rights. Use
of included script samples are subject to the terms specified
at http://www.microsoft.com/info/cpyright.htm.
-----------------------------------------------------------------------------
#>


#Use this script to query partner information for all the subscriptions under your Azure tenant.

Connect-AzAccount
$subs = Get-AzSubscription
$output = @()

### For this script to work you must get a token from the Azure portal by going to Subscription->Partner Informatin page while you have browser's developer tools open. Copy the bearer token and insert into below line start from "ey...". Getting a token using Get-AzAccessToken will not work.
$token = "Bearer eyXXXXXX"

foreach ($sub in $subs)
{
    ### Get Partner Information
    $partnerInfo = $null
    $uri = "https://service.bmx.azure.com/api/Billing/Subscription/GetPartnerInformation?api-version=2019-01-14&subscriptionGuid=" + $sub.Id
    #   Note: If there is no partner information set on a subscription, you will see an error "Unable to access the partner information at the moment. Please try again later. SubscriptionId: xxxxxxx" 
    #   This will be the case for each subscription that you run the script for and there is no partner information set. 
    #   If the partner information is set on a subscription, it will be added to the putput.
    $partnerInfo = Invoke-RestMethod -Method Get -Uri $uri -Headers @{ "Authorization" = $token } -ErrorAction Continue

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


### Remove Partner Information. Below 2 lines can be used for removing partner information from subscriptions. Modiby above scripts as required.
### Warning this will remove partner information. Ensure you have a backup of the currenet partner information values if required.
#$uri = "https://service.bmx.azure.com/api/Billing/Subscription/GetPartnerInformation?api-version=2019-01-14&subscriptionGuid=" + $sub.Id
#Invoke-RestMethod -Method Delete  -Uri $uri -Headers @{ "Authorization" = $token }


