using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using AjaxControlToolkit;
using DataBase;
using DevExpress.Export;
using DevExpress.Utils;
using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using DevExpress.Web.Internal;

namespace WebNesta_IRFS_16
{
    public partial class Aquisicao1 : BasePage.BasePage
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
            countBasesInsert = 0;
            countBasesEdit = 0;
            if (!IsPostBack)
            {
                //ASPxDropDownEdit drop = ASPxCallbackPanel1.FindControl("ddeEstruturaInsert") as ASPxDropDownEdit;
                //RequiredFieldValidator19.ControlToValidate = drop.ID;
                panelActive1.Value = Request.Form[panelActive1.UniqueID];
                panelActive2.Value = Request.Form[panelActive2.UniqueID];
                lbltxtInt.Visible = false;
                lblcodInt.Visible = false;
                txtDtAdit.Text = DateTime.Now.ToShortDateString();
            }
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            else
                usuarioPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            user = usuarioPersist;
            hfUser.Value = user;
            hfUser2.Value = user;
            str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
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
                pnlGridDataEdit.Visible = false;
                pnlGridMoedaEdit.Visible = false;
                pnlGridInteiroEdit.Visible = false;
                pnlEditarFlutuante.Visible = false;
                pnlGridFormulaEdit.Visible = false;
                pnlGridIndiceEdit.Visible = false;
                pnlGridSQLEdit.Visible = false;
                pnlGridDeAteEdit.Visible = false;
                //ASPxGridView1.DataBind();
                ddePesqContrato.Enabled = true;
                txtOperadorInsert.Text = user;
                btnEdit.Enabled = false;
                btnDelete.Enabled = false;
                btnReplicar.Enabled = false;
                btnOK.Enabled = false;
                btnCancelar.Enabled = false;
                btnInsert.Enabled = true;
                hfPostBack.Value = "0";
                (this.Master.FindControl("hfOperacao") as HiddenField).Value = "0";
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
                if (Request.QueryString.Count > 0)
                {
                    try
                    {
                        string decriptRequest = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], Request.QueryString["source"]);
                        if (decriptRequest == "RequisitaContrato")
                        {
                            RequisitaContrato();
                        }
                    }
                    catch (Exception ex)
                    {

                    }
                }
            }
            else
            {
                hfPostBack.Value = "1";
            }
            string oper = (this.Master.FindControl("hfOperacao") as HiddenField).Value;
            if (oper != "0")
            {
                btnOK.Enabled = true;
                btnCancelar.Enabled = true;
            }
            if (hfqueryRpt.Value != string.Empty)
            {
                switch ((this.Master.FindControl("hfOperacao") as HiddenField).Value)
                {
                    case "inserir":
                        gridDeAteInsert.DataSource = Consultas.Consulta(str_conn, hfqueryRpt.Value);
                        gridDeAteInsert.DataBind();
                        break;
                    case "alterar":
                        gridRptDeAte.DataSource = Consultas.Consulta(str_conn, hfqueryRpt.Value);
                        gridRptDeAte.DataBind();
                        break;
                }
            }
            if (hfCodInterno.Value != string.Empty)
            {
                int chtpidev = dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value);
                BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
            }
            gridVerbasCons.DataBind();
            gridVerbasAlt.DataBind();
            gridVerbasIns.DataBind();
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
            if (!IsPostBack)
            {
                if (Request.QueryString.Count > 0)
                {
                    if (Request.QueryString["token"] != string.Empty)
                    {
                        string OPIDCONT = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], Request.QueryString["token"]);
                        if (!string.IsNullOrEmpty(OPIDCONT))
                            CarregaContrato(Convert.ToInt32(OPIDCONT), false);
                    }

                }
            }
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
        protected void CamposHabilitados(int flag)
        {
            switch (flag)
            {
                case 0://Visualização
                    txtEstCorpo.Enabled = false;
                    txtNumProc.Enabled = false;
                    txtDesc.Enabled = false;
                    txtEstrut.Enabled = false;
                    txtProd.Enabled = false;
                    txtDataAquisi.Enabled = false;
                    txtDtAss.Enabled = false;
                    txtDtEncerra.Enabled = false;
                    //txtFormatoOperacao.Enabled = false;
                    txtAgntFinanc.Enabled = false;
                    txtCarteira.Enabled = false;
                    txtClasseProduto.Enabled = false;
                    //txtEstruContra.Enabled = false;
                    //txtRegistro.Enabled = false;
                    txtTipo.Enabled = false;
                    break;
            }
        }
        protected void RequisitaContrato()
        {
            pnlHeaderInsert.Visible = false;
            pnlHeaderRequest.Visible = true;
            dropTipoInsert2.ClientEnabled = false;
            btnOK.ValidationGroup = "InsertReq";
            panelActive1.Value = null;
            panelActive2.Value = null;
            CarregaCombosInsert();
            ddePesqContrato.Enabled = false;
            pnlConsulta.Visible = false;
            pnlAlteracao.Visible = false;
            pnlInsert.Visible = true;
            pnlExclusao.Visible = false;
            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "requisita";
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            btnInsert.Enabled = false;
            btnReplicar.Enabled = false;
            dropEstruturaInsert2.DataBind();
        }
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            hfReplicar.Value = "0";
            pnlHeaderInsert.Visible = true;
            pnlHeaderRequest.Visible = false;
            btnOK.ValidationGroup = "InsertReq";
            panelActive1.Value = null;
            panelActive2.Value = null;
            CarregaCombosInsert();
            ddePesqContrato.Enabled = false;
            pnlConsulta.Visible = false;
            pnlAlteracao.Visible = false;
            pnlInsert.Visible = true;
            pnlExclusao.Visible = false;
            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "inserir";
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            btnInsert.Enabled = false;
            btnReplicar.Enabled = false;
            fileManager.SettingsEditing.AllowCreate = true;
            fileManager.SettingsEditing.AllowDelete = true;
            fileManager.SettingsEditing.AllowMove = true;
            fileManager.SettingsEditing.AllowRename = true;
            fileManager.SettingsEditing.AllowCopy = true;
            fileManager.SettingsEditing.AllowDownload = true;
            fileManager.SettingsUpload.Enabled = true;
            dropEstruturaInsert2.DataBind();
        }
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            hfReplicar.Value = "0";
            panelActive1.Value = null;
            panelActive2.Value = null;
            txtEstruturaCorporativaEdit.Enabled = false;
            txtEstruturaEdit.Enabled = false;
            txtProdutoEdit.Enabled = false;
            txtDataAquisicaoEdit.Enabled = false;
            txtIniPagEdit.Enabled = false;
            txtFimPagEdit.Enabled = false;
            txtdtAssEdit.Enabled = false;
            //txtFormatoOperEdit.Enabled = false;
            txtAgntFinancEdit.Enabled = false;
            txtCodInternoEdit.Enabled = false;
            txtNumProcessoEdit.Enabled = false;
            txtClasseProdEdit.Enabled = false;
            txtValorAquisicaoEdit.Enabled = false;
            txtImoveisEdit.Enabled = false;
            txtdtEncerraEdit.Enabled = false;
            BasesNegociacaoEdit(hfCodInterno.Value, 1, 1);
            filesAlterar.Enabled = true;
            pnlConsulta.Visible = false;
            pnlAlteracao.Visible = true;
            pnlInsert.Visible = false;
            pnlExclusao.Visible = false;
            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "alterar";
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            btnReplicar.Enabled = false;
            btnAditamento.Enabled = false;
            filesAlterar.Enabled = true;
            gridRptDeAte.SettingsDataSecurity.AllowDelete = false;
            gridRptDeAte.SettingsDataSecurity.AllowEdit = false;
            gridRptDeAte.SettingsDataSecurity.AllowInsert = false;
            pnlGridEdit.Enabled = false;
            fileManager.SettingsEditing.AllowCreate = true;
            fileManager.SettingsEditing.AllowDelete = true;
            fileManager.SettingsEditing.AllowMove = true;
            fileManager.SettingsEditing.AllowRename = true;
            fileManager.SettingsEditing.AllowCopy = true;
            fileManager.SettingsEditing.AllowDownload = true;
            fileManager.SettingsUpload.Enabled = true;
        }
        protected void btnAditamento_Click(object sender, EventArgs e)
        {
            hfReplicar.Value = "0";
            panelActive1.Value = null;
            panelActive2.Value = null;
            txtEstruturaCorporativaEdit.Enabled = false;
            txtEstruturaEdit.Enabled = false;
            txtProdutoEdit.Enabled = false;
            txtCodAuxiliarEdit.Enabled = false;
            txtDescricaoEdit.Enabled = false;
            dropCarteiraEdit.Enabled = false;
            dropTipoEdit.Enabled = false;
            txtImoveisEdit.Enabled = false;
            txtDataAquisicaoEdit.Enabled = dropEventoAditamento.Value.ToString() == "1";
            txtIniPagEdit.Enabled = dropEventoAditamento.Value.ToString() == "1";
            txtFimPagEdit.Enabled = dropEventoAditamento.Value.ToString() == "1";
            txtdtAssEdit.Enabled = dropEventoAditamento.Value.ToString() == "1";
            //txtFormatoOperEdit.Enabled = false;
            txtAgntFinancEdit.Enabled = false;
            txtCodInternoEdit.Enabled = false;
            txtNumProcessoEdit.Enabled = false;
            txtClasseProdEdit.Enabled = false;
            txtValorAquisicaoEdit.Enabled = true;
            txtdtEncerraEdit.Enabled = dropEventoAditamento.Value.ToString() == "1";
            dropBenefAlter.Enabled = false;
            dropParcEdit.Enabled = false;
            dropCareEdit.Enabled = false;
            dropSaldoEdit.Enabled = false;
            BasesNegociacaoEdit(hfCodInterno.Value, 1, Convert.ToInt32(dropEventoAditamento.Value));
            panelActive1.Value = "collapseAlterarBases";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { $('#cardAlterar .show').removeClass('show');$('[id *= panelActive1]').val('collapseAlterarBases'); });", true);
            filesAlterar.Enabled = false;
            pnlConsulta.Visible = false;
            pnlAlteracao.Visible = true;
            pnlInsert.Visible = false;
            pnlExclusao.Visible = false;
            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "aditamento";
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            btnReplicar.Enabled = false;
            btnAditamento.Enabled = false;
            RequiredFieldValidator22.Enabled = true;
            RequiredFieldValidator22.Enabled = true;
            gridVerbasAlt.SettingsDataSecurity.AllowDelete = false;
            gridVerbasAlt.SettingsDataSecurity.AllowEdit = false;
            gridVerbasAlt.SettingsDataSecurity.AllowInsert = false;
            filesAlterar.Visible = false;
            gridFilesAlterar.SettingsDataSecurity.AllowDelete = false;
            gridFilesAlterar.SettingsDataSecurity.AllowEdit = false;
            gridFilesAlterar.SettingsDataSecurity.AllowInsert = false;
            gridRptDeAte.SettingsDataSecurity.AllowDelete = true;
            gridRptDeAte.SettingsDataSecurity.AllowEdit = true;
            gridRptDeAte.SettingsDataSecurity.AllowInsert = true;
            pnlGridEdit.Enabled = true;
            btnEdit.Enabled = false;
            btnDelete.Enabled = false;
            btnHistorico.Enabled = false;
            btnInsert.Enabled = false;
            btnAditamento.Border.BorderWidth = Unit.Pixel(2);
            btnAditamento.Border.BorderStyle = BorderStyle.Solid;
            btnAditamento.Border.BorderColor = System.Drawing.Color.Red;
            popupAditamento.ShowOnPageLoad = false;
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            hfReplicar.Value = "0";
            pnlConsulta.Visible = false;
            pnlAlteracao.Visible = false;
            pnlInsert.Visible = false;
            pnlExclusao.Visible = true;
            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "excluir";
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            btnReplicar.Enabled = false;
            btnEdit.Text = "Alterar";
        }
        protected void btnEstruturaCorpInsert_Click(object sender, ImageClickEventArgs e)
        {
            PopularTreeView();
            pnlEstruturaCorpInsert.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModalEstrutura(); });", true);
        }
        protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
        {
            txtEstruturaCorporativaInsert.Text = TreeView1.SelectedNode.Text;
            hfEstruturaCorporativa.Value = TreeView1.SelectedNode.Value;
            hfOPIDCONT.Value = txtCodInternoInsert.Text;
            pnlEstruturaCorpInsert.Visible = false;
        }
        protected void PopularTreeView()
        {
            TreeView1.Nodes.Clear();
            using (OleDbConnection conexao = new OleDbConnection(str_conn))
            {
                conexao.Open();
                PreencheFilhos(null);
            }
        }
        protected void PreencheFilhos(TreeNode noPai)
        {
            OleDbConnection conexao = new OleDbConnection(str_conn);
            string sql = "SELECT B.TVIDESTR, B.TVDSESTR, B.TVCDPAIE, B.TVNVESTR, " +
                                   "A.FOCDXCGC, A.FOCDLICE " +
                            "FROM TVESTRUT B, FOFORNEC A " +
                            "WHERE B.TVIDESTR = A.TVIDESTR " +
                            "AND A.FOTPIDTP = 6 " +
                            "AND A.FOCDLICE IS NOT NULL " +
                            "AND B.TVIDESTR IN(SELECT DISTINCT TVIDESTR " +
                                               "FROM VIFSFUSU " +
                                               "WHERE USIDUSUA = '" + user + "')";
            sql += (noPai == null ? "" : "AND B.TVCDPAIE=" + noPai.Value);
            sql += " ORDER BY B.TVNVESTR, B.TVCDPAIE, B.TVIDESTR";
            OleDbCommand cmd = new OleDbCommand(sql, conexao);
            OleDbDataAdapter da = new OleDbDataAdapter(cmd);
            DataTable tabela = new DataTable();
            da.Fill(tabela);
            foreach (DataRow row in tabela.Rows)
            {
                TreeNode node = new TreeNode(row["tvdsestr"].ToString(), row["tvidestr"].ToString());
                if (noPai != null)
                    noPai.ChildNodes.Add(node);
                else
                    TreeView1.Nodes.Add(node);
                PreencheFilhos(node);
            }
        }
        protected void CarregaCombosInsert()
        {
            int pais = 1;
            string sqlEstrutura = "select cmtpdscm, cmtpidcm from cmtpcmcl where paidpais = " + pais + " order by cmtpidcm";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlEstrutura, con))
            //    {
            //        dropEstruturaInsert.DataTextField = "cmtpdscm";
            //        dropEstruturaInsert.DataValueField = "cmtpidcm";
            //        dropEstruturaInsert.DataSource = cmd.ExecuteReader();
            //        dropEstruturaInsert.DataBind();
            //        dropEstruturaInsert.Items.Insert(0, "   ");
            //        dropEstruturaInsert.SelectedIndex = 0;
            //    }
            //}
            txtDtAquisiInsert.Text = DateTime.Now.ToString("d", CultureInfo.GetCultureInfo(lang));
        }
        protected void dropEstruturaInsert_SelectedIndexChanged(object sender, EventArgs e)
        {
            int pais = 1;
            //string idRef = dropEstruturaInsert.SelectedValue;
            //Trecho popula drop Classe Produto
            //string sqlEstrutura = "select PRTPNMOP,PRTPIDOP from prtpoper po, cmtpcmcl cm " +
            //                      "where cm.cmtpidcm = " + idRef + " " +
            //                        "and cm.paidpais = " + pais + " " +
            //                        "and po.cmtpidcm = cm.cmtpidcm " +
            //                        "and po.paidpais = cm.paidpais " +
            //                      "order by po.prtpnmop";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlEstrutura, con))
            //    {
            //        dropClasseProdutoInsert.DataTextField = "PRTPNMOP";
            //        dropClasseProdutoInsert.DataValueField = "PRTPIDOP";
            //        dropClasseProdutoInsert.DataSource = cmd.ExecuteReader();
            //        dropClasseProdutoInsert.DataBind();
            //        dropClasseProdutoInsert.Items.Insert(0, "   ");
            //        dropClasseProdutoInsert.SelectedIndex = 0;
            //    }
            //}
            //Trecho popula drop Formato Operacao
            //string sqlFormatoOper = "select optpfrid, optpfrds from optpfrco " +
            //                          "where cmtpidcm = " + idRef + " " +
            //                            "and paidpais = " + pais + " " +
            //                          "order by optpfrds";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlFormatoOper, con))
            //    {
            //        dropFormatoOperacaoInsert.DataTextField = "optpfrds";
            //        dropFormatoOperacaoInsert.DataValueField = "optpfrid";
            //        dropFormatoOperacaoInsert.DataSource = cmd.ExecuteReader();
            //        dropFormatoOperacaoInsert.DataBind();
            //        dropFormatoOperacaoInsert.Items.Insert(0, "   ");
            //        dropFormatoOperacaoInsert.SelectedIndex = 0;
            //    }
            //}

            ////Trecho popula drop Tipo
            //string sqlTipo = "select optptpid, optptpds " +
            //                  "from optptipo " +
            //                  "where cmtpidcm = " + idRef + " " +
            //                    "and paidpais = " + pais + " " +
            //                  "order by optptpds";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlTipo, con))
            //    {
            //        dropTipoInsert.DataTextField = "optptpds";
            //        dropTipoInsert.DataValueField = "optptpid";
            //        dropTipoInsert.DataSource = cmd.ExecuteReader();
            //        dropTipoInsert.DataBind();
            //        //dropTipoInsert.Items.Insert(0, "   ");
            //        dropTipoInsert.SelectedIndex = 0;
            //    }
            //}


        }
        protected void dropClasseProdutoInsert_SelectedIndexChanged(object sender, EventArgs e)
        {
            int pais = 1;
            //string idRef = dropEstruturaInsert.SelectedValue;
            //string idRef2 = dropClasseProdutoInsert.SelectedValue;
            //string sqlEstrutura = "select CONCAT(pr.prprodid,'|',pr.chidcodi) value, pr.prprodes  " +
            //                      "from prprodut pr, prtpoper po, cmtpcmcl cm " +
            //                      "where cm.cmtpidcm = " + idRef + " " +
            //                        "and cm.paidpais = " + pais + " " +
            //                        "and po.cmtpidcm = cm.cmtpidcm " +
            //                        "and po.paidpais = cm.paidpais " +
            //                        "and po.PRTPIDOP = " + idRef2 + " " +
            //                        "and pr.prtpidop = po.PRTPIDOP " +
            //                        "and pr.cmtpidcm = po.cmtpidcm " +
            //                      "order by 2 ";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlEstrutura, con))
            //    {
            //        dropProdutoInsert.DataTextField = "prprodes";
            //        dropProdutoInsert.DataValueField = "value";
            //        dropProdutoInsert.DataSource = cmd.ExecuteReader();
            //        dropProdutoInsert.DataBind();
            //        dropProdutoInsert.Items.Insert(0, "   ");
            //        dropProdutoInsert.SelectedIndex = 0;
            //    }
            //}
        }
        protected void dropProdutoInsert_SelectedIndexChanged(object sender, EventArgs e)
        {
            int pais = 1;
            string sqlEstrutura = "select CAIDCTRA,CADSCTRA from cacteira order by cadsctra";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlEstrutura, con))
            //    {
            //        dropCarteiraInsert.DataTextField = "CADSCTRA";
            //        dropCarteiraInsert.DataValueField = "CAIDCTRA";
            //        dropCarteiraInsert.DataSource = cmd.ExecuteReader();
            //        dropCarteiraInsert.DataBind();
            //        //dropCarteiraInsert.Items.Insert(0, "   ");
            //        //dropCarteiraInsert.SelectedIndex = 0;
            //    }
            //}
            //string[] value = dropProdutoInsert2.SelectedItem.Value.ToString().Split('|');
            //hfProduto.Value = value[0];
            //hfCHIDCODI.Value = value[1];
            string sqlAgente = "SELECT FOIDFORN,concat(F.FOCDXCGC, ' - ',F.FONMAB20) FONMAB20 " +
                                "FROM FOFORNEC FO where TVIDESTR IS NULL " +
                                "ORDER BY 2";
            //using (var con = new OleDbConnection(str_conn))
            //{
            //    con.Open();
            //    using (var cmd = new OleDbCommand(sqlAgente, con))
            //    {
            //        dropAgenteFinanceiroInsert.DataTextField = "FONMFORN";
            //        dropAgenteFinanceiroInsert.DataValueField = "FOIDFORN";
            //        dropAgenteFinanceiroInsert.DataSource = cmd.ExecuteReader();
            //        dropAgenteFinanceiroInsert.DataBind();
            //        dropAgenteFinanceiroInsert.Items.Insert(0, "   ");
            //        dropAgenteFinanceiroInsert.SelectedIndex = 0;
            //    }
            //}
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
        protected string InsertPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, DateTime p_cjdtprop, DateTime p_cjdtdtde, DateTime p_cjdtdtat, string p_cjvldeat)
        {
            bool audit = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento";
            if (txtDtAdit.Text == string.Empty)
            {
                txtDtAdit.Text = DateTime.Now.ToShortDateString();
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
                    cmd.Parameters.AddWithValue("@p_opdtadit", audit ? Convert.ToDateTime(txtDtAdit.Text, CultureInfo.GetCultureInfo(lang)).ToString("yyyy-MM-dd") : "");
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
            bool audit = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento";
            if (txtDtAdit.Text == string.Empty)
            {
                txtDtAdit.Text = DateTime.Now.ToShortDateString();
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
                    cmd.Parameters.AddWithValue("@p_opdtadit", audit ? Convert.ToDateTime(txtDtAdit.Text, CultureInfo.GetCultureInfo(lang)).ToString("yyyy-MM-dd") : "");
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
                      "select cj.cjidcodi,cj.CJDSDECR,'__________' cjtpcttx,tp.CJTPDSTP,tp.CJTPIDTP,cj.CHIDCODI,cj.CJTPCTTX COMBO,cj.CJTPIDTP,cj.CJORORDE,0 CJVLPROP " +
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
        protected void BasesNegociacaoEdit(string opidcont, int pais, int chtpidev)
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
                rptBasesEdit.DataSource = Consultas.Consulta(str_conn, sql);
                rptBasesEdit.DataBind();
                rptBases.DataSource = Consultas.Consulta(str_conn, sql);
                rptBases.DataBind();
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
                rptBasesEdit.DataSource = Consultas.Consulta(str_conn, sql);
                rptBasesEdit.DataBind();
                rptBases.DataSource = Consultas.Consulta(str_conn, sql);
                rptBases.DataBind();
            }

        }
        protected void criaRepeater(int cont)
        {
            rptDeAte.DataSource = null;
            DataSet dados = new DataSet();
            DataTable dt = new DataTable("tabela_DeAte");
            dt.Columns.Add("De");
            dt.Columns.Add("Ate");
            dt.Columns.Add("Valor");
            for (int i = 0; i < cont; i++)
            {
                DataRow dr1 = dt.NewRow();
                dr1["De"] = "";
                dr1["Ate"] = "";
                dr1["Valor"] = "";
                dt.Rows.Add(dr1);
            }
            dados.Tables.Add(dt);
            rptDeAte.DataSource = dt;
            rptDeAte.DataBind();
        }
        protected void criaRepeaterEdit(int cont, string query)
        {
            rptDeAte.DataSource = null;
            DataTable dt = Consultas.Consulta(str_conn, query);
            int qtdAtual = dt.Rows.Count;
            if (cont == 0 || qtdAtual == cont)
            {
                rptDeAteEdit.DataSource = Consultas.Consulta(str_conn, query);
                rptDeAteEdit.DataBind();
            }
            else
            {
                if (cont > qtdAtual)
                {
                    cont = cont - qtdAtual;
                    for (int i = 0; i < cont; i++)
                    {
                        DataRow row = dt.NewRow();
                        row[0] = "01/01/1970";
                        row[1] = "01/01/1970";
                        row[2] = "0";
                        dt.Rows.Add(row);
                    }
                }
                rptDeAteEdit.DataSource = dt;
                rptDeAteEdit.DataBind();
            }
        }
        protected void btnInserirDeAte_Click(object sender, EventArgs e)
        {
            if (txtqtdItensDeAte.Text != string.Empty)
            {
                criaRepeater(Convert.ToInt32(txtqtdItensDeAte.Text));
            }
            else
            {
                MsgException("Quantidade de Item não pode ser nulo!", 1);
            }
        }
        protected void btnInsertDeAte_Click(object sender, EventArgs e)
        {
            //string data1, data2;
            //float valor = 0;
            //int cont = 0;
            //string result = "FALHA";
            //int[] resultDT = new int[rptDeAte.Items.Count];
            //int resultFinal = 0;
            //for (int i = 0; i < rptDeAte.Items.Count; i++)
            //{
            //    TextBox dt1 = (TextBox)rptDeAte.Items[i].FindControl("txtDt1");
            //    data1 = dt1.Text;
            //    TextBox dt2 = (TextBox)rptDeAte.Items[i].FindControl("txtDt2");
            //    data2 = dt2.Text;
            //    TextBox vl = (TextBox)rptDeAte.Items[i].FindControl("txtVl");
            //    valor = float.Parse(vl.Text.Replace(",", "."));
            //    resultDT[i] = DateTime.Compare(Convert.ToDateTime(dt1.Text, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(txtDtAquisiInsert.Text, CultureInfo.GetCultureInfo(lang)));
            //    for (int j = 0; j < resultDT.Length; j++)
            //    {
            //        if (resultDT[j] == -1)
            //        {
            //            resultFinal = -1;
            //        }
            //    }
            //    if (resultFinal != -1)//Data Anterior a Data Aquisição
            //    {
            //        if (data1 != null && data2 != null && valor != 0)
            //        {
            //            result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, 0, 0, null, data1, data2, valor);
            //            if (result == "OK")
            //            {
            //                cont = cont + 1;
            //            }
            //            else
            //            {
            //                MsgException("Falha ao inserir " + lblInserirDeAte.Text + ": " + result, 1);
            //                result = "FALHA";
            //            }
            //        }
            //        else
            //        {
            //            result = "FALHA";
            //            MsgException("Verificar preenchimento dos campos.", 1);
            //        }
            //    }
            //    else
            //        MsgException("Data De não pode ser anterior a Data do contrato.", 1);
            //}
            //if (result != "FALHA")
            //{
            //    string str = null;
            //    if (cont != 0 && cont > 1)
            //    {
            //        str = cont.ToString() + " Itens";
            //    }
            //    else if (cont == 1)
            //    {
            //        str = cont.ToString() + " Item";
            //    }
            //    result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), str, 0, 0, null, null, null, 0);
            //}
            //BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        protected void btnInserirContrato_Click(object sender, EventArgs e)
        {

        }
        private void EnabledPanelContents(Panel panel, bool enabled)
        {
            foreach (Control ctrl in panel.Controls)
            {
                if (ctrl.GetType().Name == "TextBox")
                {
                    TextBox txt = (TextBox)ctrl as TextBox;
                    txt.Enabled = enabled;
                }
                else if (ctrl.GetType().Name == "DropDownList")
                {
                    DropDownList drop = (DropDownList)ctrl as DropDownList;
                    drop.Attributes.Add("disabled", "disabled");
                }
                else if (ctrl.GetType().Name == "ASPxComboBox")
                {
                    ASPxComboBox combo = (ASPxComboBox)ctrl as ASPxComboBox;
                    combo.Enabled = false;
                }
                else if (ctrl.GetType().Name == "ASPxTextBox")
                {
                    ASPxTextBox combo = (ASPxTextBox)ctrl as ASPxTextBox;
                    combo.Enabled = false;
                }
                else if (ctrl.GetType().Name == "ASPxDropDownEdit")
                {
                    ASPxDropDownEdit dropE = (ASPxDropDownEdit)ctrl as ASPxDropDownEdit;
                    dropE.Enabled = false;
                }
            }
        }
        protected void txtDescricaoInsert_TextChanged(object sender, EventArgs e)
        {
            var valida = txtDescricaoInsert.Text.Replace('"', '\0').ToString();
        }
        protected void btnInserirData_Click(object sender, EventArgs e)
        {

            //DateTime date = Convert.ToDateTime(txtInserirData.Text, CultureInfo.GetCultureInfo(lang));
            int resultDt = DateTime.Compare(Convert.ToDateTime(txtInserirData.Text, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(txtDtAquisiInsert.Text, CultureInfo.GetCultureInfo(lang)));
            if (resultDt == -1)//Data Anterior a Data Aquisição
            {
                MsgException(lblInserirData.Text + " não pode ser anterior a Data do Contrato.", 1);
            }
            else
            {
                string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, 0, null, Convert.ToDateTime(txtInserirData.Text), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                if (result != "OK")
                {
                    MsgException("Erro: " + result, 1);
                }
                BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
            }
            popupBasesInsert.ShowOnPageLoad = false;
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
        protected void btnqtdEditarDeAte_Click(object sender, EventArgs e)
        {
            string sql = "select cjdtdtde De,cjdtdtat Ate,cjvldeat Valor, OPIDISEQ ID from cjclprop_din " +
            "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
              "and opidcont = " + hfCodInterno.Value + " " +
              "and cjidcodi = " + hfCJIDCODI2.Value + " " +
              "and CJTPCTTX is null";
            string a = txtEditarDeAte.Text.Trim().Replace("Item", "");
            a = a.Replace("Itens", "");
            int cont = Convert.ToInt32(a);
            hfqueryRpt.Value = sql;
            hfcontRpt.Value = cont.ToString();
            criaRepeaterEdit(cont, sql);
        }
        protected void btnAlterarContrato_Click(object sender, EventArgs e)
        {

        }
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
            int chtpidev = dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value);
            string queryQt = "select count(opidcont) from cjclprop_din " +
        "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
          "and opidcont = " + hfCodInterno.Value + " " +
          "and cjidcodi = " + hfCJIDCODI2.Value;
            int qntd = Convert.ToInt32(Consultas.Consulta(str_conn, queryQt, 1)[0]);
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
                        BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                        BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
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
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
                    break;
                case "8": //Tipo Fórmula paramétrica
                    if (qntd != 0)
                    {
                        //string sqlLog = "INSERT INTO CJCLPROP_DIN_AUX select * from CJCLPROP_DIN where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + "";
                        //string log = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.Value.ToString(), 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    else
                    {
                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), dropEditarFormula.Value.ToString(), 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                    if (result != "OK")
                    {
                        MsgException("Erro: " + result, 1);
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
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
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
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
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
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
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
                    break;
                case "4": //Tipo De Até
                    string data1, data2;
                    float valor = 0;
                    int cont = 0;
                    result = "FALHA";
                    int[] resultDT = new int[rptDeAteEdit.Items.Count];
                    int resultFinal = 0;
                    string query = "select cjidvlde De,CJIDVLAT Ate,CJVLVALO Valor from cjclprop_din " +
                    "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                      "and opidcont = " + hfCodInterno.Value + " " +
                      "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                      "and CJTPCTTX is null";
                    string queryDel = "delete cjclprop_din " +
                    "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                      "and opidcont = " + hfCodInterno.Value + " " +
                      "and cjidcodi = " + hfCJIDCODI2.Value;
                    DataTable dt = Consultas.Consulta(str_conn, query);
                    int qtdAtual = dt.Rows.Count;
                    for (int i = 0; i < qtdAtual; i++)
                    {
                        TextBox dt1 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt1Edit");
                        data1 = dt1.Text;
                        TextBox dt2 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt2Edit");
                        data2 = dt2.Text;
                        resultDT[i] = DateTime.Compare(Convert.ToDateTime(dt1.Text, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(txtDataAquisicaoEdit.Text, CultureInfo.GetCultureInfo(lang)));
                        for (int j = 0; j < resultDT.Length; j++)
                        {
                            if (resultDT[j] == -1)
                            {
                                resultFinal = -1;
                            }
                        }
                    }
                    if (resultFinal == -1)
                        MsgException("Data 'de' não pode ser anterior a data do contrato!", 1);
                    else
                    {
                        string delete = Consultas.DeleteFrom(str_conn, queryDel);
                        if (delete == "OK")
                        {
                            if (qtdAtual <= rptDeAteEdit.Items.Count)
                            {
                                for (int i = 0; i < qtdAtual; i++)
                                {
                                    TextBox dt1 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt1Edit");
                                    data1 = dt1.Text;
                                    TextBox dt2 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt2Edit");
                                    data2 = dt2.Text;
                                    TextBox vl = (TextBox)rptDeAteEdit.Items[i].FindControl("txtVlEdit");
                                    if (resultFinal != -1)//Data Anterior a Data Aquisição
                                    {
                                        result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, new DateTime(1970, 01, 01), Convert.ToDateTime(data1, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(data2, CultureInfo.GetCultureInfo(lang)), vl.Text);
                                        if (result == "OK")
                                        {
                                            cont = cont + 1;
                                        }
                                        else
                                        {
                                            MsgException("Falha ao alterar " + lblEditarDeAte.Text + ": " + result, 1);
                                            result = "FALHA";
                                        }
                                    }
                                }
                                if (result != "FALHA")
                                {
                                    string str = null;
                                    if (cont != 0 && cont > 1)
                                    {
                                        str = cont.ToString() + " Itens";
                                    }
                                    else if (cont == 1)
                                    {
                                        str = cont.ToString() + " Item";
                                    }
                                    result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                }
                            }
                            else
                            {
                                for (int i = 0; i < qtdAtual; i++)
                                {
                                    TextBox dt1 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt1Edit");
                                    data1 = dt1.Text;
                                    TextBox dt2 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt2Edit");
                                    data2 = dt2.Text;
                                    TextBox vl = (TextBox)rptDeAteEdit.Items[i].FindControl("txtVlEdit");
                                    if (data1 != null && data2 != null && valor != 0)
                                    {

                                        if (resultFinal != -1)//Data Anterior a Data Aquisição
                                        {
                                            result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, new DateTime(1970, 01, 01), Convert.ToDateTime(data1, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(data2, CultureInfo.GetCultureInfo(lang)), vl.Text);
                                            if (result == "OK")
                                            {
                                                cont = cont + 1;
                                            }
                                            else
                                            {
                                                MsgException("Falha ao alterar " + lblEditarDeAte.Text + ": " + result, 1);
                                                result = "FALHA";
                                            }
                                        }
                                    }
                                    else
                                    {
                                        result = "FALHA";
                                        MsgException("Verificar preenchimento dos campos.", 1);
                                    }
                                }
                                if (result != "FALHA")
                                {
                                    string str = null;
                                    if (cont != 0 && cont > 1)
                                    {
                                        str = cont.ToString() + " Itens";
                                    }
                                    else if (cont == 1)
                                    {
                                        str = cont.ToString() + " Item";
                                    }
                                    result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                                }
                            }
                        }
                        else
                        {
                            MsgException("Falha na exclusão: " + delete, 1);
                        }
                    }
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
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
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
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
                    BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
                    BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
                    break;
            }
            popupBasesAlterar.ShowOnPageLoad = false;
        }
        protected void btnEditarInteiro_Click(object sender, EventArgs e)
        {
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
        protected void btnEditarDeAte_Click(object sender, EventArgs e)
        {
            int valor = 0;
            for (int i = 0; i < rptDeAteEdit.Items.Count; i++)
            {
                TextBox dt1 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt1Edit");
                TextBox dt2 = (TextBox)rptDeAteEdit.Items[i].FindControl("txtDt2Edit");
                TextBox vl = (TextBox)rptDeAteEdit.Items[i].FindControl("txtVlEdit");
                if (dt1.Text == "" || dt2.Text == "" || vl.Text == "")
                {
                    valor = valor + 1;
                }
            }
            if (valor == 0)
                SwitchEditarBasesProc(4);
            else
                MsgException("Campos nulos não são permitidos", 1);
        }
        protected void btnInserirSql_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfOPIDCONT.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), dropInserirSql.SelectedValue, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
            popupBasesInsert.ShowOnPageLoad = false;
        }
        protected void DelBasesEdit(object sender, CommandEventArgs e)
        {
            string del = "delete cjclprop_din where chidcodi=" + hfCHIDCODI2.Value + " and opidcont=" + hfCodInterno.Value + " and cjidcodi=" + hfCJIDCODI2.Value + "";
            string result = Consultas.DeleteFrom(str_conn, del);
            popupBasesAlterar.ShowOnPageLoad = false;
            BasesNegociacaoEdit(hfCodInterno.Value, 1, dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value));
            BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value));
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
                    pnlGridDataEdit.Visible = true;
                    MultiView1.ActiveViewIndex = 0;
                    btnEditarData.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        btnEditarDataDel.Visible = false;
                    else if (temProp > 0)
                        btnEditarDataDel.Visible = true;
                    btnEditarData.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    btnEditarDataDel.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
                    break;
                case "6": //Tipo Flutuante
                    lblEditarFlutuante.Text = cjdsdecr;
                    txtEditarFlutuante.Text = cjtpcttx;
                    pnlEditarFlutuante.Visible = true;
                    MultiView1.ActiveViewIndex = 3;
                    btnEditarFlutuante.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button6.Visible = false;
                    else if (temProp > 0)
                        Button6.Visible = true;
                    btnEditarFlutuante.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    Button6.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
                    break;
                case "8": //Tipo Fórmula paramétrica
                    lblEditarFormula.Text = cjdsdecr;
                    pnlGridFormulaEdit.Visible = true;
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
                    dropEditarFormula.TextField = "CINMTABE";
                    dropEditarFormula.ValueField = "CIIDCODI";
                    dropEditarFormula.DataSource = DataBase.Consultas.Consulta(str_conn, sqlFormula);
                    dropEditarFormula.DataBind();
                    try
                    {
                        dropEditarFormula.Value = cjtpcttx;
                    }
                    catch
                    { }
                    MultiView1.ActiveViewIndex = 4;
                    btnEditarFormula.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button7.Visible = false;
                    else if (temProp > 0)
                        Button7.Visible = true;
                    btnEditarFormula.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    Button7.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
                    break;
                case "15": //Tipo Indice
                    lblEditarIndice.Text = cjdsdecr;
                    txtEditarIndice.Text = cjtpcttx;
                    pnlGridIndiceEdit.Visible = true;
                    MultiView1.ActiveViewIndex = 5;
                    btnEditarIndice.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button8.Visible = false;
                    else if (temProp > 0)
                        Button8.Visible = true;
                    btnEditarIndice.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    Button8.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
                    break;
                case "9": //Tipo Inteiro
                    //if (cjidcodi == "264")
                    //    txtEditarInteiro.MaskSettings.Mask = "<1..31>";
                    //else
                    //    txtEditarInteiro.MaskSettings.Mask = "<0..9999999999999>";
                    lblEditarInteiro.Text = cjdsdecr;
                    txtEditarInteiro.Text = cjtpcttx;
                    pnlGridInteiroEdit.Visible = true;
                    MultiView1.ActiveViewIndex = 2;
                    btnEditarInteiro.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button5.Visible = false;
                    else if (temProp > 0)
                        Button5.Visible = true;
                    btnEditarInteiro.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    Button5.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
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
                    btnEditarTexto.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    Button3.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
                    break;
                case "10": //Tipo Moeda
                    lblEditarMoeda.Text = cjdsdecr;
                    txtEditarMoeda.Text = cjtpcttx;
                    pnlGridMoedaEdit.Visible = true;
                    MultiView1.ActiveViewIndex = 1;
                    btnEditarMoeda.Text = temProp > 0 ? HttpContext.GetGlobalResourceObject("GlobalResource", "btn_alterar").ToString() : HttpContext.GetGlobalResourceObject("GlobalResource", "btn_inserir").ToString();
                    if (temProp == 0)
                        Button4.Visible = false;
                    else if (temProp > 0)
                        Button4.Visible = true;
                    btnEditarMoeda.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    Button4.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
                    break;
                case "4": //Tipo De Até
                    string sql = "select cjdtdtde De,cjdtdtat Ate,cjvldeat Valor,OPIDISEQ ID from cjclprop_din " +
                                "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                                  "and opidcont = " + hfCodInterno.Value + " " +
                                  "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                                  "and CJTPCTTX is null order by 1";
                    pnlGridDeAteEdit.Visible = true;
                    hfqueryRpt.Value = sql;
                    gridRptDeAte.DataSource = Consultas.Consulta(str_conn, sql);
                    gridRptDeAte.DataBind();
                    MultiView1.ActiveViewIndex = 7;
                    gridRptDeAte.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(400);
                    popupBasesAlterar.Height = Unit.Pixel(400);
                    break;
                case "44": //Tipo De Até Data
                    string sql2 = "select cjdtdtde De,cjdtdtat Ate,cjvldeat Valor,cjdtprop Data,OPIDISEQ ID from cjclprop_din " +
                                "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                                  "and opidcont = " + hfCodInterno.Value + " " +
                                  "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                                  "and CJTPCTTX is null order by 1";
                    hfqueryRpt.Value = sql2;
                    gridRptDeAteData.DataSource = Consultas.Consulta(str_conn, sql2);
                    gridRptDeAteData.DataBind();
                    MultiView1.ActiveViewIndex = 9;
                    gridRptDeAteData.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(400);
                    popupBasesAlterar.Height = Unit.Pixel(400);
                    break;
                case "12": //Tipo SQL
                    lblEditarSql.Text = cjdsdecr;
                    pnlGridSQLEdit.Visible = true;
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
                    btnEditarSql.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    Button9.Enabled = (this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "inserir" || (this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar";
                    popupBasesAlterar.Width = Unit.Pixel(200);
                    popupBasesAlterar.Height = Unit.Pixel(200);
                    break;
            }
            popupBasesAlterar.HeaderText = cjdsdecr;
            popupBasesAlterar.ShowOnPageLoad = true;
        }
        protected void Button2_Command(object sender, CommandEventArgs e)
        {
            string[] name = e.CommandName.Split('#');
            string cjtpidtp = name[0];
            string cjdsdecr = name[1];
            string combo = name[2];
            string texto = name[3];
            string[] args = e.CommandArgument.ToString().Split('#');
            string cjidcodi = args[0];
            string chidcodi = args[1];
            hfCJIDCODI.Value = cjidcodi;
            hfCHIDCODI.Value = chidcodi;
            hfCJTPIDTP.Value = cjtpidtp;
            string i = cjtpidtp;
            switch (i)
            {
                case "3": //Tipo Data

                    lblInserirData.Text = cjdsdecr;
                    txtInserirData.Text = string.Empty;
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 0;
                    break;
                case "6": //Tipo Flutuante
                    lblInserirFlutuante.Text = cjdsdecr;
                    txtInserirFlutuante.Text = string.Empty;
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 3;
                    break;
                case "8": //Tipo Fórmula paramétrica
                    lblInserirFormula.Text = cjdsdecr;
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
                                dropInserirFormula.DataTextField = dr.GetName(0);
                                dropInserirFormula.DataValueField = dr.GetName(1);
                                dr.Close();
                                dropInserirFormula.DataSource = cmd.ExecuteReader();
                                dropInserirFormula.DataBind();
                            }
                        }
                    }
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 4;
                    break;
                case "15": //Tipo Indice
                    lblInserirIndice.Text = cjdsdecr;
                    txtInserirIndice.Text = string.Empty;
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 5;
                    break;
                case "9": //Tipo Inteiro
                    lblInserirInteiro.Text = cjdsdecr;
                    txtInserirInteiro.Text = string.Empty;
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 2;
                    break;
                case "10": //Tipo Moeda
                    lblInserirMoeda.Text = cjdsdecr;
                    txtInserirMoeda.Text = string.Empty;
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 1;
                    break;
                case "4": //Tipo De Até
                    lblInserirDeAte.Text = cjdsdecr;
                    string sql = "select cjdtdtde De,cjdtdtat Ate,cjvldeat Valor,opidcont ID from cjclprop_din " +
                                "where CHIDCODI = " + hfCHIDCODI.Value + " " +
                                  "and opidcont = " + hfCodInterno.Value + " " +
                                  "and cjidcodi = " + hfCJIDCODI.Value + " " +
                                  "and CJTPCTTX is null";
                    hfqueryRpt.Value = sql;
                    gridDeAteInsert.DataSource = Consultas.Consulta(str_conn, sql);
                    gridDeAteInsert.DataBind();
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 7;
                    break;
                case "12": //Tipo SQL
                    lblInserirSql.Text = cjdsdecr;
                    using (var con = new OleDbConnection(str_conn))
                    {
                        con.Open();
                        using (var cmd = new OleDbCommand(HttpUtility.HtmlDecode(combo.Replace("FROM DUAL", "")), con))
                        {
                            OleDbDataReader dr = cmd.ExecuteReader();
                            if (dr.HasRows)
                            {
                                dr.Read();
                                dropInserirSql.DataTextField = dr.GetName(0);
                                dropInserirSql.DataValueField = dr.GetName(0);
                                dr.Close();
                            }
                            dropInserirSql.DataSource = cmd.ExecuteReader();
                            dropInserirSql.DataBind();
                        }
                    }
                    popupBasesInsert.HeaderText = cjdsdecr;
                    MultiViewInsert.ActiveViewIndex = 6;
                    break;
            }
            popupBasesInsert.ShowOnPageLoad = true;
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
        protected void rptBasesEdit_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    (e.Item.FindControl("CalendarDtEdit1") as CalendarExtender).TargetControlID = (e.Item.FindControl("txtDtEdit1") as TextBox).UniqueID;
                    (e.Item.FindControl("CalendarDtEdit2") as CalendarExtender).TargetControlID = (e.Item.FindControl("txtDtEdit2") as TextBox).UniqueID;
                    (e.Item.FindControl("MaskedVlEdit1") as MaskedEditExtender).TargetControlID = (e.Item.FindControl("txtVlEdit") as TextBox).UniqueID;
                }
                catch
                {

                }
            }
        }
        protected void CarregaContrato(int Index, bool RowIndex)
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
            sqlBasesCons.SelectParameters[0].DefaultValue = hfOPIDCONT.Value;
            sqlBasesCons.DataBind();
            gridVerbasCons.DataBind();
            DevExpress.Web.GridViewDataComboBoxColumn col = new DevExpress.Web.GridViewDataComboBoxColumn();
            for (int i = 0; i < gridVerbasCons.Columns.Count; i++)
            {
                if (gridVerbasCons.Columns[i].VisibleIndex == 2)
                {
                    col = gridVerbasCons.Columns[i] as DevExpress.Web.GridViewDataComboBoxColumn;
                    col.PropertiesComboBox.DataSource = sqlBasesCons;
                }
            }
            CultureInfo cultureInfo = CultureInfo.GetCultureInfo(lang);
            // Get the selected index and the command name
            string sqlEstrutura = "select CAIDCTRA,CADSCTRA from cacteira where TVIDESTR = " + DataBase.Consultas.Consulta(str_conn, "SELECT TVIDESTR FROM OPCONTRA WHERE OPIDCONT=" + hfOPIDCONT.Value + "", 1)[0] + " order by cadsctra";
            using (var con = new OleDbConnection(str_conn))
            {
                con.Open();
                using (var cmd = new OleDbCommand(sqlEstrutura, con))
                {
                    dropCarteiraEdit.TextField = "CADSCTRA";
                    dropCarteiraEdit.ValueField = "CAIDCTRA";
                    dropCarteiraEdit.DataSource = cmd.ExecuteReader();
                    dropCarteiraEdit.DataBind();
                }
            }
            string sqlFornecedor = "SELECT F.FOCDXCGC, concat(F.FOCDXCGC, ' - ',F.FONMAB20) FONMAB20, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8 and (TVIDESTR = " + DataBase.Consultas.Consulta(str_conn, "SELECT TVIDESTR FROM OPCONTRA WHERE OPIDCONT=" + hfOPIDCONT.Value + "", 1)[0] + " or TVIDESTR in (select TVIDESTR from VIFSFUSU where USIDUSUA='" + usuarioPersist + "') or TVIDESTR=1) order by fonmforn";
            using (var con = new OleDbConnection(str_conn))
            {
                con.Open();
                using (var cmd = new OleDbCommand(sqlFornecedor, con))
                {
                    OleDbDataAdapter da = new OleDbDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    txtAgntFinancEdit.DataSource = dt;
                    txtAgntFinancEdit.DataBind();
                    dropBenefAlter.DataSource = dt;
                    dropBenefAlter.DataBind();
                }
            }

            hfCodInterno.Value = hfOPIDCONT.Value;
            hfCHIDCODI.Value = DataBase.Consultas.Consulta(str_conn, "select chidcodi from PRPRODUT where prprodid=" + hfPRPRODID.Value, 1)[0];
            string query1 = "SELECT TV.TVDSESTR,OP.OPCDCONT,OP.OPNMCONT,PR.PRPROCOD,PR.PRPRODES,OP.OPDTASCO, OP.OPDTBACO, FR.OPTPFRDS,FO.FONMAB20,SN.TPDSSINA,RG.OPTPRGDS,TP.OPTPTPDS,OP.CAIDCTRA,tp.cmtpidcm,tp.optptpid,ca.CADSCTRA,pe.PRTPNMOP,op.OPIDCONT,op.OPCDAUXI,(select CMTPDSCM from CMTPCMCL cm where cm.CMTPIDCM=op.CMTPIDCM and cm.PAIDPAIS=1) CMTPDSCM,OP.OPVLCONT,FO.FOIDFORN,OP.OPDTENCO,OP.OPFLPARC,OP.OPFLCARE,OP.OPFLSLDI,OP.TVIDESTR,OP.FOIDFORN2,OP.OPDTINPG,OP.OPDTFMPG " +
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
                    "AND OP.OPIDCONT=" + hfCodInterno.Value;
            //"UNION " +
            //"SELECT TV.TVDSESTR,OP.OPCDCONT,OP.OPNMCONT,PR.PRPROCOD,PR.PRPRODES,OP.OPDTASCO, OP.OPDTBACO, FR.OPTPFRDS,FO.FONMAB20,SN.TPDSSINA,RG.OPTPRGDS,TP.OPTPTPDS,OP.CAIDCTRA,tp.cmtpidcm,tp.optptpid,ca.CADSCTRA,pe.PRTPNMOP,op.OPIDCONT,op.OPCDAUXI,(select CMTPDSCM from CMTPCMCL cm where cm.CMTPIDCM=op.CMTPIDCM and cm.PAIDPAIS=1) CMTPDSCM,OP.OPVLCONT,FO.FOIDFORN,OP.OPDTENCO,OP.OPFLPARC,OP.OPFLCARE,OP.OPFLSLDI,OP.TVIDESTR,OP.FOIDFORN2,OP.OPDTINPG,OP.OPDTFMPG " +
            //"FROM OPCONTRA OP " +
            //"LEFT OUTER JOIN CACTEIRA CA ON(OP.CAIDCTRA = CA.CAIDCTRA) " +
            //"LEFT OUTER JOIN OPTPFRCO FR ON(OP.OPTPFRID = FR.OPTPFRID) " +
            //"INNER JOIN PRPRODUT PR  ON(PR.CMTPIDCM = FR.CMTPIDCM AND OP.PRPRODID = PR.PRPRODID) " +
            //"INNER JOIN TPSIMNAO SN  ON(OP.TPIDSINA = SN.TPIDSINA) " +
            //"INNER JOIN OPTPTIPO TP  ON(OP.OPTPTPID = TP.OPTPTPID AND PR.CMTPIDCM = TP.CMTPIDCM) " +
            //"INNER JOIN PRTPOPER PE  ON(OP.PRTPIDOP = PE.PRTPIDOP AND PR.CMTPIDCM = PE.CMTPIDCM) " +
            //"INNER JOIN OPTPRGCO RG  ON(OP.OPTPRGID = RG.OPTPRGID AND PR.CMTPIDCM = RG.CMTPIDCM) " +
            //"INNER JOIN IEINDECO IE  ON(PR.IEIDINEC = IE.IEIDINEC) " +
            //"INNER JOIN FOFORNEC FO  ON(OP.FOIDFORN = FO.FOIDFORN) " +
            //"INNER JOIN TVESTRUT TV  ON(OP.TVIDESTR = TV.TVIDESTR) " +
            //"AND FR.PAIDPAIS = 1 " +
            //"AND SN.PAIDPAIS = 1 " +
            //"AND TP.PAIDPAIS = 1 " +
            //"AND PE.PAIDPAIS = 1 " +
            //"AND RG.PAIDPAIS = 1 " +
            //"AND PR.CMTPIDCM NOT IN(2, 4, 5) " +
            //"AND OP.OPIDCONT=" + hfCodInterno.Value + " " +
            //"AND OP.PRTPIDOP IN(5) AND OP.OPCDCONT = '" + hfOPCDCONT.Value + "' " +
            //"ORDER BY OPCDCONT";
            //string query2 = "select cj.cjidcodi,cj.CJDSDECR, case when tp.cjtpidtp = 8 then(SELECT CINMTABE FROM CICIENTI where CIIDCODI = cd.cjtpcttx) else cd.cjtpcttx end as cjtpcttx,tp.CJTPDSTP " +
            //                  "from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
            //                  "where cd.opidcont = " + hfOPIDCONT.Value + " " +
            //                    "and cj.chidcodi = cd.chidcodi " +
            //                    "and cj.cjidcodi = cd.cjidcodi " +
            //                    "and cd.cjtpcttx is not null " +
            //                    "and tp.PAIDPAIS = 1 " +
            //                    "and tp.cjtpidtp = cj.cjtpidtp " +
            //                  "order by cj.cjororde,cj.chidcodi,cj.cjidcodi, cd.cjdtdtde, cd.cjdtdtat";
            //string sql = "select cj.cjororde, cj.chidcodi, cj.cjidcodi, cj.cjdsdecr, cd.opidcont, cd.cjtpcttx " +
            //               ", cd.cjdscaor, cd.cjidvlde, cd.cjidvlat, cd.cjvlvalo " +
            //               ", cd.cjinprop, cd.cjvlprop, cd.cjdtprop, cd.cjdtdtde, cd.cjdtdtat,cd.cjvldeat " +
            //               ", tp.cjtpidtp " +
            //               ", tp.cjtpdstp " +
            //               ", isnull(cj.cjflobrg, 'S') cjflobrg " +
            //               ", case when cj.cjtpidtp = 12 then cj.cjtpcttx " +
            //                      "else null " +
            //                      "end cjSQL " +
            //          "from cjclprop cj, cjclprop_din cd, cjtptipo tp " +
            //          "where cd.opidcont = " + hfOPIDCONT.Value + " " +
            //            "and cj.chidcodi = cd.chidcodi " +
            //            "and cj.cjidcodi = cd.cjidcodi " +
            //            "and cd.cjtpcttx is not null " +
            //            "and tp.PAIDPAIS = 1 " +
            //            "and tp.cjtpidtp = cj.cjtpidtp " +
            //          "order by cj.cjororde,cj.chidcodi,cj.cjidcodi, cd.cjdtdtde, cd.cjdtdtat";

            CamposHabilitados(0);
            string[] result = Consultas.Consulta(str_conn, query1, 30);
            if (result[0] != null)
            {
                //Trecho popula drop Tipo
                string sqlTipo = "select optptpid, optptpds " +
                                  "from optptipo " +
                                  "where cmtpidcm = " + result[13].ToString() + " " +
                                    "and paidpais = 1 " +
                                  "order by optptpds";
                using (var con2 = new OleDbConnection(str_conn))
                {
                    con2.Open();
                    using (var cmd2 = new OleDbCommand(sqlTipo, con2))
                    {
                        dropTipoEdit.TextField = "optptpds";
                        dropTipoEdit.DataSource = cmd2.ExecuteReader();
                        dropTipoEdit.ValueField = "optptpid";
                        dropTipoEdit.DataBind();
                    }
                }
                string sqlImoveis = "SELECT I.REREGIAO FROM REVIOPIM R " +
                                    "INNER JOIN REIMOVEL I ON R.REIDIMOV = I.REIDIMOV " +
                                    "WHERE R.OPIDCONT = " + hfOPIDCONT.Value;
                var dtImoveis = DataBase.Consultas.Consulta(str_conn, sqlImoveis);
                txtImoveis.Text = "";
                txtImoveisEdit.Text = "";
                foreach (DataRow item in dtImoveis.Rows)
                {
                    txtImoveis.Text += item[0].ToString() + "; ";
                    txtImoveisEdit.Text += item[0].ToString() + "; ";
                }
                txtEstCorpo.Text = result[0].ToString();
                txtEstruturaCorporativaEdit.Text = result[0].ToString();
                txtNumProc.Text = result[1].ToString();
                txtNumProcessoEdit.Text = result[1].ToString();
                txtDesc.Text = result[2].ToString();
                txtDescricaoEdit.Text = result[2].ToString();
                txtEstrut.Text = result[19].ToString();
                txtEstruturaEdit.Text = result[19].ToString();
                Session["TVIDESTR_PAG"] = result[26].ToString();
                txtProd.Text = result[4].ToString();
                txtProdutoEdit.Text = result[4].ToString();
                txtDataAquisi.Text = DateTime.TryParse(result[6].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtaqui) ? Convert.ToDateTime(result[6].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtDataAquisicaoEdit.Text = DateTime.TryParse(result[6].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtaqui2) ? Convert.ToDateTime(result[6].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtDtAss.Text = DateTime.TryParse(result[5].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtass1) ? Convert.ToDateTime(result[5].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtdtAssEdit.Text = DateTime.TryParse(result[5].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtass2) ? Convert.ToDateTime(result[5].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtDtEncerra.Text = DateTime.TryParse(result[22].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtenc1) ? Convert.ToDateTime(result[22].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtdtEncerraEdit.Text = DateTime.TryParse(result[22].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtenc2) ? Convert.ToDateTime(result[22].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtIniPag.Text = DateTime.TryParse(result[28].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtini1) ? Convert.ToDateTime(result[28].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtIniPagEdit.Text = DateTime.TryParse(result[28].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtini2) ? Convert.ToDateTime(result[28].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtFimPag.Text = DateTime.TryParse(result[29].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtfim1) ? Convert.ToDateTime(result[29].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                txtFimPagEdit.Text = DateTime.TryParse(result[29].ToString(), CultureInfo.GetCultureInfo(lang), DateTimeStyles.None, out DateTime dtfim2) ? Convert.ToDateTime(result[29].ToString(), CultureInfo.GetCultureInfo(lang)).ToShortDateString() : string.Empty;
                NumberFormatInfo nFormat = new CultureInfo(lang, true).NumberFormat;
                nFormat.CurrencySymbol = "";
                txtValorAquisi.Text = string.Format(nFormat, "{0:c2}", result[20]);
                txtValorAquisicaoEdit.Text = string.Format(nFormat, "{0:c2}", result[20]);
                //txtFormatoOperacao.Text = result[7].ToString();
                //txtFormatoOperEdit.Text = result[7].ToString();
                txtAgntFinanc.Text = result[8].ToString();
                txtAgntFinancEdit.Value = result[21].ToString();
                txtBenef.Text = result[27].ToString() == string.Empty ? "" : DataBase.Consultas.Consulta(str_conn, "select FONMAB20 from FOFORNEC WHERE FOIDFORN=" + result[27].ToString(), 1)[0];
                dropBenefAlter.Value = result[27].ToString();
                txtClasseProduto.Text = result[16].ToString();
                txtClasseProdEdit.Text = result[16].ToString();
                txtCarteira.Text = result[15].ToString();
                lblcodInt.Text = result[17].ToString();
                lblcodInt2.Text = result[17].ToString();
                txtCodInterno.Text = result[17].ToString();
                txtCodInternoEdit.Text = result[17].ToString();
                txtCodAuxiliar.Text = result[18].ToString();
                txtCodAuxiliarEdit.Text = result[18].ToString();
                txtTipo.Text = result[11].ToString();
                dropTipoEdit.Value = result[14].ToString();
                dropCarteiraEdit.Value = result[12].ToString();
                dropParc.Value = result[23].ToString();
                dropParcEdit.Value = result[23].ToString();
                dropCare.Value = result[24].ToString();
                dropCareEdit.Value = result[24].ToString();
                dropSaldo.Value = result[25].ToString();
                dropSaldoEdit.Value = result[25].ToString();
                BasesNegociacaoEdit(hfCodInterno.Value, 1, 1);
                btnEdit.Enabled = perfil != "3";
                btnDelete.Enabled = perfil != "3";
                btnInsert.Enabled = false;
                btnReplicar.Enabled = perfil != "3";
                btnAditamento.Enabled = perfil != "3";
                btnHistorico.Enabled = true;
                string dir = DataBase.Consultas.Consulta(str_conn, "select FILEPATH from FILEOPOP where opidcont=" + hfOPIDCONT.Value, 1)[0];
                if (!string.IsNullOrEmpty(dir))
                {
                    string dir2 = Server.MapPath(dir);
                    if (Directory.Exists(dir2))
                    {
                        fileManager.Settings.RootFolder = @"~/" + dir;
                        fileManager.Settings.InitialFolder = @"~/" + dir;
                        fileManager.Visible = true;
                        lblFileManager.Visible = false;
                        btnCriarDir.Visible = false;
                    }
                    else
                    {
                        fileManager.Visible = false;
                        lblFileManager.Visible = true;
                        btnCriarDir.Visible = true;
                    }
                }
                else
                {
                    fileManager.Visible = false;
                    lblFileManager.Visible = true;
                    btnCriarDir.Visible = true;
                }

                fileManager.SettingsEditing.AllowCreate = false;
                fileManager.SettingsEditing.AllowDelete = false;
                fileManager.SettingsEditing.AllowMove = false;
                fileManager.SettingsEditing.AllowRename = false;
                fileManager.SettingsEditing.AllowCopy = false;
                fileManager.SettingsEditing.AllowDownload = false;
                fileManager.SettingsUpload.Enabled = false;
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
            pnlConsulta.Visible = true;
            pnlAlteracao.Visible = false;
            pnlInsert.Visible = false;
            pnlExclusao.Visible = false;
            lbltxtInt.Visible = true;
            lblcodInt.Visible = true;
            btnOK.Enabled = false;
            btnCancelar.Enabled = true;
        }
        protected void ASPxGridView1_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            int Index = Convert.ToInt32(e.Parameters);
            hfIndexGrid.Value = Index.ToString();
            if (hfIndexGrid.Value != null)
            {
                CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
            }
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            string a = null;
            string oper = (this.Master.FindControl("hfOperacao") as HiddenField).Value;
            txtOperadorInsert.Text = hfUser.Value;
            switch (oper)
            {
                case "inserir":
                    if (txtCodInternoInsert.Text != string.Empty)
                    {
                        if (Convert.ToInt32(Consultas.Consulta(str_conn, "select count(opidcont) from opcontra where opidcont=" + txtCodInternoInsert.Text, 1)[0]) > 1)
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
                        string favore = dropAgenteFinanceiroInsert2.SelectedItem == null ? "NULL" : dropAgenteFinanceiroInsert2.SelectedItem.Value.ToString();
                        sql = "INSERT INTO [dbo].[OPCONTRA] ([TVIDESTR],[OPCDCONT],[OPNMCONT],[USIDUSUA],[CMTPIDCM],[PRTPIDOP],[PRPRODID],[OPVLCONT],[OPDTASCO],[OPDSHORA],[CAIDCTRA],[OPIDCONT],[OPTPFRID],[TPIDSINA],[OPTPRGID],[OPTPTPID],[FOIDFORN],[FOIDFORN2],[OPTPGARE],[OPCDAUXI],[OPDTBACO],[OPDTENCO],[OPFLPARC],[OPFLCARE],[OPFLSLDI],[OPDTINPG],[OPDTFMPG]) " +
                                    "VALUES(" + hfEstruturaCorporativa.Value + ", '" + txtNumProcessoInsert.Text + "', '" + txtDescricaoInsert.Text + "', '" + txtOperadorInsert.Text + "', " + dropEstruturaInsert2.SelectedItem.Value + ", " + dropClasseProdutoInsert2.SelectedItem.Value + ", " + hfProduto.Value + ", " + txtValorContInsert2.Text.Replace(",", ".") + ", convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAssInsert.Text) + "',103), '00:00:00', " + dropCarteiraInsert2.SelectedItem.Value + ", " + txtCodInternoInsert.Text + ", 1, 1, 1, " + dropTipoInsert2.SelectedItem.Value + "," + favore + "," + benefic + ",null,'" + txtCodAuxInsert.Text + "',convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAquisiInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtEncerraInsert.Text) + "',103)," + dropParcInsert.SelectedItem.Value + "," + dropCareInsert.SelectedItem.Value + "," + dropSaldoInsert.SelectedItem.Value + ",convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtIniPagInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtFimPagInsert.Text) + "',103))";


                        hfSqlInsert.Value = sql;
                        string execucao = Consultas.InsertContrato(str_conn, sql);
                        if (execucao == "Sucesso")
                        {
                            string sqlInsertDir = "INSERT INTO FILEOPOP (OPIDCONT,FILENAME,FILEPATH) " +
                                                "VALUES(" + txtCodInternoInsert.Text + ", 'Dir', 'GED/" + txtCodInternoInsert.Text + "')";
                            string dir = Server.MapPath("GED");
                            if (Directory.Exists(Path.Combine(dir, txtCodInternoInsert.Text)))
                                Directory.Delete(Path.Combine(dir, txtCodInternoInsert.Text), true);
                            Directory.CreateDirectory(Path.Combine(dir, txtCodInternoInsert.Text));
                            if (Directory.Exists(Path.Combine(dir, txtCodInternoInsert.Text)))
                            {
                                execucao = Consultas.InsertContrato(str_conn, sqlInsertDir);
                                fileManager.Settings.RootFolder = @"~/GED/" + txtCodInternoInsert.Text;
                                fileManager.Settings.InitialFolder = @"~/GED/" + txtCodInternoInsert.Text;
                                fileManager.Visible = true;
                                lblFileManager.Visible = false;
                                btnCriarDir.Visible = false;
                            }
                            DateTime dtExpira = Convert.ToDateTime(txtDtEncerraInsert.Text);
                            DataBase.WorkflowAdmin wflow = new DataBase.WorkflowAdmin();
                            wflow.str_conn = str_conn;
                            wflow.OPIDCONT = txtCodInternoInsert.Text;
                            wflow.Encerramento = true;
                            wflow.Usuario = hfUser.Value;
                            wflow.DataExpira = dtExpira;
                            wflow.Renova = 0;
                            wflow.CriarWfw();
                            ASPxCheckBoxList checkBoxList = (ASPxCheckBoxList)ddeImovelLoja.FindControl("checkListImoveis") as ASPxCheckBoxList;
                            var imoveis = checkBoxList.SelectedItems;
                            for (int i = 0; i < imoveis.Count; i++)
                            {
                                string sqlInsImovel = "INSERT INTO REVIOPIM (REIDIMOV,OPIDCONT) VALUES (@REIDIMOV,@OPIDCONT)";
                                sqlInsImovel = sqlInsImovel.Replace("@OPIDCONT", hfOPIDCONT.Value);
                                sqlInsImovel = sqlInsImovel.Replace("@REIDIMOV", imoveis[i].Value.ToString());
                                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsImovel);
                            }
                            //var dif = 12 * (Convert.ToDateTime(txtDtEncerraInsert.Text, CultureInfo.GetCultureInfo(lang)).Year - Convert.ToDateTime(txtDtAquisiInsert.Text, CultureInfo.GetCultureInfo(lang)).Year) + Convert.ToDateTime(txtDtEncerraInsert.Text, CultureInfo.GetCultureInfo(lang)).Month - Convert.ToDateTime(txtDtAquisiInsert.Text, CultureInfo.GetCultureInfo(lang)).Month;
                            //string scrAuto1 = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI.Value), 266, 9, null,dif, null, null, null, null, null);
                            EnabledPanelContents(pnlGeraisInsert, false);
                            EnabledPanelContents(pnlClassificacaoInsert, false);
                            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
                            fileInsert.Enabled = true;
                            pnlBasesInsert_Father.Visible = true;
                            btnOK.Enabled = false;
                            btnCancelar.Enabled = false;
                            btnReplicar.Enabled = false;
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { $('#cardInsert .show').removeClass('show');$('[id *= panelActive2]').val('#collapseInsertBases'); });", true);
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
                    break;
                case "replicar":
                    if (Session["linkTag"] != null)
                    {
                        if (Session["linkTag"].ToString() != "clicado")
                        {
                            string benefic2 = dropBenefAlter.SelectedItem == null ? "NULL" : dropBenefAlter.SelectedItem.Value.ToString();
                            string favore2 = txtAgntFinancEdit.SelectedItem == null ? "NULL" : txtAgntFinancEdit.SelectedItem.Value.ToString();
                            string sqlR = "insert into opcontra (TVIDESTR,OPCDCONT,OPNMCONT,USIDUSUA,CMTPIDCM,PRTPIDOP,PRPRODID,OPVLCONT,OPDTASCO,OPDSHORA,CAIDCTRA,OPIDCONT,OPTPFRID,TPIDSINA,OPTPRGID,OPTPTPID,FOIDFORN,FOIDFORN2,OPTPGARE,OPCDAUXI,OPDTBACO,OPDTENCO,OPDTINPG,OPDTFMPG,OPFLPARC,OPFLCARE,OPFLSLDI) " +
        "select TVIDESTR, '" + txtNumProcessoEdit.Text + "', OPNMCONT, USIDUSUA, CMTPIDCM, PRTPIDOP, PRPRODID, " + txtValorAquisicaoEdit.Text.Replace(",", ".") + ", convert(date,'" + Convert.ToDateTime(txtdtAssEdit.Text).ToString("dd/MM/yyyy") + "',103), OPDSHORA, CAIDCTRA, " + txtCodInternoEdit.Text + ", OPTPFRID, TPIDSINA, OPTPRGID, " + dropTipoEdit.Value + ", " + favore2 + "," + benefic2 + ", OPTPGARE, OPCDAUXI,convert(date,'" + Convert.ToDateTime(txtDataAquisicaoEdit.Text).ToString("dd/MM/yyyy") + "',103),convert(date,'" + Convert.ToDateTime(txtdtEncerraEdit.Text).ToString("dd/MM/yyyy") + "',103),convert(date,'" + Convert.ToDateTime(txtIniPagEdit.Text).ToString("dd/MM/yyyy") + "',103),convert(date,'" + Convert.ToDateTime(txtFimPagEdit.Text).ToString("dd/MM/yyyy") + "',103)," + dropParcEdit.Value + "," + dropCareEdit.Value + "," + dropSaldoEdit.Value + " " +
        "from opcontra where opidcont = " + txtCodInterno.Text + "";
                            string sqlR2 = "insert into CJCLPROP_DIN(OPIDCONT,CHIDCODI,CJIDCODI,CJTPCTTX,OPIDADIT,CHTPIDEV,CJDSCAOR,CJIDVLDE,CJIDVLAT,CJVLVALO,CJDSDECR,CJINPROP,CJVLPROP,CJDTPROP,CJDTDTDE,CJDTDTAT,CJVLDEAT) " +
        "select " + txtCodInternoEdit.Text + ", CHIDCODI, CJIDCODI, CJTPCTTX, OPIDADIT, CHTPIDEV, CJDSCAOR, CJIDVLDE, CJIDVLAT, CJVLVALO, CJDSDECR, CJINPROP, CJVLPROP, CJDTPROP, CJDTDTDE, CJDTDTAT, CJVLDEAT " +
        "from CJCLPROP_DIN where opidcont = " + txtCodInterno.Text + " and cjidcodi in (select distinct CJIDCODI from VIPROEVE where CHTPIDEV=1) ";
                            string exec1 = DataBase.Consultas.InsertInto(str_conn, sqlR);
                            if (exec1 == "OK")
                            {
                                string sqlInsertDir = "INSERT INTO FILEOPOP (OPIDCONT,FILENAME,FILEPATH) " +
                                                        "VALUES(" + txtCodInterno.Text + ", 'Dir', 'GED/" + txtCodInterno.Text + "')";
                                string dir = Server.MapPath("GED");
                                if (Directory.Exists(Path.Combine(dir, txtCodInterno.Text)))
                                    Directory.Delete(Path.Combine(dir, txtCodInterno.Text), true);
                                Directory.CreateDirectory(Path.Combine(dir, txtCodInterno.Text));
                                if (Directory.Exists(Path.Combine(dir, txtCodInterno.Text)))
                                {
                                    exec1 = Consultas.InsertContrato(str_conn, sqlInsertDir);
                                    fileManager.Settings.RootFolder = @"~/GED/" + txtCodInterno.Text;
                                    fileManager.Settings.InitialFolder = @"~/GED/" + txtCodInterno.Text;
                                    fileManager.Visible = true;
                                    lblFileManager.Visible = false;
                                    btnCriarDir.Visible = false;
                                }
                                DateTime dtExpira = Convert.ToDateTime(txtdtEncerraEdit.Text);
                                DataBase.WorkflowAdmin wflow = new DataBase.WorkflowAdmin();
                                wflow.str_conn = str_conn;
                                wflow.OPIDCONT = txtCodInternoInsert.Text;
                                wflow.Encerramento = true;
                                wflow.Usuario = hfUser.Value;
                                wflow.DataExpira = dtExpira;
                                wflow.Renova = 0;
                                wflow.CriarWfw();
                                string exec22 = DataBase.Consultas.InsertInto(str_conn, sqlR2);
                                if (exec22 == "OK")
                                {
                                    DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
                                    grid.DataBind();
                                    int Index = 0;
                                    for (int i = 0; i < grid.VisibleRowCount; i++)
                                    {
                                        if (grid.GetRowValues(i, "OPIDCONT").ToString() == txtCodInternoEdit.Text)
                                        {
                                            Index = i;
                                            grid.FocusedRowIndex = Index;
                                            break;
                                        }
                                    }
                                    ddePesqContrato.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
                                    hfIndexGrid.Value = Index.ToString();
                                    if (hfIndexGrid.Value != null)
                                    {
                                        CarregaContrato(Convert.ToInt32(txtCodInternoEdit.Text), false);
                                        btnOK.Enabled = false;
                                    }
                                }
                                else
                                {
                                    MsgException(exec22, 1);
                                }
                            }
                            else
                            {
                                MsgException(exec1, 1);
                            }
                        }
                    }
                    break;
                case "alterar":
                    string sqlUpdate = "update opcontra set OPNMCONT='" + txtDescricaoEdit.Text + "', CAIDCTRA=" + dropCarteiraEdit.Value + ", OPTPTPID=" + dropTipoEdit.Value + ",OPCDAUXI='" + txtCodAuxiliarEdit.Text + "',OPVLCONT=" + txtValorAquisicaoEdit.Text.Replace(",", ".") + ",OPDTENCO=convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", Convert.ToDateTime(txtdtEncerraEdit.Text, CultureInfo.GetCultureInfo(lang)).ToShortDateString()) + "',103),OPDTADIT=convert(datetime,'" + DateTime.Now.ToShortDateString() + "',103),OPJUADIT='Alteração sem impacto contratual.'  WHERE OPIDCONT=" + hfCodInterno.Value + "";
                    string exec2 = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if (exec2 == "OK")
                    {
                        dropCarteiraEdit.Attributes.Add("disabled", "disabled");
                        dropTipoEdit.Attributes.Add("disabled", "disabled");
                        if (txtDescricaoEdit.Text != txtDesc.Text || txtCarteira.Text != dropCarteiraEdit.SelectedItem.Text || txtTipo.Text != dropTipoEdit.SelectedItem.Text || txtCodAuxiliar.Text != txtCodAuxiliarEdit.Text || txtValorAquisi.Text != txtValorAquisicaoEdit.Text)
                        {
                            if (txtValorAquisi.Text != txtValorAquisicaoEdit.Text)
                            {
                                MsgException("Valor alterado, execução de limpeza do Fluxo de Caixa", 2);
                            }
                            if (txtDtEncerra.Text != txtdtEncerraEdit.Text)
                            {
                                MsgException("Valor alterado, execução de limpeza do Fluxo de Caixa", 2);
                            }
                            //string sqlLog = "insert into OPCONADI (OPIDCONT,OPCDCONT,OPNMCONT,OPDTASCO,OPDTBACO,OPDTENCO,CAIDCTRA,OPDTINCO,USIDUSUA,TVIDESTR,PRPRODID,OPCDAUXA,OPVLCONT,FOIDFORN,OPCDAUXI,OPIDAACC,OPTPTPID,FOIDBOLS,OPQTTOLE,TPIDTIPM,TPIDMERC,TPIDCDPR,TPIDTPPR,TPIDPROR,OPVLPRUN,TPIDCOVE,TPIDORVE,COIDCONV,FANUFATA,OPCDNFAG,OPIDBROK,OPNMADIT,OPDTADIT,OPVLCONT2,OPIDCONA) " +
                            //"select OPIDCONT, OPCDCONT, OPNMCONT, OPDTASCO, OPDTBACO, OPDTENCO, (select CAIDCTRA from CACTEIRA where CADSCTRA='" + txtCarteira.Text + "'), OPDTINCO,'" + usuarioPersist + "',TVIDESTR,PRPRODID,'" + txtCodAuxiliar.Text + "'," + txtValorAquisi.Text.Replace(",", ".") + ",FOIDFORN,OPCDAUXI,OPIDAACC,(select max(OPTPTPID) from OPTPTIPO where OPTPTPDS='" + txtTipo.Text + "'),FOIDBOLS,OPQTTOLE,TPIDTIPM,TPIDMERC,TPIDCDPR,TPIDTPPR,TPIDPROR,OPVLPRUN,TPIDCOVE,TPIDORVE,COIDCONV,FANUFATA,OPCDNFAG,OPIDBROK,'ADT',convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", DateTime.Now) + "',103)," + txtValorAquisicaoEdit.Text.Replace(",", ".") + "," + DataBase.Consultas.CarregaCodInterno("28", 0, str_conn) + " from OPCONTRA where opidcont = " + hfCodInterno.Value + "";
                            //string exec = DataBase.Consultas.InsertInto(str_conn, sqlLog);
                        }
                        MsgException(HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString(), 2);
                        a = "1";
                        DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
                        grid.DataBind();
                        int Index = 0;
                        for (int i = 0; i < grid.VisibleRowCount; i++)
                        {
                            if (grid.GetRowValues(i, "OPIDCONT").ToString() == txtCodInternoEdit.Text)
                            {
                                Index = i;
                                grid.FocusedRowIndex = Index;
                                break;
                            }
                        }
                        ddePesqContrato.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
                        hfIndexGrid.Value = Index.ToString();
                        if (hfIndexGrid.Value != null)
                        {
                            CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                        }
                    }
                    else
                    {
                        MsgException(HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_exception").ToString() + exec2, 1);
                    }
                    break;
                case "aditamento":

                    if (dropEventoAditamento.Value.ToString() == "1")
                    {
                        if (Convert.ToDecimal(txtValorAquisi.Text) != Convert.ToDecimal(txtValorAquisicaoEdit.Text) || txtDtEncerra.Text != txtdtEncerraEdit.Text || txtFimPag.Text != txtFimPagEdit.Text || dropSaldoEdit.Value != dropSaldo.Value || dropCareEdit.Value != dropCare.Value || dropParcEdit.Value != dropParc.Value)
                        {
                            string sqlUpdate2 = "update opcontra set OPVLCONT=" + txtValorAquisicaoEdit.Text.Replace(",", ".") + ", OPDTENCO=convert(datetime,'" + Convert.ToDateTime(txtdtEncerraEdit.Text).ToString("dd/MM/yyyy") + "',103), OPDTFMPG=convert(datetime,'" + Convert.ToDateTime(txtFimPagEdit.Text).ToString("dd/MM/yyyy") + "',103),OPDTADIT=convert(datetime,'" + Convert.ToDateTime(txtDtAdit.Text).ToString("dd/MM/yyyy") + "',103),OPJUADIT='" + txtJustifica.Text + "' " +
                                " , OPFLSLDI=" + dropSaldoEdit.Value + ", OPFLCARE=" + dropCareEdit.Value + ", OPFLPARC=" + dropParcEdit.Value + ", OPDTBACO = convert(datetime,'" + Convert.ToDateTime(txtDataAquisicaoEdit.Text).ToString("dd/MM/yyyy") + "',103) " +
                                "  WHERE OPIDCONT=" + hfCodInterno.Value + "";
                            OleDbConnection conn2 = new OleDbConnection(str_conn);
                            OleDbCommand cmd2 = new OleDbCommand(sqlUpdate2, conn2);
                            try
                            {
                                conn2.Open();
                                cmd2.ExecuteNonQuery();

                                dropCarteiraEdit.Attributes.Add("disabled", "disabled");
                                dropTipoEdit.Attributes.Add("disabled", "disabled");

                                string delAlert = "SELECT ALIDALSQ FROM DNALERTA " +
      "where opidcont = " + hfCodInterno.Value + " and ALDTEXPI = CONVERT(DATE, '" + Convert.ToDateTime(txtDtEncerra.Text).ToString("dd/MM/yyyy") + "', 103) " +
      "AND DNIDDENU IN(SELECT DNIDDENU FROM DENUNCIA where DNVIENCE = 1)";
                                DateTime dtExpira = Convert.ToDateTime(txtdtEncerraEdit.Text);
                                DataBase.WorkflowAdmin wflow = new DataBase.WorkflowAdmin();
                                wflow.str_conn = str_conn;
                                wflow.ID = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, delAlert, 1)[0]);
                                wflow.ExcluirWfw();
                                wflow.OPIDCONT = hfCodInterno.Value;
                                wflow.Encerramento = true;
                                wflow.DataExpira = dtExpira;
                                wflow.Usuario = hfUser.Value;
                                wflow.Renova = 0;
                                wflow.CriarWfw();
                                //string sqlLog = "insert into OPCONADI (OPIDCONT,OPCDCONT,OPNMCONT,OPDTASCO,OPDTBACO,OPDTENCO,CAIDCTRA,OPDTINCO,USIDUSUA,TVIDESTR,PRPRODID,OPCDAUXA,OPVLCONT,FOIDFORN,OPCDAUXI,OPIDAACC,OPTPTPID,FOIDBOLS,OPQTTOLE,TPIDTIPM,TPIDMERC,TPIDCDPR,TPIDTPPR,TPIDPROR,OPVLPRUN,TPIDCOVE,TPIDORVE,COIDCONV,FANUFATA,OPCDNFAG,OPIDBROK,OPNMADIT,OPDTADIT,OPVLCONT2,OPIDCONA) " +
                                //"select OPIDCONT, OPCDCONT, OPNMCONT, OPDTASCO, OPDTBACO, OPDTENCO, (select CAIDCTRA from CACTEIRA where CADSCTRA='" + txtCarteira.Text + "'), OPDTINCO,'" + usuarioPersist + "',TVIDESTR,PRPRODID,'" + txtCodAuxiliar.Text + "'," + txtValorAquisi.Text.Replace(",", ".") + ",FOIDFORN,OPCDAUXI,OPIDAACC,(select max(OPTPTPID) from OPTPTIPO where OPTPTPDS='" + txtTipo.Text + "'),FOIDBOLS,OPQTTOLE,TPIDTIPM,TPIDMERC,TPIDCDPR,TPIDTPPR,TPIDPROR,OPVLPRUN,TPIDCOVE,TPIDORVE,COIDCONV,FANUFATA,OPCDNFAG,OPIDBROK,'ADT',convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", DateTime.Now) + "',103)," + txtValorAquisicaoEdit.Text.Replace(",", ".") + "," + DataBase.Consultas.CarregaCodInterno("28", 0, str_conn) + " from OPCONTRA where opidcont = " + hfCodInterno.Value + "";
                                //string exec = DataBase.Consultas.InsertInto(str_conn, sqlLog);

                                MsgException(HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString(), 2);
                                a = "1";
                                DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
                                grid.DataBind();
                                int Index = 0;
                                for (int i = 0; i < grid.VisibleRowCount; i++)
                                {
                                    if (grid.GetRowValues(i, "OPIDCONT").ToString() == txtCodInternoEdit.Text)
                                    {
                                        Index = i;
                                        grid.FocusedRowIndex = Index;
                                        break;
                                    }
                                }
                                ddePesqContrato.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
                                hfIndexGrid.Value = Index.ToString();

                            }
                            catch (Exception ex)
                            {
                                MsgException(HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_exception").ToString() + ex.Message.ToString(), 1);
                            }
                            finally
                            {
                                conn2.Close();
                            }
                        }
                        if (hfIndexGrid.Value != null)
                        {
                            CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                            btnAditamento.Border.BorderWidth = Unit.Pixel(1);
                            btnAditamento.Border.BorderStyle = BorderStyle.Solid;
                            btnAditamento.Border.BorderColor = System.Drawing.Color.FromArgb(204, 204, 204);
                        }
                    }
                    else
                    {
                        DataBase.Consultas.Acao = "Processamento";
                        DataBase.Consultas.Resumo = "Aditamento";
                        DataBase.Consultas.Alteracao = "Processamento Aditamento Contrato #ID: " + hfOPIDCONT.Value;
                        CultureInfo culture = new CultureInfo(lang); ;
                        string[] param_dados = new string[4];
                        param_dados[0] = "@p_opidcont#" + hfOPIDCONT.Value;
                        param_dados[1] = "@p_chidcodi#" + hfCHIDCODI.Value;
                        param_dados[2] = "@p_chtpidev#" + dropEventoAditamento.Value.ToString();
                        param_dados[3] = "@p_idioma#" + culture.ToString();
                        string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Amendments", param_dados, "o_mensagem");
                        if (exec == "OK")
                        {
                            if (dropEventoAditamento.Value.ToString() == "20")
                            {
                                bool guardaChuva = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select OPTPTPID from opcontra where OPIDCONT IN (select OPIDAACC from opcontra where OPIDCONT=" + hfOPIDCONT.Value + ")", 1)[0]) == 91;
                                if (guardaChuva)
                                {
                                    decimal valorContratoPai = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, "select OPVLCONT from opcontra where OPIDCONT IN (select OPIDAACC from opcontra where OPIDCONT=" + hfOPIDCONT.Value + ")", 1)[0]);
                                    decimal valorContratoFilho = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, "select OPVLCONT from opcontra where OPIDCONT=" + hfOPIDCONT.Value + "", 1)[0]);
                                    decimal resultado = valorContratoPai - valorContratoFilho;
                                    string sqlUpdValor = "update opcontra set OPVLCONT=" + resultado + " where OPIDCONT IN (select OPIDAACC from opcontra where OPIDCONT=" + hfOPIDCONT.Value + ") and OPTPTPID=91";
                                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdValor);
                                }
                            }
                            MsgException(hfMsgSuccess.Value, 2);
                            btnAditamento.Border.BorderWidth = Unit.Pixel(0);
                            CarregaContrato(Convert.ToInt32(hfOPIDCONT.Value), false);
                        }
                        else
                        {
                            MsgException(hfMsgException.Value + exec, 1);
                        }
                    }
                    break;
                case "excluir":
                    string result = SProcExcluirContrato(Convert.ToInt32(hfOPIDCONT.Value));
                    if (result == "OK")
                    {
                        MsgException("Contrato excluído com sucesso!", 0);
                        a = "1";
                    }
                    else
                    {
                        MsgException(result, 1);
                    }
                    break;
            }
            btnOK.Enabled = false;
            clickOK = 1;
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            if ((this.Master.FindControl("hfOperacao") as HiddenField).Value == "alterar")
            {
                if (hfIndexGrid.Value != null)
                {
                    CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                }
            }
            else if ((this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar")
            {
                if (hfIndexGrid.Value != null)
                {
                    CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                }
            }
            else if ((this.Master.FindControl("hfOperacao") as HiddenField).Value == "aditamento")
            {
                if (hfIndexGrid.Value != null)
                {
                    CarregaContrato(Convert.ToInt32(hfIndexGrid.Value), true);
                    btnAditamento.Border.BorderWidth = Unit.Pixel(1);
                    btnAditamento.Border.BorderStyle = BorderStyle.Solid;
                    btnAditamento.Border.BorderColor = System.Drawing.Color.FromArgb(204, 204, 204);
                }
            }
            else
                Response.Redirect("Aquisicao");
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
                string delete = Consultas.DeleteFrom(str_conn, del);
                oper = 2;
            }
            string query = "select count(opidcont) from cjclprop_din " +
                    "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                      "and opidcont = " + hfCodInterno.Value + " " +
                      "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                      "and CJTPCTTX is null";
            int cont = Convert.ToInt32(Consultas.Consulta(str_conn, query, 1)[0]);
            string str = string.Empty;
            if (cont == 0)
            {
                if (oper == 1)
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), "1 Item", 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                else if (oper == 2)
                {
                    string del = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is not null";
                    string delete = Consultas.DeleteFrom(str_conn, del);
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
                int cont2 = Convert.ToInt32(Consultas.Consulta(str_conn, query, 1)[0]);
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
                int cont3 = Convert.ToInt32(Consultas.Consulta(str_conn, query, 1)[0]);
                if (oper == 1 && cont3 == 0)
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            }
            string upt = "update cjclprop_din set cjtpcttx='" + str + "' where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is not null";
            Consultas.UpdateFrom(str_conn, upt);
            gridRptDeAte.DataSource = Consultas.Consulta(str_conn, hfqueryRpt.Value);
            gridRptDeAte.DataBind();
            BasesNegociacaoEdit(hfCodInterno.Value, 1, dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value));
            BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value));
        }
        protected void treeEstrutura_FocusedNodeChanged(object sender, EventArgs e)
        {
            string key = treeEstrutura.FocusedNode.Key;
            string name = treeEstrutura.FocusedNode.ToString();
            txtEstruturaCorporativaInsert.Text = key;
            hfEstruturaCorporativa.Value = key;
            hfOPIDCONT.Value = txtCodInternoInsert.Text;
            pnlEstruturaCorpInsert.Visible = false;
        }
        protected void treeEstrutura_SelectionChanged(object sender, EventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;

            if (treeList.SelectionCount == 1)  // One node is selected within the control  
                Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;

            if (treeList.SelectionCount > 1)
            { // Applies selection to the last selected node, if two nodes are selected  
                TreeListNode prevSelectedNode = treeList.FindNodeByKeyValue(Session["PrevSelectedNodeKey"].ToString());
                prevSelectedNode.Selected = false;
                Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;
            }
            Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;
            txtEstruturaCorporativaInsert.Text = Consultas.Consulta(str_conn, "select TVDSESTR from tvestrut where tvidestr='" + Session["PrevSelectedNodeKey"].ToString() + "'", 1)[0];
            hfEstruturaCorporativa.Value = Session["PrevSelectedNodeKey"].ToString();
            hfOPIDCONT.Value = txtCodInternoInsert.Text;
            pnlEstruturaCorpInsert.Visible = false;
        }
        protected void ASPxButton1_Click1(object sender, EventArgs e)
        {
            txtEstruturaCorporativaInsert.Text = Consultas.Consulta(str_conn, "select TVDSESTR from tvestrut where tvidestr='" + Session["PrevSelectedNodeKey"].ToString() + "'", 1)[0];
            hfEstruturaCorporativa.Value = Session["PrevSelectedNodeKey"].ToString();
            hfOPIDCONT.Value = txtCodInternoInsert.Text;
            pnlEstruturaCorpInsert.Visible = false;

        }
        protected void gridDeAteInsert_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            CultureInfo br = new CultureInfo("pt-BR");
            e.Handled = true;
            foreach (var itens in e.UpdateValues)
            {
                string De = itens.NewValues["De"].ToString();
                string Ate = itens.NewValues["Ate"].ToString();
                string Valor = itens.NewValues["Valor"].ToString();
                string del1 = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI.Value + " and CJTPCTTX is null and cjdtdtde=convert(datetime,'" + itens.OldValues["De"].ToString() + "',103) and cjdtdtat=convert(datetime,'" + itens.OldValues["Ate"].ToString() + "',103) and CJVLDEAT=" + itens.OldValues["Valor"].ToString().Replace(",", ".") + "";
                string delete1 = Consultas.DeleteFrom(str_conn, del1);
                string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, 0, null, new DateTime(1970, 01, 01), Convert.ToDateTime(De, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(Ate, CultureInfo.GetCultureInfo(lang)), Valor.Replace(",", "."));
            }
            foreach (var itens in e.InsertValues)
            {
                string De = itens.NewValues["De"].ToString();
                string Ate = itens.NewValues["Ate"].ToString();
                string Valor = itens.NewValues["Valor"].ToString().Replace(".", "").Replace(",", ".");
                string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), null, 0, null, new DateTime(1970, 01, 01), Convert.ToDateTime(De, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(Ate, CultureInfo.GetCultureInfo(lang)), Valor.Replace(",", "."));
            }
            foreach (var itens in e.DeleteValues)
            {
                string De = itens.Values["De"].ToString();
                string Ate = itens.Values["Ate"].ToString();
                string Valor = itens.Values["Valor"].ToString();
                string del = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI.Value + " and CJTPCTTX is null and cjdtdtde=convert(datetime,'" + De + "',103) and cjdtdtat=convert(datetime,'" + Ate + "',103)  and CJVLDEAT=" + Valor.Replace(",", ".") + "";
                string delete = Consultas.DeleteFrom(str_conn, del);
            }
            string query = "select count(opidcont) from cjclprop_din " +
                    "where CHIDCODI = " + hfCHIDCODI.Value + " " +
                      "and opidcont = " + hfCodInterno.Value + " " +
                      "and cjidcodi = " + hfCJIDCODI.Value + " " +
                      "and CJTPCTTX is null";
            int cont = Convert.ToInt32(Consultas.Consulta(str_conn, query, 1)[0]);
            string str = string.Empty;
            if (cont > 1)
            {
                str = cont.ToString() + " Itens";
            }
            else
            {
                str = cont.ToString() + " Item";
            }
            string query2 = "select count(opidcont) from cjclprop_din " +
                    "where CHIDCODI = " + hfCHIDCODI.Value + " " +
                      "and opidcont = " + hfCodInterno.Value + " " +
                      "and cjidcodi = " + hfCJIDCODI.Value + " " +
                      "and CJTPCTTX is not null";
            if (Convert.ToInt32(Consultas.Consulta(str_conn, query2, 1)[0]) == 0)
                InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI.Value), Convert.ToInt32(hfCJIDCODI.Value), Convert.ToInt32(hfCJTPIDTP.Value), str, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            else
            {
                string upt = "update cjclprop_din set cjtpcttx='" + str + "' where CHIDCODI = " + hfCHIDCODI.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI.Value + " and CJTPCTTX is not null";
                Consultas.UpdateFrom(str_conn, upt);
            }
            gridDeAteInsert.DataSource = Consultas.Consulta(str_conn, hfqueryRpt.Value);
            gridDeAteInsert.DataBind();
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
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
        protected void rptBasesEdit_PreRender(object sender, EventArgs e)
        {
            for (int i = 0; i < rptBasesEdit.Items.Count; i++)
            {
                if (((i + 1) % 4) == 0 && i > 0)
                {
                    Literal ltr = rptBasesEdit.Items[i].FindControl("ltrlRepeaterBasesEdit") as Literal;
                    ltr.Text = "</div><div class=\"row\">";
                }
            }
        }
        protected void TreeList_CustomJSProperties(object sender, TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void dropClasseProdutoInsert2_Callback(object sender, CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            sqlClasseProdutosInsert.SelectParameters[0].DefaultValue = e.Parameter;
            dropClasseProdutoInsert2.DataBind();

        }
        protected void dropProdutoInsert2_Callback(object sender, CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;

            sqlProdutoInsert.SelectParameters[0].DefaultValue = e.Parameter.Split('#')[0];
            sqlProdutoInsert.SelectParameters[1].DefaultValue = e.Parameter.Split('#')[1];
            sqlProdutoInsert.SelectParameters[3].DefaultValue = e.Parameter.Split('#')[2];
            dropProdutoInsert2.DataBind();
            dropAgenteFinanceiroInsert2.DataBind();
            dropBenefIns.DataBind();
        }
        protected void dropFormatoOperacaoInsert2_Callback(object sender, CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            //sqlFormatoInsert.SelectParameters[0].DefaultValue = e.Parameter;
            //dropFormatoOperacaoInsert2.DataBind();
        }
        protected void dropTipoInsert2_Callback(object sender, CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            sqlTipoInsert.SelectParameters[0].DefaultValue = e.Parameter;
            dropTipoInsert2.DataBind();

            string oper = (this.Master.FindControl("hfOperacao") as HiddenField).Value;
            if (oper == "requisita")
            {
                dropTipoInsert2.Value = "20";
            }
            else
            {
                dropTipoInsert2.SelectedIndex = 0;
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
        protected void btnReplicar_Click(object sender, EventArgs e)
        {
            hfReplicar.Value = "1";
            panelActive1.Value = null;
            panelActive2.Value = null;
            txtEstruturaCorporativaEdit.Enabled = false;
            txtEstruturaEdit.Enabled = false;
            txtProdutoEdit.Enabled = false;
            //txtFormatoOperEdit.Enabled = false;
            txtAgntFinancEdit.Enabled = true;
            dropBenefAlter.Enabled = true;
            txtAgntFinancEdit.Value = string.Empty;
            dropBenefAlter.Value = string.Empty;
            txtCodInternoEdit.Enabled = false;
            txtNumProcessoEdit.Enabled = true;
            txtClasseProdEdit.Enabled = false;
            txtDataAquisicaoEdit.Enabled = true;
            txtDataAquisicaoEdit.Text = string.Empty;
            txtdtAssEdit.Enabled = true;
            txtdtAssEdit.Text = string.Empty;
            txtdtEncerraEdit.Enabled = true;
            txtdtEncerraEdit.Text = string.Empty;
            txtValorAquisicaoEdit.Text = string.Empty;
            dropTipoEdit.Enabled = true;
            txtValorAquisicaoEdit.Enabled = true;
            txtDescricaoEdit.Enabled = false;
            txtCodAuxiliarEdit.Enabled = false;
            dropCarteiraEdit.Enabled = false;
            dropParcEdit.Enabled = true;
            dropParcEdit.Value = string.Empty;
            dropCareEdit.Enabled = true;
            dropCareEdit.Value = string.Empty;
            dropSaldoEdit.Enabled = true;
            dropSaldoEdit.Value = string.Empty;
            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "replicar";
            BasesNegociacaoEdit(hfCodInterno.Value, 1, 1);
            rptBasesEdit.DataSource = null;
            rptBasesEdit.DataBind();
            pnlConsulta.Visible = false;
            pnlAlteracao.Visible = true;
            pnlInsert.Visible = false;
            pnlExclusao.Visible = false;
            btnEdit.Enabled = false;
            btnDelete.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            var opidcont = CarregaCodInterno("2", 1);
            hfCodInterno.Value = opidcont;
            gridVerbasAlt.DataBind();
            lblcodInt2.Text = opidcont;
            txtCodInternoEdit.Text = opidcont;
            Session["ID"] = opidcont;
            filesAlterar.Enabled = true;
            RequiredFieldValidator22.Enabled = true;
            RequiredFieldValidator21.Enabled = true;
        }
        protected void fileInsert_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            string dir = System.Configuration.ConfigurationManager.AppSettings["PathContratos"];
            string ID = Session["ID"].ToString();
            string resultExtension = Path.GetExtension(e.UploadedFile.FileName);
            string resultFileName = Path.ChangeExtension(Path.GetRandomFileName(), resultExtension);
            string resultFileUrl = dir + resultFileName;
            string resultFilePath = MapPath(resultFileUrl);
            e.UploadedFile.SaveAs(resultFilePath);
            string name = e.UploadedFile.FileName;
            string url = ResolveClientUrl(resultFileUrl);
            string exec = DataBase.Consultas.InsertInto(str_conn, "insert into fileopop (opidcont,filename,filepath) values (" + ID + ",'" + name + "','" + url + "')");

        }
        protected void filesAlterar_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            string dir = System.Configuration.ConfigurationManager.AppSettings["PathContratos"];
            string ID = Session["ID"].ToString();
            string resultExtension = Path.GetExtension(e.UploadedFile.FileName);
            string resultFileName = Path.ChangeExtension(Path.GetRandomFileName(), resultExtension);
            string resultFileUrl = dir + resultFileName;
            string resultFilePath = MapPath(resultFileUrl);
            e.UploadedFile.SaveAs(resultFilePath);
            string name = e.UploadedFile.FileName;
            string url = ResolveClientUrl(resultFileUrl);
            string exec = DataBase.Consultas.InsertInto(str_conn, "insert into fileopop (opidcont,filename,filepath) values (" + ID + ",'" + name + "','" + url + "')");
        }
        protected void Button10_Click(object sender, EventArgs e)
        {
            int chtpidev = dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value);
            string oper = (this.Master.FindControl("hfOperacao") as HiddenField).Value;
            if(oper=="inserir")
            {
                BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, chtpidev);
            }
            else
            {
                BasesNegociacaoEdit(hfCodInterno.Value, 1, chtpidev);
            }
            
            popupBasesAlterar.ShowOnPageLoad = false;
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
        protected void rptBases_PreRender(object sender, EventArgs e)
        {
            for (int i = 0; i < rptBases.Items.Count; i++)
            {
                if (((i + 1) % 4) == 0 && i > 0)
                {
                    Literal ltr = rptBases.Items[i].FindControl("ltrlRepeaterBasesEdit") as Literal;
                    ltr.Text = "</div><div class=\"row\">";
                }
            }
        }
        protected void rptBases_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {

        }
        protected void myLinkTagBtn_Click(object sender, EventArgs e)
        {
            if (txtDescricaoInsert.Enabled)
            {
                btnOK.Enabled = false;
                string oper = (this.Master.FindControl("hfOperacao") as HiddenField).Value;
                txtOperadorInsert.Text = hfUser.Value;
                if (txtCodInternoInsert.Text != string.Empty && Convert.ToInt32(Consultas.Consulta(str_conn, "select count(opidcont) from opcontra where opidcont=" + txtCodInternoInsert.Text, 1)[0]) > 1)
                {
                    MsgException("Contract already exists!", 1);
                    Response.Redirect("Aquisicao");
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
                    string favore = dropAgenteFinanceiroInsert2.SelectedItem == null ? "NULL" : dropAgenteFinanceiroInsert2.SelectedItem.Value.ToString();
                    sql = "INSERT INTO [dbo].[OPCONTRA] ([TVIDESTR],[OPCDCONT],[OPNMCONT],[USIDUSUA],[CMTPIDCM],[PRTPIDOP],[PRPRODID],[OPVLCONT],[OPDTASCO],[OPDSHORA],[CAIDCTRA],[OPIDCONT],[OPTPFRID],[TPIDSINA],[OPTPRGID],[OPTPTPID],[FOIDFORN],[FOIDFORN2],[OPTPGARE],[OPCDAUXI],[OPDTBACO],[OPDTENCO],[OPFLPARC],[OPFLCARE],[OPFLSLDI],[OPDTINPG],[OPDTFMPG]) " +
                                    "VALUES(" + hfEstruturaCorporativa.Value + ", '" + txtNumProcessoInsert.Text + "', '" + txtDescricaoInsert.Text + "', '" + txtOperadorInsert.Text + "', " + dropEstruturaInsert2.SelectedItem.Value + ", " + dropClasseProdutoInsert2.SelectedItem.Value + ", " + hfProduto.Value + ", " + txtValorContInsert2.Text.Replace(",", ".") + ", convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAssInsert.Text) + "',103), '00:00:00', " + dropCarteiraInsert2.SelectedItem.Value + ", " + txtCodInternoInsert.Text + ", 1, 1, 1, " + dropTipoInsert2.SelectedItem.Value + "," + favore + "," + benefic + ",null,'" + txtCodAuxInsert.Text + "',convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtAquisiInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtDtEncerraInsert.Text) + "',103)," + dropParcInsert.SelectedItem.Value + "," + dropCareInsert.SelectedItem.Value + "," + dropSaldoInsert.SelectedItem.Value + ",convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtIniPagInsert.Text) + "',103),convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", txtFimPagInsert.Text) + "',103))";


                    hfSqlInsert.Value = sql;
                    string execucao = Consultas.InsertContrato(str_conn, sql);
                    if (execucao == "Sucesso")
                    {
                        ASPxCheckBoxList checkBoxList = (ASPxCheckBoxList)ddeImovelLoja.FindControl("checkListImoveis") as ASPxCheckBoxList;
                        var imoveis = checkBoxList.SelectedItems;
                        for (int i = 0; i < imoveis.Count; i++)
                        {
                            string sqlInsImovel = "INSERT INTO REVIOPIM (REIDIMOV,OPIDCONT) VALUES (@REIDIMOV,@OPIDCONT)";
                            sqlInsImovel = sqlInsImovel.Replace("@OPIDCONT", hfOPIDCONT.Value);
                            sqlInsImovel = sqlInsImovel.Replace("@REIDIMOV", imoveis[i].Value.ToString());
                            string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsImovel);
                        }
                        //var dif = 12 * (Convert.ToDateTime(txtDtEncerraInsert.Text, CultureInfo.GetCultureInfo(lang)).Year - Convert.ToDateTime(txtDtAquisiInsert.Text, CultureInfo.GetCultureInfo(lang)).Year) + Convert.ToDateTime(txtDtEncerraInsert.Text, CultureInfo.GetCultureInfo(lang)).Month - Convert.ToDateTime(txtDtAquisiInsert.Text, CultureInfo.GetCultureInfo(lang)).Month;
                        //string scrAuto1 = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI.Value), 266, 9, null, dif, 0, null, null, null, null);
                        EnabledPanelContents(pnlGeraisInsert, false);
                        EnabledPanelContents(pnlClassificacaoInsert, false);
                        ddeEstruturaInsert.Enabled = false;
                        BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
                        fileInsert.Enabled = true;
                        pnlBasesInsert_Father.Visible = true;
                        btnOK.Enabled = false;
                        hfInsertOK.Value = "1";
                        Session["linkTag"] = "clicado";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { $('#cardInsert .show').removeClass('show');$('[id *= panelActive2]').val('collapseInsertBases'); });", true);
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
        protected void gridFilesAlterar_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            string exec;
            string dir = System.Configuration.ConfigurationManager.AppSettings["PathContratos"];
            var itens = e.DeleteValues;
            for (int i = 0; i < itens.Count; i++)
            {
                string file = MapPath(itens[i].Values["FILEPATH"].ToString());
                if (File.Exists(file))
                {
                    File.Delete(file);
                    if (!File.Exists(file))
                    {
                        exec = DataBase.Consultas.DeleteFrom(str_conn, "DELETE FILEOPOP WHERE FILEIDFI=" + itens[i].Keys["FILEIDFI"]);
                    }
                }
                else
                    exec = DataBase.Consultas.DeleteFrom(str_conn, "DELETE FILEOPOP WHERE FILEIDFI=" + itens[i].Keys["FILEIDFI"]);
            }
        }
        protected void gridFilesInsert_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            string exec;
            string dir = System.Configuration.ConfigurationManager.AppSettings["PathContratos"];
            var itens = e.DeleteValues;
            for (int i = 0; i < itens.Count; i++)
            {
                string file = MapPath(itens[i].Values["FILEPATH"].ToString());
                if (File.Exists(file))
                {
                    File.Delete(file);
                    if (!File.Exists(file))
                    {
                        exec = DataBase.Consultas.DeleteFrom(str_conn, "DELETE FILEOPOP WHERE FILEIDFI=" + itens[i].Keys["FILEIDFI"]);
                    }
                }
                else
                    exec = DataBase.Consultas.DeleteFrom(str_conn, "DELETE FILEOPOP WHERE FILEIDFI=" + itens[i].Keys["FILEIDFI"]);
            }
        }
        protected void dropCarteiraInsert2_Callback(object sender, CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropCarteiraInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "select CAIDCTRA,CADSCTRA from cacteira where (tvidestr=" + e.Parameter + " or tvidestr=1) order by cadsctra");
                dropCarteiraInsert2.DataBind();
            }
        }
        protected void dropAgenteFinanceiroInsert2_Callback(object sender, CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropAgenteFinanceiroInsert2.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT F.FOCDXCGC, concat(F.FOCDXCGC, ' - ',F.FONMAB20) FONMAB20, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8 order by fonmforn");
                dropAgenteFinanceiroInsert2.DataBind();
            }
        }
        protected void btnSelEmp_Click(object sender, EventArgs e)
        {
            if (DataBase.Consultas.Consulta(str_conn, "select count(*) from TPESTRPR where TVIDESTR=" + hfDropEstr.Value + "", 1)[0] == "0")
            {
                MsgException(HttpContext.GetGlobalResourceObject("Aquisicao", "aquisicao_erro_tipologia").ToString(), 4, "Tipologia");

            }
            dropClasseProdutoInsert2.Value = "";
            Session["TVIDESTR_PAG"] = hfDropEstr.Value;
        }
        protected void TreeList_Load(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treelist = (DevExpress.Web.ASPxTreeList.ASPxTreeList)sender;
            if (SqlDataSource1 == null) return;
            treelist.DataBind();
        }
        protected void gridVerbasIns_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            e.Editor.ReadOnly = false;
        }
        protected void gridVerbasIns_Init(object sender, EventArgs e)
        {
            gridVerbasIns.SettingsDataSecurity.AllowEdit = false;
        }
        protected void gridVerbasAlt_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            e.Editor.ReadOnly = false;
        }
        protected void dropBenefIns_Callback(object sender, CallbackEventArgsBase e)
        {
            if (e.Parameter != "")
            {
                dropBenefIns.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT F.FOCDXCGC, concat(F.FOCDXCGC, ' - ',F.FONMAB20) FONMAB20, F.PAIDPAIS,F.FOIDFORN,TVIDESTR FROM FOFORNEC F WHERE FOTPIDTP=8  order by fonmforn");
                dropBenefIns.DataBind();
            }
        }
        protected void gridDisponiveis_DataBound(object sender, EventArgs e)
        {
            gridDisponiveis.FocusedRowIndex = -1;
            if (gridDisponiveis.VisibleRowCount > 0 && gridDisponiveis.FilterExpression.Length > 0)
            {

                gridDisponiveis.Templates.EmptyDataRow = new MyTemplate { filter = gridDisponiveis.FilterExpression, sender = sender };
            }
        }
        protected void btnGridDisponiveisDuploClick_Click(object sender, EventArgs e)
        {

        }
        protected void gridDisponiveis_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string prprodid = gridDisponiveis.GetRowValues(gridDisponiveis.FocusedRowIndex, "prprodid").ToString();
            string tvidestr = hfDropEstr.Value;
            string sqlInsert = "INSERT INTO TPESTRPR (TVIDESTR ,PRPRODID) VALUES (" + tvidestr + "," + prprodid + ")";
            string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            if (exec == "OK")
            {
                sqlProdutoInsert.DataBind();
                dropProdutoInsert2.DataBind();
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
        protected void gridVerbasIns_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
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
                        gridVerbasIns.DataBind();
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
                        gridVerbasIns.DataBind();
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
                    gridVerbasIns.DataBind();
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
                    gridVerbasIns.DataBind();
                }
            }
        }
        protected void gridVerbasIns_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
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
            //else
            //{
            //    sqlValida = sqlValida.Replace("@opidcont", hfCodInterno.Value);
            //    sqlValida = sqlValida.Replace("@moidmoda", e.NewValues["MOIDMODA"].ToString());
            //    bool duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) >= 1;
            //    if (duplicado)
            //    {
            //        e.RowError = "Verba Duplicada";
            //    }
            //}
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
            //else
            //{
            //    sqlValida = sqlValida.Replace("@opidcont", hfCodInterno.Value);
            //    sqlValida = sqlValida.Replace("@moidmoda", e.NewValues["MOIDMODA"].ToString());
            //    bool duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) >= 1;
            //    if (duplicado)
            //    {
            //        e.RowError = "Verba Duplicada";
            //    }
            //}

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
        protected void btnReplicar_Load(object sender, EventArgs e)
        {
        }
        protected void btnHistorico_Load(object sender, EventArgs e)
        {
        }
        protected void btnAditamento_Load(object sender, EventArgs e)
        {
        }
        protected void btnInserirTexto_Click(object sender, EventArgs e)
        {
            string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), txtEditarTexto.Text, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            if (result != "OK")
            {
                MsgException("Erro: " + result, 1);
            }
            popupBasesInsert.ShowOnPageLoad = false;
            BasesNegociacaoInsert(hfCHIDCODI.Value, 1, 1);
        }
        protected void btnEditarTexto_Click(object sender, EventArgs e)
        {
            SwitchEditarBasesProc(13);
        }
        protected void linkReplicar_Click(object sender, EventArgs e)
        {
            if ((this.Master.FindControl("hfOperacao") as HiddenField).Value == "replicar")
            {
                string benefic2 = dropBenefAlter.SelectedItem == null ? "NULL" : dropBenefAlter.SelectedItem.Value.ToString();
                string favore2 = txtAgntFinancEdit.SelectedItem == null ? "NULL" : txtAgntFinancEdit.SelectedItem.Value.ToString();
                string sqlR = "insert into opcontra (TVIDESTR,OPCDCONT,OPNMCONT,USIDUSUA,CMTPIDCM,PRTPIDOP,PRPRODID,OPVLCONT,OPDTASCO,OPDSHORA,CAIDCTRA,OPIDCONT,OPTPFRID,TPIDSINA,OPTPRGID,OPTPTPID,FOIDFORN,FOIDFORN2,OPTPGARE,OPCDAUXI,OPDTBACO,OPDTENCO,OPDTINPG,OPDTFMPG,OPFLPARC,OPFLCARE,OPFLSLDI) " +
    "select TVIDESTR, '" + txtNumProcessoEdit.Text + "', OPNMCONT, USIDUSUA, CMTPIDCM, PRTPIDOP, PRPRODID, " + txtValorAquisicaoEdit.Text.Replace(",", ".") + ", convert(date,'" + Convert.ToDateTime(txtdtAssEdit.Text).ToString("dd/MM/yyyy") + "',103), OPDSHORA, CAIDCTRA, " + txtCodInternoEdit.Text + ", OPTPFRID, TPIDSINA, OPTPRGID, OPTPTPID, FOIDFORN,FOIDFORN2, OPTPGARE, OPCDAUXI,convert(date,'" + Convert.ToDateTime(txtDataAquisicaoEdit.Text).ToString("dd/MM/yyyy") + "',103),convert(date,'" + Convert.ToDateTime(txtdtEncerraEdit.Text).ToString("dd/MM/yyyy") + "',103),convert(date,'" + Convert.ToDateTime(txtIniPagEdit.Text).ToString("dd/MM/yyyy") + "',103),convert(date,'" + Convert.ToDateTime(txtFimPagEdit.Text).ToString("dd/MM/yyyy") + "',103)," + dropParcEdit.Value + "," + dropCareEdit.Value + "," + dropSaldoEdit.Value + " " +
    "from opcontra where opidcont = " + txtCodInterno.Text + "";
                string sqlR2 = "insert into CJCLPROP_DIN(OPIDCONT,CHIDCODI,CJIDCODI,CJTPCTTX,OPIDADIT,CHTPIDEV,CJDSCAOR,CJIDVLDE,CJIDVLAT,CJVLVALO,CJDSDECR,CJINPROP,CJVLPROP,CJDTPROP,CJDTDTDE,CJDTDTAT,CJVLDEAT) " +
    "select " + txtCodInternoEdit.Text + ", CHIDCODI, CJIDCODI, CJTPCTTX, OPIDADIT, CHTPIDEV, CJDSCAOR, CJIDVLDE, CJIDVLAT, CJVLVALO, CJDSDECR, CJINPROP, CJVLPROP, CJDTPROP, CJDTDTDE, CJDTDTAT, CJVLDEAT " +
    "from CJCLPROP_DIN where opidcont = " + txtCodInterno.Text + " and cjidcodi in (select distinct CJIDCODI from VIPROEVE where CHTPIDEV=1) ";
                string exec1 = DataBase.Consultas.InsertInto(str_conn, sqlR);
                if (exec1 == "OK")
                {
                    DateTime dtExpira = Convert.ToDateTime(txtdtEncerraEdit.Text);
                    DataBase.WorkflowAdmin wflow = new DataBase.WorkflowAdmin();
                    wflow.str_conn = str_conn;
                    wflow.OPIDCONT = txtCodInternoInsert.Text;
                    wflow.Encerramento = true;
                    wflow.Usuario = hfUser.Value;
                    wflow.DataExpira = dtExpira;
                    wflow.Renova = 0;
                    wflow.CriarWfw();
                    string exec22 = DataBase.Consultas.InsertInto(str_conn, sqlR2);
                    if (exec22 == "OK")
                    {
                        DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
                        grid.DataBind();
                        int Index = 0;
                        for (int i = 0; i < grid.VisibleRowCount; i++)
                        {
                            if (grid.GetRowValues(i, "OPIDCONT").ToString() == txtCodInternoEdit.Text)
                            {
                                Index = i;
                                grid.FocusedRowIndex = Index;
                                break;
                            }
                        }
                        ddePesqContrato.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
                        hfIndexGrid.Value = Index.ToString();
                        if (hfIndexGrid.Value != null)
                        {
                            (this.Master.FindControl("hfOperacao") as HiddenField).Value = "replicar";
                            CarregaContrato(Convert.ToInt32(txtCodInternoEdit.Text), false);
                            btnOK.Enabled = false;
                        }
                        btnOK.Enabled = false;
                    }
                    else
                    {
                        MsgException(exec22, 1);
                    }
                }
                else
                {
                    MsgException(exec1, 1);
                }
            }
        }
        protected void gridRptDeAteData_InitNewRow(object sender, DevExpress.Web.Data.ASPxDataInitNewRowEventArgs e)
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
        protected void gridRptDeAteData_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            CultureInfo br = new CultureInfo("pt-BR");
            e.Handled = true;
            int oper = 99;
            foreach (var itens in e.UpdateValues)
            {
                string De = itens.NewValues["De"].ToString();
                string Ate = itens.NewValues["Ate"].ToString();
                string Valor = itens.NewValues["Valor"].ToString();
                string Data = itens.NewValues["Data"].ToString();
                string result = AlterarPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, Convert.ToDateTime(Data, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(De, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(Ate, CultureInfo.GetCultureInfo(lang)), Valor.Replace(",", "."), Convert.ToInt32(itens.Keys["ID"]));
                oper = 0;
            }
            foreach (var itens in e.InsertValues)
            {
                string De = itens.NewValues["De"].ToString();
                string Ate = itens.NewValues["Ate"].ToString();
                string Valor = itens.NewValues["Valor"].ToString();
                string Data = itens.NewValues["Data"].ToString();
                string result = InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), null, 0, null, Convert.ToDateTime(Data, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(De, CultureInfo.GetCultureInfo(lang)), Convert.ToDateTime(Ate, CultureInfo.GetCultureInfo(lang)), Valor.Replace(",", "."));
                oper = 1;
            }
            foreach (var itens in e.DeleteValues)
            {
                string De = itens.Values["De"].ToString();
                string Ate = itens.Values["Ate"].ToString();
                string Valor = itens.Values["Valor"].ToString();
                string Data = itens.Values["Data"].ToString();
                string del = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is null and cjdtdtde=convert(datetime,'" + Convert.ToDateTime(De).ToString("dd/MM/yyyy") + "',103) and cjdtdtat=convert(datetime,'" + Convert.ToDateTime(Ate).ToString("dd/MM/yyyy") + "',103) and cjdtprop=convert(datetime,'" + Convert.ToDateTime(Data).ToString("dd/MM/yyyy") + "',103) and CJVLDEAT=" + Valor.Replace(",", ".") + "";
                string delete = Consultas.DeleteFrom(str_conn, del);
                oper = 2;
            }
            string query = "select count(opidcont) from cjclprop_din " +
                    "where CHIDCODI = " + hfCHIDCODI2.Value + " " +
                      "and opidcont = " + hfCodInterno.Value + " " +
                      "and cjidcodi = " + hfCJIDCODI2.Value + " " +
                      "and CJTPCTTX is null";
            int cont = Convert.ToInt32(Consultas.Consulta(str_conn, query, 1)[0]);
            string str = string.Empty;
            if (cont == 0)
            {
                if (oper == 1)
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), "1 Item", 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                else if (oper == 2)
                {
                    string del = "delete cjclprop_din where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is not null";
                    string delete = Consultas.DeleteFrom(str_conn, del);
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
                int cont2 = Convert.ToInt32(Consultas.Consulta(str_conn, query, 1)[0]);
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
                int cont3 = Convert.ToInt32(Consultas.Consulta(str_conn, query, 1)[0]);
                if (oper == 1 && cont3 == 0)
                    InsertPropriedadesDinamicas(Convert.ToInt32(hfCodInterno.Value), Convert.ToInt32(hfCHIDCODI2.Value), Convert.ToInt32(hfCJIDCODI2.Value), Convert.ToInt32(hfCJTPIDTP2.Value), str, 0, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
            }
            string upt = "update cjclprop_din set cjtpcttx='" + str + "' where CHIDCODI = " + hfCHIDCODI2.Value + " and opidcont = " + hfCodInterno.Value + " and cjidcodi = " + hfCJIDCODI2.Value + " and CJTPCTTX is not null";
            Consultas.UpdateFrom(str_conn, upt);
            gridRptDeAteData.DataSource = Consultas.Consulta(str_conn, hfqueryRpt.Value);
            gridRptDeAteData.DataBind();
            BasesNegociacaoEdit(hfCodInterno.Value, 1, dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value));
            BasesNegociacaoInsert(hfCHIDCODI2.Value, 1, dropEventoAditamento.Value == null ? 1 : Convert.ToInt32(dropEventoAditamento.Value));
        }
        protected void btnDesmembrar_Click(object sender, EventArgs e)
        {

        }
        protected void gridDesmembramentos1_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            DateTime dtliberacao = Convert.ToDateTime(dateDesmembra.Text);
            string sql = "select convert(float,ph.phvldeve) " +
