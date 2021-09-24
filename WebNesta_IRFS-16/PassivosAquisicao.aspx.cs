using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using DevExpress.Export;
using DevExpress.Utils;
using DevExpress.Web;
using DevExpress.Web.Internal;
using Newtonsoft.Json;
using WebNesta_IRFS_16.Utils;

namespace WebNesta_IRFS_16
{
    public partial class PassivosAquisicaoDevExpress : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string sgbd = System.Configuration.ConfigurationManager.AppSettings["sgbd"];
        public static string lang;
        public static string perfil;
        public static CultureInfo culture;
        public static void SetupGlobalGridViewBehavior(ASPxGridView gridView)
        {
            if (gridView == null)
                return;
            gridView.EnablePagingGestures = AutoBoolean.False;
            gridView.SettingsPager.EnableAdaptivity = true;
            gridView.Styles.Header.Wrap = DefaultBoolean.True;
            if (InjectGridNoWrapGroupPanelCssStyle(gridView.Page))
                gridView.Styles.GroupPanel.CssClass = "GridNoWrapGroupPanel";
        }
        static bool InjectGridNoWrapGroupPanelCssStyle(Page page)
        {
            HtmlHead header = (page != null && page.Header != null) ? page.Header : RenderUtils.FindHead(page);
            if (header != null)
            {
                header.Controls.Add(new LiteralControl()
                {
                    Text = "\r\n<style>.GridNoWrapGroupPanel td.dx-wrap { white-space: nowrap !important; }</style>\r\n"
                });
                return true;
            }
            return false;
        }
        protected void Page_Init(object sender, EventArgs e)
        {

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            
            //gridFluxoCaixa.DataBind();
            //gridContabil.DataBind();
            //gridExtratoFinanc.DataBind();            
            //ASPxGridView1.DataBind();
            //ASPxGridView2.DataBind();
            try
            {
                lang = Session["langSession"].ToString();
                culture = new CultureInfo(lang);
            }
            catch
            {
                lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
                culture = new CultureInfo(lang);
            }
            if (!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                MultiView1.ActiveViewIndex = 0;                
                pnlNavegacao.Visible = true;
                ASPxGridView1.FocusedRowIndex = -1;
                dropMultiView.SelectedIndex = 0;
                ASPxRadioButtonList1.SelectedIndex = 0;
                HttpCookie cookiePais = HttpContext.Current.Request.Cookies["PAIDPAIS"];
                if (cookiePais == null)
                    hfPaisUser.Value = "1";
                else
                    hfPaisUser.Value = cookiePais.Value;
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                string sqlContrato = "SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, IE.IENMINEC, OP.TVIDESTR,PR.prprodes, OP.OPCDAUXI " +
        "FROM OPCONTRA OP, " +
             "PRPRODUT PR, IEINDECO IE, " +
             "FOFORNEC FO, TVESTRUT TV " +
        "WHERE OP.PRTPIDOP IN(1, 7, 8, 17)   " +
                    "AND PR.IEIDINEC = IE.IEIDINEC " +
        "AND OP.PRPRODID = PR.PRPRODID " +
        "AND OP.FOIDFORN = FO.FOIDFORN " +
        "AND OP.TVIDESTR = TV.TVIDESTR " +
                    "AND OP.OPTPTPID not in (91,99) " +
"AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = '" + hfUser.Value + "') order by 1";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlContrato);
                Session["dtContrato"] = dt;
                ASPxGridView1.DataSource = dt;
                ASPxGridView1.DataBind();
                ASPxGridView2.DataSource = dt;
                ASPxGridView2.DataBind();

            }
            if(IsCallback||IsPostBack)
            {
                if(Session["dtFluxo"]!=null)
                {
                    DataTable dt = Session["dtFluxo"] as DataTable;
                    gridFluxoCaixa.DataSource = dt;
                    gridFluxoCaixa.DataBind();
                }
                else if(hfTabelaFluxo.Value!="" && hfOPIDCONT.Value!="")
                {
                    string novoSelect = "SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [" + hfTabelaFluxo.Value + "] WHERE ([OPIDCONT] = " + hfOPIDCONT.Value + ") ORDER BY [PHNRPARC], [PHDTEVEN]";
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, novoSelect);
                    Session["dtFluxo"] = dt;
                    gridFluxoCaixa.DataSource = dt;
                    gridFluxoCaixa.DataBind();
                }
                if (Session["dtExtrato"] != null)
                {
                    DataTable dt = Session["dtExtrato"] as DataTable;
                    gridExtratoFinanc.DataSource = dt;
                    gridExtratoFinanc.DataBind();
                }
                else if(hfTabelaExtrato.Value != "" && hfOPIDCONT.Value != "")
                {
                    string novoSelect = "SELECT T1.RZDTDATA, T2.MODSMODA RZDSHIST, T1.RZVLDEBI, " +
                    "T1.RZVLCRED, T1.RZVLSALD, T1.RZVLPRIN, T1.RZVLCOTA, T1.OPIDCONT " +
                    "FROM " + hfTabelaExtrato.Value + " T1, MODALIDA T2 " +
                    "WHERE T1.MOIDMODA = T2.MOIDMODA AND " +
                    "T2.MOTPIDCA <> 1 AND OPIDCONT = " + hfOPIDCONT.Value + " " +
                    "ORDER BY T1.RZDTDATA, T1.RZNRREGI";
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, novoSelect);
                    Session["dtExtrato"] = dt;
                    gridExtratoFinanc.DataSource = dt;
                    gridExtratoFinanc.DataBind();
                }
                if (Session["dtContab"] != null)
                {
                    DataTable dt = Session["dtContab"] as DataTable;
                    gridContabil.DataSource = dt;
                    gridContabil.DataBind();
                }
                else if (hfTabelaContab.Value != "" && hfOPIDCONT.Value != "")
                {
                    string novoSelect = "SELECT T1.LBDTLANC, T1.LBTPLANC, T2.PFCDPLNC, " +
                    "T2.PFDSPLNC, T3.MODSMODA, T1.LBVLLANC " +
                    "FROM " + hfTabelaContab.Value + " T1 " +
                    "LEFT OUTER JOIN PFPLNCTA T2 ON(T1.PFIDPLNC = T2.PFIDPLNC) " +
                    "INNER JOIN MODALIDA T3 ON(T1.MOIDMODA = T3.MOIDMODA) " +
                    "WHERE T1.MOIDMODA = T3.MOIDMODA " +
                    "AND T1.OPIDCONT = " + hfOPIDCONT.Value + " " +
                    "ORDER BY LBDTLANC, T3.MOIDMODA, T1.LBTPLANC, " +
                    "T2.PFCDPLNC";
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, novoSelect);
                    Session["dtContab"] = dt;
                    gridContabil.DataSource = dt;
                    gridContabil.DataBind();
                }
                if (Session["dtContrato"] != null)
                {
                    DataTable dt = Session["dtContrato"] as DataTable;
                    ASPxGridView1.DataSource = dt;
                    ASPxGridView1.DataBind();
                    ASPxGridView2.DataSource = dt;
                    ASPxGridView2.DataBind();
                }
                else
                {
                    string sqlContrato = "SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, IE.IENMINEC, OP.TVIDESTR,PR.prprodes, OP.OPCDAUXI " +
"FROM OPCONTRA OP, " +
"PRPRODUT PR, IEINDECO IE, " +
"FOFORNEC FO, TVESTRUT TV " +
"WHERE OP.PRTPIDOP IN(1, 7, 8, 17)   " +
    "AND PR.IEIDINEC = IE.IEIDINEC " +
"AND OP.PRPRODID = PR.PRPRODID " +
"AND OP.FOIDFORN = FO.FOIDFORN " +
"AND OP.TVIDESTR = TV.TVIDESTR " +
    "AND OP.OPTPTPID not in (99) " +
"AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = '" + hfUser.Value + "') order by 1";
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlContrato);
                    Session["dtContrato"] = dt;
                    ASPxGridView1.DataSource = dt;
                    ASPxGridView1.DataBind();
                    ASPxGridView2.DataSource = dt;
                    ASPxGridView2.DataBind();
                }
                if (Session["dtIntegra"] != null)
                {
                    DataTable dt = Session["dtIntegra"] as DataTable;
                    gridProcessaContabil.DataSource = dt;
                    gridProcessaContabil.DataBind();
                }
            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }

        protected void dropMultiView_SelectedIndexChanged(object sender, EventArgs e)
        {
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openLoading(); });", true);
            int index = 0;
            switch (dropMultiView.Value.ToString())
            {
                case "0": //Contratos
                    if(ASPxGridView1.VisibleRowCount==0)
                        ASPxGridView1.DataBind();
                    if(ASPxGridView2.VisibleRowCount==0)
                        ASPxGridView2.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    pnlRescisao.Visible = false;
                    pnlEncerraContab.Visible = false;
                    pnlRepactuacao.Visible = false;
                    pnlProcessoContabil.Visible = false;
                    index = 0;
                    break;
                case "1": //FluxoCaixa
                    string sqlFluxo = "SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [PHPLANIF] WHERE ([OPIDCONT] = " + hfOPIDCONT.Value + ") ORDER BY 1,4";
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlFluxo);
                    Session["dtFluxo"] = dt;
                    gridFluxoCaixa.DataSource = dt;
                    gridFluxoCaixa.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = true;
                    pnlRescisao.Visible = false;
                    pnlEncerraContab.Visible = false;
                    pnlRepactuacao.Visible = false;
                    pnlProcessoContabil.Visible = false;
                    index = 1;
                    break;
                case "2": //ExtratoFinanc
                    string sqlExtrato = "SELECT T1.RZDTDATA, T2.MODSMODA RZDSHIST, T1.RZVLDEBI, " +
       "T1.RZVLCRED, T1.RZVLSALD, T1.RZVLPRIN, T1.RZVLCOTA, T1.OPIDCONT " +
