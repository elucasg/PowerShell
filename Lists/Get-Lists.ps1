Add-PSSnapin microsoft.sharepoint.powershell -ErrorAction SilentlyContinue

$webApplication = "http://tpw2013"

# Get all Document Libraries in a SharePoint web application
Get-SPWebApplication $webApplication | Get-SPSite -Limit All | Get-SPweb -Limit All | ForEach {
    $web = $_
    $lists = $web.Lists | Where-Object { $_.BaseType -eq 'DocumentLibrary' }
    $lists | ForEach {
        $list = $_
        Write-Host $list.Title
    }
} 
