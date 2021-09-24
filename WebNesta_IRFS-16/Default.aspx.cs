using DataBase;
using DevExpress.DataAccess.Sql;
using DevExpress.Web;
using Google.Cloud.TextToSpeech.V1;
using System;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Media;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using WebNesta_IRFS_16.Utils;

namespace WebNesta_IRFS_16
{
    public partial class Default : BasePage.BasePage
    {
        public static string lang;
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string chaveCript = System.Configuration.ConfigurationManager.AppSettings["chaveCript"];
        public static string vetorCript = System.Configuration.ConfigurationManager.AppSettings["vetorCript"];
        public static string usuarioPersist;
        public static bool acessoInternet;
        protected void Page_Init(object sender, EventArgs e)
        {

        }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                acessoInternet = Convert.ToBoolean(ConfigurationManager.AppSettings["AcessoInternet"]);
                if (Request.QueryString["expired"] == "true")
                {
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                }
                try
                {
                    DataBase.Consultas.CriaFeriado(str_conn,
        ConfigurationManager.AppSettings["APIFeriado"],
        ConfigurationManager.AppSettings["KeyFeriado"],
        ConfigurationManager.AppSettings["AnoFeriado"]);
                    lang = Session["langSession"].ToString();
                }
                catch
                {
                    lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
                }
                var cookiePrevApp = new HttpCookie(DataBase.Funcoes.GerarHashMd5("PrevApp"));
                cookiePrevApp.Value = HttpContext.Current.Request.Url.AbsoluteUri;
                //cookiePrevApp.Expires = DateTime.Now.AddDays(1);
                cookiePrevApp.Secure = true;
                cookiePrevApp.HttpOnly = true;
                cookiePrevApp.SameSite = SameSiteMode.None;
                //cookiePrevApp.Domain = Request.Url.Host;
                Response.Cookies.Add(cookiePrevApp);
                if (System.Configuration.ConfigurationManager.AppSettings["debug"] == "1")
                {
                    var newCookie = new HttpCookie(DataBase.Funcoes.GerarHashMd5("acesso"));
                    newCookie.Value = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], System.Configuration.ConfigurationManager.AppSettings["debugUser"]);
                    //newCookie.Expires = DateTime.Now.AddDays(1);
                    newCookie.HttpOnly = true;
                    newCookie.Secure = true;
                    newCookie.SameSite = SameSiteMode.None;
                    Response.Cookies.Add(newCookie);
                    usuarioPersist = System.Configuration.ConfigurationManager.AppSettings["debugUser"];
                    var newCookieDt = new HttpCookie(DataBase.Funcoes.GerarHashMd5("acessoData"));
                    string dataAcesso = DateTime.Now.Year.ToString() + "#" + DateTime.Now.Month.ToString() + "#" + DateTime.Now.Day.ToString() + "#" + DateTime.Now.Hour.ToString() + "#" + DateTime.Now.Minute.ToString() + "#" + DateTime.Now.Second.ToString();
                    newCookieDt.Value = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], dataAcesso);
                    //newCookieDt.Expires = DateTime.Now.AddDays(1);
                    newCookieDt.HttpOnly = true;
                    newCookieDt.Secure = true;
                    newCookieDt.SameSite = SameSiteMode.None;
                    Response.Cookies.Add(newCookieDt);
                    var date = dataAcesso.Split('#');
                    Session["DTloggin"] = new DateTime(Convert.ToInt32(date[0]), Convert.ToInt32(date[1]), Convert.ToInt32(date[2]), Convert.ToInt32(date[3]), Convert.ToInt32(date[4]), Convert.ToInt32(date[5]));



                }
                else if (System.Configuration.ConfigurationManager.AppSettings["debug"] == "0")
                {
                    HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                    if (myCookie == null)
                    {
                        LogWriter log4 = new LogWriter("Entrei no IFRS e não encontrei o cookie acesso chamado : " + DataBase.Funcoes.GerarHashMd5("acesso"));
                        Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                    }
                    usuarioPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                    HttpCookie myCookieData = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acessoData")];
                    if (myCookieData == null)
                        Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                    var date = Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookieData.Value).Split('#');
                    Session["DTloggin"] = new DateTime(Convert.ToInt32(date[0]), Convert.ToInt32(date[1]), Convert.ToInt32(date[2]), Convert.ToInt32(date[3]), Convert.ToInt32(date[4]), Convert.ToInt32(date[5]));
                }
                bool senhaPadrao = DataBase.Consultas.Consulta(str_conn, "SELECT dbo.nesta_fn_Descriptografa ('" + usuarioPersist + "')", 1)[0] == System.Configuration.ConfigurationManager.AppSettings["senhaPadrao"].ToUpper();
                HttpCookie newCookieSSO = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("loginSSO")];
                if (newCookieSSO != null)
                {
                    if (newCookieSSO.Value == "1")
                        senhaPadrao = false;
                }                
                Session["senhaPadrao"] = senhaPadrao;
                if (senhaPadrao)
                    Response.Redirect("UserProfile");
                if (Session["DTloggin"] != null)
                {
                    lblLogadoDesde.Text = Convert.ToDateTime(Session["DTloggin"]).ToString();
                }
                lblIdiomaCorrente.Text = CultureInfo.GetCultureInfo(lang).DisplayName;
                Session["usuarioPersist"] = usuarioPersist;
                //Termos e Condições
                string flagTermo = DataBase.Consultas.Consulta(str_conn, "select case when USFLCONC < 0 then 0 else USFLCONC end from TUSUSUARI where USIDUSUA='" + usuarioPersist + "'", 1)[0];
                var newCookie1 = new HttpCookie(DataBase.Funcoes.GerarHashMd5("termo_aceite"));
                newCookie1.Value = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], flagTermo);
                //newCookie1.Expires = DateTime.Now.AddDays(1);
                newCookie1.Secure = true;
                newCookie1.HttpOnly = true;
                newCookie1.SameSite = SameSiteMode.None;
                //newCookie1.Domain = Request.Url.Host;
                Response.Cookies.Add(newCookie1);
                if (Convert.ToInt32(flagTermo) != 1)
                {
                    popupTermoAceite.ShowOnPageLoad = true;
                }
                else
                {
                    string sqlValida = "select count(*) from tttermos t, TUSUSUARI u " +
                                        "WHERE u.USIDUSUA = '" + usuarioPersist + "' " +
                                          "and t.ttidterm in (select max(ttidterm) from tttermos where ttvalido = 1) " +
                                          "and t.ttdtpubl >= u.usdtconc";
                    bool valida = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlValida, 1)[0]) == 0;
                    if (!valida)
                        popupTermoAceite.ShowOnPageLoad = true;
                }
                //fim Termos e Condições
                //Perfil de cliente
                string perfil = DataBase.Consultas.Consulta(str_conn, "select GOIDGRUP from TUSUSUARI WHERE USIDUSUA='" + usuarioPersist + "'", 1)[0];
                var newCookie2 = new HttpCookie(DataBase.Funcoes.GerarHashMd5("perfil_cliente"));
                newCookie2.Value = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], perfil);
                //newCookie2.Expires = DateTime.Now.AddDays(1);
                newCookie2.Secure = true;
                newCookie2.HttpOnly = true;
                newCookie2.SameSite = SameSiteMode.None;
                // newCookie2.Domain = Request.Url.Host;
                Response.Cookies.Add(newCookie2);
                //fim perfil de cliente
                //Perfil de Queries
                var newCookie3 = new HttpCookie(DataBase.Funcoes.GerarHashMd5("perfil_relatorios"));
                newCookie3.Value = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], System.Configuration.ConfigurationManager.AppSettings["limiteRelatorios"]);
                //newCookie3.Expires = DateTime.Now.AddDays(1);
                newCookie3.Secure = true;
                newCookie3.HttpOnly = true;
                newCookie3.SameSite = SameSiteMode.None;
                Response.Cookies.Add(newCookie3);
                //fim perfil de queries
                //try { lblUsuario.Text = usuarioPersist; } catch { throw new System.ArgumentException("Parameters cannot be null", "Session of user"); }
                //Bloco Emissão
                lblEmissElabo.Text = DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM OPCONTRA O INNER JOIN WFTASKOP W ON O.OPIDCONT = W.OPIDCONT WHERE (W.WFSTTASK = 0) and O.USIDUSUA='" + usuarioPersist + "' and W.WFIDFLOW=1", 1)[0];
                lblEmissConfe.Text = DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM OPCONTRA O INNER JOIN WFTASKOP W ON O.OPIDCONT = W.OPIDCONT WHERE (W.WFSTTASK = 0) and O.USIDUSUA='" + usuarioPersist + "' and W.WFIDFLOW=2", 1)[0];
                lblEmissAprov.Text = DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM OPCONTRA O INNER JOIN WFTASKOP W ON O.OPIDCONT = W.OPIDCONT WHERE(W.WFSTTASK = 0) and O.USIDUSUA = '" + usuarioPersist + "' and W.WFIDFLOW = 3", 1)[0];
                lblEmissAssina.Text = DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM OPCONTRA O INNER JOIN WFTASKOP W ON O.OPIDCONT = W.OPIDCONT WHERE (W.WFSTTASK = 0) and O.USIDUSUA='" + usuarioPersist + "' and W.WFIDFLOW=4", 1)[0];
                lblEmissCadas.Text = DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM OPCONTRA O INNER JOIN WFTASKOP W ON O.OPIDCONT = W.OPIDCONT WHERE (W.WFSTTASK = 0) and O.USIDUSUA='" + usuarioPersist + "' and W.WFIDFLOW=5", 1)[0];
                lblEmissContra.Text = DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM OPCONTRA O INNER JOIN WFTASKOP W ON O.OPIDCONT = W.OPIDCONT WHERE (W.WFSTTASK = 0) and O.USIDUSUA='" + usuarioPersist + "' and W.WFIDFLOW=6", 1)[0];
                //Bloco Atividades
                lblUsuario.Text = acessoInternet ? DataBase.Consultas.Consulta(str_conn, "select TBUSUSER from tbtbuser where tbiduser=" + usuarioPersist + "", 1)[0] : DataBase.Consultas.Consulta(str_conn, "select USNMPRUS from TUSUSUARI WHERE USIDUSUA='" + usuarioPersist + "'", 1)[0];
                lblContratosAtivos.Text = DataBase.Consultas.Consulta(str_conn, "select count(*) from opcontra op where optptpid='1' and exists (select null  from VIFSFUSU v where USIDUSUA='" + usuarioPersist + "' and v.TVIDESTR = op.TVIDESTR)", 1)[0];
                lblContratosSuspensos.Text = DataBase.Consultas.Consulta(str_conn, "select count(*) from opcontra op where optptpid='9' and exists (select null  from VIFSFUSU v where USIDUSUA='" + usuarioPersist + "' and v.TVIDESTR = op.TVIDESTR)", 1)[0];
                lblContratosEncerrados.Text = DataBase.Consultas.Consulta(str_conn, "select count(*) from opcontra op where optptpid='2' and exists (select null  from VIFSFUSU v where USIDUSUA='" + usuarioPersist + "' and v.TVIDESTR = op.TVIDESTR)", 1)[0];
                lblContratosVencendo.Text = DataBase.Consultas.Consulta(str_conn, "select count(*) from cjclprop_din cd,opcontra o where o.OPIDCONT=cd.OPIDCONT and o.OPTPTPID='1' and cjidcodi = 277 and cjdtprop >= getdate() and cjdtprop <= dateadd(day,90,getdate()) and o.OPIDCONT in (select op.OPIDCONT from OPCONTRA op where exists (select null  from VIFSFUSU v where USIDUSUA='" + usuarioPersist + "' and v.TVIDESTR = op.TVIDESTR))", 1)[0];
                lblTotalContratos.Text = DataBase.Consultas.Consulta(str_conn, "select count(*) from opcontra op where optptpid in ('1','2','9') and exists (select null  from VIFSFUSU v where USIDUSUA='" + usuarioPersist + "' and v.TVIDESTR = op.TVIDESTR)", 1)[0];
                //Bloco Pendências
                string dtFchMen = DataBase.Consultas.Consulta(str_conn, "select max(sbdtsald) from SBSLDOEX sl inner join opcontra op on sl.OPIDCONT=op.OPIDCONT where sl.sbflfech = 'S' and exists (select null from VIFSFUSU v where USIDUSUA='" + usuarioPersist + "' and v.TVIDESTR = op.TVIDESTR)", 1)[0];
                lblFechMensal.Text = dtFchMen == string.Empty ? "--/--/----" : Convert.ToDateTime(dtFchMen).ToShortDateString();
                lblUsuarioLogado.Text = usuarioPersist;
                string sqlAtualDiaria = "select case when t.rzdtdata > getdate() then getdate() " +
            "else t.rzdtdata " +
       "end rzdtdata " +
