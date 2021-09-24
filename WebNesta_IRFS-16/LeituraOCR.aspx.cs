using DevExpress.Pdf;
using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class LeituraOCR : BasePage.BasePage
    {
        public static string lang;
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string usuarioPersist;
        public static bool acessoInternet;
        public static DataTable dtInventario;
        public static DataTable gridDT;
        public static DataTable gridDTNao;
        public static CultureInfo cultureBR = new CultureInfo("pt-BR");
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
                //getSemLayout();
                //getNaoLidos();
                //getLidos();
            }
            if (IsPostBack)
            {                
                if (Session["dtInventario"] != null)
                {
                    dtInventario = (DataTable)Session["dtInventario"];
                    gridInventario.DataSource = dtInventario;
                    gridInventario.DataBind();
                }
                if (Session["gridDT"] != null)
                {
                    gridDT = (DataTable)Session["gridDT"];
                    gridLidos.DataSource = gridDT;
                    gridLidos.DataBind();
                }
                if (Session["gridDTNao"] != null)
                {
                    gridDTNao = (DataTable)Session["gridDTNao"];
                    gridNaoLidos.DataSource = gridDTNao;
                    gridNaoLidos.DataBind();
                }
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                usuarioPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
            }
            DataBase.Consultas.Usuario = usuarioPersist;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        #region Chamadas Grid
        protected void getSemLayout()
        {
            dtInventario = new DataTable();
            dtInventario.Columns.Add("PDF", typeof(string));
            dtInventario.Columns.Add("url", typeof(string));
            dtInventario.Columns.Add("Data", typeof(DateTime));
            dtInventario.Columns.Add("Contrato", typeof(string));
            dtInventario.Columns.Add("Layout", typeof(string));
            string dir = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"];
            dir = Server.MapPath(dir);
            var dirInfo = new DirectoryInfo(dir);
            var list = dirInfo.GetFiles("*.pdf");
            if (list.Length > 0)
            {
                foreach (var file in list)
                {
                    DataRow row = dtInventario.NewRow();
                    row["PDF"] = file.Name;
                    row["url"] = file.FullName;
                    row["Data"] = file.CreationTime;
                    bool contrato = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from opcontra where opidcont=" + file.Name.Split('_')[0], 1)[0]) > 0;
                    row["Contrato"] = contrato ? file.Name.Split('_')[0] : "0000";
                    if (contrato)
                    {
                        if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from LAYOPASS where opidcont=" + file.Name.Split('_')[0], 1)[0]) == 0)
                        {
                            row["Layout"] = "";
                            dtInventario.Rows.Add(row);
                        }
                        else
                        {
                            string dir_Lay = DataBase.Consultas.Consulta(str_conn, "select PA.LAYDIRPA from LAYPDFPA PA, LAYOPASS OP WHERE OP.LAYIDPAI=PA.LAYIDPAI AND OP.OPIDCONT=" + file.Name.Split('_')[0], 1)[0];
                            string destino = Path.Combine(dir, dir_Lay, file.Name);
                            File.Move(file.FullName, destino);
                        }
                    }
                    else
                    {
                        row["Layout"] = "";
                        dtInventario.Rows.Add(row);
                    }
                }
            }
            dtInventario.TableName = "Inventario";
            Session["dtInventario"] = dtInventario;
            gridInventario.DataSource = dtInventario;
            gridInventario.DataBind();
        }
        protected void getLidos()
        {
            cultureBR.NumberFormat.NumberDecimalSeparator = ",";
            cultureBR.NumberFormat.NumberGroupSeparator = ".";
            gridDT = new DataTable();
            gridDT.Columns.Add("PDF");
            gridDT.Columns.Add("Layout");
            foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA from MODALIDA where MOTPIDCA = 10").Rows)
            {
                if (row[0].ToString() == "9")
                {
                    DataColumn colDateTime = new DataColumn(row[0].ToString());
                    colDateTime.DataType = System.Type.GetType("System.DateTime");
                    gridDT.Columns.Add(colDateTime);
                }
                else
                    gridDT.Columns.Add(row[0].ToString());

            }
            foreach (DataRow row1 in DataBase.Consultas.Consulta(str_conn, "select LAYIDPAI from LAYPDFPA").Rows)
            {
                string layoutID = row1[0].ToString();
                string sqlSelect = "select filho.LAYLFFIL,filho.LAYRGFIL,filho.LAYTPFIL,filho.LAYBTFIL,filho.LAYIDCLA,filho.LAYNMFIL,filho.LAYCORFL,filho.LAYQTFIL,filho.LAYTIPOF, pai.LAYNMPAI " +
                                    "from LAYPDFPA pai, LAYPDFFI filho, LAYPDFCL cl " +
                                    "WHERE pai.LAYIDPAI = filho.LAYIDPAI " +
                                      "and filho.LAYIDCLA = cl.LAYIDCLA " +
                                      "and pai.LAYIDPAI = " + layoutID + " " +
                                      "union all " +
                                        "select filho.LAYLFFIL,filho.LAYRGFIL,filho.LAYTPFIL,filho.LAYBTFIL,m.MOIDMODA,filho.LAYNMFIL,filho.LAYCORFL,filho.LAYQTFIL,filho.LAYTIPOF, pai.LAYNMPAI " +
                                        "from LAYPDFPA pai, LAYPDFFI filho, LAYPDFCL cl, MODALIDA M " +
                                        " WHERE pai.LAYIDPAI = filho.LAYIDPAI " +
                                            "and M.MOIDMODA = filho.MOIDMODA " +
                                            "and M.LAYIDCLA = cl.LAYIDCLA " +
                                            "and pai.LAYIDPAI = " + layoutID + "";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlSelect);
                string dir = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"] + DataBase.Consultas.Consulta(str_conn, "select pai.LAYDIRPA from LAYPDFPA pai WHERE pai.LAYIDPAI = " + layoutID + "", 1)[0];
                dir = Server.MapPath(dir);
                var dirInfo = new DirectoryInfo(dir);
                var list = dirInfo.GetFiles("*.pdf");
                if (list.Length > 0)
                {
                    foreach (var file in list)
                    {
                        DataRow gridDTRow = gridDT.NewRow();
                        DataTable dtColumn = DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA,LAYNMCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA, MODSMODA from MODALIDA where MOTPIDCA = 10");
                        gridDTRow["PDF"] = file.Name;
                        foreach (DataRow dtColumnRow in dtColumn.Rows)
                        {
                            foreach (DataRow row in dt.Rows)
                            {
                                gridDTRow["Layout"] = row["LAYNMPAI"].ToString();
                                double left, bottom, right, top;
                                left = Convert.ToDouble(row["LAYLFFIL"].ToString());
                                bottom = Convert.ToDouble(row["LAYBTFIL"].ToString());
                                right = Convert.ToDouble(row["LAYRGFIL"].ToString());
                                top = Convert.ToDouble(row["LAYTPFIL"].ToString());
                                bool combinado = row["LAYCORFL"].ToString() == "0" ? true : false;
                                string result;
                                if (testePDF(file.FullName))
                                {
                                    result = FindCordinate(file.FullName, left, bottom, right, top, row["LAYNMFIL"].ToString(), combinado, Convert.ToInt32(row["LAYQTFIL"].ToString()));
                                }
                                else
                                {
                                    string novoPdf = CriarPDF(file.FullName);
                                    result = FindCordinate(novoPdf, left, bottom, right, top, row["LAYNMFIL"].ToString(), combinado, Convert.ToInt32(row["LAYQTFIL"].ToString()));
                                }
                                if (dtColumnRow["LAYIDCLA"].ToString() == row["LAYIDCLA"].ToString())
                                {
                                    if (row["LAYTIPOF"].ToString() == "Int")
                                    {
                                        decimal vl = Convert.ToDecimal(gridDTRow[dtColumnRow["LAYIDCLA"].ToString()].ToString() == string.Empty ? "0" : gridDTRow[dtColumnRow["LAYIDCLA"].ToString()].ToString());
                                        decimal resultD = Convert.ToDecimal(result.Replace("Input data is not recognized as valid pdf.", string.Empty) == string.Empty ? "0" : result.Replace("Input data is not recognized as valid pdf.", string.Empty), cultureBR);
                                        if (vl != 0)
                                        {
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = (vl + resultD).ToString("N2");
                                        }
                                        else
                                        {
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = resultD.ToString("N2");
                                        }
                                    }
                                    else
                                    {
                                        if (row["LAYIDCLA"].ToString() == "8")
                                        {
                                            string sqlTeste = "select opidcont from  opcontra where opcdcont='" + result.Replace("Input data is not recognized as valid pdf.", string.Empty).Trim() + "'";
                                            string opidcont = DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0];
                                            if (opidcont == null)
                                            {
                                                string sql = "select opidcont from opcontra where OPCDCONT='" + file.Name.Split('#')[0] + "'";
                                                opidcont = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                                gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = opidcont;
                                            }
                                            else
                                            {
                                                gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = opidcont;
                                            }
                                        }
                                        else if (row["LAYIDCLA"].ToString() == "9")
                                        {
                                            DateTime date = Convert.ToDateTime(result.Replace("Input data is not recognized as valid pdf.", string.Empty).Trim(), cultureBR);
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = date.ToShortDateString();
                                        }
                                        else if (row["LAYIDCLA"].ToString() == "11")
                                        {
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = result.Replace("Input data is not recognized as valid pdf.", string.Empty).Trim();
                                        }
                                        else
                                        {
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = result.Replace("Input data is not recognized as valid pdf.", string.Empty).Trim();
                                        }
                                    }
                                }
                            }
                        }
                        if (ValidaLinhaPDF(gridDTRow))
                        {
                            gridDT.Rows.Add(gridDTRow);
                        }
                    }
                }
            }
            gridDT.TableName = "VALORES_PDF";
            Session["gridDT"] = gridDT;
            gridLidos.DataSource = gridDT;
            gridLidos.DataBind();
        }
        protected void getNaoLidos()
        {
            cultureBR.NumberFormat.NumberDecimalSeparator = ",";
            cultureBR.NumberFormat.NumberGroupSeparator = ".";
            gridDTNao = new DataTable();
            gridDTNao.Columns.Add("PDF");
            gridDTNao.Columns.Add("Layout");
            foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA from MODALIDA where MOTPIDCA = 10").Rows)
            {
                if (row[0].ToString() == "9")
                {
                    DataColumn colDateTime = new DataColumn(row[0].ToString());
                    colDateTime.DataType = System.Type.GetType("System.DateTime");
                    gridDTNao.Columns.Add(colDateTime);
                }
                else
                    gridDTNao.Columns.Add(row[0].ToString());

            }
            foreach (DataRow row1 in DataBase.Consultas.Consulta(str_conn, "select LAYIDPAI from LAYPDFPA").Rows)
            {
                string layoutID = row1[0].ToString();
                string sqlSelect = "select filho.LAYLFFIL,filho.LAYRGFIL,filho.LAYTPFIL,filho.LAYBTFIL,filho.LAYIDCLA,filho.LAYNMFIL,filho.LAYCORFL,filho.LAYQTFIL,filho.LAYTIPOF, pai.LAYNMPAI " +
                                    "from LAYPDFPA pai, LAYPDFFI filho, LAYPDFCL cl " +
                                    "WHERE pai.LAYIDPAI = filho.LAYIDPAI " +
                                      "and filho.LAYIDCLA = cl.LAYIDCLA " +
                                      "and pai.LAYIDPAI = " + layoutID + " " +
                                      "union all " +
                                        "select filho.LAYLFFIL,filho.LAYRGFIL,filho.LAYTPFIL,filho.LAYBTFIL,m.MOIDMODA,filho.LAYNMFIL,filho.LAYCORFL,filho.LAYQTFIL,filho.LAYTIPOF, pai.LAYNMPAI " +
                                        "from LAYPDFPA pai, LAYPDFFI filho, LAYPDFCL cl, MODALIDA M " +
                                        " WHERE pai.LAYIDPAI = filho.LAYIDPAI " +
                                            "and M.MOIDMODA = filho.MOIDMODA " +
                                            "and M.LAYIDCLA = cl.LAYIDCLA " +
                                            "and pai.LAYIDPAI = " + layoutID + "";
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlSelect);
                string dir = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"] + DataBase.Consultas.Consulta(str_conn, "select pai.LAYDIRPA from LAYPDFPA pai WHERE pai.LAYIDPAI = " + layoutID + "", 1)[0];
                dir = Server.MapPath(dir);
                var dirInfo = new DirectoryInfo(dir);
                var list = dirInfo.GetFiles("*.pdf");
                if (list.Length > 0)
                {
                    foreach (var file in list)
                    {
                        DataRow gridDTRow = gridDTNao.NewRow();
                        DataTable dtColumn = DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA,LAYNMCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA, MODSMODA from MODALIDA where MOTPIDCA = 10");
                        gridDTRow["PDF"] = file.Name;
                        foreach (DataRow dtColumnRow in dtColumn.Rows)
                        {
                            foreach (DataRow row in dt.Rows)
                            {
                                gridDTRow["Layout"] = row["LAYNMPAI"].ToString();
                                double left, bottom, right, top;
                                left = Convert.ToDouble(row["LAYLFFIL"].ToString());
                                bottom = Convert.ToDouble(row["LAYBTFIL"].ToString());
                                right = Convert.ToDouble(row["LAYRGFIL"].ToString());
                                top = Convert.ToDouble(row["LAYTPFIL"].ToString());
                                bool combinado = row["LAYCORFL"].ToString() == "0" ? true : false;
                                string result;
                                if (testePDF(file.FullName))
                                {
                                    result = FindCordinate(file.FullName, left, bottom, right, top, row["LAYNMFIL"].ToString(), combinado, Convert.ToInt32(row["LAYQTFIL"].ToString()));
                                }
                                else
                                {
                                    string novoPdf = CriarPDF(file.FullName);
                                    result = FindCordinate(novoPdf, left, bottom, right, top, row["LAYNMFIL"].ToString(), combinado, Convert.ToInt32(row["LAYQTFIL"].ToString()));
                                }
                                if (dtColumnRow["LAYIDCLA"].ToString() == row["LAYIDCLA"].ToString())
                                {
                                    if (row["LAYTIPOF"].ToString() == "Int")
                                    {
                                        decimal vl = Convert.ToDecimal(gridDTRow[dtColumnRow["LAYIDCLA"].ToString()].ToString() == string.Empty ? "0" : gridDTRow[dtColumnRow["LAYIDCLA"].ToString()].ToString());
                                        decimal resultD = Convert.ToDecimal(result.Replace("Input data is not recognized as valid pdf.", string.Empty) == string.Empty ? "0" : result.Replace("Input data is not recognized as valid pdf.", string.Empty), cultureBR);
                                        if (vl != 0)
                                        {
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = (vl + resultD).ToString("N2");
                                        }
                                        else
                                        {
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = resultD.ToString("N2");
                                        }
                                    }
                                    else
                                    {
                                        if (row["LAYIDCLA"].ToString() == "8")
                                        {
                                            string sqlTeste = "select opidcont from  opcontra where opcdcont='" + result.Replace("Input data is not recognized as valid pdf.", string.Empty).Trim() + "'";
                                            string opidcont = DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0];
                                            if(opidcont==null)
                                            {
                                                string sql = "select opidcont from opcontra where OPCDCONT='" + file.Name.Split('#')[0] + "'";
                                                opidcont = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                                gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = opidcont;
                                            }
                                            else
                                            {
                                                gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = opidcont;
                                            }
                                            
                                        }
                                        else if (row["LAYIDCLA"].ToString() == "9")
                                        {
                                            DateTime date = Convert.ToDateTime(result.Replace("Input data is not recognized as valid pdf.", string.Empty).Trim(), cultureBR);
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = date.ToShortDateString();
                                        }
                                        else
                                        {
                                            gridDTRow[dtColumnRow["LAYIDCLA"].ToString()] = result.Replace("Input data is not recognized as valid pdf.", string.Empty).Trim();
                                        }
                                    }
                                }
                            }
                        }
                        if (!ValidaLinhaPDF(gridDTRow))
                        {
                            gridDTNao.Rows.Add(gridDTRow);
                        }
                    }
                }
            }
            gridDTNao.TableName = "VALORES_PDF";
            Session["gridDTNao"] = gridDTNao;
            gridNaoLidos.DataSource = gridDTNao;
            gridNaoLidos.DataBind();
        }
        protected bool ValidaLinhaPDF(DataRow linha)
        {
            bool resultado = false;
            var Class = DataBase.Consultas.Consulta(str_conn, "select MOIDMODA from MODALIDA where MOTPIDCA=10");
            decimal valor = 0;
            foreach (DataRow class1 in Class.Rows)
            {
                decimal current = Decimal.TryParse(linha[class1["MOIDMODA"].ToString()].ToString(), out current) ? Convert.ToDecimal(linha[class1["MOIDMODA"].ToString()].ToString()) : 0;
                valor = valor + current;
            }
            decimal total = Decimal.TryParse(linha["10"].ToString(), out total) ? Convert.ToDecimal(linha["10"].ToString()) : 0;
            if (valor == total)
            {
                resultado = true;
            }
            else
            {
                resultado = false;
            }
            return resultado;
        }
        #endregion
        #region Events from Grids
        protected void gridInventario_DataBinding(object sender, EventArgs e)
        {
            gridInventario.Columns.Clear();
            GridViewDataHyperLinkColumn c1 = new GridViewDataHyperLinkColumn();
            c1.FieldName = "url";
            c1.Visible = false;
            c1.VisibleIndex = 0;
            gridInventario.Columns.Add(c1);
            GridViewDataTextColumn c2 = new GridViewDataTextColumn();
            c2.FieldName = "PDF";
            c2.Caption = "PDF";
            c2.ReadOnly = true;
            c2.VisibleIndex = 1;
            gridInventario.Columns.Add(c2);
            GridViewDataTextColumn c3 = new GridViewDataTextColumn();
            c3.FieldName = "Data";
            c3.Caption = "Data";
            c3.ReadOnly = true;
            c3.VisibleIndex = 2;
            gridInventario.Columns.Add(c3);
            GridViewDataTextColumn c4 = new GridViewDataTextColumn();
            c4.FieldName = "Contrato";
            c4.Caption = "Contrato";
            c4.ReadOnly = true;
            c4.VisibleIndex = 3;
            gridInventario.Columns.Add(c4);
            GridViewDataComboBoxColumn c5 = new GridViewDataComboBoxColumn();
            c5.FieldName = "Layout";
            c5.Caption = "Layout";
            c5.PropertiesComboBox.DataSource = DataBase.Consultas.Consulta(str_conn, "select LAYIDPAI,LAYNMPAI from LAYPDFPA ORDER BY 2");
            c5.PropertiesComboBox.ValueType = typeof(Int32);
            c5.PropertiesComboBox.ValueField = "LAYIDPAI";
            c5.PropertiesComboBox.TextField = "LAYNMPAI";
            c5.VisibleIndex = 4;
            gridInventario.Columns.Add(c5);
            GridViewCommandColumn columnBtn = new GridViewCommandColumn();
            columnBtn.Caption = " ";
            GridViewCommandColumnCustomButton btn = new GridViewCommandColumnCustomButton();
            btn.ID = "btnLayout";
            btn.Text = "Criar Layout";
            btn.Visibility = GridViewCustomButtonVisibility.Invisible;
            columnBtn.CustomButtons.Add(btn);
            gridInventario.Columns.Add(columnBtn);
            //gridInventario.KeyFieldName = "PDF";
        }
        protected void gridInventario_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            dtInventario = (DataTable)Session["dtInventario"];
            if (e.UpdateValues.Count == 0) return;
            string key = e.UpdateValues[0].Keys[0].ToString();
            DataRow[] rows = dtInventario.Select("PDF='" + key + "'");//.FirstOrDefault(); // finds all rows with id==2 and selects first or null if haven't found any
            foreach (DataRow row in rows)
            {
                foreach (var item in e.UpdateValues)
                {
                    if (item.OldValues["Contrato"].ToString() != "0000")
                    {
                        row["Layout"] = item.NewValues["Layout"].ToString();
                        dtInventario.AcceptChanges();
                        row.SetModified();


                        string sqlIns = "INSERT INTO LAYOPASS (LAYIDPAI,OPIDCONT) VALUES (@LAYIDPAI,@OPIDCONT)";
                        sqlIns = sqlIns.Replace("@LAYIDPAI", item.NewValues["Layout"].ToString());
                        sqlIns = sqlIns.Replace("@OPIDCONT", item.OldValues["Contrato"].ToString());
                        string sqlUpd = "UPDATE LAYOPASS SET LAYIDPAI=@LAYIDPAI WHERE OPIDCONT=@OPIDCONT";
                        sqlUpd = sqlUpd.Replace("@LAYIDPAI", item.NewValues["Layout"].ToString());
                        sqlUpd = sqlUpd.Replace("@OPIDCONT", item.OldValues["Contrato"].ToString());
                        string sqlTeste = "select COUNT(*) from LAYOPASS WHERE OPIDCONT=" + item.OldValues["Contrato"].ToString();
                        if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0]) > 0)
                        {
                            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                        }
                        else
                        {
                            string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns);
                        }
                        e.Handled = true;
                    }
                }
            }
            Session["dtInventario"] = dtInventario;
            gridInventario.DataSource = (DataTable)Session["dtInventario"];
            gridInventario.DataBind();
            if (e.Handled)
            {
                getSemLayout();
            }
        }
        protected void gridInventario_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex == -1) return;
            if (gridInventario.VisibleRowCount > 0)
            {
                try
                {
                    if (string.IsNullOrEmpty(((ASPxGridView)sender).GetRowValues(e.VisibleIndex, "Layout").ToString()))
                    {
                        e.Visible = DevExpress.Utils.DefaultBoolean.True;
                    }
                }
                catch (Exception ex)
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
        }
        protected void gridInventario_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            if (e.ButtonID == "btnLayout")
            {
                string nomePDF = gridInventario.GetRowValues(e.VisibleIndex, "PDF").ToString();
                string opidcont = gridInventario.GetRowValues(e.VisibleIndex, "Contrato").ToString();
                string originPDF = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"];
                string destinPDF = System.Configuration.ConfigurationManager.AppSettings["PathContratos"];
                string resultExtension = System.IO.Path.GetExtension(nomePDF);
                string resultFileName = System.IO.Path.ChangeExtension(System.IO.Path.GetRandomFileName(), resultExtension);
                string sourceFile = System.IO.Path.Combine(originPDF, nomePDF);
                string destFile = System.IO.Path.Combine(Server.MapPath(destinPDF), resultFileName);
                System.IO.File.Copy(sourceFile, destFile, true);
                Session["PDF"] = nomePDF;
                Session["PDFURL"] = System.IO.Path.Combine(destinPDF, resultFileName);
                ASPxWebControl.RedirectOnCallback("Layout?create=yes&cod=" + opidcont);
            }
        }
        protected void gridLidos_DataBinding(object sender, EventArgs e)
        {
            int widthDefault = 100;
            gridLidos.Columns.Clear();
            GridViewCommandColumn cmd = new GridViewCommandColumn();
            cmd.ShowSelectCheckbox = true;
            cmd.SelectAllCheckboxMode = GridViewSelectAllCheckBoxMode.None;
            cmd.VisibleIndex = 0;
            cmd.Caption = "  ";
            cmd.Width = Unit.Pixel(50);
            gridLidos.Columns.Add(cmd);
            GridViewDataTextColumn c = new GridViewDataTextColumn();
            c.FieldName = "PDF";
            c.Caption = "PDF";
            c.ReadOnly = true;
            c.Width = Unit.Pixel(widthDefault);
            c.VisibleIndex = 1;
            gridLidos.Columns.Add(c);
            GridViewDataTextColumn c1 = new GridViewDataTextColumn();
            c1.FieldName = "Layout";
            c1.Caption = "Layout";
            c1.ReadOnly = true;
            c1.Width = Unit.Pixel(widthDefault);
            c1.VisibleIndex = 2;
            gridLidos.Columns.Add(c1);
            int cont = 3;
            foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA,LAYNMCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA, MODSMODA from MODALIDA where MOTPIDCA = 10").Rows)
            {
                if (row[0].ToString() == "8")
                {
                    GridViewDataComboBoxColumn c2 = new GridViewDataComboBoxColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.PropertiesComboBox.DataSource = DataBase.Consultas.Consulta(str_conn, "select opcdcont,opidcont from opcontra");
                    c2.PropertiesComboBox.ValueType = typeof(Int32);
                    c2.PropertiesComboBox.ValueField = "opidcont";
                    c2.PropertiesComboBox.TextField = "opcdcont";
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridLidos.Columns.Add(c2);
                }
                else if (row[0].ToString() == "9")
                {
                    GridViewDataDateColumn c2 = new GridViewDataDateColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridLidos.Columns.Add(c2);
                }
                else if (row[0].ToString() == "11")
                {
                    GridViewDataTextColumn c2 = new GridViewDataTextColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridLidos.Columns.Add(c2);
                }
                else
                {
                    GridViewDataTextColumn c2 = new GridViewDataTextColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.PropertiesTextEdit.DisplayFormatString = "N2";
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridLidos.Columns.Add(c2);
                }
                cont++;
            }
            gridLidos.KeyFieldName = "PDF";
        }
        protected void gridLidos_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            gridDT = (DataTable)Session["gridDT"];
            if (e.UpdateValues.Count == 0) return;
            DataRow[] rows = gridDT.Select("PDF='" + e.UpdateValues[0].Keys[0].ToString() + "'");//.FirstOrDefault(); // finds all rows with id==2 and selects first or null if haven't found any
            foreach (DataRow row in rows)
            {
                foreach (var item in e.UpdateValues)
                {
                    var oldEnum = item.OldValues.GetEnumerator();
                    var newEnum = item.NewValues.GetEnumerator();
                    newEnum.Reset();
                    string fieldName = string.Empty;
                    while (newEnum.MoveNext())
                    {
                        if (newEnum.Key == null) continue;
                        if (newEnum.Value != null && item.OldValues[newEnum.Key].ToString() != newEnum.Value.ToString())
                        {
                            fieldName = newEnum.Key.ToString();
                            row[fieldName] = item.NewValues[fieldName].ToString();
                        }
                    }
                    gridDT.AcceptChanges();
                    row.SetModified();
                    e.Handled = true;
                }
            }
            Session["gridDT"] = gridDT;
            gridLidos.DataSource = (DataTable)Session["gridDT"];
            gridLidos.DataBind();
        }
        protected void gridLidos_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            if (gridLidos.VisibleRowCount > 0)
            {
                try
                {
                    decimal vl = 0;
                    foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT <> 1").Rows)
                    {
                        vl = vl + Convert.ToDecimal(((ASPxGridView)sender).GetRowValues(e.VisibleIndex, row[0].ToString()).ToString() == string.Empty ? "0" : ((ASPxGridView)sender).GetRowValues(e.VisibleIndex, row[0].ToString()));
                    }
                    decimal tl = Convert.ToDecimal(((ASPxGridView)sender).GetRowValues(e.VisibleIndex, "10"));
                    if (vl != tl)
                    {
                        e.Enabled = false;
                    }
                }
                catch (Exception ex)
                {
                    RegistraLog log = new RegistraLog();
                    log.SaveLog(ex);
                }
            }
        }
        protected void gridLidos_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            //if (e.RowType != GridViewRowType.Data) return;
            //decimal vl = 0;
            //foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT <> 1").Rows)
            //{
            //    vl = vl + Convert.ToDecimal(e.GetValue(row[0].ToString()).ToString() == string.Empty ? "0" : e.GetValue(row[0].ToString()));
            //}
            //decimal tl = Convert.ToDecimal(e.GetValue("10"));
            //if (vl != tl)
            //{
            //    e.Row.ForeColor = System.Drawing.Color.LightGray;
            //}
        }
        protected void gridLidos_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "processar")
            {
                string dir = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"];
                string codDT = lang == "en-US" ? "101" : "103";
                string sqlInsert = "INSERT INTO BOLVERBA " +
                                   "(MOIDMODA " +
                                   ", BVDTTRAN " +
                                   ", BVVLVERB " +
                                   ", BVVALIDA " +
                                   ", OPIDCONT " +
                                   ", BVAPROVA,BVDTVENC,BOLIDBOL) " +
                             "VALUES " +
                                   "(@moidmoda " +
                                   ", convert(date, '@data', " + codDT + ") " +
                                   ", @valor " +
                                   ", 1 " +
                                   ", @opidcont " +
                                   ", 0, convert(date,'@data_venc'," + codDT + "),@bolidbol)";
                string sqlBoleto = "INSERT INTO BOLTOTBO " +
                                   "(BOLCDBOL " +
                                   ", BOLDTVCT " +
                                   ", BOLVLBOL " +
                                   ", BOLNMBOL " +
                                   ", OPIDCONT,BOLTPBOL,BOLSTBOL,BOLTPBOL) " +
                             "VALUES " +
                                   "('@BOLCDBOL' " +
                                   ", convert(date, '@BOLDTVCT', " + codDT + ") " +
                                   ", @BOLVLBOL " +
                                   ", '@BOLNMBOL' " +
                                   ", @OPIDCONT,'@BOLTPBOL',0,'T')";
                for (int i = 0; i < gridLidos.VisibleRowCount; i++)
                {
                    if (gridLidos.Selection.IsRowSelected(i))
                    {
                        string moidmoda = string.Empty;
                        string data = string.Empty;
                        string BOLDTVCT = string.Empty;
                        string BOLVLBOL = string.Empty;
                        string BOLCDBOL = string.Empty;
                        string BOLTPBOL = DataBase.Consultas.Consulta(str_conn, "select BOLTPBOL from LAYPDFPA where LAYNMPAI='" + gridLidos.GetRowValues(i, "Layout").ToString() + "'", 1)[0];
                        string BOLNMBOL = gridLidos.GetRowValues(i, "PDF").ToString();
                        string valor = string.Empty;
                        string opidcont = string.Empty;
                        string bolidbol = string.Empty;
                        DataTable dt = DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA from MODALIDA where MOTPIDCA = 10");
                        DataTable dt2 = DataBase.Consultas.Consulta(str_conn, "select MOIDMODA from MODALIDA where MOTPIDCA = 10");
                        string[] fields = new string[dt.Rows.Count];
                        string[] fields2 = new string[dt2.Rows.Count];
                        int j = 0;
                        foreach (DataRow row in dt.Rows)
                        {
                            fields[j] = row[0].ToString();
                            j++;
                        }
                        object[] values = gridLidos.GetRowValues(i, fields) as object[];
                        for (int k = 0; k < values.Length; k++)
                        {
                            if (fields[k] == "8")
                                opidcont = values[k].ToString();
                            else if (fields[k] == "9")
                                BOLDTVCT = Convert.ToDateTime(values[k], CultureInfo.GetCultureInfo(lang)).ToShortDateString();
                            else if (fields[k] == "10")
                                BOLVLBOL = values[k].ToString().Replace(".", "").Replace(",", ".");
                            else if (fields[k] == "11")
                                BOLCDBOL = values[k].ToString();
                        }
                        sqlBoleto = sqlBoleto.Replace("@BOLCDBOL", BOLCDBOL.Replace(" ", "").Replace(".", "").Replace("-", ""));
                        sqlBoleto = sqlBoleto.Replace("@BOLDTVCT", BOLDTVCT);
                        sqlBoleto = sqlBoleto.Replace("@BOLVLBOL", BOLVLBOL);
                        sqlBoleto = sqlBoleto.Replace("@OPIDCONT", opidcont);
                        sqlBoleto = sqlBoleto.Replace("@BOLNMBOL", BOLNMBOL);
                        sqlBoleto = sqlBoleto.Replace("@BOLTPBOL", BOLTPBOL);
                        if (DataBase.Consultas.InsertInto(str_conn, sqlBoleto) != "OK")
                            return;
                        else
                        {
                            bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(bolidbol) from boltotbo", 1)[0];
                        }
                        for (int k = 0; k < values.Length; k++)
                        {
                            if (fields[k] == "8")
                            {
                                opidcont = values[k].ToString();
                            }
                            else if (fields[k] == "9")
                            {
                                data = Convert.ToDateTime(values[k], CultureInfo.GetCultureInfo(lang)).ToShortDateString();
                            }
                            else if (fields[k] != "10")
                            {
                                sqlInsert = "INSERT INTO BOLVERBA " +
                                   "(MOIDMODA " +
                                   ", BVDTTRAN " +
                                   ", BVVLVERB " +
                                   ", BVVALIDA " +
                                   ", OPIDCONT " +
                                   ", BVAPROVA, BVDTVENC,BOLIDBOL,USIDUSUA,BVFLFLAG,) " +
                             "VALUES " +
                                   "(@moidmoda " +
                                   ", getdate() " +
                                   ", @valor " +
                                   ", 1 " +
                                   ", " + opidcont + " " +
                                   ", 0,convert(date,'" + data + "'," + codDT + ")," + bolidbol + ",'"+usuarioPersist+"',15)";
                                moidmoda = fields[k];
                                valor = values[k].ToString().Replace(".", "").Replace(",", ".");
                                if (Decimal.TryParse(valor,out decimal dec_valor))// valor != string.Empty)
                                {
                                    sqlInsert = sqlInsert.Replace("@moidmoda", moidmoda);
                                    sqlInsert = sqlInsert.Replace("@valor", valor);
                                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                                }
                            }
                        }
                        string dirLay = DataBase.Consultas.Consulta(str_conn, "select LAYDIRPA from LAYPDFPA where LAYNMPAI='" + gridLidos.GetRowValues(i, "Layout").ToString() + "'", 1)[0];
                        string fileName = gridLidos.GetRowValues(i, "PDF").ToString();
                        string origem = Path.Combine(dir, dirLay, fileName);
                        string destino = Path.Combine(dir, dirLay, "OK", fileName);
                        File.Move(origem, destino);
                    }
                }
            }
            getLidos();
        }
        protected void gridNaoLidos_DataBinding(object sender, EventArgs e)
        {
            int widthDefault = 100;
            gridNaoLidos.Columns.Clear();
            GridViewCommandColumn cmd = new GridViewCommandColumn();
            cmd.ShowSelectCheckbox = true;
            cmd.SelectAllCheckboxMode = GridViewSelectAllCheckBoxMode.None;
            cmd.VisibleIndex = 0;
            cmd.Caption = "  ";
            cmd.Width = Unit.Pixel(50);
            gridNaoLidos.Columns.Add(cmd);
            GridViewDataTextColumn c = new GridViewDataTextColumn();
            c.FieldName = "PDF";
            c.Caption = "PDF";
            c.ReadOnly = true;
            c.Width = Unit.Pixel(widthDefault);
            c.VisibleIndex = 1;
            gridNaoLidos.Columns.Add(c);
            GridViewDataTextColumn c1 = new GridViewDataTextColumn();
            c1.FieldName = "Layout";
            c1.Caption = "Layout";
            c1.ReadOnly = true;
            c1.Width = Unit.Pixel(widthDefault);
            c1.VisibleIndex = 2;
            gridNaoLidos.Columns.Add(c1);
            int cont = 3;
            foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA,LAYNMCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA, MODSMODA from MODALIDA where MOTPIDCA = 10").Rows)
            {
                if (row[0].ToString() == "8")
                {
                    GridViewDataComboBoxColumn c2 = new GridViewDataComboBoxColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.PropertiesComboBox.DataSource = DataBase.Consultas.Consulta(str_conn, "select opcdcont,opidcont from opcontra");
                    c2.PropertiesComboBox.ValueType = typeof(Int32);
                    c2.PropertiesComboBox.ValueField = "opidcont";
                    c2.PropertiesComboBox.TextField = "opcdcont";
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridNaoLidos.Columns.Add(c2);
                }
                else if (row[0].ToString() == "9")
                {
                    GridViewDataDateColumn c2 = new GridViewDataDateColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridNaoLidos.Columns.Add(c2);
                }
                else if (row[0].ToString() == "11")
                {
                    GridViewDataTextColumn c2 = new GridViewDataTextColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridNaoLidos.Columns.Add(c2);
                }
                else
                {
                    GridViewDataTextColumn c2 = new GridViewDataTextColumn();
                    c2.FieldName = row[0].ToString();
                    c2.Caption = row[1].ToString();
                    c2.PropertiesTextEdit.DisplayFormatString = "N2";
                    c2.VisibleIndex = cont;
                    c2.Width = Unit.Pixel(widthDefault);
                    gridNaoLidos.Columns.Add(c2);
                }
                cont++;
            }
            //gridNaoLidos.KeyFieldName = "PDF";
        }
        protected void gridNaoLidos_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            gridDTNao = (DataTable)Session["gridDTNao"];
            if (e.UpdateValues.Count == 0) return;
            DataRow[] rows = gridDTNao.Select("PDF='" + e.UpdateValues[0].Keys[0].ToString() + "'");//.FirstOrDefault(); // finds all rows with id==2 and selects first or null if haven't found any
            foreach (DataRow row in rows)
            {
                foreach (var item in e.UpdateValues)
                {
                    var oldEnum = item.OldValues.GetEnumerator();
                    var newEnum = item.NewValues.GetEnumerator();
                    newEnum.Reset();
                    string fieldName = string.Empty;
                    while (newEnum.MoveNext())
                    {
                        if (newEnum.Key == null) continue;
                        if (newEnum.Value != null && item.OldValues[newEnum.Key].ToString() != newEnum.Value.ToString())
                        {
                            fieldName = newEnum.Key.ToString();
                            row[fieldName] = item.NewValues[fieldName].ToString();
                        }
                    }
                    gridDTNao.AcceptChanges();
                    row.SetModified();
                    e.Handled = true;
                }
            }
            Session["gridDTNao"] = gridDTNao;
            gridNaoLidos.DataSource = (DataTable)Session["gridDTNao"];
            gridNaoLidos.DataBind();
        }
        protected void gridNaoLidos_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {

        }
        protected void gridNaoLidos_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
        {
            //if (e.VisibleIndex < 0) return;
            //if (gridNaoLidos.VisibleRowCount > 0)
            //{
            //    try
            //    {
            //        decimal vl = 0;
            //        foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT <> 1").Rows)
            //        {
            //            vl = vl + Convert.ToDecimal(((ASPxGridView)sender).GetRowValues(e.VisibleIndex, row[0].ToString()).ToString() == string.Empty ? "0" : ((ASPxGridView)sender).GetRowValues(e.VisibleIndex, row[0].ToString()));
            //        }
            //        decimal tl = Convert.ToDecimal(((ASPxGridView)sender).GetRowValues(e.VisibleIndex, "10"));
            //        if (vl != tl)
            //        {
            //            e.Enabled = false;
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        RegistraLog log = new RegistraLog();
            //        log.SaveLog(ex);
            //    }
            //}
        }
        protected void gridNaoLidos_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "processar")
            {
                string dir = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"];
                string codDT = lang == "en-US" ? "101" : "103";
                string sqlInsert = "INSERT INTO BOLVERBA " +
                                   "(MOIDMODA " +
                                   ", BVDTTRAN " +
                                   ", BVVLVERB " +
                                   ", BVVALIDA " +
                                   ", OPIDCONT " +
                                   ", BVAPROVA,BVDTVENC,BOLIDBOL) " +
                             "VALUES " +
                                   "(@moidmoda " +
                                   ", convert(date, '@data', " + codDT + ") " +
                                   ", @valor " +
                                   ", 1 " +
                                   ", @opidcont " +
                                   ", 0, convert(date,'@data_venc'," + codDT + "),@bolidbol)";
                string sqlBoleto = "INSERT INTO BOLTOTBO " +
                                   "(BOLCDBOL " +
                                   ", BOLDTVCT " +
                                   ", BOLVLBOL " +
                                   ", BOLNMBOL " +
                                   ", OPIDCONT,BOLTPBOL,BOLSTBOL,BOLTPBOL) " +
                             "VALUES " +
                                   "('@BOLCDBOL' " +
                                   ", convert(date, '@BOLDTVCT', " + codDT + ") " +
                                   ", @BOLVLBOL " +
                                   ", '@BOLNMBOL' " +
                                   ", @OPIDCONT,'@BOLTPBOL',0,'T')";
                for (int i = 0; i < gridNaoLidos.VisibleRowCount; i++)
                {
                    if (gridNaoLidos.Selection.IsRowSelected(i))
                    {
                        string moidmoda = string.Empty;
                        string data = string.Empty;
                        string BOLDTVCT = string.Empty;
                        string BOLVLBOL = string.Empty;
                        string BOLCDBOL = string.Empty;
                        string BOLTPBOL = DataBase.Consultas.Consulta(str_conn, "select BOLTPBOL from LAYPDFPA where LAYNMPAI='" + gridNaoLidos.GetRowValues(i, "Layout").ToString() + "'", 1)[0];
                        string BOLNMBOL = gridNaoLidos.GetRowValues(i, "PDF").ToString();
                        string valor = string.Empty;
                        string opidcont = string.Empty;
                        string bolidbol = string.Empty;
                        DataTable dt = DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT=1 union all select MOIDMODA from MODALIDA where MOTPIDCA = 10");
                        DataTable dt2 = DataBase.Consultas.Consulta(str_conn, "select MOIDMODA from MODALIDA where MOTPIDCA = 10");
                        string[] fields = new string[dt.Rows.Count];
                        string[] fields2 = new string[dt2.Rows.Count];
                        int j = 0;
                        foreach (DataRow row in dt.Rows)
                        {
                            fields[j] = row[0].ToString();
                            j++;
                        }
                        object[] values = gridNaoLidos.GetRowValues(i, fields) as object[];
                        for (int k = 0; k < values.Length; k++)
                        {
                            if (fields[k] == "8")
                                opidcont = values[k].ToString();
                            else if (fields[k] == "9")
                                BOLDTVCT = Convert.ToDateTime(values[k], CultureInfo.GetCultureInfo(lang)).ToShortDateString();
                            else if (fields[k] == "10")
                                BOLVLBOL = values[k].ToString().Replace(".", "").Replace(",", ".");
                            else if (fields[k] == "11")
                                BOLCDBOL = values[k].ToString();
                        }
                        sqlBoleto = sqlBoleto.Replace("@BOLCDBOL", BOLCDBOL.Replace(" ", "").Replace(".", "").Replace("-", ""));
                        sqlBoleto = sqlBoleto.Replace("@BOLDTVCT", BOLDTVCT);
                        sqlBoleto = sqlBoleto.Replace("@BOLVLBOL", BOLVLBOL);
                        sqlBoleto = sqlBoleto.Replace("@OPIDCONT", opidcont);
                        sqlBoleto = sqlBoleto.Replace("@BOLNMBOL", BOLNMBOL);
                        sqlBoleto = sqlBoleto.Replace("@BOLTPBOL", BOLTPBOL);
                        if (DataBase.Consultas.InsertInto(str_conn, sqlBoleto) != "OK")
                            return;
                        else
                        {
                            bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(bolidbol) from boltotbo", 1)[0];
                        }
                        for (int k = 0; k < values.Length; k++)
                        {
                            if (fields[k] == "8")
                            {
                                opidcont = values[k].ToString();
                            }
                            else if (fields[k] == "9")
                            {
                                data = Convert.ToDateTime(values[k], CultureInfo.GetCultureInfo(lang)).ToShortDateString();
                            }
                            else if (fields[k] != "10")
                            {
                                sqlInsert = "INSERT INTO BOLVERBA " +
                                   "(MOIDMODA " +
                                   ", BVDTTRAN " +
                                   ", BVVLVERB " +
                                   ", BVVALIDA " +
                                   ", OPIDCONT " +
                                   ", BVAPROVA, BVDTVENC,BOLIDBOL,USIDUSUA,BVFLFLAG,) " +
                             "VALUES " +
                                   "(@moidmoda " +
                                   ", getdate() " +
                                   ", @valor " +
                                   ", 1 " +
                                   ", " + opidcont + " " +
                                   ", 0,convert(date,'" + data + "'," + codDT + ")," + bolidbol + ",'" + usuarioPersist + "',15)";
                                moidmoda = fields[k];
                                valor = values[k].ToString().Replace(".", "").Replace(",", ".");
                                if (Decimal.TryParse(valor, out decimal dec_valor))// valor != string.Empty)
                                {
                                    sqlInsert = sqlInsert.Replace("@moidmoda", moidmoda);
                                    sqlInsert = sqlInsert.Replace("@valor", valor);
                                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                                }
                            }
                        }
                        string dirLay = DataBase.Consultas.Consulta(str_conn, "select LAYDIRPA from LAYPDFPA where LAYNMPAI='" + gridNaoLidos.GetRowValues(i, "Layout").ToString() + "'", 1)[0];
                        string fileName = gridNaoLidos.GetRowValues(i, "PDF").ToString();
                        string origem = Path.Combine(dir, dirLay, fileName);
                        string destino = Path.Combine(dir, dirLay, "OK", fileName);
                        File.Move(origem, destino);
                    }
                }
            }
            getNaoLidos();
        }
        #endregion
        #region Pesquisatexto
        public string FindCordinate(string filePath, double left, double bottom, double right, double top, string textoProcurar, bool combinado, int ocorrencia = 1)
        {
            CultureInfo culture = new CultureInfo("pt-BR");
            culture.NumberFormat.NumberDecimalSeparator = ",";
            string texto = string.Empty;
            try
            {
                using (PdfDocumentProcessor documentProcessor = new PdfDocumentProcessor())
                {
                    documentProcessor.LoadDocument(filePath);
                    for (int i = 0; i < documentProcessor.Document.Pages.Count; i++)
                    {
                        if (combinado)
                        {
                            PdfTextSearchParameters searchParameters = new PdfTextSearchParameters();
                            searchParameters.CaseSensitive = false;
                            searchParameters.WholeWords = true;
                            PdfTextSearchResults result;
                            int cont = 1;
                            while ((result = documentProcessor.FindText(textoProcurar, searchParameters)).Status == PdfTextSearchStatus.Found)
                            {
                                if (cont == ocorrencia)
                                {
                                    PdfOrientedRectangle lastRect = result.Rectangles.Last() as PdfOrientedRectangle;
                                    bottom = lastRect.Top - lastRect.Height;
                                    top = lastRect.Top;
                                    PdfDocumentArea rightArea = new PdfDocumentArea(i + 1, new DevExpress.Pdf.PdfRectangle(left, bottom, right, top));
                                    texto = documentProcessor.GetText(rightArea);
                                }
                                cont++;
                            }
                        }
                        else
                        {
                            PdfDocumentArea cordinateArea = new PdfDocumentArea(i + 1, new DevExpress.Pdf.PdfRectangle(left, bottom, right, top));
                            texto = documentProcessor.GetText(cordinateArea);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return texto;
        }
        public string CriarPDF(string filePath)
        {
            File.Move(filePath, filePath + ".temp");
            string retorno = string.Empty;
            string outputFile = filePath;
            Clock.Pdf.PdfCompressor p = new Clock.Pdf.PdfCompressor(filePath + ".temp", outputFile, false);
            p.PdfSettings.Author = "Jessé";
            p.PdfSettings.Language = "eng";
            p.PdfSettings.FontName = "";
            p.Start();
            p.Cleanup();
            if (File.Exists(outputFile))
            {
                File.Delete(filePath + ".temp");
                retorno = outputFile;
            }
            else
            {
                retorno = "ERRO";
            }
            return retorno;
        }
        public void ExcluirPDFTemp(string filePath)
        {
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }
        }
        public bool testePDF(string filePath)
        {
            string documentText = string.Empty;
            int linhas = 0;
            try
            {
                using (PdfDocumentProcessor documentProcessor = new PdfDocumentProcessor())
                {
                    documentProcessor.LoadDocument(filePath);
                    documentText = documentProcessor.Text;
                    linhas = documentText.Split('\n').Length;

                }
            }
            catch { }
            return linhas > 30;
        }
        #endregion

        protected void Button1_Click(object sender, EventArgs e)
        {
            //getSemLayout();
            getNaoLidos();
            getLidos();
        }

        protected void gridInventario_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }

        protected void gridLidos_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }

        protected void gridNaoLidos_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }

        protected void btnSel_Click(object sender, EventArgs e)
        {

        }

        protected void fileInsert_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            string dir = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"];
            string dirLayout = DataBase.Consultas.Consulta(str_conn, "SELECT LAYDIRPA FROM LAYPDFPA where LAYIDPAI=" + Session["idLayout"].ToString(), 1)[0];
            dir = dir + dirLayout + "/";
            string resultExtension = System.IO.Path.GetExtension(e.UploadedFile.FileName);
            //string resultFileName = System.IO.Path.ChangeExtension(System.IO.Path.GetRandomFileName(), resultExtension);
            string resultFileUrl = dir + e.UploadedFile.FileName;
            string resultFilePath = MapPath(resultFileUrl);
            if (File.Exists(resultFilePath))
                File.Delete(resultFilePath);
            e.UploadedFile.SaveAs(resultFilePath);
            string name = e.UploadedFile.FileName;
            string url = ResolveClientUrl(resultFileUrl);
        }

        protected void dropLayout_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["idLayout"] = dropLayout.SelectedItem.Value.ToString();
            fileInsert.Enabled = dropLayout.SelectedIndex >= 0;
        }
    }
}