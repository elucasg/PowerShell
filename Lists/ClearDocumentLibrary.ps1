Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

$webUrl = "http://gea:10440/kmieju"
$libraryName = "Documents_orig"

$web = Get-SPWeb $webUrl
$list = $web.Lists[$libraryName]

function DeleteAllDocuments()
{
    Write-Host "Clearing document library '$libraryName'" -ForegroundColor Yellow    
    Write-Host $list.ItemCount
    $listItems = $list.Items
    $listItems | ForEach { $list.GetItemById($_.Id).Delete()}
}


function DeleteFiles {
    param($folderUrl)

    $folder = $web.GetFolder($folderUrl)
    foreach ($file in $folder.Files) {
        # Delete file by deleting parent SPListItem
        Write-Host("DELETED FILE: " + $file.name)
        $list.Items.DeleteItemById($file.Item.Id)
    }
}


function ClearDocumentLibrary()
{
    # Delete root files
    DeleteFiles($list.RootFolder.Url)

    # Delete files in folders
    foreach ($folder in $list.Folders) {
        DeleteFiles($folder.Url)
    }

    # Delete folders
    foreach ($folder in $list.Folders) {
        try {
            Write-Host("DELETED FOLDER: " + $folder.name)
            $list.Folders.DeleteItemById($folder.ID)
        }
        catch {
            # Deletion of parent folder already deleted this folder
        }
    }
}
