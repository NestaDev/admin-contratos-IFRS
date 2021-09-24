using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Web.Configuration;
using Google.Cloud.TextToSpeech.V1;
using System.Media;

namespace WebNesta_IRFS_16
{
    public partial class Site : System.Web.UI.MasterPage
    {
        public static string lang;
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string loginUrl = System.Configuration.ConfigurationManager.AppSettings["login"];
        public static string chaveCript = System.Configuration.ConfigurationManager.AppSettings["chaveCript"];
        public static string vetorCript = System.Configuration.ConfigurationManager.AppSettings["vetorCript"];
        public static string debug = System.Configuration.ConfigurationManager.AppSettings["debug"];
        public static string debugUser = System.Configuration.ConfigurationManager.AppSettings["debugUser"];
        public static string langDefault = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
        public static bool realEstate = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["realestate"]);
        public static bool testeenergisa = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["testeenergisa"]);
        public static bool tutorial = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["tutorial"]);
        public static string usuarioPersist;
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
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    lang = Session["langSession"].ToString();
                }
                catch
                {
                    lang = langDefault;
                }
                hfLoginPage.Value = loginUrl;
                string user = string.Empty;
                string ID = string.Empty;
                try
                {

                    bool internet = Convert.ToBoolean(ConfigurationManager.AppSettings["AcessoInternet"]);
                    HttpCookie myCookie = HttpContext.Current.Request.Cookies[GerarHashMd5("acesso")];
                    string userDecripted = string.Empty;
                    if (debug == "1")
                    {
                        var teste = debugUser;
                        usuarioPersist = debugUser;
                        var i = DataBase.Consultas.ValidaUsuario(str_conn, teste);
                        userDecripted = debugUser;
                        user = userDecripted;
                    }
                    else if (debug == "0")
                    {
                        if (myCookie == null)
                            Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                        usuarioPersist = DataBase.Funcoes.Decriptar(chaveCript, vetorCript, myCookie.Value);
                        userDecripted = DataBase.Funcoes.Decriptar(chaveCript, vetorCript, myCookie.Value);
                        if (userDecripted != string.Empty)
                        {
                            user = userDecripted;
                        }
                    }
                    //DateTime dtExpira = Convert.ToDateTime(DataBase.Consultas.Consulta(str_conn, "select UTDTCASE from UTUTISEN where USIDUSUA='" + usuarioPersist + "' and utidutse in (select max(utidutse) from UTUTISEN where USIDUSUA='" + usuarioPersist + "') and USFLFLAG=1", 1)[0]);
                    //string data = string.Format(CultureInfo.GetCultureInfo(lang), "{0:d}", dtExpira);
                    //lblValidadeSenha.Text = data;
                }
                catch
                {
                    Response.Write("<script language=javascript>alert('Sua sessão expirou');</script>");
                    Response.Redirect(loginUrl);
                }
                string currentPageName = Request.Url.Segments[Request.Url.Segments.Length - 1];
                currentPageName = currentPageName.Replace(".aspx", "");
                currentPageName = currentPageName.ToUpper();
                if (currentPageName == "DEFAULT" || currentPageName == "SETUP" || currentPageName == "INVOICE" || currentPageName == "BOLETAGEM" || currentPageName == "UTILITIES" || currentPageName == "WORKFLOW" || currentPageName == "USERPROFILE" || currentPageName == "LAYOUTOCR" || currentPageName == "LEITURAOCR")
                {
                    hf2sides.Value = "0";
                }
                else
                {
                    hf2sides.Value = "1";
                }
                string sql = "SELECT TVIDESTR, TVDSESTR FROM TVESTRUT WHERE TVIDESTR IN ";
                sql += "(SELECT min(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A ";
                sql += "WHERE B.TVIDESTR = A.TVIDESTR ";
                sql += "AND A.FOTPIDTP = 6 ";
                sql += "AND A.FOCDLICE IS NOT NULL ";
                sql += "AND B.TVNVESTR IN(1, 0) ";
                sql += "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "') or ";
                sql += "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR ";
                sql += "FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "')))) ";
                var resultSQL = DataBase.Consultas.Consulta(str_conn, sql, 2);
                //Response.Write(resultSQL[0]);
                lblEstruturaCorporativa.Text = resultSQL[1];
                string sql2 = "SELECT TVIDESTR, TVDSESTR,TVIDPAIS FROM TVESTRUT WHERE TVIDESTR IN ";
                sql2 += "(SELECT max(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A ";
                sql2 += "WHERE B.TVIDESTR = A.TVIDESTR ";
                sql2 += "AND A.FOTPIDTP = 6 ";
                sql2 += "AND A.FOCDLICE IS NOT NULL ";
                sql2 += "AND B.TVNVESTR IN(1, 0) ";
                sql2 += "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "') or ";
                sql2 += "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR ";
                sql2 += "FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "')))) ";
                //MsgException(sql2, 2,"");
                var resultSQL2 = DataBase.Consultas.Consulta(str_conn, sql2, 3);
                hfEstruturaCorporativa.Value = resultSQL2[0];
                string sql3 = "select min(utdtinic) from UTUTISEN where USIDUSUA = '" + usuarioPersist + "' ";
                //string sql3 = "select min(utdtinic) from UTUTISEN where USIDUSUA in ( ";
                //sql3 += "select USIDUSUA from VIFSFUSU where TVIDESTR in  ";
                //sql3 += "(SELECT TVIDESTR FROM TVESTRUT WHERE TVIDESTR IN ";
                //sql3 += "(SELECT min(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A ";
                //sql3 += "WHERE B.TVIDESTR = A.TVIDESTR ";
                //sql3 += "AND A.FOTPIDTP = 6 ";
                //sql3 += "AND A.FOCDLICE IS NOT NULL ";
                //sql3 += "AND B.TVNVESTR IN(1, 0) ";
                //sql3 += "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "') or ";
                //sql3 += "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR ";
                //sql3 += "FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "'))))))";
                string dtDesde = DataBase.Consultas.Consulta(str_conn, sql3, 1)[0];
                DateTime clienteDesde = dtDesde == string.Empty ? DateTime.Now : Convert.ToDateTime(dtDesde);
                lblClientedesde.Text = string.Format(CultureInfo.GetCultureInfo(lang), "{0:d}", clienteDesde);
                DataBase.RastreioLogon rastreio = new DataBase.RastreioLogon();
                rastreio.Usuario = usuarioPersist;
                rastreio.str_conn = str_conn;
                rastreio.Modulo = Request.Url.Segments[Request.Url.Segments.Length - 1];
                rastreio.RastrearLogon();
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            if (!this.IsPostBack)
            {
                BotoesMenu();
                Session["Reset"] = true;
                Configuration config = WebConfigurationManager.OpenWebConfiguration("~/Web.Config");
                SessionStateSection section = (SessionStateSection)config.GetSection("system.web/sessionState");
                int timeout = (int)section.Timeout.TotalMinutes * 1000 * 60;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "SessionAlert", "SessionExpireAlert(" + timeout + ");", true);
            }

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
        protected void BotoesMenu()
        {
            if (!tutorial)
            {
                btnTutorial.Attributes.Remove("onclick");
                btnTutorial.Attributes.Remove("href");
            }
            if (testeenergisa)
            {
                btn2.Enabled = false;
                btn3.Enabled = false;
                btn4.Enabled = false;
                btn5.Enabled = false;
                btn6.Enabled = false;
                btn7.Enabled = false;
                btn9.Enabled = false;
                btn10.Enabled = false;
                link1.Enabled = false;
                link2.Enabled = false;
                link3.Enabled = false;
                link4.Enabled = false;
                link5.Enabled = false;
                link6.Enabled = false;
                link7.Enabled = false;
                link8.Enabled = false;
                link9.Enabled = false;
                link10.Enabled = false;
                link11.Enabled = false;
                link12.Enabled = false;
                link13.Enabled = false;
                link14.Enabled = false;
                LinkButton3.Enabled = false;
                link16.Enabled = false;
            }
            else
            {
                btn2.Enabled = realEstate;
                btn3.Enabled = realEstate;
                btn5.Enabled = realEstate;
                btn7.Enabled = realEstate;
                link6.Enabled = realEstate;
                link9.Enabled = realEstate;
                link10.Enabled = realEstate;
                link11.Enabled = realEstate;
                if (!realEstate)
                    link11.OnClientClick = "";
            }
            try
            {
                string sql = DataBase.Consultas.Consulta(str_conn, "select ettj from ITCCONFIG", 1)[0];
                if (sql == "N")
                {
                    link13.Enabled = false;
                    link14.Enabled = false;
                }
            }
            catch
            {
                link13.Enabled = false;
                link14.Enabled = false;
            }
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            if (hfControle.Value == "2")
                Response.Redirect("Default");
            else if (hfControle.Value == "3")
                Response.Redirect(hfCurrentPage.Value);
            else
                Response.Redirect(Request.Path.ToString());
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            Session["ClickBtnApp"] = btn.ID;
            Response.Redirect("Boletagem");
        }
        protected void Button2_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            Session["ClickBtnApp"] = btn.ID;
            Response.Redirect("Captura");
        }
        protected void btn_app_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
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
        protected void lnk_Navi_footer(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            Response.Redirect(btn.CommandArgument + "?naviBefore=" + System.IO.Path.GetFileName(Request.Url.AbsolutePath));
        }
        protected void RequestLanguageChange_Click(object sender, EventArgs e)
        {
            bool MultiIdioma = true;
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
        /// <summary>
        /// 
        /// </summary>
        /// <param name="msg">Texto para mensagem de alerta</param>
        /// <param name="exc">0 e 2=Mensagem de Sucesso 1=Mensagem de Erro 3=Mensagem de Erro com Botão OK</param>
        /// <param name="curr">Quando exc=3 Inserir string para response.redirect()</param>
        protected void MsgException(string msg, int exc, string curr)
        {
            if (exc == 1)
            {
                lblMsgException.CssClass = "text-danger";
                lblMsgException.Text = "Exception: " + msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 0)
            {
                lblMsgException.CssClass = "text-sucess";
                lblMsgException.Text = msg;
                btnOK.Visible = true;
                btnClose.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 2)
            {
                lblMsgException.CssClass = "text-sucess";
                lblMsgException.Text = msg;
                hfControle.Value = "2";
                btnOK.Visible = true;
                btnClose.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 3)
            {
                lblMsgException.CssClass = "text-sucess";
                lblMsgException.Text = msg;
                hfControle.Value = "3";
                hfCurrentPage.Value = curr;
                btnOK.Visible = true;
                btnClose.Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void lnkSair_Click(object sender, EventArgs e)
        {
            //var newCookie = new HttpCookie(GerarHashMd5("saindo"));
            //newCookie.Value = DataBase.Funcoes.Encriptar(chaveCript, vetorCript, "saindo");
            var httpContext = new HttpContextWrapper(HttpContext.Current);
            var _response = httpContext.Response;
            HttpCookie cookie2 = new HttpCookie(GerarHashMd5("acesso"))
            {
                Expires = DateTime.Now.AddDays(-1) // or any other time in the past
            };
            _response.Cookies.Set(cookie2);

            if (Request.Cookies[GerarHashMd5("loginSSO")] != null)
            {
                Response.Cookies[GerarHashMd5("acesso")].Value = "";
                Response.Cookies[GerarHashMd5("acesso")].Expires = DateTime.Now.AddDays(-1);
            }

            string[] cookies = Request.Cookies.AllKeys;
            foreach (string cookie in cookies)
            {
                Response.Cookies[cookie].Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Remove(cookie);
            }
            if (Request.Cookies[GerarHashMd5("loginSSO")] != null)
            {
                Response.Redirect("https://login.microsoftonline.com/common/oauth2/v2.0/logout?post_logout_redirect_uri="+loginUrl+"/Login?logout=sim");
            }
            else
            {
                Response.Redirect(loginUrl);
            }
            
        }
        protected void lnkAbout_Click(object sender, EventArgs e)
        {
            popupAbout.ShowOnPageLoad = true;
        }
        protected void CriaCookie(string valor, string cookie)
        {
            valor = DataBase.Funcoes.Encriptar(chaveCript, vetorCript, valor);
            var newCookie = new HttpCookie(DataBase.Funcoes.GerarHashMd5(cookie));
            newCookie.Value = valor;
            //newCookie.Expires = DateTime.Now.AddDays(7);
            newCookie.Secure = true;
            newCookie.HttpOnly = true;
            newCookie.SameSite = SameSiteMode.None;
            Response.Cookies.Add(newCookie);
        }
        protected void btnMenu_Command(object sender, CommandEventArgs e)
        {
            if (sender.GetType().Name == "ImageButton")
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
            else if (sender.GetType().Name == "LinkButton")
            {
                LinkButton btn = (LinkButton)sender;
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

        }

        protected void lblNotifiesQtd_Load(object sender, EventArgs e)
        {
            AtualizaNotificao();
        }
        public void AtualizaNotificao()
        {
            var lbl = (Label)lblNotifiesQtd;
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

        protected void btnAtualizaNotifies_Click(object sender, EventArgs e)
        {
            AtualizaNotificao();
        }

        protected void ASPxCallback1_Callback(object source, DevExpress.Web.CallbackEventArgs e)
        {
            TextSpeechGoogle(e.Parameter);
        }
        public void TextSpeechGoogle(string texto)
        {
            //ltrAudio.Text = null;
            //if (File.Exists(Server.MapPath("~/Content/GoogleSpeech.wav")))
            //    File.Delete(Server.MapPath("~/Content/GoogleSpeech.wav"));
            //string[] filePaths = Directory.GetFiles(Path.Combine(Server.MapPath("~/Content"), "GoogleSpeech*.wav"));
            //foreach (string filePath in filePaths)
            //    File.Delete(filePath);
            string fileName = "GoogleSpeech" + DateTime.Now.ToString("ddMMyyyyhhmmsssff") + ".wav";
            if (Environment.GetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS") == null)
                Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", Server.MapPath("~/KeyFiles/trans-campus-246715-29b819c67877.json"));

            var client = TextToSpeechClient.Create();

            var input = new SynthesisInput
            {
                Text = texto
            };
            var voiceSelection = new VoiceSelectionParams
            {
                LanguageCode = lang,
                Name = lang + "-Wavenet-A"
            };
            var audioConfig = new AudioConfig
            {
                AudioEncoding = AudioEncoding.Linear16
            };
            var response = client.SynthesizeSpeech(input, voiceSelection, audioConfig);
            using (var output = File.Create(Path.Combine(Server.MapPath("~/Content/" + fileName))))
            {
                response.AudioContent.WriteTo(output);
            }
            callTextSpeech.JSProperties["cptemarquivo"] = "true";
            callTextSpeech.JSProperties["cparquivo"] = "../Content/" + fileName;
            //SoundPlayer player = new SoundPlayer();
            //player.SoundLocation = Server.MapPath("~/Content/GoogleSpeech.wav");
            //player.PlaySync();
            //ltrAudio.Text = "<audio controls runat='server' type='audio/mp3' src='../Content/GoogleSpeech.wav' autoplay />";
        }

        protected void ASPxCallbackPanel1_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            TextSpeechGoogle(e.Parameter);
        }
    }
}