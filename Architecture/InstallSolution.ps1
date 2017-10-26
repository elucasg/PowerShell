Add-PSSnapin "Microsoft.SharePoint.PowerShell"

# Set variables
$WebApplicationUrl = "http://WEBAPPLICATIONURL"
$WspName = "MySolution.WSP"
$WspFullPath = "D:\Test\MySolution.WSP"

function wait4timer($solutionName) 
{    
   $solution = Get-SPSolution | where-object {$_.Name -eq $solutionName}    
   if ($solution -ne $null)     
   {        
       Write-Host "Waiting to finish soultion timer job" -ForegroundColor Green      
       while ($solution.JobExists -eq $true )          
       {               
           Write-Host "Please wait...Either a Retraction/Deployment is happening" -ForegroundColor DarkYellow           
           sleep 2            
       }                

       Write-Host "Finished the solution timer job" -ForegroundColor Green  
   }
}

# Verify whether the Solution is installed on the Target Web Application
$InstalledSolution = Get-SPSolution -Identity $WspName
if($InstalledSolution -ne $null)
{
   if($InstalledSolution.DeployedWebApplications.Count -gt 0)
   {
       wait4timer($WspName)  

       # Solution is installed in at least one WebApplication.  Hence, uninstall from all the web applications.
       # We need to uninstall from all the WebApplicaiton.  If not, it will throw error while Removing the solution
       Uninstall-SPSolution $WspName -AllWebApplications:$true -confirm:$false
   }

   wait4timer($WspName) 

   # Remove the Solution from the Farm
   Write-Host "Remove the Solution from the Farm" -ForegroundColor Green
   Remove-SPSolution $WspName -Confirm:$false

   sleep 3   
}

wait4timer($WspName) 

# Add Solution to the Farm
Add-SPSolution -LiteralPath "$WspFullPath"

# Install Solution to the WebApplication
Install-SPSolution -Identity $WspName -WebApplication $WebApplicationUrl -FullTrustBinDeployment:$true -GACDeployment:$false -Force:$true

# Let the Timer Jobs get finishes       
wait4timer($WspName)    

Write-Host "Successfully Deployed to the WebApplication" -ForegroundColor Green 
