Add-PsSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

$WebAppURL="http://gea:10330"
$UserAccount="i:0#.w|on-dev\dmsvisitor"

# Update Email for all webs in a web application
Get-SPWebApplication $WebAppURL | Get-SPSite -Limit All | Get-SPWeb -Limit All | Foreach-object {
     
    Write-host "Processing:" $_.Url
 
    #Get the User's Current Display Name and E-mail
    $User = Get-SPUser -Identity $UserAccount -Web $_.Url
 
    if($User -ne $null)
    {
        Set-SPUser -Identity $UserAccount –Web $_.Url -SyncFromAD
    }
}