"from phplanif ph " +
"where ph.opidcont = " + hfOPIDCONT.Value + " " +
"and ph.phdteven = (select min(px.phdteven) " +
           "from phplanif px " +
           "where px.opidcont = ph.opidcont " +
             "and px.phdteven >= convert(date, '" + dtliberacao.ToString("dd/MM/yyyy") + "', 103))";
            decimal valorContratoPai = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sql, 1)[0]);
            DateTime dtEncerra = Convert.ToDateTime(DataBase.Consultas.Consulta(str_conn, "select OPDTENCO from opcontra where opidcont=" + hfOPIDCONT.Value, 1)[0]);
            int qtdFilhos = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from OPCONTRA where OPIDAACC=" + hfOPIDCONT.Value, 1)[0]);
            bool insertOK = false;
            foreach (var item in e.InsertValues)
            {
                decimal percentual = Convert.ToDecimal(item.NewValues["percentual"].ToString()) / 100;
                int nrParcelas = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "SELECT count(monthid) from(  SELECT Month(DATEADD(MONTH, x.number, convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103))) AS MonthId  FROM master.dbo.spt_values x  WHERE x.type = 'P' AND x.number <= DATEDIFF(MONTH, convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103), convert(date,'" + dtEncerra.ToString("dd/MM/yyyy") + "',103))) A ", 1)[0]);
                string OPIDCONT = CarregaCodInterno("2", 1);
                string OPDTASCO = "convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103)";
                string OPDTBACO = "convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103)";
                string OPDTINPG = "convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103)";
                string OPVLCONT = (valorContratoPai * percentual).ToString();
                string OPIDAACC = hfOPIDCONT.Value;
                string OPCDCONT = DataBase.Consultas.Consulta(str_conn, "select count(*)+1 from OPCONTRA where OPIDAACC=" + hfOPIDCONT.Value, 1)[0];
                string FOIDFORN = item.NewValues["FOIDFORN"].ToString();
                string FOIDFORN2 = item.NewValues["FOIDFORN2"] == null ? "NULL" : item.NewValues["FOIDFORN2"].ToString();
                string sqlInsertOPCONTRA = "INSERT INTO OPCONTRA (PRPRODID ,OPCDCONT ,OPIDCONT ,OPCDAUXI ,OPNMCONT ,FOIDFORN ,FOIDFORN2 ,OPDTASCO ,OPDTBACO ,OPDTENCO ,OPVLCONT ,CAIDCTRA ,OPDTINCO ,OPDSOBSE ,USIDUSUA ,TVIDESTR ,OPDSHORA ,CLACONID ,OPCDAUXA ,OPIDAACC ,PRTPIDOP ,OPTPFRID ,TPIDSINA ,OPTPRGID ,OPTPTPID ,OPTPCOT ,TPGARAID ,TPIDDOCU ,FOIDFOR2 ,OPVLORIG ,OPDTVALI ,VIIDSDFA ,FOIDBOLS ,OPNOTRAD ,OPCDDDTR ,OPNFONTR ,OPNRAMTR ,OPDTORIG ,OPQTTOLE ,TPIDTIPM ,TPIDMERC ,OPDTSALD ,TPIDCDPR ,TPIDTPPR ,TPIDPROR ,OPIDTRAD ,OPVLPRUN ,TPIDCOVE ,TPIDORVE ,COIDCONV ,OPNUPARC ,OPIDPERI ,OPDTPRVC ,OPIDFRPC ,CMTPIDCM ,TPCVIDTP ,OPIDBOLS ,OPIDBABO ,TPIDTIPO ,TPIDESTI ,TPIDFORM ,TPIDCOND ,OPIDINEC ,OPIDMEST ,PEIDPERI ,OPEXEXER ,FANUFATA ,OPANSFIN ,OPANSFFI ,PRCDBOLS ,OPNUNFEN ,OPDTEXER ,IEIDINEC ,OPIDRETE ,OPFLCHMA ,OPIDREFE ,OPIDITEM ,OPNRINTV ,OPNRPZFX ,OPNRPZPG ,OPIDTPPR ,OPIDPROR ,UNIDUNID ,OPCDNFAG ,OPVLADTO ,OPDTLQOP ,OPIDOPCA ,OPIDQTLT ,OPIDVISU ,TSIDPROC ,OPIDBROK ,OPDTINCI ,VBIDFREN ,FICDTRIB ,FCFRREAJ ,FCDSDENU ,FCCDTVSE ,FCCDTOBS ,FCCDTNSE ,FCCDTNOT ,FCCDTIFA ,DACDDIAU ,ATCDATIV ,GDCDCLIE ,FRCDFREN ,TPIDPRCA ,TPIDOTCO ,OVCDIDTP ,OPTPGARE ,MPIDMTPR ,OPFLSLDI ,OPFLCARE ,OPFLPARC ,OPDTINPG ,OPDTFMPG ,OPDTADIT ,OPSQADIT ,OPJUADIT ,OPTSADIT ,OPUSADIT ,REIDIMOV) " +
