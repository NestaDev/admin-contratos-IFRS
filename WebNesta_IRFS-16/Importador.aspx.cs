using ClosedXML.Excel;
using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Importador : BasePage.BasePage
    {
        public static string str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        public static string user;
        public static string usuarioPersist;
        public static string currentPage;
        public static string perfil;
        public static DataTable gridFaturamento;
        public static DataTable dtCargaContrato;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["gridFaturamento"] = null;
                Session["dtCargaContrato"] = null;
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                    usuarioPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                user = usuarioPersist;
                hfUser2.Value = user;
                HttpCookie myCookie2 = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie2 == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie2.Value);
                str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
                HttpCookie cookiePais = HttpContext.Current.Request.Cookies["PAIDPAIS"];
            }
            DataBase.Consultas.Usuario = hfUser2.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
            if (IsPostBack)
            {
                if (Session["gridFaturamento"] != null)
                {
                    gridFaturamento = (DataTable)Session["gridFaturamento"];
                    gridFatura.DataSource = gridFaturamento;
                    gridFatura.DataBind();
                }
                if (Session["dtCargaContrato"] != null)
                {
                    dtCargaContrato = (DataTable)Session["dtCargaContrato"];
                    gridCargaContratos.DataSource = dtCargaContrato;
                    gridCargaContratos.DataBind();
                }
            }
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
        protected void dropImportador_SelectedIndexChanged(object sender, EventArgs e)
        {
            mv_Importador.ActiveViewIndex = Convert.ToInt32(dropImportador.Value);
        }
        protected void btnselecionar_Click(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
            int Index = Convert.ToInt32(grid.FocusedRowIndex);
            ddePesqContrato.Text = grid.GetRowValues(grid.FocusedRowIndex, "OPCDCONT").ToString();
            hfOPIDCONT.Value = grid.GetRowValues(grid.FocusedRowIndex, "OPIDCONT").ToString();

        }
        protected void btnDownloadModelo_Click(object sender, EventArgs e)
        {
            if (Convert.ToInt32(dropImportador.Value) == 0) //Guarda-Chuva
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
            else if (Convert.ToInt32(dropImportador.Value) == 1) //Curva ETTJ
            {
                var pasta = new System.IO.DirectoryInfo(Server.MapPath("Content/ETTJ.xlsx"));
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
            else if (Convert.ToInt32(dropImportador.Value) == 2) //Faturamento Diário
            {
                var pasta = new System.IO.DirectoryInfo(Server.MapPath("Content/faturamento.xlsx"));
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
            else if (Convert.ToInt32(dropImportador.Value) == 2) //Carga Contrato
            {
                var pasta = new System.IO.DirectoryInfo(Server.MapPath("Content/carga_contrato.xlsx"));
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
        }
        protected void fileImport_FileUploadComplete(object sender, DevExpress.Web.FileUploadCompleteEventArgs e)
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
        protected string InsertPropriedadesDinamicas(int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, string p_cjtpcttx, int p_cjinprop, string p_cjvlprop, DateTime p_cjdtprop, DateTime p_cjdtdtde, DateTime p_cjdtdtat, string p_cjvldeat)
        {
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
                    cmd.Parameters.AddWithValue("@p_opdtadit", "");
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
        protected void btnSel_Click(object sender, EventArgs e)
        {
            if (Session["fileName"] != null)
            {
                if (Convert.ToInt32(dropImportador.Value) == 0) //Guarda-Chuva
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
                else if (Convert.ToInt32(dropImportador.Value) == 1) //Curva ETTJ
                {
                    if (Session["fileName"] != null)
                    {

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
                                string ID = DataBase.Consultas.Consulta(str_conn, "select max(cenaettj)+1 from INTEETTJ where BOIDBOOK=" + dropListagemETTJ.SelectedItem.Value.ToString(), 1)[0];
                                if (ID == string.Empty)
                                {
                                    ID = "1";
                                    txtCenario.Text = ID;
                                    string sqlUpd = "update ETTJETTJ SET CENAETTJ=" + ID + " WHERE BOIDBOOK=" + dropListagemETTJ.SelectedItem.Value.ToString();
                                    string exec3 = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                                }
                                foreach (DataRow linha in dt.Rows)
                                {
                                    DataBase.Consultas.GravaLog = false;
                                    string sqlIns1 = "INSERT INTO INTEETTJ_TEMP(boidbook,cenaettj,diasinte,taxainte,capiettj,critettj) " +
                                                    "VALUES('@boidbook', @cenaettj, @diasinte, @taxainte, NULL, NULL)";
                                    sqlIns1 = sqlIns1.Replace("@boidbook", dropListagemETTJ.SelectedItem.Value.ToString());
                                    sqlIns1 = sqlIns1.Replace("@cenaettj", ID);
                                    sqlIns1 = sqlIns1.Replace("@diasinte", linha["DIA"].ToString());
                                    sqlIns1 = sqlIns1.Replace("@taxainte", linha["TAXA"].ToString().Replace(",", "."));
                                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns1);
                                    if (exec != "OK")
                                    {
                                        Label6.Text = "Falha na importação: " + exec;
                                        return;
                                    }
                                }
                                DataBase.Consultas.GravaLog = true;
                                string sqlIns2 = "INSERT INTO INTEETTJ (BOIDBOOK,DATAETTJ,CENAETTJ,DIASINTE,TAXAINTE,CAPIETTJ,CRITETTJ,DATAINTE) " +
                "VALUES(@BOIDBOOK, convert(date, '@DATAETTJ', 103), @CENAETTJ, (select min(DIASINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),(select min(TAXAINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),NULL,NULL,NULL)";
                                string sqlIns3 = "INSERT INTO INTEETTJ (BOIDBOOK,DATAETTJ,CENAETTJ,DIASINTE,TAXAINTE,CAPIETTJ,CRITETTJ,DATAINTE) " +
                "VALUES(@BOIDBOOK, convert(date, '@DATAETTJ', 103), @CENAETTJ, (select max(DIASINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),(select max(TAXAINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),NULL,NULL,NULL)";
                                sqlIns2 = sqlIns2.Replace("@BOIDBOOK", dropListagemETTJ.Value.ToString());
                                sqlIns3 = sqlIns3.Replace("@BOIDBOOK", dropListagemETTJ.Value.ToString());
                                sqlIns2 = sqlIns2.Replace("@DATAETTJ", Convert.ToDateTime(txtDtAplic.Text).ToString("dd/MM/yyyy"));
                                sqlIns3 = sqlIns3.Replace("@DATAETTJ", Convert.ToDateTime(txtDtAplic.Text).ToString("dd/MM/yyyy"));
                                sqlIns2 = sqlIns2.Replace("@CENAETTJ", ID);
                                sqlIns3 = sqlIns3.Replace("@CENAETTJ", ID);
                                string exec2 = DataBase.Consultas.InsertInto(str_conn, sqlIns2);
                                exec2 = DataBase.Consultas.InsertInto(str_conn, sqlIns3);
                                if (exec2 != "OK")
                                {
                                    Label6.Text = "Falha na importação: " + exec2;
                                }
                                gridCenarios.DataBind();
                                if (File.Exists(Session["fileName"].ToString()))
                                    File.Delete(Session["fileName"].ToString());
                                popupImportaExcel2.ShowOnPageLoad = false;
                            }
                            else
                            {
                                fileImport2.ClientEnabled = true;
                                Label6.Text = "Falha na importação: Planilha não contém informações.";
                            }
                        }
                    }
                }
                else if (Convert.ToInt32(dropImportador.Value) == 2) //Faturamento Diário
                {
                    lblError3.Text = "";
                    if (Session["fileName"] != null)
                    {

                        gridFaturamento = new DataTable();
                        gridFaturamento.Columns.Add("ID");
                        gridFaturamento.Columns.Add("OPCDCONT");
                        gridFaturamento.Columns.Add("FOCDXCGC");
                        gridFaturamento.Columns.Add("FLDTAFLX").DataType = System.Type.GetType("System.DateTime");
                        gridFaturamento.Columns.Add("FLVALBRT");
                        gridFaturamento.Columns.Add("FLVALLIQ");
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
                                        if (string.IsNullOrEmpty(cell.Value.ToString()))
                                            dt.Rows[dt.Rows.Count - 1][i] = string.Empty;
                                        else
                                            dt.Rows[dt.Rows.Count - 1][i] = cell.Value.ToString();
                                        i++;

                                    }
                                }
                            }
                            if (dt.Rows[0][1].ToString() != string.Empty)
                            {
                                int cont = 0;
                                foreach (DataRow linha in dt.Rows)
                                {
                                    cont++;
                                    try
                                    {
                                        if (DateTime.TryParse(linha[2].ToString(), out DateTime date))
                                        {
                                            DataRow gridFaturamentoRow = gridFaturamento.NewRow();
                                            gridFaturamentoRow["ID"] = DateTime.Now.ToString("HHmmssffff")+cont;
                                            gridFaturamentoRow["OPCDCONT"] = linha[0].ToString();
                                            gridFaturamentoRow["FOCDXCGC"] = linha[1].ToString().Replace("/", "").Replace(".", "").Replace("-", "");
                                            gridFaturamentoRow["FLDTAFLX"] = date;
                                            gridFaturamentoRow["FLVALBRT"] = linha[3].ToString();
                                            gridFaturamentoRow["FLVALLIQ"] = linha[4].ToString();
                                            string opidcont = DataBase.Consultas.Consulta(str_conn, "select OPIDCONT from OPCONTRA OP, FOFORNEC F WHERE OP.FOIDFORN=F.FOIDFORN AND OP.OPCDCONT='" + linha[0].ToString() + "' AND replace(replace(replace(replace(F.FOCDXCGC,'\\',''),'.',''),'-',''),'/','')='" + linha[1].ToString().Replace("/", "").Replace(".", "").Replace("-", "") + "'", 1)[0];
                                            if (string.IsNullOrEmpty(opidcont))
                                                opidcont = DataBase.Consultas.Consulta(str_conn, "select OPIDCONT from OPCONTRA OP, FOFORNEC F WHERE OP.FOIDFORN=F.FOIDFORN AND OP.OPCDCONT='" + linha[0].ToString() + "' AND F.FOCDXCGC='" + linha[1].ToString() + "'", 1)[0];
                                            if (string.IsNullOrEmpty(opidcont))
                                            {
                                                lblError3.Text += string.Format("Falha na importação: linha {0} não foi possível encontrar contrato com os dados informados.", cont);
                                            }
                                            else
                                                gridFaturamento.Rows.Add(gridFaturamentoRow);
                                        }

                                    }                                    
                                    catch(Exception ex)
                                    {
                                        lblError3.Text += "Falha na importação: " + ex.Message;
                                        return;
                                    }
                                }
                                if (gridFaturamento.Rows.Count > 0)
                                {
                                    gridFaturamento.TableName = "VALORES_PDF";
                                    Session["gridFaturamento"] = gridFaturamento;
                                    gridFatura.DataSource = gridFaturamento;
                                    gridFatura.DataBind();
                                }
                                if (File.Exists(Session["fileName"].ToString()))
                                    File.Delete(Session["fileName"].ToString());
                            }
                            else
                            {
                                fileImport3.ClientEnabled = true;
                                lblError3.Text += "Falha na importação: Planilha não contém informações.";
                            }
                        }
                    }
                }
                else if (Convert.ToInt32(dropImportador.Value) == 3) //Carga Contratos
                {
                    lblErrorCarga.Text = "";
                    if (Session["fileName"] != null)
                    {

                        dtCargaContrato = new DataTable();
                        dtCargaContrato.Columns.Add("ID");
                        dtCargaContrato.Columns.Add("CONTRATO");
                        dtCargaContrato.Columns.Add("NAUXILIAR");
                        dtCargaContrato.Columns.Add("DESCONTRATO");
                        dtCargaContrato.Columns.Add("CODCREDOR");
                        dtCargaContrato.Columns.Add("NOMECREDOR");
                        dtCargaContrato.Columns.Add("DTASSINATURA").DataType = System.Type.GetType("System.DateTime");
                        dtCargaContrato.Columns.Add("DATALIBERACAO").DataType = System.Type.GetType("System.DateTime");
                        dtCargaContrato.Columns.Add("DATAENCERRAMENTO").DataType = System.Type.GetType("System.DateTime");
                        dtCargaContrato.Columns.Add("OPVLCONT");
                        dtCargaContrato.Columns.Add("CODCARTEIRA");
                        dtCargaContrato.Columns.Add("EMPRESA");
                        dtCargaContrato.Columns.Add("NOMEEMPRESA");
                        dtCargaContrato.Columns.Add("DIAANIVERSARIO");
                        dtCargaContrato.Columns.Add("VALOROPERACAO");
                        dtCargaContrato.Columns.Add("VALORMENSAL");
                        dtCargaContrato.Columns.Add("DATA1PARCELA").DataType = System.Type.GetType("System.DateTime");
                        dtCargaContrato.Columns.Add("NPARCELAS");
                        dtCargaContrato.Columns.Add("INTERVALODIAS");
                        dtCargaContrato.Columns.Add("TAXAJUROS");
                        dtCargaContrato.Columns.Add("MOEDA");
                        dtCargaContrato.Columns.Add("DESCINDEXADOR");
                        dtCargaContrato.Columns.Add("FORREAJUSTE");
                        dtCargaContrato.Columns.Add("PERREAJUSTE");
                        dtCargaContrato.Columns.Add("PESSOAFJ");
                        dtCargaContrato.Columns.Add("ALIQPIS");
                        dtCargaContrato.Columns.Add("ALIQCOFINS");
                        dtCargaContrato.Columns.Add("REAJUSTE");
                        dtCargaContrato.Columns.Add("DTREAJUSTE").DataType = System.Type.GetType("System.DateTime");;
                        dtCargaContrato.Columns.Add("PERCENTUAL");
                        dtCargaContrato.Columns.Add("ALUGUELEXTRA");
                        dtCargaContrato.Columns.Add("MESEXTRA");
                        dtCargaContrato.Columns.Add("DATALIBERIFRS").DataType = System.Type.GetType("System.DateTime");
                        dtCargaContrato.Columns.Add("ATR");
                        dtCargaContrato.Columns.Add("CARENCIADIAS");
                        dtCargaContrato.Columns.Add("NPARCCARENCIA");
                        dtCargaContrato.Columns.Add("ESCALAPARCELA");
                        dtCargaContrato.Columns.Add("ESCALATAXAJUROS");
                        using (var workBook = new XLWorkbook(Session["fileName"].ToString()))
                        {
                            IXLWorksheet workSheet = workBook.Worksheet(2);

                            DataTable dt = new DataTable();

                            bool firstRow = true;
                            int contRow = 0;
                            foreach (IXLRow row in workSheet.Rows())
                            {
                                
                                //Use the first row to add columns to DataTable.
                                if (firstRow)
                                {
                                    contRow++;
                                    if (contRow == 3)
                                    {
                                        foreach (IXLCell cell in row.Cells())
                                        {
                                            dt.Columns.Add(cell.Value.ToString());
                                        }
                                        firstRow = false;
                                    }
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
                                int cont = 0;
                                foreach (DataRow linha in dt.Rows)
                                {
                                    cont++;
                                    try
                                    {
                                        DataRow dtCargaContratoRow = dtCargaContrato.NewRow();
                                        dtCargaContratoRow["ID"] = DateTime.Now.ToString("HHmmssffff") + cont;
                                        dtCargaContratoRow["CONTRATO"] = linha[0].ToString();
                                        dtCargaContratoRow["NAUXILIAR"] = linha[1].ToString();
                                        dtCargaContratoRow["DESCONTRATO"] = linha[2].ToString();
                                        dtCargaContratoRow["CODCREDOR"] = linha[3].ToString();
                                        dtCargaContratoRow["NOMECREDOR"] = linha[4].ToString();
                                        if(DateTime.TryParse(linha[5].ToString(),out DateTime DTASSINATURA))
                                            dtCargaContratoRow["DTASSINATURA"] = DTASSINATURA;
                                        if (DateTime.TryParse(linha[6].ToString(), out DateTime DATALIBERACAO))
                                            dtCargaContratoRow["DATALIBERACAO"] = DATALIBERACAO;
                                        if (DateTime.TryParse(linha[7].ToString(), out DateTime DATAENCERRAMENTO))
                                            dtCargaContratoRow["DATAENCERRAMENTO"] = DATAENCERRAMENTO;
                                        dtCargaContratoRow["OPVLCONT"] = linha[8].ToString();
                                        dtCargaContratoRow["CODCARTEIRA"] = linha[9].ToString();
                                        dtCargaContratoRow["EMPRESA"] = linha[10].ToString();
                                        dtCargaContratoRow["NOMEEMPRESA"] = linha[11].ToString();
                                        dtCargaContratoRow["DIAANIVERSARIO"] = linha[12].ToString();
                                        dtCargaContratoRow["VALOROPERACAO"] = linha[13].ToString();
                                        dtCargaContratoRow["VALORMENSAL"] = linha[14].ToString();
                                        if (DateTime.TryParse(linha[15].ToString(), out DateTime DATA1PARCELA))
                                            dtCargaContratoRow["DATA1PARCELA"] = DATA1PARCELA;
                                        dtCargaContratoRow["NPARCELAS"] = linha[16].ToString();
                                        dtCargaContratoRow["INTERVALODIAS"] = linha[17].ToString();
                                        dtCargaContratoRow["TAXAJUROS"] = linha[18].ToString();
                                        dtCargaContratoRow["MOEDA"] = linha[19].ToString();
                                        dtCargaContratoRow["DESCINDEXADOR"] = linha[20].ToString();
                                        dtCargaContratoRow["FORREAJUSTE"] = linha[21].ToString();
                                        dtCargaContratoRow["PERREAJUSTE"] = linha[22].ToString();
                                        dtCargaContratoRow["PESSOAFJ"] = linha[23].ToString();
                                        dtCargaContratoRow["ALIQPIS"] = linha[24].ToString();
                                        dtCargaContratoRow["ALIQCOFINS"] = linha[25].ToString();
                                        dtCargaContratoRow["REAJUSTE"] = linha[26].ToString();
                                        if (DateTime.TryParse(linha[27].ToString(), out DateTime DTREAJUSTE))
                                            dtCargaContratoRow["DTREAJUSTE"] = DTREAJUSTE;
                                        dtCargaContratoRow["PERCENTUAL"] = linha[28].ToString();
                                        dtCargaContratoRow["ALUGUELEXTRA"] = linha[29].ToString();
                                        dtCargaContratoRow["MESEXTRA"] = linha[30].ToString();
                                        if (DateTime.TryParse(linha[31].ToString(), out DateTime DATALIBERIFRS))
                                            dtCargaContratoRow["DATALIBERIFRS"] = DATALIBERIFRS;
                                        dtCargaContratoRow["ATR"] = linha[32].ToString();
                                        dtCargaContratoRow["CARENCIADIAS"] = linha[33].ToString();
                                        dtCargaContratoRow["NPARCCARENCIA"] = linha[34].ToString();
                                        dtCargaContratoRow["ESCALAPARCELA"] = linha[35].ToString();
                                        dtCargaContratoRow["ESCALATAXAJUROS"] = linha[36].ToString();
                                        dtCargaContrato.Rows.Add(dtCargaContratoRow);
                                    }
                                    catch (Exception ex)
                                    {
                                        lblErrorCarga.Text += "Falha na importação da linha "+cont+" : " + ex.Message;
                                        return;
                                    }
                                }
                                if (dtCargaContrato.Rows.Count > 0)
                                {
                                    dtCargaContrato.TableName = "VALORES_PDF";
                                    Session["dtCargaContrato"] = dtCargaContrato;
                                    gridCargaContratos.DataSource = dtCargaContrato;
                                    gridCargaContratos.DataBind();
                                }
                                if (File.Exists(Session["fileName"].ToString()))
                                    File.Delete(Session["fileName"].ToString());
                            }
                            else
                            {
                                fileImport4.ClientEnabled = true;
                                lblErrorCarga.Text += "Falha na importação: Planilha não contém informações.";
                            }
                        }
                    }
                }
            }
        }
        protected void dropListagemETTJ_SelectedIndexChanged(object sender, EventArgs e)
        {
            //sqlBook.SelectCommand = "select BODSBOOK,BOIDBOOK from BOBOBOOK ORDER BY 1";
            //sqlBook.DataBind();
            //dropBook.DataBind();
            //dropBook.Enabled = false;
            txtDescricao.Enabled = false;
            dropCriterio.Enabled = false;
            //dropCapitalizacao.Enabled = false;
            //dropMetodo.Enabled = false;
            //dropAplicacao.Enabled = false;
            //gridCurvaJuros.Enabled = false;
            //txtDataRegis.Enabled = false;
            //txtSpread.Enabled = false;
            string sqlConsulta = "select BOIDBOOK,CENAETTJ,DESCETTJ,CRITETTJ,CAPIETTJ,METOETTJ,ETDSAPLI, " +
                                "(select count(*) from INTEETTJ I where I.BOIDBOOK=E.BOIDBOOK and I.CENAETTJ=E.CENAETTJ) INTERVALO " +
                                ", DATAETTJ, " +
                                "DATEADD(DAY, (select max(diasinte) from INTEETTJ I where I.BOIDBOOK = E.BOIDBOOK and I.CENAETTJ = E.CENAETTJ),DATAETTJ) MAXDATE " +
                                ",ETVLTXSP from ETTJETTJ E WHERE BOIDBOOK=" + dropListagemETTJ.SelectedItem.Value.ToString();
            var result1 = DataBase.Consultas.Consulta(str_conn, sqlConsulta, 11);
            //dropBook.Value = result1[0];
            txtCenario.Text = result1[1];
            txtDescricao.Text = result1[2];
            dropCriterio.Value = result1[3];
            //dropCapitalizacao.Value = result1[4];
            //dropMetodo.Value = result1[5];
            //dropAplicacao.Value = result1[6];
            //txtIntervalo.Text = result1[7];
            //txtDataRegis.Text = Convert.ToDateTime(result1[8]).ToShortDateString();
            //txtDataMaior.Text = Convert.ToDateTime(result1[9]).ToShortDateString();
            //txtSpread.Text = result1[10];

            //AtualizaGrafico();

            DataTable dt = DataBase.Consultas.Consulta(str_conn, "select concat(FORMAT(GETDATE() , 'ddMMyyyyHHmmssfff'),DIASINTE) ID,DIASINTE intervalo,TAXAINTE taxa from INTEETTJ where BOIDBOOK=" + dropListagemETTJ.SelectedItem.Value.ToString() + " and CENAETTJ=" + txtCenario.Text);
            Session["dtIntervalos"] = dt;
            //gridCurvaJuros.DataSource = dt;
            //gridCurvaJuros.DataBind();
            //btnInserir.Enabled = false;
            //btnAlterar.Enabled = perfil != "3";
            //btnExcluir.Enabled = perfil != "3";
        }
        protected void gridCenarios_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            int status = Convert.ToInt32(gridCenarios.GetRowValues(e.VisibleIndex, "Status").ToString());
            if (status == 1)
            {
                e.Enabled = false;
            }
        }
        protected void gridCenarios_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            grid.JSProperties["cp_origem"] = e.ButtonID;
            if (e.ButtonID == "ativar")
            {
                string sqlUpd = "update ETTJETTJ SET CENAETTJ=@CENAETTJ WHERE BOIDBOOK=@BOIDBOOK";
                sqlUpd = sqlUpd.Replace("@CENAETTJ", grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString());
                sqlUpd = sqlUpd.Replace("@BOIDBOOK", dropListagemETTJ.SelectedItem.Value.ToString());
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                if (exec == "OK")
                {
                    grid.JSProperties["cp_ok"] = "OK";
                    grid.JSProperties["cp_cenario"] = grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString();
                    grid.JSProperties["cp_intervalos"] = DataBase.Consultas.Consulta(str_conn, "select count(*) from INTEETTJ where BOIDBOOK=" + dropListagemETTJ.SelectedItem.Value.ToString() + " and CENAETTJ=" + grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString(), 1)[0];
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, "select concat(FORMAT(GETDATE() , 'ddMMyyyyHHmmssfff'),DIASINTE) ID,DIASINTE intervalo,TAXAINTE taxa from INTEETTJ where BOIDBOOK=" + dropListagemETTJ.SelectedItem.Value.ToString() + " and CENAETTJ=" + grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString());
                    Session["dtIntervalos"] = dt;
                    //gridCurvaJuros.DataSource = dt;
                }
            }
        }
        protected void gridCenarios_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
        protected void gridSubContratos_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
        protected void btnNovoCenario_Load(object sender, EventArgs e)
        {
            ASPxButton obj = (ASPxButton)sender;
            obj.Enabled = perfil != "3";
        }
        protected void btnDblClickCenarios_Click(object sender, EventArgs e)
        {
            int Index = Convert.ToInt32(hfIndexCenarios.Value);
            DataTable dt = DataBase.Consultas.Consulta(str_conn, "select diasinte as intervalo,taxainte as taxa from INTEETTJ_TEMP where boidbook=" + dropListagemETTJ.SelectedItem.Value.ToString() + " and cenaettj=" + gridCenarios.GetRowValues(Index, "CENAETTJ").ToString() + " order by 1");
            gridDetalheCenario.DataSource = dt;
            gridDetalheCenario.DataBind();
            popupShowETTJ.ShowOnPageLoad = true;
        }

        protected void gridFatura_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }

        protected void btnProcessaFatura_Click(object sender, EventArgs e)
        {
            string sqlIns = "INSERT INTO FLDIAFLX (OPIDCONT,FLDTAFLX,FLVALBRT,FLVALLIQ) VALUES ";
            for (int i = 0; i < gridFatura.VisibleRowCount; i++)
            {
                string OPCDCONT = gridFatura.GetRowValues(i, "OPCDCONT").ToString();
                string FOCDXCGC = gridFatura.GetRowValues(i, "FOCDXCGC").ToString();
                string opidcont = DataBase.Consultas.Consulta(str_conn, "select OPIDCONT from OPCONTRA OP, FOFORNEC F WHERE OP.FOIDFORN=F.FOIDFORN AND OP.OPCDCONT='" + OPCDCONT + "' AND replace(replace(replace(replace(F.FOCDXCGC,'\\',''),'.',''),'-',''),'/','') ='" + FOCDXCGC.Replace("\\", "").Replace(".", "").Replace("-", "").Replace("/","") + "'", 1)[0];
                if (string.IsNullOrEmpty(opidcont))
                    opidcont = DataBase.Consultas.Consulta(str_conn, "select OPIDCONT from OPCONTRA OP, FOFORNEC F WHERE OP.FOIDFORN=F.FOIDFORN AND OP.OPCDCONT='" + OPCDCONT + "' AND F.FOCDXCGC ='" + FOCDXCGC + "'", 1)[0];
                string FLDTAFLX = gridFatura.GetRowValues(i, "FLDTAFLX").ToString();
                string FLVALBRT = gridFatura.GetRowValues(i, "FLVALBRT").ToString();
                string FLVALLIQ = gridFatura.GetRowValues(i, "FLVALLIQ").ToString();
                sqlIns += " (@OPIDCONT, convert(date, '@FLDTAFLX', 103), @FLVALBRT, @FLVALLIQ),";
                sqlIns = sqlIns.Replace("@OPIDCONT", opidcont);
                sqlIns = sqlIns.Replace("@FLDTAFLX", Convert.ToDateTime(FLDTAFLX).ToString("dd/MM/yyyy"));
                sqlIns = sqlIns.Replace("@FLVALBRT", FLVALBRT.Replace(",","."));
                sqlIns = sqlIns.Replace("@FLVALLIQ", FLVALLIQ.Replace(",", "."));

            }
            DataBase.Consultas.GravaLog = true;
            sqlIns = sqlIns.Remove(sqlIns.Length - 1);
            string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns);
            if (exec == "OK")
                MsgException("Importação concluída", 0, "");
            else
                MsgException(exec, 1, "");
        }

        protected void btnProcessaCarga_Click(object sender, EventArgs e)
        {
            string sqlIns = "INSERT INTO Z_CARGA_IFRS (CONTRATO,NAUXILIAR,DESCONTRATO,CODCREDOR,NOMECREDOR,DTASSINATURA,DATALIBERACAO,DATAENCERRAMENTO,OPVLCONT,CODCARTEIRA,EMPRESA,NOMEEMPRESA,DIAANIVERSARIO,VALOROPERACAO,VALORMENSAL,DATA1PARCELA,NPARCELAS,INTERVALODIAS,TAXAJUROS,MOEDA,DESCINDEXADOR,FORREAJUSTE,PERREAJUSTE,PESSOAFJ,ALIQPIS,ALIQCOFINS,REAJUSTE,DTREAJUSTE,PERCENTUAL,ALUGUELEXTRA,MESEXTRA,DATALIBERIFRS,ATR,CARENCIADIAS,NPARCCARENCIA,ESCALAPARCELA,ESCALATAXAJUROS) VALUES  ";
            bool insere = false;
            for (int i = 0; i < gridCargaContratos.VisibleRowCount; i++)
            {                
                string CONTRATO = gridCargaContratos.GetRowValues(i, "CONTRATO").ToString();
                string NAUXILIAR = gridCargaContratos.GetRowValues(i, "NAUXILIAR").ToString();
                string DESCONTRATO = gridCargaContratos.GetRowValues(i, "DESCONTRATO").ToString();
                string CODCREDOR = gridCargaContratos.GetRowValues(i, "CODCREDOR").ToString();
                string NOMECREDOR = gridCargaContratos.GetRowValues(i, "NOMECREDOR").ToString();
                string DTASSINATURA = gridCargaContratos.GetRowValues(i, "DTASSINATURA").ToString();
                string DATALIBERACAO = gridCargaContratos.GetRowValues(i, "DATALIBERACAO").ToString();
                string DATAENCERRAMENTO = gridCargaContratos.GetRowValues(i, "DATAENCERRAMENTO").ToString();
                string OPVLCONT = gridCargaContratos.GetRowValues(i, "OPVLCONT").ToString();
                string CODCARTEIRA = gridCargaContratos.GetRowValues(i, "CODCARTEIRA").ToString();
                string EMPRESA = gridCargaContratos.GetRowValues(i, "EMPRESA").ToString();
                string NOMEEMPRESA = gridCargaContratos.GetRowValues(i, "NOMEEMPRESA").ToString();
                string DIAANIVERSARIO = gridCargaContratos.GetRowValues(i, "DIAANIVERSARIO").ToString();
                string VALOROPERACAO = gridCargaContratos.GetRowValues(i, "VALOROPERACAO").ToString();
                string VALORMENSAL = gridCargaContratos.GetRowValues(i, "VALORMENSAL").ToString();
                string DATA1PARCELA = gridCargaContratos.GetRowValues(i, "DATA1PARCELA").ToString();
                string NPARCELAS = gridCargaContratos.GetRowValues(i, "NPARCELAS").ToString();
                string INTERVALODIAS = gridCargaContratos.GetRowValues(i, "INTERVALODIAS").ToString();
                string TAXAJUROS = gridCargaContratos.GetRowValues(i, "TAXAJUROS").ToString();
                string MOEDA = gridCargaContratos.GetRowValues(i, "MOEDA").ToString();
                string DESCINDEXADOR = gridCargaContratos.GetRowValues(i, "DESCINDEXADOR").ToString();
                string FORREAJUSTE = gridCargaContratos.GetRowValues(i, "FORREAJUSTE").ToString();
                string PERREAJUSTE = gridCargaContratos.GetRowValues(i, "PERREAJUSTE").ToString();
                string PESSOAFJ = gridCargaContratos.GetRowValues(i, "PESSOAFJ").ToString();
                string ALIQPIS = gridCargaContratos.GetRowValues(i, "ALIQPIS").ToString();
                string ALIQCOFINS = gridCargaContratos.GetRowValues(i, "ALIQCOFINS").ToString();
                string REAJUSTE = gridCargaContratos.GetRowValues(i, "REAJUSTE").ToString();
                string DTREAJUSTE = gridCargaContratos.GetRowValues(i, "DTREAJUSTE").ToString();
                string PERCENTUAL = gridCargaContratos.GetRowValues(i, "PERCENTUAL").ToString();
                string ALUGUELEXTRA = gridCargaContratos.GetRowValues(i, "ALUGUELEXTRA").ToString();
                string MESEXTRA = gridCargaContratos.GetRowValues(i, "MESEXTRA").ToString();
                string DATALIBERIFRS = gridCargaContratos.GetRowValues(i, "DATALIBERIFRS").ToString();
                string ATR = gridCargaContratos.GetRowValues(i, "ATR").ToString();
                string CARENCIADIAS = gridCargaContratos.GetRowValues(i, "CARENCIADIAS").ToString();
                string NPARCCARENCIA = gridCargaContratos.GetRowValues(i, "NPARCCARENCIA").ToString();
                string ESCALAPARCELA = gridCargaContratos.GetRowValues(i, "ESCALAPARCELA").ToString();
                string ESCALATAXAJUROS = gridCargaContratos.GetRowValues(i, "ESCALATAXAJUROS").ToString();
                sqlIns += " ('@CONTRATO','@NAUXILIAR','@DESCONTRATO','@CODCREDOR','@NOMECREDOR',@DTASSINATURA,@DATALIBERACAO,@DATAENCERRAMENTO,@OPVLCONT,@CODCARTEIRA,'@EMPRESA','@NOMEEMPRESA',@DIAANIVERSARIO,@VALOROPERACAO,@VALORMENSAL,@DATA1PARCELA,@NPARCELAS,@INTERVALODIAS,@TAXAJUROS,'@MOEDA','@DESCINDEXADOR','@FORREAJUSTE','@PERREAJUSTE','@PESSOAFJ',@ALIQPIS,@ALIQCOFINS,'@REAJUSTE',@DTREAJUSTE,@PERCENTUAL,@ALUGUELEXTRA,'@MESEXTRA',@DATALIBERIFRS,@ATR,@CARENCIADIAS,@NPARCCARENCIA,'@ESCALAPARCELA','@ESCALATAXAJUROS'),";
                sqlIns = sqlIns.Replace("@CONTRATO", CONTRATO);
                sqlIns = sqlIns.Replace("@NAUXILIAR", NAUXILIAR);
                sqlIns = sqlIns.Replace("@DESCONTRATO", DESCONTRATO);
                sqlIns = sqlIns.Replace("@CODCREDOR", CODCREDOR.Replace(".","").Replace("/", "").Replace("-", ""));
                sqlIns = sqlIns.Replace("@NOMECREDOR", NOMECREDOR);
                sqlIns = sqlIns.Replace("@DTASSINATURA", string.IsNullOrEmpty(DTASSINATURA) ? "NULL" : "convert(date, '"+ Convert.ToDateTime(DTASSINATURA).ToString("dd/MM/yyyy") + "', 103)" );
                sqlIns = sqlIns.Replace("@DATALIBERACAO", string.IsNullOrEmpty(DATALIBERACAO) ? "NULL" : "convert(date, '"+ Convert.ToDateTime(DATALIBERACAO).ToString("dd/MM/yyyy") + "', 103)" );
                sqlIns = sqlIns.Replace("@DATAENCERRAMENTO", string.IsNullOrEmpty(DATAENCERRAMENTO) ? "NULL" : "convert(date, '"+ Convert.ToDateTime(DATAENCERRAMENTO).ToString("dd/MM/yyyy") + "', 103)" );
                sqlIns = sqlIns.Replace("@OPVLCONT", string.IsNullOrEmpty(OPVLCONT) ? "NULL" : OPVLCONT.Replace(",", "."));
                sqlIns = sqlIns.Replace("@CODCARTEIRA", CODCARTEIRA);
                sqlIns = sqlIns.Replace("@EMPRESA", EMPRESA.Replace(".", "").Replace("/", "").Replace("-", ""));
                sqlIns = sqlIns.Replace("@NOMEEMPRESA", NOMEEMPRESA);
                sqlIns = sqlIns.Replace("@DIAANIVERSARIO", DIAANIVERSARIO);
                sqlIns = sqlIns.Replace("@VALOROPERACAO", string.IsNullOrEmpty(VALOROPERACAO) ? "NULL" : VALOROPERACAO.Replace(",", "."));
                sqlIns = sqlIns.Replace("@VALORMENSAL", string.IsNullOrEmpty(VALORMENSAL) ? "NULL" : VALORMENSAL.Replace(",", "."));
                sqlIns = sqlIns.Replace("@DATA1PARCELA", string.IsNullOrEmpty(DATA1PARCELA) ? "NULL" : "convert(date, '" + Convert.ToDateTime(DATA1PARCELA).ToString("dd/MM/yyyy") + "', 103)");
                sqlIns = sqlIns.Replace("@NPARCELAS", NPARCELAS);
                sqlIns = sqlIns.Replace("@INTERVALODIAS", INTERVALODIAS);
                sqlIns = sqlIns.Replace("@TAXAJUROS", string.IsNullOrEmpty(TAXAJUROS) ? "NULL" : TAXAJUROS.Replace(",", "."));
                sqlIns = sqlIns.Replace("@MOEDA", MOEDA);
                sqlIns = sqlIns.Replace("@DESCINDEXADOR", DESCINDEXADOR);
                sqlIns = sqlIns.Replace("@FORREAJUSTE", FORREAJUSTE);
                sqlIns = sqlIns.Replace("@PERREAJUSTE", PERREAJUSTE);
                sqlIns = sqlIns.Replace("@PESSOAFJ", PESSOAFJ);
                sqlIns = sqlIns.Replace("@ALIQPIS", string.IsNullOrEmpty(ALIQPIS) ? "NULL" : ALIQPIS.Replace(",", "."));
                sqlIns = sqlIns.Replace("@ALIQCOFINS", string.IsNullOrEmpty(ALIQCOFINS) ? "NULL" : ALIQCOFINS.Replace(",", "."));
                sqlIns = sqlIns.Replace("@REAJUSTE", REAJUSTE);
                sqlIns = sqlIns.Replace("@DTREAJUSTE", string.IsNullOrEmpty(DTREAJUSTE) ? "NULL" : "convert(date, '" + Convert.ToDateTime(DTREAJUSTE).ToString("dd/MM/yyyy") + "', 103)");
                sqlIns = sqlIns.Replace("@PERCENTUAL", string.IsNullOrEmpty(PERCENTUAL) ? "NULL" : PERCENTUAL.Replace(",", "."));
                sqlIns = sqlIns.Replace("@ALUGUELEXTRA", string.IsNullOrEmpty(ALUGUELEXTRA) ? "NULL" : ALUGUELEXTRA.Replace(",", "."));
                sqlIns = sqlIns.Replace("@MESEXTRA", MESEXTRA);
                sqlIns = sqlIns.Replace("@DATALIBERIFRS", string.IsNullOrEmpty(DATALIBERIFRS) ? "NULL" : "convert(date, '" + Convert.ToDateTime(DATALIBERIFRS).ToString("dd/MM/yyyy") + "', 103)");
                sqlIns = sqlIns.Replace("@ATR", string.IsNullOrEmpty(ATR) ? "NULL" : ATR.Replace(",", "."));
                sqlIns = sqlIns.Replace("@CARENCIADIAS", CARENCIADIAS);
                sqlIns = sqlIns.Replace("@NPARCCARENCIA", NPARCCARENCIA);
                sqlIns = sqlIns.Replace("@ESCALAPARCELA", ESCALAPARCELA);
                sqlIns = sqlIns.Replace("@ESCALATAXAJUROS", ESCALATAXAJUROS);
                insere = true;
            }
            if (insere)
            {
                DataBase.Consultas.GravaLog = true;
                sqlIns = sqlIns.Remove(sqlIns.Length - 1);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns);
                if (exec == "OK")
                    MsgException("Importação concluída", 0, "");
                else
                    MsgException(exec, 1, "");
            }
        }

        protected void gridCargaContratos_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
    }
}