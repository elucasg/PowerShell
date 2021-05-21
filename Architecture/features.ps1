Add-PsSnapin "Microsoft.SharePoint.PowerShell"

# List all installed features
Get-SPFeature | Sort -Property DisplayName

# List all installed features grouped by scope
Get-SPFeature | Sort -Property Scope, DisplayName | FT -GroupBy Scope

# List of all installed SITE scoped Features
Get-SPFeature -Limit ALL | Where-Object {$_.Scope -eq "Site"} | Select DisplayName, Id | Sort -Property DisplayName

# Features that have EDA in their DisplayName
Get-SPFeature -Limit ALL | Where-Object {$_.DisplayName -like "EDA*" } |  FT DisplayName,Id,Scope

# Check if feature enabled before activating it
$featureName = "EDA.AppSecStore.Extra.MyEDA_DelagateControlsSite"
$siteUrl = "http://eda.sharepointdev.local"
$featureEnable = Get-SPFeature -Site $siteUrl -Identity $featureName -ErrorAction SilentlyContinue
if($featureEnable) 
{
    Write-Host "Feature $featureName already enabled"
}
else
{
    Enable-SPFeature -Identity $featureName -Url $siteUrl
    Write-Host "Feature $featureName activated"
}

# Deactivate a feature
Disable-SPFeature –identity $FeatureID -URL $siteUrl -Confirm:$false