"SELECT PRPRODID, concat(OPCDCONT,'_',REPLACE(STR(@OPCDCONT, 4), SPACE(1), '0')), @OPIDCONT, OPCDAUXI, OPNMCONT, @FOIDFORN, @FOIDFORN2, @OPDTASCO, @OPDTBACO, OPDTENCO, @OPVLCONT, CAIDCTRA, OPDTINCO, OPDSOBSE, '" + hfUser.Value + "', TVIDESTR, OPDSHORA, CLACONID, OPCDAUXA, @OPIDAACC, PRTPIDOP, OPTPFRID, TPIDSINA, OPTPRGID, 1, OPTPCOT, TPGARAID, TPIDDOCU, FOIDFOR2, OPVLORIG, OPDTVALI, VIIDSDFA, FOIDBOLS, OPNOTRAD, OPCDDDTR, OPNFONTR, OPNRAMTR, OPDTORIG, OPQTTOLE, TPIDTIPM, TPIDMERC, OPDTSALD, TPIDCDPR, TPIDTPPR, TPIDPROR, OPIDTRAD, OPVLPRUN, TPIDCOVE, TPIDORVE, COIDCONV, OPNUPARC, OPIDPERI, OPDTPRVC, OPIDFRPC, CMTPIDCM, TPCVIDTP, OPIDBOLS, OPIDBABO, TPIDTIPO, TPIDESTI, TPIDFORM, TPIDCOND, OPIDINEC, OPIDMEST, PEIDPERI, OPEXEXER, FANUFATA, OPANSFIN, OPANSFFI, PRCDBOLS, OPNUNFEN, OPDTEXER, IEIDINEC, OPIDRETE, OPFLCHMA, OPIDREFE, OPIDITEM, OPNRINTV, OPNRPZFX, OPNRPZPG, OPIDTPPR, OPIDPROR, UNIDUNID, OPCDNFAG, OPVLADTO, OPDTLQOP, OPIDOPCA, OPIDQTLT, OPIDVISU, TSIDPROC, OPIDBROK, OPDTINCI, VBIDFREN, FICDTRIB, FCFRREAJ, FCDSDENU, FCCDTVSE, FCCDTOBS, FCCDTNSE, FCCDTNOT, FCCDTIFA, DACDDIAU, ATCDATIV, GDCDCLIE, FRCDFREN, TPIDPRCA, TPIDOTCO, OVCDIDTP, OPTPGARE, MPIDMTPR, OPFLSLDI, OPFLCARE, OPFLPARC, @OPDTINPG, OPDTFMPG, OPDTADIT, OPSQADIT, OPJUADIT, OPTSADIT, OPUSADIT, REIDIMOV " +
"FROM OPCONTRA WHERE OPIDCONT = " + hfOPIDCONT.Value;
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPIDCONT", OPIDCONT);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPDTASCO", OPDTASCO);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPDTBACO", OPDTBACO);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPDTINPG", OPDTINPG);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPVLCONT", OPVLCONT.Replace(",", "."));
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPIDAACC", OPIDAACC);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPCDCONT", OPCDCONT);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@FOIDFORN2", FOIDFORN2);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@FOIDFORN", FOIDFORN);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertOPCONTRA);
                if (exec == "OK")
                {
                    string sqlInsertVerba = "INSERT INTO VIOPMODA (OPIDCONT ,MOIDMODA ,CHIDCODI ,CJIDCODI ,VITPPGTO ,VIDIAMOD ,PFIDCRED ,PFIDDEBI) " +
"select @OPIDCONT, V.MOIDMODA ,CHIDCODI ,CJIDCODI ,VITPPGTO ,VIDIAMOD ,PFIDCRED ,PFIDDEBI from VIOPMODA V, MODALIDA M " +
"WHERE V.MOIDMODA = M.MOIDMODA " +
  "AND V.OPIDCONT = " + hfOPIDCONT.Value + " AND MOCDMODA = 1";
                    sqlInsertVerba = sqlInsertVerba.Replace("@OPIDCONT", OPIDCONT);
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertVerba);
                    string sqlInsertCJCLPROP_DIN = "INSERT INTO CJCLPROP_DIN (OPIDCONT ,CHIDCODI ,CJIDCODI ,CJTPCTTX ,OPIDADIT ,CHTPIDEV ,CJDSCAOR ,CJIDVLDE ,CJIDVLAT ,CJVLVALO ,CJDSDECR ,CJINPROP ,CJVLPROP ,CJDTPROP ,CJDTDTDE ,CJDTDTAT ,CJVLDEAT ,OPDTADIT ,OPSQADIT) " +
