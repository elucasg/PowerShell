Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

#-----------------------------------------------------------------
# Count number of documents\versions created in a year
# 
# PARAMETERS   webapps: comma separated list of the web applications to process
#              year: year to be analized
#              excludedLibraries: comma separated list of the document libraries not to be considered
#
# Two csv files will be generated in the script folder:
# EJU_DMS_DocumentsCount_YEAR.csv: number of documents grouped by site collection
# EJU_DMS_DocumentsCount_YEAR_Detailed.csv: number of documents grouped by document library
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#PARAMETERS

$webapps= @("http://tpw/","http://docs/")
$year = 2018
$excludedLibraries = @("Images", "Converted Forms", "Documents", "Form Templates", "List Template Gallery", "Master Page Gallery", 
                        "Web Part Gallery", "Translation Packages", "Theme Gallery", "Style Library", "Pages", "Site Collection Documents",
                         "Site Collection Images", "Solution Gallery", "Site Assets", "wfpub", "Site Pages")
#-----------------------------------------------------------------

$sitecollections = @()
$lists = @()

foreach ($webapp in $webapps)
{
    $spwebapp = Get-SPWebApplication $webapp -ErrorAction SilentlyContinue
    if ($spwebapp -ne $null)
    {
        $allsites = Get-SPSite -WebApplication $webapp -Limit All
        ForEach ($Site in $allsites)
        {                        
            Write-Host "######### Processing site collection $($Site.RootWeb.Title) ($($Site.Url)) #########" -ForegroundColor Yellow
            try
            {
                if ($Site.AllWebs -ne $null)
                {
                    ForEach ($web in $Site.AllWebs)
                    {
                        $TotalSiteItems = 0
                        $TotalSiteVersions = 0

                        ForEach ($List in $web.Lists)
                        {
                            if (($List.BaseType -eq "DocumentLibrary") -and (-not $excludedLibraries.Contains($List.Title))) # -and $List.Title -eq "C1")
                            {   
                                $TotalItems = 0
                                $TotalVersions = 0

                                Write-Host "List '$($List.Title)'" -ForegroundColor Cyan
                                foreach ($item in $List.Items)
                                {
                                    $TotalItemVersions = 0
                                    if ($item["Created"].Year -eq $year) {
                                        $TotalItems += 1
                                        $TotalItemVersions = -1
                                    }

                                    foreach ($version in $item.Versions) {
                                        if ($version.Created.Year -eq $year) {
                                            $TotalItemVersions += 1
                                        }
                                    }
                                    $TotalVersions += $TotalItemVersions
                                }

                                $newListSize = New-Object -TypeName PSObject -Property @{
                                    Web = $webapp
                                    Site = $Site.RootWeb.Title
                                    Url = $Site.Url
                                    List = $List.Title
                                    Documents = $TotalItems
                                    Versions = $TotalVersions
                                }
                                $lists += $newListSize

                                $TotalSiteItems += $TotalItems
                                $TotalSiteVersions += $TotalVersions

                            }
                        }                        
                    }
                    $newSize = New-Object -TypeName PSObject -Property @{
                        Web = $webapp
                        Site = $Site.RootWeb.Title
                        Url = $Site.Url
                        Documents = $TotalSiteItems
                        Versions = $TotalSiteVersions
                    }
                    $sitecollections += $newSize                                      
                }
            }
            catch
            {
                Write-Host "Error processing site $($Site.Url)" -ForegroundColor Red
                Write-Host $_
                continue
            }
        }
    }
    else
    {
        Write-Host "Web application '$webapp' not found." -ForegroundColor Red
    }
}

if ($sitecollections.Count -gt 0)
{
    $directorypath = Split-Path $MyInvocation.MyCommand.Path
    $filename = "EJU_DMS_DocumentsCount_$($year).csv"
    $filenameDetailed = "EJU_DMS_DocumentsCount_$($year)_Detailed.csv"

    $sitecollections | select Web, Site, Url, Documents, Versions | Export-CSV "$directorypath\$filename" -NoTypeInformation
    Write-Host "Done!! File '$directorypath\$filename' generated" -ForegroundColor Green

    $lists | select Web, Site, Url, List, Documents, Versions | Export-CSV "$directorypath\$filenameDetailed" -NoTypeInformation
    Write-Host "Done!! File '$directorypath\$filenameDetailed' generated" -ForegroundColor Green
}
