#-----------------------------------------------------------------
# Create new result source in the SharePoint Search Service Application
#-----------------------------------------------------------------
Add-PSSnapin Microsoft.SharePoint.PowerShell
  
function CreateResultSource($searchServiceName, $resultSourceName, $query)
{    
    $ssa = Get-SPEnterpriseSearchServiceApplication $searchServiceName
    $fedman = New-Object Microsoft.Office.Server.Search.Administration.Query.FederationManager($ssa)
    $searchOwner = Get-SPEnterpriseSearchOwner -Level Ssa  

    $resultSource = $fedman.GetSourceByName($resultSourceName, $searchOwner)

    if($resultSource -eq $null) {
        Write-Host "Result source does not exist. Creating..."
        $resultSource = $fedman.CreateSource($searchOwner)
    }
    else { 
        Write-Host "Using existing result source..." 
    }

    $queryProperties = New-Object Microsoft.Office.Server.Search.Query.Rules.QueryTransformProperties

    $resultSource.Name = $resultSourceName
    $resultSource.ProviderId = $fedman.ListProviders()['Local SharePoint Provider'].Id
    $resultSource.CreateQueryTransform($queryProperties, $query)
    $resultSource.Commit()
}


$SearchServiceName = "Search Service Application"
CreateResultSource $SearchServiceName "KMI" "{searchTerms} (Path:http://gea:10440/kmieju/Lists/KMList) (contentclass:STS_ListItem)"  
CreateResultSource $SearchServiceName "KMI FULL TEXT" "{searchTerms} (Path:http://gea:10440/kmieju* IsDocument:True) OR (Path:http://gea:10440/kmieju/Lists/KMList contentclass:STS_ListItem)" 
