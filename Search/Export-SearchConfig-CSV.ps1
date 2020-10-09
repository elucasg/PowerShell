Add-PsSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue
$ssa = Get-SPEnterpriseSearchServiceApplication -Identity 'Search Service Application'
$owner = Get-SPEnterpriseSearchOwner -Level SSA

# Export custom managed properties
Get-SPEnterpriseSearchMetadataManagedProperty -SearchApplication $ssa | ? { $_.SystemDefined -eq $false } | Export-Csv -Path "C:/BBM/ProdSchema.csv" -Delimiter ";" -NoTypeInformation

# Export custom Result Sources
Get-SPEnterpriseSearchResultSource -SearchApplication $ssa -Owner $owner | Where-Object {$_.BuiltIn -eq $False} | Export-Csv -Path "C:/BBM/ProdResulSources.csv" -Delimiter ";" -NoTypeInformation
