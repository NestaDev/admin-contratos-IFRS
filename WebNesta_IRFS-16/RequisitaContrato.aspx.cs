using AjaxControlToolkit;
using DataBase;
using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class RequisitaContrato : BasePage.BasePage
    {
        public static string str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string user;
        public static string usuarioPersist;
        public static string currentPage;
        public static int countBasesInsert = 0;
        public static int countBasesEdit = 0;
        public static int clickOK;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    lang = Session["langSession"].ToString();
                }
                catch
                {
                    lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
                }
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                    usuarioPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                user = usuarioPersist;
                hfUser.Value = user;
                hfUser2.Value = user;
                HttpCookie cookiePais = HttpContext.Current.Request.Cookies["PAIDPAIS"];
                if (cookiePais == null)
                    hfPaisUser.Value = "1";
                else
                    hfPaisUser.Value = cookiePais.Value;
            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void MsgException(string msg, int exc, string curr = "")
        {
            if (exc == 1)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = "Exception: " + msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 0)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 3)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 4)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void TreeList_Load(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treelist = (DevExpress.Web.ASPxTreeList.ASPxTreeList)sender;
            if (sqlTreeList == null) return;
            treelist.DataBind();
        }
        protected void TreeList_CustomJSProperties(object sender, TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void btnSelEmp_Click(object sender, EventArgs e)
        {
            Session["TVIDESTR_PAG"] = hfDropEstr.Value;
            sqlResponsavel.SelectParameters[0].DefaultValue = hfDropEstr.Value;
            sqlResponsavel.SelectParameters[1].DefaultValue = hfDropEstr.Value;
        }
        protected void dropClasseProdutoInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            sqlClasseProdutosInsert.SelectParameters[0].DefaultValue = e.Parameter;
            dropClasseProdutoInsert2.DataBind();
        }
        protected void dropTipoInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            sqlTipoInsert.SelectParameters[0].DefaultValue = e.Parameter;
            dropTipoInsert2.DataBind();
            if (hfOperacao.Value == "inserir")
                dropTipoInsert2.Value = "99";
        }
        protected void AcoesBotoes(object sender, CommandEventArgs args)
        {
            hfOperacao.Value = args.CommandArgument.ToString();
            btnOK.Enabled = true;
            btnOK1.Enabled = true;
            btnCancelar.Enabled = true;
            btnCancelar1.Enabled = true;
            switch (hfOperacao.Value)
            {
                case "inserir":
                    ddeEstruturaInsert.Enabled = true;
                    comboImovel.Enabled = true;
                    txtDataInaug.Enabled = true;
                    txtDataDevol.Enabled = true;
                    txtDataReceb.Enabled = true;
                    txtDataVistoria.Enabled = true;
                    dropTipoImov.Enabled = true;
                    txtRegAdmin.Enabled = true;
                    txtNoContribu.Enabled = true;
                    ddeGeoLocal.Enabled = true;
                    txtCep.Enabled = true;
                    dropLogradoura.Enabled = true;
                    txtAnoConst.Enabled = true;
                    dropSituacao.Enabled = true;
                    txtNoProcRegis.Enabled = true;
                    txtTestadaPrinc.Enabled = true;
                    txtAreaTerreno.Enabled = true;
                    txtAreaEdificada.Enabled = true;
                    txtAreaComum.Enabled = true;
                    txtFracIdeal.Enabled = true;
                    txtDataRegis.Enabled = true;
                    txtValorVenal.Enabled = true;
                    txtNumProcessoInsert.Enabled = true;
                    txtCodAuxInsert.Enabled = true;
                    txtDescricaoInsert.Enabled = true;
                    txtDataSolic.Enabled = true;
                    txtValorCont.Enabled = true;
                    dropEstruturaInsert2.Enabled = true;
                    dropClasseProdutoInsert2.Enabled = true;
                    dropAgenteFinanceiroInsert2.Enabled = true;
                    btnOK.ValidationGroup = "InsertReq";
                    gridWWF.Enabled = true;
                    break;
                case "alterar":
                    ddeEstruturaInsert.Enabled = false;
                    txtDataInaug.Enabled = true;
                    txtDataDevol.Enabled = true;
                    txtDataReceb.Enabled = false;
                    txtDataVistoria.Enabled = true;
                    dropTipoImov.Enabled = false;
                    txtRegAdmin.Enabled = true;
                    txtNoContribu.Enabled = true;
                    ddeGeoLocal.Enabled = true;
                    txtCep.Enabled = true;
                    dropLogradoura.Enabled = true;
                    txtAnoConst.Enabled = true;
                    dropSituacao.Enabled = true;
                    txtNoProcRegis.Enabled = true;
                    txtTestadaPrinc.Enabled = true;
                    txtAreaTerreno.Enabled = true;
                    txtAreaEdificada.Enabled = true;
                    txtAreaComum.Enabled = true;
                    txtFracIdeal.Enabled = true;
                    txtDataRegis.Enabled = true;
                    txtValorVenal.Enabled = true;
                    txtNumProcessoInsert.Enabled = false;
                    txtCodAuxInsert.Enabled = false;
                    txtDescricaoInsert.Enabled = true;
                    txtDataSolic.Enabled = false;
                    txtValorCont.Enabled = true;
                    dropEstruturaInsert2.Enabled = true;
                    dropClasseProdutoInsert2.Enabled = true;
                    dropAgenteFinanceiroInsert2.Enabled = true;
                    btnOK1.ValidationGroup = "";
                    btnOK1.CausesValidation = false;
                    gridWWF.Enabled = true;
                    btnEdit.Enabled = false;
                    btnDelete.Enabled = false;
                    break;
                case "excluir":
                    btnEdit.Enabled = false;
                    btnDelete.Enabled = false;
                    break;
            }
        }
        protected void BasesEdit(object sender, CommandEventArgs e)
        {
            if (hfOperacao.Value != "inserir" && hfOperacao.Value != "alterar")
            {
                btnEditarData.Enabled = false;
                btnEditarDataDel.Enabled = false;
                btnEditarMoeda.Enabled = false;
                Button4.Enabled = false;
                btnEditarInteiro.Enabled = false;
                Button5.Enabled = false;
                btnEditarFlutuante.Enabled = false;
                Button6.Enabled = false;
                btnEditarFormula.Enabled = false;
                Button7.Enabled = false;
                btnEditarIndice.Enabled = false;
                Button8.Enabled = false;
                btnEditarSql.Enabled = false;
                Button9.Enabled = false;
                gridRptDeAte.SettingsDataSecurity.AllowDelete = false;
                gridRptDeAte.SettingsDataSecurity.AllowEdit = false;
                gridRptDeAte.SettingsDataSecurity.AllowInsert = false;
                btnInserirData.Enabled = false;
                btnInserirMoeda.Enabled = false;
                btnInserirInteiro.Enabled = false;
                btnInserirFlutuante.Enabled = false;
                btnInserirFormula.Enabled = false;
                btnInserirIndice.Enabled = false;
                btnInserirSql.Enabled = false;
                gridDeAteInsert.SettingsDataSecurity.AllowDelete = false;
                gridDeAteInsert.SettingsDataSecurity.AllowEdit = false;
                gridDeAteInsert.SettingsDataSecurity.AllowInsert = false;
            }
            string[] name = e.CommandName.Split('#');
            string cjtpidtp = name[0];
            string cjdsdecr = name[1];
            string combo = name[2];
            string cjtpcttx = name[3];
            string[] args = e.CommandArgument.ToString().Split('#');
            string cjidcodi = args[0];
            string chidcodi = args[1];
            hfCJIDCODI2.Value = cjidcodi;
            hfCHIDCODI2.Value = chidcodi;
            hfCJTPIDTP2.Value = cjtpidtp;
            string i = cjtpidtp;
            string sql1 = "select count(*) from cjclprop_din " +
            "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
              "and opidcont = " + hfCodInterno.Value + " " +
              "and cjidcodi = " + hfCJIDCODI2.Value;
            int temProp = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sql1, 1)[0]);
            switch (i)
            {
                case "3": //Tipo Data
                    lblEditarData.Text = cjdsdecr;
                    txtEditarData.Text = cjtpcttx;
                    MultiView1.ActiveViewIndex = 0;
                    btnEditarData.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        btnEditarDataDel.Visible = false;
                    else if (temProp > 0)
                        btnEditarDataDel.Visible = true;
                    break;
                case "6": //Tipo Flutuante
                    lblEditarFlutuante.Text = cjdsdecr;
                    txtEditarFlutuante.Text = cjtpcttx;
                    MultiView1.ActiveViewIndex = 3;
                    btnEditarFlutuante.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button6.Visible = false;
                    else if (temProp > 0)
                        Button6.Visible = true;
                    break;
                case "8": //Tipo Fórmula paramétrica
                    lblEditarFormula.Text = cjdsdecr;
                    using (var con = new OleDbConnection(str_conn))
                    {
                        string sqlFormula = "WITH n(tvidestr) AS  " +
                                            "(SELECT tvidestr " +
                                            "FROM tvestrut " +
                                            "WHERE tvidestr = " + hfDropEstr.Value + " " +
                                            "UNION ALL " +
                                            "SELECT nplus1.tvidestr " +
                                            "FROM tvestrut as nplus1, n " +
                                            "WHERE n.tvidestr = nplus1.tvcdpaie) " +
                                            "SELECT CINMTABE, CIIDCODI FROM n, CICIENTI C " +
                                            "WHERE C.TVIDESTR = n.tvidestr " +
                                            "union all " +
                                            "SELECT CINMTABE, CIIDCODI " +
                                            "FROM CICIENTI C where c.ciinflag = 0";
                        con.Open();
                        using (var cmd = new OleDbCommand(sqlFormula, con))
                        {
                            OleDbDataReader dr = cmd.ExecuteReader();
                            if (dr.HasRows)
                            {
                                dr.Read();
                                dropEditarFormula.DataTextField = dr.GetName(0);
                                dropEditarFormula.DataValueField = dr.GetName(1);
                                dr.Close();
                                dropEditarFormula.DataSource = cmd.ExecuteReader();
                                dropEditarFormula.DataBind();
                            }
                        }
                    }
                    MultiView1.ActiveViewIndex = 4;
                    btnEditarFormula.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button7.Visible = false;
                    else if (temProp > 0)
                        Button7.Visible = true;
                    break;
                case "15": //Tipo Indice
                    lblEditarIndice.Text = cjdsdecr;
                    txtEditarIndice.Text = cjtpcttx;
                    MultiView1.ActiveViewIndex = 5;
                    btnEditarIndice.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button8.Visible = false;
                    else if (temProp > 0)
                        Button8.Visible = true;
                    break;
                case "9": //Tipo Inteiro
                    if (cjidcodi == "264")
                        txtEditarInteiro.MaskSettings.Mask = "<1..31>";
                    else
                        txtEditarInteiro.MaskSettings.Mask = "<0..999>";
                    lblEditarInteiro.Text = cjdsdecr;
                    txtEditarInteiro.Text = cjtpcttx;
                    MultiView1.ActiveViewIndex = 2;
                    btnEditarInteiro.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button5.Visible = false;
                    else if (temProp > 0)
                        Button5.Visible = true;
                    break;
                case "10": //Tipo Moeda
                    lblEditarMoeda.Text = cjdsdecr;
                    txtEditarMoeda.Text = cjtpcttx;
                    MultiView1.ActiveViewIndex = 1;
                    btnEditarMoeda.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button4.Visible = false;
                    else if (temProp > 0)
                        Button4.Visible = true;
                    break;
                case "4": //Tipo De Até
                    string sql = "select cjdtdtde De,cjdtdtat Ate,cjvldeat Valor,opidcont ID from cjclprop_din " +
                                "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                                  "and opidcont = " + hfCodInterno.Value + " " +
                                  "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                                  "and CJTPCTTX is null";
                    hfqueryRpt.Value = sql;
                    gridRptDeAte.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
                    gridRptDeAte.DataBind();
                    MultiView1.ActiveViewIndex = 7;
                    break;
                case "12": //Tipo SQL
                    lblEditarSql.Text = cjdsdecr;
                    using (var con = new OleDbConnection(str_conn))
                    {
                        con.Open();
                        using (var cmd = new OleDbCommand(HttpUtility.HtmlDecode(combo.Replace("FROM DUAL", "")), con))
                        {
                            OleDbDataReader dr = cmd.ExecuteReader();
                            if (dr.HasRows)
                            {
                                dr.Read();
                                dropEditarSql2.TextField = dr.GetName(0);
                                dropEditarSql2.ValueField = dr.GetName(0);
                                dr.Close();
                            }
                            dropEditarSql2.DataSource = cmd.ExecuteReader();
                            dropEditarSql2.DataBind();
                            try
                            {
                                dropEditarSql2.Value = cjtpcttx;
                            }
                            catch { }
                        }
                    }
                    MultiView1.ActiveViewIndex = 6;
                    btnEditarSql.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button9.Visible = false;
                    else if (temProp > 0)
                        Button9.Visible = true;
                    break;
            }
            popupBasesAlterar.HeaderText = cjdsdecr;
            popupBasesAlterar.ShowOnPageLoad = true;
        }
        protected void DelBasesEdit(object sender, CommandEventArgs e)
        {
            string del = "delete cjclprop_din where chidcodi=" + hfCHIDCODI2.Value + " and opidcont=" + hfCodInterno.Value + " and cjidcodi=" + hfCJIDCODI2.Value + "";
            string result = DataBase.Consultas.DeleteFrom(str_conn, del);
            popupBasesAlterar.ShowOnPageLoad = false;
            BasesNegociacaoEdit(hfCodInterno.Value, 1);
            BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
        }
        #region EditBases
        protected void btnEditarData_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(3);
        }
        protected void btnEditarMoeda_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(10);
        }
        /// <summary>
        /// Método com switch para executar procedure de alterar das propriedades dinâmicas conforme o tipo de dado.
        /// </summary>
        /// <param name="tipoBase">3=Data 6=Flutuante 8=Fórmula 15=Indice 9=Inteiro 10=Moeda 4=DeAte 12=SQL</param>
        protected void SwitchEditarBasesProc(int tipoBase)
        {
            string queryQt = "select count(opidcont) from cjclprop_din " +
        "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
          "and opidcont = " + hfCodInterno.Value + " " +
          "and cjidcodi = " + hfCJIDCODI2.Value;
            int qntd = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, queryQt, 1)[0]);
            string result = null;
            switch (tipoBase.ToString())
            {
                case "3": //Tipo Data
                    int resultDt = 0;
                    string dtBanco = DataBase.Consultas.Consulta(str_conn, "select OPDTASCO from opcontra where opidcont=" + hfCodInterno.Value + "", 1)[0];

                    if (DateTime.TryParse(txtEditarData.Text, CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtTeste))
                    {
                        DateTime.Compare(Convert.ToDateTime(txtEditarData.Text, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(dtBanco, CultureInfo.GetCultureInfo(lang)));
                    }
                    int oper = 0;
                    if (resultDt == -1 && hfCJIDCODI2.Value == "277")//Data Anterior a Data Aquisição
                    {
                        MsgException(lblEditarData.Text + " não pode ser anterior a Data do Contrato.", 1);
                    }
                    else
                    {
                        if (qntd != 0)
                        {
                            //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                            //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                            result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, Convert.ToDateTime(txtEditarData.Text, CultureInfo.GetCultureInfo(lang)), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), 0);
                            oper = result == "OK" ? 1 : 0;
                        }
                        else
                        {
                            result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, Convert.ToDateTime(txtEditarData.Text, CultureInfo.GetCultureInfo(lang)), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                        }
                        if (result != "OK")
                        {
                            MsgException("Erro: " + result, 1);
                        }
                        BasesNegociacaoEdit(hfCodInterno.Value, 1);
                        BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    }
                    if (result == "OK" && hfCJIDCODI2.Value == "277" && oper == 1)
                    {
                        MsgException("Valor alterado, execução de limpeza do Fluxo de Caixa", 2);
                    }
                    break;
                case "6": //Tipo Flutuante
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarFlutuante.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), 0);
                    }
                    else
                    {
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarFlutuante.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }

                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "8": //Tipo Fórmula paramétrica
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.SelectedValue, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), 0);
                    }
                    else
                    {
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.SelectedValue, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "15": //Tipo Indice
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarIndice.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarIndice.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "9": //Tipo Inteiro
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarInteiro.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarInteiro.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "10": //Tipo Moeda

                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarMoeda.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarMoeda.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;

                case "12": //Tipo SQL
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarSql2.SelectedItem.Text, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarSql2.SelectedItem.Text, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
            }
            popupBasesAlterar.ShowOnPageLoad = false;
        }
        protected void btnEditarInteiro_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
                SwitchEditarBasesProc(9);
        }
        protected void btnEditarFlutuante_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(6);
        }
        protected void btnEditarFormula_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(8);
        }
        protected void btnEditarIndice_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(15);
        }
        protected void btnEditarSql_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(12);
        }
        protected void btnInserirData_Click(object sender, EventArgs e)
        {

            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, 0, null, Convert.ToDateTime(txtInserirData.Text, CultureInfo.GetCultureInfo(lang)), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            if (result != "OK")
            {
                MsgException("Erro: " + result, 1);
            }
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
            popupBasesInsert.ShowOnPageLoad = false;
        }
        protected void btnInserirSql_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), dropInserirSql.SelectedValue, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
            popupBasesInsert.ShowOnPageLoad = false;
        }
        protected void btnInserirIndice_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, Convert.ToInt32(txtInserirIndice.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            if (result != "OK")
            {
                MsgException("Erro: " + result, 1);
            }
            popupBasesInsert.ShowOnPageLoad = false;
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        protected void btnInserirMoeda_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, 0, txtInserirMoeda.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            if (result != "OK")
            {
                MsgException("Erro: " + result, 1);
            }
            popupBasesInsert.ShowOnPageLoad = false;
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        protected void btnInserirInteiro_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, Convert.ToInt32(txtInserirInteiro.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            if (result != "OK")
            {
                MsgException("Erro: " + result, 1);
            }
            popupBasesInsert.ShowOnPageLoad = false;
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        protected void btnInserirFlutuante_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, 0, txtInserirFlutuante.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            if (result != "OK")
            {
                MsgException("Erro: " + result, 1);
            }
            popupBasesInsert.ShowOnPageLoad = false;
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        protected void btnInserirFormula_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), dropInserirFormula.SelectedValue, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            if (result != "OK")
            {
                MsgException("Erro: " + result, 1);
            }
            popupBasesInsert.ShowOnPageLoad = false;
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        #endregion
        protected void rptBasesInserir_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }
        protected void BasesNegociacaoEdit(string opidcont, int pais, int chtpidev=1)
        {
            string codLang = lang == "en-US" ? "101" : "103";
            if (chtpidev == 1)
            {
                string sql = "select cj.cjidcodi,cj.CJDSDECR, case when tp.cjtpidtp=8 then (SELECT CINMTABE FROM CICIENTI where CIIDCODI=cd.cjtpcttx) when tp.cjtpidtp=3 then convert(varchar,cd.CJDTPROP," + codLang + ") else cd.cjtpcttx end as cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO, cj.CJTPIDTP, cj.CJORORDE,cd.CJVLPROP " +
                      "from cjclprop cj, cjclprop_din cd, cjtptipo tp, viproeve vp " +
                     "where cd.opidcont = " + opidcont + " " +
                        "and cj.chidcodi = cd.chidcodi " +
                        "and cj.cjidcodi = cd.cjidcodi " +
                        "and cd.cjtpcttx is not null " +
                        "and vp.chidcodi = cj.chidcodi " +
                        "and vp.cjidcodi = cj.cjidcodi " +
                        "and vp.chtpidev = " + chtpidev + " " +
                        "and tp.PAIDPAIS = 1 " +
                        "and tp.cjtpidtp = cj.cjtpidtp " +
                        //Incluido trecho abaixo para não trazer propriedades com flags iguais aos opcontra
                        "and cj.CJIDCODI not in (select dp.cjidcodi from dppropfl dp, opcontra op where cj.CJIDCODI=dp.cjidcodi and op.OPIDCONT=" + opidcont + " and (op.OPFLPARC=dp.opflparc or op.OPFLCARE=dp.OPFLCARE or op.OPFLSLDI=dp.OPFLSLDI))  " +
    "union all " +
    "select cj.cjidcodi,cj.CJDSDECR,'__________' cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO, cj.CJTPIDTP,cj.CJORORDE,0 CJVLPROP " +
                                                  "from cjclprop cj, cjtptipo tp, viproeve vp " +
                                                  "where cj.chidcodi = (select p.chidcodi from opcontra o inner join prprodut p on o.PRPRODID = p.prprodid where opidcont = " + opidcont + ") " +
                                                    "and tp.PAIDPAIS = " + pais + " " +
                                                    "and tp.cjtpidtp = cj.cjtpidtp " +
                                                    "and vp.chidcodi = cj.chidcodi " +
                                                    "and vp.cjidcodi = cj.cjidcodi " +
                                                    "and vp.chtpidev = " + chtpidev + " " +
                                                    "and cj.CJIDCODI not in (select cj.CJIDCODI from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
                          "where cd.opidcont = " + opidcont + " " +
                            "and cj.chidcodi = cd.chidcodi " +
                            "and cj.cjidcodi = cd.cjidcodi " +
                            "and cd.cjtpcttx is not null  " +
                            "and tp.PAIDPAIS = " + pais + " " +
                            "and tp.cjtpidtp = cj.cjtpidtp) " +
                            //Incluido trecho abaixo para não trazer propriedades com flags iguais aos opcontra
                            "and cj.CJIDCODI not in (select dp.cjidcodi from dppropfl dp, opcontra op where cj.CJIDCODI=dp.cjidcodi and op.OPIDCONT=" + opidcont + " and (op.OPFLPARC=dp.opflparc or op.OPFLCARE=dp.OPFLCARE or op.OPFLSLDI=dp.OPFLSLDI))  order by CJORORDE";
                rptBasesInserir.DataSource = Consultas.Consulta(str_conn, sql);
                rptBasesInserir.DataBind();
            }
            else
            {
                string sql = "select cj.cjidcodi,cj.CJDSDECR, case when tp.cjtpidtp=8 then (SELECT CINMTABE FROM CICIENTI where CIIDCODI=cd.cjtpcttx) when tp.cjtpidtp=3 then convert(varchar,cd.CJDTPROP," + codLang + ") else cd.cjtpcttx end as cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO, cj.CJTPIDTP, cj.CJORORDE,cd.CJVLPROP " +
                      "from cjclprop cj, cjclprop_din cd, cjtptipo tp, viproeve vp " +
                     "where cd.opidcont = " + opidcont + " " +
                        "and cj.chidcodi = cd.chidcodi " +
                        "and cj.cjidcodi = cd.cjidcodi " +
                        "and cd.cjtpcttx is not null " +
                        "and vp.chidcodi = cj.chidcodi " +
                        "and vp.cjidcodi = cj.cjidcodi " +
                        "and vp.chtpidev = " + chtpidev + " " +
                        "and tp.PAIDPAIS = 1 " +
                        "and tp.cjtpidtp = cj.cjtpidtp " +
    //Incluido trecho abaixo para não trazer propriedades com flags iguais aos opcontra
    //"and cj.CJIDCODI not in (select dp.cjidcodi from dppropfl dp, opcontra op where cj.CJIDCODI=dp.cjidcodi and op.OPIDCONT=" + opidcont + " and (op.OPFLPARC=dp.opflparc or op.OPFLCARE=dp.OPFLCARE or op.OPFLSLDI=dp.OPFLSLDI))  " +
    "union all " +
    "select cj.cjidcodi,cj.CJDSDECR,'__________' cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO, cj.CJTPIDTP,cj.CJORORDE,0 CJVLPROP " +
                                                  "from cjclprop cj, cjtptipo tp, viproeve vp " +
                                                  "where cj.chidcodi = (select p.chidcodi from opcontra o inner join prprodut p on o.PRPRODID = p.prprodid where opidcont = " + opidcont + ") " +
                                                    "and tp.PAIDPAIS = " + pais + " " +
                                                    "and tp.cjtpidtp = cj.cjtpidtp " +
                                                    "and vp.chidcodi = cj.chidcodi " +
                                                    "and vp.cjidcodi = cj.cjidcodi " +
                                                    "and vp.chtpidev = " + chtpidev + " " +
                                                    "and cj.CJIDCODI not in (select cj.CJIDCODI from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
                          "where cd.opidcont = " + opidcont + " " +
                            "and cj.chidcodi = cd.chidcodi " +
                            "and cj.cjidcodi = cd.cjidcodi " +
                            "and cd.cjtpcttx is not null  " +
                            "and tp.PAIDPAIS = " + pais + " " +
                            "and tp.cjtpidtp = cj.cjtpidtp) " +
                            //Incluido trecho abaixo para não trazer propriedades com flags iguais aos opcontra
                            //"and cj.CJIDCODI not in (select dp.cjidcodi from dppropfl dp, opcontra op where cj.CJIDCODI=dp.cjidcodi and op.OPIDCONT=" + opidcont + " and (op.OPFLPARC=dp.opflparc or op.OPFLCARE=dp.OPFLCARE or op.OPFLSLDI=dp.OPFLSLDI))
                            "order by CJORORDE";
                rptBasesInserir.DataSource = Consultas.Consulta(str_conn, sql);
                rptBasesInserir.DataBind();
            }

        }
        protected void BasesNegociacaoInsert(string chidcodi, int pais, int chtpidev)
        {

            string sql = "select cj.cjidcodi,cj.CJDSDECR, case when tp.cjtpidtp=8 then (SELECT CINMTABE FROM CICIENTI where CIIDCODI=cd.cjtpcttx) else cd.cjtpcttx end as cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO,cj.CJTPIDTP,cj.CJORORDE,cd.CJVLPROP " +
                      "from cjclprop cj, cjclprop_din cd, cjtptipo tp, viproeve vp " +
                      "where cd.opidcont = " + hfCodInterno.Value + " " +
                        "and cj.chidcodi = cd.chidcodi " +
                        "and cj.cjidcodi = cd.cjidcodi " +
                        "and cd.cjtpcttx is not null  " +
                        "and tp.PAIDPAIS = " + pais + " " +
                        "and vp.chidcodi = cj.chidcodi " +
                        "and vp.cjidcodi = cj.cjidcodi " +
                        "and vp.chtpidev = " + pais + " " +
                        "and tp.cjtpidtp = cj.cjtpidtp " +
                        //Incluido trecho abaixo para não trazer propriedades com flags iguais aos opcontra
                        "and cj.CJIDCODI not in (select dp.cjidcodi from dppropfl dp, opcontra op where cj.CJIDCODI=dp.cjidcodi and op.OPIDCONT=" + hfCodInterno.Value + " and (op.OPFLPARC=dp.opflparc or op.OPFLCARE=dp.OPFLCARE or op.OPFLSLDI=dp.OPFLSLDI))  " +
                    "union all " +
                      "select cj.cjidcodi,cj.CJDSDECR,'____________' cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO,cj.CJTPIDTP,cj.CJORORDE,0 CJVLPROP " +
                                              "from cjclprop cj, cjtptipo tp, viproeve vp " +
                                              "where cj.chidcodi = " + chidcodi + " " +
                                                "and tp.PAIDPAIS = " + pais + " " +
                                                "and tp.cjtpidtp = cj.cjtpidtp " +
                                                "and vp.chidcodi = cj.chidcodi " +
                                                "and vp.cjidcodi = cj.cjidcodi " +
                                                "and vp.chtpidev = " + chtpidev + " " +
                                                "and cj.CJIDCODI not in (select cj.CJIDCODI from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
                      "where cd.opidcont = " + hfCodInterno.Value + " " +
                        "and cj.chidcodi = cd.chidcodi " +
                        "and cj.cjidcodi = cd.cjidcodi " +
                        "and cd.cjtpcttx is not null  " +
                        "and tp.PAIDPAIS = " + pais + " " +
                        "and tp.cjtpidtp = cj.cjtpidtp) " +
                        //Incluido trecho abaixo para não trazer propriedades com flags iguais aos opcontra
                        "and cj.CJIDCODI not in (select dp.cjidcodi from dppropfl dp, opcontra op where cj.CJIDCODI=dp.cjidcodi and op.OPIDCONT=" + hfCodInterno.Value + " and (op.OPFLPARC=dp.opflparc or op.OPFLCARE=dp.OPFLCARE or op.OPFLSLDI=dp.OPFLSLDI))  " +
                        "order by CJORORDE";
            rptBasesInserir.DataSource = Consultas.Consulta(str_conn, sql);
            rptBasesInserir.DataBind();
        }
        protected void rptBasesInserir_PreRender(object sender, EventArgs e)
        {
            for (int i = 0; i < rptBasesInserir.Items.Count; i++)
            {
                if (((i + 1) % 4) == 0 && i > 0)
                {
                    Literal ltr = rptBasesInserir.Items[i].FindControl("ltrlRepeaterBasesInserir") as Literal;
                    ltr.Text = "</div><div class=\"row\">";
                }
            }
        }
        protected string InsertPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, DateTime p_cjdtprop, DateTime p_cjdtdtde, DateTime p_cjdtdtat, string p_cjvldeat)
        {
            string retorno = null;
            string storedProc = "nesta_sp_insert_CJCLPROP_DIN";
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                try
                {
                    OleDbParameter outValue = new OleDbParameter("@o_mensagem", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                    conn.Open();
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = storedProc;
                    cmd.Parameters.AddWithValue("@p_opidcont", p_opidcont);
                    cmd.Parameters.AddWithValue("@p_chidcodi", p_chidcodi);
                    cmd.Parameters.AddWithValue("@p_cjidcodi", p_cjidcodi);
                    cmd.Parameters.AddWithValue("@p_cjtpidtp", p_cjtpidtp);
                    cmd.Parameters.AddWithValue("@p_cjtpcttx", p_cjtpcttx);
                    cmd.Parameters.AddWithValue("@p_cjinprop", p_cjinprop);
                    cmd.Parameters.AddWithValue("@p_cjvlprop", p_cjvlprop);
                    cmd.Parameters.AddWithValue("@p_cjdtprop", p_cjdtprop == new DateTime(1970, 01, 01) ? null : p_cjdtprop.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@p_cjdtdtde", p_cjdtdtde == new DateTime(1970, 01, 01) ? null : p_cjdtdtde.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@p_cjdtdtat", p_cjdtdtat == new DateTime(1970, 01, 01) ? null : p_cjdtdtat.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@p_cjvldeat", p_cjvldeat);
                    cmd.Parameters.AddWithValue("@p_opdtadit", "");
                    cmd.Parameters.AddWithValue("@p_idioma", lang);
                    cmd.Parameters.Add(outValue);
                    cmd.ExecuteScalar();
                    retorno = outValue.Value.ToString();
                }
                catch (Exception ex)
                {
                    retorno = ex.Message.ToString();
                }
                finally
                {
                    conn.Close();
                }

            }
            return retorno;
        }
        protected string AlterarPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, DateTime p_cjdtprop, DateTime p_cjdtdtde, DateTime p_cjdtdtat, float p_cjvldeat)
        {
            string retorno = null;
            string storedProc = "nesta_sp_update_CJCLPROP_DIN";
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                try
                {


                    OleDbParameter outValue = new OleDbParameter("@o_mensagem", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                    conn.Open();
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = storedProc;
                    cmd.Parameters.AddWithValue("@p_opidcont", p_opidcont);
                    cmd.Parameters.AddWithValue("@p_chidcodi", p_chidcodi);
                    cmd.Parameters.AddWithValue("@p_cjidcodi", p_cjidcodi);
                    cmd.Parameters.AddWithValue("@p_cjtpidtp", p_cjtpidtp);
                    cmd.Parameters.AddWithValue("@p_cjtpcttx", p_cjtpcttx);
                    cmd.Parameters.AddWithValue("@p_cjinprop", p_cjinprop);
                    cmd.Parameters.AddWithValue("@p_cjvlprop", p_cjvlprop);
                    cmd.Parameters.AddWithValue("@p_cjdtprop", p_cjdtprop == new DateTime(1970, 01, 01) ? null : p_cjdtprop.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@p_cjdtdtde", p_cjdtdtde == new DateTime(1970, 01, 01) ? null : p_cjdtdtde.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@p_cjdtdtat", p_cjdtdtat == new DateTime(1970, 01, 01) ? null : p_cjdtdtat.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@p_cjvldeat", p_cjvldeat);
                    cmd.Parameters.AddWithValue("@p_opdtadit", "");
                    cmd.Parameters.AddWithValue("@p_idioma", lang);
                    cmd.Parameters.Add(outValue);
                    cmd.ExecuteScalar();
                    retorno = outValue.Value.ToString();
                }
                catch (Exception ex)
                {
                    retorno = ex.Message.ToString();
                }
                finally
                {
                    conn.Close();
                }

            }
            return retorno;
        }
        protected void myLinkTagBtn_Click(object sender, EventArgs e)
        {
            if (txtDescricaoInsert.Enabled)
            {
                btnOK.Enabled = false;
                string oper = (this.Master.FindControl("hfOperacao") as HiddenField).Value;
                txtOperadorInsert.Text = hfUser.Value;
                hfCodInterno.Value = CarregaCodInterno("2", 1);
                hfOPIDCONT.Value = hfCodInterno.Value;
                Session["ID"] = hfCodInterno.Value;
                hfProduto.Value = "9999";
                hfCHIDCODI.Value = "9999";
                string sql = null;
                try
                {
                    sql = "";
                    string execucao = DataBase.Consultas.InsertContrato(str_conn, sql);
                    if (execucao == "Sucesso")
                    {
                        ddeEstruturaInsert.Enabled = false;
                        BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
                        btnOK.Enabled = false;
                        hfInsertOK.Value = "1";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { $('#cardContrato .show').removeClass('show');$('[id *= panelActive2]').val('collapseInsertBases'); });", true);
                    }
                    else
                    {
                        MsgException(execucao, 1);
                    }

                }
                catch (Exception ex)
                {
                    MsgException(ex.Message.ToString(), 1);
                    //Response.Redirect(Request.RawUrl);
                }
                clickOK = 1;
            }
        }
        protected string CarregaCodInterno(string p_ngcdtinu, double p_tvidestr)
        {
            string retorno = null;
            string storedProc = "FUNC_NUMERADOR";
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                OleDbParameter outValue = new OleDbParameter("@return_val", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                conn.Open();
                OleDbCommand cmd = new OleDbCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = storedProc;
                cmd.Parameters.AddWithValue("@p_ngcdtinu", p_ngcdtinu);
                cmd.Parameters.AddWithValue("@p_tvidestr", p_tvidestr);
                cmd.Parameters.Add(outValue);
                cmd.ExecuteScalar();
                retorno = outValue.Value.ToString();
                conn.Close();
            }
            return retorno;
        }
        protected void CarregaContrato(int Index, bool RowIndex, bool alterado = false)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            if (RowIndex)
            {
                ASPxGridView grid = (ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
                hfOPCDCONT.Value = grid.GetRowValues(Index, "OPCDCONT").ToString();
                hfTVDSESTR.Value = grid.GetRowValues(Index, "TVDSESTR").ToString();
                OPNMCONT.Value = grid.GetRowValues(Index, "OPNMCONT").ToString();
                hfPRPRODID.Value = grid.GetRowValues(Index, "PRPRODID").ToString();
                hfOPIDCONT.Value = grid.GetRowValues(Index, "OPIDCONT").ToString();
                Session["ID"] = hfOPIDCONT.Value;
            }
            else
            {
                var arrayResult = DataBase.Consultas.Consulta(str_conn, "SELECT O.OPCDCONT, T.TVDSESTR, O.OPNMCONT, O.PRPRODID,O.OPIDCONT FROM OPCONTRA O, TVESTRUT T, PRPRODUT P WHERE T.TVIDESTR=O.TVIDESTR AND O.PRPRODID=P.prprodid and O.OPIDCONT=" + Index + "", 5);
                hfOPCDCONT.Value = arrayResult[0];
                hfTVDSESTR.Value = arrayResult[1];
                OPNMCONT.Value = arrayResult[2];
                hfPRPRODID.Value = arrayResult[3];
                hfOPIDCONT.Value = arrayResult[4];
                Session["ID"] = hfOPIDCONT.Value;
            }
            CultureInfo cultureInfo = CultureInfo.GetCultureInfo(lang);
            dropAgenteFinanceiroInsert2.DataBind();
            hfCodInterno.Value = hfOPIDCONT.Value;
            hfCHIDCODI.Value = DataBase.Consultas.Consulta(str_conn, "select chidcodi from PRPRODUT where prprodid=" + hfPRPRODID.Value, 1)[0];
            string query1 = "select O.TVIDESTR,T.TVDSESTR, O.USIDUSUA,O.OPCDCONT,O.OPCDAUXI,O.OPNMCONT,O.OPDTBACO,O.OPVLCONT,O.CMTPIDCM,O.PRTPIDOP,O.FOIDFORN,O.OPTPTPID, " +
                            "RI.TPIDIMOV,RI.REREGIAO,RI.RECONTRI,RI.REENDERC,RI.RECEPZIP,RI.RELOGRAD,RI.REANOCTR,RI.RESITLEG,RI.REPROREG,RI.RETESTAD,RI.REM2TERR,RI.REM2EDIF, " +
                            "RI.REM2COMU,RI.REFRACAO,RI.REDTREGI,RI.REVVENAL,RP.REDTVIST,RP.REDTRECH,RP.REDTDVCH,RP.REDTINAU,RI.REIDIMOV, O.USIDUSUA " +
                            "from OPCONTRA O, TVESTRUT T,REIMOVEL RI, REPOSSES RP, REVIOPIM RV " +
                            "WHERE O.OPIDCONT = " + hfOPIDCONT.Value + " AND T.TVIDESTR = O.TVIDESTR " +
                            "AND O.OPIDCONT = RV.OPIDCONT " +
                            "AND RV.REIDIMOV = RI.REIDIMOV " +
                            "AND RV.REIDIMOV = RP.REIDIMOV";
            string[] result = Consultas.Consulta(str_conn, query1, 34);
            if (result[result.Length - 1] != null)
            {
                hfDropEstr.Value = result[0];
                ddeEstruturaInsert.Value = result[0];
                ddeEstruturaInsert.Text = result[1];
                txtOperadorInsert.Text = result[2];
                txtNumProcessoInsert.Text = result[3];
                txtCodAuxInsert.Text = result[4];
                txtDescricaoInsert.Text = result[5];
                txtDataSolic.Text = Convert.ToDateTime(result[6]).ToShortDateString();
                txtValorCont.Text = result[7];
                dropEstruturaInsert2.Value = result[8];
                sqlClasseProdutosInsert.SelectParameters[0].DefaultValue = result[8];
                sqlClasseProdutosInsert.SelectParameters[1].DefaultValue = hfPaisUser.Value;
                dropClasseProdutoInsert2.DataBind();
                dropClasseProdutoInsert2.Value = result[9];
                dropAgenteFinanceiroInsert2.Value = result[10];
                sqlTipoInsert.SelectParameters[0].DefaultValue = result[8];
                sqlTipoInsert.SelectParameters[1].DefaultValue = hfPaisUser.Value;
                dropTipoInsert2.DataBind();
                dropTipoInsert2.Value = result[11];
                dropTipoImov.Value = result[12];
                txtRegAdmin.Text = result[13];
                txtNoContribu.Text = result[14];
                ddeGeoLocal.Text = result[15];
                txtCep.Text = result[16];
                dropLogradoura.Value = result[17];
                txtAnoConst.Text = result[18];
                dropSituacao.Value = result[19];
                txtNoProcRegis.Text = result[20];
                txtTestadaPrinc.Text = result[21];
                txtAreaTerreno.Text = result[22];
                txtAreaEdificada.Text = result[23];
                txtAreaComum.Text = result[24];
                txtFracIdeal.Text = result[25];
                txtDataRegis.Text = Convert.ToDateTime(result[26]).ToShortDateString();
                txtValorVenal.Text = result[27];
                txtDataVistoria.Text = Convert.ToDateTime(result[28]).ToShortDateString();
                txtDataReceb.Text = Convert.ToDateTime(result[29]).ToShortDateString();
                txtDataDevol.Text = Convert.ToDateTime(result[30]).ToShortDateString();
                txtDataInaug.Text = Convert.ToDateTime(result[31]).ToShortDateString();
                hfIDImovel.Value = result[32];                
                BasesNegociacaoEdit(hfCodInterno.Value, 1);
                btnEdit.Enabled = hfUser.Value==result[33] && perfil != "3";
                btnDelete.Enabled = hfUser.Value == result[33] && perfil != "3";
                btnInsert.Enabled = false;
            }
            RequiredFieldValidator2.Enabled = true;
            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "0";
            btnOK.Enabled = false;
            btnCancelar.Enabled = true;
            ((ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1")).DataBind();
            if (alterado)
            {
                btnOK1.Enabled = false;
                btnCancelar.Enabled = false;
                ddeEstruturaInsert.Enabled = false;
                txtDataInaug.Enabled = false;
                txtDataDevol.Enabled = false;
                txtDataReceb.Enabled = false;
                txtDataVistoria.Enabled = false;
                dropTipoImov.Enabled = false;
                txtRegAdmin.Enabled = false;
                txtNoContribu.Enabled = false;
                ddeGeoLocal.Enabled = false;
                txtCep.Enabled = false;
                dropLogradoura.Enabled = false;
                txtAnoConst.Enabled = false;
                dropSituacao.Enabled = false;
                txtNoProcRegis.Enabled = false;
                txtTestadaPrinc.Enabled = false;
                txtAreaTerreno.Enabled = false;
                txtAreaEdificada.Enabled = false;
                txtAreaComum.Enabled = false;
                txtFracIdeal.Enabled = false;
                txtDataRegis.Enabled = false;
                txtValorVenal.Enabled = false;
                txtNumProcessoInsert.Enabled = false;
                txtCodAuxInsert.Enabled = false;
                txtDescricaoInsert.Enabled = false;
                txtDataSolic.Enabled = false;
                txtValorCont.Enabled = false;
                dropEstruturaInsert2.Enabled = false;
                dropClasseProdutoInsert2.Enabled = false;
                dropAgenteFinanceiroInsert2.Enabled = false;
                gridWWF.Enabled = false;
            }
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {

                if (hfCodInterno.Value != string.Empty)
                {
                    if (Convert.ToInt32(Consultas.Consulta(str_conn, "select count(opidcont) from opcontra where opidcont=" + hfCodInterno.Value, 1)[0]) > 1)
                    {
                        MsgException("Contract already exists!", 1);
                        Response.Redirect("RequisitaContrato");
                    }
                    if (hfInsertOK.Value == "1")
                    {
                        CarregaContrato(Convert.ToInt32(hfCodInterno.Value), false);
                        return;
                    }
                }
                hfCodInterno.Value = CarregaCodInterno("2", 1);
                hfOPIDCONT.Value = hfCodInterno.Value;
                Session["ID"] = hfCodInterno.Value;
                hfProduto.Value = "9999";
                hfCHIDCODI.Value = "9999";
                hfDropEstr.Value = ddeEstruturaInsert.KeyValue.ToString();
                string sqlOpcontra = null;
                try
                {
                    string sqlImovel = "INSERT INTO REIMOVEL(TVIDESTR,TPIDIMOV,REREGIAO,RECONTRI,REENDERC,RECEPZIP,RELOGRAD,REANOCTR,RESITLEG,REPROREG,RETESTAD,REM2TERR,REM2EDIF,REM2COMU,REFRACAO,REVVENAL,REDTREGI) " +
                    "VALUES(@TVIDESTR, @TPIDIMOV, @REREGIAO, @RECONTRI, @REENDERC, @RECEPZIP, @RELOGRAD, @REANOCTR, @RESITLEG, @REPROREG, @RETESTAD, @REM2TERR, @REM2EDIF, @REM2COMU, @REFRACAO, @REVVENAL, convert(date, '@REDTREGI', 103))";
                    string TVIDESTR = hfDropEstr.Value;
                    string TPIDIMOV = dropTipoImov.Value.ToString();
                    string REREGIAO = txtRegAdmin.Text == string.Empty ? "NULL" : "'" + txtRegAdmin.Text + "'";
                    string RECONTRI = txtNoContribu.Text == string.Empty ? "NULL" : "'" + txtNoContribu.Text + "'";
                    string REENDERC = ddeGeoLocal.Text == string.Empty ? "NULL" : "'" + ddeGeoLocal.Text + "'";
                    string RECEPZIP = txtCep.Text == string.Empty ? "NULL" : "'" + txtCep.Text + "'";
                    string RELOGRAD = dropLogradoura.Value.ToString() == string.Empty ? "NULL" : "'" + dropLogradoura.Value.ToString() + "'";
                    string REANOCTR = txtAnoConst.Text == string.Empty ? "NULL" : txtAnoConst.Text;
                    string RESITLEG = dropSituacao.SelectedItem.Value.ToString() == string.Empty ? "NULL" : "'" + dropSituacao.SelectedItem.Value.ToString() + "'";
                    string REPROREG = txtNoProcRegis.Text == string.Empty ? "NULL" : "'" + txtNoProcRegis.Text + "'";
                    string RETESTAD = txtTestadaPrinc.Text == string.Empty ? "NULL" : txtTestadaPrinc.Text;
                    string REM2TERR = txtAreaTerreno.Text == string.Empty ? "NULL" : txtAreaTerreno.Text;
                    string REM2EDIF = txtAreaEdificada.Text == string.Empty ? "NULL" : txtAreaEdificada.Text;
                    string REM2COMU = txtAreaComum.Text == string.Empty ? "NULL" : txtAreaComum.Text;
                    string REFRACAO = txtFracIdeal.Text == string.Empty ? "NULL" : txtFracIdeal.Text;
                    string REVVENAL = txtValorVenal.Text == string.Empty ? "NULL" : txtValorVenal.Text;
                    string REDTREGI = txtDataRegis.Text == string.Empty ? "NULL" : txtDataRegis.Text;
                    sqlImovel = sqlImovel.Replace("@TVIDESTR", TVIDESTR);
                    sqlImovel = sqlImovel.Replace("@TPIDIMOV", TPIDIMOV);
                    sqlImovel = sqlImovel.Replace("@REREGIAO", REREGIAO);
                    sqlImovel = sqlImovel.Replace("@RECONTRI", RECONTRI);
                    sqlImovel = sqlImovel.Replace("@REENDERC", REENDERC);
                    sqlImovel = sqlImovel.Replace("@RECEPZIP", RECEPZIP.Replace("-", ""));
                    sqlImovel = sqlImovel.Replace("@RELOGRAD", RELOGRAD);
                    sqlImovel = sqlImovel.Replace("@REANOCTR", REANOCTR);
                    sqlImovel = sqlImovel.Replace("@RESITLEG", RESITLEG);
                    sqlImovel = sqlImovel.Replace("@REPROREG", REPROREG);
                    sqlImovel = sqlImovel.Replace("@RETESTAD", RETESTAD.Replace(",", "."));
                    sqlImovel = sqlImovel.Replace("@REM2TERR", REM2TERR.Replace(",", "."));
                    sqlImovel = sqlImovel.Replace("@REM2EDIF", REM2EDIF.Replace(",", "."));
                    sqlImovel = sqlImovel.Replace("@REM2COMU", REM2COMU.Replace(",", "."));
                    sqlImovel = sqlImovel.Replace("@REFRACAO", REFRACAO.Replace(",", "."));
                    sqlImovel = sqlImovel.Replace("@REVVENAL", REVVENAL.Replace(",", "."));
                    sqlImovel = sqlImovel.Replace("@REDTREGI", Convert.ToDateTime(REDTREGI, CultureInfo.GetCultureInfo("pt-BR")).ToString("dd/MM/yyyy"));


                    string execucao = Consultas.InsertInto(str_conn, sqlImovel);
                    if (execucao == "OK")
                    {
                        hfIDImovel.Value = DataBase.Consultas.Consulta(str_conn, "select max(REIDIMOV) from REIMOVEL", 1)[0];
                        if (hfIDImovel.Value != string.Empty)
                        {
                            string sqlInsPosse = "INSERT INTO REPOSSES(REIDIMOV,REDTVIST,REDTRECH,REDTDVCH,REDTINAU) " +
                            "VALUES(@REIDIMOV, convert(date, '@REDTVIST', 103), convert(date, '@REDTRECH', 103), convert(date, '@REDTDVCH', 103), convert(date, '@REDTINAU', 103))";
                            sqlInsPosse = sqlInsPosse.Replace("@REIDIMOV", hfIDImovel.Value);
                            sqlInsPosse = sqlInsPosse.Replace("@REDTVIST", Convert.ToDateTime(txtDataVistoria.Text).ToString("dd/MM/yyyy"));
                            sqlInsPosse = sqlInsPosse.Replace("@REDTRECH", Convert.ToDateTime(txtDataReceb.Text).ToString("dd/MM/yyyy"));
                            sqlInsPosse = sqlInsPosse.Replace("@REDTDVCH", Convert.ToDateTime(txtDataDevol.Text).ToString("dd/MM/yyyy"));
                            sqlInsPosse = sqlInsPosse.Replace("@REDTINAU", Convert.ToDateTime(txtDataInaug.Text).ToString("dd/MM/yyyy"));
                            execucao = DataBase.Consultas.InsertInto(str_conn, sqlInsPosse);
                            string sqlInsFolder = "INSERT INTO REFOLDER(REIDIMOV,REFOLDER)VALUES(@REIDIMOV,'@REFOLDER')";
                            sqlInsFolder = sqlInsFolder.Replace("@REIDIMOV", hfIDImovel.Value);
                            string dirNew = hfIDImovel.Value + DateTime.Now.ToString("ddMMyyyyHHmmssfff");
                            sqlInsFolder = sqlInsFolder.Replace("@REFOLDER", dirNew);
                            execucao = DataBase.Consultas.InsertInto(str_conn, sqlInsFolder);
                            if (execucao == "OK")
                            {
                                string dir = Server.MapPath("GED");
                                if (Directory.Exists(Path.Combine(dir, dirNew)))
                                    Directory.Delete(Path.Combine(dir, dirNew), true);
                                Directory.CreateDirectory(Path.Combine(dir, dirNew));

                            }
                            sqlOpcontra = "INSERT INTO OPCONTRA (OPIDCONT,TVIDESTR,USIDUSUA,OPCDCONT,OPCDAUXI,OPNMCONT,OPDTBACO,CMTPIDCM,PRTPIDOP,FOIDFORN,OPTPTPID,PRPRODID,OPVLCONT) " +
"VALUES(@OPIDCONT,@TVIDESTR, '@USIDUSUA', '@OPCDCONT', '@OPCDAUXI', '@OPNMCONT', convert(date, '@OPDTBACO', 103), @CMTPIDCM, @PRTPIDOP, @FOIDFORN, 99,@PRPRODID,@OPVLCONT)";
                            sqlOpcontra = sqlOpcontra.Replace("@OPIDCONT", hfCodInterno.Value);
                            sqlOpcontra = sqlOpcontra.Replace("@TVIDESTR", hfDropEstr.Value);
                            sqlOpcontra = sqlOpcontra.Replace("@USIDUSUA", hfUser.Value);
                            sqlOpcontra = sqlOpcontra.Replace("@OPCDCONT", txtNumProcessoInsert.Text);
                            sqlOpcontra = sqlOpcontra.Replace("@OPCDAUXI", txtCodAuxInsert.Text);
                            sqlOpcontra = sqlOpcontra.Replace("@OPNMCONT", txtDescricaoInsert.Text);
                            sqlOpcontra = sqlOpcontra.Replace("@OPDTBACO", Convert.ToDateTime(txtDataSolic.Text).ToString("dd/MM/yyyy"));
                            sqlOpcontra = sqlOpcontra.Replace("@CMTPIDCM", dropEstruturaInsert2.SelectedItem.Value.ToString());
                            sqlOpcontra = sqlOpcontra.Replace("@PRTPIDOP", dropClasseProdutoInsert2.SelectedItem.Value.ToString());
                            sqlOpcontra = sqlOpcontra.Replace("@FOIDFORN", dropAgenteFinanceiroInsert2.SelectedItem.Value.ToString());
                            sqlOpcontra = sqlOpcontra.Replace("@OPVLCONT", txtValorCont.Text.Replace(".", "").Replace(",", "."));
                            sqlOpcontra = sqlOpcontra.Replace("@PRPRODID", hfProduto.Value);
                            execucao = Consultas.InsertContrato(str_conn, sqlOpcontra);
                            if (execucao == "Sucesso")
                            {
                                string sqlInsImovel = "INSERT INTO REVIOPIM (REIDIMOV,OPIDCONT) VALUES (@REIDIMOV,@OPIDCONT)";
                                sqlInsImovel = sqlInsImovel.Replace("@OPIDCONT", hfOPIDCONT.Value);
                                sqlInsImovel = sqlInsImovel.Replace("@REIDIMOV", hfIDImovel.Value);
                                string exec = Consultas.InsertInto(str_conn, sqlInsImovel);
                                BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
                                DateTime dt = Convert.ToDateTime(txtDataSolic.Text);
                                int cont = 0;
                                foreach (RepeaterItem item in rptTimeLine.Items)
                                {
                                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                                    {
                                        string sqlTask = "INSERT INTO WFTASKOP(OPIDCONT,OPNMCONT,USIDUSUA,WFIDPRIO,WFIDFLOW,WFDTTASK,WFSTTASK) " +
                                                 "VALUES(@OPIDCONT, '@OPNMCONT', '@USIDUSUA', @WFIDPRIO, @WFIDFLOW, convert(datetime, '@WFDTTASK', 103),@WFSTTASK)";
                                        ASPxTextBox txtDt = (ASPxTextBox)item.FindControl("txtQtdDias");
                                        dt = dt.AddDays(Convert.ToInt32(txtDt.Text));
                                        ASPxComboBox dropResp = (ASPxComboBox)item.FindControl("dropResponsavel3");
                                        ASPxComboBox dropPri = (ASPxComboBox)item.FindControl("dropPriori2");
                                        HiddenField IdTarefa = (HiddenField)item.FindControl("hfIdTarefa");
                                        sqlTask = sqlTask.Replace("@OPIDCONT", hfCodInterno.Value);
                                        sqlTask = sqlTask.Replace("@OPNMCONT", txtDescricaoInsert.Text);
                                        sqlTask = sqlTask.Replace("@USIDUSUA", dropResp.SelectedItem.Value.ToString());
                                        sqlTask = sqlTask.Replace("@WFIDPRIO", dropPri.SelectedItem.Value.ToString());
                                        sqlTask = sqlTask.Replace("@WFIDFLOW", IdTarefa.Value);
                                        sqlTask = sqlTask.Replace("@WFDTTASK", dt.ToString("dd/MM/yyyy"));
                                        sqlTask = sqlTask.Replace("@WFSTTASK", cont == 0?"0":"-2");
                                        execucao = DataBase.Consultas.InsertInto(str_conn, sqlTask);
                                        if(execucao=="OK")
                                        {
                                            Funcoes.NotifySome(hfUser.Value,
                                    dropResp.SelectedItem.Value.ToString(),
    str_conn,
    1,
    DataBase.Consultas.Consulta(str_conn, "select wf.WFDSFLOW from WORKFLOW wf, WFTASKOP wo where wf.WFIDFLOW=wo.WFIDFLOW and wo.WFIDTASK=" + IdTarefa.Value, 1)[0],
    hfCodInterno.Value);
                                        }
                                    }
                                    cont++;
                                }
                                ddeEstruturaInsert.Enabled = false;
                                txtNumProcessoInsert.Enabled = false;
                                txtCodAuxInsert.Enabled = false;
                                txtDescricaoInsert.Enabled = false;
                                txtDataSolic.Enabled = false;
                                txtValorCont.Enabled = false;
                                dropEstruturaInsert2.Enabled = false;
                                dropClasseProdutoInsert2.Enabled = false;
                                dropAgenteFinanceiroInsert2.Enabled = false;
                                btnInsert.Enabled = false;
                                btnOK.Enabled = false;
                                btnCancelar.Enabled = false;
                                CarregaContrato(Convert.ToInt32(hfCodInterno.Value), false, true);
                                popupTimeLine.ShowOnPageLoad = false;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { $('#cardContrato .show').removeClass('show');$('[id *= panelActive1]').val('#collapseInsertBases'); });", true);
                            }
                            else
                            {
                                MsgException(execucao, 1);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    MsgException(ex.Message.ToString(), 1);
                    //Response.Redirect(Request.RawUrl);
                }
            }
        }
        protected void btnselecionar_Click(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
            int Index = Convert.ToInt32(grid.FocusedRowIndex);
            ddePesqContrato.Text = grid.GetRowValues(grid.FocusedRowIndex, "OPCDCONT").ToString();
            hfIndexGrid.Value = Index.ToString();
            if (hfIndexGrid.Value != null)
            {
                CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
            }
        }
        protected void gridWWF_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            gridWWF.JSProperties["cp_origem"] = e.ButtonID;
            string sqlUpdTask, sqlUpdTask2, exec;
            switch (e.ButtonID)
            {
                case "alterar":
                    Session["visibleIndex"] = e.VisibleIndex.ToString();                    
                    gridWWF.JSProperties["cp_visibleIndex"] = e.VisibleIndex.ToString();
                    gridWWF.JSProperties["cp_responsavel"] = gridWWF.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString();
                    gridWWF.JSProperties["cp_prioridade"] = gridWWF.GetRowValues(e.VisibleIndex, "WFIDPRIO").ToString();
                    gridWWF.JSProperties["cp_prazo"] = gridWWF.GetRowValues(e.VisibleIndex, "WFDTTASK").ToString();
                    break;
                case "aprovar":
                    int final = Convert.ToInt32(Consultas.Consulta(str_conn, "select WFIDNEXT from WORKFLOW where WFIDFLOW = " + gridWWF.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString(), 1)[0]);
                    if (final > 0)
                    {
                        sqlUpdTask = "UPDATE WFTASKOP SET WFSTTASK = 1 WHERE WFIDTASK=" + gridWWF.GetRowValues(e.VisibleIndex, "WFIDTASK").ToString();
                        sqlUpdTask2 = "UPDATE WFTASKOP SET WFSTTASK = 0 " +
    "where OPIDCONT = " + gridWWF.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString() + " " +
    "AND WFIDFLOW in  " +
    "(select WFIDNEXT from WORKFLOW where WFIDFLOW = " + gridWWF.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString() + ")";
                        exec = Consultas.UpdtFrom(str_conn, sqlUpdTask);
                        if (exec == "OK")
                        {
                            exec = Consultas.UpdtFrom(str_conn, sqlUpdTask2);
                            if (exec == "OK")
                            {
                                Funcoes.NotifySome(hfUser.Value,
                                    gridWWF.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString(),
    str_conn,
    3,
    DataBase.Consultas.Consulta(str_conn, "select wf.WFDSFLOW from WORKFLOW wf, WFTASKOP wo where wf.WFIDFLOW=wo.WFIDFLOW and wo.WFIDTASK=" + gridWWF.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString(), 1)[0],
    gridWWF.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString());
                                gridWWF.JSProperties["cp_ok"] = "OK";
                                gridWWF.JSProperties["cp_final"] = "não";
                                MsgException("Alerta de alteração da tarefa enviada via SMS / E-mail.", 2);
                            }
                        }
                    }
                    else if (final<0)
                    {
                        gridWWF.JSProperties["cp_ok"] = "OK";
                        gridWWF.JSProperties["cp_final"] = "sim";
                        gridWWF.JSProperties["cp_visibleIndex"] = e.VisibleIndex;
                    }
                    break;
                case "recusar":
                    sqlUpdTask = "UPDATE WFTASKOP SET WFSTTASK = -1 WHERE WFIDTASK=" + gridWWF.GetRowValues(e.VisibleIndex, "WFIDTASK").ToString();
                    sqlUpdTask2 = "UPDATE WFTASKOP SET WFSTTASK = 0 " +
"where OPIDCONT = "+ gridWWF.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString() + " " +
"AND WFIDFLOW in  " +
"(select WFIDFLOW from WORKFLOW where WFIDNEXT = "+ gridWWF.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString() + ")";
                    exec = Consultas.UpdtFrom(str_conn, sqlUpdTask);
                    if (exec == "OK")
                    {
                        exec = Consultas.UpdtFrom(str_conn, sqlUpdTask2);
                        if (exec == "OK")
                        {
                            Funcoes.NotifySome(hfUser.Value,
                                    gridWWF.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString(),
    str_conn,
    2,
    DataBase.Consultas.Consulta(str_conn, "select wf.WFDSFLOW from WORKFLOW wf, WFTASKOP wo where wf.WFIDFLOW=wo.WFIDFLOW and wo.WFIDTASK=" + gridWWF.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString(), 1)[0],
    gridWWF.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString());
                            gridWWF.JSProperties["cp_ok"] = "OK";
                            MsgException("Alerta de alteração da tarefa enviada via SMS / E-mail.", 2);
                        }
                    }
                    break;
            }
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("RequisitaContrato");
        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (txtDataReceb.Text == string.Empty)
            {
                args.IsValid = false;
                CustomValidator1.ErrorMessage = "Data Recebimento Chaves não pode ser nulo";
            }
            else if (txtDataSolic.Text == string.Empty)
            {
                args.IsValid = false;
                CustomValidator1.ErrorMessage = "Data Solicitação não pode ser nulo";
            }
            else
            {
                DateTime dt = Convert.ToDateTime(txtDataSolic.Text);
                foreach (RepeaterItem item in rptTimeLine.Items)
                {
                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                    {
                        ASPxTextBox txtDt = (ASPxTextBox)item.FindControl("txtQtdDias");
                        dt = dt.AddDays(Convert.ToInt32(txtDt.Text));
                    }
                }
                DateTime dtSolic = Convert.ToDateTime(txtDataSolic.Text);
                DateTime dtGoal = Convert.ToDateTime(txtDataReceb.Text).AddDays(-1);
                var compara = DateTime.Compare(dt, dtGoal);
                if (compara > 0)
                {
                    args.IsValid = false;
                    CustomValidator1.ErrorMessage = "Data alvo " + dtGoal.ToShortDateString() + " não poderá ser alcançado.<br /> Time Line será concluído em " + dt.ToShortDateString();
                }
                else
                {
                    args.IsValid = true;
                }
            }
        }
        protected void btnOK1_Click(object sender, EventArgs e)
        {
            switch (hfOperacao.Value)
            {
                case "inserir":
                    lblDtRecebePopup.Text = txtDataReceb.Text;
                    popupTimeLine.ShowOnPageLoad = true;
                    break;
                case "alterar":
                    string sqluptImov = "UPDATE REIMOVEL " +
   "SET TPIDIMOV = @TPIDIMOV " +
      ", REREGIAO = '@REREGIAO' " +
      ", RECONTRI = '@RECONTRI' " +
      ", REENDERC = '@REENDERC' " +
      ", RECEPZIP = '@RECEPZIP' " +
      ", RELOGRAD = '@RELOGRAD' " +
      ", REANOCTR = @REANOCTR " +
      ", RESITLEG = '@RESITLEG' " +
      ", REPROREG = '@REPROREG' " +
      ", RETESTAD = @RETESTAD " +
      ", REM2TERR = @REM2TERR " +
      ", REM2EDIF = @REM2EDIF " +
      ", REM2COMU = @REM2COMU " +
      ", REFRACAO = @REFRACAO " +
      ", REVVENAL = @REVVENAL " +
      ", REDTREGI = convert(datetime, '@REDTREGI', 103) " +
 "WHERE REIDIMOV = " + hfIDImovel.Value;
                    sqluptImov = sqluptImov.Replace("@TPIDIMOV", dropTipoImov.SelectedItem.Value.ToString());
                    sqluptImov = sqluptImov.Replace("@REREGIAO", txtRegAdmin.Text);
                    sqluptImov = sqluptImov.Replace("@RECONTRI", txtNoContribu.Text);
                    sqluptImov = sqluptImov.Replace("@REENDERC", ddeGeoLocal.Text);
                    sqluptImov = sqluptImov.Replace("@RECEPZIP", txtCep.Text.Replace("-", ""));
                    sqluptImov = sqluptImov.Replace("@RELOGRAD", dropLogradoura.SelectedItem.Value.ToString());
                    sqluptImov = sqluptImov.Replace("@REANOCTR", txtAnoConst.Text);
                    sqluptImov = sqluptImov.Replace("@RESITLEG", dropSituacao.SelectedItem.Value.ToString());
                    sqluptImov = sqluptImov.Replace("@REPROREG", txtNoProcRegis.Text);
                    sqluptImov = sqluptImov.Replace("@RETESTAD", lang == "en-US" ? txtTestadaPrinc.Text.Replace(",", "") : txtTestadaPrinc.Text.Replace(".", "").Replace(",", "."));
                    sqluptImov = sqluptImov.Replace("@REM2TERR", lang == "en-US" ? txtAreaTerreno.Text.Replace(",", "") : txtAreaTerreno.Text.Replace(".", "").Replace(",", "."));
                    sqluptImov = sqluptImov.Replace("@REM2EDIF", lang == "en-US" ? txtAreaEdificada.Text.Replace(",", "") : txtAreaEdificada.Text.Replace(".", "").Replace(",", "."));
                    sqluptImov = sqluptImov.Replace("@REM2COMU", lang == "en-US" ? txtAreaComum.Text.Replace(",", "") : txtAreaComum.Text.Replace(".", "").Replace(",", "."));
                    sqluptImov = sqluptImov.Replace("@REFRACAO", lang == "en-US" ? txtFracIdeal.Text.Replace(",", "") : txtFracIdeal.Text.Replace(".", "").Replace(",", "."));
                    sqluptImov = sqluptImov.Replace("@REVVENAL", lang == "en-US" ? txtValorVenal.Text.Replace(",", "") : txtValorVenal.Text.Replace(".", "").Replace(",", "."));
                    sqluptImov = sqluptImov.Replace("@REDTREGI", Convert.ToDateTime(txtDataRegis.Text).ToString("dd/MM/yyyy"));
                    string sqluptPoss = "UPDATE REPOSSES " +
   "SET REDTVIST = convert(datetime, '@REDTVIST', 103) " +
      ", REDTRECH = convert(datetime, '@REDTRECH', 103) " +
      ", REDTDVCH = convert(datetime, '@REDTDVCH', 103) " +
      ", REDTINAU = convert(datetime, '@REDTINAU', 103) " +
 "WHERE REIDIMOV = " + hfIDImovel.Value;
                    sqluptPoss = sqluptPoss.Replace("@REDTVIST", Convert.ToDateTime(txtDataVistoria.Text).ToString("dd/MM/yyyy"));
                    sqluptPoss = sqluptPoss.Replace("@REDTRECH", Convert.ToDateTime(txtDataReceb.Text).ToString("dd/MM/yyyy"));
                    sqluptPoss = sqluptPoss.Replace("@REDTDVCH", Convert.ToDateTime(txtDataDevol.Text).ToString("dd/MM/yyyy"));
                    sqluptPoss = sqluptPoss.Replace("@REDTINAU", Convert.ToDateTime(txtDataInaug.Text).ToString("dd/MM/yyyy"));
                    string sqluptCont = "UPDATE OPCONTRA " +
   "SET OPCDCONT = '@OPCDCONT' " +
      ", OPCDAUXI = '@OPCDAUXI' " +
      ", OPNMCONT = '@OPNMCONT' " +
      ", FOIDFORN = @FOIDFORN " +
      ", OPDTBACO = convert(datetime, '@OPDTBACO', 103) " +
      ", OPVLCONT = @OPVLCONT " +
 "WHERE OPIDCONT = " + hfOPIDCONT.Value;
                    sqluptCont = sqluptCont.Replace("@OPCDCONT", txtNumProcessoInsert.Text);
                    sqluptCont = sqluptCont.Replace("@OPCDAUXI", txtCodAuxInsert.Text);
                    sqluptCont = sqluptCont.Replace("@OPNMCONT", txtDescricaoInsert.Text);
                    sqluptCont = sqluptCont.Replace("@FOIDFORN", dropAgenteFinanceiroInsert2.SelectedItem.Value.ToString());
                    sqluptCont = sqluptCont.Replace("@OPDTBACO", Convert.ToDateTime(txtDataSolic.Text).ToString("dd/MM/yyyy"));
                    sqluptCont = sqluptCont.Replace("@OPVLCONT", lang == "en-US" ? txtValorCont.Text.Replace(",", "") : txtValorCont.Text.Replace(".", "").Replace(",", "."));
                    string exec = Consultas.UpdtFrom(str_conn, sqluptImov);
                    exec = Consultas.UpdtFrom(str_conn, sqluptPoss);
                    exec = Consultas.UpdtFrom(str_conn, sqluptCont);
                    CarregaContrato(Convert.ToInt32(hfOPIDCONT.Value), false, true);
                    break;
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (Session["visibleIndex"] != null)
            {
                int visibleIndex = Convert.ToInt32(Session["visibleIndex"].ToString());
                bool trocouResp = dropResponsavel2.SelectedItem.Value.ToString() != gridWWF.GetRowValues(visibleIndex, "USIDUSUA").ToString();
                string USIDUSUA = dropResponsavel2.SelectedItem.Value.ToString() == gridWWF.GetRowValues(visibleIndex, "USIDUSUA").ToString() ? gridWWF.GetRowValues(visibleIndex, "USIDUSUA").ToString() : dropResponsavel2.SelectedItem.Value.ToString();
                string WFIDPRIO = dropPriori.SelectedItem.Value.ToString() == gridWWF.GetRowValues(visibleIndex, "WFIDPRIO").ToString() ? gridWWF.GetRowValues(visibleIndex, "WFIDPRIO").ToString() : dropPriori.SelectedItem.Value.ToString();
                string WFDTTASKstr = txtDataPrazo.Text == gridWWF.GetRowValues(visibleIndex, "WFDTTASK").ToString() ? gridWWF.GetRowValues(visibleIndex, "WFDTTASK").ToString() : txtDataPrazo.Text;
                DateTime WFDTTASK = Convert.ToDateTime(WFDTTASKstr);
                string sqlUpdTask = "UPDATE WFTASKOP " +
   "SET USIDUSUA = '@USIDUSUA' " +
      ", WFIDPRIO = @WFIDPRIO " +
      ", WFDTTASK = convert(datetime, '@WFDTTASK', 103) " +
 "WHERE WFIDTASK = @WFIDTASK";
                sqlUpdTask = sqlUpdTask.Replace("@USIDUSUA", USIDUSUA);
                sqlUpdTask = sqlUpdTask.Replace("@WFIDPRIO", WFIDPRIO);
                sqlUpdTask = sqlUpdTask.Replace("@WFDTTASK", WFDTTASK.ToString("dd/MM/yyyy"));
                sqlUpdTask = sqlUpdTask.Replace("@WFIDTASK", gridWWF.GetRowValues(visibleIndex, "WFIDTASK").ToString());
                string exec = Consultas.UpdtFrom(str_conn, sqlUpdTask);
                if (exec == "OK")
                {
                    if(trocouResp)
                    {
                        Funcoes.NotifySome(hfUser.Value, 
                            USIDUSUA, 
                            str_conn, 
                            1,
                            DataBase.Consultas.Consulta(str_conn, "select wf.WFDSFLOW from WORKFLOW wf, WFTASKOP wo where wf.WFIDFLOW=wo.WFIDFLOW and wo.WFIDTASK="+ gridWWF.GetRowValues(visibleIndex, "WFIDTASK").ToString(),1)[0],
                            gridWWF.GetRowValues(visibleIndex, "OPIDCONT").ToString());
                    }
                    string sqlLogUpd = "INSERT INTO WFALTTSK (WFIDTASK ,WFJUSTTK ,WFDTALTT ,USIDUSUA ,USIDUS02 ,WFIDPRIO ,WFDTDATA) " +
"VALUES(@WFIDTASK, '@WFJUSTTK', convert(datetime, '@WFDTALTT', 103), '@USIDUSUA', '@USIDUS02', @WFIDPRIO, convert(datetime, '@WFDTDATA', 103))";
                    sqlLogUpd = sqlLogUpd.Replace("@WFIDTASK", gridWWF.GetRowValues(visibleIndex, "WFIDTASK").ToString());
                    sqlLogUpd = sqlLogUpd.Replace("@WFJUSTTK", txtJusti.Text);
                    sqlLogUpd = sqlLogUpd.Replace("@WFDTALTT", DateTime.Now.ToString("dd/MM/yyyy"));
                    sqlLogUpd = sqlLogUpd.Replace("@USIDUSUA", hfUser.Value);
                    sqlLogUpd = sqlLogUpd.Replace("@USIDUS02", gridWWF.GetRowValues(visibleIndex, "USIDUSUA").ToString());
                    sqlLogUpd = sqlLogUpd.Replace("@WFIDPRIO", gridWWF.GetRowValues(visibleIndex, "WFIDPRIO").ToString());
                    sqlLogUpd = sqlLogUpd.Replace("@WFDTDATA", Convert.ToDateTime(gridWWF.GetRowValues(visibleIndex, "WFDTTASK").ToString()).ToString("dd/MM/yyyy"));
                    exec = Consultas.InsertInto(str_conn, sqlLogUpd);
                    gridWWF.DataBind();
                    popupAlterarWF.ShowOnPageLoad = false;
                }
            }
        }
        protected void gridWWF_DetailRowGetButtonVisibility(object sender, ASPxGridViewDetailRowButtonEventArgs e)
        {
            string ID = (sender as ASPxGridView).GetRowValues(e.VisibleIndex, "WFIDTASK").ToString();
            bool TemDetail = Convert.ToInt32(Consultas.Consulta(str_conn, "select count(*) from WFALTTSK where WFIDTASK=" + ID, 1)[0]) > 0;
            if (!TemDetail)
                e.ButtonState = GridViewDetailRowButtonState.Hidden;
        }
        protected void gridDetailWF_BeforePerformDataSelect(object sender, EventArgs e)
        {
            sqlDetailWf.SelectParameters[0].DefaultValue = (sender as ASPxGridView).GetMasterRowKeyValue().ToString();
        }
        protected void btnCancelar_Click1(object sender, EventArgs e)
        {
            popupTimeLine.ShowOnPageLoad = false;
        }
        protected void gridWWF_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            int status = Convert.ToInt32(gridWWF.GetRowValues(e.VisibleIndex, "WFSTTASK").ToString());
            int idFlow = Convert.ToInt32(gridWWF.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString());
            switch(status)
            {
                case 0:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = true;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = true;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = true;
                    }
                    break;
                case 1:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = false;
                    }
                    break;
                case -1:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = false;
                    }
                    break;
                case -2:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = true;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = false;
                    }
                    break;
            }
            if(e.ButtonID == "recusar" && idFlow==1)
            {
                e.Enabled = false;
            }
        }
        protected void btnInsert_Load(object sender, EventArgs e)
        {
            Button obj = (Button)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }
        protected void btnDelete_Load(object sender, EventArgs e)
        {
        }
        protected void btnEdit_Load(object sender, EventArgs e)
        {
        }
        protected void dropTipologia2_Callback(object sender, CallbackEventArgsBase e)
        {
            sqlProdutoInsert.SelectParameters[0].DefaultValue = dropEstruturaInsert2.SelectedItem.Value.ToString();
            sqlProdutoInsert.SelectParameters[1].DefaultValue = dropClasseProdutoInsert2.SelectedItem.Value.ToString();
            sqlProdutoInsert.SelectParameters[3].DefaultValue = hfDropEstr.Value;
            sqlProdutoInsert.DataBind();
            dropTipologia2.DataBind();
        }
        protected void btn_EmitirContrato_Click(object sender, EventArgs e)
        {
            if (dropTipologia2.SelectedItem==null) return;
            int Index = Convert.ToInt32(hfIndexGridWF.Value);
            DateTime dtEncerra = Convert.ToDateTime(txtDataEncerra.Text);
            DateTime dtPag1 = Convert.ToDateTime(txtPag1.Text);
            DateTime dtPag2 = Convert.ToDateTime(txtPag2.Text);
            string sqlUpdTask = "UPDATE WFTASKOP SET WFSTTASK = 1 WHERE WFIDTASK=" + gridWWF.GetRowValues(Index, "WFIDTASK").ToString();
            string sqlUpdOPCONTRA = "update opcontra set OPTPTPID=1 " +
                ",PRPRODID=" + dropTipologia2.SelectedItem.Value.ToString() + " " +
                ",CAIDCTRA=(select min(CAIDCTRA) from CACTEIRA WHERE TVIDESTR="+hfDropEstr.Value+") " +
                ",OPTPFRID=(select OPTPFRID from OPTPFRCO WHERE CMTPIDCM=" + dropEstruturaInsert2.SelectedItem.Value.ToString()+" AND PAIDPAIS="+hfPaisUser.Value+") " +
                ",OPTPRGID=(select OPTPRGID from OPTPRGCO WHERE CMTPIDCM=" + dropEstruturaInsert2.SelectedItem.Value.ToString()+" AND PAIDPAIS="+hfPaisUser.Value+") " +
                ",OPDTENCO= CONVERT(DATE,'"+dtEncerra.ToString("dd/MM/yyyy")+"',103) " +
                ",OPDTINPG= CONVERT(DATE,'" + dtPag1.ToString("dd/MM/yyyy")+"',103) " +
                ",OPDTFMPG= CONVERT(DATE,'" + dtPag2.ToString("dd/MM/yyyy")+"',103) " +
                ",OPDTASCO= CONVERT(DATE,'" + DateTime.Now.ToString("dd/MM/yyyy")+"',103) " +
                ",OPFLSLDI=1, OPFLCARE=0, OPFLPARC=1 " +
                " where OPIDCONT=" + gridWWF.GetRowValues(Index, "OPIDCONT").ToString();
//            string sqlUpdCJDIN = "select  "+
//"opidcont, d.chidcodi, d.cjidcodi, cjtpidtp, d.cjtpcttx, cjinprop, cjvlprop, c.cjdtprop, c.cjdtdtde, cjdtdtat, cjvldeat "+
//"from CJCLPROP_DIN D, CJCLPROP C where C.CHIDCODI = D.CHIDCODI AND C.CJIDCODI = D.CJIDCODI AND OPIDCONT ="+ gridWWF.GetRowValues(Index, "OPIDCONT").ToString();
            string sqlUpdCJDIN = "update CJCLPROP_DIN set CHIDCODI=(select chidcodi from PRPRODUT where prprodid="+dropTipologia2.SelectedItem.Value.ToString()+") where OPIDCONT=" + gridWWF.GetRowValues(Index, "OPIDCONT").ToString();
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdOPCONTRA);
            if(exec=="OK")
            {
                DateTime dtExpira = Convert.ToDateTime(txtDataEncerra.Text);
                DataBase.WorkflowAdmin wflow = new DataBase.WorkflowAdmin();
                wflow.str_conn = str_conn;
                wflow.OPIDCONT = gridWWF.GetRowValues(Index, "OPIDCONT").ToString();
                wflow.Encerramento = true;
                wflow.Usuario = hfUser.Value;
                wflow.DataExpira = dtExpira;
                wflow.Renova = 0;
                wflow.CriarWfw();
                exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdCJDIN);
                if(exec=="OK")
                {
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdTask);
                    if(exec=="OK")
                    {
                        Funcoes.NotifySome(hfUser.Value,
        gridWWF.GetRowValues(Index, "USIDUSUA").ToString(),
str_conn,
3,
DataBase.Consultas.Consulta(str_conn, "select wf.WFDSFLOW from WORKFLOW wf, WFTASKOP wo where wf.WFIDFLOW=wo.WFIDFLOW and wo.WFIDTASK=" + gridWWF.GetRowValues(Index, "WFIDFLOW").ToString(), 1)[0],
gridWWF.GetRowValues(Index, "OPIDCONT").ToString());
                        Response.Redirect(Request.Url.Segments[Request.Url.Segments.Length - 1]);
                    }
                }
            }            
        }
        protected void callBackGeoLocal_Callback(object sender, CallbackEventArgsBase e)
        {
            string latlong = "", address = "";
            string Zip = e.Parameter.ToString();
            if (Zip != string.Empty)
            {
                address = "https://maps.googleapis.com/maps/api/geocode/json?components=postal_code:" + Zip.Trim() + "&sensor=false&key=AIzaSyDjz5JIH7U_kZDGyHMaMizXy5a3DDLFjEM";
                using (WebClient webClient = new WebClient())
                {
                    webClient.Encoding = Encoding.UTF8;
                    var result = webClient.DownloadString(address);


                    Rootobject root = Newtonsoft.Json.JsonConvert.DeserializeObject<Rootobject>(result);

                    var lat = root.results[0].geometry.location.lat.ToString().Replace(",", ".");
                    var lng = root.results[0].geometry.location.lng.ToString().Replace(",", ".");

                    latlong = Convert.ToString(lat) + "," + Convert.ToString(lng);
                    callBackGeoLocal.JSProperties["cp_latlng"] = latlong;
                    ddeGeoLocal.Text = root.results[0].formatted_address;
                }
            }
        }
        protected void comboImovel_SelectedIndexChanged(object sender, EventArgs e)
        {
            string query1 = "select RI.TPIDIMOV,RI.REREGIAO,RI.RECONTRI,RI.REENDERC,RI.RECEPZIP,RI.RELOGRAD,RI.REANOCTR,RI.RESITLEG,RI.REPROREG,RI.RETESTAD,RI.REM2TERR,RI.REM2EDIF, " +
                            "RI.REM2COMU,RI.REFRACAO,RI.REDTREGI,RI.REVVENAL,RP.REDTVIST,RP.REDTRECH,RP.REDTDVCH,RP.REDTINAU " +
                            "from REIMOVEL RI, REPOSSES RP " +
                            "WHERE RI.REIDIMOV = " + comboImovel.SelectedItem.Value.ToString() + " " +
                            "AND RI.REIDIMOV = RP.REIDIMOV";
            string[] result = Consultas.Consulta(str_conn, query1, 20);
            if (result[result.Length - 1] != null)
            {                
                dropTipoImov.Value = result[0];
                dropTipoImov.Enabled = false;
                txtRegAdmin.Text = result[1];
                txtRegAdmin.Enabled = false;
                txtNoContribu.Text = result[2];
                txtNoContribu.Enabled = false;
                ddeGeoLocal.Text = result[3];
                ddeGeoLocal.Enabled = false;
                txtCep.Text = result[4];
                txtCep.Enabled = false;
                dropLogradoura.Value = result[5];
                dropLogradoura.Enabled = false;
                txtAnoConst.Text = result[6];
                txtAnoConst.Enabled = false;
                dropSituacao.Value = result[7];
                dropSituacao.Enabled = false;
                txtNoProcRegis.Text = result[8];
                txtNoProcRegis.Enabled = false;
                txtTestadaPrinc.Text = result[9];
                txtTestadaPrinc.Enabled = false;
                txtAreaTerreno.Text = result[10];
                txtAreaTerreno.Enabled = false;
                txtAreaEdificada.Text = result[11];
                txtAreaEdificada.Enabled = false;
                txtAreaComum.Text = result[12];
                txtAreaComum.Enabled = false;
                txtFracIdeal.Text = result[13];
                txtFracIdeal.Enabled = false;
                txtDataRegis.Text = Convert.ToDateTime(result[14]).ToShortDateString();
                txtDataRegis.Enabled = false;
                txtValorVenal.Text = result[15];
                txtValorVenal.Enabled = false;
                txtDataVistoria.Text = Convert.ToDateTime(result[16]).ToShortDateString();
                txtDataVistoria.Enabled = false;
                txtDataReceb.Text = Convert.ToDateTime(result[17]).ToShortDateString();
                txtDataReceb.Enabled = false;
                txtDataDevol.Text = Convert.ToDateTime(result[18]).ToShortDateString();
                txtDataDevol.Enabled = false;
                txtDataInaug.Text = Convert.ToDateTime(result[19]).ToShortDateString();
                txtDataInaug.Enabled = false;

            }
        }
    }
}