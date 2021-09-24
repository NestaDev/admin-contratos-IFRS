using ClosedXML.Excel;
using DevExpress.Spreadsheet;
using DevExpress.SpreadsheetSource.Implementation;
using DevExpress.Web;
using DevExpress.XtraCharts;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class JurosETTJ : BasePage.BasePage
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
            if(!IsPostBack)
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
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = sender as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (DevExpress.Web.ASPxTreeList.TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void gridCurvaJuros_Load(object sender, EventArgs e)
        {
        }
        protected void FillCurvaJuros()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ID", typeof(string));
            dt.Columns.Add("intervalo", typeof(Int32));
            dt.Columns.Add("taxa", typeof(Decimal));           
            dt.TableName = "Inventario";
            Session["dtIntervalos"] = dt;
            //gridCurvaJuros.DataSource = dt;
            //gridCurvaJuros.DataBind();
        }
        protected void gridCurvaJuros_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {

        }
        protected void fileImport_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
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
        protected void gridCurvaJuros_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            e.Handled = true;
            if (Session["dtIntervalos"] != null)
            {
                DataTable dt = (DataTable)Session["dtIntervalos"] as DataTable;
                DataRow dr;
                int cont = 1;
                foreach (var item in e.InsertValues)
                {
                    dr = dt.NewRow();
                    dr["ID"] = DateTime.Now.ToString("ddMMyyHHmmss") + cont.ToString();
                    dr["intervalo"] = item.NewValues["intervalo"].ToString();
                    dr["taxa"] = item.NewValues["taxa"].ToString();
                    dt.Rows.Add(dr);
                    cont++;
                }
                foreach (var item in e.DeleteValues)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID"].ToString() == item.Keys["ID"].ToString())
                            dr.Delete();
                    }
                    dt.AcceptChanges();
                }
                foreach (var item in e.UpdateValues)
                {
                    string intervalo = item.NewValues["intervalo"] == null ? item.OldValues["intervalo"].ToString() : item.NewValues["intervalo"].ToString();
                    string taxa = item.NewValues["taxa"] == null ? item.OldValues["taxa"].ToString() : item.NewValues["taxa"].ToString();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID"].ToString() == item.Keys["ID"].ToString())
                        {
                            dr["intervalo"] = intervalo;
                            dr["taxa"] = taxa;
                        }
                    }
                    dt.AcceptChanges();
                }
                Session["dtIntervalos"] = dt;
                grid.DataSource = dt;
                grid.DataBind();
            }
            else
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("ID", typeof(string));
                dt.Columns.Add("intervalo", typeof(Int32));
                dt.Columns.Add("taxa", typeof(Decimal));
                dt.TableName = "Inventario";
                DataRow dr;
                int cont = 1;
                foreach (var item in e.InsertValues)
                {
                    dr = dt.NewRow();
                    dr["ID"] = DateTime.Now.ToString("ddMMyyHHmmss") + cont.ToString();
                    dr["intervalo"] = item.NewValues["intervalo"].ToString();
                    dr["taxa"] = item.NewValues["taxa"].ToString();
                    dt.Rows.Add(dr);
                    cont++;
                }
                Session["dtIntervalos"] = dt;
                grid.DataSource = dt;
                grid.DataBind();
            }
        }
        protected void dropListagemIndices_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlBook.SelectCommand = "select BODSBOOK,BOIDBOOK from BOBOBOOK ORDER BY 1";
            sqlBook.DataBind();
            dropBook.DataBind();
            dropBook.Enabled = false;
            txtDescricao.Enabled = false;
            dropCriterio.Enabled = false;
            //dropCapitalizacao.Enabled = false;
            //dropMetodo.Enabled = false;
            //dropAplicacao.Enabled = false;
            //gridCurvaJuros.Enabled = false;
            //txtDataRegis.Enabled = false;
            //txtSpread.Enabled = false;
            string sqlConsulta = "select BOIDBOOK,CENAETTJ,DESCETTJ,CRITETTJ,CAPIETTJ,METOETTJ,ETDSAPLI, "+
                                "(select count(*) from INTEETTJ I where I.BOIDBOOK=E.BOIDBOOK and I.CENAETTJ=E.CENAETTJ) INTERVALO "+
                                ", DATAETTJ, "+
                                "DATEADD(DAY, (select max(diasinte) from INTEETTJ I where I.BOIDBOOK = E.BOIDBOOK and I.CENAETTJ = E.CENAETTJ),DATAETTJ) MAXDATE "+
                                ",ETVLTXSP from ETTJETTJ E WHERE BOIDBOOK="+dropListagemIndices.SelectedItem.Value.ToString();
            var result1 = DataBase.Consultas.Consulta(str_conn,sqlConsulta,11);
            dropBook.Value = result1[0];
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

            AtualizaGrafico();

            DataTable dt = DataBase.Consultas.Consulta(str_conn, "select concat(FORMAT(GETDATE() , 'ddMMyyyyHHmmssfff'),DIASINTE) ID,DIASINTE intervalo,TAXAINTE taxa from INTEETTJ where BOIDBOOK=" + dropBook.SelectedItem.Value.ToString() + " and CENAETTJ=" + txtCenario.Text);
            Session["dtIntervalos"] = dt;
            //gridCurvaJuros.DataSource = dt;
            //gridCurvaJuros.DataBind();
            btnInserir.Enabled = false;
            btnAlterar.Enabled = perfil != "3";
            btnExcluir.Enabled = perfil != "3";
        }
        protected void BotoesOperacao(object sender, CommandEventArgs args)
        {
            Session["Operacao"] = args.CommandArgument.ToString();
            switch (Session["Operacao"].ToString())
            {
                case "inserir":
                    txtDescricao.Enabled = true;
                    dropCriterio.Enabled = true;
                    dropBook.Enabled = true;
                    gridCenarios.Enabled = true;
                    btnInserir.Enabled = false;
                    btnAlterar.Enabled = false;
                    btnExcluir.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    sqlBook.SelectCommand = "SELECT B.BODSBOOK,B.BOIDBOOK FROM BOBOBOOK B WHERE B.BOIDBOOK NOT IN (SELECT BOIDBOOK FROM ETTJETTJ) order by 1";
                    sqlBook.DataBind();
                    dropBook.DataBind();
                    break;
                case "alterar":
                    txtDescricao.Enabled = true;
                    //dropCriterio.Enabled = true;
                    //dropCapitalizacao.Enabled = true;
                    //dropMetodo.Enabled = true;
                    //dropAplicacao.Enabled = true;
                    //gridCurvaJuros.Enabled = true;
                    gridCenarios.Enabled = true;
                    //txtDataRegis.Enabled = true;
                    //txtSpread.Enabled = true;
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
        protected void gridCenarios_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            int status = Convert.ToInt32(gridCenarios.GetRowValues(e.VisibleIndex, "Status").ToString());
            if(status==1)
            {
                e.Enabled = false;
            }
        }
        protected void gridCenarios_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            grid.JSProperties["cp_origem"] = e.ButtonID;
            if(e.ButtonID=="ativar")
            {
                string sqlUpd = "update ETTJETTJ SET CENAETTJ=@CENAETTJ WHERE BOIDBOOK=@BOIDBOOK";
                sqlUpd = sqlUpd.Replace("@CENAETTJ", grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString());
                sqlUpd = sqlUpd.Replace("@BOIDBOOK",dropBook.SelectedItem.Value.ToString());
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                if(exec=="OK")
                {
                    grid.JSProperties["cp_ok"] = "OK";
                    grid.JSProperties["cp_cenario"] = grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString();
                    grid.JSProperties["cp_intervalos"] = DataBase.Consultas.Consulta(str_conn, "select count(*) from INTEETTJ where BOIDBOOK="+ dropBook.SelectedItem.Value.ToString() + " and CENAETTJ="+ grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString(), 1)[0];
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, "select concat(FORMAT(GETDATE() , 'ddMMyyyyHHmmssfff'),DIASINTE) ID,DIASINTE intervalo,TAXAINTE taxa from INTEETTJ where BOIDBOOK=" + dropBook.SelectedItem.Value.ToString() + " and CENAETTJ=" + grid.GetRowValues(e.VisibleIndex, "CENAETTJ").ToString());
                    Session["dtIntervalos"] = dt;
                    AtualizaGrafico();
                    //gridCurvaJuros.DataSource = dt;
                }

            }
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            switch (Session["Operacao"].ToString())
            {
                case "inserir":
                    txtDescricao.Enabled = true;
                    dropBook.Enabled = true;
                    string sqlIns = "INSERT INTO ETTJETTJ (DATAETTJ,CENAETTJ,BOIDBOOK,DESCETTJ,ETVLTXSP,CAPIETTJ,CRITETTJ) " +
"VALUES(convert(date, '@DATAETTJ', 103), 0, @BOIDBOOK, '@DESCETTJ',0,0,'@CRITETTJ')";
                    sqlIns = sqlIns.Replace("@DATAETTJ", DateTime.Now.ToString("dd/MM/yyyy"));
                    sqlIns = sqlIns.Replace("@DESCETTJ", txtDescricao.Text);
                    sqlIns = sqlIns.Replace("@CRITETTJ", dropCriterio.SelectedItem.Value.ToString());
                    sqlIns = sqlIns.Replace("@BOIDBOOK", dropBook.SelectedItem.Value.ToString());
                    string exec2 = DataBase.Consultas.InsertInto(str_conn, sqlIns);
                    if (exec2 == "OK")
                    {
                        dropListagemIndices.DataBind();
                        txtDescricao.Enabled = false;
                        dropCriterio.Enabled = false;
                        dropBook.Enabled = false;
                        gridCenarios.Enabled = true;
                        btnAlterar.Enabled = false;
                        btnExcluir.Enabled = false;
                        btnInserir.Enabled = false;
                        btnOK.Enabled = false;
                        btnCancelar.Enabled = false;
                    }
                    break;
                case "alterar":
                    //string CAPIETTJ = dropCapitalizacao.SelectedItem.Value.ToString();
                    //string CRITETTJ = dropCriterio.SelectedItem.Value.ToString();
                    string DESCETTJ = txtDescricao.Text;
                    //string METOETTJ = dropMetodo.SelectedItem.Value.ToString();
                    //string ETDSAPLI = dropAplicacao.SelectedItem.Value.ToString();
                    //string ETVLTXSP = txtSpread.Text;
                    string BOIDBOOK = dropBook.SelectedItem.Value.ToString();
                    //string DATAETTJ = txtDataRegis.Text;
                    string sqlUpd = "UPDATE ETTJETTJ " +
                                   "SET DATAETTJ = CONVERT(DATE, '@DATAETTJ', 103) " +
                                      ", DESCETTJ = '@DESCETTJ' " +
                                "WHERE BOIDBOOK = @BOIDBOOK";
                    sqlUpd = sqlUpd.Replace("@DATAETTJ", DateTime.Now.ToString("dd/MM/yyyy"));
                    sqlUpd = sqlUpd.Replace("@DESCETTJ", DESCETTJ);
                    sqlUpd = sqlUpd.Replace("@BOIDBOOK", BOIDBOOK);
                    string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                    if(exec=="OK")
                    {
                        txtDescricao.Enabled = false;
                        dropBook.Enabled = false;
                        gridCenarios.DataBind();
                        gridCenarios.Enabled = false;
                        btnAlterar.Enabled = true;
                        btnExcluir.Enabled = true;
                        btnInserir.Enabled = false;
                        btnOK.Enabled = false;
                        btnCancelar.Enabled = false;
                    }
                    break;
                case "excluir":
                    string sqlDel1 = "delete ETTJETTJ where BOIDBOOK = "+dropBook.SelectedItem.Value.ToString();
                    string sqlDel2 = "delete INTEETTJ where BOIDBOOK = " + dropBook.SelectedItem.Value.ToString();
                    string sqlDel3 = "delete INTEETTJ_TEMP where BOIDBOOK = " + dropBook.SelectedItem.Value.ToString();
                    string exec4 = DataBase.Consultas.DeleteFrom(str_conn, sqlDel1);
                    if(exec4=="OK")
                    {
                        exec4 = DataBase.Consultas.DeleteFrom(str_conn, sqlDel2);
                        if(exec4=="OK")
                        {
                            exec4 = DataBase.Consultas.DeleteFrom(str_conn, sqlDel3);
                            if(exec4=="OK")
                            {
                                Response.Redirect("JurosETTJ");
                            }
                        }
                    }
                    break;
            }
        }
        protected void gridCurvaJuros_CustomCallback1(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if(e.Parameters=="clear")
            {
                FillCurvaJuros();
            }
            else if (e.Parameters == "fill")
            {
                //DataTable dt = DataBase.Consultas.Consulta(str_conn, "select concat(FORMAT(GETDATE() , 'ddMMyyyyHHmmssfff'),DIASINTE) ID,DIASINTE intervalo,TAXAINTE taxa from INTEETTJ where BOIDBOOK=" + dropBook.SelectedItem.Value.ToString() + " and CENAETTJ=" + txtCenario.Text);
                //Session["dtIntervalos"] = dt;
                //gridCurvaJuros.DataSource = dt;
                //gridCurvaJuros.DataBind();
            }

        }
        protected void btnDblClickCenarios_Click(object sender, EventArgs e)
        {
            int Index = Convert.ToInt32(hfIndexCenarios.Value);
            DataTable dt = DataBase.Consultas.Consulta(str_conn, "select diasinte as intervalo,taxainte as taxa from INTEETTJ_TEMP where boidbook=" + dropBook.SelectedItem.Value.ToString() + " and cenaettj=" + gridCenarios.GetRowValues(Index, "CENAETTJ").ToString() + " order by 1");
            gridDetalheCenario.DataSource = dt;
            gridDetalheCenario.DataBind();
            popupShowETTJ.ShowOnPageLoad = true;
        }
        protected void btnDownloadModelo_Click(object sender, EventArgs e)
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
        protected void AtualizaGrafico()
        {
            string sqlCenario = "select cenaettj from ETTJETTJ where boidbook=" + dropBook.SelectedItem.Value.ToString() + " union all " +
"select cenaettj from INTEETTJ_TEMP where boidbook = " + dropBook.SelectedItem.Value.ToString() + " and cenaettj NOT IN(SELECT cenaettj FROM ETTJETTJ WHERE boidbook = " + dropBook.SelectedItem.Value.ToString() + ") group by cenaettj";
            DataTable dtCenario = DataBase.Consultas.Consulta(str_conn, sqlCenario);
            chartGeral.Series.Clear();
            foreach (DataRow row in dtCenario.Rows)
            {
                DataTable dtGrafico = DataBase.Consultas.Consulta(str_conn, "select diasinte,taxainte from INTEETTJ_TEMP where boidbook=" + dropBook.SelectedItem.Value.ToString() + " and cenaettj=" + row[0].ToString() + " order by 1");
                Series serie = new Series("Cenário: " + row[0].ToString(), ViewType.SplineArea);
                serie.ArgumentScaleType = ScaleType.Qualitative;
                
                if (row[0].ToString() == txtCenario.Text)
                {
                    ((SplineAreaSeriesView)serie.View).MarkerOptions.Kind = MarkerKind.Diamond;
                    serie.Name = "Cenário Ativo: " + row[0].ToString();
                }
                else
                {
                    ((SplineAreaSeriesView)serie.View).MarkerOptions.Kind = MarkerKind.Diamond;
                    serie.CheckedInLegend = false;
                }
                var max = DataBase.Consultas.Consulta(str_conn, "select convert(int,max(diasinte)/5) from INTEETTJ_TEMP where boidbook=" + dropBook.SelectedItem.Value.ToString() + " and cenaettj=" + row[0].ToString() + " order by 1", 1)[0];
                if(Convert.ToInt32(max)<5)
                {
                    max = DataBase.Consultas.Consulta(str_conn, "select max(diasinte) from INTEETTJ_TEMP where boidbook=" + dropBook.SelectedItem.Value.ToString() + " and cenaettj=" + row[0].ToString() + " order by 1", 1)[0];
                }
                int cont = 0;
                //serie.Points.Add(new SeriesPoint("0", 0));
                foreach (DataRow rowSeries in dtGrafico.Rows)
                {
                    if (rowSeries[0].ToString() == "1")
                    {
                        serie.Points.Add(new SeriesPoint(rowSeries[0].ToString(), Convert.ToDecimal(rowSeries[1].ToString())));
                    }
                    else if (rowSeries[0].ToString() == max)
                    {
                        serie.Points.Add(new SeriesPoint(rowSeries[0].ToString(), Convert.ToDecimal(rowSeries[1].ToString())));
                        cont++;
                    }                    
                    else if (Convert.ToInt32(rowSeries[0].ToString()) > Convert.ToInt32(max))
                    {
                        if(((Convert.ToInt32(rowSeries[0].ToString())- Convert.ToInt32(max))/cont).ToString()==max)
                        {
                            serie.Points.Add(new SeriesPoint(rowSeries[0].ToString(), Convert.ToDecimal(rowSeries[1].ToString())));
                            cont++;
                        }
                    }                    
                }                
                chartGeral.Series.Add(serie);
            }
        }
        protected void btnSel_Click(object sender, EventArgs e)
        {

            if(Session["fileName"]!=null)
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
                    if (dt.Rows[0][1].ToString()!=string.Empty)
                    {
                        string ID = DataBase.Consultas.Consulta(str_conn, "select max(cenaettj)+1 from INTEETTJ where BOIDBOOK=" + dropBook.SelectedItem.Value.ToString(), 1)[0];
                        if (ID == string.Empty)
                        {
                            ID = "1";
                            txtCenario.Text = ID;
                            string sqlUpd = "update ETTJETTJ SET CENAETTJ=" + ID + " WHERE BOIDBOOK=" + dropBook.SelectedItem.Value.ToString();
                            string exec3 = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                        }
                        foreach (DataRow linha in dt.Rows)
                        {
                            DataBase.Consultas.GravaLog = false;
                            string sqlIns1 = "INSERT INTO INTEETTJ_TEMP(boidbook,cenaettj,diasinte,taxainte,capiettj,critettj) " +
                                            "VALUES('@boidbook', @cenaettj, @diasinte, @taxainte, NULL, NULL)";
                            sqlIns1 = sqlIns1.Replace("@boidbook", dropBook.SelectedItem.Value.ToString());
                            sqlIns1 = sqlIns1.Replace("@cenaettj", ID);
                            sqlIns1 = sqlIns1.Replace("@diasinte", linha["DIA"].ToString());
                            sqlIns1 = sqlIns1.Replace("@taxainte", linha["TAXA"].ToString().Replace(",", "."));
                            string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns1);
                            if (exec != "OK")
                            {
                                lblErrorFileUpload.Text = "Falha na importação: " + exec;
                                return;
                            }
                        }
                        DataBase.Consultas.GravaLog = true;
                        string sqlIns2 = "INSERT INTO INTEETTJ (BOIDBOOK,DATAETTJ,CENAETTJ,DIASINTE,TAXAINTE,CAPIETTJ,CRITETTJ,DATAINTE) " +
        "VALUES(@BOIDBOOK, convert(date, '@DATAETTJ', 103), @CENAETTJ, (select min(DIASINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),(select min(TAXAINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),NULL,NULL,NULL)";
                        string sqlIns3 = "INSERT INTO INTEETTJ (BOIDBOOK,DATAETTJ,CENAETTJ,DIASINTE,TAXAINTE,CAPIETTJ,CRITETTJ,DATAINTE) " +
        "VALUES(@BOIDBOOK, convert(date, '@DATAETTJ', 103), @CENAETTJ, (select max(DIASINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),(select max(TAXAINTE) from INTEETTJ_TEMP where boidbook = @BOIDBOOK and cenaettj = @CENAETTJ),NULL,NULL,NULL)";
                        sqlIns2 = sqlIns2.Replace("@BOIDBOOK", dropBook.SelectedItem.Value.ToString());
                        sqlIns3 = sqlIns3.Replace("@BOIDBOOK", dropBook.SelectedItem.Value.ToString());
                        sqlIns2 = sqlIns2.Replace("@DATAETTJ", Convert.ToDateTime(txtDtAplic.Text).ToString("dd/MM/yyyy"));
                        sqlIns3 = sqlIns3.Replace("@DATAETTJ", Convert.ToDateTime(txtDtAplic.Text).ToString("dd/MM/yyyy"));
                        sqlIns2 = sqlIns2.Replace("@CENAETTJ", ID);
                        sqlIns3 = sqlIns3.Replace("@CENAETTJ", ID);
                        string exec2 = DataBase.Consultas.InsertInto(str_conn, sqlIns2);
                        exec2 = DataBase.Consultas.InsertInto(str_conn, sqlIns3);
                        if (exec2 != "OK")
                        {
                            lblErrorFileUpload.Text = "Falha na importação: " + exec2;
                        }
                        gridCenarios.DataBind();
                        AtualizaGrafico();
                        if (File.Exists(Session["fileName"].ToString()))
                            File.Delete(Session["fileName"].ToString());
                        popupImportaExcel.ShowOnPageLoad = false;
                    }
                    else
                    {
                        fileImport.ClientEnabled = true;
                        lblErrorFileUpload.Text = "Falha na importação: Planilha não contém informações.";
                    }
                }
            }
        }
        protected void chartGeral_CustomCallback(object sender, DevExpress.XtraCharts.Web.CustomCallbackEventArgs e)
        {
            if (e.Parameter == "atualizar")
                AtualizaGrafico();
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {

            if (Session["Operacao"] == null)
            {
                Response.Redirect("JurosETTJ");
            }
            else
            {
                Response.Redirect(currentPage);
            }
        }
        protected void txtDtAplic_Init(object sender, EventArgs e)
        {
            DateTime date = new DateTime(DateTime.Now.Year,DateTime.Now.Month,1);
            txtDtAplic.MinDate = date;
        }

        protected void chartGeral_CustomDrawSeriesPoint(object sender, CustomDrawSeriesPointEventArgs e)
        {
            if (e.SeriesDrawOptions is BarDrawOptions)
            {
                ((BarDrawOptions)e.SeriesDrawOptions).FillStyle.FillMode = FillMode.Solid;
                ((BarDrawOptions)e.SeriesDrawOptions).Color = Color.FromArgb(77, 146, 135);
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

        protected void gridCenarios_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }

        protected void btnNovoCenario_Load(object sender, EventArgs e)
        {
            ASPxButton obj = (ASPxButton)sender;
            obj.Enabled = perfil != "3";
        }
    }
}