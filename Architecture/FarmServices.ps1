Add-PSSnapin Microsoft.sharepoint.powershell -ErrorAction SilentlyContinue

#Stop all Sharepoint 2013 Services
function StopSharepointServer()
{
  $SharePointServices = ('SPSearchHostController','OSearch15','SPWriterV4','SPUserCodeV4','SPTraceV4','SPTimerV4','SPAdminV4','FIMSynchronizationService','FIMService','W3SVC')

  #Stop all SharePoint Services
  foreach ($Service in $SharePointServices)
  {
      Write-Host -ForegroundColor red "Stopping $Service..."
      Stop-Service -Name $Service
  }

  #Stop IIS
  iisreset /stop
}

#Start all SharePoint 2013 Services
function StartSharepointServer()
{
  $SharePointServices = ('SPSearchHostController','OSearch15','SPWriterV4','SPUserCodeV4','SPTraceV4','SPTimerV4','SPAdminV4','FIMSynchronizationService','FIMService','W3SVC')

  #Start all SharePoint Services
  foreach ($Service in $SharePointServices)
  {
      Write-Host -ForegroundColor green "Starting $Service..."
      Start-Service -Name $Service
  }

  #Start IIS
  iisreset /start
}
