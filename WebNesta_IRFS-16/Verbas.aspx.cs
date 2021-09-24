using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Verbas : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string perfil;
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Request.QueryString.Count > 0)
                currentPage = Request.QueryString["naviBefore"];
            else if (Request.QueryString.Count == 0)
                currentPage = "Default";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void MsgException(string msg, int exc, string curr)
        {
            if (exc == 1)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = "Exception: " + msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 0)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "2";
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 3)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void btnInserir_Click(object sender, EventArgs e)
        {
            hfOperacao.Value = "Inserir";
            txtDesc.Enabled = true;
            txtDesc.Text = string.Empty;
            txtVaria.Enabled = true;
            txtVaria.Text = string.Empty;
            txtPerVaria.Enabled = true;
            txtPerVaria.Text = string.Empty;
            dropClass.Enabled = true;
            dropClass.Value = string.Empty;
            dropIFRS.Enabled = true;
            dropIFRS.Value = string.Empty;
            dropTipo.Enabled = true;
            dropTipo.Value = string.Empty;
            dropTempo.Enabled = true;
            dropTempo.Value = string.Empty;
            dropRecupera.Enabled = true;
            dropRecupera.Value = string.Empty;
            dropPeriodi.Enabled = true;
            dropPeriodi.Value = string.Empty;
            dropCalc.Enabled = true;
            dropCalc.Value = string.Empty;            
            dropImposto.Enabled = true;
            dropImposto.Value = string.Empty;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            reqDesc.Enabled = true;
            reqDesc2.Enabled = true;
            reqIFRS.Enabled = true;
            reqClass.Enabled = true;
            reqTipo.Enabled = true;
            reqTempo.Enabled = true;
            reqCalc.Enabled = true;
            reqRecupera.Enabled = true;
            reqPeriodi.Enabled = true;
            reqImposto.Enabled = true;
        }
        protected void dropVerbas_SelectedIndexChanged(object sender, EventArgs e)
        {
            hfMOIDMODA.Value= dropVerbas.Value.ToString();
            string sql = "select MOIDMODA, MODSMODA,MOIFRSMO,LAYIDCLA,MOTIPOVALO,MOTEMPMODA,MORECUPMOD,MOPERIOMOD,MOCALCMO,MOVARPER,MOVARTIM,MOCDMODA from modalida where MOIDMODA="+dropVerbas.Value;
            var result = DataBase.Consultas.Consulta(str_conn, sql, 12);
            txtDesc.Text = result[1].ToString();
            dropClass.Value = result[3].ToString();
            dropIFRS.Value = result[2].ToString();
            dropTipo.Value = result[4].ToString();
            dropTempo.Value = result[5].ToString();
            dropRecupera.Value = result[6].ToString();
            dropPeriodi.Value = result[7].ToString();
            dropCalc.Value = result[8].ToString();
            dropImposto.Value = result[11].ToString();
            txtVaria.Text = result[9].ToString();
            txtPerVaria.Text = result[10].ToString();
            btnAlterar.Enabled = perfil != "3";
            btnInserir.Enabled = false;
        }
        protected void btnAlterar_Click(object sender, EventArgs e)
        {
            hfOperacao.Value = "Alterar";
            txtDesc.Enabled = false;
            txtVaria.Enabled = true;
            txtPerVaria.Enabled = true;
            dropClass.Enabled = true;
            dropIFRS.Enabled = true;
            dropTipo.Enabled = true;
            dropTempo.Enabled = true;
            dropRecupera.Enabled = true;
            dropPeriodi.Enabled = true;
            dropCalc.Enabled = true;
            dropImposto.Enabled = true;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            reqDesc.Enabled = false;
            reqDesc2.Enabled = false;
            reqIFRS.Enabled = true;
            reqClass.Enabled = true;
            reqTipo.Enabled = true;
            reqTempo.Enabled = true;
            reqRecupera.Enabled = true;
            reqPeriodi.Enabled = true;
            reqCalc.Enabled = true;
            reqImposto.Enabled = true;
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            string exec = string.Empty;
            switch (hfOperacao.Value)
            {
                case "Inserir":
                    if (Page.IsValid)
                    {
                        string sqlInsert = "INSERT INTO MODALIDA (MOIDMODA, MODSMODA, MOTPIDCA, MOFLPADR, MOIDORDE, MOIFRSMO, LAYIDCLA,MOTIPOVALO,MOTEMPMODA,MORECUPMOD,MOPERIOMOD,MOCALCMO,MOVARPER,MOVARTIM,MOCDMODA) VALUES ((select max(moidmoda) + 1 from modalida),'@MODSMODA',10,1,0,@MOIFRSMO,@LAYIDCLA,@MOTIPOVALO,@MOTEMPMODA,@MORECUPMOD,'@MOPERIOMOD',@MOCALCMO,@MOVARPER,@MOVARTIM,@MOCDMODA)";
                        sqlInsert = sqlInsert.Replace("@MODSMODA", txtDesc.Text);
                        sqlInsert = sqlInsert.Replace("@MOIFRSMO", dropIFRS.Value.ToString());
                        sqlInsert = sqlInsert.Replace("@LAYIDCLA", dropClass.Value.ToString());
                        sqlInsert = sqlInsert.Replace("@MOTIPOVALO", dropTipo.Value.ToString());
                        sqlInsert = sqlInsert.Replace("@MOTEMPMODA", dropTempo.Value.ToString());
                        sqlInsert = sqlInsert.Replace("@MORECUPMOD", dropRecupera.Value.ToString());
                        sqlInsert = sqlInsert.Replace("@MOPERIOMOD", dropPeriodi.Value.ToString());
                        sqlInsert = sqlInsert.Replace("@MOCALCMO", dropCalc.Value.ToString());
                        sqlInsert = sqlInsert.Replace("@MOVARPER", txtVaria.Text.Replace(",","."));
                        sqlInsert = sqlInsert.Replace("@MOVARTIM", txtPerVaria.Text);
                        sqlInsert = sqlInsert.Replace("@MOCDMODA", dropImposto.Value.ToString());
                        exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                        if (exec == "OK")
                        {
                            dropVerbas.DataBind();
                            txtDesc.Enabled = false;
                            txtVaria.Enabled = false;
                            txtPerVaria.Enabled = false;
                            dropClass.Enabled = false;
                            dropIFRS.Enabled = false;
                            dropTipo.Enabled = false;
                            dropTempo.Enabled = false;
                            dropRecupera.Enabled = false;
                            dropPeriodi.Enabled = false;
                            dropCalc.Enabled = false;
                            dropImposto.Enabled = false;
                            btnOK.Enabled = false;
                            btnCancelar.Enabled = false;
                        }
                        else
                        {

                        }
                    }
                    break;
                case "Alterar":
                    string sqlUpdate = "UPDATE MODALIDA SET MOIFRSMO = @MOIFRSMO,LAYIDCLA = @LAYIDCLA,MOTIPOVALO=@MOTIPOVALO,MOTEMPMODA=@MOTEMPMODA,MORECUPMOD=@MORECUPMOD,MOPERIOMOD='@MOPERIOMOD',MOCALCMO=@MOCALCMO,MOVARPER=@MOVARPER,MOVARTIM=@MOVARTIM,MOCDMODA=@MOCDMODA WHERE MOIDMODA=" + hfMOIDMODA.Value;
                    sqlUpdate = sqlUpdate.Replace("@MOIFRSMO", dropIFRS.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@LAYIDCLA", dropClass.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@MOTIPOVALO", dropTipo.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@MOTEMPMODA", dropTempo.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@MORECUPMOD", dropRecupera.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@MOPERIOMOD", dropPeriodi.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@MOCALCMO", dropCalc.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@MOVARPER", txtVaria.Text.Replace(",", "."));
                    sqlUpdate = sqlUpdate.Replace("@MOVARTIM", txtPerVaria.Text);
                    sqlUpdate = sqlUpdate.Replace("@MOCDMODA", dropImposto.Value.ToString());
                    exec = DataBase.Consultas.UpdtFrom(str_conn,sqlUpdate);
                    if(exec =="OK")
                    {
                        dropVerbas.DataBind();
                        txtDesc.Enabled = false;
                        txtVaria.Enabled = false;
                        txtPerVaria.Enabled = false;
                        dropClass.Enabled = false;
                        dropIFRS.Enabled = false;
                        dropTipo.Enabled = false;
                        dropTempo.Enabled = false;
                        dropRecupera.Enabled = false;
                        dropPeriodi.Enabled = false;
                        dropCalc.Enabled = false;
                        dropImposto.Enabled = false;
                        btnOK.Enabled = false;
                        btnCancelar.Enabled = false;
                    }
                    else
                    {

                    }
                    break;
            }
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            switch (hfOperacao.Value)
            {
                case "Alterar":
                    Response.Redirect(currentPage);
                    break;
                case "Inserir":
                    Response.Redirect(currentPage);
                    break;
                case "excluir":
                    Response.Redirect("Verbas");
                    break;
            }
        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            bool existe = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from modalida m where MOTPIDCA=10 and UPPER(MODSMODA)='"+txtDesc.Text.ToUpper()+"'", 1)[0]) == 0 ? false : true;
            if(existe)
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
        protected void btnInserir_Load(object sender, EventArgs e)
        {
            Button obj = (Button)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
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