"FROM RZRAZCTB T1, MODALIDA T2 " +
"WHERE T1.MOIDMODA = T2.MOIDMODA AND " +
      "T2.MOTPIDCA <> 1 AND OPIDCONT = " + hfOPIDCONT.Value + " " +
  "ORDER BY T1.RZDTDATA, T1.RZNRREGI";
                    DataTable dt2 = DataBase.Consultas.Consulta(str_conn, sqlExtrato);
                    Session["dtExtrato"] = dt2;
                    gridExtratoFinanc.DataSource = dt2;
                    gridExtratoFinanc.DataBind();
                    string sqlFluxo2 = "SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [PHPLANIF] WHERE ([OPIDCONT] = " + hfOPIDCONT.Value + ") ORDER BY 1,4";
                    DataTable dt12 = DataBase.Consultas.Consulta(str_conn, sqlFluxo2);
                    Session["dtFluxo"] = dt12;
                    gridFluxoCaixa.DataSource = dt12;
                    gridFluxoCaixa.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = true;
                    pnlProcFluxo.Visible = false;
                    pnlRescisao.Visible = false;
                    pnlEncerraContab.Visible = false;
                    pnlRepactuacao.Visible = false;
                    pnlProcessoContabil.Visible = false;
                    index = 2;
                    break;
                case "3": //Contabil
                    string sqlContab = "SELECT T1.LBDTLANC, T1.LBTPLANC, T2.PFCDPLNC, " +
        "T2.PFDSPLNC, T3.MODSMODA, T1.LBVLLANC " +
        "FROM LBLCTCTB T1 " +
        "LEFT OUTER JOIN PFPLNCTA T2 ON(T1.PFIDPLNC = T2.PFIDPLNC) " +
        "INNER JOIN MODALIDA T3 ON(T1.MOIDMODA = T3.MOIDMODA) " +
        "WHERE T1.MOIDMODA = T3.MOIDMODA " +
        "AND T1.OPIDCONT = " + hfOPIDCONT.Value + " " +
        "ORDER BY LBDTLANC, T3.MOIDMODA, T1.LBTPLANC, " +
        "T2.PFCDPLNC";
                    DataTable dt3 = DataBase.Consultas.Consulta(str_conn, sqlContab);
                    Session["dtContab"] = dt3;
                    gridContabil.DataSource = dt3;
                    gridContabil.DataBind();
                    pnlProcContab.Visible = true;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    pnlRescisao.Visible = false;
                    pnlEncerraContab.Visible = false;
                    pnlRepactuacao.Visible = false;
                    pnlProcessoContabil.Visible = false;
                    index = 3;
                    break;
                case "4": //Rescisão
                    if (ASPxGridView1.VisibleRowCount == 0)
                        ASPxGridView1.DataBind();
                    if (ASPxGridView2.VisibleRowCount == 0)
                        ASPxGridView2.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    pnlRescisao.Visible = true;
                    pnlEncerraContab.Visible = false;
                    pnlRepactuacao.Visible = false;
                    pnlProcessoContabil.Visible = false;
                    index = 0;
                    break;
                case "5": //Repactuação
                    if (ASPxGridView1.VisibleRowCount == 0)
                        ASPxGridView1.DataBind();
                    if (ASPxGridView2.VisibleRowCount == 0)
                        ASPxGridView2.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    pnlRescisao.Visible = false;
                    pnlEncerraContab.Visible = false;
                    pnlRepactuacao.Visible = true;
                    pnlProcessoContabil.Visible = false;
                    index = 0;
                    break;
                case "6": //Encerramento
                    if (ASPxGridView1.VisibleRowCount == 0)
                        ASPxGridView1.DataBind();
                    if (ASPxGridView2.VisibleRowCount == 0)
                        ASPxGridView2.DataBind();
                    gridEncerramento.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    pnlRescisao.Visible = false;
                    pnlRepactuacao.Visible = false;
                    pnlEncerraContab.Visible = true;
                    btnEncerra.Enabled = true;
                    pnlProcessoContabil.Visible = false;
                    index = 6;
                    break;
                case "7": //Processo Contabil
                    gridProcessaContabil.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    pnlRescisao.Visible = false;
                    pnlRepactuacao.Visible = false;
                    pnlEncerraContab.Visible = false;
                    btnEncerra.Enabled = false;
                    pnlProcessoContabil.Visible = true;
                    index = 5;
                    break;
            }
            MultiView1.ActiveViewIndex = index;            
        }
        protected void ASPxRadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string value = ASPxRadioButtonList1.SelectedItem.Value.ToString();
            switch (value)
            {
                case "1": //Extrato
                    txtDataExtrato.Visible = true;
                    lblDataExtrato.Visible = true;
                    break;
                case "2": //Saldo
                    txtDataExtrato.Visible = false;
                    lblDataExtrato.Visible = false;
                    break;
            }
        }
        protected void btnProcessoContabil_Click(object sender, EventArgs e)
        {
            DateTime dtProcessoContabil = new DateTime(Convert.ToInt32(dateProcessoContabil.Text.Split('/')[1]),Convert.ToInt32(dateProcessoContabil.Text.Split('/')[0]),1);
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Processo Integração Contábil";
            string retorno = string.Empty;
            string[] param_dados = new string[3];
            if (ASPxCheckBox1.Checked)
            {
                var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                for (int i = 0; i < lista.Count; i++)
                {
                    DataBase.Consultas.Alteracao = "Geração Interface Contábil Contrato #ID: " + lista[i].ToString();
                    param_dados[0] = "@p_opidcont" + "#" + lista[i].ToString();
                    param_dados[1] = "@p_periodo#" + dtProcessoContabil.ToString("yyyy-MM-dd");
                    param_dados[2] = "@p_idioma#"+culture.ToString();
                    string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_GL_Integration", param_dados, "o_mensagem");
                    if (exec == "OK")
                        retorno += "Interface GL data: " + dtProcessoContabil.ToShortDateString() + " do opidcont : " + lista[i].ToString() + "<br/>";
                    else
                        retorno += exec;
                }
            }
            else
            {
                DataBase.Consultas.Alteracao = "Geração Interface Contábil Contrato #ID: " + hfOPIDCONT.Value;
                param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                param_dados[1] = "@p_periodo#" + dtProcessoContabil.ToString("yyyy-MM-dd");
                param_dados[2] = "@p_idioma#" + culture.ToString();
                string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_GL_Integration", param_dados, "o_mensagem");
                if (exec == "OK")
                    retorno = "Interface GL data: " + dtProcessoContabil.ToShortDateString() + " do opidcont : " + hfOPIDCONT.Value + "<br/>";
                else
                    retorno = exec;
            }
            MsgException(retorno, 2);
            gridProcessaContabil.DataBind();
        }
        protected void btnProcessoIntegrar_Click(object sender, EventArgs e)
        {
                DateTime dtProcessoContabil = new DateTime(Convert.ToInt32(dateProcessoContabil.Text.Split('/')[1]), Convert.ToInt32(dateProcessoContabil.Text.Split('/')[0]), 1);
                DataBase.Consultas.Acao = "Processamento";
                DataBase.Consultas.Resumo = "Integração Contábil";
                string retorno = string.Empty;
                if (ASPxCheckBox1.Checked)
                {
                    var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                    for (int i = 0; i < lista.Count; i++)
                    {
               
                        var result = DataBase.Consultas.Consulta(str_conn, "select INTEGRA_ATIVO,INTEGRA_USER,INTEGRA_PASS,INTEGRA_GL_URL from ITCCONFIG", 4);
                        switch (result[0])
                        {
                            case "1":
                                string dadosAPI = string.Format("Integração GL - API : Solicitação enviada para a URL {0}, com usuário {1} e senha {2}.", result[3], result[1], result[2]);
                                DataBase.Integra integra = new DataBase.Integra();
                                integra.urlAPI = result[3];
                                integra.userAPI = result[1];
                                integra.passAPI = result[2];
                                LogWriter log = new LogWriter(dadosAPI);
                                LogWriter log6 = new LogWriter("Solicitação para o OPIDCONT: "+ lista[i].ToString());
                            
                                IntegraCeA.Rootobject rootobject = new IntegraCeA.Rootobject() { mmyyyy = dateProcessoContabil.Text, opidcont = lista[i].ToString(), str_conn = str_conn };
                            if (rootobject.Existe())
                            {
                                rootobject.Get();
                                var serilaizeJson = JsonConvert.SerializeObject(rootobject.row, Formatting.Indented);
                                serilaizeJson = "{   \"row\": [" + serilaizeJson + "]}";
                                
                                try
                                {
                                    HttpStatusCode retornoPost = integra.PostRequest(serilaizeJson);
                                    //HttpStatusCode retornoPost = HttpStatusCode.OK;
                                    //integra.retornoAPI = "{\"row\": { " +
                                    //                        "\"id_processo\": \"NST0000120210800\", " +
                                    //                        "\"num_documento_sap\": \"017454185210002021\", " +
                                    //                        "\"msg_id\": \"\", " +
                                    //                        "\"msg_type\": \"\", " +
                                    //                        "\"msg_number\": \"666\", " +
                                    //                        "\"message\": \"Mensagem Erro Teste\"}}";
                                    if (retornoPost == HttpStatusCode.OK)
                                    {
                                        string logTexto = "\nRecebimento\n" + integra.retornoAPI;
                                        IntegraCeA.RootobjectRetorno rootobjectRetorno = JsonConvert.DeserializeObject<IntegraCeA.RootobjectRetorno>(integra.retornoAPI);

                                        if (rootobjectRetorno.row.msg_number == "000")
                                        {
                                            string sqlRetorno = "update nesta_ws_Acc_Statement set transaction_flag=1,transaction_error_logs=NULL, document_id='" + rootobjectRetorno.row.num_documento_sap + "', transaction_return_timestamp=convert(datetime,'" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "',103)  where transaction_flag=0 and document_key='" + rootobjectRetorno.row.id_processo + "'";
                                            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlRetorno);
                                        }
                                        else
                                        {
                                            string sqlRetorno = "update nesta_ws_Acc_Statement set transaction_flag=2,transaction_error_logs='" + rootobjectRetorno.row.message + "', transaction_return_timestamp=convert(datetime,'" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "',103)  where transaction_flag=0 and document_key='" + rootobjectRetorno.row.id_processo + "'";
                                            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlRetorno);
                                        }

                                    }
                                    else
                                    {
                                        retorno += "Erro " + integra.retornoAPI + " para a integração solicitada.<br/>";
                                        LogWriter log3 = new LogWriter("Envio: \n" + serilaizeJson);
                                        LogWriter log2 = new LogWriter(integra.retornoAPI);
                                    }
                                }
                                catch (Exception ex)
                                {
                                    if (!string.IsNullOrEmpty(serilaizeJson))
                                    {
                                        LogWriter log8 = new LogWriter("Envio: \n" + serilaizeJson);
                                    }
                                    retorno += "Erro: " + ex.Message;
                                    LogWriter log4 = new LogWriter(ex.Message);
                                }
                            }
                            else
                            {
                                LogWriter log7 = new LogWriter("Não foi possível encontrar dados para integração do contrato " + lista[i].ToString() + "período "+ dateProcessoContabil.Text);
                            }
                                break;
                            }
                        }
                }
                else
                {
                    string sql = "select count(*)  " +
            "from nesta_ws_Acc_Statement t1 " +
               ", (select internal_id, year_month, max(version) as version from nesta_ws_Acc_Statement " +
                  "where internal_id = " + hfOPIDCONT.Value + " " +
                    "group by internal_id, year_month) t2 " +
            "where t1.internal_id = " + hfOPIDCONT.Value + " " +
              "and t1.internal_id = t2.internal_id " +
              "and t1.version = t2.version " +
              "and t1.event between convert(date, '01/" + dateProcessoContabil.Text + "', 103) and DATEADD(Day,-1, DATEADD(MONTH,1, convert(date,'01/" + dateProcessoContabil.Text + "',103)))";
                    bool existe = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sql, 1)[0]) > 0;
                    if (existe)
                    {
                        var result = DataBase.Consultas.Consulta(str_conn, "select INTEGRA_ATIVO,INTEGRA_USER,INTEGRA_PASS,INTEGRA_GL_URL from ITCCONFIG", 4);
                        switch (result[0])
                        {
                            case "1":
                                string dadosAPI = string.Format("Integração GL - API : Solicitação enviada para a URL {0}, com usuário {1} e senha {2}.", result[3],result[1],result[2]);
                                DataBase.Integra integra = new DataBase.Integra();
                                integra.urlAPI = result[3];
                                integra.userAPI = result[1];
                                integra.passAPI = result[2];
                                LogWriter log = new LogWriter(dadosAPI);
                                IntegraCeA.Rootobject rootobject = new IntegraCeA.Rootobject() { mmyyyy = dateProcessoContabil.Text, opidcont = hfOPIDCONT.Value, str_conn = str_conn };

                                rootobject.Get();
                                var serilaizeJson = JsonConvert.SerializeObject(rootobject.row, Formatting.Indented);
                                serilaizeJson = "{   \"row\": [" + serilaizeJson + "]}";
                                LogWriter log3 = new LogWriter("Envio: \n" + serilaizeJson);
                            try
                            {
                                HttpStatusCode retornoPost = integra.PostRequest(serilaizeJson);
                                //HttpStatusCode retornoPost = HttpStatusCode.OK;
                                //integra.retornoAPI = "{\"row\": { " +
                                //                        "\"id_processo\": \"NST0000120210800\", " +
                                //                        "\"num_documento_sap\": \"017454185210002021\", " +
                                //                        "\"msg_id\": \"\", " +
                                //                        "\"msg_type\": \"\", " +
                                //                        "\"msg_number\": \"666\", " +
                                //                        "\"message\": \"Mensagem Erro Teste\"}}";
                                if (retornoPost == HttpStatusCode.OK)
                                {
                                    string logTexto = "\nRecebimento\n" + integra.retornoAPI;
                                    IntegraCeA.RootobjectRetorno rootobjectRetorno = JsonConvert.DeserializeObject<IntegraCeA.RootobjectRetorno>(integra.retornoAPI);
                                    if (rootobjectRetorno.row.msg_number == "000")
                                    {
                                        string sqlRetorno = "update nesta_ws_Acc_Statement set transaction_flag=1,transaction_error_logs=NULL, document_id='" + rootobjectRetorno.row.num_documento_sap + "', transaction_return_timestamp=convert(datetime,'" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "',103)  where transaction_flag=0 and document_key='" + rootobjectRetorno.row.id_processo + "'";
                                        string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlRetorno);
                                    }
                                    else
                                    {
                                        string sqlRetorno = "update nesta_ws_Acc_Statement set transaction_flag=2,transaction_error_logs='" + rootobjectRetorno.row.message + "', transaction_return_timestamp=convert(datetime,'" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "',103)  where transaction_flag=0 and document_key='" + rootobjectRetorno.row.id_processo + "'";
                                        string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlRetorno);
                                    }
                                    LogWriter log1 = new LogWriter(logTexto);
                                }
                                else
                                {
                                    retorno += "Erro " + integra.retornoAPI + " para a integração solicitada.<br/>";
                                    LogWriter log2 = new LogWriter(integra.retornoAPI);
                                }
                            }
                            catch(Exception ex)
                            {
                                retorno = "Erro: " + ex.Message;
                                LogWriter log4 = new LogWriter(ex.Message);
                            }
                                break;
                        }
                        retorno += "Solicitação de Integração Contábil para a data: " + dtProcessoContabil.ToShortDateString() + " do opidcont : " + hfOPIDCONT.Value + "<br/>";
                    }
                    string sqlQuery = "select t1.*  " +
            "from nesta_ws_Acc_Statement t1 " +
               ", (select internal_id, year_month, max(version) as version from nesta_ws_Acc_Statement " +
                  "where internal_id = " + hfOPIDCONT.Value + " " +
                    "group by internal_id, year_month) t2 " +
            "where t1.internal_id = " + hfOPIDCONT.Value + " " +
              "and t1.internal_id = t2.internal_id " +
              "and t1.version = t2.version " +
              "and t1.event between convert(date, '01/" + dateProcessoContabil.Text + "', 103) and DATEADD(Day,-1, DATEADD(MONTH,1, convert(date,'01/" + dateProcessoContabil.Text + "',103))) " +
            "order by t1.year_month";
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlQuery);
                    Session["dtIntegra"] = dt;
                    gridProcessaContabil.DataSource = dt;
                    gridProcessaContabil.DataBind();
                }
            MsgException(retorno, 2);
            //btnUpdatePanel2_Click(sender, e);
        }
        protected void btnProcExtrato_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Extrato Financeiro";
            if (ASPxCheckBox1.Checked)
            {
                if (checkFiltroExtrato.SelectedItems.Count > 0)
                {
                    CultureInfo culture = new CultureInfo(lang);
                    int validOK = 0;
                    int validERRO = 0;
                    string textOK = string.Empty, textErro = string.Empty;
                    var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                    for (int i = 0; i < lista.Count; i++)
                    {
                        string value = ASPxRadioButtonList1.SelectedItem.Value.ToString();
                        string[] param_dados = new string[5];
                        string retorno;
                        int[] param_Filtro = new int[checkFiltroExtrato.SelectedItems.Count];
                        for (int h = 0; h < param_Filtro.Length; h++)
                        {
                            switch (checkFiltroExtrato.SelectedItems[h].Value.ToString())
                            {
                                case "RZRAZCTB":
                                    param_Filtro[h] = 200;
                                    break;
                                case "RZRAZCTB_NOMINAL":
                                    param_Filtro[h] = 201;
                                    break;
                                case "RZRAZCTB_INFLACAO":
                                    param_Filtro[h] = 202;
                                    break;
                                case "RZRAZCTB_MOEDA":
                                    param_Filtro[h] = 203;
                                    break;
                                case "RZRAZCTB_USGAAP":
                                    param_Filtro[h] = 204;
                                    break;
                            }
                        }
                        for (int j = 0; j < param_Filtro.Length; j++)
                        {
                            switch (value)
                            {
                                case "1": //Extrato        
                                    if (txtDataExtrato.Text == string.Empty || txtDataExtrato.Text == "01/01/0100")
                                    {
                                        DataBase.Consultas.Alteracao = "Processamento Extrato Financeiro Contrato #ID: " + lista[i].ToString();
                                        param_dados[0] = "@p_opidcont" + "#" + lista[i].ToString();
                                        param_dados[1] = "@p_TipoExtrato#" + param_Filtro[j];
                                        param_dados[2] = "@p_Tipo#3";
                                        param_dados[3] = "@p_DtLimite#";
                                        param_dados[4] = "@p_GravaLog#0";
                                        retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                                        if (retorno == "OK")
                                        {
                                            validOK = validOK + 1;
                                            textOK += lista[i].ToString() + ",";

                                        }
                                        else
                                        {
                                            validERRO = validERRO + 1;
                                            textErro += "<br />#ID:" + lista[i].ToString() + ":" + retorno + ",";
                                        }
                                    }
                                    else
                                    {
                                        try
                                        {
                                            DataBase.Consultas.Alteracao = "Processamento Extrato Financeiro Contrato #ID: " + lista[i].ToString();
                                            param_dados[0] = "@p_opidcont" + "#" + lista[i].ToString();
                                            param_dados[1] = "@p_TipoExtrato#" + param_Filtro[j];
                                            param_dados[2] = "@p_Tipo#2";
                                            param_dados[3] = "@p_DtLimite#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Day);
                                            param_dados[4] = "@p_GravaLog#0";
                                            retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                                            if (retorno == "OK")
                                            {
                                                validOK = validOK + 1;
                                                textOK += lista[i].ToString() + ",";

                                            }
                                            else
                                            {
                                                validERRO = validERRO + 1;
                                                textErro += "<br />#ID:" + lista[i].ToString() + ":" + retorno + ",";
                                            }
                                        }
                                        catch (Exception ex)
                                        {
                                            MsgException(hfMsgException.Value + ex.Message.ToString(), 1);
                                        }
                                    }
                                    break;
                                case "2": //Saldo
                                    DataBase.Consultas.Alteracao = "Processamento Extrato Financeiro Contrato #ID: " + lista[i].ToString();
                                    param_dados[0] = "@p_opidcont" + "#" + lista[i].ToString();
                                    param_dados[1] = "@p_TipoExtrato#" + param_Filtro[j];
                                    param_dados[2] = "@p_Tipo#1";
                                    param_dados[3] = "@p_DtLimite#";
                                    param_dados[4] = "@p_GravaLog#0";
                                    retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                                    if (retorno == "OK")
                                    {
                                        validOK = validOK + 1;
                                        textOK += lista[i].ToString() + ",";

                                    }
                                    else
                                    {
                                        validERRO = validERRO + 1;
                                        textErro += "<br />#ID:" + lista[i].ToString() + ":" + retorno + ",";
                                    }

                                    break;
                            }
                        }
                    }
                    if (textOK.Length != 0)
                        textOK = textOK.Substring(0, textOK.Length - 1);
                    if (textErro.Length != 0)
                        textErro = textErro.Substring(0, textErro.Length - 1);
                    string erro = validERRO == 0 ? "" : hfMsgException.Value + textErro;
                    string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
                    MsgException(ok + "<br />" + erro, 2);
                }
                else
                    MsgException("Filtro de processamento não selecionado.", 2);
            }
            else
            {
                CultureInfo culture = new CultureInfo(lang);
                string value = ASPxRadioButtonList1.SelectedItem.Value.ToString();
                string[] param_dados = new string[5];
                string retorno;
                int param = 0;
                switch (radioFiltroExtrato.SelectedItem.Value.ToString())
                {
                    case "RZRAZCTB":
                        param = 200;
                        break;
                    case "RZRAZCTB_NOMINAL":
                        param = 201;
                        break;
                    case "RZRAZCTB_INFLACAO":
                        param = 202;
                        break;
                    case "RZRAZCTB_MOEDA":
                        param = 203;
                        break;
                    case "RZRAZCTB_USGAAP":
                        param = 204;
                        break;
                }
                switch (value)
                {
                    case "1": //Extrato        
                        if (txtDataExtrato.Text == string.Empty || txtDataExtrato.Text == "01/01/0100")
                        {
                            DataBase.Consultas.Alteracao = "Processamento Extrato Financeiro Contrato #ID: " + hfOPIDCONT.Value;
                            param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                            param_dados[1] = "@p_TipoExtrato#"+param;
                            param_dados[2] = "@p_Tipo#3";
                            param_dados[3] = "@p_DtLimite#";
                            param_dados[4] = "@p_GravaLog#0";
                            retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                            if (retorno == "OK")
                                MsgException(hfMsgSuccess.Value, 2);
                            else
                                MsgException(hfMsgException.Value+retorno, 1);
                        }
                        else
                        {
                            try
                            {
                                DataBase.Consultas.Alteracao = "Processamento Extrato Financeiro Contrato #ID: " + hfOPIDCONT.Value;
                                param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                                param_dados[1] = "@p_TipoExtrato#"+param;
                                param_dados[2] = "@p_Tipo#2";
                                param_dados[3] = "@p_DtLimite#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Day);
                                param_dados[4] = "@p_GravaLog#0";
                                retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                                if (retorno == "OK")
                                    MsgException(hfMsgSuccess.Value, 2);
                                else
                                    MsgException(hfMsgException.Value+retorno, 1);
                            }
                            catch (Exception ex)
                            {
                                MsgException(hfMsgException.Value + ex.Message.ToString(), 1);
                            }
                        }
                        break;
                    case "2": //Saldo
                        DataBase.Consultas.Alteracao = "Processamento Extrato Financeiro Contrato #ID: " + hfOPIDCONT.Value;
                        param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                        param_dados[1] = "@p_TipoExtrato#"+param;
                        param_dados[2] = "@p_Tipo#1";
                        param_dados[3] = "@p_DtLimite#NULL";
                        param_dados[4] = "@p_GravaLog#0";
                        retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                        if (retorno == "OK")
                            MsgException(hfMsgSuccess.Value, 2);
                        else
                            MsgException(hfMsgException.Value+retorno, 1);

                        break;
                }
                string sqlContab = "SELECT T1.RZDTDATA, T2.MODSMODA RZDSHIST, T1.RZVLDEBI, " +
"T1.RZVLCRED, T1.RZVLSALD, T1.RZVLPRIN, T1.RZVLCOTA, T1.OPIDCONT " +
"FROM RZRAZCTB T1, MODALIDA T2 " +
"WHERE T1.MOIDMODA = T2.MOIDMODA AND " +
"T2.MOTPIDCA <> 1 AND OPIDCONT = " + hfOPIDCONT.Value + " " +
"ORDER BY T1.RZDTDATA, T1.RZNRREGI";
                DataTable dt2 = DataBase.Consultas.Consulta(str_conn, sqlContab);
                Session["dtExtrato"] = dt2;
                gridExtratoFinanc.DataSource = dt2;
                gridExtratoFinanc.DataBind();
                string sqlFluxo = "SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [PHPLANIF] WHERE ([OPIDCONT] = " + hfOPIDCONT.Value + ") ORDER BY 1,4";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlFluxo);
                Session["dtFluxo"] = dt;
                gridFluxoCaixa.DataSource = dt;
                gridFluxoCaixa.DataBind();
            }
            
            radioFiltroExtrato.SelectedIndex = 0;
        }
        protected void btnProcContab_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Contábil";
            if (ASPxCheckBox1.Checked)
            {
                if (checkFiltroContabil.SelectedItems.Count > 0)
                {
                    CultureInfo culture = new CultureInfo(lang);
                    try
                    {
                        int validOK = 0;
                        int validERRO = 0;
                        string textOK = string.Empty, textErro = string.Empty;
                        var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                        for (int i = 0; i < lista.Count; i++)
                        {
                            int[] param_Filtro = new int[checkFiltroContabil.SelectedItems.Count];
                            for (int h = 0; h < param_Filtro.Length; h++)
                            {
                                switch (checkFiltroContabil.SelectedItems[h].Value.ToString())
                                {
                                    case "LBLCTCTB":
                                        param_Filtro[h] = 300;
                                        break;
                                    case "LBLCTCTB_NOMINAL":
                                        param_Filtro[h] = 301;
                                        break;
                                    case "LBLCTCTB_INFLACAO":
                                        param_Filtro[h] = 302;
                                        break;
                                    case "LBLCTCTB_MOEDA":
                                        param_Filtro[h] = 303;
                                        break;
                                    case "LBLCTCTB_USGAAP":
                                        param_Filtro[h] = 304;
                                        break;
                                }
                            }
                            for (int j = 0; j < param_Filtro.Length; j++)
                            {
                                string[] param_dados = new string[4];
                                string opidcont = lista[i].ToString();
                                DataBase.Consultas.Alteracao = "Processamento Contabil Contrato #ID: " + opidcont;
                                param_dados[0] = "@p_opidcont" + "#" + opidcont;
                                param_dados[1] = "@p_TipoContabil" + "#" + param_Filtro[j];
                                if (txtDataConta.Text == string.Empty || txtDataConta.Text == "01/01/0100")
                                    param_dados[2] = "@p_DtLimite#NULL";
                                else
                                    param_dados[2] = "@p_DtLimite#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Day);
                                param_dados[3] = "@p_GravaLog#0";
                                string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Accounting_Statement", param_dados, "p_mensagem");
                                if (exec == "OK")
                                {
                                    validOK = validOK + 1;
                                    textOK += opidcont + ",";

                                }
                                else
                                {
                                    validERRO = validERRO + 1;
                                    textErro += "<br />#ID:" + opidcont + ":" + exec + ",";
                                }
                            }
                        }
                        if (textOK.Length != 0)
                            textOK = textOK.Substring(0, textOK.Length - 1);
                        if (textErro.Length != 0)
                            textErro = textErro.Substring(0, textErro.Length - 1);
                        string erro = validERRO == 0 ? "" : hfMsgException.Value + textErro;
                        string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
                        MsgException(ok + "<br />" + erro, 2);
                    }
                    catch (Exception ex)
                    {
                        MsgException(hfMsgException.Value + ex.Message.ToString(), 1);
                    }

                }
                else
                    MsgException("Filtro de processamento não selecionado.", 2);
            }
            else
            {
                CultureInfo culture = new CultureInfo(lang);
                try
                {
                    int param = 0;
                    switch (radioFiltroContab.SelectedItem.Value.ToString())
                    {
                        case "LBLCTCTB":
                            param = 300;
                            break;
                        case "LBLCTCTB_NOMINAL":
                            param = 301;
                            break;
                        case "LBLCTCTB_INFLACAO":
                            param = 302;
                            break;
                        case "LBLCTCTB_MOEDA":
                            param = 303;
                            break;
                        case "LBLCTCTB_USGAAP":
                            param = 304;
                            break;
                    }
                    string[] param_dados = new string[4];
                    string retorno;
                    DataBase.Consultas.Alteracao = "Processamento Contabil Contrato #ID: " + hfOPIDCONT.Value;
                    param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                    param_dados[1] = "@p_TipoContabil" + "#"+param;
                    if (txtDataConta.Text == string.Empty || txtDataConta.Text == "01/01/0100")
                    {
                        param_dados[2] = "@p_DtLimite#NULL";
                    }
                    else
                    {
                        param_dados[2] = "@p_DtLimite#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Day);
                    }
                    param_dados[3] = "@p_GravaLog#0";
                    retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Accounting_Statement", param_dados, "p_mensagem");
                    if (retorno == "OK")
                        MsgException(hfMsgSuccess.Value, 2);
                    else
                        MsgException(hfMsgException.Value+retorno, 1);
                }
                catch (Exception ex)
                {
                    MsgException(hfMsgException.Value + ex.Message.ToString(), 1);
                }
                string sqlExtrato = "SELECT T1.LBDTLANC, T1.LBTPLANC, T2.PFCDPLNC, " +
        "T2.PFDSPLNC, T3.MODSMODA, T1.LBVLLANC " +
        "FROM LBLCTCTB T1 " +
        "LEFT OUTER JOIN PFPLNCTA T2 ON(T1.PFIDPLNC = T2.PFIDPLNC) " +
        "INNER JOIN MODALIDA T3 ON(T1.MOIDMODA = T3.MOIDMODA) " +
        "WHERE T1.MOIDMODA = T3.MOIDMODA " +
        "AND T1.OPIDCONT = " + hfOPIDCONT.Value + " " +
        "ORDER BY LBDTLANC, T3.MOIDMODA, T1.LBTPLANC, " +
        "T2.PFCDPLNC";
                DataTable dt3 = DataBase.Consultas.Consulta(str_conn, sqlExtrato);
                Session["dtContab"] = dt3;
                gridContabil.DataSource = dt3;
                gridContabil.DataBind();
            }
            
            radioFiltroContab.SelectedIndex = 0;
        }
        protected void btnEncerra_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Encerramento Exercício";
            DateTime dtLimite = new DateTime(Convert.ToInt32(dateEncerra.Text.Split('/')[1]), Convert.ToInt32(dateEncerra.Text.Split('/')[0]),1);
            string param=string.Empty;
            switch (checkEncerra.SelectedItem.Value.ToString())
            {
                case "0":
                    param = "300";
                    break;
                case "1":
                    param = "301";
                    break;
            }
            if (ASPxCheckBox1.Checked)
            {
                CultureInfo culture = new CultureInfo(lang);
                try
                {
                    int validOK = 0;
                    int validERRO = 0;
                    string textOK = string.Empty, textErro = string.Empty;
                    var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                    for (int i = 0; i < lista.Count; i++)
                    {
                        string[] param_dados = new string[4];
                        string opidcont = lista[i].ToString();
                        DataBase.Consultas.Alteracao = checkEncerra.SelectedItem.Text + " "+dtLimite.ToShortDateString()+"  #ID: " + opidcont;
                        param_dados[0] = "@p_opidcont" + "#" + opidcont;
                        param_dados[1] = "@p_TipoContabil#300";
                        param_dados[2] = "@p_DtLimite#" + string.Format(culture, "{0}", dtLimite.Year) + "-" + string.Format(culture, "{0}", dtLimite.Month) + "-" + string.Format(culture, "{0}", dtLimite.Day);
                        param_dados[3] = "@p_GravaLog#0";
                        string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Period_Closing", param_dados, "p_mensagem");
                        if (exec == "OK")
                        {
                            validOK = validOK + 1;
                            textOK += opidcont + ",";

                        }
                        else
                        {
                            validERRO = validERRO + 1;
                            textErro += "<br />#ID:" + opidcont + ":" + exec + ",";
                        }
                    }
                    if (textOK.Length != 0)
                        textOK = textOK.Substring(0, textOK.Length - 1);
                    if (textErro.Length != 0)
                        textErro = textErro.Substring(0, textErro.Length - 1);
                    string erro = validERRO == 0 ? "" : hfMsgException.Value + textErro;
                    string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
                    MsgException(ok + "<br />" + erro, 2);
                }
                catch(Exception ex)
                {
                    MsgException(hfMsgException.Value + ex.Message.ToString(), 1);
                }
            }
            else
            {
                CultureInfo culture = new CultureInfo(lang);
                try
                {
                    
                    string[] param_dados = new string[4];
                    string retorno;
                    DataBase.Consultas.Alteracao = checkEncerra.SelectedItem.Text + " "+ dtLimite.ToShortDateString() + "  #ID: " + hfOPIDCONT.Value;
                    param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                    param_dados[1] = "@p_TipoContabil#300";
                    param_dados[2] = "@p_DtLimite#" + string.Format(culture, "{0}", dtLimite.Year) + "-" + string.Format(culture, "{0}", dtLimite.Month) + "-" + string.Format(culture, "{0}", dtLimite.Day);
                    param_dados[3] = "@p_GravaLog#0";
                    retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Period_Closing", param_dados, "p_mensagem");
                    if (retorno == "OK")
                        MsgException(hfMsgSuccess.Value, 2);
                    else
                        MsgException(hfMsgException.Value + retorno, 1);
                }
                catch (Exception ex)
                {
                    MsgException(hfMsgException.Value + ex.Message.ToString(), 1);
                }
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
            if(exc==2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void btnProcFluxo_Click(object sender, EventArgs e)
        {

            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Fluxo Financeiro";
            string[] param_dados = new string[3];
            if (ASPxCheckBox1.Checked)
            {
                if (checkFiltroFluxo.SelectedItems.Count>0)
                {
                    int validOK = 0;
                    int validERRO = 0;
                    string textOK = string.Empty, textErro = string.Empty;
                    var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                    for (int i = 0; i < lista.Count; i++)
                    {
                        int[] param_Filtro = new int[checkFiltroFluxo.SelectedItems.Count];
                        for(int h=0;h<param_Filtro.Length;h++)
                        {
                            switch(checkFiltroFluxo.SelectedItems[h].Value.ToString())
                            {
                                case "PHPLANIF":
                                    param_Filtro[h] = 100;
                                    break;
                                case "PHPLANIF_NOMINAL":
                                    param_Filtro[h] = 101;
                                    break;
                                case "PHPLANIF_INFLACAO":
                                    param_Filtro[h] = 102;
                                    break;
                                case "PHPLANIF_MOEDA":
                                    param_Filtro[h] = 103;
                                    break;
                                case "PHPLANIF_USGAAP":
                                    param_Filtro[h] = 104;
                                    break;
                            }
                        }
                        for (int j = 0; j < param_Filtro.Length; j++)
                        {
                            string opidcont = lista[i].ToString();
                            DataBase.Consultas.Alteracao = "Processamento Fluxo Financeiro Contrato #ID: " + opidcont;
                            param_dados[0] = "@p_opidcont" + "#" + opidcont;
                            param_dados[1] = "@p_TipoFluxo" + "#" + param_Filtro[j];
                            param_dados[2] = "@p_GravaLog" + "#0";
                            string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Cash_Flow", param_dados, "p_mensagem");
                            if (exec == "OK")
                            {
                                validOK = validOK + 1;
                                textOK += opidcont + ",";

                            }
                            else
                            {
                                validERRO = validERRO + 1;
                                textErro += "<br />#ID:" + opidcont + ":" + exec + ",";
                            }
                        }
                    }
                    if (textOK.Length != 0)
                        textOK = textOK.Substring(0, textOK.Length - 1);
                    if (textErro.Length != 0)
                        textErro = textErro.Substring(0, textErro.Length - 1);
                    string erro = validERRO == 0 ? "" : hfMsgException.Value + textErro;
                    string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
                    MsgException(ok + "<br />" + erro, 2);
                }
                else
                    MsgException("Filtro de processamento não selecionado.", 2);
            }
            else
            {
                int param = 0;
                switch(radioFiltroFluxo.SelectedItem.Value.ToString())
                {
                    case "PHPLANIF":
                        param = 100;
                        break;
                    case "PHPLANIF_NOMINAL":
                        param = 101;
                        break;
                    case "PHPLANIF_INFLACAO":
                        param = 102;
                        break;
                    case "PHPLANIF_MOEDA":
                        param = 103;
                        break;
                    case "PHPLANIF_USGAAP":
                        param = 104;
                        break;
                }
                string opidcont = hfOPIDCONT.Value;
                DataBase.Consultas.Alteracao = "Processamento Fluxo Financeiro Contrato #ID: " + opidcont;
                param_dados[0] = "@p_opidcont" + "#" + opidcont;
                param_dados[1] = "@p_TipoFluxo" + "#"+param;
                param_dados[2] = "@p_GravaLog" + "#0";
                string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Cash_Flow", param_dados, "p_mensagem");
                if (exec == "OK")
                {
                    MsgException(hfMsgSuccess.Value, 2);
                }
                else
                {
                    MsgException(hfMsgException.Value + exec, 1);
                }
                string sqlFluxo = "SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [PHPLANIF] WHERE ([OPIDCONT] = " + hfOPIDCONT.Value + ") ORDER BY 1,4";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlFluxo);
                Session["dtFluxo"] = dt;
                gridFluxoCaixa.DataSource = dt;
                gridFluxoCaixa.DataBind();
            }
            radioFiltroFluxo.SelectedIndex = 0;
        }
        protected void ASPxCheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            if(ASPxCheckBox1.Checked)
            {
                ASPxGridView2.DataBind();
                MultiView1.ActiveViewIndex = 4;
                dropMultiView.SelectedIndex = 0;
                pnlProcContab.Visible = false;
                pnlProcExtrato.Visible = false;
                pnlProcFluxo.Visible = false;
                pnlRescisao.Visible = false;
                pnlEncerraContab.Visible = false;
                pnlRepactuacao.Visible = false;
                pnlProcessoContabil.Visible = false;
                pnlInfoContrato.Visible = false;
                dropMultiView.Enabled = false;
            }
            else
            {
                ASPxGridView1.DataBind();
                MultiView1.ActiveViewIndex = 0;
                pnlInfoContrato.Visible = true;
                dropMultiView.Enabled = true;
                dropMultiView.SelectedIndex = 0;
                pnlProcContab.Visible = false;
                pnlProcExtrato.Visible = false;
                pnlEncerraContab.Visible = false;
                pnlProcFluxo.Visible = false;
                pnlRescisao.Visible = false;
                pnlRepactuacao.Visible = false;
                pnlProcessoContabil.Visible = false;
            }
        }
        protected void ASPxGridView2_ToolbarItemClick(object source, DevExpress.Web.Data.ASPxGridViewToolbarItemClickEventArgs e)
        {

            hfMsgSuccess.Value= HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString();
            int validOK = 0;
            int validERRO = 0;
            string textOK = string.Empty, textErro = string.Empty;
            switch (e.Item.Name)
            {
                case "fluxo":
                    var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                    for(int i = 0; i < lista.Count; i++)
                    {
                        string opidcont = lista[i].ToString();
                        string exec = DataBase.Consultas.CallProc1(str_conn, "nesta_sp_Cash_Flow", opidcont, sgbd);
                        if (exec == "OK")
                        {
                            validOK = validOK + 1;
                            textOK += opidcont+",";

                        }
                        else
                        {
                            validERRO = validERRO + 1;
                            textErro += opidcont + ",";
                        }
                    }
                    break;
            }
            if(textOK.Length != 0)
                textOK = textOK.Substring(0, textOK.Length - 1);
            if(textErro.Length !=0)
                textErro = textErro.Substring(0, textErro.Length - 1);
            string erro = validERRO == 0 ? "" : hfMsgException.Value+"<br />#ID:"+textErro;
            string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:"+textOK;
            MsgException(ok + "<br />" + erro, 2);
        }
        protected void ASPxGridView1_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            int Index = Convert.ToInt32(e.Parameters);
            DevExpress.Web.ASPxGridView grid = (sender) as DevExpress.Web.ASPxGridView;
            hfOPIDCONT.Value = grid.GetRowValues(Index, "OPIDCONT").ToString();
            txtOPIDCONT.Text = grid.GetRowValues(Index, "OPIDCONT").ToString();
            //lblOPIDCONT.Visible = true;
            txtOper.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
            txtDesc.Text = grid.GetRowValues(Index, "OPNMCONT").ToString();
            txtIndice.Text = grid.GetRowValues(Index, "IENMINEC").ToString();
            txtContra.Text = grid.GetRowValues(Index, "FONMAB20").ToString();
            pnlNavegacao.Visible = true;
            btnProcFluxo.Enabled = true;
            btnProcExtrato.Enabled = true;
            btnProcContab.Enabled = true;
            btnProcResci.Enabled = true;
            btnProcRepac.Enabled = true;
        }
        protected void ASPxGridView2_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if(ASPxGridView2.GetSelectedFieldValues("OPIDCONT").Count() > 0)
            {
                switch (e.Parameters)
                {
                    case "fluxo": //FluxoCaixa
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = true;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        btnProcFluxo.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        dropMultiView.Value = 1;
                        break;
                    case "extrato": //ExtratoFinanc
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = true;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        btnProcExtrato.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        dropMultiView.Value = 2;
                        break;
                    case "contabil": //Contabil
                        pnlProcContab.Visible = true;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        btnProcContab.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        dropMultiView.Value = 3;
                        break;
                    case "rescisao":
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = true;
                        pnlRepactuacao.Visible = false;
                        btnProcResci.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        dropMultiView.Value = 4;
                        break;
                    case "repactuacao":
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = true;
                        btnProcRepac.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        dropMultiView.Value = 6;
                        break;
                    case "encerra":
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        pnlEncerraContab.Visible = true;
                        btnEncerra.Enabled = true;
                        dropMultiView.Value = 5;
                        pnlEncerraContab.Visible = true;
                        btnEncerra.Enabled = true;
                        pnlProcessoContabil.Visible = false;
                        break;
                }
            }
            else
            {
                pnlProcContab.Visible = false;
                pnlProcExtrato.Visible = false;
                pnlProcFluxo.Visible = false;
                pnlRescisao.Visible = false;
                pnlRepactuacao.Visible = false;
                btnProcContab.Enabled = false;
                btnProcExtrato.Enabled = false;
                btnProcFluxo.Enabled = false;
                btnProcRepac.Enabled = false;
                btnProcResci.Enabled = false;
                dropMultiView.SelectedIndex = 0;
                ASPxGridView grid = (sender) as ASPxGridView;
                ASPxRadioButtonList rb = grid.Toolbars.FindByName("ToolProcess").Items.FindByName("Item").FindControl("itemlist_toolbar") as ASPxRadioButtonList;
                rb.SelectedItem = null;
            }
        }
        protected void btnSelect1_Click(object sender, EventArgs e)
        {
            int Index = Convert.ToInt32(ASPxGridView1.FocusedRowIndex);            
            hfOPIDCONT.Value = ASPxGridView1.GetRowValues(Index, "OPIDCONT").ToString();
            txtOPIDCONT.Text = ASPxGridView1.GetRowValues(Index, "OPIDCONT").ToString();
            //lblOPIDCONT.Visible = true;
            txtOper.Text = ASPxGridView1.GetRowValues(Index, "OPCDCONT").ToString();
            txtDesc.Text = ASPxGridView1.GetRowValues(Index, "OPNMCONT").ToString();
            //txtIndice.Text = ASPxGridView1.GetRowValues(Index, "IENMINEC").ToString();
            txtContra.Text = ASPxGridView1.GetRowValues(Index, "FONMAB20").ToString();
            string sql = "select ie.IENMINEC Contract_Currency " +
     ", i2.IENMINEC Exchange_Currency " +
     ", i3.IENMINEC Functional_Currency " +
"from opcontra  op " +
   ", prprodut  pr " +
   ", ieindeco  ie " +
   ", tvestrut  tv " +
   ", ieindeco  i2 " +
   ", itcconfig it " +
   ", ieindeco  i3 " +
   ", ieindeco  i4 " +
"where op.opidcont in ("+ hfOPIDCONT.Value + ") " +
  "and pr.prprodid = op.PRPRODID " +
  "and ie.ieidinec = pr.ieidinec " +
  "and tv.tvidestr = op.TVIDESTR " +
  "and i2.ieidinec = tv.IEIDINEC " +
  "and it.ieidinec = i3.IESGINEC " +
  "and i4.ieidinec = tv.TVIDPAIS";
            try
            {
                var result = DataBase.Consultas.Consulta(str_conn, sql, 3);
                txtIndice.Text = result[0];
                txtIndice2.Text = result[1];
                txtIndice3.Text = result[2];
            }
            catch
            {
                txtIndice.Text = string.Empty;
                txtIndice2.Text = string.Empty;
                txtIndice3.Text = string.Empty;
            }
            pnlNavegacao.Visible = true;
            btnProcFluxo.Enabled = true;
            btnProcExtrato.Enabled = true;
            btnProcContab.Enabled = true;
            btnProcResci.Enabled = true;
            btnProcRepac.Enabled = true;
            dropMultiView.Enabled = true;
            string sqlFluxo = "SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [PHPLANIF] WHERE ([OPIDCONT] = "+ hfOPIDCONT.Value + ") ORDER BY 1,4";
            DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlFluxo);
            Session["dtFluxo"] = dt;
            gridFluxoCaixa.DataSource = dt;
            gridFluxoCaixa.DataBind();
            string sqlExtrato = "SELECT T1.RZDTDATA, T2.MODSMODA RZDSHIST, T1.RZVLDEBI, " +
       "T1.RZVLCRED, T1.RZVLSALD, T1.RZVLPRIN, T1.RZVLCOTA, T1.OPIDCONT " +
