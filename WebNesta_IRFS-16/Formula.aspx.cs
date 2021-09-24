using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Formula : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string perfil;
        public static bool AcessoInternet;
        public static CultureInfo culture;
        public static CultureInfo cultureBR;
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
            culture = new CultureInfo(lang);
            cultureBR = new CultureInfo("pt-BR");
            if (!IsPostBack)
            {
                HttpCookie myPerfil = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myPerfil == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myPerfil.Value);
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("TVIDESTR")];
                if (myCookie != null)
                {
                    hfTVIDESTRPAI.Value = myCookie.Value;
                }
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
                gridFormula.SettingsDataSecurity.AllowInsert = false;
            }
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = (DevExpress.Web.ASPxTreeList.ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList") as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            treeList.DataBind();
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
            btnInserir.Enabled= perfil != "3";
        }
        protected void MsgException(string msg, int exc, string curr)
        {
            if (exc == 1)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = hfMsgException.Value + msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 0)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = hfMsgSuccess.Value;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 4)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = hfMsgSuccess.Value;
                (this.Master.FindControl("btnOK") as Button).Visible = false;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = hfMsgSuccess.Value;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "2";
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 3)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = hfMsgSuccess.Value;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void dropFormulas_SelectedIndexChanged(object sender, EventArgs e)
        {
            hfDropForm.Value = dropFormulas.Value.ToString();
            var result = DataBase.Consultas.Consulta(str_conn, "select CINMTABE,CITPBASE,CITPFORM,CIINFLAG from CICIENTI where CIIDCODI=" + dropFormulas.Value,4);
            txtNomeFor.Text = result[0];
            dropBase.Value = result[1];
            txtFormula.Text = result[2];
            hfFormula.Value = dropFormulas.Value.ToString();
            txtDtBase.Enabled = true;
            txtDtEvento.Enabled = true;
            txtDtPag.Enabled = true;
            btnExecutar.Enabled = true;
            btnCalcular.Enabled = true;            
            if (result[3] == "0")
            {
                btnInserir.Enabled = false;
                btnAlterar.Enabled = perfil == "1";
                btnExcluir.Enabled = perfil == "1";
            }
            else
            {
                btnInserir.Enabled = perfil != "3";
                btnAlterar.Enabled = perfil != "3";
                btnExcluir.Enabled = perfil != "3";
            }
            gridFormula.SettingsDataSecurity.AllowInsert = false;
            gridFormula.SettingsDataSecurity.AllowEdit = false;
            gridFormula.SettingsDataSecurity.AllowDelete = false;
        }
        protected void btnExecutar_Click(object sender, EventArgs e)
        {
            string formula = DataBase.Consultas.Consulta(str_conn, "SELECT CITPFORM FROM CICIENTI WHERE CIIDCODI=" + dropFormulas.Value.ToString() + "", 1)[0];
            string sBase, sEvento, sPagamento;
            DataBase.StringToFormula stf = new DataBase.StringToFormula();
            string codDT = lang == "en-US" ? "101" : "103";


            DateTime dtBase;
            dtBase = Convert.ToDateTime(txtDtBase.Text == string.Empty ? "01/01/1970" : txtDtBase.Text, culture);
            string diasB = DataBase.Consultas.Consulta(str_conn, "select CINRDIAS from CFFORMUL where CITPDESL='B' and CIIDCODI=" + dropFormulas.Value.ToString() + "", 1)[0];
            if (diasB == "-30" || diasB == "-31")
                dtBase = dtBase.AddMonths(-1);
            else if (diasB == "30" || diasB == "31")
                dtBase = dtBase.AddMonths(1);
            else
                dtBase = dtBase.AddDays(Convert.ToInt32(diasB));
            //var _base = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,CV.cvvlcoid,CF.CIPRPART from CFFORMUL CF,CVCOTIEC CV where CV.cvdtcoie=(CONVERT(datetime,'" + dtBase.ToShortDateString() + "'," + codDT + ")) AND CV.ieidinec=CF.IEIDINEC AND CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='B'", 3);
            //DataTable dataTableBase = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,CV.cvvlcoid,CF.CIPRPART from CFFORMUL CF,CVCOTIEC CV where CV.cvdtcoie=(CONVERT(datetime,'" + dtBase.ToShortDateString() + "'," + codDT + ")) AND CV.ieidinec=CF.IEIDINEC AND CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='B'");
            DataTable dataTableBase = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,dbo.FUNC_BUSCA_COTA (cf.ieidinec,CONVERT(datetime,'"+ dtBase.ToString("dd/MM/yyyy") + "',103)),CF.CIPRPART from CFFORMUL CF where CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='B'");
            string _base = string.Empty;
            foreach (DataRow rowBase in dataTableBase.Rows)
            {
                if (txtDtBase.Text != string.Empty)
                {
                    if (rowBase[0].ToString() != null)
                    {
                        _base = stf.Eval(rowBase[1].ToString() + "*(" + rowBase[2].ToString() + "/100)").ToString();
                        if (formula.Contains("from"))
                            formula = formula.Replace(rowBase[0].ToString(), _base.Replace(",","."));
                        else
                            formula = formula.Replace(rowBase[0].ToString(), _base);
                    }
                    else
                    {
                        MsgException("Cotação não encontrada para a data base: " + dtBase.ToShortDateString(), 1, "");
                        return;
                    }
                }
            }

            DateTime dtEvento;
            dtEvento = Convert.ToDateTime(txtDtEvento.Text == string.Empty ? "01/01/1970" : txtDtEvento.Text, culture);
            string diasE = DataBase.Consultas.Consulta(str_conn, "select CINRDIAS from CFFORMUL where CITPDESL='E' and CIIDCODI=" + dropFormulas.Value.ToString() + "", 1)[0];
            if (diasE == "-30" || diasE == "-31")
                dtEvento = dtEvento.AddMonths(-1);
            else if (diasE == "30" || diasE == "31")
                dtEvento = dtEvento.AddMonths(1);
            else
                dtEvento = dtEvento.AddDays(Convert.ToInt32(diasE));
            //var _evento = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,CV.cvvlcoid,CF.CIPRPART from CFFORMUL CF,CVCOTIEC CV where CV.cvdtcoie=(CONVERT(datetime,'" + dtEvento.ToShortDateString() + "'," + codDT + ")) AND CV.ieidinec=CF.IEIDINEC AND CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='E'", 3);
            //DataTable dataTableEvento = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,CV.cvvlcoid,CF.CIPRPART from CFFORMUL CF,CVCOTIEC CV where CV.cvdtcoie=(CONVERT(datetime,'" + dtEvento.ToShortDateString() + "'," + codDT + ")) AND CV.ieidinec=CF.IEIDINEC AND CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='E'");
            DataTable dataTableEvento = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,dbo.FUNC_BUSCA_COTA (cf.ieidinec,CONVERT(datetime,'"+ dtEvento.ToString("dd/MM/yyyy") + "',103)),CF.CIPRPART from CFFORMUL CF where CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='E'");
            string _evento = string.Empty;
            foreach (DataRow rowEvento in dataTableEvento.Rows)
            {
                if (txtDtEvento.Text != string.Empty)
                {
                    if (rowEvento[0].ToString() != null)
                    {
                        _evento = stf.Eval(rowEvento[1].ToString() + "*(" + rowEvento[2].ToString() + "/100)").ToString();
                        if (formula.Contains("from"))
                            formula = formula.Replace(rowEvento[0].ToString(), _evento.Replace(",", "."));
                        else
                            formula = formula.Replace(rowEvento[0].ToString(), _evento);
                    }
                    else
                    {
                        MsgException("Cotação não encontrada para a data evento: " + dtEvento.ToShortDateString(), 1, "");
                        return;
                    }
                }
            }

            DateTime dtPagamento;
            dtPagamento = Convert.ToDateTime(txtDtPag.Text == string.Empty ? "01/01/1970" : txtDtPag.Text, culture);
            string diasP = DataBase.Consultas.Consulta(str_conn, "select CINRDIAS from CFFORMUL where CITPDESL='P' and CIIDCODI=" + dropFormulas.Value.ToString() + "", 1)[0];
            if (diasP == "-30" || diasP == "-31")
                dtPagamento = dtPagamento.AddMonths(-1);
            else if (diasP == "30" || diasP == "31")
                dtPagamento = dtPagamento.AddMonths(1);
            else
                dtPagamento = dtPagamento.AddDays(Convert.ToInt32(diasP));
            //var _pagamento = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,CV.cvvlcoid,CF.CIPRPART from CFFORMUL CF,CVCOTIEC CV where CV.cvdtcoie=(CONVERT(datetime,'" + dtPagamento.ToShortDateString() + "'," + codDT + ")) AND CV.ieidinec=CF.IEIDINEC AND CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='P'", 3);
            //DataTable dataTablePag = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,CV.cvvlcoid,CF.CIPRPART from CFFORMUL CF,CVCOTIEC CV where CV.cvdtcoie=(CONVERT(datetime,'" + dtPagamento.ToShortDateString() + "'," + codDT + ")) AND CV.ieidinec=CF.IEIDINEC AND CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='P'");
            DataTable dataTablePag = DataBase.Consultas.Consulta(str_conn, "select CF.CICDVARI,dbo.FUNC_BUSCA_COTA (cf.ieidinec,CONVERT(datetime,'"+ dtPagamento.ToString("dd/MM/yyyy") + "',103)),CF.CIPRPART from CFFORMUL CF where CF.CIIDCODI=" + dropFormulas.Value.ToString() + " AND CF.CITPDESL='P'");
            string _pagamento = string.Empty;
            foreach (DataRow rowPagamento in dataTablePag.Rows)
            {
                if (txtDtPag.Text != string.Empty)
                {
                    if (rowPagamento[0].ToString() != null)
                    {
                        _pagamento = stf.Eval(rowPagamento[1].ToString() + "*(" + rowPagamento[2].ToString() + "/100)").ToString();
                        if (formula.Contains("from"))
                            formula = formula.Replace(rowPagamento[0].ToString(), _pagamento.Replace(",", "."));
                        else
                            formula = formula.Replace(rowPagamento[0].ToString(), _pagamento);
                    }
                    else
                    {
                        MsgException("Cotação não encontrada para a data pagamento: " + dtPagamento.ToShortDateString(), 1, "");
                        return;
                    }
                }
            }
            if (formula.Contains("from"))
            {
                lblResultado.Text = DataBase.Consultas.Consulta(str_conn,"select "+formula,1)[0];
            }
            else
            {
                double result = Math.Round(stf.Eval(formula), 7);
                string teste = result.ToString();
                teste = teste.Substring(teste.Length - 1, 1);
                if (teste != "0")
                {
                    if (Convert.ToInt32(teste) > 5)
                    {
                        result = Math.Round(result, 6, MidpointRounding.AwayFromZero);
                    }
                    else if (Convert.ToInt32(teste) < 5)
                    {
                        result = Math.Round(result, 6, MidpointRounding.ToEven);
                    }
                }
                lblResultado.Text = result.ToString("N6");
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
        protected void btnSelEmp_Click(object sender, EventArgs e)
        {
            dropFormulas.Value = null;
            dropFormulas.Enabled = true;
            hfDropForm.Value = "";
            gridFormula.DataSource = null;
            gridFormula.DataBind();
            txtNomeFor.Text = "";
            txtNomeFor.Enabled = false;
            dropBase.Value = null;
            dropBase.Enabled = false;
            txtFormula.Text = "";
            txtFormula.Enabled = false;
            txtDtBase.Enabled = false;
            txtDtEvento.Enabled = false;
            txtDtPag.Enabled = false;
            btnExecutar.Enabled = false;
            btnCalcular.Enabled = false;
            btnInserir.Enabled = perfil != "3";
            btnAlterar.Enabled = false;
            btnExcluir.Enabled = false;
            gridFormula.SettingsDataSecurity.AllowInsert = false;
            gridFormula.SettingsDataSecurity.AllowEdit = false;
            gridFormula.SettingsDataSecurity.AllowDelete = false;
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
        }

        protected void btnInserir_Click(object sender, EventArgs e)
        {
            gridFormula.SettingsDataSecurity.AllowInsert = false;
            txtNomeFor.Enabled = true;
            txtNomeFor.Text = "";
            dropBase.Value = null;
            txtFormula.Text = null;
            hfDropForm.Value = "";
            gridFormula.DataBind();
            dropFormulas.Value = null;
            dropBase.Enabled = true;
            txtFormula.Enabled = true;
            hfOperacao.Value = "Inserir";
            btnOK.Enabled = true;
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            switch(hfOperacao.Value)
            {
                case "Inserir":
                    if(Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM CICIENTI WHERE CINMTABE='"+ txtNomeFor.Text + "' AND TVIDESTR="+ hfDropEstr.Value + " ", 1)[0])>0)
                    {
                        MsgException("Nome Duplicado", 1, "");
                        return;
                    }
                    string ID = DataBase.Consultas.Consulta(str_conn, "select max(CIIDCODI)+1 from CICIENTI", 1)[0];
                    string sql = "INSERT INTO CICIENTI " +
                               "(CINMTABE " +
                               ", CITPBASE " +
                               ", CITPFORM " +
                               ", CIIDCODI " +
                               ", TVIDESTR, CIINFLAG) " +
                         "VALUES " +
                               "('"+txtNomeFor.Text+"' " +
                               ", '"+dropBase.Value+"' " +
                               ", '"+txtFormula.Text+"' " +
                               ", "+ID+" " +
                               ", "+hfDropEstr.Value+",1)";
                    if(txtNomeFor.Text=="" || txtFormula.Text=="" || dropBase.Value.ToString()=="")
                    {
                        MsgException("Validar preenchimento correto", 1, "");
                    }
                    else
                    {
                        string exec = DataBase.Consultas.InsertInto(str_conn,sql);
                        if(exec=="OK")
                        {
                            dropFormulas.DataBind();
                            dropFormulas.Value = ID;
                            hfDropForm.Value = ID;
                            gridFormula.SettingsDataSecurity.AllowInsert = true;
                            btnOK.Enabled = false;
                            txtDtBase.Enabled = true;
                            txtDtEvento.Enabled = true;
                            txtDtPag.Enabled = true;
                            btnExecutar.Enabled = true;
                            btnCalcular.Enabled = true;
                            MsgException("Fórmula Criada, seguir com o preenchimento das variáveis", 4, "");
                        }
                        else
                        {
                            MsgException(exec, 1, "");
                        }
                    }
                    break;
                case "Alterar":
                    string sqlUpdt = "UPDATE CICIENTI SET CITPFORM='@CITPFORM' WHERE CIIDCODI=@CIIDCODI";
                    sqlUpdt = sqlUpdt.Replace("@CITPFORM",txtFormula.Text);
                    sqlUpdt = sqlUpdt.Replace("@CIIDCODI", hfDropForm.Value);
                    string exec2 = DataBase.Consultas.UpdtFrom(str_conn,sqlUpdt);
                    if(exec2=="OK")
                    {
                        MsgException("Fórmula alterada", 4, "");
                        txtDtBase.Enabled = true;
                        txtDtEvento.Enabled = true;
                        txtDtPag.Enabled = true;
                        txtFormula.Enabled = false;
                        btnExecutar.Enabled = true;
                        btnCalcular.Enabled = true;
                        btnInserir.Enabled = false;
                        btnAlterar.Enabled = true;
                        btnExcluir.Enabled = true;
                        gridFormula.SettingsDataSecurity.AllowInsert = false;
                        gridFormula.SettingsDataSecurity.AllowEdit = false;
                        gridFormula.SettingsDataSecurity.AllowDelete = false;
                    }
                    break;
                case "Excluir":
                    string sqlDel = "delete CFFORMUL WHERE CIIDCODI=@CIIDCODI";
                    sqlDel = sqlDel.Replace("@CIIDCODI", hfDropForm.Value);
                    string sqlDel2 = "delete CICIENTI WHERE CIIDCODI=@CIIDCODI";
                    sqlDel2 = sqlDel2.Replace("@CIIDCODI", hfDropForm.Value);
                    string exec3 = DataBase.Consultas.UpdtFrom(str_conn, sqlDel);
                    if(exec3=="OK")
                        exec3= DataBase.Consultas.UpdtFrom(str_conn, sqlDel2);
                    MsgException("Fórmula Excluída", 0, "");
                    break;
            }
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
        }

        protected void gridFormula_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            int cont = 0;
            string exec = string.Empty;
            string sqlInsert = "INSERT INTO CFFORMUL (CICDVARI,CITPDESL,CIPRPART,CINRDIAS,CIIDCODI,IEIDINEC) VALUES ('@CICDVARI','@CITPDESL',@CIPRPART,@CINRDIAS,@CIIDCODI,@IEIDINEC)";
            string sqlUpdate = "UPDATE CFFORMUL SET CICDVARI='@CICDVARI',CIPRPART=@CIPRPART,CINRDIAS=@CINRDIAS WHERE IEIDINEC=@IEIDINEC AND CICDVARI='@CICDVARI2' AND CIIDCODI=@CIIDCODI";
            string sqlDelete = "DELETE CFFORMUL WHERE IEIDINEC=@IEIDINEC AND CIIDCODI=@CIIDCODI AND CITPDESL='@CITPDESL' AND CICDVARI='@CICDVARI'";
            string CICDVARI, CITPDESL, CIPRPART, CINRDIAS, CINRCARE, CFVLVALO, CIIDCODI, IEIDINEC;
            foreach (var itens in e.InsertValues)
            {
                CICDVARI = itens.NewValues["CICDVARI"].ToString();
                CITPDESL = itens.NewValues["CITPDESL"].ToString();
                CIPRPART = itens.NewValues["CIPRPART"].ToString();
                CINRDIAS = itens.NewValues["CINRDIAS"].ToString();
                IEIDINEC = itens.NewValues["IEIDINEC"].ToString();
                CIIDCODI = dropFormulas.Value.ToString();
                sqlInsert = sqlInsert.Replace("@CICDVARI",CICDVARI);
                sqlInsert = sqlInsert.Replace("@CITPDESL", CITPDESL);
                sqlInsert = sqlInsert.Replace("@CIPRPART", CIPRPART);
                sqlInsert = sqlInsert.Replace("@CINRDIAS", CINRDIAS);
                sqlInsert = sqlInsert.Replace("@IEIDINEC", IEIDINEC);
                sqlInsert = sqlInsert.Replace("@CIIDCODI", CIIDCODI);
                exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if (exec != "OK")
                    cont++;
                else
                {
                    string updPart = DataBase.Consultas.UpdtFrom(str_conn, "UPDATE CFFORMUL SET CIPRPART="+CIPRPART+" WHERE CIIDCODI="+CIIDCODI+" AND IEIDINEC="+IEIDINEC);

                }
            }
            foreach (var itens in e.UpdateValues)
            {
                CIPRPART = itens.NewValues["CIPRPART"] == null ? itens.OldValues["CIPRPART"].ToString() : itens.NewValues["CIPRPART"].ToString();
                CINRDIAS = itens.NewValues["CINRDIAS"] == null ? itens.OldValues["CINRDIAS"].ToString() : itens.NewValues["CINRDIAS"].ToString();
                IEIDINEC = itens.NewValues["IEIDINEC"] == null ? itens.OldValues["IEIDINEC"].ToString() : itens.NewValues["IEIDINEC"].ToString();
                CICDVARI = itens.NewValues["CICDVARI"] == null ? itens.OldValues["CICDVARI"].ToString() : itens.NewValues["CICDVARI"].ToString();
                CIIDCODI = dropFormulas.Value.ToString();
                sqlUpdate = sqlUpdate.Replace("@CICDVARI2", itens.OldValues["CICDVARI"].ToString());
                sqlUpdate = sqlUpdate.Replace("@CIPRPART", CIPRPART);
                sqlUpdate = sqlUpdate.Replace("@CINRDIAS", CINRDIAS);
                sqlUpdate = sqlUpdate.Replace("@IEIDINEC", IEIDINEC);
                sqlUpdate = sqlUpdate.Replace("@CICDVARI", CICDVARI);                
                sqlUpdate = sqlUpdate.Replace("@CIIDCODI", CIIDCODI);
                exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                if (exec != "OK")
                    cont++;
                else
                {
                    string updPart = DataBase.Consultas.UpdtFrom(str_conn, "UPDATE CFFORMUL SET CIPRPART=" + CIPRPART + " WHERE CIIDCODI=" + CIIDCODI + " AND IEIDINEC=" + IEIDINEC);

                }
            }
            foreach (var itens in e.DeleteValues)
            {
                IEIDINEC = itens.Keys[2].ToString();
                CIIDCODI = itens.Keys[3].ToString();
                CITPDESL = itens.Keys[1].ToString();
                CICDVARI = itens.Keys[0].ToString();
                sqlDelete = sqlDelete.Replace("@IEIDINEC", IEIDINEC);
                sqlDelete = sqlDelete.Replace("@CIIDCODI", CIIDCODI);
                sqlDelete = sqlDelete.Replace("@CITPDESL", CITPDESL);
                sqlDelete = sqlDelete.Replace("@CICDVARI", CICDVARI);
                exec = DataBase.Consultas.DeleteFrom(str_conn,sqlDelete);
                if (exec != "OK")
                    cont++;
            }
        }
        protected void gridFormula_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            if (e.NewValues["CIPRPART"] != null)
            {
                string IEIDINEC = e.OldValues["IEIDINEC"] == null ? e.NewValues["IEIDINEC"].ToString() : e.OldValues["IEIDINEC"].ToString();
                DataTable dt = DataBase.Consultas.Consulta(str_conn, "select AVG(CIPRPART) from CFFORMUL where CIIDCODI="+ dropFormulas.Value.ToString() + " and IEIDINEC not in ("+ IEIDINEC + ") GROUP BY IEIDINEC");
                int part = 0;
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        part = part + Convert.ToInt32(row[0]);
                    }
                    part = part + Convert.ToInt32(e.NewValues["CIPRPART"]);
                    if(part>100)
                    {
                        e.RowError = "Participação maior que 100%";
                    }
                }
            }
            if (e.IsNewRow)
            {
                string CICDVARI2 = e.NewValues["CICDVARI"].ToString();
                string CITPDESL2 = e.NewValues["CITPDESL"].ToString();
                string IEIDINEC2 = e.NewValues["IEIDINEC"].ToString();
                string CIIDCODI = dropFormulas.Value.ToString();
                bool duplicate = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from CFFORMUL where CICDVARI='"+ CICDVARI2 + "' AND CITPDESL='"+ CITPDESL2 + "' AND IEIDINEC="+ IEIDINEC2 + " AND CIIDCODI="+ CIIDCODI + "", 1)[0]) > 0 ? true : false;
                if(duplicate)
                {
                    e.RowError = "Duplicado";
                }
            }
            
        }
        protected void btnAlterar_Click(object sender, EventArgs e)
        {
            gridFormula.SettingsDataSecurity.AllowInsert = true;
            gridFormula.SettingsDataSecurity.AllowEdit = true;
            gridFormula.SettingsDataSecurity.AllowDelete = true;
            txtNomeFor.Enabled = false;
            dropBase.Enabled = false;
            txtFormula.Enabled = true;
            hfOperacao.Value = "Alterar";
            btnAlterar.Enabled = false;
            btnInserir.Enabled = false;
            btnExcluir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
        }
        protected void btnExcluir_Click(object sender, EventArgs e)
        {
            hfOperacao.Value = "Excluir";
            btnAlterar.Enabled = false;
            btnInserir.Enabled = false;
            btnExcluir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            //hfDropForm.Value = dropFormulas.Value.ToString();
            var result = DataBase.Consultas.Consulta(str_conn, "select CINMTABE,CITPBASE,CITPFORM from CICIENTI where CIIDCODI=" + hfDropForm.Value, 3);
            txtNomeFor.Text = result[0];
            txtNomeFor.Enabled = false;
            dropBase.Value = result[1];
            dropBase.Enabled = false;
            txtFormula.Text = result[2];
            txtFormula.Enabled = false;
            hfFormula.Value = hfDropForm.Value;
            txtDtBase.Enabled = true;
            txtDtEvento.Enabled = true;
            txtDtPag.Enabled = true;
            btnExecutar.Enabled = true;
            btnCalcular.Enabled = true;
            btnInserir.Enabled = false;
            btnAlterar.Enabled = true;
            btnExcluir.Enabled = true;
            gridFormula.SettingsDataSecurity.AllowInsert = false;
            gridFormula.SettingsDataSecurity.AllowEdit = false;
            gridFormula.SettingsDataSecurity.AllowDelete = false;
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
        }
        protected void btnInserir_Load(object sender, EventArgs e)
        {
            ASPxButton obj = (ASPxButton)sender;
            obj.Enabled = perfil != "3";
        }

        protected void btnExcluir_Load(object sender, EventArgs e)
        {
        }

        protected void btnAlterar_Load(object sender, EventArgs e)
        {
        }
    }
}