"SELECT @OPIDCONT, CHIDCODI, CJIDCODI, CJTPCTTX, OPIDADIT, CHTPIDEV, CJDSCAOR, CJIDVLDE, CJIDVLAT, CJVLVALO, CJDSDECR, CJINPROP, CJVLPROP, CJDTPROP, CJDTDTDE, CJDTDTAT, CJVLDEAT, OPDTADIT, OPSQADIT " +
"FROM CJCLPROP_DIN where OPIDCONT = " + hfOPIDCONT.Value + " and CJIDCODI not in (265, 266)";
                    sqlInsertCJCLPROP_DIN = sqlInsertCJCLPROP_DIN.Replace("@OPIDCONT", OPIDCONT);
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertCJCLPROP_DIN);
                    if (exec == "OK")
                    {
                        insertOK = true;
                        string sqlUpdDeAte = "update CJCLPROP_din set CJDTDTDE=convert(date,'" + dtliberacao.ToString("dd/MM/yyyy") + "',103) where CJIDCODI in (select CJIDCODI from CJCLPROP_din D, OPCONTRA O where D.CJDTDTDE=O.OPDTBACO AND O.OPIDCONT=D.OPIDCONT AND O.OPIDCONT=" + OPIDAACC + ") and OPIDCONT=" + OPIDCONT;
                        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdDeAte);
                        string CHIDCODI = DataBase.Consultas.Consulta(str_conn, "select p.chidcodi from opcontra o,PRPRODUT p where o.PRPRODID=p.prprodid and o.opidcont=" + hfOPIDCONT.Value, 1)[0];
                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 265, 3, null, 0, null, dtliberacao, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                        InsertPropriedadesDinamicas(Convert.ToInt32(OPIDCONT), Convert.ToInt32(CHIDCODI), 266, 9, null, nrParcelas, null, new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), new DateTime(1970, 01, 01), null);
                    }
                }
            }
            if (qtdFilhos == 0 && insertOK)
            {
                decimal valorFilhos = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, "select sum(OPVLCONT) from OPCONTRA where OPIDAACC=" + hfOPIDCONT.Value, 1)[0]);
                string OPIDCONT = CarregaCodInterno("2", 1);
                string OPVLCONT = (valorContratoPai - valorFilhos).ToString();
                string OPIDAACC = hfOPIDCONT.Value;
                string sqlInsertOPCONTRA = "INSERT INTO OPCONTRA (PRPRODID ,OPCDCONT ,OPIDCONT ,OPCDAUXI ,OPNMCONT ,FOIDFORN ,FOIDFORN2 ,OPDTASCO ,OPDTBACO ,OPDTENCO ,OPVLCONT ,CAIDCTRA ,OPDTINCO ,OPDSOBSE ,USIDUSUA ,TVIDESTR ,OPDSHORA ,CLACONID ,OPCDAUXA ,OPIDAACC ,PRTPIDOP ,OPTPFRID ,TPIDSINA ,OPTPRGID ,OPTPTPID ,OPTPCOT ,TPGARAID ,TPIDDOCU ,FOIDFOR2 ,OPVLORIG ,OPDTVALI ,VIIDSDFA ,FOIDBOLS ,OPNOTRAD ,OPCDDDTR ,OPNFONTR ,OPNRAMTR ,OPDTORIG ,OPQTTOLE ,TPIDTIPM ,TPIDMERC ,OPDTSALD ,TPIDCDPR ,TPIDTPPR ,TPIDPROR ,OPIDTRAD ,OPVLPRUN ,TPIDCOVE ,TPIDORVE ,COIDCONV ,OPNUPARC ,OPIDPERI ,OPDTPRVC ,OPIDFRPC ,CMTPIDCM ,TPCVIDTP ,OPIDBOLS ,OPIDBABO ,TPIDTIPO ,TPIDESTI ,TPIDFORM ,TPIDCOND ,OPIDINEC ,OPIDMEST ,PEIDPERI ,OPEXEXER ,FANUFATA ,OPANSFIN ,OPANSFFI ,PRCDBOLS ,OPNUNFEN ,OPDTEXER ,IEIDINEC ,OPIDRETE ,OPFLCHMA ,OPIDREFE ,OPIDITEM ,OPNRINTV ,OPNRPZFX ,OPNRPZPG ,OPIDTPPR ,OPIDPROR ,UNIDUNID ,OPCDNFAG ,OPVLADTO ,OPDTLQOP ,OPIDOPCA ,OPIDQTLT ,OPIDVISU ,TSIDPROC ,OPIDBROK ,OPDTINCI ,VBIDFREN ,FICDTRIB ,FCFRREAJ ,FCDSDENU ,FCCDTVSE ,FCCDTOBS ,FCCDTNSE ,FCCDTNOT ,FCCDTIFA ,DACDDIAU ,ATCDATIV ,GDCDCLIE ,FRCDFREN ,TPIDPRCA ,TPIDOTCO ,OVCDIDTP ,OPTPGARE ,MPIDMTPR ,OPFLSLDI ,OPFLCARE ,OPFLPARC ,OPDTINPG ,OPDTFMPG ,OPDTADIT ,OPSQADIT ,OPJUADIT ,OPTSADIT ,OPUSADIT ,REIDIMOV) " +
