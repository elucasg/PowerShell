Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$url = 'http://cronos:4000/sites/web'
$web = get-spweb -Identity $url

function RemoveSiteColumn([string]$SiteUrl, [string]$fieldName)
{
	$site = Get-SPSite $SiteUrl

	$web = $site.RootWeb
	$Column = $web.Fields.getfieldbyinternalname($fieldName)
	if($Column)
	{
		$Column.Delete()
		write-host "Site column " $column.Title " deleted successfully from the site " $web.url ".......... Done !" -fore blue
	} 
	else { Write-host "Site column $fieldName does not exist." }
}

# Delete list
$listName = 'Eurojust Videos'
$list = $web.lists[$listName]
if($list -ne $null) {
	$list.Delete()
    Write-host "List $listName deleted."
}
else {
	write-host "The list" $listName "does not exist"
}

# Delete site content type
$contentType = 'Eurojust Video'
$ct = $web.ContentTypes[$contentType]

if ($ct) {
    # Delete all the content type's children
	$ctusage = [Microsoft.SharePoint.SPContentTypeUsage]::GetUsages($ct)
	foreach ($ctuse in $ctusage) {
		$list = $web.GetList($ctuse.Url)
		$contentTypeCollection = $list.ContentTypes;
		$contentTypeCollection.Delete($contentTypeCollection[$ContentType].Id);
		Write-host "Deleted $contentType content type from $ctuse.Url"
	}
	$ct.Delete()
	Write-host "Deleted $contentType from site."

} else { Write-host "Content type $contentType does not exist." }

# Delete site column
$siteColumns = ('EJUVideoActive','EJUVideoDate','EJUVideoDescription','EJUVideoImage','EJUVideoUrl')
foreach ($siteColumn in $siteColumns)
{
	RemoveSiteColumn $url $siteColumn
}
