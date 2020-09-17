Add-PSSnapin Microsoft.SharePoint.PowerShell –ErrorAction SilentlyContinue
  
#Variables
$SiteUrl = "https://eurojust.europa.eu/doclibrary/register"
$ListName = "RegisterList"

$directorypath = Split-Path $MyInvocation.MyCommand.Path
$csvfile = "$directorypath\ListData.csv"

#Internal names of fields to Export
$ExportFields = @("Title","Topic","RegID","Document_x0020_type","Created")
  
#Get Web and List
$web = Get-SPWeb $SiteUrl
$List = $Web.Lists[$ListName]
Write-host "Total Number of Items Found:"$List.Itemcount
 
#Array to Hold Result - PSObjects
$ListItemCollection = @()
   
#Get All List items
$List.Items | ForEach {
	write-host "Processing Item ID:"$_["ID"]
  
	$ExportItem = New-Object PSObject
	#Get Each field
	foreach($Field in $ExportFields)
    {
        $ExportItem | Add-Member -MemberType NoteProperty -name $Field -value $_[$Field] 
    }
    #Add the object with property to an Array
    $ListItemCollection += $ExportItem
}   

#Export the result Array to CSV file
$ListItemCollection | Export-CSV $csvfile -NoTypeInformation
Write-host -f Green "List '$ListName' Exported to $($csvfile) for site $($SiteURL)"
