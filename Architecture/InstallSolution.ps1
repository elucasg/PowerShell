Add-PSSnapin "Microsoft.SharePoint.PowerShell"

# Set variables
$WebApplicationUrl = "http://bm2-077:16877"
$WspName = "EDA.DPOL.WSP"
$WspFullPath = "C:\EDA\DPOL\Installation\Features\EDA.DPOL.WSP"

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
Install-SPSolution -Identity $WspName -WebApplication $WebApplicationUrl -GACDeployment

# Let the Timer Jobs get finished   
wait4timer($WspName)    

Write-Host "Successfully Deployed to the WebApplication" -ForegroundColor Green 
