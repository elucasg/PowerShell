Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$WebAppURL = "http://gea:2110"

#Delete web application
Remove-SPWebApplication -identity $WebAppURL -Confirm

#Remove the web application and its databases & IIS Web Application
Remove-SPWebApplication -identity $WebAppURL -Confirm -DeleteIISSite -RemoveContentDatabases
