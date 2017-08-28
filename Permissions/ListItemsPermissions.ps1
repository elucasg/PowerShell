if ( (Get-PSSnapin -Name "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null )
{
    Write-Host "Connecting SharePoint…."
    Add-PsSnapin "Microsoft.SharePoint.PowerShell"
}

$web = get-spweb "http://gea:2801"

$list = $web.Lists["Master Page Gallery"]  
  
$listitem = $list.Items  
foreach ($item in $listitem)  
{  
     write-host "Permission for the list item " $item.name -fore yellow  
     foreach ($role in $item.RoleAssignments)  
     {  
        $users = $role.member.name  
        foreach ($roledef in $role.RoleDefinitionBindings)  
        {  
           write-host $users ":" $roledef.name  
        }  
     }  
} 
