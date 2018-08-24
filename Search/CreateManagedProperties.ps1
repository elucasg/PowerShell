#-----------------------------------------------------------------
# Create new managed properties in the SharePoint Search Service Application
# 
# The managed properties are defined in the file ManagedProperties.csv
# 
# ManagedPropertyName,Type,Description,Category,Refine,Multiple,CrawledPropertyName
# KMSubject,1,KM Item Subject,SharePoint,True,True,ows_KMSubject
#-----------------------------------------------------------------
Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

$directorypath = Split-Path $MyInvocation.MyCommand.Path
$csvfile = "$directorypath\ManagedProperties.csv"

#Get the Search Service Application
$searchapp = Get-SPEnterpriseSearchServiceApplication

#Iterate through the CSV file
Import-csv $csvfile | where {
      
    #Get the Crawled Property First
    $cat = Get-SPEnterpriseSearchMetadataCategory –SearchApplication $searchapp –Identity $_.Category
    $cp = Get-SPEnterpriseSearchMetadataCrawledProperty -SearchApplication $searchapp -name $_.CrawledPropertyName -Category $cat -ea silentlycontinue
  
    #If the Crawled Property is not null, then go inside
    if ($cp)
    {
        # Check whether Managed Property already exists
        $property = Get-SPEnterpriseSearchMetadataManagedProperty -SearchApplication $searchapp -Identity $_.ManagedPropertyName -ea silentlycontinue
        if ($property)
        {
            Write-Host -f Red "Cannot create managed property" $_.ManagedPropertyName "because it already exists"      
        }
        else
        {
            New-SPEnterpriseSearchMetadataManagedProperty -Name $_.ManagedPropertyName -SearchApplication $searchapp -Type $_.Type -Description $_.Description -SafeForAnonymous $true -Queryable $true
               
            $mp = Get-SPEnterpriseSearchMetadataManagedProperty -SearchApplication $searchapp -Identity $_.ManagedPropertyName

            if ($_.Refine -eq "True")
            {
            $mp.Refinable = $true
            }

            if ($_.Multiple -eq "True")
            {
            $mp.HasMultipleValues = $true
            }

            $mp.Update()

            #Map the Managed Property with the Corresponding Crawled Property
            New-SPEnterpriseSearchMetadataMapping -SearchApplication $searchapp -ManagedProperty $mp –CrawledProperty $cp

            Write-Host "Managed property" $_.ManagedPropertyName "created" -ForegroundColor Green
        }
    }
    else
    {
        Write-Host -f Red "The specified crawled property " $_.CrawledPropertyName " does not exists... Please check whether you have given valid crawled property name"
    }
  
}
