Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$url = 'http://eda.sharepointdev.local:9134/sites/dpol2'
$documentsToDelete = @("2013 Spanish Strategy Cyber Security.pdf", "20170327 Spanish FFT EDAP.PDF", "Strategic_Defence_Review_Slovenia_2016.pdf")

$web = Get-SPWeb -Identity $url
$List = $web.Lists['Defence Policies']

$files = $List.Items | Where-Object {$_.Name -in $documentsToDelete}

foreach ($file in $files)
{
    $file.Delete();
    Write-Host $file.Name "deleted"
}

$web.Dispose()
