# Get-AzureSubscriptionPartnerInformation
Get Azure Subscription Partner Information
Use this script to query partner information for all the subscriptions under your Azure tenant.

Note: If there is no partner information set on a subscription, you will see an error "Unable to access the partner information at the moment. Please try again later. SubscriptionId: xxxxxxx" This will be the case for each subscription that you run the script for and there is no partner information set. If the partner information is available, it will added to the putput

