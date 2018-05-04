Add-PSSnapin microsoft.sharepoint.powershell -ErrorAction SilentlyContinue
 
$WebURL = "http://gea:10440/sites/kmi"
$MasterPage = "DMSMainv15.master"
$SourcePath ="C:\Temp\KMI\DMSMainv15.master"
 
#Get the Web
$web = Get-SPWeb $WebURL
 
#Get the Target folder - Master page Gallery
$MasterPageList = $web.GetFolder("Master Page Gallery")
 
#Set the Target file for Master page
$TargetPath = $Web.Url + "/_catalogs/masterpage/" + $MasterPage
 
#Get the Master page from local disk
$MasterPageFile = (Get-ChildItem $SourcePath).OpenRead()

#upload master page using powershell
$fileToUpdate = $Web.GetFile($TargetPath)
if ($fileToUpdate.Exists) {
    $fileToUpdate.CheckOut()
    $MasterPage = $MasterPageList.Files.Add($TargetPath, $MasterPageFile, $true)
    $MasterPage.Update()
    $MasterPage.CheckIn("Checked-in via PowerShell script.")
    if ($MasterPage.Level -eq "Draft") {
        $MasterPage.Publish("Published via PowerShell script.")
    }
}
else {
    $MasterPage = $MasterPageList.Files.Add($TargetPath, $MasterPageFile, $true)
}

$web.Update()
