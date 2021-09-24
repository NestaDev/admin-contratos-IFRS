using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class ClasseProduto : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string usuarioPersist;
        public static bool AcessoInternet;
        protected void Page_Init(object sender, EventArgs e)
        {
            AcessoInternet = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["AcessoInternet"]);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (AcessoInternet)
            {
                pnlBotoes.Visible = false;
                gridClasseProduto.SettingsDataSecurity.AllowEdit = false;
            }
            try
            {
                lang = Session["langSession"].ToString();
            }
            catch
            {
                lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
            }
            if (!IsPostBack)
            {
                HttpCookie cookiePais = HttpContext.Current.Request.Cookies["PAIDPAIS"];
                if (cookiePais == null)
                    hfPaisUser.Value = "1";
                else
                    hfPaisUser.Value = cookiePais.Value;
                hfOperacao.Value = string.Empty;
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
                (gridClasseProduto.Columns["CommandColumn"] as GridViewColumn).Visible = false;
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
        protected void MsgException(string msg, int exc)
        {
            if (exc == 1)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
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
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }

        protected void dropProposito_SelectedIndexChanged(object sender, EventArgs e)
        {
            CarregaGrid(dropProposito.Value.ToString(), dropProposito.Text.ToString());
        }
        protected void CarregaGrid(string prodid, string prodds)
        {
            hfCMTPIDCM.Value = prodid;
            txtDescri.Text = prodds;
            btnInserir.Enabled = true;
            btnexcluir.Enabled = true;
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
            (gridClasseProduto.Columns["CommandColumn"] as GridViewColumn).Visible = false;
            gridClasseProduto.DataBind();
        }
        protected void btnexcluir_Click(object sender, EventArgs e)
        {
            hfOperacao.Value = "excluir";
            (gridClasseProduto.Columns["CommandColumn"] as GridViewColumn).Visible = true;
            btnexcluir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            switch (hfOperacao.Value)
            {
                case "alterar":
                    Response.Redirect(currentPage);
                    break;
                case "inserir":
                    Response.Redirect(currentPage);
                    break;
                case "excluir":
                    if (dropProposito.SelectedIndex != 0)
                        CarregaGrid(dropProposito.Value.ToString(), dropProposito.Text.ToString());
                    break;
            }
        }
        
        protected void btnOK_Click(object sender, EventArgs e)
        {
            switch (hfOperacao.Value)
            {
                case "alterar":
                    //Response.Redirect(currentPage);
                    break;
                case "inserir":
                    //Response.Redirect(currentPage);
                    break;
                case "excluir":
                    int validOK = 0;
                    int validERRO = 0;
                    string textOK = string.Empty, textErro = string.Empty;
                    var ID = gridClasseProduto.GetSelectedFieldValues("CMTPIDCM;PRTPIDOP;PAIDPAIS");
                    for (int i = 0; i < ID.Count; i++)
                    {
                        string CMTPIDCM = ID[i].ToString().Split('|')[0];
                        string PRTPIDOP = ID[i].ToString().Split('|')[1];
                        string PAIDPAIS = ID[i].ToString().Split('|')[2];
                        string exec = DataBase.Consultas.DeleteFrom(str_conn, "");
                        if (exec == "OK")
                        {
                            validOK = validOK + 1;
                            textOK += CMTPIDCM + "#" + PRTPIDOP + "#"+ PAIDPAIS +",";

                        }
                        else
                        {
                            validERRO = validERRO + 1;
                            textErro += CMTPIDCM + "#" + PRTPIDOP + "#" + PAIDPAIS + ",";
                        }
                    }
                    if (textOK.Length != 0)
                        textOK = textOK.Substring(0, textOK.Length - 1);
                    if (textErro.Length != 0)
                        textErro = textErro.Substring(0, textErro.Length - 1);
                    string erro = validERRO == 0 ? "" : HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_exception").ToString() + "<br />#ID:" + textErro;
                    string ok = validOK == 0 ? "" : HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString() + "<br />#ID:" + textOK;
                    MsgException(ok + "<br />" + erro, 2);
                    if (dropProposito.SelectedIndex != 0)
                        CarregaGrid(dropProposito.Value.ToString(), dropProposito.Text.ToString());
                    break;
            }
        }

        protected void gridClasseProduto_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            string sql = "select max(po.prtpidop) + 1 from prtpoper po, cmtpcmcl cm "+
            "where po.cmtpidcm = cm.cmtpidcm "+
            "and po.paidpais = cm.paidpais "+
            "and cm.CMTPIDCM = "+hfCMTPIDCM.Value+" and po.PAIDPAIS = "+hfPaisUser.Value+"";
            foreach (var itens in e.InsertValues)
            {
                string ID = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                try
                {
                    int iID = Convert.ToInt32(ID);
                    string exec = DataBase.Consultas.InsertInto(str_conn, "INSERT INTO PRTPOPER (CMTPIDCM,PRTPIDOP,PAIDPAIS,PRTPNMOP,PRFLSMPR) VALUES ("+hfCMTPIDCM.Value+","+ID+","+ hfPaisUser.Value + ",'"+itens.NewValues["PRTPNMOP"].ToString()+"','"+itens.NewValues["PRFLSMPR"].ToString()+"')");
                }
                catch (Exception ex)
                {
                    MsgException(ex.Message.ToString(), 1);
                }

            }
            (gridClasseProduto.Columns["CommandColumn"] as GridViewColumn).Visible = false;
        }
    }
}