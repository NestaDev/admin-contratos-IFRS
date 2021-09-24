using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Carteira : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string sgbd = System.Configuration.ConfigurationManager.AppSettings["sgbd"];
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
                if (AcessoInternet)
                {
                    //pnlRightCol.Visible = false;
                    //gridCarteira.SettingsDataSecurity.AllowEdit = false;
                }
                hfOperacao.Value = string.Empty;
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
                (gridCarteira.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
                AsyncPostBackTrigger tr = new AsyncPostBackTrigger();
                tr.ControlID = btnSelEmp.UniqueID;
                uptGrid.Triggers.Add(tr);
            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            ASPxTreeList tree = (ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList");
            tree.DataBind();
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
            if (gridCarteira.VisibleRowCount > 0)
            {
                hfOperacao.Value = "excluir";
                (gridCarteira.Columns["CommandColumn"] as GridViewColumn).Visible = true;
                btnexcluir.Enabled = false;
                btnOK.Enabled = true;
                btnCancelar.Enabled = true;
            }
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            gridCarteira.DataBind();
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
                    var ID = gridCarteira.GetSelectedFieldValues("CAIDCTRA");
                    for (int i = 0; i < ID.Count; i++)
                    {
                        string exec = DataBase.Consultas.DeleteFrom(str_conn, "DELETE CACTEIRA where CAIDCTRA=" + ID[i] + " ");
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
                    (gridCarteira.Columns["CommandColumn"] as GridViewColumn).Visible = false;
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
                    (gridCarteira.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    btnexcluir.Enabled = true;
                    btnOK.Enabled = false;
                    btnCancelar.Enabled = false;
                    break;
            }
            hfOperacao.Value = null;
        }
        protected void gridCarteira_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var itens in e.InsertValues)
            {
                string ID = DataBase.Consultas.Consulta(str_conn, "select max(CAIDCTRA) + 1 from CACTEIRA", 1)[0];
                    int iID = Convert.ToInt32(ID);
                    string exec = DataBase.Consultas.InsertInto(str_conn, "INSERT INTO CACTEIRA (CAIDCTRA,CADSCTRA,CADSAB20,TVIDESTR) VALUES (" + ID + ",'" + itens.NewValues["CADSCTRA"].ToString() + "','" + itens.NewValues["CADSAB20"].ToString() + "'," + hfDropEstr.Value + ")");

            }
            foreach(var item in e.UpdateValues)
            {
                string CAIDCTRA = item.NewValues["CAIDCTRA"].ToString() == string.Empty ? item.OldValues["CAIDCTRA"].ToString() : item.NewValues["CAIDCTRA"].ToString();
                string CADSCTRA = item.NewValues["CADSCTRA"].ToString() == string.Empty ? item.OldValues["CADSCTRA"].ToString() : item.NewValues["CADSCTRA"].ToString();
                string CADSAB20 = item.NewValues["CADSAB20"].ToString() == string.Empty ? item.OldValues["CADSAB20"].ToString() : item.NewValues["CADSAB20"].ToString();
                string upd = "update CACTEIRA set CADSCTRA='@CADSCTRA',CADSAB20='@CADSAB20' where CAIDCTRA=@CAIDCTRA";
                upd = upd.Replace("@CADSCTRA", CADSCTRA);
                upd = upd.Replace("@CADSAB20", CADSAB20);
                upd = upd.Replace("@CAIDCTRA", CAIDCTRA);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, upd);
            }
            (gridCarteira.Columns["CommandColumn"] as GridViewColumn).Visible = false;
            uptGrid.Update();
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            uptGrid.Update();
        }
        protected void sqlCarteira_Load(object sender, EventArgs e)
        {
            //if (hfDropEstr.Value != "")
            //{
            //    hfHierarqEstr.Value = DataBase.Consultas.HierarquiaEstrut(str_conn, hfDropEstr.Value, sgbd);
            //    sqlCarteira.SelectCommand = "select CAIDCTRA, CADSCTRA,CADSAB20,tvidestr from CACTEIRA where tvidestr in (" + hfHierarqEstr.Value + ") order by 1";
            //    gridCarteira.DataBind();
            //}
        }

        protected void gridCarteira_Load(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            gridCarteira.SettingsDataSecurity.AllowInsert = perfil != "3";
            gridCarteira.SettingsDataSecurity.AllowEdit = perfil != "3";
            gridCarteira.SettingsDataSecurity.AllowDelete = perfil != "3";
        }

        protected void btnInserir_Load(object sender, EventArgs e)
        {
            ASPxButton obj = (ASPxButton)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }

        protected void btnexcluir_Load(object sender, EventArgs e)
        {
        }
    }
}