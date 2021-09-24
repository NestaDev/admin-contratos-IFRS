using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebNesta_IRFS_16.App_GlobalResources;

namespace WebNesta_IRFS_16
{
    public partial class PlanoContas : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string usuarioPersist;
        public static string perfil;
        public static bool AcessoInternet;
        protected void Page_Init(object sender, EventArgs e)
        {
            AcessoInternet = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["AcessoInternet"]);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (AcessoInternet)
            {
                //pnlBotoes.Visible = false;
                //gridPlanCont.SettingsDataSecurity.AllowEdit = false;
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
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                hfOperacao.Value = string.Empty;
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
                (gridPlanCont.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
            }
            ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
            treeView.DataBind();
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
        protected void btnexcluir_Click(object sender, EventArgs e)
        {
            hfOperacao.Value = "excluir";
            (gridPlanCont.Columns["CommandColumn"] as GridViewColumn).Visible = true;
            btnexcluir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
        }

        protected void gridPlanCont_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.UpdateValues)
            {
                string TVIDESTR = hfDropEstr.Value;
                string PFCDPLNC = item.NewValues["PFCDPLNC"].ToString() == string.Empty ? item.OldValues["PFCDPLNC"].ToString() : item.NewValues["PFCDPLNC"].ToString();
                string PFDSPLNC = item.NewValues["PFDSPLNC"].ToString() == string.Empty ? item.OldValues["PFDSPLNC"].ToString() : item.NewValues["PFDSPLNC"].ToString();
                string PFIDPLNC = item.Keys["PFIDPLNC"].ToString();
                string sqlUpdate = "UPDATE PFPLNCTA SET PFCDPLNC='@PFCDPLNC', PFDSPLNC='@PFDSPLNC' WHERE PFIDPLNC=@PFIDPLNC";
                sqlUpdate = sqlUpdate.Replace("@PFCDPLNC", PFCDPLNC);
                sqlUpdate = sqlUpdate.Replace("@PFDSPLNC", PFDSPLNC);
                sqlUpdate = sqlUpdate.Replace("@PFIDPLNC", PFIDPLNC);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            }
            foreach (var itens in e.InsertValues)
            {
                string[] param_dados = new string[2];
                param_dados[0] = "@p_ngcdtinu#5";
                param_dados[1] = "@p_tvidestr#1";
                string ID = DataBase.Consultas.ExecProcedure(str_conn, "FUNC_NUMERADOR", param_dados, "@return_val");
                try
                {
                    int iID = Convert.ToInt32(ID);
                    string exec = DataBase.Consultas.InsertInto(str_conn, "INSERT INTO PFPLNCTA(PFIDPLNC,PFCDPLNC,PFCDPLNR,PFDSPLNC,PFFLPLNN,PFFLCARC,CUIDCUST,PFFLRESU,PFSYSDATE,TVIDESTR) VALUES ("+ID+",'"+itens.NewValues["PFCDPLNC"].ToString() +"',null,'"+ itens.NewValues["PFDSPLNC"].ToString() + "','D',null,null,null,null,"+hfDropEstr.Value+")");
                }
                catch(Exception ex)
                {
                    MsgException(ex.Message.ToString(), 1);
                }

            }
            (gridPlanCont.Columns["CommandColumn"] as GridViewColumn).Visible = false;
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
                    var ID = gridPlanCont.GetSelectedFieldValues("PFIDPLNC");
                    for (int i = 0; i < ID.Count; i++)
                    {
                        string exec = DataBase.Consultas.DeleteFrom(str_conn, "delete PFPLNCTA where PFIDPLNC=" + ID[i] + " ");
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
                    (gridPlanCont.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    btnexcluir.Enabled = true;
                    btnOK.Enabled = false;
                    btnCancelar.Enabled = false;
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
                    (gridPlanCont.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    btnexcluir.Enabled = true;
                    break;
            }
        }
        protected void btnSelEmp_Click(object sender, EventArgs e)
        {
            uptGrid.Update();
            btnInserir.Enabled= perfil != "3";
            btnexcluir.Enabled= perfil != "3";
        }

        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = sender as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (DevExpress.Web.ASPxTreeList.TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }

        protected void gridPlanCont_Load(object sender, EventArgs e)
        {
            gridPlanCont.SettingsDataSecurity.AllowDelete= perfil != "3";
            gridPlanCont.SettingsDataSecurity.AllowEdit= perfil != "3";
            gridPlanCont.SettingsDataSecurity.AllowInsert= perfil != "3";
        }

        protected void btnInserir_Load(object sender, EventArgs e)
        {
        }
        protected void btnexcluir_Load(object sender, EventArgs e)
        {
        }
    }
}