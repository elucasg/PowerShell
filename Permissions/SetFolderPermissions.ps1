try { Add-PSSnapin "Microsoft.SharePoint.PowerShell" } catch{ $null }

# Set Variables
$WebURL="http://spsse:8000/"
$FolderURL="http://spsse:8000/PROVISIONAL COMMITMENT MODIFICATION Library/6"
$UserAccount="MVP\testfia2"
$PermissionLevel="RS Read"
 
function Set-FolderPermissions($webUrl, $FolderURL, $UserAccount, $PermissionLevel)
{
    #Get Web
    $web = Get-SPWeb $webUrl  
    #Get the User   
    $user = $web.EnsureUser($UserAccount)
    #Get the Permission Level
    $RoleDefinition = $web.RoleDefinitions[$PermissionLevel]
  
    #Get the Folder    
    $Folder = $web.GetFolder($FolderURL).Item
    if ($Folder -ne $null) 
    {  
        #Check if Item has Unique Permissions. If not, Break the inheritance
        if($folder.HasUniqueRoleAssignments -eq $false) 
        {
            $folder.BreakRoleInheritance($true) 
        }
 
        #Grant Permissions
        $RoleAssignment = New-Object Microsoft.SharePoint.SPRoleAssignment($user)
        $RoleAssignment.RoleDefinitionBindings.Add($RoleDefinition) 
        $Folder.RoleAssignments.Add($RoleAssignment)
        $Folder.SystemUpdate(); 
 
        Write-Host "Successfully added $($user) to folder $($Folder.Name)" -foregroundcolor Green
    }
 
}
 
Set-FolderPermissions $WebURL $FolderURL $UserAccount $PermissionLevel
