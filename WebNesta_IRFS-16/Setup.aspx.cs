using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using DevExpress.DataAccess.ConnectionParameters;
using DevExpress.DataAccess.Native.Sql;
using DevExpress.DataAccess.Sql;
using DevExpress.DataAccess.Web;
using DevExpress.Xpo.DB;
using DevExpress.Web;
using DevExpress.XtraReports.Web;
using System.Data;
using CrystalDecisions.CrystalReports.Engine;
using DevExpress.Web.ASPxTreeList;
using System.IO;
using System.Xml;
using System.Resources;
using System.Configuration;
using System.Web.Configuration;
using System.Globalization;

namespace WebNesta_IRFS_16
{
    public partial class Setup1 : BasePage.BasePage
    {
        private XmlNode node = null;
        DataSet dset = new DataSet();
        private string FileName
        {
            get
            {
                return this.CurrentRes;
            }
        }

        public string CurrentRes { get; private set; }

        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string flagTermo;
        public static string lang;
        public static string perfil;
        public static DataConnectionParametersBase connQueryBuilder;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                PanelView.ActiveViewIndex = 0;
                HttpCookie cookiePais = HttpContext.Current.Request.Cookies["PAIDPAIS"];
                if (cookiePais == null)
                    hfPaisUser.Value = "1";
                else
                {
                    if (cookiePais.Value != "1" || cookiePais.Value != "2" || cookiePais.Value != "3")
                        hfPaisUser.Value = "2";
                    else
                        hfPaisUser.Value = cookiePais.Value;
                }
            }
            try
            {
                lang = Session["langSession"].ToString();
            }
            catch
            {
                lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
            }
            connQueryBuilder = new MsSqlConnectionParameters(
    System.Configuration.ConfigurationManager.AppSettings["hostDB"],
    System.Configuration.ConfigurationManager.AppSettings["nameDB"],
    System.Configuration.ConfigurationManager.AppSettings["userDB"],
    System.Configuration.ConfigurationManager.AppSettings["passDB"],
    MsSqlAuthorizationType.SqlServer);

