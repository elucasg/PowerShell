# Migrate a Web Application from one Farm to another

# 1. Check that destination farm build number is the same build number or higher than the source farm 
# 2. Create a new web application and site collection
# 3. Dismount the web application content database
# 4. Restore the database backup taken from source farm (from SQL Server Management Studio)
# 5. Mount the content database for the web application
# 6. Upgrade the mounted content database

Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

# Get Farm Build Number
# In Central Admin you can get this information as well by going to "System Settings" > "Manage Servers in the Farm" and looking for the "Configuration database version" number
$farm = Get-SPFarm
$farm.BuildVersion

# Dismount the web application content database
Dismount-SPContentDatabase "content_database_name"

# Mount the content database for the web application
Mount-SPContentDatabase "content_database_name" -WebApplication "web_application_url"

# Upgrade the mounted content database
Upgrade-SPContentDatabase "content_database_name"
