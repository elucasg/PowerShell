# Details about the OfficeWebAppsFarm object that the current server is a member of
Get-OfficeWebAppsFarm

# Creates a new Office Web Apps Server farm on the local computer with https.
New-OfficeWebAppsFarm -InternalUrl "https://officewebapps.bilbomatica.es" -ExternalUrl "https://officewebapps.bilbomatica.es" -EditingEnabled:$true -CertificateName "Bilbomatica"
