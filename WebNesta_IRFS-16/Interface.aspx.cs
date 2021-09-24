using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Interface : System.Web.UI.Page
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string sgbd = System.Configuration.ConfigurationManager.AppSettings["sgbd"];
        public static string currentPage;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Page.Title = hfTituloPag.Value;
                try
                {
                    lang = Session["langSession"].ToString();
                }
                catch
                {
                    lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
                }
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
            }
            if (!IsPostBack)
            {
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
        protected void MsgException(string msg, int exc, string curr)
        {
            if (exc == 1)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = "Exception: " + msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 0)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "2";
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 3)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect(currentPage);
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            string retorno = string.Empty;
            List<Object> selectItems = gridContractPend.GetSelectedFieldValues(gridContractPend.KeyFieldName);
            foreach (object selectItemID in selectItems)
            {
                retorno = DataBase.Consultas.UpdtFrom(str_conn, "update carga_ifrs set log_erros=null,loaded=0 where opidcont="+selectItemID);
                if(retorno== "OK")
                {
                    string[] param_dados = new string[1];
                    param_dados[0] = "@p_opidcont" + "#" + selectItemID;
                    retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_QA_WS_CARGA_IFRS", param_dados, "null");
                }
            }
            gridContractPend.DataBind();

        }

        protected void ASPxGridView1_BeforePerformDataSelect(object sender, EventArgs e)
        {
            hfOPIDCONT.Value = (sender as DevExpress.Web.ASPxGridView).GetMasterRowKeyValue().ToString();
        }
    }
}