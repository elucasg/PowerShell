Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue

#-----------------------------------------------------------------
# Upload display templates to Master Page Gallery
# 
# PARAMETERS   searchSiteUrl: url of the search site
#              
# The display templates to upload should be in a directory DisplayTemplates under the powershell directory
#-----------------------------------------------------------------

$searchSiteUrl = "http://gea:10330/sites/search"
$scriptBase = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent

function UploadDisplayTemplates([string]$siteUrl)
 {
     $spsite = Get-SPSite $siteUrl
     $web = $spsite.RootWeb
     $searchDisplayTemplatesFolder = $web.GetFolder("_catalogs/masterpage/Display Templates/Search")
     $displayTemplatesDirectory = $scriptBase + "\DisplayTemplates"
     $web.AllowUnsafeUpdates=$true;
  
     foreach ($file in Get-ChildItem $displayTemplatesDirectory)
     {
          try
          {
                  $stream = [IO.File]::OpenRead($file.fullname)
                  $destUrl = $web.Url + "/_catalogs/masterpage/Display Templates/Search/" + $file.Name;
                  $displayTemplateFile = $web.GetFile($destUrl)
                    
                  if($displayTemplateFile.CheckOutStatus -ne "None")
                  {
                      $searchDisplayTemplatesFolder.files.Add($destUrl,$stream,$true)
                      $stream.close() 
                      $displayTemplateFile.CheckOut();                      
                      $displayTemplateFile.CheckIn("CheckIn by PowerShell");                         
                      $displayTemplateFile.Publish("Publish by PowerShell");                         
                        
                      $displayTemplateFile.Update();        
                      $web.Update();
                       
                      Write-Host $file.Name " Display Template uploaded on $web site" -ForegroundColor Green  
                        
                  }
                  else
                  {
                      $displayTemplateFile.CheckOut();
                      try
                      {
                         $searchDisplayTemplatesFolder.Files.Add($destUrl,$stream,$true)
                      }
                      catch
                      {
                         Write-Host $_
                      }
                      $stream.close()                             
                      $displayTemplateFile.CheckIn("CheckIn by PowerShell");                         
                      $displayTemplateFile.Publish("Publish by PowerShell");                         
                        
                      $displayTemplateFile.Update();        
                      $web.Update();                       
                        
                      Write-Host $file.Name " Display Template uploaded on $web site" -ForegroundColor Green  
                        
                  }
          }
          catch
          {
              Write-Host $_ 
          }    
      }
    
    $web.AllowUnsafeUpdates  = $false;
  
    $web.dispose();
    $spsite.dispose();
 }

 UploadDisplayTemplates $searchSiteUrl
