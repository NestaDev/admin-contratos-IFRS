using AjaxControlToolkit;
using ClosedXML.Excel;
using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using System;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Contrato_Umbrella1 : BasePage.BasePage
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
                mv_contrato.SetActiveView(this.view_1);
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                    usuarioPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                user = usuarioPersist;
                hfUser.Value = user;
                hfUser2.Value = user;
                str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
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
        protected void CarregaContrato(int Index, bool RowIndex)
        {
            hfOperacao.Value = "consultar";
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
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
            string sqlEstrutura = "select CAIDCTRA,CADSCTRA from cacteira where ( TVIDESTR=1 OR TVIDESTR = " + DataBase.Consultas.Consulta(str_conn, "SELECT TVIDESTR FROM OPCONTRA WHERE OPIDCONT=" + hfOPIDCONT.Value + "", 1)[0] + ") order by cadsctra";
            using (var con = new OleDbConnection(str_conn))
            {
                con.Open();
                using (var cmd = new OleDbCommand(sqlEstrutura, con))
                {
                    dropCarteiraInsert2.TextField = "CADSCTRA";
                    dropCarteiraInsert2.ValueField = "CAIDCTRA";
                    dropCarteiraInsert2.DataSource = cmd.ExecuteReader();
                    dropCarteiraInsert2.DataBind();
                }
            }
            string sqlFornecedor = "SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8 and (TVIDESTR = " + DataBase.Consultas.Consulta(str_conn, "SELECT TVIDESTR FROM OPCONTRA WHERE OPIDCONT=" + hfOPIDCONT.Value + "", 1)[0] + " or TVIDESTR in (select TVIDESTR from VIFSFUSU where USIDUSUA='" + usuarioPersist + "') or TVIDESTR=1) order by fonmforn";
            using (var con = new OleDbConnection(str_conn))
            {
                con.Open();
                using (var cmd = new OleDbCommand(sqlFornecedor, con))
                {
                    OleDbDataAdapter da = new OleDbDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dropAgenteFinanceiroInsert2.DataSource = dt;
                    dropAgenteFinanceiroInsert2.DataBind();
                    dropBenefIns.DataSource = dt;
                    dropBenefIns.DataBind();
                }
            }
            hfCodInterno.Value = hfOPIDCONT.Value;
            hfCHIDCODI.Value = DataBase.Consultas.Consulta(str_conn, "select chidcodi from PRPRODUT where prprodid=" + hfPRPRODID.Value, 1)[0];
            string query1 = "SELECT TV.TVDSESTR,OP.OPCDCONT,OP.OPNMCONT,PR.PRPROCOD,PR.PRPRODES,OP.OPDTASCO, OP.OPDTBACO, FR.OPTPFRDS,FO.FONMAB20,SN.TPDSSINA,RG.OPTPRGDS,TP.OPTPTPDS,OP.CAIDCTRA,tp.cmtpidcm,tp.optptpid,ca.CADSCTRA,pe.PRTPNMOP,op.OPIDCONT,op.OPCDAUXI,(select CMTPDSCM from CMTPCMCL cm where cm.CMTPIDCM=op.CMTPIDCM and cm.PAIDPAIS=1) CMTPDSCM,OP.OPVLCONT,FO.FOIDFORN,OP.OPDTENCO,OP.OPFLPARC,OP.OPFLCARE,OP.OPFLSLDI,OP.TVIDESTR,OP.FOIDFORN2,OP.OPDTINPG,OP.OPDTFMPG,op.CMTPIDCM,op.PRTPIDOP,op.USIDUSUA,pr.CHIDCODI " +
                    "FROM OPCONTRA OP " +
                    "LEFT OUTER JOIN CACTEIRA CA ON(OP.CAIDCTRA = CA.CAIDCTRA) " +
                    "LEFT OUTER JOIN OPTPFRCO FR ON(OP.OPTPFRID = FR.OPTPFRID) " +
                    "INNER JOIN PRPRODUT PR   ON(PR.CMTPIDCM = FR.CMTPIDCM AND OP.PRPRODID = PR.PRPRODID) " +
                    "INNER JOIN TPSIMNAO SN   ON(OP.TPIDSINA = SN.TPIDSINA) " +
                    "INNER JOIN OPTPTIPO TP   ON(OP.OPTPTPID = TP.OPTPTPID AND PR.CMTPIDCM = TP.CMTPIDCM) " +
                    "INNER JOIN PRTPOPER PE   ON(OP.PRTPIDOP = PE.PRTPIDOP AND PR.CMTPIDCM = PE.CMTPIDCM) " +
                    "INNER JOIN OPTPRGCO RG   ON(OP.OPTPRGID = RG.OPTPRGID AND PR.CMTPIDCM = RG.CMTPIDCM) " +
                    "INNER JOIN IEINDECO IE   ON(PR.IEIDINEC = IE.IEIDINEC) " +
                    "INNER JOIN FOFORNEC FO   ON(OP.FOIDFORN = FO.FOIDFORN) " +
                    "INNER JOIN TVESTRUT TV   ON(OP.TVIDESTR = TV.TVIDESTR) " +
                    "AND FR.PAIDPAIS = 1 " +
                    "AND SN.PAIDPAIS = 1 " +
                    "AND TP.PAIDPAIS = 1 " +
                    "AND PE.PAIDPAIS = 1 " +
                    "AND RG.PAIDPAIS = 1 " +
                    "AND PR.CMTPIDCM NOT IN(2, 4, 5) " +
                    "AND OP.OPIDAACC IS NULL and OP.OPIDCONT=" + hfCodInterno.Value + " " +
                    "AND   OP.PRTPIDOP NOT IN(5) AND OP.OPCDCONT = '" + hfOPCDCONT.Value + "' " +
                    "UNION " +
                    "SELECT TV.TVDSESTR,OP.OPCDCONT,OP.OPNMCONT,PR.PRPROCOD,PR.PRPRODES,OP.OPDTASCO, OP.OPDTBACO, FR.OPTPFRDS,FO.FONMAB20,SN.TPDSSINA,RG.OPTPRGDS,TP.OPTPTPDS,OP.CAIDCTRA,tp.cmtpidcm,tp.optptpid,ca.CADSCTRA,pe.PRTPNMOP,op.OPIDCONT,op.OPCDAUXI,(select CMTPDSCM from CMTPCMCL cm where cm.CMTPIDCM=op.CMTPIDCM and cm.PAIDPAIS=1) CMTPDSCM,OP.OPVLCONT,FO.FOIDFORN,OP.OPDTENCO,OP.OPFLPARC,OP.OPFLCARE,OP.OPFLSLDI,OP.TVIDESTR,OP.FOIDFORN2,OP.OPDTINPG,OP.OPDTFMPG,op.CMTPIDCM,op.PRTPIDOP,op.USIDUSUA,pr.CHIDCODI " +
                    "FROM OPCONTRA OP " +
                    "LEFT OUTER JOIN CACTEIRA CA ON(OP.CAIDCTRA = CA.CAIDCTRA) " +
                    "LEFT OUTER JOIN OPTPFRCO FR ON(OP.OPTPFRID = FR.OPTPFRID) " +
                    "INNER JOIN PRPRODUT PR  ON(PR.CMTPIDCM = FR.CMTPIDCM AND OP.PRPRODID = PR.PRPRODID) " +
                    "INNER JOIN TPSIMNAO SN  ON(OP.TPIDSINA = SN.TPIDSINA) " +
                    "INNER JOIN OPTPTIPO TP  ON(OP.OPTPTPID = TP.OPTPTPID AND PR.CMTPIDCM = TP.CMTPIDCM) " +
                    "INNER JOIN PRTPOPER PE  ON(OP.PRTPIDOP = PE.PRTPIDOP AND PR.CMTPIDCM = PE.CMTPIDCM) " +
                    "INNER JOIN OPTPRGCO RG  ON(OP.OPTPRGID = RG.OPTPRGID AND PR.CMTPIDCM = RG.CMTPIDCM) " +
                    "INNER JOIN IEINDECO IE  ON(PR.IEIDINEC = IE.IEIDINEC) " +
                    "INNER JOIN FOFORNEC FO  ON(OP.FOIDFORN = FO.FOIDFORN) " +
                    "INNER JOIN TVESTRUT TV  ON(OP.TVIDESTR = TV.TVIDESTR) " +
                    "AND FR.PAIDPAIS = 1 " +
                    "AND SN.PAIDPAIS = 1 " +
                    "AND TP.PAIDPAIS = 1 " +
                    "AND PE.PAIDPAIS = 1 " +
                    "AND RG.PAIDPAIS = 1 " +
                    "AND PR.CMTPIDCM NOT IN(2, 4, 5) " +
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

            string[] result = DataBase.Consultas.Consulta(str_conn, query1, 34);
            if (result[0] != null)
            {
                ddeEstruturaInsert.Enabled = false;
                txtNumProcessoInsert.Enabled = false;
                txtDescricaoInsert.Enabled = false;
                txtCodAuxInsert.Enabled = false;
                txtDtAquisiInsert.Enabled = false;
                txtDtAssInsert.Enabled = false;
                txtDtEncerraInsert.Enabled = false;
                txtValorContInsert2.Enabled = false;
                txtIniPagInsert.Enabled = false;
                txtFimPagInsert.Enabled = false;
                dropEstruturaInsert2.Enabled = false;
                dropClasseProdutoInsert2.Enabled = false;
                dropProdutoInsert2.Enabled = false;
                dropCarteiraInsert2.Enabled = false;
                dropAgenteFinanceiroInsert2.Enabled = false;
                dropBenefIns.Enabled = false;
                dropParcInsert.Enabled = false;
                dropCareInsert.Enabled = false;
                dropSaldoInsert.Enabled = false;
                sqlClasseProdutosInsert.SelectParameters[0].DefaultValue = result[30].ToString();
                dropClasseProdutoInsert2.DataBind();
                txtOperadorInsert.Text = result[32].ToString();
                hfCHIDCODI.Value = result[33].ToString();
                ddeEstruturaInsert.Text = result[0].ToString();
                txtNumProcessoInsert.Text = result[1].ToString();
                txtDescricaoInsert.Text = result[2].ToString();
                dropEstruturaInsert2.Value = result[19].ToString();
                Session["TVIDESTR_PAG"] = result[26].ToString();
                dropProdutoInsert2.Text = result[4].ToString();
                txtDtAquisiInsert.Text = DateTime.TryParse(result[6].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtaqui) ? Convert.ToDateTime(result[6].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtDtAssInsert.Text = DateTime.TryParse(result[5].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtass1) ? Convert.ToDateTime(result[5].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtDtEncerraInsert.Text = DateTime.TryParse(result[22].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtenc1) ? Convert.ToDateTime(result[22].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtIniPagInsert.Text = DateTime.TryParse(result[28].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtini1) ? Convert.ToDateTime(result[28].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtFimPagInsert.Text = DateTime.TryParse(result[29].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtfim1) ? Convert.ToDateTime(result[29].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                NumberFormatInfo nFormat = new CultureInfo(lang, true).NumberFormat;
                nFormat.CurrencySymbol = "";
                txtValorContInsert2.Text = string.Format(nFormat, "{0:c2}", result[20]);
                dropAgenteFinanceiroInsert2.Value = result[21].ToString();
                dropBenefIns.Value = result[27].ToString();
                dropClasseProdutoInsert2.Value = result[31].ToString();
                dropCarteiraInsert2.Value = result[12].ToString();
                txtCodInternoInsert.Text = result[17].ToString();
                txtCodAuxInsert.Text = result[18].ToString();
                dropParcInsert.Value = result[23].ToString();
                dropSaldoInsert.Value = result[25].ToString();
                gridVerbasAlt.SettingsDataSecurity.AllowDelete = false;
                gridVerbasAlt.SettingsDataSecurity.AllowEdit = false;
                gridVerbasAlt.SettingsDataSecurity.AllowInsert = false;
                BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
                btnEdit.Enabled = perfil != "3";
                if(perfil != "3")
                {
                    btnDelete.Enabled = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from opcontra where OPIDAACC="+ hfOPIDCONT.Value, 1)[0])==0;
                }
                else
                {
                    btnDelete.Enabled = false;
                }
                btnInsert.Enabled = false;
                mv_contrato.SetActiveView(this.view_1);
            }
            RequiredFieldValidator2.Enabled = true;
            if ((this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar")
            {
                gridRptDeAte.SettingsDataSecurity.AllowDelete = true;
                gridRptDeAte.SettingsDataSecurity.AllowEdit = true;
                gridRptDeAte.SettingsDataSecurity.AllowInsert = true;
                pnlGridEdit.Enabled = true;
            }
            else
                (this.Master.FindControl("hfOperacao") as HiddenField).Value = "0";
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
        protected void btnInsert_Load(object sender, EventArgs e)
        {

        }
        protected void btnDelete_Load(object sender, EventArgs e)
        {

        }
        protected void btnEdit_Load(object sender, EventArgs e)
        {

        }
        protected void btnCancelar1_Click(object sender, EventArgs e)
        {
            if (hfOperacao.Value == "inserir")
            {
                //if (hfIndexGrid.Value != null)
                //{
                //    CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                //}
            }
            else if (hfOperacao.Value == "alterar")
            {
                //if (hfIndexGrid.Value != null)
                //{
                //    CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                //}
            }
            else if (hfOperacao.Value == "excluir")
            {
                //if (hfIndexGrid.Value != null)
                //{
                //    CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                //    btnAditamento.Border.BorderWidth = Unit.Pixel(1);
                //    btnAditamento.Border.BorderStyle = BorderStyle.Solid;
                //    btnAditamento.Border.BorderColor = System.Drawing.Color.FromArgb(204, 204, 204);
                //}
            }
            else
                Response.Redirect("CONTRATO_UMBRELLA");
        }
        protected void btnOK1_Click(object sender, EventArgs e)
        {
            switch (hfOperacao.Value)
            {
                case "inserir":
                    if (txtCodInternoInsert.Text != string.Empty)
                    {
                        if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(opidcont) from opcontra where opidcont=" + txtCodInternoInsert.Text, 1)[0]) > 1)
                        {
                            MsgException("Contract already exists!", 1);
                            Response.Redirect("Aquisicao");
                        }
                        if (hfInsertOK.Value == "1")
                        {
                            CarregaContrato(Convert.ToInt32(txtCodInternoInsert.Text), false);
                            return;
                        }
                    }
                    txtCodInternoInsert.Text = CarregaCodInterno("2", 1);
                    hfCodInterno.Value = txtCodInternoInsert.Text;

                    Session["ID"] = txtCodInternoInsert.Text;
                    string[] value = dropProdutoInsert2.SelectedItem.Value.ToString().Split('|');
                    hfProduto.Value = value[0];
                    hfCHIDCODI.Value = value[1];
                    hfEstruturaCorporativa.Value = ddeEstruturaInsert.KeyValue.ToString();
                    string sql = null;
                    try
                    {
                        string benefic = dropBenefIns.SelectedItem == null ? "NULL" : dropBenefIns.SelectedItem.Value.ToString();
                        string favorec = dropAgenteFinanceiroInsert2.SelectedItem == null ? "NULL" : dropAgenteFinanceiroInsert2.SelectedItem.Value.ToString();
                        sql = "INSERT INTO [dbo].[OPCONTRA] ([TVIDESTR],[OPCDCONT],[OPNMCONT],[USIDUSUA],[CMTPIDCM],[PRTPIDOP],[PRPRODID],[OPVLCONT],[OPDTASCO],[OPDSHORA],[CAIDCTRA],[OPIDCONT],[OPTPFRID],[TPIDSINA],[OPTPRGID],[OPTPTPID],[FOIDFORN],[FOIDFORN2],[OPTPGARE],[OPCDAUXI],[OPDTBACO],[OPDTENCO],[OPFLPARC],[OPFLCARE],[OPFLSLDI],[OPDTINPG],[OPDTFMPG]) " +
                                    "VALUES(" + hfEstruturaCorporativa.Value + ", '" + txtNumProcessoInsert.Text + "', '" + txtDescricaoInsert.Text + "', '" + txtOperadorInsert.Text + "', " + dropEstruturaInsert2.SelectedItem.Value + ", " + dropClasseProdutoInsert2.SelectedItem.Value + ", " + hfProduto.Value + ", " + txtValorContInsert2.Text.Replace(",", ".") + ", convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAssInsert.Text) + "',103), '00:00:00', " + dropCarteiraInsert2.SelectedItem.Value + ", " + txtCodInternoInsert.Text + ", 1, 1, 1, 91," + favorec + "," + benefic + ",null,'" + txtCodAuxInsert.Text + "',convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAquisiInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtEncerraInsert.Text) + "',103)," + dropParcInsert.SelectedItem.Value + "," + dropCareInsert.SelectedItem.Value + "," + dropSaldoInsert.SelectedItem.Value + ",convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtIniPagInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtFimPagInsert.Text) + "',103))";


                        hfSqlInsert.Value = sql;
                        string execucao = DataBase.Consultas.InsertContrato(str_conn, sql);
                        if (execucao == "Sucesso")
                        {
                            hfOPIDCONT.Value = txtCodInternoInsert.Text;
                            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
                            btnOK1.Enabled = false;
                            btnCancelar1.Enabled = false;
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { $('#cardInsert .show').removeClass('show');$('[id *= panelActive1]').val('#collapseInsertBases'); });", true);
                            ddeEstruturaInsert.Enabled = true;
                            txtOperadorInsert.Text = hfUser.Value;
                            txtNumProcessoInsert.Enabled = true;
                            txtDescricaoInsert.Enabled = true;
                            txtCodAuxInsert.Enabled = true;
                            txtDtAquisiInsert.Enabled = true;
                            txtDtAssInsert.Enabled = true;
                            txtDtEncerraInsert.Enabled = true;
                            txtValorContInsert2.Enabled = true;
                            txtIniPagInsert.Enabled = true;
                            txtFimPagInsert.Enabled = true;
                            dropEstruturaInsert2.Enabled = true;
                            dropClasseProdutoInsert2.Enabled = true;
                            dropProdutoInsert2.Enabled = true;
                            dropCarteiraInsert2.Enabled = true;
                            dropAgenteFinanceiroInsert2.Enabled = true;
                            dropBenefIns.Enabled = true;
                            dropParcInsert.Enabled = true;
                            dropCareInsert.Enabled = true;
                            dropSaldoInsert.Enabled = true;
                            btnOK1.Enabled = false;
                            ASPxButton btnImportar = gridSubContratos.FindStatusBarTemplateControl("btnImportar") as ASPxButton;
                            btnImportar.Enabled = true;
                        }
                        else
                        {
                            MsgException(execucao, 1);
                        }

                    }
                    catch (Exception ex)
                    {
                        MsgException(ex.Message.ToString(), 1);
                    }
                    break;
                case "alterar":
                    //string sqlUpdate = "update opcontra set OPNMCONT='" + txtDescricaoInsert.Text + "', CAIDCTRA=" + dropCarteiraInsert2.Value + ", OPCDAUXI='" + txtCodAuxInsert.Text + "',OPVLCONT=" + txtValorAquisicaoEdit.Text.Replace(",", ".") + ",OPDTENCO=convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", Convert.ToDateTime(txtdtEncerraEdit.Text, CultureInfo.GetCultureInfo(lang)).ToShortDateString()) + "',103),OPDTADIT=convert(datetime,'" + DateTime.Now.ToShortDateString() + "',103),OPJUADIT='Alteração sem impacto contratual.'  WHERE OPIDCONT=" + hfCodInterno.Value + "";
                    //string exec2 = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    //if (exec2 == "OK")
                    //{
                    //    dropCarteiraEdit.Attributes.Add("disabled", "disabled");
                    //    dropTipoEdit.Attributes.Add("disabled", "disabled");
                    //    if (txtDescricaoEdit.Text != txtDesc.Text || txtCarteira.Text != dropCarteiraEdit.SelectedItem.Text || txtTipo.Text != dropTipoEdit.SelectedItem.Text || txtCodAuxiliar.Text != txtCodAuxiliarEdit.Text || txtValorAquisi.Text != txtValorAquisicaoEdit.Text)
                    //    {
                    //        if (txtValorAquisi.Text != txtValorAquisicaoEdit.Text)
                    //        {
                    //            MsgException("Valor alterado, execução de limpeza do Fluxo de Caixa", 2);
                    //        }
                    //        if (txtDtEncerra.Text != txtdtEncerraEdit.Text)
                    //        {
                    //            MsgException("Valor alterado, execução de limpeza do Fluxo de Caixa", 2);
                    //        }
                    //        //string sqlLog = "insert into OPCONADI (OPIDCONT,OPCDCONT,OPNMCONT,OPDTASCO,OPDTBACO,OPDTENCO,CAIDCTRA,OPDTINCO,USIDUSUA,TVIDESTR,PRPRODID,OPCDAUXA,OPVLCONT,FOIDFORN,OPCDAUXI,OPIDAACC,OPTPTPID,FOIDBOLS,OPQTTOLE,TPIDTIPM,TPIDMERC,TPIDCDPR,TPIDTPPR,TPIDPROR,OPVLPRUN,TPIDCOVE,TPIDORVE,COIDCONV,FANUFATA,OPCDNFAG,OPIDBROK,OPNMADIT,OPDTADIT,OPVLCONT2,OPIDCONA) " +
                    //        //"select OPIDCONT, OPCDCONT, OPNMCONT, OPDTASCO, OPDTBACO, OPDTENCO, (select CAIDCTRA from CACTEIRA where CADSCTRA='" + txtCarteira.Text + "'), OPDTINCO,'" + usuarioPersist + "',TVIDESTR,PRPRODID,'" + txtCodAuxiliar.Text + "'," + txtValorAquisi.Text.Replace(",", ".") + ",FOIDFORN,OPCDAUXI,OPIDAACC,(select max(OPTPTPID) from OPTPTIPO where OPTPTPDS='" + txtTipo.Text + "'),FOIDBOLS,OPQTTOLE,TPIDTIPM,TPIDMERC,TPIDCDPR,TPIDTPPR,TPIDPROR,OPVLPRUN,TPIDCOVE,TPIDORVE,COIDCONV,FANUFATA,OPCDNFAG,OPIDBROK,'ADT',convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", DateTime.Now) + "',103)," + txtValorAquisicaoEdit.Text.Replace(",", ".") + "," + DataBase.Consultas.CarregaCodInterno("28", 0, str_conn) + " from OPCONTRA where opidcont = " + hfCodInterno.Value + "";
                    //        //string exec = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                    //    }
                    //    MsgException(HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString(), 2);
                    //    a = "1";
                    //    DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
                    //    grid.DataBind();
                    //    int Index = 0;
                    //    for (int i = 0; i < grid.VisibleRowCount; i++)
                    //    {
                    //        if (grid.GetRowValues(i, "OPIDCONT").ToString() == txtCodInternoEdit.Text)
                    //        {
                    //            Index = i;
                    //            grid.FocusedRowIndex = Index;
                    //            break;
                    //        }
                    //    }
                    //    ddePesqContrato.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
                    //    hfIndexGrid.Value = Index.ToString();
                    //    if (hfIndexGrid.Value != null)
                    //    {
                    //        CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                    //    }
                    //}
                    //else
                    //{
                    //    MsgException(HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_exception").ToString() + exec2, 1);
                    //}
                    break;
                case "excluir":
                    string result = SProcExcluirContrato(Convert.ToInt32(hfOPIDCONT.Value));
                    if (result == "OK")
                    {
                        MsgException("Contrato excluído com sucesso!", 0);
                        //a = "1";
                    }
                    else
                    {
                        MsgException(result, 1);
                    }
                    break;
            }
        }
        protected string SProcExcluirContrato(int p_opidcont)
        {
            string retorno = null;
            string storedProc = "nesta_sp_delete_OPCONTRA";
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                try
                {

                    if (DataBase.Consultas.DeleteFrom(str_conn, "delete DNALERTA where OPIDCONT=" + p_opidcont.ToString()) == "OK")
                    {

                        OleDbParameter outValue = new OleDbParameter("@o_mensagem", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                        conn.Open();
                        OleDbCommand cmd = new OleDbCommand();
                        cmd.Connection = conn;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = storedProc;
                        cmd.Parameters.AddWithValue("@p_opidcont", p_opidcont);
                        cmd.Parameters.AddWithValue("@p_idioma", lang);
                        cmd.Parameters.Add(outValue);
                        cmd.ExecuteScalar();
                        retorno = outValue.Value.ToString();
                    }
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
        protected void AcoesBotoes(object sender, CommandEventArgs args)
        {
            hfOperacao.Value = args.CommandArgument.ToString();
            switch (hfOperacao.Value)
            {
                case "inserir":
                    hfOPIDCONT.Value = null;
                    ddeEstruturaInsert.Enabled = true;
                    txtOperadorInsert.Text = hfUser.Value;
                    txtNumProcessoInsert.Enabled = true;
                    txtDescricaoInsert.Enabled = true;
                    txtCodAuxInsert.Enabled = true;
                    txtDtAquisiInsert.Enabled = true;
                    txtDtAssInsert.Enabled = true;
                    txtDtEncerraInsert.Enabled = true;
                    txtValorContInsert2.Enabled = true;
                    txtIniPagInsert.Enabled = true;
                    txtFimPagInsert.Enabled = true;
                    dropEstruturaInsert2.Enabled = true;
                    dropClasseProdutoInsert2.Enabled = true;
                    dropProdutoInsert2.Enabled = true;
                    dropCarteiraInsert2.Enabled = true;
                    dropAgenteFinanceiroInsert2.Enabled = true;
                    dropBenefIns.Enabled = true;
                    dropParcInsert.Enabled = true;
                    dropCareInsert.Enabled = true;
                    dropSaldoInsert.Enabled = true;
                    btnOK1.Enabled = true;
                    btnCancelar1.Enabled = true;
                    btnEdit.Enabled = false;
                    btnEdit.Enabled = false;
                    btnDelete.Enabled = false;
                    gridVerbasAlt.SettingsDataSecurity.AllowDelete = true;
                    gridVerbasAlt.SettingsDataSecurity.AllowEdit = true;
                    gridVerbasAlt.SettingsDataSecurity.AllowInsert = true;
                    mv_contrato.SetActiveView(this.view_1);
                    break;
                case "alterar":
                    ASPxButton btnImportar = gridSubContratos.FindStatusBarTemplateControl("btnImportar") as ASPxButton;
                    btnImportar.Enabled = true;
                    ddeEstruturaInsert.Enabled = false;
                    txtNumProcessoInsert.Enabled = false;
                    txtDescricaoInsert.Enabled = false;
                    txtCodAuxInsert.Enabled = false;
                    txtDtAquisiInsert.Enabled = false;
                    txtDtAssInsert.Enabled = false;
                    txtDtEncerraInsert.Enabled = false;
                    txtValorContInsert2.Enabled = false;
                    txtIniPagInsert.Enabled = false;
                    txtFimPagInsert.Enabled = false;
                    dropEstruturaInsert2.Enabled = false;
                    dropClasseProdutoInsert2.Enabled = false;
                    dropProdutoInsert2.Enabled = false;
                    dropCarteiraInsert2.Enabled = false;
                    dropAgenteFinanceiroInsert2.Enabled = false;
                    dropBenefIns.Enabled = false;
                    dropParcInsert.Enabled = false;
                    dropCareInsert.Enabled = false;
                    dropSaldoInsert.Enabled = false;
                    btnOK1.Enabled = true;
                    btnCancelar1.Enabled = true;
                    btnInsert.Enabled = false;
                    btnEdit.Enabled = false;
                    btnDelete.Enabled = false;
                    gridVerbasAlt.SettingsDataSecurity.AllowDelete = true;
                    gridVerbasAlt.SettingsDataSecurity.AllowEdit = true;
                    gridVerbasAlt.SettingsDataSecurity.AllowInsert = true;
                    mv_contrato.SetActiveView(this.view_1);
                    break;
                case "excluir":
                    ASPxButton btnImportar2 = gridSubContratos.FindStatusBarTemplateControl("btnImportar") as ASPxButton;
                    btnImportar2.Enabled = false;
                    mv_contrato.SetActiveView(this.view_2);
                    btnOK1.Enabled = true;
                    btnCancelar1.Enabled = true;
                    btnInsert.Enabled = false;
                    btnEdit.Enabled = false;
                    btnDelete.Enabled = false;
                    break;
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
        protected void TreeList_Load(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treelist = (DevExpress.Web.ASPxTreeList.ASPxTreeList)sender;
            if (SqlDataSource1 == null) return;
            treelist.DataBind();
        }
        protected void myLinkTagBtn_Click(object sender, EventArgs e)
        {
            if (txtDescricaoInsert.Enabled)
            {
                if (txtCodInternoInsert.Text != string.Empty)
                {
                    if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(opidcont) from opcontra where opidcont=" + txtCodInternoInsert.Text, 1)[0]) > 1)
                    {
                        MsgException("Contract already exists!", 1);
                        Response.Redirect("Aquisicao");
                    }
                    if (hfInsertOK.Value == "1")
                    {
                        CarregaContrato(Convert.ToInt32(txtCodInternoInsert.Text), false);
                        return;
                    }
                }
                txtCodInternoInsert.Text = CarregaCodInterno("2", 1);
                hfCodInterno.Value = txtCodInternoInsert.Text;
                hfOPIDCONT.Value = txtCodInternoInsert.Text;
                Session["ID"] = txtCodInternoInsert.Text;
                string[] value = dropProdutoInsert2.SelectedItem.Value.ToString().Split('|');
                hfProduto.Value = value[0];
                hfCHIDCODI.Value = value[1];
                hfEstruturaCorporativa.Value = ddeEstruturaInsert.KeyValue.ToString();
                string sql = null;
                try
                {
                    string benefic = dropBenefIns.SelectedItem == null ? "NULL" : dropBenefIns.SelectedItem.Value.ToString();
                    string favorec = dropAgenteFinanceiroInsert2.SelectedItem == null ? "NULL" : dropAgenteFinanceiroInsert2.SelectedItem.Value.ToString();
                    sql = "INSERT INTO [dbo].[OPCONTRA] ([TVIDESTR],[OPCDCONT],[OPNMCONT],[USIDUSUA],[CMTPIDCM],[PRTPIDOP],[PRPRODID],[OPVLCONT],[OPDTASCO],[OPDSHORA],[CAIDCTRA],[OPIDCONT],[OPTPFRID],[TPIDSINA],[OPTPRGID],[OPTPTPID],[FOIDFORN],[FOIDFORN2],[OPTPGARE],[OPCDAUXI],[OPDTBACO],[OPDTENCO],[OPFLPARC],[OPFLCARE],[OPFLSLDI],[OPDTINPG],[OPDTFMPG]) " +
                                "VALUES(" + hfEstruturaCorporativa.Value + ", '" + txtNumProcessoInsert.Text + "', '" + txtDescricaoInsert.Text + "', '" + txtOperadorInsert.Text + "', " + dropEstruturaInsert2.SelectedItem.Value + ", " + dropClasseProdutoInsert2.SelectedItem.Value + ", " + hfProduto.Value + ", " + txtValorContInsert2.Text.Replace(",", ".") + ", convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAssInsert.Text) + "',103), '00:00:00', " + dropCarteiraInsert2.SelectedItem.Value + ", " + txtCodInternoInsert.Text + ", 1, 1, 1, 91," + favorec + "," + benefic + ",null,'" + txtCodAuxInsert.Text + "',convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAquisiInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtEncerraInsert.Text) + "',103)," + dropParcInsert.SelectedItem.Value + "," + dropCareInsert.SelectedItem.Value + "," + dropSaldoInsert.SelectedItem.Value + ",convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtIniPagInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtFimPagInsert.Text) + "',103))";


                    hfSqlInsert.Value = sql;
                    string execucao = DataBase.Consultas.InsertContrato(str_conn, sql);
                    if (execucao == "Sucesso")
                    {
                        BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
                        btnOK1.Enabled = false;
                        btnCancelar1.Enabled = false;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { $('#cardInsert .show').removeClass('show');$('[id *= panelActive1]').val('#collapseInsertBases'); });", true);
                        ddeEstruturaInsert.Enabled = true;
                        txtOperadorInsert.Text = hfUser.Value;
                        txtNumProcessoInsert.Enabled = true;
                        txtDescricaoInsert.Enabled = true;
                        txtCodAuxInsert.Enabled = true;
                        txtDtAquisiInsert.Enabled = true;
                        txtDtAssInsert.Enabled = true;
                        txtDtEncerraInsert.Enabled = true;
                        txtValorContInsert2.Enabled = true;
                        txtIniPagInsert.Enabled = true;
                        txtFimPagInsert.Enabled = true;
                        dropEstruturaInsert2.Enabled = true;
                        dropClasseProdutoInsert2.Enabled = true;
                        dropProdutoInsert2.Enabled = true;
                        dropCarteiraInsert2.Enabled = true;
                        dropAgenteFinanceiroInsert2.Enabled = true;
                        dropBenefIns.Enabled = true;
                        dropParcInsert.Enabled = true;
                        dropCareInsert.Enabled = true;
                        dropSaldoInsert.Enabled = true;
                        btnOK1.Enabled = false;
                        ASPxButton btnImportar = gridSubContratos.FindStatusBarTemplateControl("btnImportar") as ASPxButton;
                        btnImportar.Enabled = true;

                    }
                    else
                    {
                        MsgException(execucao, 1);
                    }

                }
                catch (Exception ex)
                {
                    MsgException(ex.Message.ToString(), 1);
                }
            }
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
            dropBenefIns.DataBind();
        }
        protected void dropCarteiraInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropCarteiraInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "select CAIDCTRA,CADSCTRA from cacteira where (tvidestr=" + e.Parameter + " or tvidestr=1) order by cadsctra");
                dropCarteiraInsert2.DataBind();
            }
        }
        protected void dropAgenteFinanceiroInsert2_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropAgenteFinanceiroInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8 order by fonmforn");
                dropAgenteFinanceiroInsert2.DataBind();
            }
        }
        protected void dropBenefIns_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropBenefIns.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8  order by fonmforn");
                dropBenefIns.DataBind();
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
            rptBasesInserir.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
            rptBasesInserir.DataBind();
        }
        protected void DelBasesEdit(object sender, CommandEventArgs e)
        {
            string del = "delete cjclprop_din where chidcodi=" + hfCHIDCODI2.Value + " and opidcont=" + hfCodInterno.Value + " and cjidcodi=" + hfCJIDCODI2.Value + "";
            string result = DataBase.Consultas.DeleteFrom(str_conn, del);
            popupBasesAlterar.ShowOnPageLoad = false;
            BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
        }
        protected void btnEditarData_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(3);
        }
        protected void btnEditarMoeda_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(10);
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
                //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is null and cjdtdtde='" + itens.OldValues["De"].ToString() + "' and cjdtdtat='" + itens.OldValues["Ate"].ToString() + "'";
                //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                //string del1 = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is null and cjdtdtde=convert(datetime,'" + itens.OldValues["De"].ToString() + "',103) and cjdtdtat=convert(datetime,'" + itens.OldValues["Ate"].ToString() + "',103) and CJVLDEAT="+ itens.OldValues["Valor"].ToString().Replace(",",".")+"";
                //string delete1 = Consultas.DeleteFrom(str_conn, del1);
                string result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, new DateTime(1970, 01, 01), Convert.ToDateTime(De, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(Ate, CultureInfo.GetCultureInfo(lang)), Valor.Replace(",", "."), Convert.ToInt32(itens.Keys["ID"]));
                oper = 0;
            }
            foreach (var itens in e.InsertValues)
            {
                string De = itens.NewValues["De"].ToString();
                string Ate = itens.NewValues["Ate"].ToString();
                string Valor = itens.NewValues["Valor"].ToString();
                string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, new DateTime(1970, 01, 01), Convert.ToDateTime(De, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(Ate, CultureInfo.GetCultureInfo(lang)), Valor.Replace(",", "."));
                oper = 1;
            }
            foreach (var itens in e.DeleteValues)
            {
                string De = itens.Values["De"].ToString();
                string Ate = itens.Values["Ate"].ToString();
                string Valor = itens.Values["Valor"].ToString();
                string del = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is null and cjdtdtde=convert(datetime,'" + Convert.ToDateTime(De).ToString("dd/MM/yyyy") + "',103) and cjdtdtat=convert(datetime,'" + Convert.ToDateTime(Ate).ToString("dd/MM/yyyy") + "',103) and CJVLDEAT=" + Valor.Replace(",", ".") + "";
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
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), "1 Item", 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
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
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
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
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            }
            string upt = "update cjclprop_din set cjtpcttx='" + str + "' where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is not null";
            DataBase.Consultas.UpdateFrom(str_conn, upt);
            gridRptDeAte.DataSource = DataBase.Consultas.Consulta(str_conn, hfqueryRpt.Value);
            gridRptDeAte.DataBind();
            //BasesNegociacaoEdit(hfCodInterno.Value, 1);
            BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
        }
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
        protected void btnEditarTexto_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(13);
        }
        protected void gridRptDeAteData_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
        {

        }
        protected void gridRptDeAteData_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {

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
                            result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, Convert.ToDateTime(txtEditarData.Text), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                            oper = result == "OK" ? 1 : 0;
                        }
                        else
                        {
                            result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, Convert.ToDateTime(txtEditarData.Text), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                        }
                        if (result != "OK")
                        {
                            MsgException("Erro: " + result, 1);
                        }
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
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarFlutuante.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                    {
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarFlutuante.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }

                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "8": //Tipo Fórmula paramétrica
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.SelectedValue, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                    {
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.SelectedValue, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "15": //Tipo Indice
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarIndice.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarIndice.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "9": //Tipo Inteiro
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarInteiro.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, Convert.ToInt32(txtEditarInteiro.Text), null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "10": //Tipo Moeda

                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarMoeda.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, txtEditarMoeda.Text.Replace(",", "."), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "4": //Tipo De Até

                    break;
                case "12": //Tipo SQL
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarSql2.SelectedItem.Text, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarSql2.SelectedItem.Text, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
                case "13": //Tipo TEXTO
                    if (qntd != 0)
                    {
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), txtEditarTexto.Text, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), txtEditarTexto.Text, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, 1);
                    break;
            }
            popupBasesAlterar.ShowOnPageLoad = false;
        }
        protected string InsertPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, DateTime p_cjdtprop, DateTime p_cjdtdtde, DateTime p_cjdtdtat, string p_cjvldeat)
        {
            bool audit = hfOperacao.Value == "aditamento";
            string dtAdit = null;
            if (dtAdit == string.Empty)
            {
                dtAdit = DateTime.Now.ToShortDateString();
            }
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
                    cmd.Parameters.AddWithValue("@p_opdtadit", audit ? Convert.ToDateTime(dtAdit, CultureInfo.GetCultureInfo(lang)).ToString("yyyy-MM-dd") : "");
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
        protected string AlterarPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, DateTime p_cjdtprop, DateTime p_cjdtdtde, DateTime p_cjdtdtat, string p_cjvldeat, int p_opidiseq = 0)
        {
            bool audit = hfOperacao.Value == "aditamento";
            string dtAdit = null;
            if (dtAdit == string.Empty)
            {
                dtAdit = DateTime.Now.ToShortDateString();
            }
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
                    cmd.Parameters.AddWithValue("@p_opdtadit", audit ? Convert.ToDateTime(dtAdit, CultureInfo.GetCultureInfo(lang)).ToString("yyyy-MM-dd") : "");
                    cmd.Parameters.AddWithValue("@p_opidiseq", p_opidiseq);
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
            }
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
        protected void BasesEdit(object sender, CommandEventArgs e)
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
                    btnEditarData.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    btnEditarDataDel.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
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
                    btnEditarFlutuante.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    Button6.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
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
                    btnEditarFormula.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    Button7.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
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
                    btnEditarIndice.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    Button8.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
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
                    btnEditarInteiro.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    Button5.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    break;
                case "13": //Tipo Texto
                    lblEditarTexto.Text = cjdsdecr;
                    txtEditarTexto.Text = cjtpcttx;
                    MultiView1.ActiveViewIndex = 8;
                    btnEditarTexto.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button3.Visible = false;
                    else if (temProp > 0)
                        Button3.Visible = true;
                    btnEditarTexto.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    Button3.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
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
                    btnEditarMoeda.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    Button4.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    break;
                case "4": //Tipo De Até
                    string sql = "select cjdtdtde De,cjdtdtat Ate,cjvldeat Valor,OPIDISEQ ID from cjclprop_din " +
                                "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                                  "and opidcont = " + hfCodInterno.Value + " " +
                                  "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                                  "and CJTPCTTX is null order by 1";
                    hfqueryRpt.Value = sql;
                    gridRptDeAte.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
                    gridRptDeAte.DataBind();
                    MultiView1.ActiveViewIndex = 7;
                    gridRptDeAte.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    break;
                case "44": //Tipo De Até Data
                    string sql2 = "select cjdtdtde De,cjdtdtat Ate,cjvldeat Valor,cjdtprop Data,OPIDISEQ ID from cjclprop_din " +
                                "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                                  "and opidcont = " + hfCodInterno.Value + " " +
                                  "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                                  "and CJTPCTTX is null order by 1";
                    hfqueryRpt.Value = sql2;
                    gridRptDeAteData.DataSource = DataBase.Consultas.Consulta(str_conn, sql2);
                    gridRptDeAteData.DataBind();
                    MultiView1.ActiveViewIndex = 9;
                    gridRptDeAteData.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
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
                    btnEditarSql.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    Button9.Enabled = hfOperacao.Value == "alterar" || hfOperacao.Value == "inserir";
                    break;
            }
            popupBasesAlterar.HeaderText = cjdsdecr;
            popupBasesAlterar.ShowOnPageLoad = true;
        }
        protected void Button10gridDeAte_Click(object sender, EventArgs e)
        {
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        protected void gridSubContratos_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string opidcont = gridSubContratos.GetRowValues(e.VisibleIndex, "opidcont").ToString();
            switch (e.ButtonID)
            {
                case "encerrar":

                    break;
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (Session["fileName"] != null)
            {
                lblErrorFileUpload.Text = null;
                DateTime dtEncerra = Convert.ToDateTime(DataBase.Consultas.Consulta(str_conn, "select OPDTENCO from OPCONTRA where OPIDCONT=" + hfOPIDCONT.Value, 1)[0]);

                using (var workBook = new XLWorkbook(Session["fileName"].ToString()))
                {
                    IXLWorksheet workSheet = workBook.Worksheet(1);

                    DataTable dt = new DataTable();

                    bool firstRow = true;
                    foreach (IXLRow row in workSheet.Rows())
                    {
                        //Use the first row to add columns to DataTable.
                        if (firstRow)
                        {
                            foreach (IXLCell cell in row.Cells())
                            {
                                dt.Columns.Add(cell.Value.ToString());
                            }
                            firstRow = false;
                        }
                        else
                        {
                            //Add rows to DataTable.
                            dt.Rows.Add();
                            int i = 0;
                            foreach (IXLCell cell in row.Cells())
                            {
                                dt.Rows[dt.Rows.Count - 1][i] = cell.Value.ToString();
                                i++;

                            }
                        }
                    }
                    if (dt.Rows[0][1].ToString() != string.Empty)
                    {
                        decimal valorContrato = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, "select case when sum(OPVLCONT) is null then 0 else sum(OPVLCONT) end from opcontra where OPIDAACC=" + hfOPIDCONT.Value + " and OPTPTPID=1", 1)[0]);
                        decimal valorTotal = 0;
                        int contLinha = 1;
                        string OPIDCONT = string.Empty;
                        foreach (DataRow linha in dt.Rows)
                        {

                            contLinha++;
                            if (linha[0].ToString() != "" && linha[1].ToString() != "" && linha[2].ToString() != "" && linha[3].ToString() != "" && linha[4].ToString() != "" && linha[7].ToString() != "" && linha[8].ToString() != "" && linha[9].ToString() != "")
                            {
                                if (!DateTime.TryParse(linha[2].ToString(), out DateTime dtliberacao))
                                {
                                    lblErrorFileUpload.Text += "Falha na importação: Linha " + contLinha + " Data liberação formato incorreto ou nulo.<br />";
                                    continue;
                                }
                                if (!DateTime.TryParse(linha[7].ToString(), out DateTime dtPrimParcela))
                                {
                                    lblErrorFileUpload.Text += "Falha na importação: Linha " + contLinha + " Primeira Parcela formato incorreto ou nulo.<br />";
                                    continue;
                                }
                                if (!Int32.TryParse(linha[9].ToString(), out int intervalo))
                                {
                                    lblErrorFileUpload.Text += "Falha na importação: Linha " + contLinha + " Intervalo dias formato incorreto ou nulo.<br />";
                                    continue;
                                }
                                if (!Int32.TryParse(linha[8].ToString(), out int aniversario))
                                {
                                    lblErrorFileUpload.Text += "Falha na importação: Linha " + contLinha + " Aniversario formato incorreto ou nulo.<br />";
                                    continue;
                                }
                                if (!string.IsNullOrEmpty(linha[5].ToString()) && !Decimal.TryParse(linha[5].ToString(), out Decimal taxaDescTeste))
                                {
                                    lblErrorFileUpload.Text += "Falha na importação: Linha " + contLinha + " Taxa Desc formato incorreto ou nulo.<br />";
                                    continue;
                                }
                                if (!string.IsNullOrEmpty(linha[6].ToString()) && !Decimal.TryParse(linha[6].ToString(), out Decimal taxaNomTeste))
                                {
                                    lblErrorFileUpload.Text += "Falha na importação: Linha " + contLinha + " Taxa Nominal formato incorreto ou nulo.<br />";
                                    continue;
                                }
                                DataBase.Consultas.GravaLog = false;
                                string OPCDAUXI = linha[0].ToString();
                                string OPNMCONT = DataBase.Consultas.Consulta(str_conn, "select concat(OPNMCONT,'_','" + linha[1].ToString() + "') from OPCONTRA where OPIDCONT=" + hfOPIDCONT.Value, 1)[0];
                                if (OPNMCONT.Length > 60)
                                    OPNMCONT = OPNMCONT.Substring(0, 60);
                                //DateTime dtliberacao = Convert.ToDateTime(linha[2]);
                                string valorParcelas = linha[3].ToString();
                                //int nrParcelas = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "SELECT count(monthid) from(  SELECT Month(DATEADD(MONTH, x.number, convert(date,'"+dtliberacao.ToString("dd/MM/yyyy")+"',103))) AS MonthId  FROM master.dbo.spt_values x  WHERE x.type = 'P' AND x.number <= DATEDIFF(MONTH, convert(date,'"+ dtliberacao.ToString("dd/MM/yyyy") + "',103), convert(date,'"+ dtEncerra.ToString("dd/MM/yyyy") + "',103))) A ", 1)[0]);
                                int nrParcelas = Convert.ToInt32(linha[4].ToString());
                                //DateTime dtPrimParcela = Convert.ToDateTime(linha[6]);
                                //int aniversario = Convert.ToInt32(linha[7].ToString());
                                //int intervalor = Convert.ToInt32(linha[8].ToString());
                                Decimal taxaDesc = !string.IsNullOrEmpty(linha[5].ToString()) ? Convert.ToDecimal(linha[5].ToString()) : 0;
                                Decimal taxaNom = !string.IsNullOrEmpty(linha[6].ToString()) ? Convert.ToDecimal(linha[6].ToString()) : 0;
                                DateTime dtEncerraFilho = dtPrimParcela.AddMonths((nrParcelas - 1) * (intervalo / 30));
                                valorTotal = nrParcelas * Convert.ToDecimal(valorParcelas);
                                OPIDCONT = CarregaCodInterno("2", 1);
                                string OPDTASCO = "convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103)";
                                string OPDTBACO = "convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103)";
                                string OPDTINPG = "convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103)";
                                string OPVLCONT = valorTotal.ToString();
                                string OPIDAACC = hfOPIDCONT.Value;
                                string OPCDCONT = DataBase.Consultas.Consulta(str_conn, "select count(*)+1 from OPCONTRA where OPIDAACC=" + hfOPIDCONT.Value, 1)[0];
                                string OPDTENCO = "convert(date,'" + dtEncerraFilho.ToString("dd/MM/yyyy") + "',103)";
                                string sqlInsertOPCONTRA = "INSERT INTO OPCONTRA (PRPRODID ,OPCDCONT ,OPIDCONT ,OPCDAUXI ,OPNMCONT ,FOIDFORN ,FOIDFORN2 ,OPDTASCO ,OPDTBACO ,OPDTENCO ,OPVLCONT ,CAIDCTRA ,OPDTINCO ,OPDSOBSE ,USIDUSUA ,TVIDESTR ,OPDSHORA ,CLACONID ,OPCDAUXA ,OPIDAACC ,PRTPIDOP ,OPTPFRID ,TPIDSINA ,OPTPRGID ,OPTPTPID ,OPTPCOT ,TPGARAID ,TPIDDOCU ,FOIDFOR2 ,OPVLORIG ,OPDTVALI ,VIIDSDFA ,FOIDBOLS ,OPNOTRAD ,OPCDDDTR ,OPNFONTR ,OPNRAMTR ,OPDTORIG ,OPQTTOLE ,TPIDTIPM ,TPIDMERC ,OPDTSALD ,TPIDCDPR ,TPIDTPPR ,TPIDPROR ,OPIDTRAD ,OPVLPRUN ,TPIDCOVE ,TPIDORVE ,COIDCONV ,OPNUPARC ,OPIDPERI ,OPDTPRVC ,OPIDFRPC ,CMTPIDCM ,TPCVIDTP ,OPIDBOLS ,OPIDBABO ,TPIDTIPO ,TPIDESTI ,TPIDFORM ,TPIDCOND ,OPIDINEC ,OPIDMEST ,PEIDPERI ,OPEXEXER ,FANUFATA ,OPANSFIN ,OPANSFFI ,PRCDBOLS ,OPNUNFEN ,OPDTEXER ,IEIDINEC ,OPIDRETE ,OPFLCHMA ,OPIDREFE ,OPIDITEM ,OPNRINTV ,OPNRPZFX ,OPNRPZPG ,OPIDTPPR ,OPIDPROR ,UNIDUNID ,OPCDNFAG ,OPVLADTO ,OPDTLQOP ,OPIDOPCA ,OPIDQTLT ,OPIDVISU ,TSIDPROC ,OPIDBROK ,OPDTINCI ,VBIDFREN ,FICDTRIB ,FCFRREAJ ,FCDSDENU ,FCCDTVSE ,FCCDTOBS ,FCCDTNSE ,FCCDTNOT ,FCCDTIFA ,DACDDIAU ,ATCDATIV ,GDCDCLIE ,FRCDFREN ,TPIDPRCA ,TPIDOTCO ,OVCDIDTP ,OPTPGARE ,MPIDMTPR ,OPFLSLDI ,OPFLCARE ,OPFLPARC ,OPDTINPG ,OPDTFMPG ,OPDTADIT ,OPSQADIT ,OPJUADIT ,OPTSADIT ,OPUSADIT ,REIDIMOV) " +
"SELECT PRPRODID, concat(OPCDCONT,'_',REPLACE(STR(@OPCDCONT, 4), SPACE(1), '0')), @OPIDCONT, '@OPCDAUXI', '@OPNMCONT', FOIDFORN, FOIDFORN2, @OPDTASCO, @OPDTBACO, @OPDTENCO, @OPVLCONT, CAIDCTRA, OPDTINCO, OPDSOBSE, USIDUSUA, TVIDESTR, OPDSHORA, CLACONID, OPCDAUXA, @OPIDAACC, PRTPIDOP, OPTPFRID, TPIDSINA, OPTPRGID, 1, OPTPCOT, TPGARAID, TPIDDOCU, FOIDFOR2, OPVLORIG, OPDTVALI, VIIDSDFA, FOIDBOLS, OPNOTRAD, OPCDDDTR, OPNFONTR, OPNRAMTR, OPDTORIG, OPQTTOLE, TPIDTIPM, TPIDMERC, OPDTSALD, TPIDCDPR, TPIDTPPR, TPIDPROR, OPIDTRAD, OPVLPRUN, TPIDCOVE, TPIDORVE, COIDCONV, OPNUPARC, OPIDPERI, OPDTPRVC, OPIDFRPC, CMTPIDCM, TPCVIDTP, OPIDBOLS, OPIDBABO, TPIDTIPO, TPIDESTI, TPIDFORM, TPIDCOND, OPIDINEC, OPIDMEST, PEIDPERI, OPEXEXER, FANUFATA, OPANSFIN, OPANSFFI, PRCDBOLS, OPNUNFEN, OPDTEXER, IEIDINEC, OPIDRETE, OPFLCHMA, OPIDREFE, OPIDITEM, OPNRINTV, OPNRPZFX, OPNRPZPG, OPIDTPPR, OPIDPROR, UNIDUNID, OPCDNFAG, OPVLADTO, OPDTLQOP, OPIDOPCA, OPIDQTLT, OPIDVISU, TSIDPROC, OPIDBROK, OPDTINCI, VBIDFREN, FICDTRIB, FCFRREAJ, FCDSDENU, FCCDTVSE, FCCDTOBS, FCCDTNSE, FCCDTNOT, FCCDTIFA, DACDDIAU, ATCDATIV, GDCDCLIE, FRCDFREN, TPIDPRCA, TPIDOTCO, OVCDIDTP, OPTPGARE, MPIDMTPR, OPFLSLDI, OPFLCARE, OPFLPARC, OPDTINPG, OPDTFMPG, OPDTADIT, 0, OPJUADIT, OPTSADIT, OPUSADIT, REIDIMOV " +
"FROM OPCONTRA WHERE OPIDCONT = " + hfOPIDCONT.Value;
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPCDAUXI", OPCDAUXI);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPIDCONT", OPIDCONT);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPDTASCO", OPDTASCO);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPDTBACO", OPDTBACO);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPDTENCO", OPDTENCO);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPDTINPG", OPDTINPG);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPVLCONT", OPVLCONT.Replace(",", "."));
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPIDAACC", OPIDAACC);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPCDCONT", OPCDCONT);
                                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPNMCONT", OPNMCONT);
                                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertOPCONTRA);
                                if (exec == "OK")
                                {
                                    if (DateTime.Compare(dtEncerra, dtEncerraFilho) < 0)
                                    {
                                        string updDtEncerra = "update opcontra set OPDTENCO = " + OPDTENCO + ", OPDTADIT=GETDATE(),OPJUADIT='Data Encerramento alterada devido importação do contrato filho código " + OPIDCONT + "' where opidcont= " + hfOPIDCONT.Value;
                                        exec = DataBase.Consultas.UpdtFrom(str_conn, updDtEncerra);
                                    }
                                    string sqlInsertCJCLPROP_DIN = "INSERT INTO CJCLPROP_DIN (OPIDCONT ,CHIDCODI ,CJIDCODI ,CJTPCTTX ,OPIDADIT ,CHTPIDEV ,CJDSCAOR ,CJIDVLDE ,CJIDVLAT ,CJVLVALO ,CJDSDECR ,CJINPROP ,CJVLPROP ,CJDTPROP ,CJDTDTDE ,CJDTDTAT ,CJVLDEAT ,OPDTADIT ,OPSQADIT) " +
"SELECT @OPIDCONT, CHIDCODI, CJIDCODI, CJTPCTTX, OPIDADIT, CHTPIDEV, CJDSCAOR, CJIDVLDE, CJIDVLAT, CJVLVALO, CJDSDECR, CJINPROP, CJVLPROP, CJDTPROP, CJDTDTDE, CJDTDTAT, CJVLDEAT, OPDTADIT, OPSQADIT " +
"FROM CJCLPROP_DIN where OPIDCONT = " + hfOPIDCONT.Value + " and CJIDCODI not in (264,265, 266,267,25701,273,13690,13748)";
                                    sqlInsertCJCLPROP_DIN = sqlInsertCJCLPROP_DIN.Replace("@OPIDCONT", OPIDCONT);
                                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertCJCLPROP_DIN);
                                    if (exec == "OK")
                                    {
                                        string CHIDCODI = DataBase.Consultas.Consulta(str_conn, "select p.chidcodi from opcontra o,PRPRODUT p where o.PRPRODID=p.prprodid and o.opidcont=" + hfOPIDCONT.Value, 1)[0];
                                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 264, 9, null, aniversario, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 265, 3, null, 0, null, dtPrimParcela, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 266, 9, null, nrParcelas, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 267, 9, null, intervalo, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 25701, 6, null, 0, valorParcelas, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 13690, 4, null, 0, null, new DateTime(1970, 01, 01), dtliberacao, dtEncerraFilho, valorParcelas.Replace(",", "."));
                                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 13690, 4, "1 Item", 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        //lblErrorFileUpload.Text += "Contrato " + OPCDAUXI + " importado com sucesso. <br />";
                                        if (taxaDesc != 0)
                                        {
                                            InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 273, 4, null, 0, null, new DateTime(1970, 01, 01), dtliberacao, dtEncerraFilho, taxaDesc.ToString().Replace(",", "."));
                                            InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 273, 4, "1 Item", 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        }
                                        if (taxaNom != 0)
                                        {
                                            InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 13748, 4, null, 0, null, new DateTime(1970, 01, 01), dtliberacao, dtEncerraFilho, taxaNom.ToString().Replace(",", "."));
                                            InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 13748, 4, "1 Item", 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                        }
                                        string sqlInsertVerba = "INSERT INTO VIOPMODA select '" + OPIDCONT + "' as OPIDCONT,MOIDMODA,CHIDCODI,CJIDCODI,VITPPGTO,VIDIAMOD,PFIDCRED,PFIDDEBI from VIOPMODA V where V.OPIDCONT=" + hfOPIDCONT.Value;
                                        exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertVerba);
                                        lblErrorFileUpload.Text += "Importação com sucesso: Linha " + contLinha + " ID " + OPIDCONT + "<br />";
                                    }
                                }
                                else
                                {
                                    lblErrorFileUpload.Text += "Falha na importação: " + exec + "<br />";
                                }
                            }
                            else
                            {
                                lblErrorFileUpload.Text += "Falha na importação: Linha " + contLinha + " formatada de forma incorreta.<br />";
                            }
                            valorContrato = valorContrato + valorTotal;
                        }
                        if (!string.IsNullOrEmpty(OPIDCONT))
                        {
                            string updVlContrato = "update opcontra set OPVLCONT = " + valorContrato.ToString().Replace(",", ".") + ", OPDTADIT=GETDATE(),OPJUADIT='Valor do Contrato alterado devido importação do contrato filho código " + OPIDCONT + "' where opidcont= " + hfOPIDCONT.Value;
                            string exec2 = DataBase.Consultas.UpdtFrom(str_conn, updVlContrato);
                        }
                        if (File.Exists(Session["fileName"].ToString()))
                            File.Delete(Session["fileName"].ToString());
                        gridSubContratos.DataBind();
                    }
                    else
                    {
                        fileImport.ClientEnabled = true;
                        lblErrorFileUpload.Text = "Falha na importação: Planilha não contém informações.<br />";
                    }
                }
            }
        }
        protected void fileImport_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            string dir = System.Configuration.ConfigurationManager.AppSettings["PathETTJ"];
            string resultExtension = System.IO.Path.GetExtension(e.UploadedFile.FileName);
            string resultFileName = System.IO.Path.ChangeExtension(System.IO.Path.GetRandomFileName(), resultExtension);
            string resultFileUrl = dir + resultFileName;
            string resultFilePath = MapPath(resultFileUrl);
            e.UploadedFile.SaveAs(resultFilePath);
            string name = e.UploadedFile.FileName;
            string url = ResolveClientUrl(resultFileUrl);
            if (File.Exists(resultFilePath))
                Session["fileName"] = resultFilePath;
        }
        protected void btnDownloadModelo_Click(object sender, EventArgs e)
        {
            var pasta = new System.IO.DirectoryInfo(Server.MapPath("Content/SubContratos.xlsx"));
            System.IO.FileInfo file = new System.IO.FileInfo(pasta.FullName);
            if (file.Exists)
            {
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name);
                Response.AddHeader("Content-Length", file.Length.ToString());
                Response.Flush();
                Response.WriteFile(file.FullName);
            }
        }
        protected void gridVerbasAlt_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            e.Editor.ReadOnly = false;
        }
        protected void gridVerbasAlt_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            string sqlValida = "select count(*) from VIOPMODA v where v.OPIDCONT=@opidcont and v.MOIDMODA=@moidmoda";
            if (e.IsNewRow)
            {
                sqlValida = sqlValida.Replace("@opidcont", hfCodInterno.Value);
                sqlValida = sqlValida.Replace("@moidmoda", e.NewValues["MOIDMODA"].ToString());
                bool duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) > 0;
                if (duplicado)
                {
                    e.RowError = "Verba Duplicada";
                }
            }
        }
        protected void gridVerbasAlt_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.InsertValues)
            {
                if (item.NewValues["ID"] == null)
                {
                    string moidmoda = item.NewValues["MOIDMODA"].ToString();
                    string VIDIAMOD = item.NewValues["VIDIAMOD"].ToString();
                    string opidcont = hfCodInterno.Value;
                    string VITPPGTO = item.NewValues["VITPPGTO"] == null ? "NULL" : item.NewValues["VITPPGTO"].ToString();
                    string PFIDCRED = item.NewValues["PFIDCRED"] == null ? "NULL" : item.NewValues["PFIDCRED"].ToString();
                    string PFIDDEBI = item.NewValues["PFIDDEBI"] == null ? "NULL" : item.NewValues["PFIDDEBI"].ToString();
                    string sql = "insert into VIOPMODA (MOIDMODA,OPIDCONT,VITPPGTO,VIDIAMOD,PFIDCRED,PFIDDEBI) values (@MOIDMODA,@OPIDCONT,@VITPPGTO,@VIDIAMOD,@PFIDCRED,@PFIDDEBI)";
                    sql = sql.Replace("@MOIDMODA", moidmoda);
                    sql = sql.Replace("@OPIDCONT", opidcont);
                    sql = sql.Replace("@VITPPGTO", VITPPGTO);
                    sql = sql.Replace("@VIDIAMOD", VIDIAMOD);
                    sql = sql.Replace("@PFIDCRED", PFIDCRED);
                    sql = sql.Replace("@PFIDDEBI", PFIDDEBI);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sql);
                    if (exec == "OK")
                    {
                        gridVerbasAlt.DataBind();
                    }
                }
                else
                {
                    string moidmoda = item.NewValues["MOIDMODA"].ToString();
                    string VIDIAMOD = item.NewValues["VIDIAMOD"].ToString();
                    string opidcont = hfCodInterno.Value;
                    string chidcodi = item.NewValues["ID"].ToString().Split('#')[0];
                    string cjidcodi = item.NewValues["ID"].ToString().Split('#')[1];
                    string VITPPGTO = item.NewValues["VITPPGTO"] == null ? "NULL" : item.NewValues["VITPPGTO"].ToString();
                    string PFIDCRED = item.NewValues["PFIDCRED"] == null ? "NULL" : item.NewValues["PFIDCRED"].ToString();
                    string PFIDDEBI = item.NewValues["PFIDDEBI"] == null ? "NULL" : item.NewValues["PFIDDEBI"].ToString();
                    string sql = "insert into VIOPMODA (MOIDMODA,OPIDCONT,CHIDCODI,CJIDCODI,VITPPGTO,VIDIAMOD,PFIDCRED,PFIDDEBI) values (@MOIDMODA,@OPIDCONT,@CHIDCODI,@CJIDCODI,@VITPPGTO,@VIDIAMOD,@PFIDCRED,@PFIDDEBI)";
                    sql = sql.Replace("@MOIDMODA", moidmoda);
                    sql = sql.Replace("@OPIDCONT", opidcont);
                    sql = sql.Replace("@CHIDCODI", chidcodi);
                    sql = sql.Replace("@CJIDCODI", cjidcodi);
                    sql = sql.Replace("@VITPPGTO", VITPPGTO);
                    sql = sql.Replace("@VIDIAMOD", VIDIAMOD);
                    sql = sql.Replace("@PFIDCRED", PFIDCRED);
                    sql = sql.Replace("@PFIDDEBI", PFIDDEBI);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sql);
                    if (exec == "OK")
                    {
                        gridVerbasAlt.DataBind();
                    }
                }
            }
            foreach (var item in e.DeleteValues)
            {
                string VIIDMODA = item.Values["VIIDMODA"].ToString();
                string sql = "DELETE FROM VIOPMODA WHERE VIIDMODA=@VIIDMODA";
                sql = sql.Replace("@VIIDMODA", VIIDMODA);
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
                if (exec == "OK")
                    gridVerbasAlt.DataBind();
            }
            foreach (var item in e.UpdateValues)
            {
                var ID = item.NewValues["ID"].ToString().Split('#');
                string moidmoda = item.NewValues["MOIDMODA"].ToString();
                string chidcodi = ID.Length == 2 ? ID[0] : "NULL";
                string cjidcodi = ID.Length == 2 ? ID[1] : "NULL";
                string VITPPGTO = item.NewValues["VITPPGTO"] == null ? "NULL" : item.NewValues["VITPPGTO"].ToString();
                string VIDIAMOD = item.NewValues["VIDIAMOD"] == null ? item.OldValues["VIDIAMOD"].ToString() : item.NewValues["VIDIAMOD"].ToString();
                string PFIDCRED = item.NewValues["PFIDCRED"] == null ? item.OldValues["PFIDCRED"].ToString() : item.NewValues["PFIDCRED"].ToString();
                string PFIDDEBI = item.NewValues["PFIDDEBI"] == null ? item.OldValues["PFIDDEBI"].ToString() : item.NewValues["PFIDDEBI"].ToString();
                string VIIDMODA = item.Keys["VIIDMODA"].ToString();
                string sql = "update VIOPMODA set MOIDMODA=@MOIDMODA,CHIDCODI=@CHIDCODI,CJIDCODI=@CJIDCODI,VITPPGTO=@VITPPGTO,VIDIAMOD=@VIDIAMOD,PFIDCRED=@PFIDCRED,PFIDDEBI=@PFIDDEBI where VIIDMODA=@VIIDMODA";
                sql = sql.Replace("@MOIDMODA", moidmoda);
                sql = sql.Replace("@CHIDCODI", chidcodi);
                sql = sql.Replace("@CJIDCODI", cjidcodi);
                sql = sql.Replace("@VITPPGTO", VITPPGTO);
                sql = sql.Replace("@VIIDMODA", VIIDMODA);
                sql = sql.Replace("@VIDIAMOD", VIDIAMOD);
                sql = sql.Replace("@PFIDCRED", PFIDCRED);
                sql = sql.Replace("@PFIDDEBI", PFIDDEBI);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sql);
                if (exec == "OK")
                {
                    gridVerbasAlt.DataBind();
                }
            }
        }
        protected void btnSelectSubContrato_Click(object sender, EventArgs e)
        {
            int Index = Convert.ToInt32(gridSubContratos.FocusedRowIndex);
            string OPIDCONT = gridSubContratos.GetRowValues(gridSubContratos.FocusedRowIndex, "OPIDCONT").ToString();
            Response.Redirect("Aquisicao?token=" + DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], OPIDCONT));
        }
        protected void gridSubContratos_Load(object sender, EventArgs e)
        {
            ASPxButton btnImportar = gridSubContratos.FindStatusBarTemplateControl("btnImportar") as ASPxButton;
            btnImportar.Enabled = !string.IsNullOrEmpty(hfOPIDCONT.Value);
        }
    }
}