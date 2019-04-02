Add-PSSnapin microsoft.sharepoint.powershell -ErrorAction SilentlyContinue
 
# Set variables
$WebURL = "https://customers.bilbomatica.es:12345/sites/ejt/ejwebsite"
$FilePath = "https://customers.bilbomatica.es:12345/sites/ejt/ejwebsite/Software Maintenance/SC40_QTM03/Deployment/Website-VisualIdentity-InstallationPackage_v0.1.zip"

# Update document created and modified date
$web = Get-SPWeb $WebUrl
$File2Replace = $web.GetFile($FilePath)
$dateToStore = Get-Date "03/29/2019 15:06:00"
$File2Replace.item["Created"] = $dateToStore
$File2Replace.item["Modified"] = $dateToStore
$File2Replace.item.UpdateOverwriteVersion()
$web.Dispose()
