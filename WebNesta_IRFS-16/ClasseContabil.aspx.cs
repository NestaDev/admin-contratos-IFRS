using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.OleDb;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataBase;
using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using DevExpress.Web.Data;

namespace WebNesta_IRFS_16
{
    public partial class ClasseContabil : BasePage.BasePage
    {
        GridViewCommandColumn ComandColumn { get { return (GridViewCommandColumn)gridContas.Columns[0]; } }
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string usuarioPersist;
        public static string perfil;
        protected override void OnPreLoad(EventArgs e)
        {
            //if(hfPRPRODID.Value != string.Empty)
            //{
            //    string sql = "SELECT MO.MOIDMODA, MO.MODSMODA FROM MODALIDA MO, VIPROMOD VI WHERE MO.MOIDMODA = VI.MOIDMODA AND VI.PRPRODID = " + hfPRPRODID.Value + " AND VI.TVIDESTR = 1";
            //    sqlMODALIDADE.SelectCommand = sql;
            //    sqlMODALIDADE.DataBind();
            //    gridContas.DataBind();
            //}
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack && !IsCallback)
            //{
            //    if (hfPRPRODID.Value != string.Empty)
            //    {
            //        string sql = "SELECT MO.MOIDMODA, MO.MODSMODA FROM MODALIDA MO, VIPROMOD VI WHERE MO.MOIDMODA = VI.MOIDMODA AND VI.PRPRODID = " + hfPRPRODID.Value + " AND VI.TVIDESTR = 1";
            //        sqlMODALIDADE.SelectCommand = sql;
            //        sqlMODALIDADE.DataBind();
            //        gridContas.DataBind();
            //    }
            //}
            Page.Title = hfTituloPag.Value;
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
                hfOperacao.Value = string.Empty;
                (gridContas.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
            }
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
            treeView.DataBind();
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void dropProduto_SelectedIndexChanged(object sender, EventArgs e)
        {
            //hfPRPRODID.Value = dropProduto.SelectedItem.Value;
            //txtDescri.Text = dropProduto.SelectedItem.Text;
        }
        protected void gridContaDebit_2_BatchUpdate(object sender, ASPxDataBatchUpdateEventArgs e)
        {
            foreach (var itens in e.UpdateValues)
            {
                string MOIDMODA = itens.NewValues["MOIDMODA"].ToString();
                string PFIDDEBI = itens.NewValues["PFIDDEBI"].ToString();
                string sqlUpd = "update VIPRESCT set PFIDDEBI=" + PFIDDEBI + " where PRPRODID = " + hfPRPRODID.Value + " and moidmoda =" + MOIDMODA + "";
                Consultas.UpdateFrom(str_conn, sqlUpd);
            }
            //gridContaDebit_2.DataBind();
        }
        protected void gridContaCred_2_BatchUpdate(object sender, ASPxDataBatchUpdateEventArgs e)
        {
            foreach (var itens in e.UpdateValues)
            {
                string MOIDMODA = itens.NewValues["MOIDMODA"].ToString();
                string PFIDCRED = itens.NewValues["PFIDCRED"].ToString();
                string sqlUpd = "update VIPRESCT set PFIDCRED=" + PFIDCRED + " where PRPRODID = " + hfPRPRODID.Value + " and moidmoda =" + MOIDMODA + "";
                Consultas.UpdateFrom(str_conn, sqlUpd);
            }
            //gridContaCred_2.DataBind();
        }
        protected void dropProduto_SelectedIndexChanged1(object sender, EventArgs e)
        {
            CarregaGrid(dropProduto.Value.ToString(),dropProduto.Text.ToString());
        }
        protected void CarregaGrid(string prodid, string prodds)
        {
            hfPRPRODID.Value = prodid;
            txtDescri.Text = prodds;
            btnInserir.Enabled = perfil != "3";
            btnexcluir.Enabled = perfil != "3";
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
            gridContas.SettingsDataSecurity.AllowDelete = perfil != "3";
            gridContas.SettingsDataSecurity.AllowEdit = perfil != "3";
            gridContas.SettingsDataSecurity.AllowInsert = perfil != "3";
            (gridContas.Columns["CommandColumn"] as GridViewColumn).Visible = false;
            gridContas.DataBind();
        }
        protected void btnexcluir_Click(object sender, EventArgs e)
        {
            hfOperacao.Value = "excluir";
            (gridContas.Columns["CommandColumn"] as GridViewColumn).Visible = true;
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
                    if (dropProduto.SelectedIndex != 0)
                        CarregaGrid(dropProduto.Value.ToString(), dropProduto.Text.ToString());
                    break;
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
                    var ID = gridContas.GetSelectedFieldValues("ID;PRPRODID;TVIDESTR");
                    for(int i = 0; i < ID.Count; i++)
                    {
                        string moidmoda = ID[i].ToString().Split('|')[0];
                        string prprodid = ID[i].ToString().Split('|')[1];
                        string tvidestr = ID[i].ToString().Split('|')[2];
                        string exec = DataBase.Consultas.DeleteFrom(str_conn, "delete VIPRESCT where PRPRODID="+prprodid+" and MOIDMODA="+moidmoda+" and TVIDESTR="+tvidestr+"");
                        if (exec == "OK")
                        {
                            validOK = validOK + 1;
                            textOK += prprodid+"#"+ moidmoda + ",";

                        }
                        else
                        {
                            validERRO = validERRO + 1;
                            textErro += prprodid + "#" + moidmoda + ",";
                        }
                    }
                    if (textOK.Length != 0)
                        textOK = textOK.Substring(0, textOK.Length - 1);
                    if (textErro.Length != 0)
                        textErro = textErro.Substring(0, textErro.Length - 1);
                    string erro = validERRO == 0 ? "" : HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_exception").ToString() + "<br />#ID:" + textErro;
                    string ok = validOK == 0 ? "" : HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString() + "<br />#ID:" + textOK;
                    MsgException(ok + "<br />" + erro, 2);
                    if (dropProduto.SelectedIndex!=0)
                    CarregaGrid(dropProduto.Value.ToString(), dropProduto.Text.ToString());
                    break;
            }
        }
        public List<Dictionary<string, object>> GetClientValues()
        {
            List<Dictionary<string, object>> l = new List<Dictionary<string, object>>();
            var objectArray = ((object[])hf.Get("modifiedValues"));
            for (int i = 0; i < objectArray.Length; i++)
            {
                l.Add(objectArray[i] as Dictionary<String, object>);
            }
            return l;
        }
        protected void gridContas_RowValidating(object sender, ASPxDataValidationEventArgs e)
        {
            if (e.IsNewRow)
            {
                string msg = HttpContext.GetGlobalResourceObject("GlobalResource", "lbl_grid_batch_duplicated").ToString();
                string ID = e.NewValues["ID"].ToString();
                string TVIDESTR = hfDropEstr.Value;
                string PRPRODID = dropProduto.Value.ToString();
                bool existe = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select COUNT(*) from VIPRESCT V WHERE V.TVIDESTR="+TVIDESTR+" AND V.PRPRODID="+PRPRODID+" AND MOIDMODA="+ID+"", 1)[0]) > 0;
                if(existe)
                {
                    e.RowError = msg;
                }
            }
            else
            {
                string msg = HttpContext.GetGlobalResourceObject("GlobalResource", "lbl_grid_batch_duplicated").ToString();
                if (e.NewValues["ID"].ToString() != e.OldValues["ID"].ToString())
                {
                    string ID = e.NewValues["ID"].ToString();
                    string TVIDESTR = hfDropEstr.Value;
                    string PRPRODID = dropProduto.Value.ToString();
                    bool existe = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select COUNT(*) from VIPRESCT V WHERE V.TVIDESTR=" + TVIDESTR + " AND V.PRPRODID=" + PRPRODID + " AND MOIDMODA=" + ID + "", 1)[0]) > 0;
                    if (existe)
                    {
                        e.RowError = msg;
                    }
                }
            }
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void gridContas_CustomDataCallback(object sender, ASPxGridViewCustomDataCallbackEventArgs e)
        {
            if (e.Parameters.ToString().Split('#')[0] == "CDCRED")
            {
                e.Result = "DSCRED#" + e.Parameters.ToString().Split('#')[1];
            }
            else if (e.Parameters.ToString().Split('#')[0] == "DSCRED")
            {
                e.Result = "CDCRED#" + e.Parameters.ToString().Split('#')[1];
            }
            else if (e.Parameters.ToString().Split('#')[0] == "CDDEBI")
            {
                e.Result = "DSDEBI#" + e.Parameters.ToString().Split('#')[1];
            }
            else if (e.Parameters.ToString().Split('#')[0] == "DSDEBI")
            {
                e.Result = "CDDEBI#" + e.Parameters.ToString().Split('#')[1];
            }
        }
        protected void gridContas_BatchUpdate(object sender, ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach(var item in e.InsertValues)
            {
                string sqlInsert = "INSERT INTO VIPRESCT (TVIDESTR,PRPRODID,MOIDMODA,PFIDCRED,PFIDDEBI) VALUES ("+ hfDropEstr.Value + ","+ hfPRPRODID.Value + ",@MOIDMODA,@PFIDCRED,@PFIDDEBI)";
                sqlInsert = sqlInsert.Replace("@MOIDMODA", item.NewValues["ID"].ToString());
                sqlInsert = sqlInsert.Replace("@PFIDCRED", item.NewValues["CDCRED"].ToString());
                sqlInsert = sqlInsert.Replace("@PFIDDEBI", item.NewValues["CDDEBI"].ToString());
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            }
            foreach(var item in e.UpdateValues)
            {
                string TVIDESTR = hfDropEstr.Value;
                string PRPRODID = hfPRPRODID.Value;
                string MOIDMODA = item.NewValues["ID"].ToString() == string.Empty ? item.OldValues["ID"].ToString() : item.NewValues["ID"].ToString();
                string PFIDCRED = item.NewValues["CDCRED"].ToString() == string.Empty ? item.OldValues["CDCRED"].ToString() : item.NewValues["CDCRED"].ToString();
                string PFIDDEBI = item.NewValues["CDDEBI"].ToString() == string.Empty ? item.OldValues["CDDEBI"].ToString() : item.NewValues["CDDEBI"].ToString();
                string sqlUpdate = "UPDATE VIPRESCT SET PFIDDEBI=@PFIDDEBI,PFIDCRED=@PFIDCRED WHERE TVIDESTR=@TVIDESTR and PRPRODID =@PRPRODID and MOIDMODA=@MOIDMODA";
                sqlUpdate = sqlUpdate.Replace("@TVIDESTR", TVIDESTR);
                sqlUpdate = sqlUpdate.Replace("@PRPRODID", PRPRODID);
                sqlUpdate = sqlUpdate.Replace("@MOIDMODA", MOIDMODA);
                sqlUpdate = sqlUpdate.Replace("@PFIDDEBI", PFIDDEBI);
                sqlUpdate = sqlUpdate.Replace("@PFIDCRED", PFIDCRED);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            }
        }
    }
}