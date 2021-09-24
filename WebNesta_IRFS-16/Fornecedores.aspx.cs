using DataBase;
using DevExpress.Web.ASPxTreeList;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.OleDb;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Fornecedores : BasePage.BasePage
    {
        public static string str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static bool realEstate = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["realestate"]);
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
            str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
                                    
            if (!IsPostBack)
            {
                if (Request.QueryString.Count > 0)
                    currentPage = Request.QueryString["naviBefore"];
                else if (Request.QueryString.Count == 0)
                    currentPage = "Default";

                string sqlEstrutura = "select PANMPAIS,PAIDPAIS from PAPAPAIS order by PANMPAIS";
                using (var con = new OleDbConnection(str_conn))
                {
                    con.Open();
                    using (var cmd = new OleDbCommand(sqlEstrutura, con))
                    {
                        dropPais.TextField = "PANMPAIS";
                        dropPais.ValueField = "PAIDPAIS";
                        dropPais.DataSource = cmd.ExecuteReader();
                        dropPais.DataBind();
                        dropPais.Items.Insert(0, new DevExpress.Web.ListEditItem(HttpContext.GetGlobalResourceObject("Fornecedores", "fornecedor_label_12-opt1").ToString(), "0"));
                        dropPais.SelectedIndex = 0;
                    }
                }
                string sqlBanco = "select BACDCODI,BADSDESC from BANBANCO order by 2";
                using (var con = new OleDbConnection(str_conn))
                {
                    con.Open();
                    using (var cmd = new OleDbCommand(sqlBanco, con))
                    {
                        dropBanco.TextField = "BADSDESC";
                        dropBanco.ValueField = "BACDCODI";
                        dropBanco.DataSource = cmd.ExecuteReader();
                        dropBanco.DataBind();
                        dropBanco.Items.Insert(0, new DevExpress.Web.ListEditItem(HttpContext.GetGlobalResourceObject("Fornecedores", "fornecedor_label_12-opt1").ToString(), "0"));
                        dropBanco.SelectedIndex = 0;
                    }
                }
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                    hfUser2.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
                //Pegar empresa pelo usuário logado
                string sql = "SELECT TVIDESTR, TVDSESTR FROM TVESTRUT WHERE TVIDESTR IN ";
                sql += "(SELECT min(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A ";
                sql += "WHERE B.TVIDESTR = A.TVIDESTR ";
                sql += "AND A.FOTPIDTP = 6 ";
                sql += "AND A.FOCDLICE IS NOT NULL ";
                sql += "AND B.TVNVESTR IN(1, 0) ";
                sql += "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + hfUser.Value + "') or ";
                sql += "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR ";
                sql += "FROM TUSUSUARI WHERE USIDUSUA = '" + hfUser.Value + "')))) ";
                hfTVIDESTR.Value = DataBase.Consultas.Consulta(str_conn, sql, 2)[0];
                hfTVIDESTR2.Value = hfTVIDESTR.Value;
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
            txtCpf.Text = "";
            txtDesc.Text = "";
            dropRemessa.SelectedIndex = 0;
            txtApelido.Text = "";
            dropPais.SelectedIndex = 0;
            dropBanco.SelectedIndex = 0;
            txtAG.Text = "";
            txtDAG.Text = "";
            txtCC.Text = "";
            txtDCC.Text = "";
            txtNomeContato.Text = "";
            txtEmailContato.Text = "";
            txtNumWhats.Text = "";
            btnInserir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            txtCpf.Enabled = true;
            txtCpf.Visible = true;
            dropDownEdit.Enabled = false;
            txtDesc.Enabled = true;
            dropRemessa.Enabled = true;
            txtApelido.Enabled = true;
            txtEmailContato.Enabled = true;
            txtNomeContato.Enabled = true;
            txtNumWhats.Enabled = true;
            txtChavePix.Enabled = true;
            dropBanco.Enabled = true;
            txtAG.Enabled = true;
            txtDAG.Enabled = true;
            txtCC.Enabled = true;
            txtDCC.Enabled = true;
            dropPais.Enabled = true;
            btnCpf.Enabled = false;
            reqCpf.Enabled = true;
            reqDesc.Enabled = true;
            reqPais.Enabled = true;
            reqRemessa.Enabled = realEstate;
            reqBanco.Enabled = realEstate;
            reqAG.Enabled = realEstate;
            reqCC.Enabled = realEstate;
            reqNomeContato.Enabled = realEstate;
            reqEmailContato.Enabled = realEstate;
            reqEmailContato2.Enabled = realEstate;
            hfOperacao.Value = "inserir";
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
                    Response.Redirect("Fornecedores");
                    break;
            }
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            switch (hfOperacao.Value)
            {
                case "alterar":
                    string upd = "update FOFORNEC set FONMFORN='" + txtDesc.Text + "',FONMAB20='"+txtApelido.Text+"', PAIDPAIS=" + dropPais.Value + ",FONRFORN='"+dropBanco.Value+"',FOAGFORN='"+txtAG.Text+"',FODIGAGE='"+ txtDAG.Text + "',FOCCFORN='"+ txtCC.Text + "',FODIGCON='"+ txtDCC.Text + "',TPNMFORN='"+dropRemessa.Value+ "', FONMCOTT='"+txtNomeContato.Text+"',FOMAILFO='"+txtEmailContato.Text+"',FOWHATFO='"+txtNumWhats.Text.Replace("(", "").Replace(")", "").Replace("-", "") + "',FOCHAPIX='"+txtChavePix.Text+"' where FOIDFORN=" + hfId.Value + "";
                    string altera = Consultas.UpdtFrom(str_conn, upd);
                    if(altera=="OK")
                    {
                        txtCpf.Enabled = false;
                        txtCpf.Visible = true;
                        dropDownEdit.Enabled = false;
                        txtDesc.Enabled = false;
                        dropRemessa.Enabled = false;
                        txtApelido.Enabled = false;
                        txtEmailContato.Enabled = false;
                        txtNomeContato.Enabled = false;
                        txtNumWhats.Enabled = false;
                        txtChavePix.Enabled = false;
                        dropBanco.Enabled = false;
                        txtAG.Enabled = false;
                        txtDAG.Enabled = false;
                        txtCC.Enabled = false;
                        txtDCC.Enabled = false;
                        dropPais.Enabled = false;
                        MsgException(hfMsgSuccess.Value, 2, "");
                    }
                    else
                    {
                        MsgException(altera, 1, "");
                    }
                    break;
                case "inserir":
                    //int seq = Consultas.SeqPKTabelas(str_conn, "select max(FOIDFORN) from FOFORNEC");
                    int seq = Convert.ToInt32(DataBase.Consultas.CarregaCodInterno("17", 1, str_conn));
                    if (seq != 0)
                    {
                        string sqlInsert = "insert into FOFORNEC (LCIDLOCA,FOIDFORN, FONMFORN,FONMAB20, PAIDPAIS, FOCDXCGC,FOTPIDTP,TVIDESTR,FONRFORN,FOAGFORN,FODIGAGE,FOCCFORN,FODIGCON,TPNMFORN,FONMCOTT,FOMAILFO,FOWHATFO,FOCHAPIX) values (1," + seq+", '"+txtDesc.Text+ "','" + txtApelido.Text + "', " + dropPais.Value+", '"+txtCpf.Text+"',8,"+ hfTVIDESTR.Value + ",'"+dropBanco.Value+"','"+txtAG.Text+ "','" + txtDAG.Text + "','" + txtCC.Text + "','" + txtDCC.Text + "','"+dropRemessa.Value+"','"+txtNomeContato.Text+"','"+txtEmailContato.Text+"','"+txtNumWhats.Text.Replace("(","").Replace(")", "").Replace("-", "") + "','"+txtChavePix.Text+"')";
                        string insert = Consultas.InsertInto(str_conn, sqlInsert);
                        if (insert == "OK")
                        {
                            txtCpf.Enabled = false;
                            txtCpf.Visible = true;
                            dropDownEdit.Enabled = false;
                            txtDesc.Enabled = false;
                            dropRemessa.Enabled = false;
                            txtApelido.Enabled = false;
                            txtEmailContato.Enabled = false;
                            txtNomeContato.Enabled = false;
                            txtNumWhats.Enabled = false;
                            txtChavePix.Enabled = false;
                            dropBanco.Enabled = false;
                            txtAG.Enabled = false;
                            txtDAG.Enabled = false;
                            txtCC.Enabled = false;
                            txtDCC.Enabled = false;
                            dropPais.Enabled = false;
                            MsgException(hfMsgSuccess.Value, 3,currentPage);
                        }
                        else
                        {
                            MsgException(insert, 1, "");
                        }
                    }
                    else
                    {
                        MsgException(hfMsgException.Value, 1, "");
                    }
                    break;
                case "excluir":
                    string delete = Consultas.DeleteFrom(str_conn, "DELETE FOFORNEC where FOIDFORN = " + hfId.Value + "");
                    if (delete == "OK")
                    {
                        txtCpf.Enabled = false;
                        txtCpf.Visible = true;
                        dropDownEdit.Enabled = false;
                        txtDesc.Enabled = false;
                        dropRemessa.Enabled = false;
                        txtApelido.Enabled = false;
                        txtEmailContato.Enabled = false;
                        txtNomeContato.Enabled = false;
                        txtNumWhats.Enabled = false;
                        txtChavePix.Enabled = false;
                        dropBanco.Enabled = false;
                        txtAG.Enabled = false;
                        txtDAG.Enabled = false;
                        txtCC.Enabled = false;
                        txtDCC.Enabled = false;
                        dropPais.Enabled = false;
                        MsgException(hfMsgSuccess.Value, 2,"");
                    }
                    else
                    {
                        MsgException(delete, 1, "");
                    }
                    break;
            }

        }


        protected void btnCpf_Click(object sender, ImageClickEventArgs e)
        {
            //gridFornecedores.Enabled = true;
            //btnPesquisar.Enabled = true;
            //btnInserir.Enabled = false;
            //btnAlterar.Enabled = false;
            //btnExcluir.Enabled = false;
            //btnOK.Enabled = false;
            //btnCancelar.Enabled = false;
            //gridFornecedores.DataBind();
            //pnlGrid.Visible = true;
        }

        protected void btnAlterar_Click(object sender, EventArgs e)
        {
            btnInserir.Enabled = false;
            btnAlterar.Enabled = false;
            btnExcluir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            txtCpf.Enabled = false;
            txtDesc.Enabled = true;
            txtApelido.Enabled = true;
            dropPais.Enabled = true;
            dropRemessa.Enabled = true;
            txtApelido.Enabled = true;
            txtNomeContato.Enabled = true;
            txtEmailContato.Enabled = true;
            txtNumWhats.Enabled = true;
            txtChavePix.Enabled = true;
            dropBanco.Enabled = true;
            txtAG.Enabled = true;
            txtDAG.Enabled = true;
            txtCC.Enabled = true;
            txtDCC.Enabled = true;
            btnCpf.Enabled = false;
            reqCpf.Enabled = true;
            reqDesc.Enabled = true;
            reqPais.Enabled = true;
            reqRemessa.Enabled = realEstate;
            reqBanco.Enabled = realEstate;
            reqAG.Enabled = realEstate;
            reqCC.Enabled = realEstate;
            reqNomeContato.Enabled = realEstate;
            reqEmailContato.Enabled = realEstate;
            reqEmailContato2.Enabled = realEstate;
            hfOperacao.Value = "alterar";
            dropDownEdit.Enabled = false;
        }
        protected void btnExcluir_Click(object sender, EventArgs e)
        {
            btnInserir.Enabled = false;
            btnAlterar.Enabled = false;
            btnExcluir.Enabled = false;
            btnOK.Enabled = true;
            btnCancelar.Enabled = true;
            //gridFornecedores.Enabled = false;
            //btnPesquisar.Enabled = false;
            hfOperacao.Value = "excluir";
            dropDownEdit.Enabled = false;
        }
        protected void gridFornecedores_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            int Index = Convert.ToInt32(e.Parameters);
            //DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)dropDownEdit.FindControl("gridFornecedores");
            DevExpress.Web.ASPxGridView grid = (sender) as DevExpress.Web.ASPxGridView;
            hfCPF.Value = grid.GetRowValues(Index, "FOCDXCGC").ToString();
            hfNome.Value = grid.GetRowValues(Index, "FONMFORN").ToString();
            hfPais.Value = grid.GetRowValues(Index, "PAIDPAIS").ToString();
            hfId.Value = grid.GetRowValues(Index, "FOIDFORN").ToString();
            dropDownEdit.Text = hfCPF.Value;
            txtCpf.Text = hfCPF.Value;
            txtDesc.Text = hfNome.Value;
            dropPais.Value = hfPais.Value;
            btnAlterar.Enabled = true;
            btnInserir.Enabled = false;
            btnExcluir.Enabled = true;
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
            hfOperacao.Value = "pesquisar";
        }
        protected void btnselecionar_Click(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)dropDownEdit.FindControl("gridFornecedores");
            //DevExpress.Web.ASPxGridView grid = (sender) as DevExpress.Web.ASPxGridView;
            hfCPF.Value = grid.GetRowValues(grid.FocusedRowIndex, "FOCDXCGC").ToString();
            hfNome.Value = grid.GetRowValues(grid.FocusedRowIndex, "FONMFORN").ToString();
            hfApelido.Value = grid.GetRowValues(grid.FocusedRowIndex, "FONMAB20").ToString();
            hfPais.Value = grid.GetRowValues(grid.FocusedRowIndex, "PAIDPAIS").ToString();
            hfId.Value = grid.GetRowValues(grid.FocusedRowIndex, "FOIDFORN").ToString();
            var result = DataBase.Consultas.Consulta(str_conn, "select f.PAIDPAIS,f.FONMAB20,f.FONMFORN,f.FOCDXCGC,f.fonrforn,f.FOAGFORN,f.FODIGAGE,f.FOCCFORN,f.FODIGCON,f.TPNMFORN,FONMCOTT,FOMAILFO,FOWHATFO,FOCHAPIX from fofornec f where foidforn=" + hfId.Value, 14);
            dropDownEdit.Text = hfCPF.Value;
            txtCpf.Text = hfCPF.Value;
            txtDesc.Text = result[2].ToString();
            txtApelido.Text = hfApelido.Value;
            dropPais.Value = hfPais.Value;
            dropBanco.Value = result[4].ToString();
            dropRemessa.Value = result[9].ToString();
            txtAG.Text = result[5].ToString();
            txtDAG.Text = result[6].ToString();
            txtCC.Text = result[7].ToString();
            txtDCC.Text = result[8].ToString();
            txtNomeContato.Text = result[10];
            txtEmailContato.Text = result[11];
            txtNumWhats.Text = result[12];
            txtChavePix.Text = result[13];
            btnAlterar.Enabled = perfil != "3";
            btnInserir.Enabled = true;
            btnExcluir.Enabled = perfil != "3";
            btnOK.Enabled = false;
            btnCancelar.Enabled = false;
            hfOperacao.Value = "pesquisar";
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }

        protected void btnAlterar_Load(object sender, EventArgs e)
        {
        }

        protected void btnExcluir_Load(object sender, EventArgs e)
        {
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
    }
}