#Iterate All Site Collections
$SPWebApp = Get-SPWebApplication $WebAppUrl
foreach ($SPSite in $SPWebApp.Sites)
{
  $SPSite.Dispose()
}

#Loop Through All Sub Sites in a Site Collection
$site = Get-SPSite $siteUrl -ErrorAction SilentlyContinue
if ($site -ne $null)
{
  foreach($web in $site.AllWebs)
  {
    Write-Host $web.Title
    $web.Dispose()
  }
}