"SELECT PRPRODID, concat(OPCDCONT,'_','0000'), @OPIDCONT, OPCDAUXI, OPNMCONT, FOIDFORN, FOIDFORN2, OPDTASCO, OPDTBACO, OPDTENCO, @OPVLCONT, CAIDCTRA, OPDTINCO, OPDSOBSE, '" + hfUser.Value + "', TVIDESTR, OPDSHORA, CLACONID, OPCDAUXA, @OPIDAACC, PRTPIDOP, OPTPFRID, TPIDSINA, OPTPRGID, 1, OPTPCOT, TPGARAID, TPIDDOCU, FOIDFOR2, OPVLORIG, OPDTVALI, VIIDSDFA, FOIDBOLS, OPNOTRAD, OPCDDDTR, OPNFONTR, OPNRAMTR, OPDTORIG, OPQTTOLE, TPIDTIPM, TPIDMERC, OPDTSALD, TPIDCDPR, TPIDTPPR, TPIDPROR, OPIDTRAD, OPVLPRUN, TPIDCOVE, TPIDORVE, COIDCONV, OPNUPARC, OPIDPERI, OPDTPRVC, OPIDFRPC, CMTPIDCM, TPCVIDTP, OPIDBOLS, OPIDBABO, TPIDTIPO, TPIDESTI, TPIDFORM, TPIDCOND, OPIDINEC, OPIDMEST, PEIDPERI, OPEXEXER, FANUFATA, OPANSFIN, OPANSFFI, PRCDBOLS, OPNUNFEN, OPDTEXER, IEIDINEC, OPIDRETE, OPFLCHMA, OPIDREFE, OPIDITEM, OPNRINTV, OPNRPZFX, OPNRPZPG, OPIDTPPR, OPIDPROR, UNIDUNID, OPCDNFAG, OPVLADTO, OPDTLQOP, OPIDOPCA, OPIDQTLT, OPIDVISU, TSIDPROC, OPIDBROK, OPDTINCI, VBIDFREN, FICDTRIB, FCFRREAJ, FCDSDENU, FCCDTVSE, FCCDTOBS, FCCDTNSE, FCCDTNOT, FCCDTIFA, DACDDIAU, ATCDATIV, GDCDCLIE, FRCDFREN, TPIDPRCA, TPIDOTCO, OVCDIDTP, OPTPGARE, MPIDMTPR, OPFLSLDI, OPFLCARE, OPFLPARC, OPDTINPG, OPDTFMPG, OPDTADIT, OPSQADIT, OPJUADIT, OPTSADIT, OPUSADIT, REIDIMOV " +
"FROM OPCONTRA WHERE OPIDCONT = " + hfOPIDCONT.Value;
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPIDCONT", OPIDCONT);
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPVLCONT", OPVLCONT.Replace(",", "."));
                sqlInsertOPCONTRA = sqlInsertOPCONTRA.Replace("@OPIDAACC", OPIDAACC);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertOPCONTRA);
                if (exec == "OK")
                {
                    string sqlInsertVerba = "INSERT INTO VIOPMODA (OPIDCONT ,MOIDMODA ,CHIDCODI ,CJIDCODI ,VITPPGTO ,VIDIAMOD ,PFIDCRED ,PFIDDEBI) " +
"select @OPIDCONT, V.MOIDMODA ,CHIDCODI ,CJIDCODI ,VITPPGTO ,VIDIAMOD ,PFIDCRED ,PFIDDEBI from VIOPMODA V, MODALIDA M " +
"WHERE V.MOIDMODA = M.MOIDMODA " +
  "AND V.OPIDCONT = " + hfOPIDCONT.Value + " AND MOCDMODA = 1";
                    sqlInsertVerba = sqlInsertVerba.Replace("@OPIDCONT", OPIDCONT);
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertVerba);
                    string sqlInsertCJCLPROP_DIN = "INSERT INTO CJCLPROP_DIN (OPIDCONT ,CHIDCODI ,CJIDCODI ,CJTPCTTX ,OPIDADIT ,CHTPIDEV ,CJDSCAOR ,CJIDVLDE ,CJIDVLAT ,CJVLVALO ,CJDSDECR ,CJINPROP ,CJVLPROP ,CJDTPROP ,CJDTDTDE ,CJDTDTAT ,CJVLDEAT ,OPDTADIT ,OPSQADIT) " +
