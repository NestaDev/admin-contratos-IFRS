using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class UserProfile : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public bool senhaPadrao;
        public static string lang;
        public static CultureInfo culture;
        protected void Page_Load(object sender, EventArgs e)
        {
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
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                foreach (DevExpress.Web.MenuItem item in menuUserProfile.Items)
                {
                    if (item.Name=="0")
                    {
                        item.Selected = true;
                        break;
                    }
                }
                PanelView.ActiveViewIndex = 0;
                var resultDados = DataBase.Consultas.Consulta(str_conn, "select USNUMCEL,USLANGUE from TUSUSUARI where USIDUSUA='"+hfUser.Value+"'",2);
                txtNumWhats.Text = resultDados[0];
                dropIdioma.Value = resultDados[1].IndexOf('-')>=0? resultDados[1]:"";
            }
            var menuitem = menuUserProfile.Items.FindByName("1");
            var lbl = (Label)menuitem.FindControl("lblNotifiesQtd");
            string sqlNotifies = "select count(*) from WFWFCHAT WHERE USIDUSUA2='" + hfUser.Value + "' AND WFDTDATA IS NULL";
            int result = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlNotifies, 1)[0]);
            if (result > 0)
            {
                lbl.Text = result.ToString();
            }
            else
            {
                lbl.Text = string.Empty;
            }
            if (Session["senhaPadrao"] != null)
            {
                senhaPadrao = Convert.ToBoolean(Session["senhaPadrao"]);
            }
            if(!IsPostBack && senhaPadrao)
            {
                foreach (DevExpress.Web.MenuItem item in menuUserProfile.Items)
                {
                    if (item.Name == "0")
                    {
                        item.Selected = true;
                        break;
                    }
                }
                PanelView.ActiveViewIndex = 0;
                checkSenha.Checked = true;
                txtPwd.ClientEnabled = true;
                txtPwd1.ClientEnabled = true;
                txtPwd2.ClientEnabled = true;
                lblSenhaPadrao.Visible = true;
            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void menuUserProfile_ItemClick(object source, DevExpress.Web.MenuItemEventArgs e)
        {
            int panelIndex = Convert.ToInt32(e.Item.Name);
            PanelView.ActiveViewIndex = panelIndex;
        }

        protected void gridNotifies_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.Parameters);
            bool lido = gridNotifies.GetRowValues(rowIndex, "WFDTDATA").ToString() != string.Empty;
            if (!lido)
            {
                string sqlUpd = "update WFWFCHAT set WFDTDATA=GetDate() WHERE WFIDCHAT="+ gridNotifies.GetRowValues(rowIndex, "WFIDCHAT").ToString() + "";
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
            }            
        }
        protected void gridNotifies_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            bool lido = gridNotifies.GetRowValues(e.VisibleIndex, "WFDTDATA").ToString()!=string.Empty;
            if (!lido)
            {
                e.Row.ToolTip = "Clique duas vezes para confirmar a leitura desta notificação";
                e.Row.Font.Bold = true;
            }
        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string sqlCheck = "select count(*) from ututisen with (nolock) where usidusua = '" + hfUser.Value + "' " +
                            "and utdtinic >= dateadd(year, -1, convert(date, GetDate())) "+
                            "and uscdseus = dbo.nesta_fn_Criptografa('"+ txtPwd1.Text + "')";
            if(dropIdioma.Value==null)
            {
                CustomValidator1.ErrorMessage = HttpContext.GetGlobalResourceObject("UserProfile", "CustomValidator1-4").ToString();
                args.IsValid = false;
            }
            if (checkSenha.Checked)
            {
                bool SenhaAtual = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "SELECT [dbo].[nesta_fn_Credencial_Valida] ('" + hfUser.Value + "','" + txtPwd.Text + "')", 1)[0]) == 1;
                if (SenhaAtual)
                {
                    if ((txtPwd1.Text == txtPwd2.Text) && senhaPadrao)
                    {
                        bool validaSenha = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn,sqlCheck,1)[0]) == 0;
                        if(validaSenha)
                            args.IsValid = true;
                        else
                        {
                            CustomValidator1.ErrorMessage = HttpContext.GetGlobalResourceObject("UserProfile", "CustomValidator1-3").ToString();
                            args.IsValid = false;
                        }
                    }
                    else if (txtPwd1.Text == txtPwd2.Text)
                    {
                        args.IsValid = true;
                    }
                    else if(txtPwd1.Text != txtPwd2.Text)
                    {
                        CustomValidator1.ErrorMessage = HttpContext.GetGlobalResourceObject("UserProfile", "CustomValidator1-1").ToString();
                        args.IsValid = false;
                    }
                }
                else
                {
                    CustomValidator1.ErrorMessage = HttpContext.GetGlobalResourceObject("UserProfile", "CustomValidator1-2").ToString();
                    args.IsValid = false;
                }
            }
        }
        protected void AcaoSenhaNova(object sender, CommandEventArgs args)
        {
            DataBase.Consultas.Acao = "Cadastro Usuário";
            string[] param_dados = new string[4];
            param_dados[3] = "@p_idioma#" + culture.ToString();
            switch (args.CommandArgument.ToString())
            {
                case "ok":
                    lblMsgErro.Text = "";
                    lblMsgErro.Visible = false;
                    if (Page.IsValid)
                    {
                        if (checkSenha.Checked && senhaPadrao)
                        {
                            DataBase.Consultas.Resumo = "Alteração de Senha Padrão";
                            DataBase.Consultas.Alteracao = "Alteração de Senha de acesso ao sistema.";
                            param_dados[0] = "@p_User#" + hfUser.Value;
                            param_dados[1] = "@p_Pass#" + txtPwd2.Text;
                            param_dados[2] = "@p_Reset#2";
                            //string sqlUpd = "UPDATE TUSUSUARI SET USNUMCEL='" + txtNumWhats.Text.Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "") + "',USLANGUE='" + dropIdioma.SelectedItem.Value.ToString() + "' where USIDUSUA='" + hfUser.Value + "'";
                            string sqlUpd = "UPDATE TUSUSUARI SET USNUMCEL='" + txtNumWhats.Text.Replace(" ", "") + "',USLANGUE='" + dropIdioma.SelectedItem.Value.ToString() + "' where USIDUSUA='" + hfUser.Value + "'";
                            string sqlUs1 = "update TUSUSUARI set USCDSEUS=(SELECT [dbo].[nesta_fn_Criptografa] ('" + txtPwd2.Text + "')) where USIDUSUA='" + hfUser.Value + "'";
                            string sqlUs2 = "update UTUTISEN set USCDSEUS=(SELECT [dbo].[nesta_fn_Criptografa] ('" + txtPwd2.Text + "')) where USIDUSUA='" + hfUser.Value + "'";
                            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                            if (exec == "OK")
                            {
                                exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUs1);
                                if (exec == "OK")
                                {
                                    //exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUs2);
                                    exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Reset_Credential", param_dados, "p_mensagem");
                                    if (exec == "OK")
                                    {
                                        txtPwd.Text = string.Empty;
                                        txtPwd1.Text = string.Empty;
                                        txtPwd2.Text = string.Empty;
                                        checkSenha.Checked = false;
                                        Response.Redirect("Default");
                                    }
                                    else
                                    {
                                        lblSenhaValida.Visible = false;
                                        checkSenha.Checked = false;
                                        lblMsgErro.Text = exec;
                                        lblMsgErro.Visible = true;
                                    }
                                }
                            }
                        }
                        else if (checkSenha.Checked)
                        {
                            DataBase.Consultas.Resumo = "Alteração de Senha";
                            DataBase.Consultas.Alteracao = "Alteração de Senha de acesso ao sistema.";
                            param_dados[0] = "@p_User#" + hfUser.Value;
                            param_dados[1] = "@p_Pass#" + txtPwd2.Text;
                            param_dados[2] = "@p_Reset#3";
                            //string sqlUpd = "UPDATE TUSUSUARI SET USNUMCEL='" + txtNumWhats.Text.Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "") + "',USLANGUE='" + dropIdioma.SelectedItem.Value.ToString() + "' where USIDUSUA='" + hfUser.Value + "'";
                            string sqlUpd = "UPDATE TUSUSUARI SET USNUMCEL='" + txtNumWhats.Text.Replace(" ", "") + "',USLANGUE='" + dropIdioma.SelectedItem.Value.ToString() + "' where USIDUSUA='" + hfUser.Value + "'";
                            string sqlUs1 = "update TUSUSUARI set USCDSEUS=(SELECT [dbo].[nesta_fn_Criptografa] ('" + txtPwd2.Text + "')) where USIDUSUA='" + hfUser.Value + "'";
                            string sqlUs2 = "update UTUTISEN set USCDSEUS=(SELECT [dbo].[nesta_fn_Criptografa] ('" + txtPwd2.Text + "')) where USIDUSUA='" + hfUser.Value + "'";
                            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                            if (exec == "OK")
                            {
                                exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUs1);
                                if (exec == "OK")
                                {
                                    //exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUs2);
                                    exec = DataBase.Consultas.ExecProcedure(str_conn, "nesta_sp_Reset_Credential", param_dados, "p_mensagem");
                                    if (exec == "OK")
                                    {
                                        txtPwd.Text = string.Empty;
                                        txtPwd1.Text = string.Empty;
                                        txtPwd2.Text = string.Empty;
                                        checkSenha.Checked = false;
                                        lblSenhaValida.Text = "Senha alterada.";
                                        lblSenhaValida.Visible = true;
                                    }
                                    else
                                    {
                                        lblSenhaValida.Visible = false;
                                        checkSenha.Checked = false;
                                        lblMsgErro.Text = exec;
                                        lblMsgErro.Visible = true;
                                    }
                                }
                            }
                        }
                        else
                        {
                            //string sqlUpd = "UPDATE TUSUSUARI SET USNUMCEL='" + txtNumWhats.Text.Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "") + "',USLANGUE='" + dropIdioma.SelectedItem.Value.ToString() + "' where USIDUSUA='" + hfUser.Value + "'";
                            string sqlUpd = "UPDATE TUSUSUARI SET USNUMCEL='" + txtNumWhats.Text.Replace(" ","") + "',USLANGUE='" + dropIdioma.SelectedItem.Value.ToString() + "' where USIDUSUA='" + hfUser.Value + "'";
                            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                            if (exec == "OK")
                            {
                                Response.Redirect(Request.Url.Segments[Request.Url.Segments.Length - 1]);
                            }
                        }
                    }
                    break;
                case "cancelar":
                    txtPwd.Text = string.Empty;
                    txtPwd1.Text = string.Empty;
                    txtPwd2.Text = string.Empty;
                    lblSenhaValida.Text = string.Empty;
                    break;
            }            
        }
    }
}