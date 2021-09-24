using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Feriados : System.Web.UI.Page
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string usuarioPersist;
        protected void Page_Load(object sender, EventArgs e)
        {
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
                hfPais.Value = cookiePais == null?"1":cookiePais.Value;
                dropPais.Value = Convert.ToInt32(hfPais.Value);
                hfOperacao.Value = string.Empty;
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
                (gridFeriados.Columns["CommandColumn"] as GridViewColumn).Visible = false;
            }
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
        protected void btnexcluir_Click(object sender, EventArgs e)
        {
            hfOperacao.Value = "excluir";
            (gridFeriados.Columns["CommandColumn"] as GridViewColumn).Visible = true;
            btnexcluir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
        }
        protected void btnOK_Click(object sender, EventArgs e)
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
                    int validOK = 0;
                    int validERRO = 0;
                    string textOK = string.Empty, textErro = string.Empty;
                    var ID = gridFeriados.GetSelectedFieldValues("TBIDFERI");
                    for (int i = 0; i < ID.Count; i++)
                    {
                        string exec = DataBase.Consultas.DeleteFrom(str_conn, "UPDATE tbferiad set TBFLFERI=1 where TBIDFERI=" + ID[i] + " ");
                        if (exec == "OK")
                        {
                            validOK = validOK + 1;
                            textOK += ID[i] + ",";

                        }
                        else
                        {
                            validERRO = validERRO + 1;
                            textErro += ID[i] + ",";
                        }
                    }
                    if (textOK.Length != 0)
                        textOK = textOK.Substring(0, textOK.Length - 1);
                    if (textErro.Length != 0)
                        textErro = textErro.Substring(0, textErro.Length - 1);
                    string erro = validERRO == 0 ? "" : HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_exception").ToString() + "<br />#ID:" + textErro;
                    string ok = validOK == 0 ? "" : HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString() + "<br />#ID:" + textOK;
                    MsgException(ok + "<br />" + erro, 2);
                    (gridFeriados.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    btnexcluir.Enabled = true;
                    break;
            }
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
                    (gridFeriados.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    btnexcluir.Enabled = true;
                    break;
            }
        }

        protected void gridFeriados_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            foreach (var itens in e.UpdateValues)
            {
                string dt = itens.NewValues["TBDTFERI"].ToString() == string.Empty ? itens.OldValues["TBDTFERI"].ToString(): itens.NewValues["TBDTFERI"].ToString();
                string nm = itens.NewValues["TBNMFERI"].ToString() == string.Empty ? itens.OldValues["TBNMFERI"].ToString() : itens.NewValues["TBNMFERI"].ToString();
                string pais = itens.NewValues["PAIDPAIS"].ToString() == string.Empty ? itens.OldValues["PAIDPAIS"].ToString() : itens.NewValues["PAIDPAIS"].ToString();
                DateTime date = Convert.ToDateTime(dt, CultureInfo.GetCultureInfo(lang));
                string sql = "update tbferiad set tbdtferi=convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", date.Day + "/" + date.Month + "/" + date.Year) + "',103),tbnmferi='"+ nm + "', paidpais="+ pais + " where tbidferi="+itens.Keys["TBIDFERI"] +"";
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sql);
            }
            foreach (var itens in e.InsertValues)
            {
                DateTime dt = Convert.ToDateTime(itens.NewValues["TBDTFERI"].ToString(), CultureInfo.GetCultureInfo(lang));
                string exec = DataBase.Consultas.InsertInto(str_conn, "INSERT INTO TBFERIAD (TBDTFERI,TBNMFERI,PAIDPAIS) VALUES(convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", dt.Day+"/"+dt.Month+"/"+dt.Year) + "',103),'" + itens.NewValues["TBNMFERI"].ToString() + "',"+ itens.NewValues["PAIDPAIS"].ToString() + ")");
            }
            (gridFeriados.Columns["CommandColumn"] as GridViewColumn).Visible = false;
        }

        protected void gridFeriados_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            HttpCookie cookiePais = HttpContext.Current.Request.Cookies["PAIDPAIS"];
            string pais = cookiePais == null ? "1" : cookiePais.Value;
            pais = hfPais.Value == pais ? hfPais.Value : pais + "," + hfPais.Value;
            if (e.Column.FieldName== "PAIDPAIS")
            {
                sqlPais2.SelectCommand = "select PAIDPAIS,PANMPAIS from PAPAPAIS WHERE PAIDPAIS in ("+pais+")";
                sqlPais2.DataBind();
            }
        }
    }
}