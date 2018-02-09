Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$url = 'http://minerva/Eurojust'

#Get the Web
$web = Get-SPWeb -Identity $url

#Get the List/Library
$list = $web.Lists.TryGetList("EJ Library")

$firstLevelFolders = @("AMAT","eMission","eMS","eRec","eSEC","DMS","EJ website restricted areas","Eurojust website","InfoPath forms","Intranet","CMS","OCC scheduler","SIS client","Art 13 pdf","Art 17 pdf","CIF","JITs","EJN","F5")
$secondLevelFolders = @("Requirements Factory","Development and Release","Maintenance","Final documentation")

if($list)  #Check If List exists!
{
  foreach ($firstLevelFolder in $firstLevelFolders)
  {
    # Check Folder Doesn't exists in the Library!
    $folder = $list.ParentWeb.GetFolder($list.RootFolder.Url + "/" + $firstLevelFolder);
    #sharepoint powershell check if folder exists
    if ($folder.Exists -eq $false)
    {
      #Create a Folder
      $folder = $list.AddItem("", [Microsoft.SharePoint.SPFileSystemObjectType]::Folder, $firstLevelFolder)
      $folder.Update();
    }

    foreach ($secondLevelFolder in $secondLevelFolders)
    {
      $Subfolder = $list.ParentWeb.GetFolder($folder.URL + "/" + $secondLevelFolder);
      if ($Subfolder.Exists -eq $false)
      {
        #Create a Sub-Folder
        $Subfolder = $list.AddItem($folder.URL, [Microsoft.SharePoint.SPFileSystemObjectType]::Folder, $secondLevelFolder)
        $Subfolder.Update();

        #Create Archive Sub-Folder
        $ArchiveSubfolder = $list.AddItem($Subfolder.URL, [Microsoft.SharePoint.SPFileSystemObjectType]::Folder, "Archive")
        $ArchiveSubfolder.Update();								
      }
    }
  }
}
