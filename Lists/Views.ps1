# Remove SharePoint List View
function Remove-SPListView {
    Param(
    [string]$WebUrl,
    [string]$ListName,
    [string]$ViewName
    )

    $SPWeb = Get-SPWeb $WebUrl
    $List = $SPWeb.Lists[$ListName]
    $View = $List.Views[$ViewName]
    $List.Views.Delete($View.ID)
    $List.Update()
    $SPWeb.Update()
    $SPWeb.Dispose()
}