"FROM RZRAZCTB T1, MODALIDA T2 " +
"WHERE T1.MOIDMODA = T2.MOIDMODA AND " +
      "T2.MOTPIDCA <> 1 AND OPIDCONT = " + hfOPIDCONT.Value + " " +
  "ORDER BY T1.RZDTDATA, T1.RZNRREGI";
            DataTable dt2 = DataBase.Consultas.Consulta(str_conn, sqlExtrato);
            Session["dtExtrato"] = dt2;
            gridExtratoFinanc.DataSource = dt2;
            gridExtratoFinanc.DataBind();
            string sqlContab = "SELECT T1.LBDTLANC, T1.LBTPLANC, T2.PFCDPLNC, " +
                    "T2.PFDSPLNC, T3.MODSMODA, T1.LBVLLANC " +
                    "FROM LBLCTCTB T1 " +
                    "LEFT OUTER JOIN PFPLNCTA T2 ON(T1.PFIDPLNC = T2.PFIDPLNC) " +
                    "INNER JOIN MODALIDA T3 ON(T1.MOIDMODA = T3.MOIDMODA) " +
                    "WHERE T1.MOIDMODA = T3.MOIDMODA " +
                    "AND T1.OPIDCONT = " + hfOPIDCONT.Value + " " +
                    "ORDER BY LBDTLANC, T3.MOIDMODA, T1.LBTPLANC, " +
                    "T2.PFCDPLNC";
            DataTable dt3 = DataBase.Consultas.Consulta(str_conn, sqlContab);
            Session["dtContab"] = dt3;
            gridContabil.DataSource = dt3;
            gridContabil.DataBind();
            gridProcessaContabil.DataBind();
        }
        protected void btnSelect2_Click(object sender, EventArgs e)
        {
            if (ASPxGridView2.GetSelectedFieldValues("OPIDCONT").Count() > 0)
            {
                switch (hfMultiProcSelect.Value)
                {
                    case "fluxo": //FluxoCaixa
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = true;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        btnProcFluxo.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        btnEncerra.Enabled = false;
                        dropMultiView.SelectedIndex = 1;
                        pnlEncerraContab.Visible = false;
                        pnlRepactuacao.Visible = false;
                        pnlProcessoContabil.Visible = false;
                        break;
                    case "extrato": //ExtratoFinanc
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = true;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        btnProcExtrato.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        btnEncerra.Enabled = false;
                        dropMultiView.SelectedIndex = 2;
                        pnlEncerraContab.Visible = false;
                        pnlRepactuacao.Visible = false;
                        pnlProcessoContabil.Visible = false;
                        break;
                    case "contabil": //Contabil
                        pnlProcContab.Visible = true;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        btnProcContab.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        btnEncerra.Enabled = false;
                        dropMultiView.SelectedIndex = 3;
                        pnlEncerraContab.Visible = false;
                        pnlRepactuacao.Visible = false;
                        pnlProcessoContabil.Visible = false;
                        break;
                    case "encerra": //Encerramento
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        pnlEncerraContab.Visible = true;
                        btnEncerra.Enabled = true;
                        dropMultiView.SelectedIndex = 5;
                        pnlEncerraContab.Visible = true;
                        btnEncerra.Enabled = true;
                        pnlProcessoContabil.Visible = false;
                        break;
                    case "rescisao":
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = true;
                        pnlRepactuacao.Visible = false;
                        btnProcResci.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        btnEncerra.Enabled = false;
                        dropMultiView.SelectedIndex = 5;
                        break;
                    case "repactuacao":
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = true;
                        btnProcRepac.Enabled = true;
                        pnlEncerraContab.Visible = false;
                        btnEncerra.Enabled = false;
                        dropMultiView.SelectedIndex = 6;
                        break;
                    case "integra":
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        pnlRescisao.Visible = false;
                        pnlRepactuacao.Visible = false;
                        pnlEncerraContab.Visible = false;
                        btnEncerra.Enabled = false;
                        pnlProcessoContabil.Visible = true;
                        dropMultiView.SelectedIndex = 4;
                        pnlEncerraContab.Visible = false;
                        btnEncerra.Enabled = false;
                        pnlProcessoContabil.Visible = true;
                        break;
                }
            }
            else
            {
                pnlProcContab.Visible = false;
                pnlProcExtrato.Visible = false;
                pnlProcFluxo.Visible = false;
                pnlRescisao.Visible = false;
                pnlRepactuacao.Visible = false;
                btnProcContab.Enabled = false;
                btnProcExtrato.Enabled = false;
                btnProcFluxo.Enabled = false;
                btnProcRepac.Enabled = false;
                btnProcResci.Enabled = false;
                dropMultiView.SelectedIndex = 0;
                //ASPxGridView grid = (sender) as ASPxGridView;
                //ASPxRadioButtonList rb = grid.Toolbars.FindByName("ToolProcess").Items.FindByName("Item").FindControl("itemlist_toolbar") as ASPxRadioButtonList;
                //rb.SelectedItem = null;
            }
        }
        protected void btnProcResci_Click(object sender, EventArgs e)
        {
            string multa = Convert.ToDecimal(txtMultaRescisoria.Text) == 0 ? "0" : txtMultaRescisoria.Text;
            //MsgException(culture.ToString(), 2);return;
            if (Page.IsValid)
            {
                DataBase.Consultas.Acao = "Processamento";
                DataBase.Consultas.Resumo = "Rescisão";
                string[] param_dados = new string[3];
                DateTime data = new DateTime(1986, 3, 26);
                DateTime data1 = Convert.ToDateTime(txtDataResci.Text, culture);
                if (data.Day == data1.Day && data.Month == data1.Month)
                {
                    pupRescisao.ShowOnPageLoad = true;
                }
                else
                {
                    if (ASPxCheckBox1.Checked)
                    {
                        int validOK = 0;
                        int validERRO = 0;
                        string textOK = string.Empty, textErro = string.Empty;
                        var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                        for (int i = 0; i < lista.Count; i++)
                        {
                            string opidcont = lista[i].ToString();
                            DataBase.Consultas.Alteracao = "Processamento Rescisão Contrato #ID: " + opidcont;
                            param_dados[0] = "@p_opidcont" + "#" + opidcont;
                            param_dados[1] = "@p_rescisao#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Day);
                            param_dados[2] = "@p_idioma#" + culture.ToString();
                            string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Termination", param_dados, "o_mensagem");
                            if (exec == "OK")
                            {
                                validOK = validOK + 1;
                                textOK += opidcont + ",";

                            }
                            else
                            {
                                validERRO = validERRO + 1;
                                textErro += "<br />#ID:" + opidcont + ":" + exec + ",";
                            }
                        }
                        if (textOK.Length != 0)
                            textOK = textOK.Substring(0, textOK.Length - 1);
                        if (textErro.Length != 0)
                            textErro = textErro.Substring(0, textErro.Length - 1);
                        string erro = validERRO == 0 ? "" : hfMsgException.Value + textErro;
                        string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
                        MsgException(ok + "<br />" + erro, 2);
                    }
                    else
                    {
                        string opidcont = hfOPIDCONT.Value;
                        DataBase.Consultas.Alteracao = "Processamento Rescisão Contrato #ID: " + opidcont;
                        param_dados[0] = "@p_opidcont" + "#" + opidcont;
                        param_dados[1] = "@p_rescisao#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Day);
                        param_dados[2] = "@p_idioma#" + culture.ToString();
                        string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Termination", param_dados, "o_mensagem");
                        if (exec == "OK")
                        {
                            string retu = string.Empty;
                            for (int j = 0; j < param_dados.Length; j++)
                                retu += param_dados[j] + "<br />";
                            MsgException(hfMsgSuccess.Value, 2);
                        }
                        else
                        {
                            MsgException(hfMsgException.Value + exec, 1);
                        }
                    }
                }
            }
        }
        protected void btnYes_Command(object sender, CommandEventArgs e)
        {
            string multa = Convert.ToDecimal(txtMultaRescisoria.Text) == 0 ? "0" : txtMultaRescisoria.Text;
            pupRescisao.ShowOnPageLoad = false;
            string[] param_dados = new string[3];
            string exec = string.Empty;
            if (ASPxCheckBox1.Checked)
            {
                int validOK = 0;
                int validERRO = 0;
                string textOK = string.Empty, textErro = string.Empty;
                var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                for (int i = 0; i < lista.Count; i++)
                {
                    string opidcont = lista[i].ToString();
                    DataBase.Consultas.Acao = "Processamento";
                    DataBase.Consultas.Resumo = "Rescisão";
                    DataBase.Consultas.Alteracao = "Processamento Rescisão Contrato #ID: " + opidcont;
                    param_dados[0] = "@p_opidcont" + "#" + opidcont;
                    param_dados[1] = "@p_rescisao#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Day);
                    param_dados[2] = "@p_idioma#" + culture.ToString();
                    switch (e.CommandArgument.ToString())
                    {
                        case "1":
                            exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Termination", param_dados, "o_mensagem");
                            break;
                        case "0":
                            exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Termination", param_dados, "o_mensagem");
                            break;
                    }
                    if (exec == "OK")
                    {
                        validOK = validOK + 1;
                        textOK += opidcont + ",";

                    }
                    else
                    {
                        validERRO = validERRO + 1;
                        textErro += "<br />#ID:" + opidcont + ":"+exec+ ",";
                    }
                }
                if (textOK.Length != 0)
                    textOK = textOK.Substring(0, textOK.Length - 1);
                if (textErro.Length != 0)
                    textErro = textErro.Substring(0, textErro.Length - 1);
                string erro = validERRO == 0 ? "" : hfMsgException.Value + textErro;
                string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
                MsgException(ok + "<br />" + erro, 2);
            }
            else
            {
                string opidcont = hfOPIDCONT.Value;
                DataBase.Consultas.Alteracao = "Processamento Rescisão Contrato #ID: " + opidcont;
                param_dados[0] = "@p_opidcont" + "#" + opidcont;
                param_dados[1] = "@p_rescisao#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataResci.Text).Day);
                param_dados[2] = "@p_idioma#" + culture.ToString();                
                switch(e.CommandArgument.ToString())
                {
                    case "1":
                        exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Termination", param_dados, "o_mensagem");
                        break;
                    case "0":
                        exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Termination", param_dados, "o_mensagem");
                        break;
                }
                if (exec == "OK")
                {
                    MsgException(hfMsgSuccess.Value, 2);
                }
                else
                {
                    MsgException(hfMsgException.Value + exec, 1);
                }
            }
        }
        protected void btnProcRepac_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Repactuação";
            DateTime dt = new DateTime(Convert.ToInt32(txtDataRepac.Text.Split('/')[1]), Convert.ToInt32(txtDataRepac.Text.Split('/')[0]),1);
            string[] param_dados = new string[4];
            string exec = string.Empty;
            if (ASPxCheckBox1.Checked)
            {
                int validOK = 0;
                int validERRO = 0;
                string textOK = string.Empty, textErro = string.Empty;
                var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                for (int i = 0; i < lista.Count; i++)
                {
                    string opidcont = lista[i].ToString();
                    DataBase.Consultas.Alteracao = "Processamento Repactuação Contrato #ID: " + opidcont;
                    param_dados[0] = "@p_opidcont" + "#" + opidcont;
                    param_dados[1] = "@p_dt_repact#"+dt.ToString("dd/MM/yyyy");
                    //param_dados[2] = "@p_repact_ate#" + txtDataRepac.Text;
                    param_dados[2] = "@p_taxa#" + txtTaxaRepac.Text.Replace(",", ".");
                    param_dados[3] = "@p_idioma#pt_BR";// + culture.ToString();
                    exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Repactuation", param_dados, "o_mensagem");
                    if (exec == "OK")
                    {
                        validOK = validOK + 1;
                        textOK += opidcont + ",";

                    }
                    else
                    {
                        validERRO = validERRO + 1;
                        textErro += "<br />#ID:" + opidcont + ":"+exec+ ",";
                    }
                }
                if (textOK.Length != 0)
                    textOK = textOK.Substring(0, textOK.Length - 1);
                if (textErro.Length != 0)
                    textErro = textErro.Substring(0, textErro.Length - 1);
                string erro = validERRO == 0 ? "" : hfMsgException.Value + textErro;
                string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
                MsgException(ok + "<br />" + erro, 2);
            }
            else
            {                
                string opidcont = hfOPIDCONT.Value;
                DataBase.Consultas.Alteracao = "Processamento Repactuação Contrato #ID: " + opidcont;
                param_dados[0] = "@p_opidcont" + "#" + opidcont;
                param_dados[1] = "@p_dt_repact#"+dt;
                //param_dados[2] = "@p_repact_ate#" + txtDataRepac.Text;
                param_dados[2] = "@p_taxa#" + txtTaxaRepac.Text.Replace(",",".");
                param_dados[3] = "@p_idioma#" + culture.ToString();
                exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Repactuation", param_dados, "o_mensagem");
                if (exec == "OK")
                {
                    MsgException(hfMsgSuccess.Value, 2);
                }
                else
                {
                    MsgException(hfMsgException.Value + exec, 1);
                }
            }
        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            int valid = DataBase.Consultas.ValidaRescisao(str_conn, Convert.ToDateTime(txtDataResci.Text, culture), hfOPIDCONT.Value, culture);
            if (valid==1)
            {
                CustomValidator1.ErrorMessage = GetGlobalResourceObject("PassivosAquisicao", "contabil_msg_erro1").ToString();
                args.IsValid = false;
                return;
            }
            else if(valid==2)
            {
                CustomValidator1.ErrorMessage = GetGlobalResourceObject("PassivosAquisicao", "contabil_msg_erro2").ToString();
                args.IsValid = false;
                return;
            }
            else if (valid == 3)
            {
                CustomValidator1.ErrorMessage = GetGlobalResourceObject("PassivosAquisicao", "contabil_msg_erro3").ToString();
                args.IsValid = false;
                return;
            }
            else if (valid == 4)
            {
                CustomValidator1.ErrorMessage = GetGlobalResourceObject("PassivosAquisicao", "contabil_msg_erro4").ToString();
                args.IsValid = false;
                return;
            }
            else if (valid==0)
            {
                args.IsValid = true;
                return;
            }
        }
        protected void gridFluxoCaixa_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                var exportMenuItem = e.Items.FindByCommand(GridViewContextMenuCommand.ExportMenu);
                //exportMenuItem.Items.Add("Custom export to XLS(WYSIWYG)", "CustomExportToXLS").Image.IconID = "export_exporttoxls_16x16";
                exportMenuItem.Items.Clear();
                exportMenuItem.Items.Add("CSV", "CSV").Image.Url = "icons/icons8-csv-30.png";
                exportMenuItem.Items.Add("XLS", "XLS").Image.Url = "icons/icons8-xls-30.png";
            }
        }
        protected void gridFluxoCaixa_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            ASPxGridView grid = (sender) as ASPxGridView;
            if (e.Item.Name == "CSV")
                grid.ExportCsvToResponse(new DevExpress.XtraPrinting.CsvExportOptionsEx() { ExportType = ExportType.DataAware });
            if (e.Item.Name == "XLS")
                grid.ExportXlsToResponse(new DevExpress.XtraPrinting.XlsExportOptionsEx { ExportType = ExportType.DataAware });
        }
        protected void gridExtratoFinanc_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                var exportMenuItem = e.Items.FindByCommand(GridViewContextMenuCommand.ExportMenu);
                //exportMenuItem.Items.Add("Custom export to XLS(WYSIWYG)", "CustomExportToXLS").Image.IconID = "export_exporttoxls_16x16";
                exportMenuItem.Items.Clear();
                exportMenuItem.Items.Add("CSV", "CSV").Image.Url = "icons/icons8-csv-30.png";
                exportMenuItem.Items.Add("XLS", "XLS").Image.Url = "icons/icons8-xls-30.png";
            }
        }
        protected void gridExtratoFinanc_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            ASPxGridView grid = (sender) as ASPxGridView;
            if (e.Item.Name == "CSV")
                grid.ExportCsvToResponse(new DevExpress.XtraPrinting.CsvExportOptionsEx() { ExportType = ExportType.DataAware });
            if (e.Item.Name == "XLS")
                grid.ExportXlsToResponse(new DevExpress.XtraPrinting.XlsExportOptionsEx { ExportType = ExportType.DataAware });
        }
        protected void gridContabil_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                var exportMenuItem = e.Items.FindByCommand(GridViewContextMenuCommand.ExportMenu);
                //exportMenuItem.Items.Add("Custom export to XLS(WYSIWYG)", "CustomExportToXLS").Image.IconID = "export_exporttoxls_16x16";
                exportMenuItem.Items.Clear();
                exportMenuItem.Items.Add("CSV", "CSV").Image.Url = "icons/icons8-csv-30.png";
                exportMenuItem.Items.Add("XLS", "XLS").Image.Url = "icons/icons8-xls-30.png";
            }
        }
        protected void gridContabil_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            ASPxGridView grid = (sender) as ASPxGridView;
            if (e.Item.Name == "CSV")
                grid.ExportCsvToResponse(new DevExpress.XtraPrinting.CsvExportOptionsEx() { ExportType = ExportType.DataAware });
            if (e.Item.Name == "XLS")
                grid.ExportXlsToResponse(new DevExpress.XtraPrinting.XlsExportOptionsEx { ExportType = ExportType.DataAware });
        }
        protected void btnProcRepac_Load(object sender, EventArgs e)
        {

            btnProcRepac.Enabled = perfil != "3";
        }
        protected void btnProcResci_Load(object sender, EventArgs e)
        {
            btnProcResci.Enabled = perfil != "3";
        }
        protected void btnProcContab_Load(object sender, EventArgs e)
        {
            btnProcContab.Enabled = perfil != "3";
        }
        protected void btnProcExtrato_Load(object sender, EventArgs e)
        {
            btnProcExtrato.Enabled = perfil != "3";
        }
        protected void btnProcFluxo_Load(object sender, EventArgs e)
        {
            btnProcFluxo.Enabled = perfil != "3";
        }
        protected void ASPxCheckBox1_Load(object sender, EventArgs e)
        {
            ASPxCheckBox1.Enabled = perfil != "3";
        }
        protected void gridExtratoFinanc_DataBound(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            if (!string.IsNullOrEmpty(txtOPIDCONT.Text))
            {
                foreach (GridViewDataColumn c in grid.Columns)
                {
                    bool ifrs = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select PRTPIDOP from opcontra where opidcont=" + txtOPIDCONT.Text, 1)[0]) == 17;
                    if (ifrs)
                    {
                        if (c.FieldName.ToString() == "RZVLSALD")
                        {
                            c.Caption = GetGlobalResourceObject("PassivosAquisicao", "contabil_card3_coluna5.2").ToString();
                        }
                        else if (c.FieldName.ToString() == "RZVLPRIN")
                        {
                            c.Caption = GetGlobalResourceObject("PassivosAquisicao", "contabil_card3_coluna6.2").ToString();
                        }
                    }
                }
            }
        }
        protected void radioFiltroFluxo_Load(object sender, EventArgs e)
        {
            ASPxRadioButtonList radio = (ASPxRadioButtonList)sender;
            if (!IsPostBack)
            {
                radio.Items.Clear();
                string sql = "select " +
                            "case when CVM_REAL = 'S' then 'PHPLANIF' else 'N' end as CVM_REAL " +
                            ",case when CVM_NOMINAL = 'S' then 'PHPLANIF_NOMINAL' else 'N' end as CVM_NOMINAL " +
                            ",case when CVM_INFLACIONADO = 'S' then 'PHPLANIF_INFLACAO' else 'N' end as CVM_INFLACIONADO " +
                            //",case when CONTABILIZAMOEDA = 'S' then 'PHPLANIF_MOEDA' else 'N' end as CONTABILIZAMOEDA " +
                            ",case when USGAAP = 'S' then 'PHPLANIF_USGAAP' else 'N' end as USGAAP " +
                            "from ITCCONFIG";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                radio.EncodeHtml = false;
                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        if (row[column.ColumnName].ToString() != "N")
                        {
                            radio.Items.Add(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString()
                                , row[column.ColumnName].ToString());
                        }
                        else if (row[column.ColumnName].ToString() == "N")
                        {
                            
                            radio.Items.Add("<span style='color: #b8b8b8;'>" + GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString()+ "</span>"
                                , "0");
                        }
                    }
                }
                radio.SelectedItem = radio.Items.FindByText(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_CVM_REAL").ToString());
            }
        }
        protected void gridFluxoCaixa_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            hfTabelaFluxo.Value = e.Parameters;
            string novoSelect = "SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [" + hfTabelaFluxo.Value + "] WHERE ([OPIDCONT] = "+ hfOPIDCONT.Value + ") ORDER BY [PHNRPARC], [PHDTEVEN]";
            DataTable dt = DataBase.Consultas.Consulta(str_conn, novoSelect);
            Session["dtFluxo"] = dt;
            gridFluxoCaixa.DataSource = dt;
            gridFluxoCaixa.DataBind();
        }
        protected void radioFiltroExtrato_Load(object sender, EventArgs e)
        {
            ASPxRadioButtonList radio = (ASPxRadioButtonList)sender;
            if (!IsPostBack)
            {
                radio.Items.Clear();
                string sql = "select "+
                            "case when CVM_REAL = 'S' then 'RZRAZCTB' else 'N' end as CVM_REAL " +
                            ",case when CVM_NOMINAL = 'S' then 'RZRAZCTB_NOMINAL' else 'N' end as CVM_NOMINAL " +
                            ",case when CVM_INFLACIONADO = 'S' then 'RZRAZCTB_INFLACAO' else 'N' end as CVM_INFLACIONADO " +
                            ",case when CONTABILIZAMOEDA = 'S' then 'RZRAZCTB_MOEDA' else 'N' end as CONTABILIZAMOEDA " +                                                       
                            ",case when USGAAP = 'S' then 'RZRAZCTB_USGAAP' else 'N' end as USGAAP "+   
                            "from ITCCONFIG ";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                radio.EncodeHtml = false;
                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        if (row[column.ColumnName].ToString() != "N")
                        {
                            radio.Items.Add(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString()
                                , row[column.ColumnName].ToString());
                        }
                        else if (row[column.ColumnName].ToString() == "N")
                        {

                            radio.Items.Add("<span style='color: #b8b8b8;'>" + GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString() + "</span>", "0");
                        }
                    }
                }
                radio.SelectedItem = radio.Items.FindByText(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_CVM_REAL").ToString());
            }
        }
        protected void gridExtratoFinanc_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            hfTabelaExtrato.Value = e.Parameters;
            string novoSelect = "SELECT T1.RZDTDATA, T2.MODSMODA RZDSHIST, T1.RZVLDEBI, "+
       "T1.RZVLCRED, T1.RZVLSALD, T1.RZVLPRIN, T1.RZVLCOTA, T1.OPIDCONT "+
