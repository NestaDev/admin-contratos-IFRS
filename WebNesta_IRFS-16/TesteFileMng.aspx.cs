using DevExpress.Web;
using DevExpress.Web.Demos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebNesta_IRFS_16.Utils;

namespace WebNesta_IRFS_16
{
    public partial class TesteFileMng : System.Web.UI.Page
    {
        bool IsOneDriveClientIDValueDefined
        {
            get
            {
                return !string.IsNullOrEmpty(FileManagmentUtils.GetOneDriveClientIDValue());
            }
        }
        bool IsOneDriveClientSecretValueDefined
        {
            get
            {
                return !string.IsNullOrEmpty(FileManagmentUtils.GetOneDriveClientSecretValue());
            }
        }
        bool IsGoogleDriveClientEmailValueDefined
        {
            get
            {
                return !string.IsNullOrEmpty(FileManagmentUtils.GetGoogleDriveClientEmailValue());
            }
        }
        bool IsGoogleDrivePrivateKeyValueDefined
        {
            get
            {
                return !string.IsNullOrEmpty(FileManagmentUtils.GetGoogleDrivePrivateKeyValue());
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsOneDriveClientIDValueDefined || !IsOneDriveClientSecretValueDefined)
            {
                MainContent.InnerHtml = string.Format(
                    "To run the demo locally, use the AccountManager.RegisterOneDrive() method to register your Azure Active Directory application account in the global.asax file. " +
                    "Refer to the <a href='{0}'>{0}</a> link to see the demo online.",
                    "https://demos.devexpress.com/ASPxFileManagerAndUploadDemos/FileManager/OneDriveProvider.aspx");
            }
            //if (!IsGoogleDriveClientEmailValueDefined || !IsGoogleDrivePrivateKeyValueDefined)
            //{
            //    MainContent.InnerHtml = string.Format(
            //        "To run the demo locally, use the AccountManager.RegisterGoogleDrive() method to register your GoogleDrive service account in the global.asax file. " +
            //        "Refer to the <a href='{0}'>{0}</a> to see the demo online.",
            //        "https://demos.devexpress.com/ASPxFileManagerAndUploadDemos/FileManager/GoogleDriveProvider.aspx");
            //}
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void FileManager_OnCloudProviderRequest(object sender, FileManagerCloudProviderRequestEventArgs e)
        {
            //EventMonitor.TraceEvent(sender, e, FileManager.ProviderType);
        }

        protected void fileManager_FileUploading(object sender, FileManagerFileUploadEventArgs e)
        {

            if (e.File.Folder.FullName == "Files")
                ValidateSiteEdit(e);
        }

        protected void fileManager_ItemRenaming(object sender, FileManagerItemRenameEventArgs e)
        {
            if (string.IsNullOrEmpty(e.NewName))
                ValidateSiteEdit(e);
        }

        protected void fileManager_ItemMoving(object sender, FileManagerItemMoveEventArgs e)
        {
            if (e.DestinationFolder.FullName == "Files")
                ValidateSiteEdit(e);
        }

        protected void fileManager_ItemDeleting(object sender, FileManagerItemDeleteEventArgs e)
        {
            //if (e.Item.Location. == "Files")
            //    ValidateSiteEdit(e);
        }

        protected void fileManager_FolderCreating(object sender, FileManagerFolderCreateEventArgs e)
        {
            if (e.ParentFolder.FullName == "Files")
                ValidateSiteEdit(e);
        }
        protected void fileManager_ItemCopying(object sender, FileManagerItemCopyEventArgs e)
        {
            if (e.DestinationFolder.FullName == "Files")
                ValidateSiteEdit(e);
        }
        protected void ValidateSiteEdit(FileManagerActionEventArgsBase e)
        {            
            e.Cancel = true;
            e.ErrorText = "You cannot create child folders for the root folder";
        }
    }
}