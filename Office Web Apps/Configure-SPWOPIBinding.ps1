
# Disable office web apps for your entire SharePoint environment
Remove-SPWOPIBinding –All:$true

# Enable opening documents in client applications at Site collection level:
#  - Log into SharePoint site >> Go to Site Settings.
#  - Click Site collection features under Site Collection Administration section.
#  - Activate "Open Documents in Client Application by Default" feature
