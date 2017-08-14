Add-PsSnapin "Microsoft.SharePoint.PowerShell"

# Set variables
$WebAppName = "EDA DPOL"
$WebAppHostHeader = "eda.dpol.sharepointdev.local"
$WebAppPort = "9136"
$url = "http://eda.dpol.sharepointdev.local"
$dbName = "WSS_Content_EDA_DPOL"
$WebAppAppPool = "EDADPOLAppPool"
$WebAppAppPoolAccount = "sharepointdev\spfarm"

# Create Authentication Provider
$ap = New-SPAuthenticationProvider

# Create Web Application
New-SPWebApplication -Name $WebAppName -DatabaseName $dbName -HostHeader $WebAppHostHeader -Port $WebAppPort -ApplicationPool $WebAppAppPool -ApplicationPoolAccount (Get-SPManagedAccount $WebAppAppPoolAccount) -URL $url -AuthenticationProvider $ap 