"FROM "+hfTabelaExtrato.Value+" T1, MODALIDA T2 "+
"WHERE T1.MOIDMODA = T2.MOIDMODA AND "+
      "T2.MOTPIDCA <> 1 AND OPIDCONT = "+hfOPIDCONT.Value+" "+
  "ORDER BY T1.RZDTDATA, T1.RZNRREGI";
            DataTable dt = DataBase.Consultas.Consulta(str_conn, novoSelect);
            Session["dtExtrato"] = dt;
            gridExtratoFinanc.DataSource = dt;
            gridExtratoFinanc.DataBind();
        }
        protected void gridContabil_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            hfTabelaContab.Value = e.Parameters;
            string novoSelect = "SELECT T1.LBDTLANC, T1.LBTPLANC, T2.PFCDPLNC, "+
                                "T2.PFDSPLNC, T3.MODSMODA, T1.LBVLLANC "+
                                "FROM "+hfTabelaContab.Value+" T1 "+
                                "LEFT OUTER JOIN PFPLNCTA T2 ON(T1.PFIDPLNC = T2.PFIDPLNC) "+
                                "INNER JOIN MODALIDA T3 ON(T1.MOIDMODA = T3.MOIDMODA) "+
                                "WHERE T1.MOIDMODA = T3.MOIDMODA "+
                                "AND T1.OPIDCONT = "+hfOPIDCONT.Value+" "+
                                "ORDER BY LBDTLANC, T3.MOIDMODA, T1.LBTPLANC, "+
                                "T2.PFCDPLNC";
            DataTable dt = DataBase.Consultas.Consulta(str_conn, novoSelect);
            Session["dtContab"] = dt;
            gridContabil.DataSource = dt;
            gridContabil.DataBind();
        }
        protected void radioFiltroContab_Load(object sender, EventArgs e)
        {
            ASPxRadioButtonList radio = (ASPxRadioButtonList)sender;
            if (!IsPostBack)
            {
                radio.Items.Clear();
                bool CapitalAberto = DataBase.Consultas.Consulta(str_conn, "SELECT CAPITALABERTO FROM ITCCONFIG", 1)[0] == "S";
                string sql = string.Empty;
                if (CapitalAberto)
                {
                    sql = "select " +
                        "case when CVM_REAL = 'S' then 'LBLCTCTB' else 'N' end as CVM_REAL " +
                        ",case when CVM_NOMINAL = 'S' then 'LBLCTCTB_NOMINAL' else 'N' end as CVM_NOMINAL " +
                        ",case when CONTABILIZAMOEDA = 'S' then 'LBLCTCTB_MOEDA' else 'N' end as CONTABILIZAMOEDA " +
                        //",case when CVM_INFLACIONADO = 'S' then 'LBLCTCTB_INFLACAO' else 'N' end as CVM_INFLACIONADO " +
                        ",case when USGAAP = 'S' then 'LBLCTCTB_USGAAP' else 'N' end as USGAAP " +
                        "from ITCCONFIG ";
                }
                else
                {
                    sql = "select " +
                        "case when CVM_REAL = 'S' then 'LBLCTCTB' else 'N' end as CVM_REAL " +
                        ",case when CONTABILIZAMOEDA = 'S' then 'LBLCTCTB_MOEDA' else 'N' end as CONTABILIZAMOEDA " +
                        ",case when USGAAP = 'S' then 'LBLCTCTB_USGAAP' else 'N' end as USGAAP " +
                        "from ITCCONFIG ";
                }
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                radio.EncodeHtml = false;
                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        if (row[column.ColumnName].ToString() != "N")
                        {
                            radio.Items.Add(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString()
                                , row[column.ColumnName].ToString());
                        }
                        else if (row[column.ColumnName].ToString() == "N")
                        {

                            radio.Items.Add("<span style='color: #b8b8b8;'>" + GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString() + "</span>"
                                , "0");
                        }
                    }
                }
                radio.SelectedItem = radio.Items.FindByText(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_CVM_REAL").ToString());
            }
        }
        protected void checkFiltroFluxo_Load(object sender, EventArgs e)
        {
            ASPxCheckBoxList radio = (ASPxCheckBoxList)sender;
            if (!IsPostBack)
            {
                radio.Items.Clear();
                string sql = "select " +
                            "case when CVM_REAL = 'S' then 'PHPLANIF' else 'N' end as CVM_REAL " +
                            ",case when CVM_NOMINAL = 'S' then 'PHPLANIF_NOMINAL' else 'N' end as CVM_NOMINAL " +
                            ",case when CVM_INFLACIONADO = 'S' then 'PHPLANIF_INFLACAO' else 'N' end as CVM_INFLACIONADO " +
                            //",case when CONTABILIZAMOEDA = 'S' then 'PHPLANIF_MOEDA' else 'N' end as CONTABILIZAMOEDA " +
                            ",case when USGAAP = 'S' then 'PHPLANIF_USGAAP' else 'N' end as USGAAP " +
                            "from ITCCONFIG";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                radio.EncodeHtml = false;
                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        if (row[column.ColumnName].ToString() != "N")
                        {
                            radio.Items.Add(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString()
                                , row[column.ColumnName].ToString());
                        }
                        //else if (row[column.ColumnName].ToString() == "N")
                        //{

                        //    radio.Items.Add("<span style='color: #b8b8b8;'>" + GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString() + "</span>"
                        //        , "0");
                        //}
                    }
                }
                radio.SelectedItem = radio.Items.FindByText(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_CVM_REAL").ToString());
            }
            radio.Visible = ASPxCheckBox1.Checked;
        }
        protected void checkFiltroExtrato_Load(object sender, EventArgs e)
        {
            ASPxCheckBoxList radio = (ASPxCheckBoxList)sender;
            if (!IsPostBack)
            {
                radio.Items.Clear();
                string sql = "select " +
                            "case when CVM_REAL = 'S' then 'RZRAZCTB' else 'N' end as CVM_REAL " +
                            ",case when CVM_NOMINAL = 'S' then 'RZRAZCTB_NOMINAL' else 'N' end as CVM_NOMINAL " +
                            ",case when CVM_INFLACIONADO = 'S' then 'RZRAZCTB_INFLACAO' else 'N' end as CVM_INFLACIONADO " +
                            ",case when CONTABILIZAMOEDA = 'S' then 'RZRAZCTB_MOEDA' else 'N' end as CONTABILIZAMOEDA " +
                            ",case when USGAAP = 'S' then 'RZRAZCTB_USGAAP' else 'N' end as USGAAP " +
                            "from ITCCONFIG";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                radio.EncodeHtml = false;
                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        if (row[column.ColumnName].ToString() != "N")
                        {
                            radio.Items.Add(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString()
                                , row[column.ColumnName].ToString());
                        }
                        //else if (row[column.ColumnName].ToString() == "N")
                        //{

                        //    radio.Items.Add("<span style='color: #b8b8b8;'>" + GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString() + "</span>"
                        //        , "0");
                        //}
                    }
                }
                radio.SelectedItem = radio.Items.FindByText(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_CVM_REAL").ToString());
            }
            radio.Visible = ASPxCheckBox1.Checked;
        }
        protected void checkFiltroContabil_Load(object sender, EventArgs e)
        {
            ASPxCheckBoxList radio = (ASPxCheckBoxList)sender;
            if (!IsPostBack)
            {
                radio.Items.Clear();
                bool CapitalAberto = DataBase.Consultas.Consulta(str_conn, "SELECT CAPITALABERTO FROM ITCCONFIG", 1)[0] == "S";
                string sql = string.Empty;
                if (CapitalAberto)
                {
                    sql = "select " +
                        "case when CVM_REAL = 'S' then 'LBLCTCTB' else 'N' end as CVM_REAL " +
                        ",case when CVM_NOMINAL = 'S' then 'LBLCTCTB_NOMINAL' else 'N' end as CVM_NOMINAL " +
                        ",case when CONTABILIZAMOEDA = 'S' then 'LBLCTCTB_MOEDA' else 'N' end as CONTABILIZAMOEDA " +
                        //",case when CVM_INFLACIONADO = 'S' then 'LBLCTCTB_INFLACAO' else 'N' end as CVM_INFLACIONADO " +
                        ",case when USGAAP = 'S' then 'LBLCTCTB_USGAAP' else 'N' end as USGAAP " +
                        "from ITCCONFIG ";
                }
                else
                {
                    sql = "select " +
                        "case when CVM_REAL = 'S' then 'LBLCTCTB' else 'N' end as CVM_REAL " +
                        ",case when CONTABILIZAMOEDA = 'S' then 'LBLCTCTB_MOEDA' else 'N' end as CONTABILIZAMOEDA " +
                        ",case when USGAAP = 'S' then 'LBLCTCTB_USGAAP' else 'N' end as USGAAP " +
                        "from ITCCONFIG ";
                }
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                radio.EncodeHtml = false;
                foreach (DataRow row in dt.Rows)
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        if (row[column.ColumnName].ToString() != "N")
                        {
                            radio.Items.Add(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString()
                                , row[column.ColumnName].ToString());
                        }
                        //else if (row[column.ColumnName].ToString() == "N")
                        //{

                        //    radio.Items.Add("<span style='color: #b8b8b8;'>" + GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_" + column.ColumnName).ToString() + "</span>"
                        //        , "0");
                        //}
                    }
                }
                radio.SelectedItem = radio.Items.FindByText(GetGlobalResourceObject("PassivosAquisicao", "filtro_grid_CVM_REAL").ToString());
            }
            radio.Visible = ASPxCheckBox1.Checked;
        }
        protected void btnEncerra_Load(object sender, EventArgs e)
        {
            btnEncerra.Enabled = perfil != "3";
        }
        protected void checkEncerra_Load(object sender, EventArgs e)
        {
            ASPxRadioButtonList radio = (ASPxRadioButtonList)sender;
            radio.Items.Clear();
            radio.Items.Add(GetGlobalResourceObject("PassivosAquisicao", "contabil_right_checkbox4").ToString(), "0");
            radio.Items.Add("<span style='color: #b8b8b8;'>" + GetGlobalResourceObject("PassivosAquisicao", "contabil_right_checkbox5").ToString() + " </span>", "-1");
        }
        protected void btnProcessoContabil_Load(object sender, EventArgs e)
        {
            //btnProcessoContabil.Enabled = perfil != "3";
        }
        protected void btnProcessoIntegrar_Load(object sender, EventArgs e)
        {
            try
            {
                bool ativo = DataBase.Consultas.Consulta(str_conn, "SELECT SISINTER FROM ITCCONFIG", 1)[0] == "1";
                btnProcessoIntegrar.Visible = ativo;                
            }
            catch
            {
                btnProcessoIntegrar.Visible = false;
            }
            //btnProcessoIntegrar.Enabled = perfil != "3";
        }
        protected void gridProcessaContabil_DataBound(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            foreach (GridViewDataColumn c in grid.Columns)
            {               
                using (Graphics graphics = Graphics.FromImage(new Bitmap(1, 1)))
                {
                    SizeF size = graphics.MeasureString(c.FieldName, new Font("Arial", 11, FontStyle.Regular, GraphicsUnit.Point));
                    int width = Convert.ToInt32(size.Width);
                    //width = width + Convert.ToInt32(width * 0.30);
                    c.Width = Unit.Pixel(width + 35);
                }
            }
        }
        protected void gridProcessaContabil_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                var exportMenuItem = e.Items.FindByCommand(GridViewContextMenuCommand.ExportMenu);
                //exportMenuItem.Items.Add("Custom export to XLS(WYSIWYG)", "CustomExportToXLS").Image.IconID = "export_exporttoxls_16x16";
                exportMenuItem.Items.Clear();
                exportMenuItem.Items.Add("CSV", "CSV").Image.Url = "icons/icons8-csv-30.png";
                exportMenuItem.Items.Add("XLS", "XLS").Image.Url = "icons/icons8-xls-30.png";
            }
        }
        protected void gridProcessaContabil_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            ASPxGridView grid = (sender) as ASPxGridView;
            if (e.Item.Name == "CSV")
                grid.ExportCsvToResponse(new DevExpress.XtraPrinting.CsvExportOptionsEx() { ExportType = ExportType.DataAware });
            if (e.Item.Name == "XLS")
                grid.ExportXlsToResponse(new DevExpress.XtraPrinting.XlsExportOptionsEx { ExportType = ExportType.DataAware });
        }
        protected void gridEncerramento_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                var exportMenuItem = e.Items.FindByCommand(GridViewContextMenuCommand.ExportMenu);
                //exportMenuItem.Items.Add("Custom export to XLS(WYSIWYG)", "CustomExportToXLS").Image.IconID = "export_exporttoxls_16x16";
                exportMenuItem.Items.Clear();
                exportMenuItem.Items.Add("CSV", "CSV").Image.Url = "icons/icons8-csv-30.png";
                exportMenuItem.Items.Add("XLS", "XLS").Image.Url = "icons/icons8-xls-30.png";
            }
        }
        protected void gridEncerramento_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            ASPxGridView grid = (sender) as ASPxGridView;
            if (e.Item.Name == "CSV")
                grid.ExportCsvToResponse(new DevExpress.XtraPrinting.CsvExportOptionsEx() { ExportType = ExportType.DataAware });
            if (e.Item.Name == "XLS")
                grid.ExportXlsToResponse(new DevExpress.XtraPrinting.XlsExportOptionsEx { ExportType = ExportType.DataAware });
        }
        protected void txtDataExtrato_Init(object sender, EventArgs e)
        {
            txtDataExtrato.Date = DateTime.Now;
        }
        protected void dateProcessoContabil_DateChanged(object sender, EventArgs e)
        {
            if (!ASPxCheckBox1.Checked)
            {
                string sql = "select t1.*  " +
                    "from nesta_ws_Acc_Statement t1 " +
                       ", (select internal_id, year_month, max(version) as version from nesta_ws_Acc_Statement " +
                          "where internal_id = " + hfOPIDCONT.Value + " " +
                            "group by internal_id, year_month) t2 " +
                    "where t1.internal_id = " + hfOPIDCONT.Value + " " +
                      "and t1.internal_id = t2.internal_id " +
                      "and t1.version = t2.version " +
                      "and t1.event between convert(date, '01/" + dateProcessoContabil.Text + "', 103) and DATEADD(Day,-1, DATEADD(MONTH,1, convert(date,'01/" + dateProcessoContabil.Text + "',103))) " +
                    "order by t1.year_month";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                Session["dtIntegra"] = dt;
                gridProcessaContabil.DataSource = dt;
                gridProcessaContabil.DataBind();
            }
            btnProcessoContabil.Enabled = perfil != "3";
            btnProcessoIntegrar.Enabled = perfil != "3";
        }
    }
}