            string sql = "SELECT QUEIDPVT,QUENMPVT,QUEBBPVT,QUETPPVT FROM QUERYPVT WHERE USIDUSUA = '" + hfUser.Value + "'";
            gridQueries.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
            gridQueries.DataBind();
            gridUsuarios.DataBind();
            if (Session["sqlUsuariosLogados"] != null)
            {
                sqlUsuariosLogados.SelectCommand = Session["sqlUsuariosLogados"].ToString();

                sqlUsuariosLogados.DataBind();
                gridUsuariosLogados.DataBind();
            }
            if (Request.QueryString.Count > 0)
            {
                if (Request.QueryString["queryBuilder"] == "1")
                {
                    (gridQueries.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    gridQueries.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT QUEIDPVT,QUENMPVT,QUEBBPVT,QUETPPVT FROM QUERYPVT WHERE USIDUSUA = '" + hfUser.Value + "'");
                    gridQueries.DataBind();
                    if (gridQueries.Columns.Count > 0)
                        btn_excluir.Enabled = true;
                    PanelView.ActiveViewIndex = 1;
                }
            }
            //Perfil Query Builder
            HttpCookie myCookie2 = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_relatorios")];
            if (myCookie2 == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie2.Value);
            hfPerfilQuery.Value = perfil;
            ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
            treeView.DataBind();
            gropGrupo.DataBind();
            dropPais.DataBind();
            gridUsuariosLogados.DataBind();
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        public class MyDataSourceWizardDBSchemaProviderFactory : IDataSourceWizardDBSchemaProviderExFactory
        {
            public string userPersist { get; set; }
            IDBSchemaProviderEx IDataSourceWizardDBSchemaProviderExFactory.Create()
            {
                MyDBSchemaProvider myDB = new MyDBSchemaProvider();
                myDB.userPersist = userPersist;
                return myDB;
            }
        }
        public class MyDBSchemaProvider : IDBSchemaProviderEx
        {
            public string userPersist { get; set; }
            public DBStoredProcedure[] GetProcedures(SqlDataConnection connection, params string[] procedureList)
            {
                DBSchema defaultSchema = connection.GetDBSchema(false, SchemaLoadingMode.StoredProcedures);
                DBStoredProcedure[] storedProcedures = defaultSchema.StoredProcedures.Where((storedProcedure) => { return storedProcedure.Arguments.Count == 1; }).ToArray();
                return storedProcedures;
            }
            public DBTable[] GetTables(SqlDataConnection connection, params string[] tableList)
            {
                DBSchema defaultSchema = connection.GetDBSchema(false);
                string user = userPersist;
                if (user == "MASTER")
                {
                    DBTable[] tables = defaultSchema.Tables.ToArray();
                    return tables;
                }
                else
                {
                    DBTable[] tables = defaultSchema.Tables.Where(c=>c.Name.StartsWith("nesta_dw_") || c.Name.StartsWith("nesta_dm_")).ToArray();
                    return tables;
                }

            }
            public DBTable[] GetViews(SqlDataConnection connection, params string[] viewList)
            {
                DBSchema defaultSchema = connection.GetDBSchema(false);
                //DBTable[] views = defaultSchema.Views.Where((view) => { return view.Name.StartsWith("nesta_dw_"); }).ToArray();
                DBTable[] views = defaultSchema.Views.Where(c => c.Name.StartsWith("nesta_dw_") || c.Name.StartsWith("nesta_dm_")).ToArray();
                return views;
            }
            public void LoadColumns(SqlDataConnection connection, params DBTable[] tables)
            {
                connection.LoadDBColumns(tables);
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="msg">Texto para MensageBox</param>
        /// <param name="exc">0 = Mensagem de alerta e refresh na página 1 = Mensagem de Erro em Vermelho 2 = mensagem de alerta sem refresh na página</param>
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
        protected void ASPxMenu1_ItemClick(object source, DevExpress.Web.MenuItemEventArgs e)
        {
            switch (e.Item.Name)
            {
                case "1":
                    string sql = "SELECT QUEIDPVT,QUENMPVT,QUEBBPVT,QUETPPVT FROM QUERYPVT WHERE USIDUSUA = '" + hfUser.Value + "'";
                    (gridQueries.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    gridQueries.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
                    gridQueries.DataBind();
                    if (gridQueries.Columns.Count > 0)
                        btn_excluir.Enabled = true;
                    PanelView.ActiveViewIndex = 1;
                    break;
                case "2":
                    PanelView.ActiveViewIndex = 2;
                    break;
                case "3":
                    PanelView.ActiveViewIndex = 3;
                    break;
                case "4":
                    PanelView.ActiveViewIndex = 4;
                    break;
                case "5":
                    PanelView.ActiveViewIndex = 5;
                    break;
                case "6":
                    PanelView.ActiveViewIndex = 6;
                    break;
                case "7":
                    Configuration conf = WebConfigurationManager.OpenWebConfiguration(System.Web.Hosting.HostingEnvironment.ApplicationVirtualPath);
                    SessionStateSection section = (SessionStateSection)conf.GetSection("system.web/sessionState");
                    int timeout = (int)section.Timeout.TotalMinutes;
                    string sql2 = "SELECT USNMPRUS,USNMSNUS,USIDUSUA,convert(datetime,USLASTUPD) as data,USLASTACT, " +
                        " case when DATEADD(MINUTE," + timeout + ", USLASTUPD) > convert(datetime,'" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "',103) then 0 else -1 end as Situacao " +
                        " FROM TUSUSUARI " +
                                    "where USLASTUPD IS NOT NULL ";
                    Session["sqlUsuariosLogados"] = sql2;
                    sqlUsuariosLogados.SelectCommand = sql2;
                    sqlUsuariosLogados.DataBind();
                    gridUsuariosLogados.DataBind();
                    PanelView.ActiveViewIndex = 7;
                    break;
                case "8":
                    PanelView.SetActiveView(this.vw_Componente);
                    break;
                case "9":
                    PanelView.SetActiveView(this.vw_Produto);
                    break;
                case "10":
                    PanelView.SetActiveView(this.vw_Propriedades);
                    break;
                case "11":
                    PanelView.SetActiveView(this.vw_Modalidade);
                    break;
                case "12":
                    PanelView.SetActiveView(this.vw_Eventos);
                    break;
                case "13":
                    PanelView.SetActiveView(this.vw_Mercado);
                    break;
            }
        }
        protected void queryBuilder_SaveQuery(object sender, DevExpress.XtraReports.Web.SaveQueryEventArgs e)
        {
            if (Page.IsValid)
            {
                hfTipoQuery.Value = listTipoQuery.SelectedItem.Value.ToString();
                hfQuery.Value = e.SelectStatement.Replace("'", "''");
                var ids = DataBase.Consultas.Consulta(str_conn, "SELECT distinct TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = '" + hfUser.Value + "'");
                string TVIDESTR = string.Empty;
                foreach (DataRow row in ids.Rows)
                {
                    TVIDESTR += row[0] + ",";
                }
                if (!string.IsNullOrEmpty(e.ResultQuery.FilterString))
                {
                    if (e.ResultQuery.FilterString.IndexOf("[TVIDESTR]") < 0)
                    {
                        e.ResultQuery.FilterString += " AND [TVIDESTR] in (" + TVIDESTR.Substring(0, TVIDESTR.Length - 1) + ") ";
                    }
                }
                else
                {
                    e.ResultQuery.FilterString += " [TVIDESTR] in (" + TVIDESTR.Substring(0, TVIDESTR.Length - 1) + ") ";
                }
                e.ResultQuery.Name = DateTime.Now.ToString("ddMMyyyyHHmmssfff");
                DevExpress.DataAccess.Sql.SqlDataSource ds = new DevExpress.DataAccess.Sql.SqlDataSource(connQueryBuilder);
                ds.Queries.Add(e.ResultQuery);
                string serializedQuery = ds.SaveToXml().ToString();
                hfNameQuery.Value = txtNomeRelat.Text;
                string sqlInsert = "INSERT INTO QUERYPVT([USIDUSUA],[QUENMPVT],[QUEBBPVT],[QUETPPVT],[QUEXMPVT],[QUETITU1],[QUETITU2]) VALUES('" + hfUser.Value + "','" + hfNameQuery.Value + "','" + hfQuery.Value + "'," + hfTipoQuery.Value + ",'" + serializedQuery + "','"+txtTituloRelat.Text+"','"+ txtTituloRelat2.Text + "')";
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                ASPxWebControl.RedirectOnCallback("Setup?queryBuilder=1");
            }
        }
        protected void Button1_Command(object sender, CommandEventArgs e)
        {
            switch (e.CommandArgument.ToString())
            {
                case "inserir":
                    hfOper.Value = e.CommandArgument.ToString();
                    btn_cancelar.Enabled = true;
                    queryBuilder.OpenConnection(connQueryBuilder);
                    mvQueryBuilder.SetActiveView(this.viewQueryBuilderInsert);
                    popupControle.ShowOnPageLoad = true;
                    break;
                case "excluir":
                    string sql = "SELECT QUEIDPVT,QUENMPVT,QUEBBPVT,QUETPPVT FROM QUERYPVT WHERE USIDUSUA = '" + hfUser.Value + "'";
                    (gridQueries.Columns["CommandColumn"] as GridViewColumn).Visible = true;
                    gridQueries.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
                    gridQueries.DataBind();
                    hfOper.Value = e.CommandArgument.ToString();
                    btn_ok.Enabled = true;
                    btn_cancelar.Enabled = true;
                    break;
                case "ok":
                    if (hfOper.Value == "excluir")
                    {
                        var ID = gridQueries.GetSelectedFieldValues("QUEIDPVT");
                        for (int i = 0; i < ID.Count; i++)
                        {
                            string exec = DataBase.Consultas.DeleteFrom(str_conn, "DELETE FROM QUERYPVT WHERE QUEIDPVT=" + ID[i].ToString());
                        }
                        gridQueries.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT QUEIDPVT, QUENMPVT, QUEBBPVT, QUETPPVT FROM QUERYPVT WHERE USIDUSUA = '" + hfUser.Value + "'");
                        gridQueries.DataBind();
                        (gridQueries.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    }
                    else if (hfOper.Value == "inserir")
                    {

                    }
                    break;
                case "cancelar":
                    if (hfOper.Value == "excluir")
                    {
                        gridQueries.DataBind();
                        (gridQueries.Columns["CommandColumn"] as GridViewColumn).Visible = false;
                    }
                    else if (hfOper.Value == "inserir")
                    {

                    }
                    break;
            }
        }
        protected void gridQueries_DataBound(object sender, EventArgs e)
        {
            string a = string.Empty;
            if (hfPerfilQuery.Value == "0")
            {
                btn_inserir.Enabled = true;
            }
            else if (hfPerfilQuery.Value != string.Empty)
            {
                int qtdQuery = Convert.ToInt32(hfPerfilQuery.Value);
                if (gridQueries.VisibleRowCount >= qtdQuery)
                {
                    btn_inserir.Enabled = false;
                }
                else if (gridQueries.VisibleRowCount < qtdQuery)
                {
                    btn_inserir.Enabled = true;
                }
            }
        }
        protected void gridQueries_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            if (e.ButtonID != "detail") return;
            var teste = gridQueries.GetRowValues(Convert.ToInt32(e.VisibleIndex), "QUEIDPVT");
            hfIDQuery.Value = teste.ToString();
            var query = DataBase.Consultas.Consulta(str_conn, "SELECT QUEXMPVT,QUENMPVT,QUETPPVT,QUETITU1,QUETITU2 FROM QUERYPVT WHERE QUEIDPVT=" + hfIDQuery.Value + "", 5);
            DevExpress.DataAccess.Sql.SqlDataSource ds = new DevExpress.DataAccess.Sql.SqlDataSource(connQueryBuilder);
            ds.LoadFromXml(XElement.Parse(query[0]));
            txtNomeRelat2.Text = query[1];
            SelectQuery select = ds.Queries[0] as SelectQuery;
            //txtNameQuery2.Text = query[1];
            listTipoQuery2.Value = Convert.ToInt32(query[2]);
            txtTituloRelatorio1.Text = query[3];
            txtTituloRelatorio2.Text = query[4];
            queryBuilder2.OpenConnection(connQueryBuilder, select);
            mvQueryBuilder.SetActiveView(this.viewQueryBuilderAlterar);
            popupControle.ShowOnPageLoad = true;
        }
        protected void queryBuilder2_SaveQuery(object sender, DevExpress.XtraReports.Web.SaveQueryEventArgs e)
        {
            hfTipoQuery.Value = listTipoQuery2.SelectedItem.Value.ToString();
            hfQuery.Value = e.SelectStatement.Replace("'", "''");
            var ids = DataBase.Consultas.Consulta(str_conn, "SELECT distinct TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = '" + hfUser.Value + "'");
            string TVIDESTR = string.Empty;
            foreach (DataRow row in ids.Rows)
            {
                TVIDESTR += row[0] + ",";
            }
            if (!string.IsNullOrEmpty(e.ResultQuery.FilterString))
            {
                if (e.ResultQuery.FilterString.IndexOf("[TVIDESTR]") < 0)
                {
                    e.ResultQuery.FilterString += " AND [TVIDESTR] in (" + TVIDESTR.Substring(0, TVIDESTR.Length - 1) + ")";
                }
            }
            else
            {
                e.ResultQuery.FilterString += " [TVIDESTR] in (" + TVIDESTR.Substring(0, TVIDESTR.Length - 1) + ")";
            }
            DevExpress.DataAccess.Sql.SqlDataSource ds = new DevExpress.DataAccess.Sql.SqlDataSource(connQueryBuilder);
            ds.Queries.Add(e.ResultQuery);
            string serializedQuery = ds.SaveToXml().ToString();
            hfNameQuery.Value = txtNomeRelat2.Text; //e.ResultQuery.Name; //
            string sqlupdate = "update QUERYPVT set QUEBBPVT='" + hfQuery.Value + "', QUEXMPVT='" + serializedQuery + "', QUENMPVT='" + hfNameQuery.Value + "',QUETPPVT=" + hfTipoQuery.Value + ",QUETITU1='"+txtTituloRelatorio1.Text+"',QUETITU2='"+txtTituloRelatorio2.Text+"' where QUEIDPVT=" + hfIDQuery.Value + "";
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlupdate);
            ASPxWebControl.RedirectOnCallback("Setup?queryBuilder=1");
        }
        protected void gridQueries_Load(object sender, EventArgs e)
        {
            string a = string.Empty;
            if (hfPerfilQuery.Value == "0")
            {
                btn_inserir.Enabled = true;
            }
            else if (hfPerfilQuery.Value != string.Empty)
            {
                int qtdQuery = Convert.ToInt32(hfPerfilQuery.Value);
                if (gridQueries.VisibleRowCount >= qtdQuery)
                {
                    btn_inserir.Enabled = false;
                }
                else if (gridQueries.VisibleRowCount < qtdQuery)
                {
                    btn_inserir.Enabled = true;
                }
            }

        }
        protected void gridLog_DetailRowGetButtonVisibility(object sender, ASPxGridViewDetailRowButtonEventArgs e)
        {
            if (Convert.ToInt32(flagTermo) != 1)
                e.ButtonState = GridViewDetailRowButtonState.Hidden;
        }
        protected void gridLog_Load(object sender, EventArgs e)
        {
            //Termos e Condições
            HttpCookie myCookie1 = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("termo_aceite")];
            if (myCookie1 == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            flagTermo = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie1.Value);
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void btnSelectLoja_Click(object sender, EventArgs e)
        {
            btnInserir.Enabled = false;
            btnAlterar.Enabled = true;
            btnExcluir.Enabled = true;
            btnOK.Enabled = false;
            btnCancelar.Enabled = true;
            radioModelo.Enabled = false;
            txtRazao.Enabled = false;
            txtApelido.Enabled = false;
            txtCNPJ.Enabled = false;
            dropPais.Enabled = false;
            string sql = "select case when tv.TVNVESTR=0 then 0 else 1 end as MODELO, " +
                        "case when tv.TVCDPAIE=0 then NULL else TV.TVCDPAIE end as GRUPO, " +
                        "FO.FONMFORN AS RAZAO, " +
                        "FO.FONMAB20 AS APELIDO, " +
                        "FO.FOCDXCGC AS CNPJ, " +
                        "FO.PAIDPAIS AS PAIS " +
                    "from TVESTRUT TV, FOFORNEC FO " +
                    "WHERE TV.TVIDESTR = FO.TVIDESTR " +
                        "AND FOTPIDTP = 6 " +
                        "AND TV.TVIDESTR = " + hfDropEstr.Value + "";
            var result = DataBase.Consultas.Consulta(str_conn, sql, 6);
            if (result.Length < 6) return;
            radioModelo.Value = result[0];
            gropGrupo.Value = result[1];
            gropGrupo.ClientEnabled = false;
            txtRazao.Text = result[2];
            txtApelido.Text = result[3];
            txtCNPJ.Text = result[4];
            dropPais.Value = result[5];

            mv_Loja.SetActiveView(this.vw_loja_Consultar);
        }
        protected void AcoesOperacores_Loja(object sender, CommandEventArgs e)
        {
            gropGrupo.Enabled = true;
            switch (e.CommandArgument.ToString())
            {
                case "Inserir":
                    hfOper_Loja.Value = e.CommandArgument.ToString();
                    lblMensagemLoja.Text = "Modo Inclusão.";
                    btnOK.ValidationGroup = "Loja";
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    btnCancelar.Enabled = true;
                    radioModelo.Enabled = true;
                    txtRazao.Enabled = true;
                    txtApelido.Enabled = true;
                    txtCNPJ.Enabled = true;
                    dropPais.Enabled = true;
                    gridAssociadas.Enabled = true;
                    gridDisponiveis.Enabled = true;
                    mv_Loja.SetActiveView(this.vw_loja_Consultar);
                    break;
                case "Alterar":
                    hfOper_Loja.Value = e.CommandArgument.ToString();
                    lblMensagemLoja.Text = "Modo Alteração.";
                    btnOK.ValidationGroup = "Loja";
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    radioModelo.Enabled = true;
                    txtRazao.Enabled = true;
                    txtApelido.Enabled = true;
                    txtCNPJ.Enabled = true;
                    dropPais.Enabled = true;
                    gridAssociadas.Enabled = true;
                    gridDisponiveis.Enabled = true;
                    mv_Loja.SetActiveView(this.vw_loja_Consultar);
                    break;
                case "Excluir":
                    hfOper_Loja.Value = e.CommandArgument.ToString();
                    lblMensagemLoja.Text = "Modo Exclusão. Confirme a operação clicando em OK.";
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    radioModelo.Enabled = false;
                    gropGrupo.Enabled = false;
                    txtRazao.Enabled = false;
                    txtApelido.Enabled = false;
                    txtCNPJ.Enabled = false;
                    dropPais.Enabled = false;
                    mv_Loja.SetActiveView(this.vw_loja_Consultar);
                    break;
                case "Associar":
                    hfOper_Loja.Value = e.CommandArgument.ToString();
                    mv_Loja.SetActiveView(this.vw_loja_Associar);
                    break;
            }
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Tela += " Cadastro Loja";
            string TVIDESTR, TVDSESTR, TVCDPAIE, TVIDPAIS, FOCDXCGC, FONMFORN, FONMAB20, PAIDPAIS, USIDUSUA, TVNVESTR;
            switch (hfOper_Loja.Value)
            {
                #region Inserir
                case "Inserir":
                    string sqlInTVESTRUT = "INSERT INTO TVESTRUT " +
               "(TVIDESTR " +
               ", TVDSESTR " +
               ", TVCDPAIE " +
               ", TVNVESTR " +
               ", TVPORTAE " +
               ", TVIPESTR " +
               ", TVLUQTCR " +
               ", TVLMPASS " +
               ", IEIDINEC " +
               ", TVIDPAIS) " +
         "VALUES " +
               "(@TVIDESTR " +
               ", '@TVDSESTR' " +
               ", @TVCDPAIE " +
               ", @TVNVESTR " +
               ", null " +
               ", null " +
               ", 'C' " +
               ", null " +
               ", null " +
               ", @TVIDPAIS)";
                    string sqlInFOFORNEC = "INSERT INTO FOFORNEC " +
                                           "(LCIDLOCA " +
                                           ", FOCDXCGC " +
                                           ", FOIDFORN " +
                                           ", FONMFORN " +
                                           ", FONMAB20 " +
                                           ", FOBLOQFO " +
                                           ", TVIDESTR " +
                                           ", IEIDINEC " +
                                           ", FOCTIDCT " +
                                           ", FOTPIDTP " +
                                           ", PAIDPAIS " +
                                           ", FOCDLICE) " +
                                     "VALUES " +
                                           "(269 " +
                                           ",'@FOCDXCGC' " +
                                           "," + DataBase.Consultas.CarregaCodInterno("17", 1, str_conn) + " " +
                                           ",'@FONMFORN' " +
                                           ",'@FONMAB20' " +
                                           ", 'F' " +
                                           ",@TVIDESTR " +
                                           ", null " +
                                           ", 1 " +
                                           ", 6 " +
                                           ",@PAIDPAIS " +
                                           ",'?')";
                    string sqlInVIFSFUSU = "INSERT INTO VIFSFUSU " +
                       "(FSIDFUSI " +
                       ", USIDUSUA " +
                       ", TVIDESTR) " +
                 "VALUES " +
                       "(0 " +
                       ",'@USIDUSUA' " +
                       ",@TVIDESTR)";
                    TVIDESTR = DataBase.Consultas.Consulta(str_conn, "SELECT MAX(TVIDESTR)+1 FROM TVESTRUT", 1)[0];
                    TVDSESTR = txtApelido.Text;
                    FONMAB20 = txtApelido.Text;
                    FONMFORN = txtRazao.Text;
                    FOCDXCGC = txtCNPJ.Text;
                    TVCDPAIE = radioModelo.SelectedItem.Value.ToString() == "0" ? "0" : gropGrupo.Value.ToString();
                    TVNVESTR = radioModelo.SelectedItem.Value.ToString() == "0" ? "0" : "1";
                    TVIDPAIS = dropPais.Value.ToString();
                    PAIDPAIS = dropPais.Value.ToString();
                    USIDUSUA = hfUser.Value;
                    sqlInTVESTRUT = sqlInTVESTRUT.Replace("@TVIDESTR", TVIDESTR);
                    sqlInTVESTRUT = sqlInTVESTRUT.Replace("@TVDSESTR", TVDSESTR);
                    sqlInTVESTRUT = sqlInTVESTRUT.Replace("@TVCDPAIE", TVCDPAIE);
                    sqlInTVESTRUT = sqlInTVESTRUT.Replace("@TVNVESTR", TVNVESTR);
                    sqlInTVESTRUT = sqlInTVESTRUT.Replace("@TVIDPAIS", TVIDPAIS);
                    sqlInFOFORNEC = sqlInFOFORNEC.Replace("@FOCDXCGC", FOCDXCGC);
                    sqlInFOFORNEC = sqlInFOFORNEC.Replace("@FONMFORN", FONMFORN);
                    sqlInFOFORNEC = sqlInFOFORNEC.Replace("@FONMAB20", FONMAB20);
                    sqlInFOFORNEC = sqlInFOFORNEC.Replace("@TVIDESTR", TVIDESTR);
                    sqlInFOFORNEC = sqlInFOFORNEC.Replace("@PAIDPAIS", PAIDPAIS);
                    sqlInVIFSFUSU = sqlInVIFSFUSU.Replace("@USIDUSUA", USIDUSUA);
                    sqlInVIFSFUSU = sqlInVIFSFUSU.Replace("@TVIDESTR", TVIDESTR);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInTVESTRUT);
                    if (exec == "OK")
                    {
                        exec = DataBase.Consultas.InsertInto(str_conn, sqlInFOFORNEC);
                        if (exec == "OK")
                        {
                            exec = DataBase.Consultas.InsertInto(str_conn, sqlInVIFSFUSU);
                            if (exec == "OK")
                            {
                                ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
                                treeView.DataBind();
                                btnOK.Enabled = false;
                                btnCancelar.Enabled = false;
                                radioModelo.Enabled = false;
                                txtRazao.Enabled = false;
                                txtApelido.Enabled = false;
                                txtCNPJ.Enabled = false;
                                dropPais.Enabled = false;
                                gropGrupo.Enabled = false;
                            }
                        }
                    }
                    break;
                #endregion
                #region Alterar
                case "Alterar":
                    string sqlUpdTVESTRUT = "UPDATE TVESTRUT SET TVDSESTR='@TVDSESTR',TVCDPAIE=@TVCDPAIE,TVNVESTR=@TVNVESTR WHERE TVIDESTR=" + hfDropEstr.Value;
                    string sqlUpdFOFORNEC = "UPDATE FOFORNEC SET FOCDXCGC='@FOCDXCGC',FONMFORN='@FONMFORN',FONMAB20='@FONMAB20' WHERE TVIDESTR=" + hfDropEstr.Value + " and FOTPIDTP=6";
                    TVDSESTR = txtApelido.Text;
                    FONMAB20 = txtApelido.Text;
                    FONMFORN = txtRazao.Text;
                    FOCDXCGC = txtCNPJ.Text;
                    TVCDPAIE = radioModelo.SelectedItem.Value.ToString() == "0" ? "0" : gropGrupo.Value.ToString();
                    TVNVESTR = radioModelo.SelectedItem.Value.ToString() == "0" ? "0" : "1";
                    sqlUpdTVESTRUT = sqlUpdTVESTRUT.Replace("@TVDSESTR", TVDSESTR);
                    sqlUpdTVESTRUT = sqlUpdTVESTRUT.Replace("@TVCDPAIE", TVCDPAIE);
                    sqlUpdTVESTRUT = sqlUpdTVESTRUT.Replace("@TVNVESTR", TVNVESTR);
                    sqlUpdFOFORNEC = sqlUpdFOFORNEC.Replace("@FOCDXCGC", FOCDXCGC);
                    sqlUpdFOFORNEC = sqlUpdFOFORNEC.Replace("@FONMFORN", FONMFORN);
                    sqlUpdFOFORNEC = sqlUpdFOFORNEC.Replace("@FONMAB20", FONMAB20);
                    string exec2 = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdTVESTRUT);
                    if (exec2 == "OK")
                    {
                        exec2 = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdFOFORNEC);
                        if (exec2 == "OK")
                        {
                            ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
                            treeView.DataBind();
                            btnOK.Enabled = false;
                            btnCancelar.Enabled = false;
                            radioModelo.Enabled = false;
                            txtRazao.Enabled = false;
                            txtApelido.Enabled = false;
                            txtCNPJ.Enabled = false;
                            dropPais.Enabled = false;
                            gropGrupo.Enabled = false;
                        }
                    }
                    break;
                #endregion
                #region Excluir
                case "Excluir":
                    string sqlDelTVESTRUT = "DELETE TVESTRUT where TVIDESTR=@ID or TVCDPAIE=@ID";
                    string sqlDelFOFORNEC = "DELETE FOFORNEC WHERE FOTPIDTP=6 AND TVIDESTR in (select TVIDESTR from TVESTRUT where TVIDESTR=@ID or TVCDPAIE=@ID)";
                    sqlDelTVESTRUT = sqlDelTVESTRUT.Replace("@ID", hfDropEstr.Value);
                    sqlDelFOFORNEC = sqlDelFOFORNEC.Replace("@ID", hfDropEstr.Value);
                    string exec3 = DataBase.Consultas.DeleteFrom(str_conn, sqlDelFOFORNEC);
                    if (exec3 == "OK")
                    {
                        exec3 = DataBase.Consultas.DeleteFrom(str_conn, sqlDelTVESTRUT);
                        if (exec3 == "OK")
                        {
                            ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
                            treeView.DataBind();
                            btnOK.Enabled = false;
                            btnCancelar.Enabled = false;
                            radioModelo.Enabled = false;
                            txtRazao.Enabled = false;
                            txtApelido.Enabled = false;
                            txtCNPJ.Enabled = false;
                            dropPais.Enabled = false;
                            gropGrupo.Enabled = false;
                            radioModelo.Value = null;
                            gropGrupo.Value = null;
                            txtRazao.Text = null;
                            txtApelido.Text = null;
                            txtCNPJ.Text = null;
                            dropPais.Value = null;
                            btnInserir.Enabled = true;
                            btnAlterar.Enabled = false;
                            btnExcluir.Enabled = false;
                            btnOK.Enabled = false;
                            btnCancelar.Enabled = false;
                            mv_Loja.ActiveViewIndex = -1;
                        }
                    }
                    break;
                #endregion
                case "Associar":

                    break;
            }
        }
        protected void gropGrupo_Load(object sender, EventArgs e)
        {
            if (radioModelo.Value == null) return;
            gropGrupo.ClientEnabled = radioModelo.SelectedItem.Value.ToString() == "1";
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            btnInserir.Enabled = true;
            btnAlterar.Enabled = false;
            btnExcluir.Enabled = false;
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
            mv_Loja.ActiveViewIndex = -1;
        }
        protected void UserCommands(object sender, CommandEventArgs e)
        {
            switch (e.CommandArgument)
            {
                case "inserir":
                    Session["UserOperacao"] = e.CommandArgument;
                    break;
                case "alterar":
                    Session["UserOperacao"] = e.CommandArgument;
                    break;
                case "excluir":
                    Session["UserOperacao"] = e.CommandArgument;
                    break;
                case "ok":
                    if (Session["UserOperacao"] != null)
                    {
                        switch (Session["UserOperacao"].ToString())
                        {
                            case "inserir":
                                break;
                            case "alterar":
                                break;
                            case "excluir":
                                break;
                        }
                        Session["UserOperacao"] = null;
                    }
                    break;
                case "cancelar":
                    if (Session["UserOperacao"] != null)
                    {
                        switch (Session["UserOperacao"].ToString())
                        {
                            case "inserir":
                                break;
                            case "alterar":
                                break;
                            case "excluir":
                                break;
                        }
                        Session["UserOperacao"] = null;
                    }
                    break;
            }
        }
        protected void gridUsuarios_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.InsertValues)
            {
                string GOIDGRUP, USLANGUE, USNMPRUS, USEMAILU, USNMSNUS, USNUMCEL, USIDUSUA;
                GOIDGRUP = item.NewValues["GOIDGRUP"].ToString();
                USLANGUE = item.NewValues["USLANGUE"].ToString();
                USNMPRUS = item.NewValues["USNMPRUS"].ToString();
                USEMAILU = item.NewValues["USEMAILU"].ToString();
                USNMSNUS = item.NewValues["USNMSNUS"].ToString();
                USNUMCEL = item.NewValues["USNUMCEL"].ToString();
                USNUMCEL = USNUMCEL.Replace("(", "").Replace(")", "").Replace("-", "");
                USIDUSUA = item.NewValues["USIDUSUA"].ToString();
                string sql = "INSERT INTO TUSUSUARI (GOIDGRUP, USLANGUE, USNMPRUS, USEMAILU, USNMSNUS, USNUMCEL, USIDUSUA, TVIDESTR,TUDATECA,USTPIDTP,USFLCONC,USCDSEUS) " +
                            "VALUES(@GOIDGRUP, '@USLANGUE', '@USNMPRUS', '@USEMAILU', '@USNMSNUS', '@USNUMCEL', '@USIDUSUA', 1, CONVERT(DATE, GETDATE()), 1, 0,'@USCDSEUS')";
                string USCDSEUS = DataBase.Consultas.Consulta(str_conn, "SELECT dbo.nesta_fn_Criptografa ('12345678a!')", 1)[0];
                sql = sql.Replace("@GOIDGRUP", GOIDGRUP);
                sql = sql.Replace("@USLANGUE", USLANGUE);
                sql = sql.Replace("@USNMPRUS", USNMPRUS);
                sql = sql.Replace("@USEMAILU", USEMAILU);
                sql = sql.Replace("@USNMSNUS", USNMSNUS);
                sql = sql.Replace("@USNUMCEL", USNUMCEL);
                sql = sql.Replace("@USCDSEUS", USCDSEUS);
                sql = sql.Replace("@USIDUSUA", USIDUSUA);
                string exec = DataBase.Consultas.InsertInto(str_conn, sql);
                if (exec == "OK")
                {

                    sql = "INSERT INTO UTUTISEN (USIDUSUA ,USCDSEUS ,UTDTCASE ,UTHOCASE ,USFLFLAG ,UTDTINIC ,UTIDUTSE) " +
                            "VALUES ('@USIDUSUA' ,'@USCDSEUS' ,convert(date,dateadd(month,12,getDate())) ,'00:00:00' ,1 ,convert(date,getDate()) ,1)";
                    sql = sql.Replace("@USIDUSUA", USIDUSUA);
                    sql = sql.Replace("@USCDSEUS", USCDSEUS);
                    exec = DataBase.Consultas.InsertInto(str_conn, sql);
                    if (exec == "OK")
                    {
                        gridUsuarios.DataBind();
                    }
                }
            }
            foreach (var item in e.UpdateValues)
            {
                string GOIDGRUP, USLANGUE, USNMPRUS, USEMAILU, USNMSNUS, USNUMCEL, USIDUSUA;
                GOIDGRUP = item.NewValues["GOIDGRUP"] == null ? item.OldValues["GOIDGRUP"].ToString() : item.NewValues["GOIDGRUP"].ToString();
                USLANGUE = item.NewValues["USLANGUE"] == null ? item.OldValues["USLANGUE"].ToString() : item.NewValues["USLANGUE"].ToString();
                USNMPRUS = item.NewValues["USNMPRUS"] == null ? item.OldValues["USNMPRUS"].ToString() : item.NewValues["USNMPRUS"].ToString();
                USEMAILU = item.NewValues["USEMAILU"] == null ? item.OldValues["USEMAILU"].ToString() : item.NewValues["USEMAILU"].ToString();
                USNMSNUS = item.NewValues["USNMSNUS"] == null ? item.OldValues["USNMSNUS"].ToString() : item.NewValues["USNMSNUS"].ToString();
                USNUMCEL = item.NewValues["USNUMCEL"] == null ? "NULL" : "'" + item.NewValues["USNUMCEL"].ToString() + "'";
                USNUMCEL = USNUMCEL.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                USIDUSUA = item.Keys["USIDUSUA"].ToString();
                string sql = "UPDATE TUSUSUARI " +
   "SET GOIDGRUP = @GOIDGRUP, USLANGUE = '@USLANGUE', USNMPRUS = '@USNMPRUS', USEMAILU = '@USEMAILU', USNMSNUS = '@USNMSNUS', USNUMCEL = @USNUMCEL " +
 "WHERE USIDUSUA = '@USIDUSUA'";
                sql = sql.Replace("@GOIDGRUP", GOIDGRUP);
                sql = sql.Replace("@USLANGUE", USLANGUE);
                sql = sql.Replace("@USNMPRUS", USNMPRUS);
                sql = sql.Replace("@USEMAILU", USEMAILU);
                sql = sql.Replace("@USNMSNUS", USNMSNUS);
                sql = sql.Replace("@USNUMCEL", USNUMCEL);
                sql = sql.Replace("@USIDUSUA", USIDUSUA);

                string exec = DataBase.Consultas.UpdtFrom(str_conn, sql);
                if (exec == "OK")
                {
                    gridUsuarios.DataBind();
                }
            }
        }
        protected void gridUsuarios_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            if (e.NewValues["USEMAILU"] != null)
            {
                if (e.IsNewRow)
                {
                    if (string.IsNullOrEmpty(e.NewValues["USEMAILU"].ToString())) return;
                    bool duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from TUSUSUARI WHERE USEMAILU='" + e.NewValues["USEMAILU"].ToString() + "'", 1)[0]) > 0;
                    if (duplicado)
                    {
                        e.RowError = "E-mail cadastrado para outro usuário.";
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(e.NewValues["USEMAILU"].ToString())) return;
                    bool duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from TUSUSUARI WHERE USIDUSUA not in ('" + e.Keys["USIDUSUA"].ToString() + "') and  USEMAILU='" + e.NewValues["USEMAILU"].ToString() + "'", 1)[0]) > 0;
                    if (duplicado)
                    {
                        e.RowError = "E-mail cadastrado para outro usuário.";
                    }
                }
            }
        }
        protected void gridUsuarios_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.ButtonID == "disable")
            {
                int valida = Convert.ToInt32(gridUsuarios.GetRowValues(e.VisibleIndex, "USTPIDTP"));
                if (valida == 0)
                {
                    e.Enabled = false;
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
            else if (e.ButtonID == "enable")
            {
                int valida = Convert.ToInt32(gridUsuarios.GetRowValues(e.VisibleIndex, "USTPIDTP"));
                if (valida == 1)
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                    e.Enabled = false;
                }
            }
            else if (e.ButtonID == "reset")
            {
                int valida = Convert.ToInt32(gridUsuarios.GetRowValues(e.VisibleIndex, "USTPIDTP"));
                if (valida == 0)
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                    e.Enabled = false;
                }
            }
        }
        protected void gridUsuarios_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string USIDUSUA = gridUsuarios.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString();
            string sqlUpdate = string.Empty;
            string sqlUpdate2 = string.Empty;
            string exec = string.Empty;
            switch (e.ButtonID)
            {
                case "enable":
                    DataBase.Consultas.Acao = "Cadastro Usuário";
                    DataBase.Consultas.Resumo = "Reativar Usuário";
                    DataBase.Consultas.Alteracao = "Procedimento de Reativação do usuário " + USIDUSUA;
                    sqlUpdate = "UPDATE TUSUSUARI SET USTPIDTP=1  WHERE USIDUSUA = '@USIDUSUA'";
                    sqlUpdate2 = "UPDATE UTUTISEN SET USFLFLAG=1  WHERE USIDUSUA = '@USIDUSUA'";
                    sqlUpdate = sqlUpdate.Replace("@USIDUSUA", USIDUSUA);
                    sqlUpdate2 = sqlUpdate2.Replace("@USIDUSUA", USIDUSUA);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if (exec == "OK")
                    {
                        DataBase.Consultas.GravaLog = true;
                        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate2);
                        if (exec == "OK")
                            gridUsuarios.DataBind();
                        DataBase.Consultas.GravaLog = false;
                    }
                    break;
                case "disable":
                    DataBase.Consultas.Acao = "Cadastro Usuário";
                    DataBase.Consultas.Resumo = "Desativar Usuário";
                    DataBase.Consultas.Alteracao = "Procedimento de Desativação do usuário " + USIDUSUA;
                    sqlUpdate = "UPDATE TUSUSUARI SET USTPIDTP=0  WHERE USIDUSUA = '@USIDUSUA'";
                    sqlUpdate2 = "UPDATE UTUTISEN SET USFLFLAG=0  WHERE USIDUSUA = '@USIDUSUA'";
                    sqlUpdate = sqlUpdate.Replace("@USIDUSUA", USIDUSUA);
                    sqlUpdate2 = sqlUpdate2.Replace("@USIDUSUA", USIDUSUA);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if (exec == "OK")
                    {
                        DataBase.Consultas.GravaLog = true;
                        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate2);
                        if (exec == "OK")
                            gridUsuarios.DataBind();
                        DataBase.Consultas.GravaLog = false;
                    }
                    break;
                case "reset":
                    DataBase.Consultas.Acao = "Cadastro Usuário";
                    DataBase.Consultas.Resumo = "Reset de Senha";
                    DataBase.Consultas.Alteracao = "Procedimento de Reset de senha do usuário " + USIDUSUA;
                    string[] param_dados = new string[4];
                    CultureInfo culture = new CultureInfo(lang);
                    param_dados[3] = "@p_idioma#" + culture.ToString();
                    string senhaNova = System.Configuration.ConfigurationManager.AppSettings["senhaPadrao"];
                    string USCDSEUS = DataBase.Consultas.Consulta(str_conn, "SELECT dbo.nesta_fn_Criptografa ('" + senhaNova + "')", 1)[0];
                    string sqlUs1 = "update TUSUSUARI set USCDSEUS='" + USCDSEUS + "' where USIDUSUA='" + USIDUSUA + "'";
                    string sqlUs2 = "update UTUTISEN set USCDSEUS='" + USCDSEUS + "' where USIDUSUA='" + USIDUSUA + "'";
                    param_dados[0] = "@p_User#" + USIDUSUA;
                    param_dados[1] = "@p_Pass#" + USCDSEUS;
                    param_dados[2] = "@p_Reset#1";
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUs1);
                    if (exec == "OK")
                    {
                        DataBase.Consultas.GravaLog = true;
                        //exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUs2);
                        exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Reset_Credential", param_dados, "p_mensagem");
                        if (exec == "OK")
                        {
                            string WhatsNum = DataBase.Consultas.Consulta(str_conn, "select USNUMCEL from TUSUSUARI where USIDUSUA='" + USIDUSUA + "'", 1)[0];
                            if (!string.IsNullOrEmpty(WhatsNum))
                            {
                                string WhatsMsg = "Senha do sistema nesta alterada para: " + senhaNova + ". \n Será solicitado alteração no primeiro login.";
                                //DataBase.Funcoes.SendWhats(WhatsNum.Trim(), WhatsMsg);
                            }
                            gridUsuarios.DataBind();
                        }
                        else
                            throw new ApplicationException(exec);
                        DataBase.Consultas.GravaLog = false;
                    }
                    else
                        throw new ApplicationException(exec);
                    break;
            }
        }
        protected void gridUsuarios_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            int valida = Convert.ToInt32(gridUsuarios.GetRowValues(e.VisibleIndex, "USTPIDTP"));
            if (valida == 0)
            {
                e.Row.ToolTip = "Usuário está desativado.";
                e.Row.BackColor = System.Drawing.Color.LightGray;
                e.Row.ForeColor = System.Drawing.Color.White;
            }
        }
        protected void ASPxMenu1_Load(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            ASPxMenu1.Items.FindByName("1").Enabled = perfil != "3";
            ASPxMenu1.Items.FindByName("2").Enabled = perfil == "1";
            ASPxMenu1.Items.FindByName("4").Enabled = perfil == "1";
            ASPxMenu1.Items.FindByName("3").Enabled = perfil == "1";
            ASPxMenu1.Items.FindByName("admin").Enabled = perfil == "1";
            ASPxMenu1.Items.FindByName("admin2").Enabled = perfil == "1";
            ASPxMenu1.Items.FindByName("config").Enabled = perfil == "1";
        }
        protected void gridDisponiveis_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string acao = e.Parameters.Split('#')[0];
            int Index = Convert.ToInt32(e.Parameters.Split('#')[1]);
            if (acao == "assoc")
            {
                string TVIDESTR = hfDropEstr.Value;
                string USIDUSUA = gridDisponiveis.GetRowValues(Index, "USIDUSUA").ToString();
                string sql = "INSERT INTO VIFSFUSU (FSIDFUSI,USIDUSUA,TVIDESTR) " +
                            "VALUES(0,'@USIDUSUA',@TVIDESTR)";
                sql = sql.Replace("@USIDUSUA", USIDUSUA);
                sql = sql.Replace("@TVIDESTR", TVIDESTR);
                string exec = DataBase.Consultas.InsertInto(str_conn, sql);
                if (exec == "OK")
                {
                    gridAssociadas.JSProperties["cp_ok"] = "OK";
                    gridDisponiveis.JSProperties["cp_ok"] = "OK";
                    gridAssociadas.DataBind();
                    gridDisponiveis.DataBind();
                }
            }
        }
        protected void gridAssociadas_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string acao = e.Parameters.Split('#')[0];
            int Index = Convert.ToInt32(e.Parameters.Split('#')[1]);
            if (acao == "delete")
            {
                string TVIDESTR = hfDropEstr.Value;
                string USIDUSUA = gridAssociadas.GetRowValues(Index, "USIDUSUA").ToString();
                string sql = "DELETE VIFSFUSU WHERE USIDUSUA='@USIDUSUA' AND TVIDESTR=@TVIDESTR";
                sql = sql.Replace("@USIDUSUA", USIDUSUA);
                sql = sql.Replace("@TVIDESTR", TVIDESTR);
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
                if (exec == "OK")
                {
                    gridAssociadas.JSProperties["cp_ok"] = "OK";
                    gridDisponiveis.JSProperties["cp_ok"] = "OK";
                    gridAssociadas.DataBind();
                    gridDisponiveis.DataBind();
                }
            }
        }
        protected void gridNivel_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.UpdateValues)
            {
                string NIIDAPRO = item.Keys["NIIDAPRO"].ToString();
                string NINMAPRO = item.NewValues["NINMAPRO"] == null ? item.OldValues["NINMAPRO"].ToString() : item.NewValues["NINMAPRO"].ToString();
                string NIVL1APR = item.NewValues["NIVL1APR"] == null ? item.OldValues["NIVL1APR"].ToString() : item.NewValues["NIVL1APR"].ToString();
                string NIVL2APR = item.NewValues["NIVL2APR"] == null ? item.OldValues["NIVL2APR"].ToString() : item.NewValues["NIVL2APR"].ToString();
                string sqlUpd = "UPDATE NIAPROVA " +
   "SET NINMAPRO = '@NINMAPRO' " +
      ", NIVL1APR = @NIVL1APR " +
      ", NIVL2APR = @NIVL2APR " +
 "WHERE NIIDAPRO = @NIIDAPRO";
                sqlUpd = sqlUpd.Replace("@NIIDAPRO", NIIDAPRO);
                sqlUpd = sqlUpd.Replace("@NINMAPRO", NINMAPRO);
                sqlUpd = sqlUpd.Replace("@NIVL1APR", NIVL1APR);
                sqlUpd = sqlUpd.Replace("@NIVL2APR", NIVL2APR);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                if (exec == "OK")
                    gridNivel.DataBind();
            }
        }
        protected void gridNivelAssociados_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.InsertValues)
            {
                string sqlIns = "INSERT INTO VINIUSUA (NIIDAPRO ,USIDUSUA) VALUES (@NIIDAPRO ,'@USIDUSUA')";
                sqlIns = sqlIns.Replace("@NIIDAPRO", item.NewValues["NIIDAPRO"].ToString());
                sqlIns = sqlIns.Replace("@USIDUSUA", item.NewValues["USIDUSUA"].ToString());
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns);
                if (exec == "OK")
                    gridNivelAssociados.DataBind();
            }
            foreach (var item in e.UpdateValues)
            {
                string VIIDNIUS = item.Keys["VIIDNIUS"].ToString();
                string USIDUSUA = item.NewValues["USIDUSUA"] == null ? item.OldValues["USIDUSUA"].ToString() : item.NewValues["USIDUSUA"].ToString();
                string NIIDAPRO = item.NewValues["NIIDAPRO"] == null ? item.OldValues["NIIDAPRO"].ToString() : item.NewValues["NIIDAPRO"].ToString();
                string sqlUpd = "UPDATE VINIUSUA SET NIIDAPRO = @NIIDAPRO ,USIDUSUA = '@USIDUSUA' WHERE VIIDNIUS=@VIIDNIUS";
                sqlUpd = sqlUpd.Replace("@NIIDAPRO", NIIDAPRO);
                sqlUpd = sqlUpd.Replace("@USIDUSUA", USIDUSUA);
                sqlUpd = sqlUpd.Replace("@VIIDNIUS", VIIDNIUS);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                if (exec == "OK")
                    gridNivelAssociados.DataBind();
            }
            foreach (var item in e.DeleteValues)
            {
                string VIIDNIUS = item.Keys["VIIDNIUS"].ToString();
                string sqlDel = "DELETE VINIUSUA WHERE  VIIDNIUS=@VIIDNIUS";
                sqlDel = sqlDel.Replace("@VIIDNIUS", VIIDNIUS);
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDel);
                if (exec == "OK")
                    gridNivelAssociados.DataBind();
            }
        }
        protected void btnNextBoleto_Click(object sender, EventArgs e)
        {
            int VITPPGTO = 0;
            switch (dropFormPagt.Value)
            {
                case "B": //Boleto
                    VITPPGTO = 1;
                    break;

                case "T": //Deposito
                    VITPPGTO = 2;
                    break;
                case "D": //Debito em conta
                    VITPPGTO = 3;
                    break;
            }
            txtBoletoTotal.Enabled = false;
            dropContratosBoleto.Enabled = false;
            txtNomeBoleto.Enabled = false;
            dropLocatario.Enabled = false;
            txtDtVenc.Enabled = false;
            DateTime dtVenc = Convert.ToDateTime(txtDtVenc.Text);
            DataTable dt = new DataTable();
            dt.Columns.Add("ID2");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "valor";
            dc.DataType = System.Type.GetType("System.Decimal");
            dt.Columns.Add(dc);
            dt.Columns.Add("moidmoda");
            ASPxGridView1.KeyFieldName = "ID2";
            DataRow dr;
            int cont = 1;
            foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select V.MOIDMODA,CJIDCODI from VIOPMODA V, MODALIDA M where V.VITPPGTO=" + VITPPGTO + " AND V.OPIDCONT=" + dropContratosBoleto.Value.ToString() + " AND V.MOIDMODA=M.MOIDMODA AND M.MOTIPOVALO=0 ").Rows)
            {
                dr = dt.NewRow();
                dr["ID2"] = DateTime.Now.ToString("ddMMyyHHmmss") + cont.ToString();
                switch (row[1].ToString())
                {
                    case "25700":
                        string sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        string sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        string sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and PHDTEVEN=convert(date,'" + sqlDia + "') and MOIDMODA=" + row[0].ToString() + "";
                        float valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                        dr["valor"] = valorContrato;
                        break;
                    case "25701":
                        sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        string sqlValorFix = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and PHDTEVEN=convert(date,'" + sqlDia + "') and MOIDMODA=" + row[0].ToString() + "";
                        float valorContratoFix = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValorFix, 1)[0]);
                        dr["valor"] = valorContratoFix;
                        break;
                    case "25702":
                        sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        string sqlValorold = "select CJTPCTTX from CJCLPROP where CJIDCODI=25702";
                        string result = DataBase.Consultas.Consulta(str_conn, sqlValorold, 1)[0];
                        string codConvert = lang == "en-US" ? "101" : "103";
                        result = result.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                        result = result.Replace("@p_date", "convert(datetime,'" + sqlDia + "',103)");
                        valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result, 1)[0]);
                        dr["valor"] = valorContrato;
                        break;
                    case "25703":
                        sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        string sqlValorold2 = "select CJTPCTTX from CJCLPROP where CJIDCODI=25703";
                        string result2 = DataBase.Consultas.Consulta(str_conn, sqlValorold2, 1)[0];
                        string codConvert2 = lang == "en-US" ? "101" : "103";
                        result2 = result2.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                        result2 = result2.Replace("@p_date", "convert(datetime,'" + sqlDia + "',103)");
                        valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result2, 1)[0]);
                        dr["valor"] = valorContrato;
                        break;
                    default:
                        dr["valor"] = 0;
                        break;
                }
                dr["moidmoda"] = row[0].ToString();
                dt.Rows.Add(dr);
                cont++;
            }
            sqlVerbas2.SelectParameters[0].DefaultValue = hfOpidcont.Value;
            sqlVerbas2.DataBind();
            Session["dtNovaBoleta2"] = dt;
            ASPxGridView1.DataSource = dt;
            ASPxGridView1.DataBind();
        }
        protected void gridEntry_CustomDataCallback(object sender, ASPxGridViewCustomDataCallbackEventArgs e)
        {

        }
        protected void gridEntry_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            bool existe = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from BOLTOTBO where upper(BOLNMBOL)='" + txtNomeBoleto.Text.ToUpper() + "' and OPIDCONT=" + dropContratosBoleto.Value.ToString() + "", 1)[0]) > 0;
            if (existe)
            {
                args.IsValid = false;
                return;
            }
            else
            {
                args.IsValid = true;
                return;
            }
        }
        protected void btnGravarBoleto_Click(object sender, EventArgs e)
        {
            if (Session["dtNovaBoleta2"] != null)
            {
                DataTable dt = (DataTable)Session["dtNovaBoleta2"] as DataTable;
                if (Page.IsValid)
                {
                    string BOLCDBOL = "0";
                    string BOLDTVCT = Convert.ToDateTime(txtDtVenc.Text).ToString("dd/MM/yyyy");
                    float valortotal = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        valortotal = valortotal + (float)Convert.ToDecimal(row["valor"].ToString());
                    }
                    //string BOLVLBOL = txtBoletoTotal.Text.Replace(".", "").Replace(",", ".");
                    string BOLVLBOL = valortotal.ToString().Replace(".", "").Replace(",", ".");
                    string BOLNMBOL = txtNomeBoleto.Text;
                    string OPIDCONT = dropContratosBoleto.Value.ToString();
                    string BOLTPBOL = dropFormPagt.Value.ToString();
                    string sqlInsert = "INSERT INTO BOLTOTBO(BOLCDBOL,BOLDTVCT,BOLVLBOL,BOLNMBOL,OPIDCONT,BOLTPBOL,BOLSTBOL,BOLTPENT) " +
                                        "VALUES(@BOLCDBOL, convert(date, '@BOLDTVCT', 103), @BOLVLBOL, '@BOLNMBOL', @OPIDCONT,'@BOLTPBOL',0,1)";
                    sqlInsert = sqlInsert.Replace("@BOLCDBOL", BOLCDBOL);
                    sqlInsert = sqlInsert.Replace("@BOLDTVCT", BOLDTVCT);
                    sqlInsert = sqlInsert.Replace("@BOLVLBOL", BOLVLBOL);
                    sqlInsert = sqlInsert.Replace("@BOLNMBOL", BOLNMBOL);
                    sqlInsert = sqlInsert.Replace("@OPIDCONT", OPIDCONT);
                    sqlInsert = sqlInsert.Replace("@BOLTPBOL", BOLTPBOL);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            DataRow dr = dt.Rows[i];
                            string moidmoda = dr["moidmoda"].ToString();
                            string data = DateTime.Now.ToString("dd/MM/yyyy");
                            string valor = dr["valor"].ToString().Replace(",", ".");
                            string opidcont = OPIDCONT;
                            string usidusua = hfUser.Value;
                            string data_venc = BOLDTVCT;
                            string bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(BOLIDBOL) from BOLTOTBO where BOLDTVCT=convert(date,'" + BOLDTVCT + "',103) and OPIDCONT=" + OPIDCONT, 1)[0];
                            string sqlInsert2 = "INSERT INTO fluxo_oper_jesse (moidmoda,data,valor,valida,opidcont,aprovado,data_venc,bolidbol,usidusua) " +
                 "VALUES(@moidmoda, convert(date, '@data', 103), @valor, 0, @opidcont, 0, convert(date, '@data_venc', 103), @bolidbol, '@usidusua')";
                            sqlInsert2 = sqlInsert2.Replace("@moidmoda", moidmoda);
                            sqlInsert2 = sqlInsert2.Replace("@data_venc", data_venc);
                            sqlInsert2 = sqlInsert2.Replace("@data", data);
                            sqlInsert2 = sqlInsert2.Replace("@valor", valor);
                            sqlInsert2 = sqlInsert2.Replace("@opidcont", opidcont);
                            sqlInsert2 = sqlInsert2.Replace("@bolidbol", bolidbol);
                            sqlInsert2 = sqlInsert2.Replace("@usidusua", usidusua);
                            exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert2);
                            if (exec == "OK")
                            {
                                Session["dtNovaBoleta2"] = null;
                                ASPxGridView1.DataSource = null;
                                ASPxGridView1.DataBind();
                                txtBoletoTotal.Enabled = true;
                                dropContratosBoleto.Enabled = true;
                                txtNomeBoleto.Enabled = true;
                                dropLocatario.Enabled = true;
                                txtDtVenc.Enabled = true;
                            }
                        }
                    }
                }
            }
        }
        protected void btnLimparBoleto_Click(object sender, EventArgs e)
        {
            hfBoleto.Value = string.Empty;
            txtBoletoTotal.Enabled = true;
            txtBoletoTotal.Text = string.Empty;
            dropContratosBoleto.Enabled = true;
            dropContratosBoleto.Value = string.Empty;
            dropLocatario.Enabled = true;
            dropLocatario.Value = string.Empty;
            txtNomeBoleto.Enabled = true;
            txtNomeBoleto.Text = string.Empty;
            txtDtVenc.Enabled = true;
            txtDtVenc.Text = string.Empty;
            if (Session["dtNovaBoleta2"] != null)
            {
                DataTable dt = (DataTable)Session["dtNovaBoleta2"] as DataTable;
                dt = null;
                Session["dtNovaBoleta2"] = null;
                ASPxGridView1.DataSource = null;
                ASPxGridView1.DataBind();
            }
        }
        protected void dropLocatario_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlContratos2.SelectParameters[0].DefaultValue = dropLocatario.Value.ToString();
            sqlContratos2.SelectParameters[1].DefaultValue = dropLocatario.Value.ToString();
            sqlContratos2.DataBind();
            dropContratosBoleto.DataBind();
            if (dropContratosBoleto.Items.Count == 1)
            {
                dropContratosBoleto.Value = dropContratosBoleto.Items[0];
                hfOpidcont.Value = dropContratosBoleto.Items[0].Value.ToString();
            }
            else if (dropContratosBoleto.Items.Count > 1)
            {
                dropContratosBoleto.Value = string.Empty;
            }
        }
        protected void gridEntry_BatchUpdate1(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

        }
        protected void ASPxGridView1_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            if (Session["dtNovaBoleta2"] != null)
            {
                DataTable dt = (DataTable)Session["dtNovaBoleta2"] as DataTable;
                DataRow dr;
                int cont = 1;
                Decimal fTotal = Convert.ToDecimal(txtBoletoTotal.Text);
                Decimal fParcial = 0;
                foreach (var item in e.InsertValues)
                {
                    dr = dt.NewRow();
                    dr["ID2"] = DateTime.Now.ToString("ddMMyyHHmmss") + cont.ToString();
                    dr["valor"] = item.NewValues["valor"].ToString();
                    dr["moidmoda"] = item.NewValues["moidmoda"].ToString();
                    dt.Rows.Add(dr);
                    cont++;
                }
                foreach (var item in e.DeleteValues)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID2"].ToString() == item.Keys["ID2"].ToString())
                            dr.Delete();
                    }
                    dt.AcceptChanges();
                }
                foreach (var item in e.UpdateValues)
                {
                    string valor = item.NewValues["valor"] == null ? item.OldValues["valor"].ToString() : item.NewValues["valor"].ToString();
                    string moidmoda = item.NewValues["moidmoda"] == null ? item.OldValues["moidmoda"].ToString() : item.NewValues["moidmoda"].ToString();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID2"].ToString() == item.Keys["ID2"].ToString())
                        {
                            dr["valor"] = valor;
                            dr["moidmoda"] = moidmoda;
                        }
                    }
                    dt.AcceptChanges();
                }
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dr = dt.Rows[i];
                    fParcial += Convert.ToDecimal(dr["valor"].ToString());
                }
                if (dt.Rows.Count == 0)
                {
                    txtBoletoTotal.ForeColor = System.Drawing.Color.DimGray;
                    lblErroTotal.Text = string.Empty;
                }
                else
                {
                    if (fTotal != fParcial)
                    {
                        lblErroTotal.Text = "Valores boletados não batem com total.";
                        txtBoletoTotal.ForeColor = System.Drawing.Color.Red;
                    }
                    else
                    {
                        txtBoletoTotal.ForeColor = System.Drawing.Color.DimGray;
                        lblErroTotal.Text = string.Empty;
                    }
                }
                Session["dtNovaBoleta2"] = dt;
                ASPxGridView1.DataSource = dt;
                ASPxGridView1.DataBind();
            }
        }
        protected void ASPxGridView1_CustomDataCallback(object sender, ASPxGridViewCustomDataCallbackEventArgs e)
        {
            string sql, sqlDia, sqlValor;
            float valorContrato;
            if (e.Parameters.ToString().Split('#')[0] == "moidmoda")
            {
                string sqlBases = "select CJIDCODI,MOIDMODA from VIOPMODA where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and CHIDCODI is not null and CJIDCODI is not null";
                var dtBases = DataBase.Consultas.Consulta(str_conn, sqlBases);
                foreach (DataRow row in dtBases.Rows)
                {
                    if (row[1].ToString() == e.Parameters.ToString().Split('#')[1])
                    {
                        switch (row[0].ToString())
                        {
                            case "25700":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and PHDTEVEN='" + sqlDia + "' and MOIDMODA=" + e.Parameters.ToString().Split('#')[1] + "";
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                                e.Result = "valor2#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                            case "25702":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold = "select CJTPCTTX from CJCLPROP where CJIDCODI=25702";
                                string result = DataBase.Consultas.Consulta(str_conn, sqlValorold, 1)[0];
                                string codConvert = lang == "en-US" ? "101" : "103";
                                result = result.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                                result = result.Replace("@p_date", "'" + sqlDia + "'");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result, 1)[0]);
                                e.Result = "valor2#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                            case "25703":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold2 = "select CJTPCTTX from CJCLPROP where CJIDCODI=25703";
                                string result2 = DataBase.Consultas.Consulta(str_conn, sqlValorold2, 1)[0];
                                string codConvert2 = lang == "en-US" ? "101" : "103";
                                result2 = result2.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                                result2 = result2.Replace("@p_date", "'" + sqlDia + "'");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result2, 1)[0]);
                                e.Result = "valor2#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                        }
                    }
                }
            }
        }
        protected void dropLocatario2_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlBoletosGrid.SelectParameters[0].DefaultValue = dropLocatario2.Value.ToString();
            sqlBoletosGrid.SelectParameters[1].DefaultValue = dropLocatario2.Value.ToString();
            sqlBoletosGrid.DataBind();
            gridBoleto.DataBind();
        }
        protected void gridDetalheBoleto_BeforePerformDataSelect(object sender, EventArgs e)
        {
            sqlDetalheBoletos.SelectParameters[0].DefaultValue = (sender as ASPxGridView).GetMasterRowKeyValue().ToString();
        }
        protected void radioExibir_SelectedIndexChanged(object sender, EventArgs e)
        {
            mv_PortalLocatario.ActiveViewIndex = Convert.ToInt32(radioExibir.SelectedItem.Value);
        }
        protected void gridModalidadesDisponiveis_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.InsertValues)
            {
                string sqlIns = "INSERT INTO MODALIDA (MOIDMODA ,MODSMODA,MOTPIDCA,MOFLPADR,MOIDORDE) VALUES (@MOIDMODA,'@MODSMODA' ,@MOTPIDCA,0,0)";
                sqlIns = sqlIns.Replace("@MOIDMODA", DataBase.Consultas.Consulta(str_conn, "select MAX(MOIDMODA)+1 from MODALIDA", 1)[0]);
                sqlIns = sqlIns.Replace("@MODSMODA", item.NewValues["MODSMODA"].ToString());
                sqlIns = sqlIns.Replace("@MOTPIDCA", item.NewValues["MOTPIDCA"].ToString());
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns);
                if (exec == "OK")
                    gridModalidadesDisponiveis.DataBind();
            }
            foreach (var item in e.UpdateValues)
            {
                string MOIDMODA = item.Keys["MOIDMODA"].ToString();
                string MODSMODA = item.NewValues["MODSMODA"] == null ? item.OldValues["MODSMODA"].ToString() : item.NewValues["MODSMODA"].ToString();
                string MOTPIDCA = item.NewValues["MOTPIDCA"] == null ? item.OldValues["MOTPIDCA"].ToString() : item.NewValues["MOTPIDCA"].ToString();
                string sqlUpd = "UPDATE MODALIDA SET MODSMODA = '@MODSMODA' ,MOTPIDCA = '@MOTPIDCA' WHERE MOIDMODA=@MOIDMODA";
                sqlUpd = sqlUpd.Replace("@MODSMODA", MODSMODA);
                sqlUpd = sqlUpd.Replace("@MOTPIDCA", MOTPIDCA);
                sqlUpd = sqlUpd.Replace("@MOIDMODA", MOIDMODA);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                if (exec == "OK")
                    gridModalidadesDisponiveis.DataBind();
            }
            foreach (var item in e.DeleteValues)
            {
                string MOIDMODA = item.Keys["MOIDMODA"].ToString();
                string sqlValida = "select sum(qtd) from ( " +
"select COUNT(*) as qtd from RZRAZCTB R " +
"where R.MOIDMODA = " + MOIDMODA + " " +
"union select COUNT(*) as qtd from PHPLANIF_OPER P " +
"where P.MOIDMODA = " + MOIDMODA + " ) as q";
                bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) == 0;
                if (valida)
                {
                    string sqlDel = "DELETE MODALIDA WHERE  MOIDMODA=@MOIDMODA";
                    sqlDel = sqlDel.Replace("@MOIDMODA", MOIDMODA);
                    string sqlDel2 = "DELETE VIPROMOD WHERE MOIDMODA=@MOIDMODA";
                    sqlDel2 = sqlDel2.Replace("@MOIDMODA", MOIDMODA);
                    string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDel);
                    if (exec == "OK")
                    {
                        exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDel2);
                        if (exec == "OK")
                            gridModalidadesDisponiveis.DataBind();
                    }
                }
                else
                {
                    //gridModalidadesDisponiveis.JSProperties["cp_msgErro"] = "Modalidade não pode ser excluída.";
                    MsgException("Modalidade não pode ser excluída.", 1);
                }
            }
        }
        protected void gridModalidadesDisponiveis_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string acao = e.ButtonID;
            int Index = e.VisibleIndex;
            if (acao == "assoc")
            {
                string TVIDESTR = hfDropEstr.Value;
                string PRPRODID = hfDropProd.Value;
                string MOIDMODA = gridModalidadesDisponiveis.GetRowValues(Index, "MOIDMODA").ToString();
                string sql = "INSERT INTO VIPROMOD (TVIDESTR,PRPRODID,MOIDMODA) VALUES(@TVIDESTR,@PRPRODID,@MOIDMODA)";
                sql = sql.Replace("@TVIDESTR", TVIDESTR);
                sql = sql.Replace("@PRPRODID", PRPRODID);
                sql = sql.Replace("@MOIDMODA", MOIDMODA);
                string exec = DataBase.Consultas.InsertInto(str_conn, sql);
                if (exec == "OK")
                {
                    gridModalidadesAssociadas.JSProperties["cp_ok"] = "OK";
                    gridModalidadesDisponiveis.JSProperties["cp_ok"] = "OK";
                }
            }
        }
        protected void gridModalidadesAssociadas_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string acao = e.ButtonID;
            int Index = e.VisibleIndex;
            if (acao == "delete")
            {
                string TVIDESTR = hfDropEstr.Value;
                string PRPRODID = hfDropProd.Value;
                string MOIDMODA = gridModalidadesAssociadas.GetRowValues(Index, "MOIDMODA").ToString();
                string sqlValida = "select sum(qtd) from ( " +
"select COUNT(*) as qtd from RZRAZCTB R " +
"where R.MOIDMODA = " + MOIDMODA + " " +
"union select COUNT(*) as qtd from PHPLANIF_OPER P " +
"where P.MOIDMODA = " + MOIDMODA + " ) as q";
                bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) == 0;
                if (valida)
                {
                    string sql = "DELETE VIPROMOD WHERE PRPRODID=@PRPRODID AND TVIDESTR=@TVIDESTR AND MOIDMODA=@MOIDMODA";
                    sql = sql.Replace("@TVIDESTR", TVIDESTR);
                    sql = sql.Replace("@PRPRODID", PRPRODID);
                    sql = sql.Replace("@MOIDMODA", MOIDMODA);
                    string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
                    if (exec == "OK")
                    {
                        gridModalidadesAssociadas.JSProperties["cp_ok"] = "OK";
                        gridModalidadesDisponiveis.JSProperties["cp_ok"] = "OK";
                    }
                }
                else
                {
                    MsgException("Modalidade não pode ser desassociada.", 1);
                }
            }
        }
        protected void dropComponenteProp_SelectedIndexChanged(object sender, EventArgs e)
        {
            hfDropComp.Value = dropComponenteProp.Value.ToString().Split('#')[0];
            hfDropCMID.Value = dropComponenteProp.Value.ToString().Split('#')[1];
            gridPropNaoVinculadas.Enabled = true;
        }
        protected void gridPropNaoVinculadas_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string acao = e.ButtonID;
            int Index = e.VisibleIndex;
            if (acao == "AssocProp")
            {
                string CHIDCODI = hfDropComp.Value;
                string CHTPIDEV = hfDropEvento.Value;
                string CJIDCODI = gridPropNaoVinculadas.GetRowValues(Index, "CJIDCODI").ToString();
                string sql = "INSERT INTO VIPROEVE (CHIDCODI,CHTPIDEV,CJIDCODI) VALUES(@CHIDCODI,@CHTPIDEV,@CJIDCODI)";
                sql = sql.Replace("@CHIDCODI", CHIDCODI);
                sql = sql.Replace("@CHTPIDEV", CHTPIDEV);
                sql = sql.Replace("@CJIDCODI", CJIDCODI);
                string exec = DataBase.Consultas.InsertInto(str_conn, sql);
                if (exec == "OK")
                {
                    gridPropNaoVinculadas.JSProperties["cp_ok"] = "OK";
                    gridPropVinculadas.JSProperties["cp_ok"] = "OK";
                    gridPropNaoVinculadas.DataBind();
                    gridPropVinculadas.DataBind();
                }
            }
        }
        protected void gridPropVinculadas_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string acao = e.ButtonID;
            int Index = e.VisibleIndex;
            if (acao == "deleteProp")
            {
                string CHIDCODI = hfDropComp.Value;
                string CHTPIDEV = hfDropEvento.Value;
                string CJIDCODI = gridPropVinculadas.GetRowValues(Index, "CJIDCODI").ToString();
                string sqlValida = "select count(*) from CJCLPROP_DIN C,OPCONTRA O " +
"WHERE C.OPIDCONT = O.OPIDCONT " +
  "AND C.CJIDCODI = " + CJIDCODI + " " +
  "AND C.CHIDCODI = " + CHIDCODI + "";
                //bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) == 0;
                bool valida = true;
                if (valida)
                {
                    string sql = "DELETE VIPROEVE WHERE CHIDCODI=@CHIDCODI AND CHTPIDEV=@CHTPIDEV AND CJIDCODI=@CJIDCODI";
                    sql = sql.Replace("@CHIDCODI", CHIDCODI);
                    sql = sql.Replace("@CHTPIDEV", CHTPIDEV);
                    sql = sql.Replace("@CJIDCODI", CJIDCODI);
                    string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
                    if (exec == "OK")
                    {
                        gridPropNaoVinculadas.JSProperties["cp_ok"] = "OK";
                        gridPropVinculadas.JSProperties["cp_ok"] = "OK";
                        gridPropNaoVinculadas.DataBind();
                        gridPropVinculadas.DataBind();
                    }
                }
                else
                {
                    MsgException("Propriedade não pode ser desassociada.", 1);
                }
            }
        }
        protected void gridPropNaoVinculadas_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {

            string CJTPIDTP, CJIDCODI, CJDSDECR, CJTPCTTX, CJORORDE, CJDSEXPR, CJDSMENS, CJFILTRO, CJCHAVE, CJFLOBRG, CJTPCAID, CJFLAQUI;
            CJTPIDTP = e.NewValues["CJTPIDTP"] != null ? e.NewValues["CJTPIDTP"].ToString() : e.OldValues["CJTPIDTP"] == null ? e.OldValues["CJTPIDTP"].ToString() : "";
            CJIDCODI = e.Keys["CJIDCODI"].ToString();
            CJDSDECR = e.NewValues["CJDSDECR"] != null ? e.NewValues["CJDSDECR"].ToString() : e.OldValues["CJDSDECR"] == null ? e.OldValues["CJDSDECR"].ToString() : "";
            CJTPCTTX = e.NewValues["CJTPCTTX"] != null ? e.NewValues["CJTPCTTX"].ToString() : e.OldValues["CJTPCTTX"] == null ? e.OldValues["CJTPCTTX"].ToString() : "";
            CJORORDE = e.NewValues["CJORORDE"] != null ? e.NewValues["CJORORDE"].ToString() : e.OldValues["CJORORDE"] == null ? e.OldValues["CJORORDE"].ToString() : "";
            CJDSEXPR = e.NewValues["CJDSEXPR"] != null ? e.NewValues["CJDSEXPR"].ToString() : e.OldValues["CJDSEXPR"] == null ? e.OldValues["CJDSEXPR"].ToString() : "";
            CJDSMENS = e.NewValues["CJDSMENS"] != null ? e.NewValues["CJDSMENS"].ToString() : e.OldValues["CJDSMENS"] == null ? e.OldValues["CJDSMENS"].ToString() : "";
            CJFILTRO = e.NewValues["CJFILTRO"] != null ? e.NewValues["CJFILTRO"].ToString() : e.OldValues["CJFILTRO"] == null ? e.OldValues["CJFILTRO"].ToString() : "";
            CJCHAVE = e.NewValues["CJCHAVE"] != null ? e.NewValues["CJCHAVE"].ToString() : e.OldValues["CJCHAVE"] == null ? e.OldValues["CJCHAVE"].ToString() : "";
            CJFLOBRG = e.NewValues["CJFLOBRG"] != null ? e.NewValues["CJFLOBRG"].ToString() : e.OldValues["CJFLOBRG"] == null ? e.OldValues["CJFLOBRG"].ToString() : "";
            CJTPCAID = e.NewValues["CJTPCAID"] != null ? e.NewValues["CJTPCAID"].ToString() : e.OldValues["CJTPCAID"] == null ? e.OldValues["CJTPCAID"].ToString() : "";
            CJFLAQUI = e.NewValues["CJFLAQUI"] != null ? e.NewValues["CJFLAQUI"].ToString() : e.OldValues["CJFLAQUI"] == null ? e.OldValues["CJFLAQUI"].ToString() : "";
            string CHIDCODI = hfDropComp.Value;
            string sqlUpdate = "update CJCLPROP set" +
                " CJTPIDTP=@CJTPIDTP, " +
                " CJDSDECR='@CJDSDECR', " +
                " CJTPCTTX='@CJTPCTTX', " +
                " CJORORDE='@CJORORDE', " +
                " CJDSEXPR='@CJDSEXPR', " +
                " CJDSMENS='@CJDSMENS', " +
                " CJFILTRO='@CJFILTRO', " +
                " CJCHAVE='@CJCHAVE', " +
                " CJFLOBRG='@CJFLOBRG', " +
                " CJTPCAID='@CJTPCAID', " +
                " CJFLAQUI='@CJFLAQUI' " +
                " where CJIDCODI=@CJIDCODI and CHIDCODI=@CHIDCODI";
            sqlUpdate = sqlUpdate.Replace("@CJTPIDTP", CJTPIDTP);
            sqlUpdate = sqlUpdate.Replace("@CJIDCODI", CJIDCODI);
            sqlUpdate = sqlUpdate.Replace("@CJDSDECR", CJDSDECR);
            sqlUpdate = sqlUpdate.Replace("@CJTPCTTX", CJTPCTTX.Replace("'", "''"));
            sqlUpdate = sqlUpdate.Replace("@CJORORDE", CJORORDE);
            sqlUpdate = sqlUpdate.Replace("@CJDSEXPR", CJDSEXPR);
            sqlUpdate = sqlUpdate.Replace("@CJDSMENS", CJDSMENS);
            sqlUpdate = sqlUpdate.Replace("@CJFILTRO", CJFILTRO);
            sqlUpdate = sqlUpdate.Replace("@CJCHAVE", CJCHAVE);
            sqlUpdate = sqlUpdate.Replace("@CJFLOBRG", CJFLOBRG);
            sqlUpdate = sqlUpdate.Replace("@CJTPCAID", CJTPCAID);
            sqlUpdate = sqlUpdate.Replace("@CJFLAQUI", CJFLAQUI);
            sqlUpdate = sqlUpdate.Replace("@CHIDCODI", CHIDCODI);
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
            {
                gridPropNaoVinculadas.DataBind();
                gridPropNaoVinculadas.CancelEdit();
                e.Cancel = true;
            }
        }
        protected void gridPropVinculadas_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            string CJTPIDTP, CJIDCODI, CJDSDECR, CJTPCTTX, CJORORDE, CJDSEXPR, CJDSMENS, CJFILTRO, CJCHAVE, CJFLOBRG, CJTPCAID, CJFLAQUI;
            CJTPIDTP = e.NewValues["CJTPIDTP"] != null ? e.NewValues["CJTPIDTP"].ToString() : e.OldValues["CJTPIDTP"] == null ? e.OldValues["CJTPIDTP"].ToString() : "";
            CJIDCODI = e.Keys["CJIDCODI"].ToString();
            CJDSDECR = e.NewValues["CJDSDECR"] != null ? e.NewValues["CJDSDECR"].ToString() : e.OldValues["CJDSDECR"] == null ? e.OldValues["CJDSDECR"].ToString() : "";
            CJTPCTTX = e.NewValues["CJTPCTTX"] != null ? e.NewValues["CJTPCTTX"].ToString() : e.OldValues["CJTPCTTX"] == null ? e.OldValues["CJTPCTTX"].ToString() : "";
            CJORORDE = e.NewValues["CJORORDE"] != null ? e.NewValues["CJORORDE"].ToString() : e.OldValues["CJORORDE"] == null ? e.OldValues["CJORORDE"].ToString() : "";
            CJDSEXPR = e.NewValues["CJDSEXPR"] != null ? e.NewValues["CJDSEXPR"].ToString() : e.OldValues["CJDSEXPR"] == null ? e.OldValues["CJDSEXPR"].ToString() : "";
            CJDSMENS = e.NewValues["CJDSMENS"] != null ? e.NewValues["CJDSMENS"].ToString() : e.OldValues["CJDSMENS"] == null ? e.OldValues["CJDSMENS"].ToString() : "";
            CJFILTRO = e.NewValues["CJFILTRO"] != null ? e.NewValues["CJFILTRO"].ToString() : e.OldValues["CJFILTRO"] == null ? e.OldValues["CJFILTRO"].ToString() : "";
            CJCHAVE = e.NewValues["CJCHAVE"] != null ? e.NewValues["CJCHAVE"].ToString() : e.OldValues["CJCHAVE"] == null ? e.OldValues["CJCHAVE"].ToString() : "";
            CJFLOBRG = e.NewValues["CJFLOBRG"] != null ? e.NewValues["CJFLOBRG"].ToString() : e.OldValues["CJFLOBRG"] == null ? e.OldValues["CJFLOBRG"].ToString() : "";
            CJTPCAID = e.NewValues["CJTPCAID"] != null ? e.NewValues["CJTPCAID"].ToString() : e.OldValues["CJTPCAID"] == null ? e.OldValues["CJTPCAID"].ToString() : "";
            CJFLAQUI = e.NewValues["CJFLAQUI"] != null ? e.NewValues["CJFLAQUI"].ToString() : e.OldValues["CJFLAQUI"] == null ? e.OldValues["CJFLAQUI"].ToString() : "";
            string CHIDCODI = hfDropComp.Value;
            string sqlUpdate = "update CJCLPROP set" +
                " CJTPIDTP=@CJTPIDTP, " +
                " CJDSDECR='@CJDSDECR', " +
                " CJTPCTTX='@CJTPCTTX', " +
                " CJORORDE='@CJORORDE', " +
                " CJDSEXPR='@CJDSEXPR', " +
                " CJDSMENS='@CJDSMENS', " +
                " CJFILTRO='@CJFILTRO', " +
                " CJCHAVE='@CJCHAVE', " +
                " CJFLOBRG='@CJFLOBRG', " +
                " CJTPCAID='@CJTPCAID', " +
                " CJFLAQUI='@CJFLAQUI' " +
                " where CJIDCODI=@CJIDCODI and CHIDCODI=@CHIDCODI";
            sqlUpdate = sqlUpdate.Replace("@CJTPIDTP", CJTPIDTP);
            sqlUpdate = sqlUpdate.Replace("@CJIDCODI", CJIDCODI);
            sqlUpdate = sqlUpdate.Replace("@CJDSDECR", CJDSDECR);
            sqlUpdate = sqlUpdate.Replace("@CJTPCTTX", CJTPCTTX.Replace("'", "''"));
            sqlUpdate = sqlUpdate.Replace("@CJORORDE", CJORORDE);
            sqlUpdate = sqlUpdate.Replace("@CJDSEXPR", CJDSEXPR);
            sqlUpdate = sqlUpdate.Replace("@CJDSMENS", CJDSMENS);
            sqlUpdate = sqlUpdate.Replace("@CJFILTRO", CJFILTRO);
            sqlUpdate = sqlUpdate.Replace("@CJCHAVE", CJCHAVE);
            sqlUpdate = sqlUpdate.Replace("@CJFLOBRG", CJFLOBRG);
            sqlUpdate = sqlUpdate.Replace("@CJTPCAID", CJTPCAID);
            sqlUpdate = sqlUpdate.Replace("@CJFLAQUI", CJFLAQUI);
            sqlUpdate = sqlUpdate.Replace("@CHIDCODI", CHIDCODI);
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
            {
                gridPropVinculadas.DataBind();
                gridPropVinculadas.CancelEdit();
                e.Cancel = true;
            }
        }
        protected void gridProduto_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            string sqlUpdate = "update PRPRODUT set prprocod='@prprodes', prprodes='@prprodes', chidcodi=@chidcodi, ieidinec=@ieidinec, prtpidop=@prtpidop, cmtpidcm=@cmtpidcm, origem=@origem, capital=@capital, usgaap=@usgaap, impostos=@impostos, reajustes=@reajustes, carencia=@carencia, fluxo=@fluxo, calculo=@calculo, depreciacao=@depreciacao, remensuracao=@remensuracao,prmonint=@prmonint where prprodid=@prprodid";
            string prprodid, prprodes, chidcodi, ieidinec, prtpidop, cmtpidcm, origem, capital, usgaap, impostos, reajustes, carencia, fluxo, calculo, depreciacao, remensuracao, prmonint;
            prprodid = e.Keys["prprodid"].ToString();
            prprodes = e.NewValues["prprodes"] == null ? e.OldValues["prprodes"].ToString() : e.NewValues["prprodes"].ToString();
            chidcodi = e.NewValues["chidcodi"] == null ? e.OldValues["chidcodi"].ToString() : e.NewValues["chidcodi"].ToString();
            ieidinec = e.NewValues["ieidinec"] == null ? e.OldValues["ieidinec"].ToString() : e.NewValues["ieidinec"].ToString();
            prtpidop = e.NewValues["id"] == null ? e.OldValues["id"].ToString().Split('#')[0] : e.NewValues["id"].ToString().Split('#')[0];
            cmtpidcm = e.NewValues["id"] == null ? e.OldValues["id"].ToString().Split('#')[1] : e.NewValues["id"].ToString().Split('#')[1];
            origem = e.NewValues["origem"] == null ? e.OldValues["origem"].ToString() : e.NewValues["origem"].ToString();
            capital = e.NewValues["capital"] == null ? e.OldValues["capital"].ToString() : e.NewValues["capital"].ToString();
            usgaap = e.NewValues["usgaap"] == null ? e.OldValues["usgaap"].ToString() : e.NewValues["usgaap"].ToString();
            impostos = e.NewValues["impostos"] == null ? e.OldValues["impostos"].ToString() : e.NewValues["impostos"].ToString();
            reajustes = e.NewValues["reajustes"] == null ? e.OldValues["reajustes"].ToString() : e.NewValues["reajustes"].ToString();
            carencia = e.NewValues["carencia"] == null ? e.OldValues["carencia"].ToString() : e.NewValues["carencia"].ToString();
            fluxo = e.NewValues["fluxo"] == null ? e.OldValues["fluxo"].ToString() : e.NewValues["fluxo"].ToString();
            calculo = e.NewValues["calculo"] == null ? e.OldValues["calculo"].ToString() : e.NewValues["calculo"].ToString();
            depreciacao = e.NewValues["depreciacao"] == null ? e.OldValues["depreciacao"].ToString() : e.NewValues["depreciacao"].ToString();
            remensuracao = e.NewValues["remensuracao"] == null ? e.OldValues["remensuracao"].ToString() : e.NewValues["remensuracao"].ToString();
            prmonint = e.NewValues["prmonint"] == null ? e.OldValues["prmonint"].ToString() : e.NewValues["prmonint"].ToString();
            sqlUpdate = sqlUpdate.Replace("@prprodid", prprodid);
            sqlUpdate = sqlUpdate.Replace("@prprodes", prprodes);
            sqlUpdate = sqlUpdate.Replace("@chidcodi", chidcodi);
            sqlUpdate = sqlUpdate.Replace("@ieidinec", ieidinec);
            sqlUpdate = sqlUpdate.Replace("@prtpidop", prtpidop);
            sqlUpdate = sqlUpdate.Replace("@cmtpidcm", cmtpidcm);
            sqlUpdate = sqlUpdate.Replace("@origem", origem);
            sqlUpdate = sqlUpdate.Replace("@capital", capital);
            sqlUpdate = sqlUpdate.Replace("@usgaap", usgaap);
            sqlUpdate = sqlUpdate.Replace("@impostos", impostos);
            sqlUpdate = sqlUpdate.Replace("@reajustes", reajustes);
            sqlUpdate = sqlUpdate.Replace("@carencia", carencia);
            sqlUpdate = sqlUpdate.Replace("@fluxo", fluxo);
            sqlUpdate = sqlUpdate.Replace("@calculo", calculo);
            sqlUpdate = sqlUpdate.Replace("@depreciacao", depreciacao);
            sqlUpdate = sqlUpdate.Replace("@remensuracao", remensuracao);
            sqlUpdate = sqlUpdate.Replace("@prmonint", prmonint);
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
            {
                gridProduto.DataBind();
                gridProduto.CancelEdit();
                e.Cancel = true;
            }
            else
            {
                MsgException(exec, 1);
            }
        }
        protected void gridProduto_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            string sqlInsert = "INSERT INTO PRPRODUT (prprodid,prprocod,ptsmidsm,ptspidsp,prprodes,chidcodi,ptemidem,ieidinec,prdsxobs,tvidplvb,pventsai,pvnateza,pvtporig,pvedorig,pvfmalim,pvfreque,ckidcver,pvveidve,pvveidvi,prnminte,acidarea,ptdpiddp,prtpidop,cmtpidcm,pvensaid,pvnateid,pvfreqid,pvtporid,tvidestr,pridinec,prvllote,prunlote,prftmoed,pgidcopg,prcdbols,prinitem,prinfccb,coidcomm,origem,capital,usgaap,impostos,reajustes,carencia,fluxo,calculo,depreciacao,remensuracao,prmonint) " +
                    "VALUES(@prprodid, '@prprodes', 1, 1, '@prprodes', @chidcodi, 1, @ieidinec, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, @prtpidop, @cmtpidcm, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 2, 2, NULL, @origem, @capital, @usgaap, @impostos, @reajustes, @carencia, @fluxo, @calculo, @depreciacao, @remensuracao,@prmonint)";
            string prprodid, prprodes, chidcodi, ieidinec, prtpidop, cmtpidcm, origem, capital, usgaap, impostos, reajustes, carencia, fluxo, calculo, depreciacao, remensuracao, prmonint;
            prprodid = DataBase.Consultas.Consulta(str_conn, "select max(prprodid)+1 from PRPRODUT", 1)[0];
            prprodes = e.NewValues["prprodes"].ToString();
            chidcodi = e.NewValues["chidcodi"].ToString();
            ieidinec = e.NewValues["ieidinec"].ToString();
            prtpidop = e.NewValues["id"].ToString().Split('#')[0];
            cmtpidcm = e.NewValues["id"].ToString().Split('#')[1];
            origem = e.NewValues["origem"].ToString();
            capital = e.NewValues["capital"].ToString();
            usgaap = e.NewValues["usgaap"].ToString();
            impostos = e.NewValues["impostos"].ToString();
            reajustes = e.NewValues["reajustes"].ToString();
            carencia = e.NewValues["carencia"].ToString();
            fluxo = e.NewValues["fluxo"].ToString();
            calculo = e.NewValues["calculo"].ToString();
            depreciacao = e.NewValues["depreciacao"].ToString();
            remensuracao = e.NewValues["remensuracao"].ToString();
            prmonint = e.NewValues["prmonint"].ToString();
            sqlInsert = sqlInsert.Replace("@prprodid", prprodid);
            sqlInsert = sqlInsert.Replace("@prprodes", prprodes);
            sqlInsert = sqlInsert.Replace("@chidcodi", chidcodi);
            sqlInsert = sqlInsert.Replace("@ieidinec", ieidinec);
            sqlInsert = sqlInsert.Replace("@prtpidop", prtpidop);
            sqlInsert = sqlInsert.Replace("@cmtpidcm", cmtpidcm);
            sqlInsert = sqlInsert.Replace("@origem", origem);
            sqlInsert = sqlInsert.Replace("@capital", capital);
            sqlInsert = sqlInsert.Replace("@usgaap", usgaap);
            sqlInsert = sqlInsert.Replace("@impostos", impostos);
            sqlInsert = sqlInsert.Replace("@reajustes", reajustes);
            sqlInsert = sqlInsert.Replace("@carencia", carencia);
            sqlInsert = sqlInsert.Replace("@fluxo", fluxo);
            sqlInsert = sqlInsert.Replace("@calculo", calculo);
            sqlInsert = sqlInsert.Replace("@depreciacao", depreciacao);
            sqlInsert = sqlInsert.Replace("@remensuracao", remensuracao);
            sqlInsert = sqlInsert.Replace("@prmonint", prmonint);
            string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            if (exec == "OK")
            {
                gridProduto.DataBind();
                gridProduto.CancelEdit();
                e.Cancel = true;
            }
            else
            {
                MsgException(exec, 1);
            }
        }
        protected void gridProduto_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string sqlValida = "select count(*) from opcontra where PRPRODID=" + e.Keys["prprodid"].ToString();
            bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) == 0;
            if (valida)
            {
                string sqlDelete = "delete from PRPRODUT where PRPRODID=" + e.Keys["prprodid"].ToString();
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
                if (exec == "OK")
                {
                    gridProduto.DataBind();
                    gridProduto.CancelEdit();
                    e.Cancel = true;
                }
                else
                {
                    MsgException(exec, 1);
                }
            }
            else
            {
                MsgException("Produto com Operação associada.", 1);
            }
        }
        protected void dropClasse_SelectedIndexChanged(object sender, EventArgs e)
        {
            hfCMTPIDCM.Value = dropClasse.Value.ToString();
            dropClasseComp.DataBind();
        }
        protected void gridEventos_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            string CMIDCODI = e.Keys[0].ToString();
            string CHTPIDEV = e.NewValues["CHTPIDEV"] == null ? e.OldValues["CHTPIDEV"].ToString() : e.NewValues["CHTPIDEV"].ToString();
            string CHTPDSEV = e.NewValues["CHTPDSEV"] == null ? e.OldValues["CHTPDSEV"].ToString() : e.NewValues["CHTPDSEV"].ToString();
            string PAIDPAIS = e.NewValues["PAIDPAIS"] == null ? e.OldValues["PAIDPAIS"].ToString() : e.NewValues["PAIDPAIS"].ToString();
            string sqlUpdate = "UPDATE CMTPEVEN SET CHTPIDEV=" + CHTPIDEV + ",CHTPDSEV='" + CHTPDSEV + "',PAIDPAIS=" + PAIDPAIS + " WHERE CMIDCODI=" + CMIDCODI + " and CHTPIDEV=" + e.OldValues["CHTPIDEV"].ToString() + "";
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
            {
                gridEventos.DataBind();
                gridEventos.CancelEdit();
                e.Cancel = true;
            }
            else
            {
                MsgException(exec, 1);
            }
        }
        protected void gridEventos_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            string CMIDCODI = dropClasseComp.Value.ToString();
            string CHTPIDEV = e.NewValues["CHTPIDEV"] == null ? DataBase.Consultas.Consulta(str_conn, "select max(CHTPIDEV)+1 from CMTPEVEN", 1)[0] : e.NewValues["CHTPIDEV"].ToString();
            string CHTPDSEV = e.NewValues["CHTPDSEV"].ToString();
            string PAIDPAIS = e.NewValues["PAIDPAIS"].ToString();
            string sqlInsert = "INSERT INTO CMTPEVEN (CMIDCODI,CHTPIDEV,CHTPDSEV,PAIDPAIS) VALUES (" + CMIDCODI + "," + CHTPIDEV + ",'" + CHTPDSEV + "'," + PAIDPAIS + ")";
            string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            if (exec == "OK")
            {
                gridEventos.DataBind();
                gridEventos.CancelEdit();
                e.Cancel = true;
            }
            else
            {
                MsgException(exec, 1);
            }
        }
        protected void gridEventos_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string CMIDCODI = e.Keys[0].ToString();
            string CHTPIDEV = e.Keys[1].ToString();
            string PAIDPAIS = e.Keys[2].ToString();
            string sqlDelete = "delete from CMTPEVEN where CMIDCODI=" + CMIDCODI + " and CHTPIDEV=" + CHTPIDEV + " and PAIDPAIS=" + PAIDPAIS;
            string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
            if (exec == "OK")
            {
                gridEventos.DataBind();
                gridEventos.CancelEdit();
                e.Cancel = true;
            }
            else
            {
                MsgException(exec, 1);
            }
        }
        protected void gridEventos_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfCMIDCODI.Value))
            {
                gridEventos.Enabled = false;
            }
            else
            {
                gridEventos.Enabled = true;
            }
        }
        protected void gridComponente_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string sqlValida = "select COUNT(*) from PRPRODUT P, OPCONTRA O where P.prprodid=O.PRPRODID AND chidcodi=" + e.Keys["chidcodi"].ToString();
            bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) == 0;
            if (valida)
            {
                string sqlDelete = "delete from CHCOMPOT where chidcodi=" + e.Keys["chidcodi"].ToString();
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
                if (exec == "OK")
                {
                    gridComponente.DataBind();
                    gridComponente.CancelEdit();
                    e.Cancel = true;
                }
                else
                {
                    MsgException(exec, 1);
                }
            }
            else
            {
                MsgException("Componente com Operação associada.", 1);
            }
        }
        protected void gridComponente_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            string sqlInsert = "INSERT INTO CHCOMPOT(chdsdecr,chdsobsr,cmidcodi,chidcodi,chflsimp) " +
