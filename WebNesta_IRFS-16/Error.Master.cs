using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Error : System.Web.UI.MasterPage
    {
        public static string lang;
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string loginUrl = System.Configuration.ConfigurationManager.AppSettings["login"];
        public static string chaveCript = System.Configuration.ConfigurationManager.AppSettings["chaveCript"];
        public static string vetorCript = System.Configuration.ConfigurationManager.AppSettings["vetorCript"];
        public static string debug = System.Configuration.ConfigurationManager.AppSettings["debug"];
        public static string debugUser = System.Configuration.ConfigurationManager.AppSettings["debugUser"];
        public static string langDefault = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
        public static string usuarioPersist;
        public static bool realEstate = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["realestate"]);
        protected void BotoesMenu()
        {
            btn2.Enabled = realEstate;
            btn3.Enabled = realEstate;
            btn5.Enabled = realEstate;
            btn7.Enabled = realEstate;
            link9.Enabled = realEstate;
            link10.Enabled = realEstate;
            link11.Enabled = realEstate;
            if (!realEstate)
                link11.OnClientClick = "";
        }
        public static string GerarHashMd5(string input)
        {
            MD5 md5Hash = MD5.Create();
            // Converter a String para array de bytes, que é como a biblioteca trabalha.
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));
            // Cria-se um StringBuilder para recompôr a string.
            StringBuilder sBuilder = new StringBuilder();
            // Loop para formatar cada byte como uma String em hexadecimal
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            return sBuilder.ToString();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            BotoesMenu();
            try
            {
                lang = Session["langSession"].ToString();
            }
            catch
            {
                lang = langDefault;
            }
            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(lang);
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(lang);
            ImageButton btn_culture = Page.Master.FindControl("btn_" + CultureInfo.CurrentCulture.Name.Replace("-", "_")) as ImageButton;
            //btn_culture.Attributes.Add("style", "border: 1px solid #c0c0c0;background-color: #bddfdf;width:65px");
            btn_culture.Enabled = false;
        }
        protected void lnk_Navi_footer(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            Response.Redirect(btn.CommandArgument + "?naviBefore=" + System.IO.Path.GetFileName(Request.Url.AbsolutePath));
        }
        protected void RequestLanguageChange_Click(object sender, EventArgs e)
        {
            bool MultiIdioma = false;
            if (MultiIdioma)
            {
                ImageButton senderLink = sender as ImageButton;
                //store requested language as new culture in the session
                Session["langSession"] = senderLink.CommandArgument;
                string langValue = senderLink.CommandArgument;
                if (!String.IsNullOrEmpty(langValue))
                {
                    Thread.CurrentThread.CurrentCulture =
                        CultureInfo.CreateSpecificCulture(langValue);
                    Thread.CurrentThread.CurrentUICulture = new
                        CultureInfo(langValue);
                }
                //reload last requested page with new culture
                Response.Redirect(Request.Url.Segments[Request.Url.Segments.Length - 1]);
            }
            else
            {
                popupIdioma.ShowOnPageLoad = true;
            }
        }
        protected void btnMenu_Command(object sender, CommandEventArgs e)
        {
            ImageButton btn = (ImageButton)sender;
            if (btn.CommandArgument == "#") return;
            Session["ClickBtnApp"] = btn.ID;
            if (btn.CommandArgument.IndexOf("http") >= 0)
            {
                ResponseHelper.Redirect(btn.CommandArgument, "_blank", "");
            }
            else if (btn.CommandArgument.IndexOf("?") >= 0)
            {
                string criptRequest = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], "RequisitaContrato");
                Response.Redirect(btn.CommandArgument + criptRequest);
            }
            else
            {
                Response.Redirect(btn.CommandArgument);
            }
        }
        protected void lnkSair_Click(object sender, EventArgs e)
        {
            var newCookie = new HttpCookie(GerarHashMd5("saindo"));
            newCookie.Value = DataBase.Funcoes.Encriptar(chaveCript, vetorCript, "saindo");
            if (Request.Cookies[GerarHashMd5("acesso")] != null)
            {
                Request.Cookies[GerarHashMd5("acesso")].Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Remove(GerarHashMd5("acesso"));
            }
            Session.Abandon();
            Response.Redirect(loginUrl);
        }
        protected void lnkAbout_Click(object sender, EventArgs e)
        {
            popupAbout.ShowOnPageLoad = true;
        }
        protected void lblNotifiesQtd_Load(object sender, EventArgs e)
        {
            var lbl = (Label)sender;
            string sqlNotifies = "select count(*) from WFWFCHAT WHERE USIDUSUA2='" + usuarioPersist + "' AND WFDTDATA IS NULL";
            int result = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlNotifies, 1)[0]);
            if (result > 0)
            {
                lbl.Text = result.ToString();
            }
            else
            {
                lbl.Text = string.Empty;
            }
        }
    }
}