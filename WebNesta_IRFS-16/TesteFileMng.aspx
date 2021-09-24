<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TesteFileMng.aspx.cs" Inherits="WebNesta_IRFS_16.TesteFileMng" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div runat="server" id="MainContent">
        <dx:ASPxFileManager ID="FileManager" runat="server" ProviderType="OneDrive" OnCloudProviderRequest="FileManager_OnCloudProviderRequest"
            OnFolderCreating="fileManager_FolderCreating" OnItemDeleting="fileManager_ItemDeleting" OnItemMoving="fileManager_ItemMoving"
            OnItemRenaming="fileManager_ItemRenaming" OnFileUploading="fileManager_FileUploading" OnItemCopying="fileManager_ItemCopying">
            <SettingsFolders EnableCallBacks="true" />
            <SettingsEditing AllowCopy="true" AllowCreate="true" AllowDelete="true" AllowDownload="true" AllowMove="true" AllowRename="true" />
    <SettingsOneDrive AccountName="FileManagerOneDriveAccount" TokenEndpoint="https://login.microsoftonline.com/e7d7dd1c-5536-472c-aac7-2beffcdf3649/oauth2/token" RedirectUri="https://cloud4.webnesta.com:44302/testefilemng" />
            <SettingsAdaptivity Enabled="true" />
        </dx:ASPxFileManager>

    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
</asp:Content>
