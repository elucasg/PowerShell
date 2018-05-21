Add-PSSnapIn Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
(Get-SPEnterpriseSearchServiceApplication).reset($true, $true)
