using DataBase;
using DevExpress.Web;
using DevExpress.XtraCharts;
using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Indice1 : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string perfil;
        public static bool AcessoInternet;
        protected void Page_Init(object sender, EventArgs e)
        {
            AcessoInternet = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["AcessoInternet"]);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Title = hfTituloPag.Value;
            try
            {
                lang = Session["langSession"].ToString();
            }
            catch
            {
                lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
            }
            gridCotacao.ForceDataRowType(typeof(System.Data.DataRow));
            if (!IsPostBack)
            {
                multiviewCotacoes.SetActiveView(this.vw_oficial);
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                if (AcessoInternet)
                {
                    //pnlBotoes.Visible = false;
                }
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
                string query = "WITH n(tvidestr) AS  " +
                               "(SELECT tvidestr " +
                                "FROM tvestrut " +
                               " WHERE tvidestr = 28302 " +
                                    " UNION ALL " +
                                "SELECT nplus1.tvidestr " +
                                "FROM tvestrut as nplus1, n " +
                               "WHERE n.tvidestr = nplus1.tvcdpaie) " +
                            "SELECT I.IEIDINEC,I.IENMINEC,I.IEINFLAG FROM n,IEINDECO I " +
                            "WHERE I.IEINFLAG = 1 AND I.TVIDESTR = n.tvidestr " +
                            " union all " +
                            "select I.IEIDINEC,I.IENMINEC,I.IEINFLAG FROM IEINDECO I " +
                            "where I.IEINFLAG = 0 " +
                            "order by I.IEINFLAG";
                //using (var con = new OleDbConnection(str_conn))
                //{
                //    con.Open();
                //    using (var cmd = new OleDbCommand(query, con))
                //    {
                //        dropListagemIndices.TextField = "IENMINEC";
                //        dropListagemIndices.ValueField = "IEIDINEC";
                //        dropListagemIndices.DataSource = cmd.ExecuteReader();
                //        dropListagemIndices.DataBind();
                //        dropListagemIndices.Items.Insert(0, new DevExpress.Web.ListEditItem("   ", "0"));
                //        dropListagemIndices.SelectedIndex = 0;
                //    }
                //}
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
            dropListagemIndices.DataBind();
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
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
        protected void dropListagemIndices_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropListagemIndices.SelectedItem != null)
            {
                string query = "SELECT I.IEIDINEC Cod, I.IESGINEC Sig, I.IENMINEC Descr, " +
                                   "Case I.IETPFREQ when 'D' then 'Diário' when 'M' then 'Mensal' end Freq, I.IETPFREQ, " +
                                   "Case I.IETPINDC when 'I' then 'Indexador' when 'T' then 'Taxa' when 'M' then 'Paridade Moeda' when 'F' then 'Futuro Bolsa' when 'P' then 'PUT Bolsa' when 'C' then 'CALL Bolsa' end Tipo, " +
                                   "I.IETPINDC, I.IETPDIVU, I.IESGBCAS Rot, I.IEIDMOOR,O.IESGBCAS Orig, I.IEIDMODE,D.IESGBCAS Cota, " +
                                    "I.IETPSITU,I.IEINFLAG,I.IEININTE,I.IECDBAND " +
                             "FROM IEINDECO I " +
                              "LEFT OUTER JOIN IEINDECO O ON(I.IEIDMOOR = O.IEIDINEC) " +
                              "LEFT OUTER JOIN IEINDECO D ON(I.IEIDMODE = D.IEIDINEC) " +
                            "WHERE I.IETPINDC NOT IN('U', 'N', 'F', 'P', 'C') " +
                              "AND I.IEIDINEC = " + dropListagemIndices.Value + " ";

                string[] result = Consultas.Consulta(str_conn, query, 17);
                if (result.Length > 0)
                {
                    hfCodIndice.Value = result[0];
                    txtDescri.Text = result[2];
                    txtSig.Text = result[1];
                    txtRot.Text = result[8];
                    //dropMoedaOrig.SelectedValue = result[9];
                    //dropMoedaCota.SelectedValue = result[11];
                    dropTipoIndic.Value = result[6];
                    dropFreqIndic.Value = result[4];
                    dropModelo.Value = result[14];
                    dropValor.Value = result[16];
                    txtFeeder.Text = result[15];
                    ASPxCheckBox1.ClientEnabled = true;
                    if (result[14] == "0")
                    {
                        gridCotacao.SettingsDataSecurity.AllowInsert = perfil == "1";
                        gridCotacao.SettingsDataSecurity.AllowEdit = perfil == "1";
                        gridCotacao.SettingsDataSecurity.AllowDelete = perfil == "1";
                        btnAlterar.Enabled = perfil == "1";
                        btnExcluir.Enabled = perfil == "1";
                    }
                    else if (result[14] == "1")
                    {
                        gridCotacao.SettingsDataSecurity.AllowInsert = perfil != "3";
                        gridCotacao.SettingsDataSecurity.AllowEdit = perfil != "3";
                        gridCotacao.SettingsDataSecurity.AllowDelete = perfil != "3";
                        btnAlterar.Enabled = perfil != "3";
                        btnExcluir.Enabled = perfil != "3";
                    }
                    gridCotacaoPrevisao.SettingsDataSecurity.AllowInsert = perfil != "3";
                    gridCotacaoPrevisao.SettingsDataSecurity.AllowEdit = perfil != "3";
                    gridCotacaoPrevisao.SettingsDataSecurity.AllowDelete = perfil != "3";
                    AtualizaGrafico(dropListagemIndices.Value.ToString());
                }
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="flag">0=Inserir / 1=Alterar / 2 = Excluir</param>
        protected void CamposHabilitados(int flag)
        {
            switch (flag)
            {
                case 0://Inserir
                    btnAlterar.Enabled = false;
                    btnExcluir.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    txtDescri.Text = "";
                    txtDescri.Enabled = true;
                    txtSig.Text = "";
                    txtSig.Enabled = true;
                    txtRot.Text = "";
                    txtRot.Enabled = true;
                    //dropMoedaOrig.SelectedIndex = 0;
                    //dropMoedaOrig.Enabled = true;
                    //dropMoedaCota.SelectedIndex = 0;
                    //dropMoedaCota.Enabled = true;
                    txtDescri.Enabled = true;
                    dropTipoIndic.Value = "0";
                    dropTipoIndic.Enabled = true;
                    dropFreqIndic.Value = "0";
                    dropFreqIndic.Enabled = true;
                    dropListagemIndices.Enabled = false;
                    btnOK.Enabled = true;
                    reqDescri.Enabled = true;
                    reqFreqIndic.Enabled = true;
                    //reqMoedaCota.Enabled = true;
                    //reqMoedaOrig.Enabled = true;
                    //reqRot.Enabled = true;
                    reqSig.Enabled = true;
                    reqTipoIndic.Enabled = true;
                    break;
                case 1://Alterar
                    txtDescri.Enabled = true;
                    txtSig.Enabled = true;
                    txtRot.Enabled = true;
                    //dropMoedaOrig.Enabled = true;
                    //dropMoedaCota.Enabled = true;
                    dropTipoIndic.Enabled = true;
                    dropFreqIndic.Enabled = true;
                    btnOK.Enabled = true;
                    btnInserir.Enabled = false;
                    btnAlterar.Enabled = false;
                    btnExcluir.Enabled = false;
                    btnCancelar.Enabled = true;
                    break;
                case 2://Excluir
                    txtDescri.Enabled = false;
                    txtSig.Enabled = false;
                    txtRot.Enabled = false;
                    //dropMoedaOrig.Enabled = false;
                    //dropMoedaCota.Enabled = false;
                    dropTipoIndic.Enabled = false;
                    dropFreqIndic.Enabled = false;
                    btnOK.Enabled = true;
                    btnInserir.Enabled = false;
                    btnAlterar.Enabled = false;
                    btnExcluir.Enabled = false;
                    btnCancelar.Enabled = true;
                    break;
            }
        }
        protected void btnInserir_Click(object sender, EventArgs e)
        {
            CamposHabilitados(0);
            hfOperacao.Value = "inserir";
            dropModelo.Value = "1";
        }
        protected void btnAlterar_Click(object sender, EventArgs e)
        {
            CamposHabilitados(1);
            reqDescri.Enabled = true;
            reqFreqIndic.Enabled = true;
            //reqMoedaCota.Enabled = true;
            //reqMoedaOrig.Enabled = true;
            //reqRot.Enabled = true;
            reqSig.Enabled = true;
            reqTipoIndic.Enabled = true;
            switch (dropTipoIndic.Value)
            {
                case "T": //Taxa
                    dropFreqIndic.Value = "D";
                    dropFreqIndic.Enabled = false;
                    //dropMoedaCota.SelectedValue = "1";
                    //dropMoedaCota.Enabled = false;
                    //dropMoedaOrig.SelectedValue = "1";
                    //dropMoedaOrig.Enabled = false;
                    break;
                case "I": //Indexador
                    dropFreqIndic.Value = "D";
                    dropFreqIndic.Enabled = true;
                    //dropMoedaCota.SelectedValue = "1";
                    //dropMoedaCota.Enabled = false;
                    //dropMoedaOrig.SelectedValue = "1";
                    //dropMoedaOrig.Enabled = false;
                    break;
                case "M": //Paridade Moeda
                    dropFreqIndic.Value = "D";
                    dropFreqIndic.Enabled = false;
                    //dropMoedaCota.SelectedValue = "1";
                    //dropMoedaCota.Enabled = true;
                    //dropMoedaOrig.SelectedValue = "1";
                    //dropMoedaOrig.Enabled = true;
                    break;
                case "F": //Futuro Bolsa
                    break;
                case "P": //PUT Bolsa
                    break;
                case "C": //CALL Bolsa
                    break;
            }
            hfOperacao.Value = "alterar";
            gridCotacao.DataBind();
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
                    Response.Redirect("Indice");
                    break;
            }

        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            switch (hfOperacao.Value)
            {
                case "alterar":
                    string upd = "update IEINDECO set IENMINEC='" + txtDescri.Text + "',IESGINEC='" + txtSig.Text + "',IESGBCAS='" + txtRot.Text + "',IETPINDC='" + dropTipoIndic.Value + "',IETPFREQ='" + dropFreqIndic.Value + "' where IEIDINEC=" + hfCodIndice.Value + "";
                    string exec = DataBase.Consultas.UpdtFrom(str_conn, upd);
                    if (exec == "OK")
                    {
                        MsgException("Índice " + txtDescri.Text + " alterado com sucesso!", 3, currentPage);
                    }
                    else
                    {
                        MsgException(exec, 1, "");
                    }
                    break;
                case "inserir":
                    int seq = Consultas.SeqPKTabelas(str_conn, "select max(IEIDINEC) from IEINDECO");
                    if (seq != 0)
                    {
                        string isrt = "insert into IEINDECO (IEIDINEC,IESGINEC,IENMINEC,IETPFREQ,IETPINDC,IESGBCAS,IEINFLAG,TVIDESTR) values (" + seq + ",'" + txtSig.Text + "','" + txtDescri.Text + "','" + dropFreqIndic.Value + "','" + dropTipoIndic.Value + "','" + txtRot.Text + "',1," + hfDropEstr.Value + ")";
                        string insert = Consultas.InsertInto(str_conn, isrt);
                        if (insert == "OK")
                        {
                            txtDescri.Enabled = false;
                            txtRot.Enabled = false;
                            txtSig.Enabled = false;
                            dropFreqIndic.Enabled = false;
                            dropTipoIndic.Enabled = false;
                            gridCotacao.DataBind();
                            hfCodIndice.Value = seq.ToString();
                            gridCotacao.SettingsDataSecurity.AllowInsert = true;
                            gridCotacao.SettingsDataSecurity.AllowEdit = true;
                            gridCotacao.SettingsDataSecurity.AllowDelete = true;
                        }
                        else
                        {
                            MsgException(insert, 1, "");
                        }
                    }
                    else
                    {
                        MsgException("Houve alguma falha no resgate do sequencial!", 0, "");
                    }
                    break;
                case "excluir":
                    string delete = Consultas.DeleteFrom(str_conn, "DELETE IEINDECO where IEIDINEC = " + hfCodIndice.Value + "");
                    string delete2 = Consultas.DeleteFrom(str_conn, "DELETE CVCOTIEC where IEIDINEC = " + hfCodIndice.Value + "");
                    if (delete == "OK")
                    {
                        MsgException("Índice " + txtDescri.Text + " excluído com sucesso!", 3, currentPage);
                    }
                    else
                    {
                        MsgException(delete, 1, "");
                    }
                    break;
            }
            btnOK.Enabled = false;
        }
        protected void btnExcluir_Click(object sender, EventArgs e)
        {
            CamposHabilitados(2);
            hfOperacao.Value = "excluir";
            gridCotacao.DataBind();
        }
        protected void gridCotacao_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            string result = string.Empty;
            e.Handled = true;
            foreach (var itens in e.UpdateValues)
            {
                string CVDTCOIE = itens.NewValues["CVDTCOIE"].ToString();
                string CVVLCOID = itens.NewValues["CVVLCOID"].ToString().Replace(",", ".");
                string sqlUpd = "UPDATE CVCOTIEC SET CVVLCOID=" + CVVLCOID + " WHERE IEIDINEC = " + hfCodIndice.Value + " AND CVDTCOIE='" + itens.OldValues["CVDTCOIE"] + "' and cvflplan=0";
                result = Consultas.UpdtFrom(str_conn, sqlUpd);
            }
            foreach (var itens in e.InsertValues)
            {
                //string codDt = lang=="en-US"?"101":"103";
                string CVDTCOIE = Convert.ToDateTime(itens.NewValues["CVDTCOIE"]).ToString("dd/MM/yyyy");
                string CVVLCOID = itens.NewValues["CVVLCOID"].ToString().Replace(",", ".");
                string sqlInsert = "INSERT INTO CVCOTIEC (IEIDINEC,CVDTCOIE,CVVLCOID,CVHRCOIE,cvflplan) VALUES (@IEIDINEC,convert(date,'@CVDTCOIE',103),@CVVLCOID,'@CVHRCOIE',0)";
                sqlInsert = sqlInsert.Replace("@IEIDINEC", hfCodIndice.Value);
                sqlInsert = sqlInsert.Replace("@CVDTCOIE", CVDTCOIE);
                sqlInsert = sqlInsert.Replace("@CVVLCOID", CVVLCOID);
                sqlInsert = sqlInsert.Replace("@CVHRCOIE", "00:00:00");
                result = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            }
            foreach (var itens in e.DeleteValues)
            {
                //string codDt = lang == "en-US" ? "101" : "103";
                string CVDTCOIE = Convert.ToDateTime(itens.Values["CVDTCOIE"]).ToString("dd/MM/yyyy");
                string CVVLCOID = itens.Values["CVVLCOID"].ToString().Replace(",", ".");
                string sqlDelete = "DELETE CVCOTIEC WHERE IEIDINEC = @IEIDINEC  AND CVDTCOIE=convert(date,'@CVDTCOIE',103) and cvflplan=0";
                sqlDelete = sqlDelete.Replace("@IEIDINEC", hfCodIndice.Value);
                sqlDelete = sqlDelete.Replace("@CVDTCOIE", CVDTCOIE);
                result = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
            }
            if (hfOperacao.Value == "inserir")
            {
                MsgException("Cotação para " + txtDescri.Text + " inserido com sucesso!", 3, currentPage);
            }
            gridCotacao.DataBind();
        }
        protected void dropTipoIndic_SelectedIndexChanged1(object sender, EventArgs e)
        {
            switch (dropTipoIndic.Value)
            {
                case "T": //Taxa
                    dropFreqIndic.Value = "D";
                    dropFreqIndic.Enabled = false;
                    //dropMoedaCota.SelectedValue = "1";
                    //dropMoedaCota.Enabled = false;
                    //dropMoedaOrig.SelectedValue = "1";
                    //dropMoedaOrig.Enabled = false;
                    break;
                case "I": //Indexador
                    dropFreqIndic.Value = "D";
                    dropFreqIndic.Enabled = true;
                    //dropMoedaCota.SelectedValue = "1";
                    //dropMoedaCota.Enabled = false;
                    //dropMoedaOrig.SelectedValue = "1";
                    //dropMoedaOrig.Enabled = false;
                    break;
                case "M": //Paridade Moeda
                    dropFreqIndic.Value = "D";
                    dropFreqIndic.Enabled = false;
                    //dropMoedaCota.SelectedValue = "1";
                    //dropMoedaCota.Enabled = true;
                    //dropMoedaOrig.SelectedValue = "1";
                    //dropMoedaOrig.Enabled = true;
                    break;
                case "F": //Futuro Bolsa
                    break;
                case "P": //PUT Bolsa
                    break;
                case "C": //CALL Bolsa
                    break;
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
            dropListagemIndices.Enabled = true;
        }
        protected void btnInserir_Load(object sender, EventArgs e)
        {
            ASPxButton obj = (ASPxButton)sender;
            obj.Enabled = perfil != "3";
        }
        protected void btnExcluir_Load(object sender, EventArgs e)
        {
            Button obj = (Button)sender;
            obj.Enabled = perfil == "1";
        }
        protected void btnAlterar_Load(object sender, EventArgs e)
        {
            Button obj = (Button)sender;
            obj.Enabled = perfil != "3";
        }
        protected void ASPxCheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (ASPxCheckBox1.Checked)
                multiviewCotacoes.SetActiveView(this.vw_previsao);
            else
                multiviewCotacoes.SetActiveView(this.vw_oficial);
        }
        protected void gridCotacaoPrevisao_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            string result = string.Empty;
            e.Handled = true;
            foreach (var itens in e.UpdateValues)
            {
                string CVVLCOID = itens.NewValues["CVVLCOID"].ToString().Replace(",", ".");
                string sqlUpd = "UPDATE CVCOTIEC SET CVVLCOID=" + CVVLCOID + " WHERE IEIDINEC = " + hfCodIndice.Value + " AND CVDTCOIE=convert(date,'" + Convert.ToDateTime(itens.OldValues["CVDTCOIE"]).ToString("dd/MM/yyyy") + "',103) and cvflplan=1";
                result = Consultas.UpdtFrom(str_conn, sqlUpd);
            }
            foreach (var itens in e.InsertValues)
            {
                //string codDt = lang=="en-US"?"101":"103";
                string CVDTCOIE = Convert.ToDateTime(itens.NewValues["CVDTCOIE"]).ToString("dd/MM/yyyy");
                string CVVLCOID = itens.NewValues["CVVLCOID"].ToString().Replace(",", ".");
                string sqlInsert = "INSERT INTO CVCOTIEC (IEIDINEC,CVDTCOIE,CVVLCOID,CVHRCOIE,cvflplan) VALUES (@IEIDINEC,convert(date,'@CVDTCOIE',103),@CVVLCOID,'@CVHRCOIE',1)";
                sqlInsert = sqlInsert.Replace("@IEIDINEC", hfCodIndice.Value);
                sqlInsert = sqlInsert.Replace("@CVDTCOIE", CVDTCOIE);
                sqlInsert = sqlInsert.Replace("@CVVLCOID", CVVLCOID);
                sqlInsert = sqlInsert.Replace("@CVHRCOIE", "00:00:00");
                result = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            }
            foreach (var itens in e.DeleteValues)
            {
                //string codDt = lang == "en-US" ? "101" : "103";
                string CVDTCOIE = Convert.ToDateTime(itens.Values["CVDTCOIE"]).ToString("dd/MM/yyyy");
                string CVVLCOID = itens.Values["CVVLCOID"].ToString().Replace(",", ".");
                string sqlDelete = "DELETE CVCOTIEC WHERE IEIDINEC = @IEIDINEC  AND CVDTCOIE=convert(date,'@CVDTCOIE',103) and cvflplan=1";
                sqlDelete = sqlDelete.Replace("@IEIDINEC", hfCodIndice.Value);
                sqlDelete = sqlDelete.Replace("@CVDTCOIE", CVDTCOIE);
                result = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
            }
            if (hfOperacao.Value == "inserir")
            {
                MsgException("Cotação para " + txtDescri.Text + " inserido com sucesso!", 3, currentPage);
            }
            gridCotacaoPrevisao.DataBind();
        }
        protected void ASPxCheckBox1_Load(object sender, EventArgs e)
        {
            ASPxCheckBox obj = (ASPxCheckBox)sender;
            obj.Enabled = perfil != "3";
        }
        protected void AtualizaGrafico(string ieidinec)
        {
            string sqlCotacoes = "select t.* from (select top(90) cvdtcoie, cvvlcoid from cvcotiec where ieidinec = " + ieidinec + " and cvdtcoie >= DATEADD(YEAR,-1,GETDATE()) order by cvdtcoie desc) t order by 1";
            DataTable result = DataBase.Consultas.Consulta(str_conn, sqlCotacoes);
            Series serie = new Series("Histórico de cotações ", ViewType.Line);
            serie.ArgumentScaleType = ScaleType.Qualitative;
            ((PointSeriesView)serie.View).PointMarkerOptions.Size = 6;
            foreach (DataRow row in result.Rows)
            {
                serie.Points.Add(new SeriesPoint(Convert.ToDateTime(row[0].ToString()).ToShortDateString(), Math.Round(Convert.ToDecimal(row[1].ToString()), 4, MidpointRounding.AwayFromZero)));
            }
            chartCotacao.Series.Clear();
            chartCotacao.Series.Add(serie);
            //serie.Legend.Visibility = DevExpress.Utils.DefaultBoolean.False;
        }
    }
}