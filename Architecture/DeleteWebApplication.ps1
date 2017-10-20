Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$WebAppURL = "http://gea:2110"

#Get web application information
Get-SPWebApplication -identity $WebAppURL | Select-Object @{Expression={$_.DisplayName};Label="Name"}, @{Expression={$_.Url};Label="Url"}, @{Expression={$_.ContentDatabases[0].Name};Label="Content Database"}, @{Expression={$_.ApplicationPool.Name};Label="App Pool"}

#Delete web application
Remove-SPWebApplication -identity $WebAppURL -Confirm

#Remove the web application and its databases & IIS Web Application
Remove-SPWebApplication -identity $WebAppURL -Confirm -DeleteIISSite -RemoveContentDatabases
