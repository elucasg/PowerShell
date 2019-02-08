Add-PSSnapin "Microsoft.SharePoint.PowerShell"

# List all the timer jobs filtering by name
Get-SPWebApplication  | %{$_.JobDefinitions | Select -Unique -Property Name, ID, Status , Schedule} | Where-Object Name -Like "JIT*" | Sort-Object -Property Name | ft
