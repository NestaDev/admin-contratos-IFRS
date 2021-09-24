using DevExpress.DataAccess.Web;
using DevExpress.Web;
using DevExpress.XtraReports.Web.QueryBuilder;
using DevExpress.XtraReports.Web.ReportDesigner;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using WebNesta_IRFS_16.Utils;
using static WebNesta_IRFS_16.Setup1;

namespace WebNesta_IRFS_16
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Código que é executado na inicialização do aplicativo
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            DevExpress.Web.ASPxWebControl.CallbackError += new EventHandler(Application_Error);
            DefaultQueryBuilderContainer.Register<IDataSourceWizardDBSchemaProviderExFactory, MyDataSourceWizardDBSchemaProviderFactory>();
            DevExpress.XtraReports.Web.ASPxQueryBuilder.StaticInitialize();
            DevExpress.XtraReports.Web.ASPxWebDocumentViewer.StaticInitialize();
            RegisterAccounts();
            DevExpress.XtraReports.Web.ASPxReportDesigner.StaticInitialize();

            //DefaultReportDesignerContainer.RegisterDataSourceWizardConfigFileConnectionStringsProvider();
        }
        void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex is HttpUnhandledException)
            {
                Session.Add("error", ex);
                Server.ClearError();
                Response.Redirect("~/Oops.aspx", false);
            }
            else if (ex is HttpException)
            {
                HttpException httpException = ex as HttpException;
                if (httpException != null)
                {
                    Session.Add("error", httpException);
                    string erro = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], httpException.Message);
                    Server.Transfer("Oops.aspx?Erro=" + erro, false);
                }
            }
        }
        void Session_Start(object sender, EventArgs e)
        {
            Session["error"] = "";
        }
        void RegisterAccounts()
        {
            //AccountManager.RegisterAmazon("FileManagerAmazonAccount", FileManagmentUtils.GetAmazonAccessKeyID(), FileManagmentUtils.GetAmazonSecretAccessKey());
            //AccountManager.RegisterAmazon("UploadAmazonAccount", UploadingUtils.GetAmazonAccessKeyID(), UploadingUtils.GetAmazonSecretAccessKey());
            //AccountManager.RegisterAzure("FileManagerAzureAccount", FileManagmentUtils.GetAzureStorageAccountName(), FileManagmentUtils.GetAzureAccessKey());
            //AccountManager.RegisterAzure("UploadAzureAccount", UploadingUtils.GetAzureStorageAccountName(), UploadingUtils.GetAzureAccessKey());
            //AccountManager.RegisterDropbox("FileManagerDropboxAccount", FileManagmentUtils.GetDropboxAccessTokenValue());
            //AccountManager.RegisterDropbox("UploadDropboxAccount", UploadingUtils.GetDropboxAccessTokenValue());
            AccountManager.RegisterOneDrive("FileManagerOneDriveAccount", FileManagmentUtils.GetOneDriveClientIDValue(), FileManagmentUtils.GetOneDriveClientSecretValue());
            //AccountManager.RegisterOneDrive("UploadOneDriveAccount", UploadingUtils.GetOneDriveClientIDValue(), UploadingUtils.GetOneDriveClientSecretValue());
            AccountManager.RegisterGoogleDrive("FileManagerGoogleDriveAccount", FileManagmentUtils.GetGoogleDriveClientEmailValue(), FileManagmentUtils.GetGoogleDrivePrivateKeyValue());
            //AccountManager.RegisterGoogleDrive("UploadGoogleDriveAccount", UploadingUtils.GetGoogleDriveClientEmailValue(), UploadingUtils.GetGoogleDrivePrivateKeyValue());
        }
    }
}