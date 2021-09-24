using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using DevExpress.Web.Office;
using DevExpress.XtraRichEdit;
using DevExpress.Web.ASPxRichEdit;

namespace WebNesta_IRFS_16
{
    public partial class Utilities : BasePage.BasePage
    {
        public string perfil;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }

        protected void DemoRichEdit_Callback(object sender, CallbackEventArgsBase e)
        {
            ASPxRichEdit rich = (ASPxRichEdit)sender;
            if (fileManager.SelectedFile != null)
                rich.Open(Path.Combine(Server.MapPath(fileManager.SelectedFile.FullName)));
            //Arquivos\Base Clausulas\KENAN-_1.DOC
            //var teste = e.Parameter;
            //var path = Server.MapPath("GED");
            //rich.Open(Path.Combine(path, teste));
        }

        protected void fileManager_CustomThumbnail(object source, FileManagerThumbnailCreateEventArgs e)
        {
            try
            {
                switch (((FileManagerFile)e.Item).Extension.ToUpper()) //.jpg,.jpeg,.gif,.rtf,.txt,.doc,.docx,.pdf
                {
                    case ".JPG":
                        e.ThumbnailImage.Url = "GED/Icones/image.png";
                        break;
                    case ".JPEG":
                        e.ThumbnailImage.Url = "GED/Icones/image.png";
                        break;
                    case ".GIF":
                        e.ThumbnailImage.Url = "GED/Icones/image.png";
                        break;
                    case ".RTF":
                        e.ThumbnailImage.Url = "GED/Icones/doc.png";
                        break;
                    case ".TXT":
                        e.ThumbnailImage.Url = "GED/Icones/txt.png";
                        break;
                    case ".DOC":
                        e.ThumbnailImage.Url = "GED/Icones/word.png";
                        break;
                    case ".DOCX":
                        e.ThumbnailImage.Url = "GED/Icones/word.png";
                        break;
                    case ".PDF":
                        e.ThumbnailImage.Url = "GED/Icones/pdf.png";
                        break;
                }
            }
            catch
            {

            }
        }

        protected void fileManager_Load(object sender, EventArgs e)
        {
            ASPxFileManager file = (ASPxFileManager)sender;
            file.SettingsEditing.AllowCopy = perfil != "3";
            file.SettingsEditing.AllowCreate = perfil != "3";
            file.SettingsEditing.AllowDelete = perfil != "3";
            file.SettingsEditing.AllowMove = perfil != "3";
            file.SettingsEditing.AllowRename = perfil != "3";
            file.SettingsUpload.Enabled=perfil != "3";
        }
    }
}