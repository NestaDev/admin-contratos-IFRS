using DevExpress.DashboardWeb;
using DevExpress.DataAccess.Sql;
using DevExpress.Export;
using DevExpress.Utils;
using DevExpress.Web;
using DevExpress.Web.ASPxPivotGrid;
using DevExpress.Web.ASPxTreeList;
using DevExpress.XtraPivotGrid;
using DevExpress.XtraPrinting;
using DevExpress.XtraPrinting.Native;
using DevExpress.XtraPrintingLinks;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace WebNesta_IRFS_16
{
    public partial class Relatorios1 : BasePage.BasePage
    {
        public static string str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string chaveCript = System.Configuration.ConfigurationManager.AppSettings["chaveCript"];
        public static string vetorCript = System.Configuration.ConfigurationManager.AppSettings["vetorCript"];
        public static string lang;
        public static string user;
        public static string usuarioPersist;
        public static string currentPage;
        public static int queryString;
        public static int cont;
        float maxWidth = 0;
        private System.Drawing.Image headerImage;
        protected void Page_Init(object sender, EventArgs e)
        {

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString.Count > 0)
                {
                    if (Request.QueryString["token"] == string.Empty)
                    {
                        queryString = 0;
                        MultiView1.ActiveViewIndex = 0;
                        Panel1.Enabled = false;
                    }
                    else
                    {
                        queryString = 1;
                        MultiView1.ActiveViewIndex = 2;
                        pnlPivot.Visible = false;
                    }
                }
                else
                {
                    queryString = 0;
                    MultiView1.ActiveViewIndex = 0;
                    Panel1.Enabled = false;
                }
            }
            Page.Title = hfTituloPag.Value;
            if (!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                    usuarioPersist = DataBase.Funcoes.Decriptar(chaveCript, vetorCript, myCookie.Value);
                user = usuarioPersist;
                hfUser.Value = user;
                hfUser2.Value = user;
                str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
                if (Cache["MyCacheDependency"] == null)
                {
                    Cache["MyCacheDependency"] = DateTime.Now;
                }
            }
            if (queryString == 0)
            {
                string sql = "SELECT T.TPNMVIEW + ' - ' + Q.QUENMPVT NOME, Q.QUEIDPVT ID FROM QUERYPVT Q, TPTPVIEW T WHERE Q.QUETPPVT=T.TPIDVIEW AND Q.USIDUSUA='" + user + "'";
                using (var con = new OleDbConnection(str_conn))
                {
                    con.Open();
                    using (var cmd = new OleDbCommand(sql, con))
                    {
                        dropQueries.TextField = "NOME";
                        dropQueries.ValueField = "ID";
                        dropQueries.DataSource = cmd.ExecuteReader();
                        dropQueries.DataBind();
                    }
                }
            }
            else if (queryString == 1)
            {
                if (Request.QueryString["token"] != "")
                {
                    string id = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], Request.QueryString["token"]);
                    lblNomeQuery.Text = DataBase.Consultas.Consulta(str_conn, "SELECT T.TPNMVIEW + ' - ' + Q.QUENMPVT NOME FROM QUERYPVT Q, TPTPVIEW T WHERE Q.QUETPPVT=T.TPIDVIEW AND Q.QUEIDPVT=" + id + "", 1)[0];
                    lblNomeQuery2.Text = lblNomeQuery.Text;
                    //string query = DataBase.Consultas.Consulta(str_conn, "SELECT QUEBBPVT FROM QUERYPVT WHERE QUEIDPVT=" + id, 1)[0];
                    hfIDRelatorio.Value = id;
                    //string sql = "SELECT CAIDLAYO,CADSLAYO,CABBLAYO FROM CALAYOUT WHERE USIDUSUA='" + hfUser.Value + "' AND CARLLAYO=" + hfIDRelatorio.Value + "";
                    //sqlLayouts.SelectCommand = sql;
                    (ASPxDropDownEdit1.FindControl("gridLayouts") as ASPxGridView).DataBind();
                }
            }
            try
            {
                lang = Session["langSession"].ToString();

            }
            catch
            {
                lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
            }
            ASPxPivotGrid1.OptionsPager.Visible = false;
            ASPxPivotGrid1.OptionsView.ShowColumnHeaders = false;
            ASPxPivotGrid1.OptionsView.ShowRowHeaders = false;
            ASPxPivotGrid1.OptionsView.ShowDataHeaders = false;
            ASPxPivotGrid1.OptionsView.ShowFilterHeaders = true;
            ASPxPivotGrid1.OptionsView.HorizontalScrollBarMode = DevExpress.Web.ScrollBarMode.Auto;
            ASPxPivotGrid1.OptionsView.VerticalScrollBarMode = DevExpress.Web.ScrollBarMode.Auto;
            ASPxPivotGrid1.OptionsView.RowTotalsLocation = PivotRowTotalsLocation.Tree;
            ASPxPivotGrid1.Styles.FieldValueStyle.Wrap = DefaultBoolean.False;
        }
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
        protected void ASPxPivotGrid1_FieldValueDisplayText(object sender, DevExpress.Web.ASPxPivotGrid.PivotFieldDisplayTextEventArgs e)
        {
            if (e.Field != null && e.Field.Area == DevExpress.XtraPivotGrid.PivotArea.DataArea)
            {
                e.DisplayText += " sample text";
            }
        }
        protected void Button2_Click(object sender, EventArgs e)
        {
            var filename = "Report_" + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Year.ToString() + "_" + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString();
            XlsxExportOptionsEx options;

            switch (lstExporting.SelectedItem.Value)
            {
                //case 0: //Pdf
                //    ASPxPivotGridExporter1.ExportPdfToResponse(filename);
                //    break;
                case 1: //Excel
                    options = new XlsxExportOptionsEx() { ExportType = ExportType.WYSIWYG };
                    ASPxPivotGridExporter1.ExportXlsxToResponse(filename, options);
                    break;
                case 2: //Excel (Data Aware)
                    options = new XlsxExportOptionsEx()
                    {
                        ExportType = ExportType.DataAware,
                        AllowGrouping = DefaultBoolean.True,
                        TextExportMode = TextExportMode.Value,
                        AllowFixedColumns = DefaultBoolean.True,
                        AllowFixedColumnHeaderPanel = DefaultBoolean.True,
                        RawDataMode = false
                    };
                    ASPxPivotGridExporter1.ExportXlsxToResponse(filename, options);
                    break;
                case 3:
                    PdfExportOptions pdfEx = new PdfExportOptions();
                    pdfEx.ConvertImagesToJpeg = false;
                    pdfEx.ImageQuality = PdfJpegImageQuality.Medium;
                    pdfEx.PdfACompatibility = PdfACompatibility.PdfA3b;
                    ASPxPivotGridExporter1.OptionsPrint.PageSettings.Landscape = true;
                    ASPxPivotGridExporter1.OptionsPrint.PageSettings.Margins = new System.Drawing.Printing.Margins() { Bottom = 1, Top = 1, Left = 1, Right = 1 };
                    ASPxPivotGridExporter1.OptionsPrint.PageSettings.PaperKind = System.Drawing.Printing.PaperKind.A3;
                    ASPxPivotGridExporter1.ExportPdfToResponse(filename);
                    break;
            }
        }
        protected void treeEstrutura_SelectionChanged(object sender, EventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            if (treeList.SelectionCount == 1)  // One node is selected within the control  
                Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;

            if (treeList.SelectionCount > 1)
            { // Applies selection to the last selected node, if two nodes are selected  
                TreeListNode prevSelectedNode = treeList.FindNodeByKeyValue(Session["PrevSelectedNodeKey"].ToString());
                prevSelectedNode.Selected = false;
                Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;
            }
            Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;
            hfTVIDESTR.Value = treeList.GetSelectedNodes()[0].Key;
        }
        protected void TreeList_CustomJSProperties(object sender, TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void TreeList_SelectionChanged(object sender, EventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            if (treeList.SelectionCount == 1)  // One node is selected within the control  
                Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;

            if (treeList.SelectionCount > 1)
            { // Applies selection to the last selected node, if two nodes are selected  
                TreeListNode prevSelectedNode = treeList.FindNodeByKeyValue(Session["PrevSelectedNodeKey"].ToString());
                prevSelectedNode.Selected = false;
                Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;
            }
            Session["PrevSelectedNodeKey"] = treeList.GetSelectedNodes()[0].Key;
            hfTVIDESTR.Value = treeList.GetSelectedNodes()[0].Key;
        }
        protected void gridLayouts_ToolbarItemClick(object source, DevExpress.Web.Data.ASPxGridViewToolbarItemClickEventArgs e)
        {
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ASPxDropDownEdit1.FindControl("gridLayouts");
            switch (e.Item.Name)
            {
                case "select":
                    var ID = grid.GetSelectedFieldValues("CAIDLAYO")[0];
                    var resultado = DataBase.Consultas.Consulta(str_conn, "select CABBLAYO,CADSLAYO from CALAYOUT where CAIDLAYO=" + ID + "", 2);
                    string layout = resultado[0];
                    string layoutNome = resultado[1];
                    ASPxPivotGrid1.LoadLayoutFromString(layout);
                    ASPxDropDownEdit1.Text = layoutNome;
                    break;
                case "update":
                    var CAIDLAYO = grid.GetSelectedFieldValues("CAIDLAYO")[0];
                    string CABBLAYO = ASPxPivotGrid1.SaveLayoutToString();
                    var result = DataBase.Consultas.UpdtFrom(str_conn, "update CALAYOUT set CABBLAYO='" + CABBLAYO + "' where CAIDLAYO=" + CAIDLAYO + "");
                    break;
            }
        }
        protected void gridLayouts_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            DevExpress.Web.ASPxGridView grid = (sender) as DevExpress.Web.ASPxGridView;
            foreach (var itens in e.InsertValues)
            {
                string USIDUSUA = hfUser2.Value;
                string CADSLAYO = itens.NewValues["CADSLAYO"].ToString();
                string CABBLAYO = ASPxPivotGrid1.SaveLayoutToString();
                int CARLLAYO = hfIDRelatorio.Value == string.Empty ? 0 : Convert.ToInt32(hfIDRelatorio.Value);
                string sql = "INSERT INTO CALAYOUT(USIDUSUA, CADSLAYO, CARLLAYO, CABBLAYO) VALUES('" + USIDUSUA + "', '" + CADSLAYO + "', " + CARLLAYO + ", '" + CABBLAYO + "')";
                var result = DataBase.Consultas.InsertInto(str_conn, sql);
            }
            grid.DataBind();
        }
        protected void ASPxPivotGrid1_DataBound(object sender, EventArgs e)
        {
            Cache["MyCacheDependency"] = DateTime.Now;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            else
                usuarioPersist = DataBase.Funcoes.Decriptar(chaveCript, vetorCript, myCookie.Value);
            ASPxPivotGrid1.RetrieveFields();
            for (int i = 0; i < ASPxPivotGrid1.Fields.Count; i++)
            {
                ASPxPivotGrid1.Fields[i].Area = DevExpress.XtraPivotGrid.PivotArea.DataArea;
                ASPxPivotGrid1.Fields[i].Visible = false;
                ASPxPivotGrid1.Fields[i].CellFormat.FormatType = FormatType.Custom;
                ASPxPivotGrid1.Fields[i].CellFormat.FormatString = "N2";




            }
            string sql = "SELECT TOP 1 CABBLAYO,CADSLAYO FROM CALAYOUT WHERE USIDUSUA='" + usuarioPersist + "' AND CARLLAYO=" + hfIDRelatorio.Value + " order by CAIDLAYO desc";
            var result = DataBase.Consultas.Consulta(str_conn, sql, 2);
            string layout = result[0];
            string layoutNome = result[1];
            //MsgException(layout + hfUser.Value + hfIDRelatorio.Value + "-" + sql, 2);
            if (DataBase.Funcoes.IsBase64(layout))
            {
                ASPxPivotGrid1.LoadLayoutFromString(layout);
                ASPxDropDownEdit1.Text = layoutNome;
            }
        }
        protected void ASPxPivotGrid1_Init(object sender, EventArgs e)
        {
            if (Request.QueryString.Count > 0)
            {
                if (Request.QueryString["token"] != "")
                {
                    string id = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], Request.QueryString["token"]);
                    lblNomeQuery.Text = DataBase.Consultas.Consulta(str_conn, "SELECT T.TPNMVIEW + ' - ' + Q.QUENMPVT NOME FROM QUERYPVT Q, TPTPVIEW T WHERE Q.QUETPPVT=T.TPIDVIEW AND Q.QUEIDPVT=" + id + "", 1)[0];
                    string query = DataBase.Consultas.Consulta(str_conn, "SELECT QUEXMPVT FROM QUERYPVT WHERE QUEIDPVT=" + id, 1)[0];
                    hfIDRelatorio.Value = id;
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
                        for (int i = 0; i < select.Parameters.Count; i++)
                        {

                            var param = select.Parameters[i];
                            if (param.Type.Name == "DateTime")
                                query = "declare @" + param.Name + " " + param.Type.Name + " = " + "convert(datetime,'" + Convert.ToDateTime(param.Value).ToString("dd/MM/yyyy HH:mm:ss") + "',103) " + query;
                            else if (param.Type.Name == "String")
                                query = "declare @" + param.Name + " nvarchar(max) = " + "'" + param.Value.ToString() + "' " + query;
                            else if (param.Type.Name == "Decimal")
                                query = "declare @" + param.Name + " " + param.Type.Name + " = " + " " + param.Value.ToString() + " " + query;
                            else
                                query = "declare @" + param.Name + " " + param.Type.Name + " = " + param.Value.ToString() + query;
                            //dsPivotGrid.SelectParameters.Add("@"+param.Name, param.Value.ToString());
                        }
                    }
                    dsPivotGrid.SelectCommand = query;
                    ASPxPivotGrid1.DataSource = dsPivotGrid;
                    ASPxPivotGrid1.DataBind();
                }
                else
                {
                    ASPxPivotGrid1.DataSource = null;
                    ASPxPivotGrid1.DataBind();
                }
            }
            else
            {
                ASPxPivotGrid1.DataSource = null;
                ASPxPivotGrid1.DataBind();
            }
        }
        protected void ASPxPivotGrid1_Load(object sender, EventArgs e)
        {

        }
        protected void btn_click_Relatorios_Click(object sender, EventArgs e)
        {
            string id = dropQueries.SelectedItem.Value.ToString();
            Response.Redirect("Relatorios?token=" + DataBase.Funcoes.Encriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], id));
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            popupMail.ShowOnPageLoad = true;
        }
        void Header_CreateDetailHeaderArea(object sender, CreateAreaEventArgs e)
        {
            string[] result = new string[2];
            string id = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], Request.QueryString["token"]);
            try
            {
                result = DataBase.Consultas.Consulta(str_conn, "SELECT QUETITU1,QUETITU2 FROM QUERYPVT WHERE QUEIDPVT=" + id + "", 2);
            }
            catch { }

            e.Graph.BorderWidth = 1;
            e.Graph.BorderColor = Color.Black;
            e.Graph.StringFormat.Value.LineAlignment = StringAlignment.Center;
            int width1, width2=0, width3=0;
            string titulo1 = string.Format("Emitido por {0} em {1}", user,DateTime.Now.ToString("dd/MM/yyyy HH:mm"));
            using (System.Drawing.Graphics graphics = System.Drawing.Graphics.FromImage(new Bitmap(1, 1)))
            {
                System.Drawing.SizeF size = graphics.MeasureString(titulo1, new Font("Arial", 11, FontStyle.Regular, GraphicsUnit.Point));
                width1 = Convert.ToInt32(size.Width);
            }
            int[] anArray = { width1, width2, width3 };
            Rectangle r = new Rectangle(0, 0, anArray.Max(), 30);
            e.Graph.DrawString(titulo1, r);
            if (!string.IsNullOrEmpty(result[0]) && !string.IsNullOrEmpty(result[1]))
            {
                string titulo2 = result[0];
                using (System.Drawing.Graphics graphics = System.Drawing.Graphics.FromImage(new Bitmap(1, 1)))
                {
                    System.Drawing.SizeF size = graphics.MeasureString(titulo2, new Font("Arial", 11, FontStyle.Regular, GraphicsUnit.Point));
                    width2 = Convert.ToInt32(size.Width);
                }
                string titulo3 = result[1];
                using (System.Drawing.Graphics graphics = System.Drawing.Graphics.FromImage(new Bitmap(1, 1)))
                {
                    System.Drawing.SizeF size = graphics.MeasureString(titulo3, new Font("Arial", 11, FontStyle.Regular, GraphicsUnit.Point));
                    width3 = Convert.ToInt32(size.Width);
                }

                r = new Rectangle(0, 30, anArray.Max(), 30);
                e.Graph.DrawString(titulo2, r);
                r = new Rectangle(0, 60, anArray.Max(), 30);
                e.Graph.DrawString(titulo3, r);
            }
        }
        void Link1_CreateReportFooterArea(object sender, CreateAreaEventArgs e)
        {
            e.Graph.BorderWidth = 0;
            Rectangle r = new Rectangle(0, 20, 200, 50);
            e.Graph.Font = new Font("Times New Roman", 12, FontStyle.Italic);
            e.Graph.ForeColor = Color.Gray;
            e.Graph.DrawString("This is footer", r);
        }
        void WriteToResponse(string fileName, bool saveAsFile, string fileFormat, MemoryStream stream)
        {
            if (Page == null || Page.Response == null)
                return;
            string disposition = saveAsFile ? "attachment" : "inline";
            Page.Response.Clear();
            Page.Response.Buffer = false;
            Page.Response.AppendHeader("Content-Type", string.Format("application/{0}", fileFormat));
            Page.Response.AppendHeader("Content-Transfer-Encoding", "binary");
            Page.Response.AppendHeader("Content-Disposition",
                string.Format("{0}; filename={1}.{2}", disposition, fileName, fileFormat));
            Page.Response.BinaryWrite(stream.ToArray());
            Page.Response.End();
        }
        protected void gridTabela_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            ASPxGridView grid = (sender) as ASPxGridView;
            string filename = DataBase.Consultas.Consulta(str_conn, "SELECT QUENMPVT FROM QUERYPVT  WHERE QUEIDPVT=" + hfIDRelatorio.Value + "", 1)[0];
            filename = filename.Replace(" ", "_");
            filename = filename + "_" + DateTime.Now.ToString("ddMMyyyy-HHmmssfff");
            if (e.Item.Name == "CSV")
            {
                //gridTabelaExporter.WriteCsvToResponse(
                //    lblNomeQuery2.Text.Replace(" ", "_") + "_" + DateTime.Now.ToString("ddMMyyyyHHmmss")
                //    , new DevExpress.XtraPrinting.CsvExportOptionsEx() { ExportType = ExportType.DataAware });
                PrintingSystemBase ps = new PrintingSystemBase();

                LinkBase header = new LinkBase();
                header.CreateDetailHeaderArea += Header_CreateDetailHeaderArea;
                gridTabelaExporter.Styles.Cell.Font.Name = "Arial";
                gridTabelaExporter.Styles.Header.BorderSides = BorderSide.All;
                gridTabelaExporter.Styles.Header.Font.Name = "Arial";
                gridTabelaExporter.Styles.Header.ForeColor = Color.Black;
                gridTabelaExporter.Styles.Header.BackColor = Color.Transparent;
                gridTabelaExporter.Styles.Header.Font.Bold = true;
                PrintableComponentLinkBase link1 = new PrintableComponentLinkBase();
                link1.Component = this.gridTabelaExporter;
                //link1.CreateReportFooterArea += Link1_CreateReportFooterArea;
                CompositeLinkBase compositeLink = new CompositeLinkBase(ps);
                compositeLink.Links.AddRange(new object[] { header, link1 });

                compositeLink.CreateDocument();
                using (MemoryStream stream = new MemoryStream())
                {

                    compositeLink.ExportToCsv(stream);
                    WriteToResponse(filename, true, "csv", stream);

                }
                ps.Dispose();

            }
            if (e.Item.Name == "XLSX")
            {
                //gridTabelaExporter.WriteXlsxToResponse(
                //    lblNomeQuery2.Text.Replace(" ", "_") + "_" + DateTime.Now.ToString("ddMMyyyyHHmmss")
                //    , new DevExpress.XtraPrinting.XlsxExportOptionsEx() { ExportType = ExportType.DataAware });

                PrintingSystemBase ps = new PrintingSystemBase();

                LinkBase header = new LinkBase();
                header.CreateDetailHeaderArea += Header_CreateDetailHeaderArea;
                gridTabelaExporter.Styles.Cell.Font.Name = "Arial";
                gridTabelaExporter.Styles.Header.BorderSides = BorderSide.All;
                gridTabelaExporter.Styles.Header.Font.Name = "Arial";
                gridTabelaExporter.Styles.Header.ForeColor = Color.Black;
                gridTabelaExporter.Styles.Header.BackColor = Color.Transparent;
                gridTabelaExporter.Styles.Header.Font.Bold = true;
                PrintableComponentLinkBase link1 = new PrintableComponentLinkBase();
                link1.Component = this.gridTabelaExporter;
                //link1.CreateReportFooterArea += Link1_CreateReportFooterArea;
                CompositeLinkBase compositeLink = new CompositeLinkBase(ps);
                compositeLink.Links.AddRange(new object[] { header, link1 });

                compositeLink.CreateDocument();
                using (MemoryStream stream = new MemoryStream())
                {

                compositeLink.ExportToXlsx(stream);
                            WriteToResponse(filename, true, "xlsx", stream);

                }
                ps.Dispose();                

            }
            if (e.Item.Name == "PDF")
            {
                //gridTabelaExporter.Landscape = true;
                //gridTabelaExporter.BottomMargin = 1;
                //gridTabelaExporter.TopMargin = 1;
                //gridTabelaExporter.LeftMargin = 1;
                //gridTabelaExporter.RightMargin = 1;
                //gridTabelaExporter.PaperKind = System.Drawing.Printing.PaperKind.A3;
                //gridTabelaExporter.WritePdfToResponse(lblNomeQuery2.Text.Replace(" ", "_") + "_" + DateTime.Now.ToString("ddMMyyyyHHmmss"));

                PrintingSystemBase ps = new PrintingSystemBase();

                LinkBase header = new LinkBase();
                header.CreateDetailHeaderArea += Header_CreateDetailHeaderArea;
                gridTabelaExporter.Styles.Cell.Font.Name = "Arial";
                gridTabelaExporter.Styles.Header.BorderSides = BorderSide.All;
                gridTabelaExporter.Styles.Header.Font.Name = "Arial";
                gridTabelaExporter.Styles.Header.ForeColor = Color.Black;
                gridTabelaExporter.Styles.Header.BackColor = Color.Transparent;
                gridTabelaExporter.Styles.Header.Font.Bold = true;
                PrintableComponentLinkBase link1 = new PrintableComponentLinkBase();
                link1.Component = this.gridTabelaExporter;
                //link1.CreateReportFooterArea += Link1_CreateReportFooterArea;
                CompositeLinkBase compositeLink = new CompositeLinkBase(ps);
                compositeLink.Links.AddRange(new object[] { header, link1 });

                compositeLink.CreateDocument();
                using (MemoryStream stream = new MemoryStream())
                {
                    compositeLink.Margins.Top = 10;
                    compositeLink.Margins.Bottom = 10;
                    compositeLink.Margins.Left = 10;
                    compositeLink.Margins.Right = 10;
                    compositeLink.Landscape = true;
                    compositeLink.CreateDocument(false);
                    compositeLink.PrintingSystemBase.Document.AutoFitToPagesWidth = 1;
                    compositeLink.ExportToPdf(stream);
                    WriteToResponse(filename, true, "pdf", stream);

                }
                ps.Dispose();
            }
        }
        protected void gridTabela_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                var exportMenuItem = e.Items.FindByCommand(GridViewContextMenuCommand.ExportMenu);
                //exportMenuItem.Items.Add("Custom export to XLS(WYSIWYG)", "CustomExportToXLS").Image.IconID = "export_exporttoxls_16x16";
                exportMenuItem.Items.Clear();
                exportMenuItem.Items.Add("CSV", "CSV").Image.Url = "icons/icons8-csv-30.png";
                exportMenuItem.Items.Add("XLSX", "XLSX").Image.Url = "icons/icons8-microsoft-excel-30.png";
                exportMenuItem.Items.Add("PDF", "PDF").Image.Url = "icons/icons8-pdf-30.png";
            }
        }
        protected void listView_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (listView.SelectedItem.Value.ToString())
            {
                case "1":
                    MultiView1.SetActiveView(this.vwPivot);
                    pnlPivot.Visible = true;
                    break;
                case "2":
                    MultiView1.SetActiveView(this.vwTabela);
                    pnlPivot.Visible = false;
                    break;
            }
        }
        protected void gridTabela_DataBound(object sender, EventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            int width = 0;
            int widthTotal = 0;
            foreach (GridViewDataColumn c in grid.Columns)
            {
                c.SettingsHeaderFilter.Mode = GridHeaderFilterMode.CheckedList;
                if (c.FieldName.ToString() == "TVIDESTR")
                {
                    c.Visible = false;
                }
                if ((c.FieldName.ToString().ToUpper()).StartsWith("VALOR"))
                {
                    c.PropertiesEdit.DisplayFormatString = "N2";
                }
                object value = grid.GetRowValues(0, c.FieldName);
                if (value is decimal)
                {
                    c.PropertiesEdit.DisplayFormatString = "N2";
                }
                else if (value is float)
                {
                    c.PropertiesEdit.DisplayFormatString = "N2";
                }
                else if (value is double)
                {
                    c.PropertiesEdit.DisplayFormatString = "N2";
                }
                using (System.Drawing.Graphics graphics = System.Drawing.Graphics.FromImage(new Bitmap(1, 1)))
                {
                    System.Drawing.SizeF size = graphics.MeasureString(c.FieldName, new Font("Arial", 11, FontStyle.Regular, GraphicsUnit.Point));
                    width = Convert.ToInt32(size.Width);
                    //width = width + Convert.ToInt32(width * 0.30);
                    c.Width = Unit.Pixel(width + 35);
                }
                if(c.Visible)
                    widthTotal += c.ExportWidth;
            }
            Session["columnWidth"] = widthTotal;
        }
        protected void dsPivotGrid_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.CommandTimeout = 5000;
        }
        protected void gridTabelaExporter_RenderBrick(object sender, ASPxGridViewExportRenderingEventArgs e)
        {
            if (e.RowType == GridViewRowType.Header)
            {
                e.BrickStyle.TextAlignment = DevExpress.XtraPrinting.TextAlignment.BottomCenter;
            }
        }
    }
}