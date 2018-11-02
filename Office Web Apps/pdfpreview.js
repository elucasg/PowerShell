/* 
SharePoint 2013: Enabling PDF Previews in Document Libraries with Office Web Apps 2013
source: http://www.wictorwilen.se/sharepoint-2013-enabling-pdf-previews-in-document-libraries-with-office-web-apps-2013
*/

function PDFPreview() {
    SP.SOD.executeOrDelayUntilScriptLoaded(function () {
        filePreviewManager.previewers.extensionToPreviewerMap.pdf = 
            [embeddedWACPreview, WACImagePreview];
        embeddedWACPreview.dimensions.pdf= { width: 379, height: 252}
    }, "filepreview.js");
}

_spBodyOnLoadFunctionNames.push("PDFPreview");
