using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Book : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string perfil;
        public static bool AcessoInternet;
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
            if (!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                if (Session["dtIntervalos"] != null)
                    Session["dtIntervalos"] = null;
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
        protected void BotoesOperacao(object sender, CommandEventArgs args)
        {
            Session["Operacao"] = args.CommandArgument.ToString();
            switch (Session["Operacao"].ToString())
            {
                case "inserir":
                    txtNome.Enabled = true;
                    txtNome20.Enabled = true;
                    btnInserir.Enabled = false;
                    btnAlterar.Enabled = false;
                    btnExcluir.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    break;
                case "alterar":
                    txtNome.Enabled = true;
                    txtNome20.Enabled = true;
                    gridAssociadas.Enabled = true;
                    gridDisponiveis.Enabled = true;
                    btnAlterar.Enabled = false;
                    btnExcluir.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    break;
                case "excluir":
                    btnAlterar.Enabled = false;
                    btnExcluir.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    break;
            }
        }
        protected void dropListagemIndices_SelectedIndexChanged(object sender, EventArgs e)
        {
            hfBOIDBOOK.Value = dropListagemIndices.SelectedItem.Value.ToString();
            var result = DataBase.Consultas.Consulta(str_conn, "select BODSBOOK,BOCDAB20 from BOBOBOOK where BOIDBOOK="+hfBOIDBOOK.Value,2);
            txtNome.Text = result[0];
            txtNome20.Text = result[1];
            gridAssociadas.DataBind();
            gridDisponiveis.DataBind();
            btnInserir.Enabled = false;
            btnAlterar.Enabled = perfil != "3";
            btnExcluir.Enabled = perfil != "3";
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            string BOIDBOOK, BODSBOOK, BOCDAB20, sqlns, exec1;
            switch (Session["Operacao"].ToString())
            {
                case "inserir":
                    BOIDBOOK = DataBase.Consultas.Consulta(str_conn, "select max(boidbook)+1 from BOBOBOOK", 1)[0];
                    hfBOIDBOOK.Value = BOIDBOOK;
                    BODSBOOK = txtNome.Text;
                    BOCDAB20 = txtNome20.Text;
                    sqlns = "INSERT INTO BOBOBOOK (BOIDBOOK,BODSBOOK,BOCDAB20) "+
                                    "VALUES(@BOIDBOOK, '@BODSBOOK', '@BOCDAB20')";
                    sqlns = sqlns.Replace("@BOIDBOOK",BOIDBOOK);
                    sqlns = sqlns.Replace("@BODSBOOK", BODSBOOK);
                    sqlns = sqlns.Replace("@BOCDAB20", BOCDAB20);
                    exec1 = DataBase.Consultas.InsertInto(str_conn,sqlns);
                    if(exec1=="OK")
                    {
                        txtNome.Enabled = false;
                        txtNome20.Enabled = false;
                        btnInserir.Enabled = false;
                        btnAlterar.Enabled = false;
                        btnExcluir.Enabled = false;
                        btnOK.Enabled = false;
                        btnCancelar.Enabled = false;
                        gridAssociadas.Enabled = true;
                        gridDisponiveis.Enabled = true;
                        dropListagemIndices.DataBind();
                    }                    
                    break;
                case "alterar":
                    BOIDBOOK = hfBOIDBOOK.Value;
                    BODSBOOK = txtNome.Text;
                    BOCDAB20 = txtNome20.Text;
                    sqlns = "UPDATE BOBOBOOK "+
                               "SET BODSBOOK = '@BODSBOOK' "+
                                  ", BOCDAB20 = '@BOCDAB20' "+
                             "WHERE BOIDBOOK = @BOIDBOOK";
                    sqlns = sqlns.Replace("@BOIDBOOK", BOIDBOOK);
                    sqlns = sqlns.Replace("@BODSBOOK", BODSBOOK);
                    sqlns = sqlns.Replace("@BOCDAB20", BOCDAB20);
                    exec1 = DataBase.Consultas.InsertInto(str_conn, sqlns);
                    if (exec1 == "OK")
                    {
                        txtNome.Enabled = false;
                        txtNome20.Enabled = false;
                        btnInserir.Enabled = false;
                        btnAlterar.Enabled = false;
                        btnExcluir.Enabled = false;
                        btnOK.Enabled = false;
                        btnCancelar.Enabled = false;
                        gridAssociadas.Enabled = true;
                        gridDisponiveis.Enabled = true;

                    }
                    break;
                case "excluir":
                    BOIDBOOK = hfBOIDBOOK.Value;
                    sqlns = "DELETE BOBOBOOK " +
                             "WHERE BOIDBOOK = @BOIDBOOK";
                    sqlns = sqlns.Replace("@BOIDBOOK", BOIDBOOK);
                    bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from ETTJETTJ where BOIDBOOK="+BOIDBOOK, 1)[0]) == 0;
                    if (valida)
                    {
                        exec1 = DataBase.Consultas.InsertInto(str_conn, sqlns);
                        if (exec1 == "OK")
                        {
                            sqlns = "DELETE VIBOOCAR " +
                                    "WHERE BOIDBOOK = @BOIDBOOK";
                            sqlns = sqlns.Replace("@BOIDBOOK", BOIDBOOK);
                            exec1 = DataBase.Consultas.InsertInto(str_conn, sqlns);
                            if (exec1 == "OK")
                            {
                                Response.Redirect("Book");
                            }
                        }
                    }
                    else
                    {
                        MsgException("Exclusão não pode prosseguir pois existem itens associados.", 1, "");
                    }
                    break;
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            if (Session["Operacao"] == null)
            {
                Response.Redirect("Book");
            }
            else
            {
                Response.Redirect(currentPage);
            }
        }

        protected void gridAssociadas_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            string acao = e.Parameters.Split('#')[0];
            int Index = Convert.ToInt32(e.Parameters.Split('#')[1]);
            if(acao=="delete")
            {
                string BOIDBOOK = hfBOIDBOOK.Value;
                string CAIDCTRA = gridAssociadas.GetRowValues(Index, "CAIDCTRA").ToString();
                string sql = "DELETE VIBOOCAR  " +
                            "WHERE BOIDBOOK = @BOIDBOOK AND CAIDCTRA = @CAIDCTRA";
                sql = sql.Replace("@BOIDBOOK", BOIDBOOK);
                sql = sql.Replace("@CAIDCTRA", CAIDCTRA);
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
                if (exec == "OK")
                {
                    gridAssociadas.JSProperties["cp_ok"] = "OK";
                    gridDisponiveis.JSProperties["cp_ok"] = "OK";
                    gridAssociadas.DataBind();
                    gridDisponiveis.DataBind();
                }
            }
        }

        protected void gridDisponiveis_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            string acao = e.Parameters.Split('#')[0];
            int Index = Convert.ToInt32(e.Parameters.Split('#')[1]);
            if(acao=="assoc")
            {
                string BOIDBOOK = hfBOIDBOOK.Value;
                string CAIDCTRA = gridDisponiveis.GetRowValues(Index, "CAIDCTRA").ToString();
                string sql = "INSERT INTO VIBOOCAR (BOIDBOOK ,CAIDCTRA) " +
                            "VALUES(@BOIDBOOK, @CAIDCTRA)";
                sql = sql.Replace("@BOIDBOOK", BOIDBOOK);
                sql = sql.Replace("@CAIDCTRA", CAIDCTRA);
                string exec = DataBase.Consultas.InsertInto(str_conn, sql);
                if(exec=="OK")
                {
                    gridAssociadas.JSProperties["cp_ok"] = "OK";
                    gridDisponiveis.JSProperties["cp_ok"] = "OK";
                    gridAssociadas.DataBind();
                    gridDisponiveis.DataBind();
                }
            }
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

        protected void gridDisponiveis_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }

        protected void gridAssociadas_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
    }
}