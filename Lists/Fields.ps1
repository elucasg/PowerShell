function RemoveSiteColumnListReference([string] $webURL, [string] $listName, [string]$fieldName) 
{
  	Write-Host "(1) Start removing field:" $fieldName -ForegroundColor White
    $web = Get-SPWeb $webURL
    $list = $web.Lists[$listName]
    $column = $list.Fields[$fieldName]
        
    if($column)
    {			
        $column.Hidden = $false
        $column.Sealed = $false
        $column.AllowDeletion = $true
        $column.ReadOnlyField = $false
        $column.Update()
        $list.Fields.Delete($column)
                      
        Write-Host "Site column " $fieldName " referenced in list " $list.Title " is removed from " $webURL  -ForegroundColor Green
                   
        $list.Update()                 
    }
    else
    {
      Write-Host "Site column " $fieldName " referenced in list " $list.Title " was already removed from " $webURL   -ForegroundColor Red
    }
    
    $web.Dispose()       
}