"from(select max(rz.RZDTDATA) rzdtdata from RZRAZCTB rz inner " +
                                      "join opcontra op on rz.OPIDCONT = op.OPIDCONT " +
      "where exists(select null from VIFSFUSU v where USIDUSUA = '" + usuarioPersist + "' and v.TVIDESTR = op.TVIDESTR) " +
     ") t";
                string dtAtDia = DataBase.Consultas.Consulta(str_conn, sqlAtualDiaria, 1)[0];
                lblAtuaDiaria.Text = dtAtDia == string.Empty ? new DateTime(2020, 10, 04).ToShortDateString() : Convert.ToDateTime(dtAtDia).ToShortDateString();
                string dtAtCot = DataBase.Consultas.Consulta(str_conn, "select max(c.cvdtcoie) from CVCOTIEC c, IEINDECO i where c.ieidinec=i.IEIDINEC and IEINFLAG=0 and IEININTE is not null", 1)[0];
                lblAtuaCota.Text = dtAtCot == string.Empty ? new DateTime(2020, 11, 11).ToShortDateString() : Convert.ToDateTime(dtAtCot).ToShortDateString();
                string sql2 = "SELECT TVIDESTR, TVDSESTR,TVIDPAIS FROM TVESTRUT WHERE TVIDESTR IN ";
                sql2 += "(SELECT max(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A ";
                sql2 += "WHERE B.TVIDESTR = A.TVIDESTR ";
                sql2 += "AND A.FOTPIDTP = 6 ";
                sql2 += "AND A.FOCDLICE IS NOT NULL ";
                sql2 += "AND B.TVNVESTR IN(1, 0) ";
                sql2 += "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "') or ";
                sql2 += "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR ";
                sql2 += "FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "')))) ";
                var resultSQL2 = DataBase.Consultas.Consulta(str_conn, sql2, 3);
                string tvidstrut = resultSQL2[0];
                var cookieTVIDESTR = new HttpCookie(DataBase.Funcoes.GerarHashMd5("TVIDESTR"));
                cookieTVIDESTR.Value = tvidstrut;
                //cookieTVIDESTR.Expires = DateTime.Now.AddDays(1);
                cookieTVIDESTR.Secure = true;
                cookieTVIDESTR.HttpOnly = true;
                cookieTVIDESTR.SameSite = SameSiteMode.None;
                //cookieTVIDESTR.Domain = Request.Url.Host;
                Response.Cookies.Add(cookieTVIDESTR);
                Session["paisUser"] = resultSQL2[2];
                var cookiePais = new HttpCookie("PAIDPAIS");
                cookiePais.Value = resultSQL2[2];
                cookiePais.Secure = true;
                cookiePais.HttpOnly = true;
                cookiePais.SameSite = SameSiteMode.None;
                //cookiePais.Expires = DateTime.Now.AddDays(5);
                Response.Cookies.Add(cookiePais);
                rptIndices.DataSource = DataBase.Consultas.Consulta(str_conn, "select IENMINEC NOME, QUOTE VALOR from nesta_vw_quotes where TVIDESTR=" + tvidstrut + "");
                rptIndices.DataBind();
                int qtdAcessos = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select UTIDUTSE from UTUTISEN where USIDUSUA = '" + usuarioPersist + "'", 1)[0] == "" ? "0" : DataBase.Consultas.Consulta(str_conn, "select UTIDUTSE from UTUTISEN where USIDUSUA = '" + usuarioPersist + "'", 1)[0]);
                if (qtdAcessos <= 1)
                {
                    mvGuide.SetActiveView(this.v_PrimeiroAcesso);
                }
                else
                {
                    mvGuide.SetActiveView(this.v_DemaisAcessos);
                }
                //Documentos disponíveis para o usuário logado
                string sql = "SELECT TVIDESTR, TVDSESTR FROM TVESTRUT WHERE TVIDESTR IN ";
                sql += "(SELECT min(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A ";
                sql += "WHERE B.TVIDESTR = A.TVIDESTR ";
                sql += "AND A.FOTPIDTP = 6 ";
                sql += "AND A.FOCDLICE IS NOT NULL ";
                sql += "AND B.TVNVESTR IN(1, 0) ";
                sql += "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "') or ";
                sql += "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR ";
                sql += "FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "')))) ";
                var resultSQL = DataBase.Consultas.Consulta(str_conn, sql, 2);
                Session["TVIDESTR_grupo"] = resultSQL[0];

                string sqlEmpresas2 = "SELECT TVIDESTR FROM TVESTRUT WHERE TVIDESTR IN  " +
                                    "(SELECT min(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A " +
                                        "WHERE B.TVIDESTR = A.TVIDESTR " +
                                        "AND A.FOTPIDTP = 6 " +
                                        "AND A.FOCDLICE IS NOT NULL " +
                                        "AND B.TVNVESTR IN(1, 0) " +
                                        "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "') or " +
                                        "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR " +
                                        "FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "')))) " +
                                        "union " +
                                        "select distinct TVIDESTR from VIFSFUSU where USIDUSUA = '" + usuarioPersist + "'";
                string empresas = string.Empty;
                foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, sqlEmpresas2).Rows)
                {
                    empresas += row[0].ToString() + ",";
                }
                empresas = empresas.Substring(0, empresas.Length - 1);
                //rptDocumentos.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT T.TPNMVIEW nome,T.TPIDVIEW ID, COUNT(*) qtd FROM QUERYPVT Q, TPTPVIEW T WHERE Q.QUETPPVT=T.TPIDVIEW AND Q.USIDUSUA in (select USIDUSUA from VIFSFUSU WHERE TVIDESTR="+ resultSQL[0] + ") GROUP BY T.TPNMVIEW,T.TPIDVIEW");
                rptDocumentos.DataSource = DataBase.Consultas.Consulta(str_conn, "SELECT T.TPNMVIEW nome,T.TPIDVIEW ID, COUNT(*) qtd FROM QUERYPVT Q, TPTPVIEW T WHERE Q.QUETPPVT=T.TPIDVIEW AND T.PAIDPAIS="+ Session["LandID"].ToString() + " AND Q.USIDUSUA in (select USIDUSUA from VIFSFUSU WHERE TVIDESTR in (" + empresas + ")) GROUP BY T.TPNMVIEW,T.TPIDVIEW");
                rptDocumentos.DataBind();
            }

        }
        protected void rptDocumentos_PreRender(object sender, EventArgs e)
        {
            for (int i = 0; i < rptDocumentos.Items.Count; i++)
            {
                if (((i + 1) % 3) == 0 && i > 0)
                {
                    if (rptDocumentos.Items[i].ItemType == ListItemType.Item)
                    {
                        Literal ltr = rptDocumentos.Items[i].FindControl("ltrbr") as Literal;
                        ltr.Text = "<div id='divDoc' style='display:none'>";
                    }
                }
            }
        }
        protected void rptDocumentos_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Footer)
            {
                if (rptDocumentos.Items.Count < 3)
                {
                    e.Item.Visible = false;
                }
                else if (rptDocumentos.Items.Count >= 3)
                {
                    Literal lrt = e.Item.FindControl("ltrfooter") as Literal;
                    lrt.Text = "</div>";
                }
            }
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string sqlEmpresas2 = "SELECT TVIDESTR FROM TVESTRUT WHERE TVIDESTR IN  " +
                    "(SELECT min(B.TVIDESTR) FROM TVESTRUT B, FOFORNEC A " +
                        "WHERE B.TVIDESTR = A.TVIDESTR " +
                        "AND A.FOTPIDTP = 6 " +
                        "AND A.FOCDLICE IS NOT NULL " +
                        "AND B.TVNVESTR IN(1, 0) " +
                        "AND(B.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "') or " +
                        "B.TVIDESTR IN(SELECT TV2.TVCDPAIE FROM TVESTRUT TV2 WHERE TV2.TVIDESTR IN(SELECT DISTINCT TVIDESTR " +
                        "FROM TUSUSUARI WHERE USIDUSUA = '" + usuarioPersist + "')))) " +
                        "union " +
                        "select distinct TVIDESTR from VIFSFUSU where USIDUSUA = '" + usuarioPersist + "'";
                string empresas = string.Empty;
                foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, sqlEmpresas2).Rows)
                {
                    empresas += row[0].ToString() + ",";
                }
                empresas = empresas.Substring(0, empresas.Length - 1);
                DevExpress.Web.ASPxPopupControl aSPxPopupControl = (DevExpress.Web.ASPxPopupControl)e.Item.FindControl("ASPxPopupControl1");
                Repeater rpt = (Repeater)aSPxPopupControl.FindControl("innerRepeater");
                if (rpt != null)
                {
                    DataRowView drv = e.Item.DataItem as DataRowView;
                    string sql = "SELECT Q.QUENMPVT NOME, Q.QUEIDPVT ID FROM QUERYPVT Q, TPTPVIEW T WHERE Q.QUETPPVT=T.TPIDVIEW AND T.PAIDPAIS=" + Session["LandID"].ToString() + " AND Q.USIDUSUA in (select USIDUSUA from VIFSFUSU WHERE TVIDESTR in (" + empresas + ")) AND T.TPIDVIEW=" + drv.Row["ID"].ToString() + " order by 1";
                    //Response.Write(sql);
                    rpt.DataSource = DataBase.Consultas.Consulta(str_conn, sql);
                    rpt.DataBind();
                }
            }
        }
        protected void LinkButton1_Command(object sender, CommandEventArgs e)
        {
            string id = e.CommandArgument.ToString();
            hfQueryID.Value = e.CommandArgument.ToString();
            

            for (int i = 0; i < HttpContext.Current.Request.Cookies.AllKeys.Length; i++)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[HttpContext.Current.Request.Cookies.AllKeys[i]];
                if (myCookie.Name.IndexOf("paramCtrl") >= 0)
                {
                    myCookie.Value = "";
                    myCookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Remove(myCookie.Name);
                    Response.Cookies.Add(myCookie);
                }
            }
            pnlParametros.Controls.Clear();
            string query = DataBase.Consultas.Consulta(str_conn, "SELECT QUEXMPVT FROM QUERYPVT WHERE QUEIDPVT=" + id, 1)[0];
            string querySelect = DataBase.Consultas.Consulta(str_conn, "SELECT QUEBBPVT FROM QUERYPVT WHERE QUEIDPVT=" + id, 1)[0];
            DevExpress.DataAccess.Sql.SqlDataSource ds = new DevExpress.DataAccess.Sql.SqlDataSource(str_conn);
            ds.LoadFromXml(XElement.Parse(query));
            SelectQuery select = ds.Queries[0] as SelectQuery;
            ds.Queries.Add(select);
            DevExpress.DataAccess.ConnectionParameters.MsSqlConnectionParameters parametersBase = new DevExpress.DataAccess.ConnectionParameters.MsSqlConnectionParameters(
                ConfigurationManager.AppSettings["hostDB"],
                ConfigurationManager.AppSettings["nameDB"],
                ConfigurationManager.AppSettings["userDB"],
                ConfigurationManager.AppSettings["passDB"],
                DevExpress.DataAccess.ConnectionParameters.MsSqlAuthorizationType.SqlServer);
            ds.ConnectionParameters = parametersBase;
            ds.Fill();
            query = select.GetSql(ds.Connection.GetDBSchema(true));
            if (select.Parameters.Count > 0)
            {
                popupParametro.ShowOnPageLoad = true;
                for (int i = 0; i < select.Parameters.Count; i++)
                {
                    var param = select.Parameters[i];
                    Label lbl = new Label();
                    lbl.CssClass = "labels text-left h6 text-uppercase";
                    lbl.ID = DateTime.Now.ToString("HHmmsssfff");
                    lbl.Text = param.Name;
                    pnlParametros.Controls.Add(lbl);
                    if (param.Type.Name == "DateTime")
                    {

                        ASPxDateEdit dt = new ASPxDateEdit();
                        dt.ID = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                        dt.ClientInstanceName = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                        dt.CssClass = "drop-down mt-1 mb-2";
                        dt.Theme = "Material";
                        dt.Width = Unit.Percentage(100);
                        dt.Border.BorderColor = Color.FromArgb(Int32.Parse("669999", System.Globalization.NumberStyles.HexNumber));
                        dt.Border.BorderStyle = BorderStyle.Solid;
                        dt.Border.BorderWidth = Unit.Pixel(1);
                        dt.ValidationSettings.RequiredField.IsRequired = true;
                        dt.ValidationSettings.Display = Display.Dynamic;
                        dt.ValidationSettings.ValidationGroup = "ValidateProcessa";
                        dt.UseMaskBehavior = true;
                        dt.ClientSideEvents.DateChanged = "function(s,e){  " +
                            "var date = s.GetDate();  " +
                            "var dd = date.getDate(); " +
                            "var mm = ('0' + (date.getMonth() + 1)).slice(-2); " +
                            "var y = date.getFullYear(); " +
                            "var someFormattedDate = dd + '/' + mm + '/' + y; " +
                            " createCookie('" + dt.ClientInstanceName + "', someFormattedDate, 1); }";
                        pnlParametros.Controls.Add(dt);
                    }
                    //query = "declare @" + param.Name + " " + param.Type.Name + " = " + "'" + param.Value.ToString() + "'" + query;
                    else if (param.Type.Name == "String")
                    {
                        ASPxTextBox txt = new ASPxTextBox();
                        txt.ID = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                        txt.ClientInstanceName = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                        txt.CssClass = "text-boxes mt-1 mb-2";
                        txt.Theme = "Material";
                        txt.Width = Unit.Percentage(100);
                        txt.ValidationSettings.RequiredField.IsRequired = true;
                        txt.ValidationSettings.Display = Display.Dynamic;
                        txt.ValidationSettings.ValidationGroup = "ValidateProcessa";
                        txt.ClientSideEvents.TextChanged = "function(s,e){  " +
                                                            "var texto = s.GetText();  " +
                                                            " createCookie('" + txt.ClientInstanceName + "', texto, 1); }";
                        pnlParametros.Controls.Add(txt);
                    }
                    //query = "declare @" + param.Name + " " + param.Type.Name + " = " + "'" + param.Value.ToString() + "'" + query;
                    else
                    {
                        if (param.Name.ToUpper().StartsWith("LISTESTR_"))
                        {
                            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                            if (myCookie == null)
                                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                            else
                                usuarioPersist = DataBase.Funcoes.Decriptar(chaveCript, vetorCript, myCookie.Value);
                            ASPxComboBox combo = new ASPxComboBox();
                            combo.ID = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                            combo.ClientInstanceName = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                            combo.CssClass = "drop-down mt-1 mb-2";
                            combo.Theme = "Material";
                            combo.Width = Unit.Percentage(100);
                            combo.Border.BorderColor = Color.FromArgb(Int32.Parse("669999", System.Globalization.NumberStyles.HexNumber));
                            combo.Border.BorderStyle = BorderStyle.Solid;
                            combo.Border.BorderWidth = Unit.Pixel(1);
                            combo.ValidationSettings.RequiredField.IsRequired = true;
                            combo.ValidationSettings.Display = Display.Dynamic;
                            combo.ValidationSettings.ValidationGroup = "ValidateProcessa";
                            combo.ClientSideEvents.SelectedIndexChanged = "function(s,e){  " +
                                "var texto = s.GetValue();  " +
                                " createCookie('" + combo.ClientInstanceName + "', texto, 1); }";
                            combo.DataSource = DataBase.Consultas.Consulta(str_conn, "select distinct T.TVIDESTR,t.TVDSESTR from VIFSFUSU v, TVESTRUT t where v.TVIDESTR=t.TVIDESTR and v.USIDUSUA='" + usuarioPersist + "'");
                            combo.ValueField = "TVIDESTR";
                            combo.TextField = "TVDSESTR";
                            combo.ValueType = Type.GetType("Int32");
                            combo.DataBind();
                            pnlParametros.Controls.Add(combo);
                        }
                        else
                        {
                            ASPxTextBox txt = new ASPxTextBox();
                            txt.ID = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                            txt.ClientInstanceName = "paramCtrl#" + param.Name + "#" + param.Type.Name;
                            txt.CssClass = "text-boxes mt-1 mb-2";
                            txt.Theme = "Material";
                            txt.Width = Unit.Percentage(100);
                            txt.ValidationSettings.RequiredField.IsRequired = true;
                            txt.ValidationSettings.Display = Display.Dynamic;
                            txt.ValidationSettings.ValidationGroup = "ValidateProcessa";
                            txt.ClientSideEvents.TextChanged = "function(s,e){  " +
                                "var texto = s.GetText();  " +
                                " createCookie('" + txt.ClientInstanceName + "', texto, 1); }";
                            pnlParametros.Controls.Add(txt);
                        }
                    }
                }
                popupParametro.ShowOnPageLoad = true;
            }
            else
            {
                string args = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], e.CommandArgument.ToString());
                Response.Redirect("Relatorios?token=" + args);
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Write(Funcoes.GetCotacoes(1619, "01/07/2020"));
        }
        protected void chkLeitura_CheckedChanged(object sender, EventArgs e)
        {
            if (chkLeitura.Checked)
            {
                DataBase.Consultas.Usuario = usuarioPersist;
                DataBase.Consultas.Tela = "Termos e Condições";
                string exec = DataBase.Consultas.UpdtFrom(str_conn, "UPDATE TUSUSUARI SET USDTCONC = convert(datetime,'" + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss") + "',103),USFLCONC=1 where USIDUSUA='" + usuarioPersist + "'");
                if (exec == "OK")
                {
                    string flagTermo = DataBase.Consultas.Consulta(str_conn, "select case when USFLCONC < 0 then 0 else USFLCONC end from TUSUSUARI where USIDUSUA='" + usuarioPersist + "'", 1)[0];
                    var newCookie1 = new HttpCookie(DataBase.Funcoes.GerarHashMd5("termo_aceite"));
                    newCookie1.Value = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], flagTermo);
                    //newCookie1.Expires = DateTime.Now.AddDays(1);
                    newCookie1.Secure = true;
                    newCookie1.HttpOnly = true;
                    newCookie1.SameSite = SameSiteMode.None;
                    //newCookie1.Domain = Request.Url.Host;
                    Response.Cookies.Add(newCookie1);
                    popupTermoAceite.ShowOnPageLoad = false;
                }
            }
        }
        protected void popupTermoAceite_Load(object sender, EventArgs e)
        {
            string sql = "select TTDTPUBL,TTHEADER,TTCLAUSU from tttermos WHERE TTVALIDO=1";
            var result = DataBase.Consultas.Consulta(str_conn, sql, 3);
            if (result.Length == 3)
            {
                lblDataTermo.Text = Convert.ToDateTime(result[0]).ToShortDateString();
                popupTermoAceite.HeaderText = result[1];
                ltrClausu.Text = result[2];
            }
        }
        protected void btnProcReport_Click(object sender, EventArgs e)
        {
            string id = hfQueryID.Value;
            string query = DataBase.Consultas.Consulta(str_conn, "SELECT QUEXMPVT FROM QUERYPVT WHERE QUEIDPVT=" + id, 1)[0];
            string querySelect = DataBase.Consultas.Consulta(str_conn, "SELECT QUEBBPVT FROM QUERYPVT WHERE QUEIDPVT=" + id, 1)[0];
            DevExpress.DataAccess.Sql.SqlDataSource ds = new DevExpress.DataAccess.Sql.SqlDataSource(str_conn);
            ds.LoadFromXml(XElement.Parse(query));
            SelectQuery select = ds.Queries[0] as SelectQuery;
            ds.Queries.Add(select);
            DevExpress.DataAccess.ConnectionParameters.MsSqlConnectionParameters parametersBase = new DevExpress.DataAccess.ConnectionParameters.MsSqlConnectionParameters(
                ConfigurationManager.AppSettings["hostDB"],
                ConfigurationManager.AppSettings["nameDB"],
                ConfigurationManager.AppSettings["userDB"],
                ConfigurationManager.AppSettings["passDB"],
                DevExpress.DataAccess.ConnectionParameters.MsSqlAuthorizationType.SqlServer);
            ds.ConnectionParameters = parametersBase;            
            if (select.Parameters.Count > 0)
            {
                for (int i = 0; i < select.Parameters.Count; i++)
                {
                    var param = select.Parameters[i];
                    string sessionName = "paramCtrl%23" + param.Name + "%23" + param.Type.Name;
                    HttpCookie myCookie = HttpContext.Current.Request.Cookies[sessionName];
                    if (myCookie != null)
                    {
                        if (param.Type.Name == "DateTime")
                        {
                            DateTime dt = new DateTime(Convert.ToInt32(myCookie.Value.Split('/')[2]), Convert.ToInt32(myCookie.Value.Split('/')[1]), Convert.ToInt32(myCookie.Value.Split('/')[0]));
                            select.Parameters[i].Type = param.Type;
                            select.Parameters[i].Value = dt;
                            //querySelect = "declare @" + param.Name + " " + param.Type.Name + " = " + " convert(date, '" + dt.ToString("dd/MM/yyyy") + "', 103)" + query;
                            //querySelect = querySelect.Replace(param.Name, "convert(date, '" + dt.ToString("dd/MM/yyyy") + "', 103)");
                        }
                        else if (param.Type.Name == "String")
                        {
                            select.Parameters[i].Type = param.Type;
                            select.Parameters[i].Value = myCookie.Value;
                            //querySelect = "declare @" + param.Name + " " + param.Type.Name + " = " + " '" + myCookie.Value + "' " + query;
                            //querySelect = querySelect.Replace(param.Name, "'" + myCookie.Value + "'");
                        }
                        else if(param.Type.Name== "Decimal")
                        {
                            select.Parameters[i].Type = param.Type;
                            select.Parameters[i].Value = Convert.ToDecimal(myCookie.Value.Replace(",", "."));
                            //querySelect = "declare @" + param.Name + " " + param.Type.Name + " = " + " " + myCookie.Value.Replace(",", ".") + " " + query;
                            //querySelect = querySelect.Replace(param.Name,myCookie.Value.Replace(",", "."));
                        }
                        else
                        {
                            select.Parameters[i].Type = param.Type;
                            select.Parameters[i].Value = myCookie.Value;
                            //querySelect = "declare @" + param.Name + " " + param.Type.Name + " = " + " " + myCookie.Value.Replace(",", ".") + " " + query;
                            //querySelect = querySelect.Replace(param.Name,myCookie.Value.Replace(",", "."));
                        }

                    }
                }
            }
            ds.Queries.Clear();
            ds.Queries.Add(select);
            string serializedQuery = ds.SaveToXml().ToString();
            string exec = DataBase.Consultas.UpdtFrom(str_conn, "update QUERYPVT set QUEXMPVT='" + serializedQuery + "' where QUEIDPVT="+id);
            if (exec == "OK")
            {
                string args = DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], id);
                Response.Redirect("Relatorios?token=" + args);
            }
            else
            {
                
            }
            popupParametro.ShowOnPageLoad = false;
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            popupParametro.ShowOnPageLoad = false;
        }
    }
}