"VALUES('@chdsdecr', '@chdsobsr', @cmidcodi, @chidcodi, @chflsimp)";
            string chdsdecr, chdsobsr, cmidcodi, chidcodi, chflsimp;
            chdsdecr = e.NewValues["chdsdecr"].ToString();
            chdsobsr = e.NewValues["chdsdecr"].ToString();
            cmidcodi = e.NewValues["cmidcodi"].ToString();
            chidcodi = e.NewValues["chidcodi"].ToString();
            chflsimp = e.NewValues["chflsimp"].ToString();
            sqlInsert = sqlInsert.Replace("@chdsdecr", chdsdecr);
            sqlInsert = sqlInsert.Replace("@chdsobsr", chdsobsr);
            sqlInsert = sqlInsert.Replace("@cmidcodi", cmidcodi);
            sqlInsert = sqlInsert.Replace("@chidcodi", chidcodi);
            sqlInsert = sqlInsert.Replace("@chflsimp", chflsimp);
            string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            if (exec == "OK")
            {
                gridComponente.DataBind();
                gridComponente.CancelEdit();
                e.Cancel = true;
            }
            else
            {
                MsgException(exec, 1);
            }
        }
        protected void gridComponente_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            string sqlValida = "select COUNT(*) from PRPRODUT P, OPCONTRA O where P.prprodid=O.PRPRODID AND chidcodi=" + e.Keys["chidcodi"].ToString();
            bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) == 0;
            if (valida)
            {
                string sqlUpdate = "UPDATE CHCOMPOT SET chdsdecr='@chdsdecr',chdsobsr='@chdsdecr',cmidcodi=@cmidcodi,chflsimp=@chflsimp,chidcodi=@chidcodi WHERE chidcodi=" + e.Keys["chidcodi"].ToString();
                string chdsdecr, chdsobsr, cmidcodi, chidcodi, chflsimp;
                chdsdecr = e.NewValues["chdsdecr"] == null ? e.OldValues["chdsdecr"].ToString() : e.NewValues["chdsdecr"].ToString();
                chdsobsr = e.NewValues["chdsdecr"] == null ? e.OldValues["chdsdecr"].ToString() : e.NewValues["chdsdecr"].ToString();
                cmidcodi = e.NewValues["cmidcodi"] == null ? e.OldValues["cmidcodi"].ToString() : e.NewValues["cmidcodi"].ToString();
                chidcodi = e.NewValues["chidcodi"] == null ? e.OldValues["chidcodi"].ToString() : e.NewValues["chidcodi"].ToString();
                chflsimp = e.NewValues["chflsimp"] == null ? e.OldValues["chflsimp"].ToString() : e.NewValues["chflsimp"].ToString();
                sqlUpdate = sqlUpdate.Replace("@chdsdecr", chdsdecr);
                sqlUpdate = sqlUpdate.Replace("@chdsobsr", chdsobsr);
                sqlUpdate = sqlUpdate.Replace("@cmidcodi", cmidcodi);
                sqlUpdate = sqlUpdate.Replace("@chidcodi", chidcodi);
                sqlUpdate = sqlUpdate.Replace("@chflsimp", chflsimp);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                if (exec == "OK")
                {
                    gridComponente.DataBind();
                    gridComponente.CancelEdit();
                    e.Cancel = true;
                }
                else
                {
                    MsgException(exec, 1);
                }
            }
            else
            {
                MsgException("Componente com Operação associada.", 1);
            }
        }
        protected void gridPropNaoVinculadas_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            string CJTPIDTP, CJIDCODI, CJDSDECR, CJTPCTTX, CJORORDE, CJDSEXPR, CJDSMENS, CJFILTRO, CJCHAVE, CJFLOBRG, CJTPCAID, CJFLAQUI;
            CJTPIDTP = e.NewValues["CJTPIDTP"] == null ? "NULL" : e.NewValues["CJTPIDTP"].ToString();
            CJIDCODI = e.NewValues["CJIDCODI"] == null ? DataBase.Consultas.Consulta(str_conn, "select max(CJIDCODI)+1 from CJCLPROP", 1)[0] : e.NewValues["CJIDCODI"].ToString();
            CJDSDECR = e.NewValues["CJDSDECR"] == null ? "NULL" : e.NewValues["CJDSDECR"].ToString();
            CJTPCTTX = e.NewValues["CJTPCTTX"] == null ? "NULL" : e.NewValues["CJTPCTTX"].ToString();
            CJORORDE = e.NewValues["CJORORDE"] == null ? "NULL" : e.NewValues["CJORORDE"].ToString();
            CJDSEXPR = e.NewValues["CJDSEXPR"] == null ? "NULL" : e.NewValues["CJDSEXPR"].ToString();
            CJDSMENS = e.NewValues["CJDSMENS"] == null ? "NULL" : e.NewValues["CJDSMENS"].ToString();
            CJFILTRO = e.NewValues["CJFILTRO"] == null ? "NULL" : e.NewValues["CJFILTRO"].ToString();
            CJCHAVE = e.NewValues["CJCHAVE"] == null ? "NULL" : e.NewValues["CJCHAVE"].ToString();
            CJFLOBRG = e.NewValues["CJFLOBRG"] == null ? "NULL" : e.NewValues["CJFLOBRG"].ToString();
            CJTPCAID = e.NewValues["CJTPCAID"] == null ? "NULL" : e.NewValues["CJTPCAID"].ToString();
            CJFLAQUI = e.NewValues["CJFLAQUI"] == null ? "NULL" : e.NewValues["CJFLAQUI"].ToString();
            string CHIDCODI = hfDropComp.Value;
            string sqlUpdate = "insert into  CJCLPROP (CJTPIDTP, CJIDCODI, CJDSDECR, CJTPCTTX, CJORORDE, CJDSEXPR, CJDSMENS, CJFILTRO, CJCHAVE, CJFLOBRG, CJTPCAID, CJFLAQUI,CHIDCODI)" +
                " values (@CJTPIDTP, @CJIDCODI, '@CJDSDECR', '@CJTPCTTX', @CJORORDE, '@CJDSEXPR', '@CJDSMENS', '@CJFILTRO', '@CJCHAVE', '@CJFLOBRG', '@CJTPCAID', '@CJFLAQUI',@CHIDCODI)";
            sqlUpdate = sqlUpdate.Replace("@CJTPIDTP", CJTPIDTP);
            sqlUpdate = sqlUpdate.Replace("@CJIDCODI", CJIDCODI);
            sqlUpdate = sqlUpdate.Replace("@CJDSDECR", CJDSDECR);
            sqlUpdate = sqlUpdate.Replace("@CJTPCTTX", CJTPCTTX.Replace("'", "''"));
            sqlUpdate = sqlUpdate.Replace("@CJORORDE", CJORORDE);
            sqlUpdate = sqlUpdate.Replace("@CJDSEXPR", CJDSEXPR);
            sqlUpdate = sqlUpdate.Replace("@CJDSMENS", CJDSMENS);
            sqlUpdate = sqlUpdate.Replace("@CJFILTRO", CJFILTRO);
            sqlUpdate = sqlUpdate.Replace("@CJCHAVE", CJCHAVE);
            sqlUpdate = sqlUpdate.Replace("@CJFLOBRG", CJFLOBRG);
            sqlUpdate = sqlUpdate.Replace("@CJTPCAID", CJTPCAID);
            sqlUpdate = sqlUpdate.Replace("@CJFLAQUI", CJFLAQUI);
            sqlUpdate = sqlUpdate.Replace("@CHIDCODI", CHIDCODI);
            string exec = DataBase.Consultas.InsertInto(str_conn, sqlUpdate);
            if (exec == "OK")
            {
                gridPropNaoVinculadas.DataBind();
                gridPropNaoVinculadas.CancelEdit();
                e.Cancel = true;

            }
        }
        protected void gridPropNaoVinculadas_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "CJIDCODI")
            {
                if (gridPropNaoVinculadas.IsNewRowEditing)
                    e.Editor.ReadOnly = false;
            }
        }
        protected void gridPropNaoVinculadas_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            if (e.IsNewRow)
            {
                if (e.NewValues["CJIDCODI"] != null)
                {
                    string sqlCheck = "select count(*) from CJCLPROP C where CHIDCODI=" + hfDropComp.Value + " AND CJIDCODI=" + e.NewValues["CJIDCODI"].ToString();
                    bool duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlCheck, 1)[0]) > 0;
                    if (duplicado)
                    {
                        string nextID = DataBase.Consultas.Consulta(str_conn, "select max(CJIDCODI)+1 from CJCLPROP C where CHIDCODI=" + hfDropComp.Value, 1)[0];
                        e.RowError = "CJIDCODI " + e.NewValues["CJIDCODI"].ToString() + " já existente para esse Componente, próximo ID válido para uso é : " + nextID + " .";
                    }

                }
            }
        }

        protected void gridMercado_Load(object sender, EventArgs e)
        {
            gridMercado.SettingsDataSecurity.AllowDelete = perfil != "3";
            gridMercado.SettingsDataSecurity.AllowEdit = perfil != "3";
            gridMercado.SettingsDataSecurity.AllowInsert = perfil != "3";
        }

        protected void gridMercado_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string sql = "DELETE FROM VIEMPIND WHERE VIIDINDE=@VIIDINDE";
            sql = sql.Replace("@VIIDINDE", e.Keys["VIIDINDE"].ToString());
            string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
            if (exec == "OK")
            {
                gridMercado.DataBind();
                gridMercado.CancelEdit();
                e.Cancel = true;
            }
            else
                MsgException(exec, 2);
        }

        protected void gridMercado_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {

            string sql = "INSERT INTO VIEMPIND (TVIDESTR,IEIDINEC) VALUES (@TVIDESTR,@IEIDINEC)";
            sql = sql.Replace("@TVIDESTR", e.NewValues["TVIDESTR"].ToString());
            sql = sql.Replace("@IEIDINEC", e.NewValues["IEIDINEC"].ToString());
            string exec = DataBase.Consultas.InsertInto(str_conn, sql);
            if (exec == "OK")
            {
                gridMercado.DataBind();
                gridMercado.CancelEdit();
                e.Cancel = true;
            }
            else
                MsgException(exec, 2);

        }

        protected void gridMercado_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            string TVIDESTR, IEIDINEC;
            TVIDESTR = e.NewValues["TVIDESTR"] == null ? e.OldValues["TVIDESTR"].ToString() : e.NewValues["TVIDESTR"].ToString();
            IEIDINEC = e.NewValues["IEIDINEC"] == null ? e.OldValues["IEIDINEC"].ToString() : e.NewValues["IEIDINEC"].ToString();
            string sql = "UPDATE VIEMPIND SET TVIDESTR = @TVIDESTR, IEIDINEC = @IEIDINEC WHERE VIIDINDE=@VIIDINDE";
            sql = sql.Replace("@TVIDESTR", TVIDESTR);
            sql = sql.Replace("@IEIDINEC", IEIDINEC);
            sql = sql.Replace("@VIIDINDE", e.Keys["VIIDINDE"].ToString());
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sql);
            if (exec == "OK")
            {
                gridMercado.DataBind();
                gridMercado.CancelEdit();
                e.Cancel = true;
            }
            else
                MsgException(exec, 2);
        }

        protected void gridUsuarios_CustomErrorText(object sender, ASPxGridViewCustomErrorTextEventArgs e)
        {
            e.ErrorText = e.Exception.Message;
        }
    }
}