### Overview of Workflow Farm configuration
Get-WFFarm

### Verify that the services are running
Get-WFFarmStatus
# If the services are stopped: Start-WFHost

### Bus Farm Configuration
Get-SBFarm

### Verify that the services on the service bus farm are running
Get-SBFarmStatus
# If the services are stopped: Start-SBFarm

<###
Services
--------
Verify that the services associated with Workflow Manager Farm are running:

Workflow Manager Backend
Service Bus Message Broker
Service Bus Gateway
Windows Fabric Host Service (FabricHostSvc) 
###>

<###
Service Applications
--------------------
SharePoint 2013 Workflows require the following Service Applications:

App Management Service
Site Subscription Service
Workflow Service Application Proxy: When you click on Workflow Service Application Proxy you should see the Workflow Service Status with the message 'Workflow is Connected'
###>

<###
Response
--------
Verify that your workflow responds under the assigned url: http://spsse.mvp.sp:12291/
###>
