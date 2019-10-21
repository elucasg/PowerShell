Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

#-----------------------------------------------------------------
# Deploy a SharePoint solution
# 
# PARAMETERS   featureName: name of the feature to be activated
#              WspName: name of the solution package to be installed
#              webUrl: web application url
#
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#PARAMETERS
$featureName = "Eurojust.SPI.UI.Resources_EJUResources"
$WspName = "eurojust.spi.ui.resources.wsp"
$webUrl = "http://www.dev.eurojust.eu.int"
#-----------------------------------------------------------------
$directorypath = Split-Path $MyInvocation.MyCommand.Path
$WspFullPath = "$directorypath\$WspName"

function wait4timer($solutionName) 
{    
   $solution = Get-SPSolution | where-object {$_.Name -eq $solutionName}    
   if ($solution -ne $null)     
   {        
       Write-Host "Waiting to finish solution timer job. Please wait." -NoNewline -ForegroundColor DarkYellow      
       while ($solution.JobExists -eq $true )          
       {               
           Write-Host -NoNewline "." -ForegroundColor DarkYellow           
           sleep 4
       }
       Write-Host ""              
   }
}

# Deactivate feature
Write-Host "Deactivate Feature" -ForegroundColor Green
$featureEnable = Get-SPFeature -Site $webUrl -Identity $featureName -ErrorAction SilentlyContinue
if($featureEnable) 
{
    Disable-SPFeature –Identity $featureName –url $webUrl -confirm:$false
}

# Verify whether the Solution is installed on the Target Web Application
$InstalledSolution = Get-SPSolution -Identity $WspName
if($InstalledSolution -ne $null)
{
   if($InstalledSolution.DeployedWebApplications.Count -gt 0)
   {
       # Solution is installed in at least one WebApplication.  Hence, uninstall from all the web applications.
       # We need to uninstall from all the WebApplicaiton.  If not, it will throw error while Removing the solution
       Write-Host "Uninstalling solution" -ForegroundColor Green
       Uninstall-SPSolution $WspName -AllWebApplications:$true -confirm:$false

       wait4timer($WspName) 
   }

   # Remove the Solution from the Farm
   Write-Host "Remove the Solution from the Farm" -ForegroundColor Green
   Remove-SPSolution $WspName -Confirm:$false

   sleep 3   
}

# Add Solution to the Farm
Add-SPSolution -LiteralPath "$WspFullPath"

# Install Solution to the WebApplication
Write-Host "Install Solution to the WebApplication" -ForegroundColor Green
Install-SPSolution -Identity $WspName -WebApplication $webUrl -GACDeployment 

# Let the Timer Jobs get finished   
wait4timer($WspName)    

Write-Host "Successfully Deployed to the WebApplication" -ForegroundColor Green

Enable-SPFeature –Identity $featureName –url $webUrl
Write-Host "Feature Enabled" -ForegroundColor Green
