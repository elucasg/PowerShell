
# Disable office web apps for your entire SharePoint environment
Remove-SPWOPIBinding -all $true

# Disable the office web apps for single site collection
$webAppsFeatureId = $(Get-SPFeature -limit all | where {$_.displayname -eq "OfficeWebApps"}).Id 
$singleSiteCollection = Get-SPSite -Identity http://<site_name> 
Disable-SPFeature $webAppsFeatureId -Url $singleSiteCollection.URL

# Enable opening documents in client applications at Site collection level:
#  - Log into SharePoint site >> Go to Site Settings.
#  - Click Site collection features under Site Collection Administration section.
#  - Activate "Open Documents in Client Application by Default" feature
