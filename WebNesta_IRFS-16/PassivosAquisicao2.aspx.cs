using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using DevExpress.Export;
using DevExpress.Utils;
using DevExpress.Web;
using DevExpress.Web.Internal;

namespace WebNesta_IRFS_16
{
    public partial class PassivosAquisicao2 : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string sgbd = System.Configuration.ConfigurationManager.AppSettings["sgbd"];
        public static string lang;
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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["dtFluxoCaixa"] != null)
            {
                DataTable dt = (DataTable)Session["dtFluxoCaixa"] as DataTable;
                gridFluxoCaixa.DataSource = dt;
                gridFluxoCaixa.DataBind();
            }
            gridContabil.DataBind();
            gridExtratoFinanc.DataBind();
            ASPxGridView2.DataBind();
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
                Session["dtFluxoCaixa"] = null;
                ASPxCheckBox1.Checked = false;
                MultiView1.ActiveViewIndex = 0;
                pnlNavegacao.Visible = true;
                ASPxGridView1.FocusedRowIndex = -1;
                dropMultiView.SelectedIndex = 0;
                ASPxRadioButtonList1.SelectedIndex = 0;
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                ASPxCheckBox1.Enabled = perfil != "3";
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

            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void dropMultiView_SelectedIndexChanged(object sender, EventArgs e)
        {
            int index = 0;
            switch (dropMultiView.Value.ToString())
            {
                case "0": //Contratos
                    ASPxGridView1.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    index = 0;
                    break;
                case "1": //FluxoCaixa
                    gridFluxoCaixa.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = true;
                    index = 1;
                    break;
                case "2": //ExtratoFinanc
                    gridExtratoFinanc.DataBind();
                    pnlProcContab.Visible = false;
                    pnlProcExtrato.Visible = true;
                    pnlProcFluxo.Visible = false;
                    index = 2;
                    break;
                case "3": //Contabil
                    gridContabil.DataBind();
                    pnlProcContab.Visible = true;
                    pnlProcExtrato.Visible = false;
                    pnlProcFluxo.Visible = false;
                    index = 3;
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
        protected void btnProcExtrato_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Extrato Operacional";
            if (ASPxCheckBox1.Checked)
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
                    switch (value)
                    {
                        case "1": //Extrato        
                            if (txtDataExtrato.Text == string.Empty || txtDataExtrato.Text == "01/01/0100")
                            {
                                DataBase.Consultas.Alteracao = "Processamento Extrato Operacional Contrato #ID: " + lista[i].ToString();
                                param_dados[0] = "@p_opidcont" + "#" + lista[i].ToString();
                                param_dados[1] = "@p_TipoExtrato#205";
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
                                    DataBase.Consultas.Alteracao = "Processamento Extrato Operacional Contrato #ID: " + lista[i].ToString();
                                    param_dados[0] = "@p_opidcont" + "#" + lista[i].ToString();
                                    param_dados[1] = "@p_TipoExtrato#205";
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
                            DataBase.Consultas.Alteracao = "Processamento Extrato Operacional Contrato #ID: " + lista[i].ToString();
                            param_dados[0] = "@p_opidcont" + "#" + lista[i].ToString();
                            param_dados[1] = "@p_TipoExtrato#13";
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
                CultureInfo culture = new CultureInfo(lang);
                string value = ASPxRadioButtonList1.SelectedItem.Value.ToString();
                string[] param_dados = new string[5];
                string retorno;
                switch (value)
                {
                    case "1": //Extrato        
                        if (txtDataExtrato.Text == string.Empty || txtDataExtrato.Text == "01/01/0100")
                        {
                            DataBase.Consultas.Alteracao = "Processamento Extrato Operacional Contrato #ID: " + hfOPIDCONT.Value;
                            param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                                param_dados[1] = "@p_TipoExtrato#13";
                                param_dados[2] = "@p_Tipo#3";
                                param_dados[3] = "@p_DtLimite#";
                                param_dados[4] = "@p_GravaLog#0";
                            retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                            if (retorno == "OK")
                                MsgException(hfMsgSuccess.Value, 2);
                            else
                                MsgException(hfMsgException.Value + retorno, 1);
                        }
                        else
                        {
                            try
                            {
                                DataBase.Consultas.Alteracao = "Processamento Extrato Operacional Contrato #ID: " + hfOPIDCONT.Value;
                                param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                                param_dados[1] = "@p_TipoExtrato#13";
                                param_dados[2] = "@p_Tipo#2";
                                param_dados[3] = "@p_DtLimite#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataExtrato.Text).Day);
                                param_dados[4] = "@p_GravaLog#0";
                                retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
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
                        break;
                    case "2": //Saldo
                        DataBase.Consultas.Alteracao = "Processamento Extrato Operacional Contrato #ID: " + hfOPIDCONT.Value;
                        param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                        param_dados[1] = "@p_TipoExtrato#13";
                        param_dados[2] = "@p_Tipo#1";
                        param_dados[3] = "@p_DtLimite#";
                        param_dados[4] = "@p_GravaLog#0";
                        retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Financial_Statement", param_dados, "p_mensagem");
                        if (retorno == "OK")
                            MsgException(hfMsgSuccess.Value, 2);
                        else
                            MsgException(hfMsgException.Value + retorno, 1);

                        break;
                }
            }
        }
        protected void btnProcContab_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Contábil";
            if (ASPxCheckBox1.Checked)
            {
                if (txtDataConta.Text != string.Empty || txtDataConta.Text != "01/01/0100")
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
                            DataBase.Consultas.Alteracao = "Processamento Contabil Contrato #ID: " + opidcont;
                            param_dados[0] = "@p_opidcont" + "#" + opidcont;
                            param_dados[1] = "@p_TipoContabil#305";
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
            }
            else
            {
                if (txtDataConta.Text != string.Empty || txtDataConta.Text != "01/01/0100")
                {
                    CultureInfo culture = new CultureInfo(lang);
                    try
                    {
                        string[] param_dados = new string[4];
                        string retorno;
                        DataBase.Consultas.Alteracao = "Processamento Contabil Contrato #ID: " + hfOPIDCONT.Value;
                        param_dados[0] = "@p_opidcont" + "#" + hfOPIDCONT.Value;
                        param_dados[1] = "@p_TipoContabil#305";
                        param_dados[2] = "@p_DtLimite#" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Year) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Month) + "-" + string.Format(culture, "{0}", Convert.ToDateTime(txtDataConta.Text).Day);
                        param_dados[3] = "@p_GravaLog#0";
                        retorno = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Accounting_Statement", param_dados, "p_mensagem");
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
        protected void btnProcFluxo_Click(object sender, EventArgs e)
        {
            DataBase.Consultas.Acao = "Processamento";
            DataBase.Consultas.Resumo = "Fluxo Operacional";
            string[] param_dados = new string[3];
            if (ASPxCheckBox1.Checked)
            {
                
                int validOK = 0;
                int validERRO = 0;
                string textOK = string.Empty, textErro = string.Empty;
                var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                for (int i = 0; i < lista.Count; i++)
                {
                    string opidcont = lista[i].ToString();
                    DataBase.Consultas.Alteracao = "Processamento Fluxo Operacional Contrato #ID: " + opidcont;
                    param_dados[0] = "@p_opidcont" + "#" + opidcont;
                    param_dados[1] = "@p_TipoFluxo" + "#105";
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
                DataBase.Consultas.Alteracao = "Processamento Fluxo Operacional Contrato #ID: " + opidcont;
                param_dados[0] = "@p_opidcont" + "#" + opidcont;
                param_dados[1] = "@p_TipoFluxo" + "#105";
                param_dados[2] = "@p_GravaLog" + "#0";
                string exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Cash_Flow", param_dados, "p_mensagem");
                //string exec = DataBase.Consultas.CallProc1(str_conn, "nesta_sp_Cash_Flow", opidcont, sgbd);
                if (exec == "OK")
                {
                    MsgException(hfMsgSuccess.Value, 2);
                }
                else
                {
                    MsgException(hfMsgException.Value + exec, 1);
                }
            }
            string sqlPivot = "select distinct quotename(m.MODSMODA),m.MOIDMODA from VIOPMODA f inner join modalida m on f.moidmoda = m.moidmoda where f.OPIDCONT=" + hfOPIDCONT.Value + " order by m.MOIDMODA";
            var rPivot = DataBase.Consultas.Consulta(str_conn, sqlPivot);
            string sqlParam = string.Empty;
            foreach (DataRow row in rPivot.Rows)
            {
                sqlParam += row[0].ToString() + ",";
            }
            sqlParam = sqlParam.Substring(0, sqlParam.Length - 1);
            string sqlFluxo = "SELECT * FROM ( " +
                "SELECT f.PHDTEVEN as data, m.MODSMODA, f.PHVLAMOR " +
                "FROM PHPLANIF_OPER f " +
                "inner join modalida m on f.moidmoda=m.moidmoda " +
                "where f.opidcont=@opidcont " +
                ") AS t " +
                "PIVOT ( SUM(PHVLAMOR) FOR MODSMODA IN (@pivot)) as P ";
            sqlFluxo = sqlFluxo.Replace("@opidcont", hfOPIDCONT.Value);
            sqlFluxo = sqlFluxo.Replace("@pivot", sqlParam);
            Session["dtFluxoCaixa"] = DataBase.Consultas.Consulta(str_conn, sqlFluxo);
        }
        protected void ASPxCheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (ASPxCheckBox1.Checked)
            {
                ASPxGridView2.DataBind();
                MultiView1.ActiveViewIndex = 4;
                dropMultiView.SelectedIndex = 0;
                pnlProcContab.Visible = false;
                pnlProcExtrato.Visible = false;
                pnlProcFluxo.Visible = false;
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
                pnlProcFluxo.Visible = false;
            }
        }
        protected void ASPxGridView2_ToolbarItemClick(object source, DevExpress.Web.Data.ASPxGridViewToolbarItemClickEventArgs e)
        {

            hfMsgSuccess.Value = HttpContext.GetGlobalResourceObject("GlobalResource", "msg_alert_success").ToString();
            int validOK = 0;
            int validERRO = 0;
            string textOK = string.Empty, textErro = string.Empty;
            switch (e.Item.Name)
            {
                case "fluxo":
                    var lista = ASPxGridView2.GetSelectedFieldValues("OPIDCONT");
                    for (int i = 0; i < lista.Count; i++)
                    {
                        string opidcont = lista[i].ToString();
                        string exec = DataBase.Consultas.CallProc1(str_conn, "nesta_sp_Cash_Flow", opidcont, sgbd);
                        if (exec == "OK")
                        {
                            validOK = validOK + 1;
                            textOK += opidcont + ",";

                        }
                        else
                        {
                            validERRO = validERRO + 1;
                            textErro += opidcont + ",";
                        }
                    }
                    break;
            }
            if (textOK.Length != 0)
                textOK = textOK.Substring(0, textOK.Length - 1);
            if (textErro.Length != 0)
                textErro = textErro.Substring(0, textErro.Length - 1);
            string erro = validERRO == 0 ? "" : hfMsgException.Value + "<br />#ID:" + textErro;
            string ok = validOK == 0 ? "" : hfMsgSuccess.Value + "<br />#ID:" + textOK;
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
        }
        protected void ASPxGridView2_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (ASPxGridView2.GetSelectedFieldValues("OPIDCONT").Count() > 0)
            {
                switch (e.Parameters)
                {
                    case "fluxo": //FluxoCaixa
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = true;
                        btnProcFluxo.Enabled = true;
                        dropMultiView.SelectedIndex = 1;
                        break;
                    case "extrato": //ExtratoFinanc
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = true;
                        pnlProcFluxo.Visible = false;
                        btnProcExtrato.Enabled = true;
                        dropMultiView.SelectedIndex = 2;
                        break;
                    case "contabil": //Contabil
                        pnlProcContab.Visible = true;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        btnProcContab.Enabled = true;
                        dropMultiView.SelectedIndex = 3;
                        break;
                }
            }
            else
            {
                pnlProcContab.Visible = false;
                pnlProcExtrato.Visible = false;
                pnlProcFluxo.Visible = false;
                btnProcContab.Enabled = false;
                btnProcExtrato.Enabled = false;
                btnProcFluxo.Enabled = false;
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
            string sqlPivot = "select distinct quotename(m.MODSMODA),m.MOIDMODA from VIOPMODA f inner join modalida m on f.moidmoda = m.moidmoda where f.OPIDCONT=" + hfOPIDCONT.Value + " order by m.MOIDMODA";
            var rPivot = DataBase.Consultas.Consulta(str_conn, sqlPivot);
            if (rPivot.Rows.Count == 0) return;
            string sqlParam = string.Empty;
            foreach(DataRow row in rPivot.Rows)
            {
                sqlParam += row[0].ToString() + ",";
            }
            sqlParam = sqlParam.Substring(0, sqlParam.Length - 1);
            string sqlFluxo = "SELECT * FROM ( " +
                "SELECT f.PHDTEVEN as data, m.MODSMODA, f.PHVLAMOR " +
                "FROM PHPLANIF_OPER f " +
                "inner join modalida m on f.moidmoda=m.moidmoda " +
                "where f.opidcont=@opidcont " +
                ") AS t " +
                "PIVOT ( SUM(PHVLAMOR) FOR MODSMODA IN (@pivot)) as P ";
            sqlFluxo = sqlFluxo.Replace("@opidcont", hfOPIDCONT.Value);
            sqlFluxo = sqlFluxo.Replace("@pivot", sqlParam);
            Session["dtFluxoCaixa"] = DataBase.Consultas.Consulta(str_conn,sqlFluxo);
            txtOper.Text = ASPxGridView1.GetRowValues(Index, "OPCDCONT").ToString();
            txtDesc.Text = ASPxGridView1.GetRowValues(Index, "OPNMCONT").ToString();
            txtIndice.Text = ASPxGridView1.GetRowValues(Index, "IENMINEC").ToString();
            txtContra.Text = ASPxGridView1.GetRowValues(Index, "FONMAB20").ToString();
            dropMultiView.Enabled = true;
            pnlNavegacao.Visible = true;
            btnProcFluxo.Enabled = true;
            btnProcExtrato.Enabled = true;
            btnProcContab.Enabled = true;
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
                        btnProcFluxo.Enabled = true;
                        dropMultiView.SelectedIndex = 1;
                        break;
                    case "extrato": //ExtratoFinanc
                        pnlProcContab.Visible = false;
                        pnlProcExtrato.Visible = true;
                        pnlProcFluxo.Visible = false;
                        btnProcExtrato.Enabled = true;
                        dropMultiView.SelectedIndex = 2;
                        break;
                    case "contabil": //Contabil
                        pnlProcContab.Visible = true;
                        pnlProcExtrato.Visible = false;
                        pnlProcFluxo.Visible = false;
                        btnProcContab.Enabled = true;
                        dropMultiView.SelectedIndex = 3;
                        break;
                }
            }
            else
            {
                pnlProcContab.Visible = false;
                pnlProcExtrato.Visible = false;
                pnlProcFluxo.Visible = false;
                btnProcContab.Enabled = false;
                btnProcExtrato.Enabled = false;
                btnProcFluxo.Enabled = false;
                dropMultiView.SelectedIndex = 0;
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
        protected void gridFluxoCaixa_Load(object sender, EventArgs e)
        {
            if(Session["dtFluxoCaixa"]!= null)
            {
                DataTable dt = (DataTable)Session["dtFluxoCaixa"] as DataTable;
                DataTable dtClone = dt.Clone();
                dtClone.Columns["data"].DataType = typeof(DateTime);
                foreach(DataRow row in dt.Rows)
                {
                    dtClone.ImportRow(row);
                }
                Session["dtFluxoCaixa"] = dtClone;
                gridFluxoCaixa.DataSource = dtClone;
                gridFluxoCaixa.DataBind();
            }
        }
        protected void gridFluxoCaixa_DataBinding(object sender, EventArgs e)
        {
            int widthDefault = 80;
            int widthTotal = 25;
            gridFluxoCaixa.Columns.Clear();
            gridFluxoCaixa.TotalSummary.Clear();
            if (Session["dtFluxoCaixa"] != null)
            {
                DataTable dt = (DataTable)Session["dtFluxoCaixa"] as DataTable;
                int index = 0;
                foreach(DataColumn column in dt.Columns)
                {
                    if(column.Caption=="data")
                    {
                        GridViewDataDateColumn c = new GridViewDataDateColumn();
                        c.FieldName = column.Caption;
                        c.Caption = "Data";
                        c.PropertiesDateEdit.DisplayFormatString = "d";
                        c.ReadOnly = true;
                        c.VisibleIndex = index;

                        float width = getTextSize(c.Caption + "000");
                        c.Width = Unit.Pixel(Convert.ToInt32(width));
                        
                        gridFluxoCaixa.Columns.Add(c);
                        widthTotal = widthTotal + Convert.ToInt32(width);
                    }
                    else
                    {
                        GridViewDataTextColumn c = new GridViewDataTextColumn();
                        c.FieldName = column.Caption;
                        c.Caption = column.Caption;
                        c.PropertiesTextEdit.DisplayFormatString = "N2";
                        c.ReadOnly = true;
                        c.PropertiesTextEdit.NullDisplayText = "0,00";
                        c.VisibleIndex = index;

                        float width = getTextSize(c.Caption + "000");
                        c.Width = Unit.Pixel(Convert.ToInt32(width));

                        gridFluxoCaixa.Columns.Add(c);
                        ASPxSummaryItem sum = new ASPxSummaryItem();
                        sum.FieldName= column.Caption;
                        sum.DisplayFormat = "N2";
                        sum.SummaryType = DevExpress.Data.SummaryItemType.Sum;
                        gridFluxoCaixa.TotalSummary.Add(sum);
                        widthTotal = widthTotal + Convert.ToInt32(width);
                    }
                    index++;
                }
                gridFluxoCaixa.Width = Unit.Pixel(widthTotal);
            }
        }
        protected void btnProcFluxo_Load(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            btnProcFluxo.Enabled = perfil != "3";
        }
        protected void btnProcExtrato_Load(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            btnProcExtrato.Enabled = perfil != "3";
        }
        protected void btnProcContab_Load(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            btnProcContab.Enabled = perfil != "3";
        }
        private float getTextSize(string text)
        {
            Font font = new Font("Courier New", 10.0F);
            System.Drawing.Image fakeImage = new Bitmap(1, 1);
            Graphics graphics = Graphics.FromImage(fakeImage);
            SizeF size = graphics.MeasureString(text, font);
            return size.Width;
        }
        protected void gridContratoFilho_BeforePerformDataSelect(object sender, EventArgs e)
        {
            hfMasterRow.Value = (sender as ASPxGridView).GetMasterRowKeyValue().ToString();
            string key = (sender as ASPxGridView).GetMasterRowKeyValue().ToString();
            sqlContratoFilho.SelectParameters[0].DefaultValue = key;
            string valida = "";
            if (valida == "")
                return;
        }
        protected void ASPxGridView1_DetailRowGetButtonVisibility(object sender, ASPxGridViewDetailRowButtonEventArgs e)
        {
            string opidcont = ASPxGridView1.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString();
            bool umbrella = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select OPTPTPID from OPCONTRA where OPIDCONT="+opidcont, 1)[0]) == 91;
            if (!umbrella)
                e.ButtonState = GridViewDetailRowButtonState.Hidden;
        }
        protected void btnSelect3_Click(object sender, EventArgs e)
        {
            int MasterIndex = Convert.ToInt32(ASPxGridView1.FindVisibleIndexByKeyValue(hfMasterRow.Value));
            ASPxGridView grid = ASPxGridView1.FindDetailRowTemplateControl(MasterIndex, "gridContratoFilho") as ASPxGridView;
            int Index = Convert.ToInt32(grid.FocusedRowIndex);
            hfOPIDCONT.Value = grid.GetRowValues(Index, "OPIDCONT").ToString();
            txtOPIDCONT.Text = grid.GetRowValues(Index, "OPIDCONT").ToString();
            string sqlPivot = "select distinct quotename(m.MODSMODA),m.MOIDMODA from VIOPMODA f inner join modalida m on f.moidmoda = m.moidmoda where f.OPIDCONT=" + hfOPIDCONT.Value + " order by m.MOIDMODA";
            var rPivot = DataBase.Consultas.Consulta(str_conn, sqlPivot);
            if (rPivot.Rows.Count == 0) return;
            string sqlParam = string.Empty;
            foreach (DataRow row in rPivot.Rows)
            {
                sqlParam += row[0].ToString() + ",";
            }
            sqlParam = sqlParam.Substring(0, sqlParam.Length - 1);
            string sqlFluxo = "SELECT * FROM ( " +
                "SELECT f.PHDTEVEN as data, m.MODSMODA, f.PHVLAMOR " +
                "FROM PHPLANIF_OPER f " +
                "inner join modalida m on f.moidmoda=m.moidmoda " +
                "where f.opidcont=@opidcont " +
                ") AS t " +
                "PIVOT ( SUM(PHVLAMOR) FOR MODSMODA IN (@pivot)) as P ";
            sqlFluxo = sqlFluxo.Replace("@opidcont", hfOPIDCONT.Value);
            sqlFluxo = sqlFluxo.Replace("@pivot", sqlParam);
            Session["dtFluxoCaixa"] = DataBase.Consultas.Consulta(str_conn, sqlFluxo);
            txtOper.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
            txtDesc.Text = grid.GetRowValues(Index, "OPNMCONT").ToString();
            txtIndice.Text = grid.GetRowValues(Index, "IENMINEC").ToString();
            txtContra.Text = grid.GetRowValues(Index, "FONMAB20").ToString();
            dropMultiView.Enabled = true;
            pnlNavegacao.Visible = true;
            btnProcFluxo.Enabled = true;
            btnProcExtrato.Enabled = true;
            btnProcContab.Enabled = true;
        }
    }
}