using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Tipologia : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static bool AcessoInternet;
        protected void Page_Init(object sender, EventArgs e)
        {
            AcessoInternet = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["AcessoInternet"]);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }

            }
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = (DevExpress.Web.ASPxTreeList.ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList") as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            treeList.DataBind();
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
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "2";
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 3)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = sender as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (DevExpress.Web.ASPxTreeList.TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void duploClickGrid(object sender, CommandEventArgs e)
        {
            string prprodid = string.Empty;
            string tvidestr = string.Empty;
            string sqlInsert = string.Empty;
            string exec = string.Empty;
            switch(e.CommandArgument)
            {
                case "1": //associadas                    
                    prprodid = gridAssociadas.GetRowValues(gridAssociadas.FocusedRowIndex, "prprodid").ToString();
                    tvidestr = gridAssociadas.GetRowValues(gridAssociadas.FocusedRowIndex, "tvidestr").ToString();
                    string valida = DataBase.Consultas.Consulta(str_conn, "select count(prprodid) from opcontra where PRPRODID="+prprodid+" and TVIDESTR="+tvidestr+"", 1)[0];
                    if (valida == "0")
                    {
                        sqlInsert = "DELETE TPESTRPR WHERE TVIDESTR=" + tvidestr + " AND PRPRODID=" + prprodid + "";
                        exec = DataBase.Consultas.DeleteFrom(str_conn, sqlInsert);
                    }
                    else
                    {
                        MsgException(GetGlobalResourceObject("GlobalResource", "MsgExc_delete_item_using").ToString(),1,"");
                    }
                    break;
                case "2": //disponiveis
                    prprodid = gridDisponiveis.GetRowValues(gridDisponiveis.FocusedRowIndex, "prprodid").ToString();
                    tvidestr = hfDropEstr.Value;
                    sqlInsert = "INSERT INTO TPESTRPR (TVIDESTR ,PRPRODID) VALUES ("+tvidestr+","+prprodid+")";
                    exec = DataBase.Consultas.InsertInto(str_conn,sqlInsert);
                    break;
            }
            sqlDisponiveis.DataBind();
            gridDisponiveis.DataBind();
            sqlAssociados.DataBind();
            gridAssociadas.DataBind();
        }
        protected void btnSelEmp_Click(object sender, EventArgs e)
        {

        }
        protected void gridAssociadas_DataBound(object sender, EventArgs e)
        {
            gridAssociadas.FocusedRowIndex = -1;
        }
        protected void gridDisponiveis_DataBound(object sender, EventArgs e)
        {
            //Response.Write(gridDisponiveis.FilterExpression.ToString());
            gridDisponiveis.FocusedRowIndex = -1;
            if(gridDisponiveis.VisibleRowCount>0 && gridDisponiveis.FilterExpression.Length>0)
            {

                gridDisponiveis.Templates.EmptyDataRow = new MyTemplate { filter = gridDisponiveis.FilterExpression,sender=sender };
            }
            
        }

        protected void gridDisponiveis_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            switch(e.DataColumn.FieldName)
            {
                case "prprodes":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('tipologia');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;                
                case "origem":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('origem');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "capital":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('capital');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "usgaap":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('usgaap');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "impostos":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('impostos');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "reajustes":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('reajustes');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "carencia":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('carencia');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "fluxo":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('fluxo');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "calculo":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('calculo');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "depreciacao":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('depreciacao');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
                case "remensuracao":
                    e.Cell.Attributes.Add("onmouseover", "QuickGuide('remensuracao');");
                    e.Cell.Attributes.Add("onmouseout", "QuickGuide('ini');");
                    break;
            }
        }

        protected void gridAssociadas_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }

        protected void gridDisponiveis_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }
    }
}
class MyTemplate : ITemplate
{
    public string filter { get; set; }
    public object sender { get; set; }
    public void InstantiateIn(Control container)
    {
        ASPxGridView grid = (ASPxGridView)sender;
        int start = -1;
        List<string> fields = new List<string>();
        for (int i = 0; i < grid.FilterExpression.Length; i++)
        {
            if (grid.FilterExpression[i] == '[')
                start = i;
            if (grid.FilterExpression[i] == ']')
            {
                fields.Add(grid.FilterExpression.Substring(start + 1, i - start - 1 +5).Replace("]", ""));
                start = -1;
            }                
        }
        Label lbl = new Label();
        lbl.ID = "lblGrid001";
        for(int i=0;i<fields.Count;i++)
        {
            if (fields[i] == "origem = 1") fields[i] = "Origem Nacional";
            if (fields[i] == "origem = 0") fields[i] = "Origem Mundial";
            if (fields[i] == "capital = 1") fields[i] = "Capital Aberto";
            if (fields[i] == "capital = 0") fields[i] = "Capital Fechado";
            if (fields[i] == "usgaap = 1") fields[i] = "USGAAP? Sim";
            if (fields[i] == "usgaap = 0") fields[i] = "USGAAP? Não";
            if (fields[i] == "impostos = 1") fields[i] = "Impostos? Sim";
            if (fields[i] == "impostos = 0") fields[i] = "Impostos? Não";
            if (fields[i] == "reajustes = 1") fields[i] = "Reajustes? Sim";
            if (fields[i] == "reajustes = 0") fields[i] = "Reajustes? Não";
            if (fields[i] == "carencia = 1") fields[i] = "Carência? Sim";
            if (fields[i] == "carencia = 0") fields[i] = "Carência? Não";
            if (fields[i] == "fluxo = 1") fields[i] = "Fluxo de Pagamentos Uniforme";
            if (fields[i] == "fluxo = 0") fields[i] = "Fluxo de Pagamentos não Uniforme";
            if (fields[i] == "calculo = 1") fields[i] = "Cálculo Tabela Price";
            if (fields[i] == "calculo = 0") fields[i] = "Cálculo Linear";
            if (fields[i] == "depreciacao = 1") fields[i] = "Depreciação Linear";
            if (fields[i] == "depreciacao = 0") fields[i] = "Depreciação Diferenciada";
            if (fields[i] == "remensuracao = 1") fields[i] = "Remensuração? Sim";
            if (fields[i] == "remensuracao = 0") fields[i] = "Remensuração? Não";
        }
        lbl.Text = "Tipologia com as características pesquisadas não existe: <strong>";
        foreach (var item in fields)
        {
            lbl.Text += item + ", ";
        }
        lbl.Text = lbl.Text.Trim().Substring(0, lbl.Text.Trim().Length - 1);
        lbl.Text += ".</strong> <br />Necessário abrir chamado para criar Tipologia. <br />";
        container.Controls.Add(lbl);
        Button btn = new Button();
        btn.ID = "btnGrid001";
        btn.Text = "Abrir Chamado";
        btn.CssClass = "btn-using";
        container.Controls.Add(btn);
    }
}