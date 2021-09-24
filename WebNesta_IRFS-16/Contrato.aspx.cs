using AjaxControlToolkit;
using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Contrato : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string user;
        public static string usuarioPersist;
        protected void Page_Init(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            else
                usuarioPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            user = usuarioPersist;
            hfUser2.Value = user;
            hfUser.Value = user;
            HttpCookie cookiePais = HttpContext.Current.Request.Cookies["PAIDPAIS"];
            if (cookiePais == null)
                hfPaisUser.Value = "1";
            else
                hfPaisUser.Value = cookiePais.Value;
            validaControles(0);
            AsyncPostBackTrigger tr1 = new AsyncPostBackTrigger();
            tr1.ControlID = btnInsert.UniqueID;
            updPanelGeral.Triggers.Add(tr1);
            AsyncPostBackTrigger tr2 = new AsyncPostBackTrigger();
            tr2.ControlID = btnDelete.UniqueID;
            updPanelGeral.Triggers.Add(tr2);
            AsyncPostBackTrigger tr3 = new AsyncPostBackTrigger();
            tr3.ControlID = btnEdit.UniqueID;
            updPanelGeral.Triggers.Add(tr3);
            AsyncPostBackTrigger tr4 = new AsyncPostBackTrigger();
            tr4.ControlID = btnReplicar.UniqueID;
            updPanelGeral.Triggers.Add(tr4);
            AsyncPostBackTrigger tr5 = new AsyncPostBackTrigger();
            tr5.ControlID = btnselecionar.UniqueID;
            updPanelGeral.Triggers.Add(tr5);
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
        }
        protected void Page_LoadComplete(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="msg">Mensagem que será exibida ao usuário através de Modal Popup Jquery</param>
        /// <param name="exc">Código para identificar se a mensagem é uma exception ou alerta, 0 = Alerta | 1 = Exception </param>
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
        protected void validaControles(int tipo)
        {
            switch (tipo)
            {
                case 0: //Consulta e Delete
                    foreach (var item in updPanelGeral.ContentTemplateContainer.Controls)
                    {
                        if (item.GetType() == typeof(TextBox))
                        {
                            TextBox txt = (TextBox)item as TextBox;
                            txt.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxComboBox")
                        {
                            ASPxComboBox combo = (ASPxComboBox)item as ASPxComboBox;
                            combo.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxTextBox")
                        {
                            ASPxTextBox combo = (ASPxTextBox)item as ASPxTextBox;
                            combo.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxDropDownEdit")
                        {
                            ASPxDropDownEdit dropE = (ASPxDropDownEdit)item as ASPxDropDownEdit;
                            dropE.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxUploadControl")
                        {
                            ASPxUploadControl upload = (ASPxUploadControl)item as ASPxUploadControl;
                            upload.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxGridView")
                        {
                            ASPxGridView grid = (ASPxGridView)item as ASPxGridView;
                            grid.SettingsDataSecurity.AllowInsert = false;
                            grid.SettingsDataSecurity.AllowEdit = false;
                            grid.SettingsDataSecurity.AllowDelete = false;
                            grid.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxCallbackPanel")
                        {
                            ASPxCallbackPanel cbPanel = (ASPxCallbackPanel)item as ASPxCallbackPanel;
                            foreach (var item2 in cbPanel.Controls)
                            {
                                if (item2.GetType().Name == "ASPxDropDownEdit")
                                {
                                    ASPxDropDownEdit dde = (ASPxDropDownEdit)item2 as ASPxDropDownEdit;
                                    dde.Enabled = false;
                                }
                            }
                        }
                    }
                    break;
                case 1: //Insert
                    foreach (var item in updPanelGeral.ContentTemplateContainer.Controls)
                    {
                        if (item.GetType() == typeof(TextBox))
                        {
                            TextBox txt = (TextBox)item as TextBox;
                            txt.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxComboBox")
                        {
                            ASPxComboBox combo = (ASPxComboBox)item as ASPxComboBox;
                            combo.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxTextBox")
                        {
                            ASPxTextBox combo = (ASPxTextBox)item as ASPxTextBox;
                            combo.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxDropDownEdit")
                        {
                            ASPxDropDownEdit dropE = (ASPxDropDownEdit)item as ASPxDropDownEdit;
                            dropE.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxUploadControl")
                        {
                            ASPxUploadControl upload = (ASPxUploadControl)item as ASPxUploadControl;
                            upload.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxGridView")
                        {
                            ASPxGridView grid = (ASPxGridView)item as ASPxGridView;
                            grid.SettingsDataSecurity.AllowInsert = true;
                            grid.SettingsDataSecurity.AllowEdit = true;
                            grid.SettingsDataSecurity.AllowDelete = true;
                            grid.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxCallbackPanel")
                        {
                            ASPxCallbackPanel cbPanel = (ASPxCallbackPanel)item as ASPxCallbackPanel;
                            foreach (var item2 in cbPanel.Controls)
                            {
                                if (item2.GetType().Name == "ASPxDropDownEdit")
                                {
                                    ASPxDropDownEdit dde = (ASPxDropDownEdit)item2 as ASPxDropDownEdit;
                                    dde.Enabled = true;
                                }
                            }
                        }
                    }
                    break;
                case 2: //Alterar
                    foreach (var item in updPanelGeral.ContentTemplateContainer.Controls)
                    {
                        if (item.GetType() == typeof(TextBox))
                        {
                            TextBox txt = (TextBox)item as TextBox;
                            txt.Enabled = false;
                            if (txt.ID == "txtCodAuxInsert" || txt.ID == "txtDescricaoInsert" || txt.ID == "txtDtEncerraInsert")
                                txt.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxComboBox")
                        {
                            ASPxComboBox combo = (ASPxComboBox)item as ASPxComboBox;
                            combo.Enabled = false;
                            if (combo.ID == "dropCarteiraInsert2" || combo.ID == "dropTipoInsert2")
                                combo.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxTextBox")
                        {
                            ASPxTextBox combo = (ASPxTextBox)item as ASPxTextBox;
                            combo.Enabled = false;
                            if (combo.ID == "txtValorContInsert2")
                                combo.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxDropDownEdit")
                        {
                            ASPxDropDownEdit dropE = (ASPxDropDownEdit)item as ASPxDropDownEdit;
                            dropE.Enabled = false;

                        }
                        else if (item.GetType().Name == "ASPxUploadControl")
                        {
                            ASPxUploadControl upload = (ASPxUploadControl)item as ASPxUploadControl;
                            upload.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxGridView")
                        {
                            ASPxGridView grid = (ASPxGridView)item as ASPxGridView;
                            grid.SettingsDataSecurity.AllowInsert = false;
                            grid.SettingsDataSecurity.AllowEdit = false;
                            grid.SettingsDataSecurity.AllowDelete = false;
                            grid.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxCallbackPanel")
                        {
                            ASPxCallbackPanel cbPanel = (ASPxCallbackPanel)item as ASPxCallbackPanel;
                            foreach (var item2 in cbPanel.Controls)
                            {
                                if (item2.GetType().Name == "ASPxDropDownEdit")
                                {
                                    ASPxDropDownEdit dde = (ASPxDropDownEdit)item2 as ASPxDropDownEdit;
                                    dde.Enabled = false;
                                }
                            }
                        }
                    }
                    break;
                case 3: //Replicar
                    foreach (var item in updPanelGeral.ContentTemplateContainer.Controls)
                    {
                        if (item.GetType() == typeof(TextBox))
                        {
                            TextBox txt = (TextBox)item as TextBox;
                            txt.Enabled = false;
                            if (txt.ID == "txtDtAquisiInsert" || txt.ID == "txtDtAssInsert" || txt.ID == "txtDtEncerraInsert")
                                txt.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxComboBox")
                        {
                            ASPxComboBox combo = (ASPxComboBox)item as ASPxComboBox;
                            combo.Enabled = false;
                            if (combo.ID == "dropAgenteFinanceiroInsert2" || combo.ID == "dropParcInsert" || combo.ID == "dropCareInsert" || combo.ID == "dropSaldoInsert")
                                combo.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxTextBox")
                        {
                            ASPxTextBox combo = (ASPxTextBox)item as ASPxTextBox;
                            combo.Enabled = false;
                            if (combo.ID == "txtValorContInsert2")
                                combo.Enabled = true;
                        }
                        else if (item.GetType().Name == "ASPxDropDownEdit")
                        {
                            ASPxDropDownEdit dropE = (ASPxDropDownEdit)item as ASPxDropDownEdit;
                            dropE.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxUploadControl")
                        {
                            ASPxUploadControl upload = (ASPxUploadControl)item as ASPxUploadControl;
                            upload.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxGridView")
                        {
                            ASPxGridView grid = (ASPxGridView)item as ASPxGridView;
                            grid.SettingsDataSecurity.AllowInsert = false;
                            grid.SettingsDataSecurity.AllowEdit = false;
                            grid.SettingsDataSecurity.AllowDelete = false;
                            grid.Enabled = false;
                        }
                        else if (item.GetType().Name == "ASPxCallbackPanel")
                        {
                            ASPxCallbackPanel cbPanel = (ASPxCallbackPanel)item as ASPxCallbackPanel;
                            foreach (var item2 in cbPanel.Controls)
                            {
                                if (item2.GetType().Name == "ASPxDropDownEdit")
                                {
                                    ASPxDropDownEdit dde = (ASPxDropDownEdit)item2 as ASPxDropDownEdit;
                                    dde.Enabled = false;
                                }
                            }
                        }
                    }
                    break;
            }
        }
        protected void CarregaContrato(int Index, bool RowIndex)
        {
            if (RowIndex)
            {
                ASPxGridView grid = (ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
                hfOPCDCONT.Value = grid.GetRowValues(Index, "OPCDCONT").ToString();
                hfTVDSESTR.Value = grid.GetRowValues(Index, "TVDSESTR").ToString();
                hfPRPRODES.Value = grid.GetRowValues(Index, "PRPRODES").ToString();
                hfOPVLCONT.Value = grid.GetRowValues(Index, "OPVLCONT").ToString();
                hfPRPRODID.Value = grid.GetRowValues(Index, "PRPRODID").ToString();
                hfOPIDCONT.Value = grid.GetRowValues(Index, "OPIDCONT").ToString();
                Session["ID"] = hfOPIDCONT.Value;
            }
            else
            {
                var arrayResult = DataBase.Consultas.Consulta(str_conn, "SELECT OPCDCONT,TVDSESTR,PRPRODES,OPVLCONT,O.PRPRODID,OPIDCONT FROM OPCONTRA O, TVESTRUT T, PRPRODUT P WHERE T.TVIDESTR=O.TVIDESTR AND O.PRPRODID=P.prprodid and O.OPIDCONT=" + Index + "", 6);
                hfOPCDCONT.Value = arrayResult[0];
                hfTVDSESTR.Value = arrayResult[1];
                hfPRPRODES.Value = arrayResult[2];
                hfOPVLCONT.Value = arrayResult[3];
                hfPRPRODID.Value = arrayResult[4];
                hfOPIDCONT.Value = arrayResult[5];
                Session["ID"] = hfOPIDCONT.Value;
            }
            CultureInfo cultureInfo = CultureInfo.GetCultureInfo(lang);
            // Get the selected index and the command name
            //string sqlEstrutura = "select CAIDCTRA,CADSCTRA from cacteira where TVIDESTR = " + DataBase.Consultas.Consulta(str_conn, "SELECT TVIDESTR FROM OPCONTRA WHERE OPIDCONT=" + hfOPIDCONT.Value + "", 1)[0] + " order by cadsctra";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlEstrutura, con))
            //    {
            //        dropCarteiraInsert2.TextField = "CADSCTRA";
            //        dropCarteiraInsert2.ValueField = "CAIDCTRA";
            //        dropCarteiraInsert2.DataSource = cmd.ExecuteReader();
            //        dropCarteiraInsert2.DataBind();
            //    }
            //}
            //string sqlFornecedor = "SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8 and TVIDESTR = " + DataBase.Consultas.Consulta(str_conn, "SELECT TVIDESTR FROM OPCONTRA WHERE OPIDCONT=" + hfOPIDCONT.Value + "", 1)[0] + " order by fonmforn";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlFornecedor, con))
            //    {
            //        dropAgenteFinanceiroInsert2.TextField = "FONMFORN";
            //        dropAgenteFinanceiroInsert2.ValueField = "FOIDFORN";
            //        dropAgenteFinanceiroInsert2.DataSource = cmd.ExecuteReader();
            //        dropAgenteFinanceiroInsert2.DataBind();
            //    }
            //}
            hfCodInterno.Value = hfOPIDCONT.Value;
            hfCHIDCODI.Value = DataBase.Consultas.Consulta(str_conn, "select chidcodi from PRPRODUT where prprodid=" + hfPRPRODID.Value, 1)[0];
            string pais = hfPaisUser.Value;
            string query1 = "SELECT TV.TVDSESTR,OP.OPIDCONT,OP.OPCDCONT,OP.OPCDAUXI,OP.OPNMCONT,OP.USIDUSUA,OP.OPDTASCO,OP.OPDTBACO,OP.OPDTENCO,OP.OPVLCONT,OP.CMTPIDCM,OP.PRTPIDOP,OP.PRPRODID,OP.CAIDCTRA,OP.OPTPFRID,OP.FOIDFORN,OP.OPTPTPID,OP.OPFLPARC,OP.OPFLCARE,OP.OPFLSLDI,TV.TVIDESTR	 " +
                    "FROM OPCONTRA OP " +
                    "INNER JOIN TVESTRUT TV   ON(OP.TVIDESTR = TV.TVIDESTR) " +
                    "AND OP.OPIDAACC IS NULL and OP.OPIDCONT=" + hfCodInterno.Value + " " +
                    "AND   OP.PRTPIDOP NOT IN(5) AND OP.OPCDCONT = '" + hfOPCDCONT.Value + "' " +
                    "UNION " +
                    "SELECT TV.TVDSESTR,OP.OPIDCONT,OP.OPCDCONT,OP.OPCDAUXI,OP.OPNMCONT,OP.USIDUSUA,OP.OPDTASCO,OP.OPDTBACO,OP.OPDTENCO,OP.OPVLCONT,OP.CMTPIDCM,OP.PRTPIDOP,OP.PRPRODID,OP.CAIDCTRA,OP.OPTPFRID,OP.FOIDFORN,OP.OPTPTPID,OP.OPFLPARC,OP.OPFLCARE,OP.OPFLSLDI,TV.TVIDESTR	 " +
                    "FROM OPCONTRA OP " +
                    "INNER JOIN TVESTRUT TV  ON(OP.TVIDESTR = TV.TVIDESTR) " +
                    "AND OP.OPIDCONT=" + hfCodInterno.Value + " " +
                    "AND OP.PRTPIDOP IN(5) AND OP.OPCDCONT = '" + hfOPCDCONT.Value + "' " +
                    "ORDER BY OPCDCONT";
            string query2 = "select cj.cjidcodi,cj.CJDSDECR, case when tp.cjtpidtp = 8 then(SELECT CINMTABE FROM CICIENTI where CIIDCODI = cd.cjtpcttx) else cd.cjtpcttx end as cjtpcttx,tp.CJTPDSTP " +
                              "from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
                              "where cd.opidcont = " + hfOPIDCONT.Value + " " +
                                "and cj.chidcodi = cd.chidcodi " +
                                "and cj.cjidcodi = cd.cjidcodi " +
                                "and cd.cjtpcttx is not null " +
                                "and tp.PAIDPAIS = 1 " +
                                "and tp.cjtpidtp = cj.cjtpidtp " +
                              "order by cj.cjororde,cj.chidcodi,cj.cjidcodi, cd.cjdtdtde, cd.cjdtdtat";
            string sql = "select cj.cjororde, cj.chidcodi, cj.cjidcodi, cj.cjdsdecr, cd.opidcont, cd.cjtpcttx " +
                           ", cd.cjdscaor, cd.cjidvlde, cd.cjidvlat, cd.cjvlvalo " +
                           ", cd.cjinprop, cd.cjvlprop, cd.cjdtprop, cd.cjdtdtde, cd.cjdtdtat,cd.cjvldeat " +
                           ", tp.cjtpidtp " +
                           ", tp.cjtpdstp " +
                           ", isnull(cj.cjflobrg, 'S') cjflobrg " +
                           ", case when cj.cjtpidtp = 12 then cj.cjtpcttx " +
                                  "else null " +
                                  "end cjSQL " +
                      "from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
                      "where cd.opidcont = " + hfOPIDCONT.Value + " " +
                        "and cj.chidcodi = cd.chidcodi " +
                        "and cj.cjidcodi = cd.cjidcodi " +
                        "and cd.cjtpcttx is not null " +
                        "and tp.PAIDPAIS = 1 " +
                        "and tp.cjtpidtp = cj.cjtpidtp " +
                      "order by cj.cjororde,cj.chidcodi,cj.cjidcodi, cd.cjdtdtde, cd.cjdtdtat";

            string[] result = DataBase.Consultas.Consulta(str_conn, query1, 21);
            if (result[0] != null)
            {
                ddeEstruturaInsert.Text = result[0].ToString();
                txtCodInternoInsert.Text = result[1].ToString();
                txtNumProcessoInsert.Text = result[2].ToString();
                txtCodAuxInsert.Text = result[3].ToString();
                txtDescricaoInsert.Text = result[4].ToString();
                txtOperadorInsert.Text = result[5].ToString();
                txtDtAquisiInsert.Text = Convert.ToDateTime(result[6].ToString().Trim()).ToString("d");
                txtDtAssInsert.Text = Convert.ToDateTime(result[7].ToString().Trim()).ToString("d");
                txtDtEncerraInsert.Text = Convert.ToDateTime(result[8].ToString().Trim()).ToString("d");
                NumberFormatInfo nFormat = new CultureInfo(lang, true).NumberFormat;
                nFormat.CurrencySymbol = "";
                txtValorContInsert2.Text = string.Format(nFormat, "{0:c2}", result[9]);
                dropEstruturaInsert2.Value = result[10].ToString();
                sqlClasseProdutosInsert.SelectParameters[0].DefaultValue = result[10].ToString();
                dropClasseProdutoInsert2.DataBind();
                dropClasseProdutoInsert2.Value = result[11].ToString();
                sqlProdutoInsert.SelectParameters[0].DefaultValue = result[10].ToString();
                sqlProdutoInsert.SelectParameters[1].DefaultValue = result[11].ToString();
                //sqlProdutoInsert.SelectParameters[2].DefaultValue = pais;
                sqlProdutoInsert.SelectParameters[3].DefaultValue = result[20].ToString();
                dropProdutoInsert2.DataBind();                
                dropProdutoInsert2.Value = result[12].ToString()+"|"+ hfCHIDCODI.Value;
                dropCarteiraInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "select CAIDCTRA,CADSCTRA from cacteira where tvidestr=" + result[20].ToString() + " order by cadsctra");
                dropCarteiraInsert2.DataBind();
                dropCarteiraInsert2.Value = result[13].ToString();
                sqlFormatoInsert.SelectParameters[0].DefaultValue = result[10].ToString();
                dropFormatoOperacaoInsert2.DataBind();
                dropFormatoOperacaoInsert2.Value = result[14].ToString();
                dropAgenteFinanceiroInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8 and TVIDESTR = " + result[20].ToString() + " order by fonmforn");
                dropAgenteFinanceiroInsert2.DataBind();
                dropAgenteFinanceiroInsert2.Value = result[15].ToString();
                sqlTipoInsert.SelectParameters[0].DefaultValue = result[10].ToString();
                dropTipoInsert2.DataBind();
                dropTipoInsert2.Value = result[16].ToString();
                dropParcInsert.Value = result[17].ToString();
                dropCareInsert.Value = result[18].ToString();
                dropSaldoInsert.Value = result[19].ToString();
                BasesNegociacaoEdit(hfCodInterno.Value, 1);
                btnEdit.Enabled = true;
                btnDelete.Enabled = true;
                btnInsert.Enabled = false;
                btnReplicar.Enabled = true;
            }
            //RequiredFieldValidator2.Enabled = true;
            //(this.Master.FindControl("hfOperacao") as HiddenField).Value = "0";
            //pnlConsulta.Visible = true;
            //pnlAlteracao.Visible = false;
            //pnlInsert.Visible = false;
            //pnlExclusao.Visible = false;
            //btnHistorico.Enabled = true;
            //lbltxtInt.Visible = true;
            //lblcodInt.Visible = true;
        }

        #region DropDown principais
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void TreeList_Load(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treelist = (DevExpress.Web.ASPxTreeList.ASPxTreeList)sender;
            if (SqlDataSource1 == null) return;
            treelist.DataBind();
        }
        protected void btnSelEmp_Click(object sender, EventArgs e)
        {
            if (DataBase.Consultas.Consulta(str_conn, "select count(*) from TPESTRPR where TVIDESTR=" + hfDropEstr.Value + "", 1)[0] == "0")
            {
                MsgException("Não existe Tipologia associada para esta empresa", 4, "Tipologia");

            }
            dropClasseProdutoInsert2.Value = "";
            Session["TVIDESTR_PAG"] = hfDropEstr.Value;
        }
        protected void dropClasseProdutoInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            sqlClasseProdutosInsert.SelectParameters[0].DefaultValue = e.Parameter;
            dropClasseProdutoInsert2.DataBind();
        }
        protected void dropProdutoInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;

            sqlProdutoInsert.SelectParameters[0].DefaultValue = e.Parameter.Split('#')[0];
            sqlProdutoInsert.SelectParameters[1].DefaultValue = e.Parameter.Split('#')[1];
            sqlProdutoInsert.SelectParameters[3].DefaultValue = e.Parameter.Split('#')[2];
            dropProdutoInsert2.DataBind();
            dropAgenteFinanceiroInsert2.DataBind();
        }
        protected void dropCarteiraInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropCarteiraInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "select CAIDCTRA,CADSCTRA from cacteira where tvidestr=" + e.Parameter + " order by cadsctra");
                dropCarteiraInsert2.DataBind();
            }
        }
        protected void dropFormatoOperacaoInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            sqlFormatoInsert.SelectParameters[0].DefaultValue = e.Parameter;
            dropFormatoOperacaoInsert2.DataBind();
        }
        protected void dropAgenteFinanceiroInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropAgenteFinanceiroInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8 and TVIDESTR = " + e.Parameter + " order by fonmforn");
                dropAgenteFinanceiroInsert2.DataBind();
            }
        }
        protected void dropTipoInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            sqlTipoInsert.SelectParameters[0].DefaultValue = e.Parameter;
            dropTipoInsert2.DataBind();
            dropTipoInsert2.SelectedIndex = 0;
        }
        #endregion              
        protected void BasesNegociacaoEdit(string opidcont, int pais)
        {
            string sql = "select cj.cjidcodi,cj.CJDSDECR, case when tp.cjtpidtp=8 then (SELECT CINMTABE FROM CICIENTI where CIIDCODI=cd.cjtpcttx) else cd.cjtpcttx end as cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO, cj.CJTPIDTP, cj.CJORORDE,cd.CJVLPROP " +
                  "from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
                 "where cd.opidcont = " + opidcont + " " +
                    "and cj.chidcodi = cd.chidcodi " +
                    "and cj.cjidcodi = cd.cjidcodi " +
                    "and cd.cjtpcttx is not null " +
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
                                                "and vp.chtpidev = " + pais + " " +
                                                "and cj.CJIDCODI not in (select cj.CJIDCODI from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
                      "where cd.opidcont = " + opidcont + " " +
                        "and cj.chidcodi = cd.chidcodi " +
                        "and cj.cjidcodi = cd.cjidcodi " +
                        "and cd.cjtpcttx is not null  " +
                        "and tp.PAIDPAIS = " + pais + " " +
                        "and tp.cjtpidtp = cj.cjtpidtp) " +
                        //Incluido trecho abaixo para não trazer propriedades com flags iguais aos opcontra
                        "and cj.CJIDCODI not in (select dp.cjidcodi from dppropfl dp, opcontra op where cj.CJIDCODI=dp.cjidcodi and op.OPIDCONT=" + opidcont + " and (op.OPFLPARC=dp.opflparc or op.OPFLCARE=dp.OPFLCARE or op.OPFLSLDI=dp.OPFLSLDI))  order by CJORORDE";
            rptBases.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
            rptBases.DataBind();
        }
        protected void myLinkTagBtn_Click(object sender, EventArgs e)
        {

        }

        protected void lnkRptBasesInsert_Command(object sender, CommandEventArgs e)
        {
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
                                            "WHERE tvidestr = " + Session["TVIDESTR_PAG"].ToString() + " " +
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
            panelActive2.Value = "collapseInsertBases";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { var paneName2 = $(\"[id *= panelActive2]\").val() != \"\" ? $(\"[id *= panelActive2]\").val() : \"collapseInsertInfo\";$('#cardInsert .show').removeClass('show');$(\"#\" + paneName2).collapse(\"show\");$('[id *= panelActive2]').val('#collapseInsertBases'); });", true);
            popupBasesAlterar.HeaderText = cjdsdecr;
            popupBasesAlterar.ShowOnPageLoad = true;
        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (txtEditarInteiro.Text == "10")
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
        protected void rptBasesInserir_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    (e.Item.FindControl("CalendarDt1") as CalendarExtender).TargetControlID = (e.Item.FindControl("txtDt1") as TextBox).UniqueID;
                    (e.Item.FindControl("CalendarDt2") as CalendarExtender).TargetControlID = (e.Item.FindControl("txtDt2") as TextBox).UniqueID;
                    (e.Item.FindControl("MaskedVl1") as MaskedEditExtender).TargetControlID = (e.Item.FindControl("txtVl") as TextBox).UniqueID;
                }
                catch
                {

                }
                if(e.Item.GetType() == typeof(LinkButton))
                {
                    LinkButton btn = (LinkButton)e.Item.FindControl("lnkRptBasesInsert");
                    AsyncPostBackTrigger tr1 = new AsyncPostBackTrigger();
                    tr1.ControlID = btn.UniqueID;
                    updPanelGeral.Triggers.Add(tr1);
                }
            }
        }
        protected void rptBasesInserir_PreRender(object sender, EventArgs e)
        {
            for (int i = 0; i < rptBases.Items.Count; i++)
            {
                if (((i + 1) % 4) == 0 && i > 0)
                {
                    Literal ltr = rptBases.Items[i].FindControl("ltrlRepeaterBasesInserir") as Literal;
                    ltr.Text = "</div><div class=\"row\">";
                }
            }
        }
        protected void fileInsert_FileUploadComplete(object sender, DevExpress.Web.FileUploadCompleteEventArgs e)
        {

        }
        protected void gridFilesInsert_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

        }
        #region Botões à direira
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            validaControles(1);
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            validaControles(0);
        }
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            validaControles(2);
        }
        protected void btnReplicar_Click(object sender, EventArgs e)
        {
            validaControles(3);
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
        #endregion

        protected void gridRptDeAte_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {
            ASPxGridView grid = (sender) as ASPxGridView;
            ((GridViewDataColumn)grid.Columns["De"]).EditFormSettings.Visible = DevExpress.Utils.DefaultBoolean.True;
            ((GridViewDataColumn)grid.Columns["Ate"]).EditFormSettings.Visible = DevExpress.Utils.DefaultBoolean.True;
            ((GridViewDataColumn)grid.Columns["Valor"]).EditFormSettings.Visible = DevExpress.Utils.DefaultBoolean.True;
            if (grid.VisibleRowCount == 0)
            {
                bool testeDe = DateTime.TryParse(DataBase.Consultas.Consulta(str_conn, "select OPDTASCO from OPCONTRA WHERE OPIDCONT=" + hfCodInterno.Value, 1)[0], out DateTime dtAquisi);
                bool testeAte = DateTime.TryParse(DataBase.Consultas.Consulta(str_conn, "select OPDTENCO from OPCONTRA WHERE OPIDCONT=" + hfCodInterno.Value, 1)[0], out DateTime dtEncerra);
                if (testeAte)
                    e.NewValues["Ate"] = dtEncerra;
                if (testeDe)
                    e.NewValues["De"] = dtAquisi;
            }
        }

        protected void gridRptDeAte_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            CultureInfo br = new CultureInfo("pt-BR");
            e.Handled = true;
            int oper = 99;
            foreach (var itens in e.UpdateValues)
            {
                string De = itens.NewValues["De"].ToString();
                string Ate = itens.NewValues["Ate"].ToString();
                string Valor = itens.NewValues["Valor"].ToString();
                string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is null and cjdtdtde='" + itens.OldValues["De"].ToString() + "' and cjdtdtat='" + itens.OldValues["Ate"].ToString() + "'";
                string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                string del1 = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is null and cjdtdtde='" + itens.OldValues["De"].ToString() + "' and cjdtdtat='" + itens.OldValues["Ate"].ToString() + "'";
                string delete1 = DataBase.Consultas.DeleteFrom(str_conn, del1);
                string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, null, De, Ate, Valor.Replace(",", "."));
                oper = 0;
            }
            foreach (var itens in e.InsertValues)
            {
                string De = itens.NewValues["De"].ToString();
                string Ate = itens.NewValues["Ate"].ToString();
                string Valor = itens.NewValues["Valor"].ToString();
                string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, null, De, Ate, Valor.Replace(",", "."));
                oper = 1;
            }
            foreach (var itens in e.DeleteValues)
            {
                string De = itens.Values["De"].ToString();
                string Ate = itens.Values["Ate"].ToString();
                string Valor = itens.Values["Valor"].ToString();
                string del = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is null and cjdtdtde='" + De + "' and cjdtdtat='" + Ate + "'";
                string delete = DataBase.Consultas.DeleteFrom(str_conn, del);
                oper = 2;
            }
            string query = "select count(opidcont) from cjclprop_din " +
                    "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                      "and opidcont = " + hfCodInterno.Value + " " +
                      "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                      "and CJTPCTTX is null";
            int cont = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, query, 1)[0]);
            string str = string.Empty;
            if (cont == 0)
            {
                if (oper == 1)
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), "1 Item", 0, null, null, null, null, null);
                else if (oper == 2)
                {
                    string del = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is not null";
                    string delete = DataBase.Consultas.DeleteFrom(str_conn, del);
                }
            }
            else if (cont > 1)
            {
                str = cont.ToString() + " Itens";
                query = "select count(opidcont) from cjclprop_din " +
        "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
          "and opidcont = " + hfCodInterno.Value + " " +
          "and cjidcodi = " + hfCJIDCODI2.Value + " " +
          "and CJTPCTTX is not null";
                int cont2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, query, 1)[0]);
                if (oper == 1 && cont2 == 0)
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, null, null, null, null);
            }
            else
            {
                str = cont.ToString() + " Item";
                query = "select count(opidcont) from cjclprop_din " +
        "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
          "and opidcont = " + hfCodInterno.Value + " " +
          "and cjidcodi = " + hfCJIDCODI2.Value + " " +
          "and CJTPCTTX is not null";
                int cont3 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, query, 1)[0]);
                if (oper == 1 && cont3 == 0)
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, null, null, null, null);
            }
            string upt = "update cjclprop_din set cjtpcttx='" + str + "' where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is not null";
            DataBase.Consultas.UpdateFrom(str_conn, upt);
            gridRptDeAte.DataSource = DataBase.Consultas.Consulta(str_conn, hfqueryRpt.Value);
            gridRptDeAte.DataBind();
            BasesNegociacaoEdit(hfCodInterno.Value, 1);
        }

        protected string InsertPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, string p_cjdtprop, string p_cjdtdtde, string p_cjdtdtat, string p_cjvldeat)
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
                    cmd.Parameters.AddWithValue("@p_cjdtprop", p_cjdtprop);
                    cmd.Parameters.AddWithValue("@p_cjdtdtde", p_cjdtdtde);
                    cmd.Parameters.AddWithValue("@p_cjdtdtat", p_cjdtdtat);
                    cmd.Parameters.AddWithValue("@p_cjvldeat", p_cjvldeat);
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
        protected string AlterarPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, string p_cjdtprop, string p_cjdtdtde, string p_cjdtdtat, float p_cjvldeat)
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
                    cmd.Parameters.AddWithValue("@p_cjdtprop", p_cjdtprop);
                    cmd.Parameters.AddWithValue("@p_cjdtdtde", p_cjdtdtde);
                    cmd.Parameters.AddWithValue("@p_cjdtdtat", p_cjdtdtat);
                    cmd.Parameters.AddWithValue("@p_cjvldeat", p_cjvldeat);
                    cmd.Parameters.AddWithValue("@p_idioma", lang);
                    cmd.Parameters.Add(outValue);
                    cmd.ExecuteScalar();
                    retorno = outValue.Value.ToString();
                }
                catch (Exception ex)
                {
                    MsgException(ex.ToString(), 1);
                }
                finally
                {
                    conn.Close();
                }

            }
            return retorno;
        }
        protected void btnEditarData_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(3);
        }
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
                            string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                            string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                            result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, txtEditarData.Text, null, null, 0);
                            oper = result == "OK" ? 1 : 0;
                        }
                        else
                        {
                            result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, txtEditarData.Text, null, null, null);
                        }
                        if (result != "OK")
                        {
                            MsgException("Erro: " + result, 1);
                        }
                        BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    }
                    if (result == "OK" && hfCJIDCODI2.Value == "277" && oper == 1)
                    {
                        MsgException("Valor alterado, execução de limpeza do Fluxo de Caixa", 2);
                    }
                    break;
                case "6": //Tipo Flutuante
                    if (qntd != 0)
                    {
                        string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarFlutuante.Text.Replace(",", "."), null, null, null, 0);
                    }
                    else
                    {
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarFlutuante.Text.Replace(",", "."), null, null, null, null);
                    }

                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    break;
                case "8": //Tipo Fórmula paramétrica
                    if (qntd != 0)
                    {
                        string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.SelectedValue, 0, null, null, null, null, 0);
                    }
                    else
                    {
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.SelectedValue, 0, null, null, null, null, null);
                    }
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    break;
                case "15": //Tipo Indice
                    if (qntd != 0)
                    {
                        string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, txtEditarIndice.Text, null, null, 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, txtEditarIndice.Text, null, null, null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    break;
                case "9": //Tipo Inteiro
                    if (qntd != 0)
                    {
                        string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarInteiro.Text), null, null, null, null, 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarInteiro.Text), null, null, null, null, null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    break;
                case "10": //Tipo Moeda

                    if (qntd != 0)
                    {
                        string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarMoeda.Text.Replace(",", "."), null, null, null, 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarMoeda.Text.Replace(",", "."), null, null, null, null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    break;
                case "4": //Tipo De Até
                    //string data1, data2;
                    //float valor = 0;
                    //int cont = 0;
                    //result = "FALHA";
                    //int[] resultDT = new int[rptDeAteEdit.Items.Count];
                    //int resultFinal = 0;
                    //string query = "select cjidvlde De,CJIDVLAT Ate,CJVLVALO Valor from cjclprop_din " +
                    //"where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                    //  "and opidcont = " + hfCodInterno.Value + " " +
                    //  "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                    //  "and CJTPCTTX is null";
                    //string queryDel = "delete cjclprop_din " +
                    //"where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                    //  "and opidcont = " + hfCodInterno.Value + " " +
                    //  "and cjidcodi = " + hfCJIDCODI2.Value;
                    //DataTable dt = DataBase.Consultas.Consulta(str_conn, query);
                    //int qtdAtual = dt.Rows.Count;
                    //for (int i = 0; i < qtdAtual; i++)
                    //{
                    //    TextBox dt1 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt1Edit");
                    //    data1 = dt1.Text;
                    //    TextBox dt2 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt2Edit");
                    //    data2 = dt2.Text;
                    //    resultDT[i] = DateTime.Compare(Convert.ToDateTime(dt1.Text, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(txtDataAquisicaoEdit.Text, CultureInfo.GetCultureInfo(lang)));
                    //    for (int j = 0; j < resultDT.Length; j++)
                    //    {
                    //        if (resultDT[j] == -1)
                    //        {
                    //            resultFinal = -1;
                    //        }
                    //    }
                    //}
                    //if (resultFinal == -1)
                    //    MsgException("Data 'de' não pode ser anterior a data do contrato!", 1);
                    //else
                    //{
                    //    string delete = DataBase.Consultas.DeleteFrom(str_conn, queryDel);
                    //    if (delete == "OK")
                    //    {
                    //        if (qtdAtual <= rptDeAteEdit.Items.Count)
                    //        {
                    //            for (int i = 0; i < qtdAtual; i++)
                    //            {
                    //                TextBox dt1 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt1Edit");
                    //                data1 = dt1.Text;
                    //                TextBox dt2 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt2Edit");
                    //                data2 = dt2.Text;
                    //                TextBox vl = (TextBox)rptDeAteEdit.Items[i].FindControl("txtVlEdit");
                    //                if (resultFinal != -1)//Data Anterior a Data Aquisição
                    //                {
                    //                    result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, null, data1, data2, vl.Text);
                    //                    if (result == "OK")
                    //                    {
                    //                        cont = cont + 1;
                    //                    }
                    //                    else
                    //                    {
                    //                        MsgException("Falha ao alterar " + lblEditarDeAte.Text + ": " + result, 1);
                    //                        result = "FALHA";
                    //                    }
                    //                }
                    //            }
                    //            if (result != "FALHA")
                    //            {
                    //                string str = null;
                    //                if (cont != 0 && cont > 1)
                    //                {
                    //                    str = cont.ToString() + " Itens";
                    //                }
                    //                else if (cont == 1)
                    //                {
                    //                    str = cont.ToString() + " Item";
                    //                }
                    //                result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, null, null, null, null);
                    //            }
                    //        }
                    //        else
                    //        {
                    //            for (int i = 0; i < qtdAtual; i++)
                    //            {
                    //                TextBox dt1 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt1Edit");
                    //                data1 = dt1.Text;
                    //                TextBox dt2 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt2Edit");
                    //                data2 = dt2.Text;
                    //                TextBox vl = (TextBox)rptDeAteEdit.Items[i].FindControl("txtVlEdit");
                    //                if (data1 != null && data2 != null && valor != 0)
                    //                {

                    //                    if (resultFinal != -1)//Data Anterior a Data Aquisição
                    //                    {
                    //                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, null, data1, data2, vl.Text);
                    //                        if (result == "OK")
                    //                        {
                    //                            cont = cont + 1;
                    //                        }
                    //                        else
                    //                        {
                    //                            MsgException("Falha ao alterar " + lblEditarDeAte.Text + ": " + result, 1);
                    //                            result = "FALHA";
                    //                        }
                    //                    }
                    //                }
                    //                else
                    //                {
                    //                    result = "FALHA";
                    //                    MsgException("Verificar preenchimento dos campos.", 1);
                    //                }
                    //            }
                    //            if (result != "FALHA")
                    //            {
                    //                string str = null;
                    //                if (cont != 0 && cont > 1)
                    //                {
                    //                    str = cont.ToString() + " Itens";
                    //                }
                    //                else if (cont == 1)
                    //                {
                    //                    str = cont.ToString() + " Item";
                    //                }
                    //                result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, null, null, null, null);
                    //            }
                    //        }
                    //    }
                    //    else
                    //    {
                    //        MsgException("Falha na exclusão: " + delete, 1);
                    //    }
                    //}
                    //BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    break;
                case "12": //Tipo SQL
                    if (qntd != 0)
                    {
                        string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarSql2.SelectedItem.Text, 0, null, null, null, null, 0);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarSql2.SelectedItem.Text, 0, null, null, null, null, null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1);
                    break;
            }
            popupBasesAlterar.ShowOnPageLoad = false;
            
        }
        protected void DelBasesEdit(object sender, CommandEventArgs e)
        {
            string del = "delete cjclprop_din where chidcodi=" + hfCHIDCODI2.Value + " and opidcont=" + hfCodInterno.Value + " and cjidcodi=" + hfCJIDCODI2.Value + "";
            string result = DataBase.Consultas.DeleteFrom(str_conn, del);
            popupBasesAlterar.ShowOnPageLoad = false;
            BasesNegociacaoEdit(hfCodInterno.Value, 1);
        }
    }
}