"SELECT @OPIDCONT, CHIDCODI, CJIDCODI, CJTPCTTX, OPIDADIT, CHTPIDEV, CJDSCAOR, CJIDVLDE, CJIDVLAT, CJVLVALO, CJDSDECR, CJINPROP, CJVLPROP, CJDTPROP, CJDTDTDE, CJDTDTAT, CJVLDEAT, OPDTADIT, OPSQADIT " +
"FROM CJCLPROP_DIN where OPIDCONT = " + hfOPIDCONT.Value + " ";
                    sqlInsertCJCLPROP_DIN = sqlInsertCJCLPROP_DIN.Replace("@OPIDCONT", OPIDCONT);
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertCJCLPROP_DIN);
                    if (exec == "OK")
                    {

                    }
                }
            }
            gridDesmembramentos1.DataBind();
        }
        protected object GetTotalSummaryValue()
        {
            ASPxSummaryItem summaryItem = gridDesmembramentos1.TotalSummary.First(i => i.Tag == "percentual_Sum");
            return gridDesmembramentos1.GetTotalSummaryValue(summaryItem);
        }
        protected void gridDesmembramentos1_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            ASPxCheckBox lbl = gridDesmembramentos1.FindStatusBarTemplateControl("checkSalvarDesmembra") as ASPxCheckBox;
            //sqlFornecedores.DataBind();
            //gridDesmembramentos1.DataBind();
            if (string.IsNullOrEmpty(hfOPIDCONT.Value))
            {
                lbl.Text = "Necessário selecionar a data para confirmar operação.";
                lbl.ClientEnabled = false;
                return;
            }
            if (e.Parameters == string.Empty)
            {
                lbl.Text = "Necessário selecionar a data para confirmar operação.";
                lbl.ClientEnabled = false;
                return;
            }
            DateTime dt = Convert.ToDateTime(e.Parameters);
            string sql = "select convert(float,ph.phvldeve) " +
  "from phplanif ph " +
  "where ph.opidcont = " + hfOPIDCONT.Value + " " +
    "and ph.phdteven = (select min(px.phdteven) " +
                       "from phplanif px " +
                       "where px.opidcont = ph.opidcont " +
                         "and px.phdteven >= convert(date, '" + dt.ToString("dd/MM/yyyy") + "', 103))";
            decimal valorSaldo = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sql, 1)[0]);

            lbl.Text = "Confirmo que o Desmembramento de um contrato é uma operação irreversível. Saldo de " + valorSaldo.ToString("n2") + " em " + dt.ToShortDateString();
            lbl.ClientEnabled = true;
        }
        protected void ASPxCallback1_Callback(object source, CallbackEventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("{Digitado}", txtEditarInteiro.Text).Replace("{Validado}", valida);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", txtEditarInteiro.Text).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", txtEditarInteiro.Text).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(txtEditarInteiro.Text))
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1];
                        else
                            e.Result = result[1];


                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }
        }
        protected void callMoeda_Callback(object source, CallbackEventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("{Digitado}", txtEditarMoeda.Text.Replace(",", ".")).Replace("{Validado}", valida.Replace(",", "."));
                    decimal aDecimal = new decimal(1.0);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", txtEditarMoeda.Text).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", txtEditarMoeda.Text).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(txtEditarMoeda.Text))
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1];
                        else
                            e.Result = result[1];


                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }
        }
        protected void callFlutuante_Callback(object source, CallbackEventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("{Digitado}", txtEditarFlutuante.Text.Replace(",", ".")).Replace("{Validado}", valida.Replace(",", "."));
                    decimal aDecimal = new decimal(1.0);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", txtEditarFlutuante.Text).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", txtEditarFlutuante.Text).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(txtEditarFlutuante.Text))
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1];
                        else
                            e.Result = result[1];


                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }
        }
        protected void callFormula_Callback(object source, CallbackEventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("[DELETE]", "").Replace("{Digitado}", dropEditarFormula.Value.ToString().Replace(",", ".")).Replace("{Validado}", valida.Replace(",", "."));
                    decimal aDecimal = new decimal(1.0);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", dropEditarFormula.Value.ToString()).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", dropEditarFormula.Value.ToString()).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(dropEditarFormula.Value.ToString()))
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1];
                        else
                            e.Result = result[1];


                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }
        }
        protected void callSQL_Callback(object source, CallbackEventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("{Digitado}", dropEditarSql2.Value.ToString().Replace(",", ".")).Replace("{Validado}", valida.Replace(",", "."));
                    decimal aDecimal = new decimal(1.0);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", dropEditarSql2.Value.ToString()).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", dropEditarSql2.Value.ToString()).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(dropEditarSql2.Value.ToString()))
                    {
                        e.Result = "valid";
                    }
                    else
                    {

                        if (delete)
                            e.Result = "[DELETE]" + result[1];
                        else
                            e.Result = result[1];


                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }
        }
        protected void gridRptDeAte_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            DateTime de = Convert.ToDateTime(e.NewValues["De"].ToString());
            DateTime ate = Convert.ToDateTime(e.NewValues["Ate"].ToString());
            string valor = e.NewValues["Valor"].ToString();
            if (e.IsNewRow)
            {
                var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
                string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
                bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
                if (result[0] != null && result[1] != null && result[2] != null)
                {
                    bool delete = result[2].IndexOf("[DELETE]") >= 0;
                    if (result[0].IndexOf("[SQL]") >= 0)
                    {
                        string sqlValida = result[0].Replace("[SQL]", "");
                        sqlValida = sqlValida.ToUpper();
                        sqlValida = sqlValida.Replace("{DE}", "convert(date,'" + de.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{ATE}", "convert(date,'" + ate.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{VALOR}", "convert(float,'" + valor.Replace(",", ".") + "',103)");
                        string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                        if (valida == null)
                        {
                            e.RowError = "Não foi possível validar. Acionar Suporte.";
                            return;
                        }
                        string szExpression = result[2].Replace("{Validado}", valida.Replace(",", "."));
                        var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                        if (!resultado)
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                    else if (result[0].IndexOf("[REGEX]") >= 0)
                    {
                        string regexValida = result[0].Replace("[REGEX]", "");
                        Regex regEx = new Regex(regexValida);
                        if (!regEx.IsMatch(dropEditarSql2.Value.ToString()))
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                }
            }
            else
            {
                var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
                string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
                bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
                if (result[0] != null && result[1] != null && result[2] != null)
                {
                    bool delete = result[2].IndexOf("[DELETE]") >= 0;
                    if (result[0].IndexOf("[SQL]") >= 0)
                    {
                        string sqlValida = result[0].Replace("[SQL]", "");
                        sqlValida = sqlValida.ToUpper();
                        sqlValida = sqlValida.Replace("{DE}", "convert(date,'" + de.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{ATE}", "convert(date,'" + ate.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{VALOR}", "convert(float,'" + valor.Replace(",", ".") + "',103)");
                        string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                        if (valida == null)
                        {
                            e.RowError = "Não foi possível validar. Acionar Suporte.";
                            return;
                        }
                        string szExpression = result[2].Replace("{Validado}", valida.Replace(",", "."));
                        var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                        if (!resultado)
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                    else if (result[0].IndexOf("[REGEX]") >= 0)
                    {
                        string regexValida = result[0].Replace("[REGEX]", "");
                        Regex regEx = new Regex(regexValida);
                        if (!regEx.IsMatch(dropEditarSql2.Value.ToString()))
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                }
            }
        }
        protected void gridRptDeAteData_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            DateTime de = Convert.ToDateTime(e.NewValues["De"].ToString());
            DateTime ate = Convert.ToDateTime(e.NewValues["Ate"].ToString());
            DateTime dtref = Convert.ToDateTime(e.NewValues["Data"].ToString());
            string valor = e.NewValues["Valor"].ToString();
            if (e.IsNewRow)
            {
                var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
                string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
                bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
                if (result[0] != null && result[1] != null && result[2] != null)
                {
                    bool delete = result[2].IndexOf("[DELETE]") >= 0;
                    if (result[0].IndexOf("[SQL]") >= 0)
                    {
                        string sqlValida = result[0].Replace("[SQL]", "");
                        sqlValida = sqlValida.ToUpper();
                        sqlValida = sqlValida.Replace("{DE}", "convert(date,'" + de.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{ATE}", "convert(date,'" + ate.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{REF}", "convert(date,'" + dtref.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{VALOR}", "convert(float,'" + valor.Replace(",", ".") + "',103)");
                        string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                        if (valida == null)
                        {
                            e.RowError = "Não foi possível validar. Acionar Suporte.";
                            return;
                        }
                        string szExpression = result[2].Replace("{Validado}", valida.Replace(",", "."));
                        var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                        if (!resultado)
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                    else if (result[0].IndexOf("[REGEX]") >= 0)
                    {
                        string regexValida = result[0].Replace("[REGEX]", "");
                        Regex regEx = new Regex(regexValida);
                        if (!regEx.IsMatch(dropEditarSql2.Value.ToString()))
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                }
            }
            else
            {
                var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
                string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
                bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
                if (result[0] != null && result[1] != null && result[2] != null)
                {
                    bool delete = result[2].IndexOf("[DELETE]") >= 0;
                    if (result[0].IndexOf("[SQL]") >= 0)
                    {
                        string sqlValida = result[0].Replace("[SQL]", "");
                        sqlValida = sqlValida.ToUpper();
                        sqlValida = sqlValida.Replace("{DE}", "convert(date,'" + de.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{ATE}", "convert(date,'" + ate.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{REF}", "convert(date,'" + dtref.ToString("dd/MM/yyyy") + "',103)");
                        sqlValida = sqlValida.Replace("{VALOR}", "convert(float,'" + valor.Replace(",", ".") + "',103)");
                        string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                        if (valida == null)
                        {
                            e.RowError = "Não foi possível validar. Acionar Suporte.";
                            return;
                        }
                        string szExpression = result[2].Replace("{Validado}", valida.Replace(",", "."));
                        var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                        if (!resultado)
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                    else if (result[0].IndexOf("[REGEX]") >= 0)
                    {
                        string regexValida = result[0].Replace("[REGEX]", "");
                        Regex regEx = new Regex(regexValida);
                        if (!regEx.IsMatch(dropEditarSql2.Value.ToString()))
                        {

                            e.RowError = result[1];
                            return;

                        }
                    }
                }
            }
        }
        protected void callIndice_Callback(object source, CallbackEventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("{Digitado}", txtEditarIndice.Text).Replace("{Validado}", valida);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {
                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", txtEditarIndice.Text).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", txtEditarIndice.Text).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(txtEditarIndice.Text))
                    {
                        e.Result = "valid";
                    }
                    else
                    {
                        if (valida2)
                            e.Result = "valid";
                        else
                        {
                            if (delete)
                                e.Result = "[DELETE]" + result[1];
                            else
                                e.Result = result[1];

                        }
                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }
        }
        protected void callTexto_Callback(object source, CallbackEventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("{Digitado}", txtEditarTexto.Text).Replace("{Validado}", valida);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {
                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", txtEditarTexto.Text).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", txtEditarTexto.Text).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(txtEditarTexto.Text))
                    {
                        e.Result = "valid";
                    }
                    else
                    {
                        if (valida2)
                            e.Result = "valid";
                        else
                        {
                            if (delete)
                                e.Result = "[DELETE]" + result[1];
                            else
                                e.Result = result[1];

                        }
                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }
        }
        protected void callData_Callback(object source, CallbackEventArgs e)
        {
            DateTime dtref = Convert.ToDateTime(txtEditarData.Text);
            var result = DataBase.Consultas.Consulta(str_conn, "select CJDSEXPR,CJDSMENS,CJFILTRO from CJCLPROP where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + "", 3);
            string sqlValida2 = "select count(*) from CJCLPROP_DIN where CJIDCODI=" + hfCJIDCODI2.Value + " and CHIDCODI=" + hfCHIDCODI2.Value + " AND OPIDCONT=" + hfOPIDCONT.Value;
            bool valida2 = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida2, 1)[0]) == 0;
            if (result[0] != null && result[1] != null && result[2] != null)
            {
                bool delete = result[2].IndexOf("[DELETE]") >= 0;
                if (result[0].IndexOf("[SQL]") >= 0)
                {
                    string sqlValida = result[0].Replace("[SQL]", "");
                    sqlValida = sqlValida.Replace("{REF}", "convert(date,'" + dtref.ToString("dd/MM/yyyy") + "',103)");
                    string valida = DataBase.Consultas.Consulta(str_conn, sqlValida.Replace("{OPIDCONT}", hfOPIDCONT.Value), 1)[0];
                    string szExpression = result[2].Replace("{Digitado}", txtEditarTexto.Text).Replace("{Validado}", valida);
                    var resultado = Funcoes.EvaluateLogicalExpression(szExpression);
                    if (resultado)
                    {
                        e.Result = "valid";
                    }
                    else
                    {
                        if (delete)
                            e.Result = "[DELETE]" + result[1].Replace("{Digitado}", txtEditarTexto.Text).Replace("{Validado}", valida);
                        else
                            e.Result = result[1].Replace("{Digitado}", txtEditarTexto.Text).Replace("{Validado}", valida);

                    }
                }
                else if (result[0].IndexOf("[REGEX]") >= 0)
                {
                    string regexValida = result[0].Replace("[REGEX]", "");
                    Regex regEx = new Regex(regexValida);
                    if (regEx.IsMatch(txtEditarTexto.Text))
                    {
                        e.Result = "valid";
                    }
                    else
                    {
                        if (valida2)
                            e.Result = "valid";
                        else
                        {
                            if (delete)
                                e.Result = "[DELETE]" + result[1];
                            else
                                e.Result = result[1];

                        }
                    }
                }
                else
                {
                    e.Result = "valid";
                }
            }
            else
            {
                e.Result = "valid";
            }

        }
        protected void CriarDirContratos(object sender, EventArgs args)
        {
            string sqlInsertDir = "INSERT INTO FILEOPOP (OPIDCONT,FILENAME,FILEPATH) " +
                                                "VALUES(" + hfOPIDCONT.Value + ", 'Dir', 'GED/" + hfOPIDCONT.Value + "')";
            string execucao = Consultas.InsertInto(str_conn, sqlInsertDir);
            if (execucao == "OK")
            {
                string dir = Server.MapPath("GED");
                if (Directory.Exists(Path.Combine(dir, hfOPIDCONT.Value)))
                    Directory.Delete(Path.Combine(dir, hfOPIDCONT.Value), true);
                Directory.CreateDirectory(Path.Combine(dir, hfOPIDCONT.Value));
                if (Directory.Exists(Path.Combine(dir, hfOPIDCONT.Value)))
                {

                    fileManager.Settings.RootFolder = @"~/GED/" + hfOPIDCONT.Value;
                    fileManager.Settings.InitialFolder = @"~/GED/" + hfOPIDCONT.Value;
                    fileManager.Visible = true;
                    lblFileManager.Visible = false;
                    btnCriarDir.Visible = false;
                    popupFileManager.ShowOnPageLoad = false;
                    popupFileManager.ShowOnPageLoad = true;
                }
            }
            else
                MsgException(execucao, 1);
        }

        protected void btnCriarDir_Load(object sender, EventArgs e)
        {
            Button obj = (Button)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";

        }
        protected void popupBasesAlterar_Load(object sender, EventArgs e)
        {

        }
    }
}