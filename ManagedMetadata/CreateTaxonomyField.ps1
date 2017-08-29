Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

#Variables
$fieldName = "PowerShell MMS Column"
$siteUrl = "http://intranet"
$mmsServiceName = "Managed Metadata Service"
$mmsGroupName = "MyGroup"
$mmsTermSetName = "MyTermSet"

$site = Get-SPSite $siteUrl
$web = $site.RootWeb

$taxonomy = Get-SPTaxonomySession -Site $site

$sspId = $taxonomy.TermStores |
Where-Object {$_.Name -eq $mmsServiceName} |
Select-Object -ExpandProperty Id |
Select-Object -ExpandProperty Guid

$termSetId = $taxonomy.TermStores.Groups |
Where-Object {$_.Name -eq $mmsGroupName} |
Select-Object -ExpandProperty TermSets |
Where-Object {$_.Name -eq $mmsTermSetName} |
Select-Object -ExpandProperty Id |
Select-Object -ExpandProperty Guid

# Create Taxonomy Type field
$field = $web.Fields.CreateNewField("TaxonomyFieldType",$fieldName)
$web.fields.add($field)
$field = $web.fields.GetField($fieldName)
$field.TermSetId = $termSetId
$field.SspId = $sspId
$field.Update()
