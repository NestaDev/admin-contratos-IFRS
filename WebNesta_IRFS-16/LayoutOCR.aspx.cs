using DevExpress.Pdf;
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
    public partial class LayoutOCR : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string perfil;
        public static string userPersist;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["PDFURL"] != null && Session["PDF"] != null)
            {
                if (Request.QueryString.Count > 0)
                {
                    string value = Request.QueryString[0];
                    if (value == "yes")
                    {
                        hfPDF.Value = Session["PDF"].ToString();
                        hfPDF2.Value = Session["PDF"].ToString();
                        hfPDFURL.Value = Session["PDFURL"].ToString();
                        hfPDFURL2.Value = Session["PDFURL"].ToString();
                        txtPdf.Text = hfPDF.Value;
                        txtNomeLayout.Enabled = true;
                        dropFormPagt.Enabled = true;
                        btnSalvarLayout.Enabled = perfil != "3";
                        dropLayouts.Enabled = true;
                        btnVoltar.Visible = true;
                    }
                }
            }
            if (hfPDFURL.Value != string.Empty)
            {
                ShowPdf1.FilePath = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority + "/" + System.Configuration.ConfigurationManager.AppSettings["NomeApp"] + hfPDFURL.Value;
            }
            if (!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);

                if (checkVerba.Checked)
                    mvVerba.SetActiveView(this.vw_Verba);
                else
                    mvVerba.SetActiveView(this.vw_Class);
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                userPersist = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
            }
            DataBase.Consultas.Usuario = userPersist;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (ShowPdf1.FilePath == "")
            {
                ShowPdf1.Visible = false;
                btnViewPDF.Visible = false;
            }
            else
            {
                btnViewPDF.Visible = true;
                ShowPdf1.Visible = true;
            }
        }
        protected void fileInsert_FileUploadComplete(object sender, DevExpress.Web.FileUploadCompleteEventArgs e)
        {
            string dir = System.Configuration.ConfigurationManager.AppSettings["PathContratos"];
            //dir = Server.MapPath(dir);
            string resultExtension = System.IO.Path.GetExtension(e.UploadedFile.FileName);
            string resultFileName = System.IO.Path.ChangeExtension(System.IO.Path.GetRandomFileName(), resultExtension);
            string resultFileUrl = dir + resultFileName;
            string resultFilePath = MapPath(resultFileUrl);
            e.UploadedFile.SaveAs(resultFilePath);
            string name = e.UploadedFile.FileName;
            string url = ResolveClientUrl(resultFileUrl);
            Session["PDF"] = name;
            Session["PDFURL"] = url;
        }
        protected void btnSel_Click(object sender, EventArgs e)
        {
            if (Session["PDF"] != null && Session["PDFURL"] != null)
            {
                hfPDF.Value = Session["PDF"].ToString();
                hfPDF2.Value = Session["PDF"].ToString();
                hfPDFURL.Value = Session["PDFURL"].ToString();
                hfPDFURL2.Value = Session["PDFURL"].ToString();
                txtPdf.Text = hfPDF.Value;
                ShowPdf1.FilePath = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Authority + "/" + System.Configuration.ConfigurationManager.AppSettings["NomeApp"] + hfPDFURL.Value;
                txtNomeLayout.Enabled = true;
                dropFormPagt.Enabled = true;
                btnSalvarLayout.Enabled = perfil != "3";
                dropLayouts.Enabled = true;
            }
        }
        protected void dropPosition_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (txtPesquisa.Text != "" && Convert.ToInt32(dropPosition.Value) > 0)
            {
                if (hfPDF2.Value != null && hfPDFURL2.Value != null)
                {
                    string file = Server.MapPath(hfPDFURL2.Value);
                    string result;
                    if (testePDF(file))
                    {
                        result = FindWord(file, txtPesquisa.Text, Convert.ToInt32(dropPosition.Value), Convert.ToInt32(txtOcorrencia.Text));
                        if (result.IndexOf('#') > 0)
                        {
                            var resultado = result.Split('#');
                            txtResultado.Text = resultado[0];
                            txtLeft.Value = Convert.ToDecimal(resultado[1]);
                            txtBottom.Value = Convert.ToDecimal(resultado[2]);
                            txtRight.Value = Convert.ToDecimal(resultado[3]);
                            txtTop.Value = Convert.ToDecimal(resultado[4]);
                            txtLeft.Enabled = true;
                            txtBottom.Enabled = true;
                            txtRight.Enabled = true;
                            txtTop.Enabled = true;
                            btnAjustar.Enabled = true;
                            btnGravar.Enabled = perfil != "3";
                            dropClassificador.Enabled = true;
                            dropTipo.Enabled = true;
                            hfOpercao.Value = "Novo";
                            btnDelete.Enabled = false;
                        }
                    }
                    else
                    {
                        string novoPdf = CriarPDF(file);
                        result = FindWord(novoPdf, txtPesquisa.Text, Convert.ToInt32(dropPosition.Value), Convert.ToInt32(txtOcorrencia.Text));
                        if (result != "" && result.IndexOf('#') >= 0)
                        {
                            hfPDFURL2.Value = System.Configuration.ConfigurationManager.AppSettings["PathContratos"] + Path.GetFileName(novoPdf);
                            var resultado = result.Split('#');
                            txtResultado.Text = resultado[0];
                            txtLeft.Value = Convert.ToDecimal(resultado[1]);
                            txtBottom.Value = Convert.ToDecimal(resultado[2]);
                            txtRight.Value = Convert.ToDecimal(resultado[3]);
                            txtTop.Value = Convert.ToDecimal(resultado[4]);
                            txtLeft.Enabled = true;
                            txtBottom.Enabled = true;
                            txtRight.Enabled = true;
                            txtTop.Enabled = true;
                            btnAjustar.Enabled = true;
                            btnGravar.Enabled = perfil != "3";
                            dropClassificador.Enabled = true;
                            dropTipo.Enabled = true;
                            hfOpercao.Value = "Novo";
                            btnDelete.Enabled = false;
                        }
                    }
                }
            }
        }
        #region Pesquisatexto
        public string FindCordinate(string filePath, double left, double bottom, double right, double top)
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
                        PdfDocumentArea cordinateArea = new PdfDocumentArea(i + 1, new DevExpress.Pdf.PdfRectangle(left, bottom, right, top));
                        texto = documentProcessor.GetText(cordinateArea);
                    }
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            return texto;
        }
        public string FindWord(string filePath, string word, int position, int ocorrencia = 1)
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
                        double maxbottom = documentProcessor.Document.Pages[i].CropBox.Bottom;
                        double maxtop = documentProcessor.Document.Pages[i].CropBox.Top;
                        double maxleft = documentProcessor.Document.Pages[i].CropBox.Left;
                        double maxright = documentProcessor.Document.Pages[i].CropBox.Right;
                        PdfTextSearchParameters searchParameters = new PdfTextSearchParameters();
                        searchParameters.CaseSensitive = false;
                        searchParameters.WholeWords = true;
                        PdfTextSearchResults result;// documentProcessor.FindText(word, searchParameters)
                        int cont = 1;
                        while ((result = documentProcessor.FindText(word, searchParameters)).Status == PdfTextSearchStatus.Found)
                        {
                            if (cont == ocorrencia)
                            {
                                double left, top, right, bottom;
                                DevExpress.Pdf.PdfRectangle cropBox = documentProcessor.Document.Pages[i].CropBox;
                                PdfOrientedRectangle firstRect = result.Rectangles.Last() as PdfOrientedRectangle;
                                PdfOrientedRectangle lastRect = result.Rectangles.Last() as PdfOrientedRectangle;
                                int offset = 10;
                                switch (position)
                                {
                                    case 2: //Direita
                                        left = lastRect.Left + lastRect.Width + 1;
                                        bottom = lastRect.Top - lastRect.Height;
                                        right = cropBox.Right;
                                        top = lastRect.Top;
                                        PdfDocumentArea rightArea = new PdfDocumentArea(i + 1, new DevExpress.Pdf.PdfRectangle(left, bottom, right, top));
                                        string rightText = documentProcessor.GetText(rightArea);
                                        texto = rightText + "#" + left.ToString("N4") + "#" + bottom.ToString("N4") + "#" + right.ToString("N4") + "#" + top.ToString("N4");
                                        break;
                                    case 3: //Esquerda
                                        left = cropBox.Left;
                                        bottom = firstRect.Top - firstRect.Height;
                                        right = firstRect.Left - 1;
                                        top = firstRect.Top;
                                        PdfDocumentArea leftArea = new PdfDocumentArea(i + 1, new DevExpress.Pdf.PdfRectangle(left, bottom, right, top));
                                        string leftText = documentProcessor.GetText(leftArea);
                                        texto = leftText + "#" + left.ToString("N4") + "#" + bottom.ToString("N4") + "#" + right.ToString("N4") + "#" + top.ToString("N4");
                                        break;
                                    case 1: //Acima                                    
                                        left = firstRect.Left;
                                        bottom = firstRect.Top + 1;
                                        right = lastRect.Left + lastRect.Width;
                                        top = firstRect.Top + offset;
                                        PdfDocumentArea topArea = new PdfDocumentArea(i + 1, new DevExpress.Pdf.PdfRectangle(left, bottom, right, top));
                                        string topText = documentProcessor.GetText(topArea);
                                        texto = topText + "#" + left.ToString("N4") + "#" + bottom.ToString("N4") + "#" + right.ToString("N4") + "#" + top.ToString("N4");
                                        break;
                                    case 4: //Abaixo
                                        left = firstRect.Left;
                                        bottom = lastRect.Top - lastRect.Height - 1 - offset;
                                        right = lastRect.Left + lastRect.Width;
                                        top = lastRect.Top - lastRect.Height - 1;
                                        PdfDocumentArea bottomArea = new PdfDocumentArea(i + 1, new DevExpress.Pdf.PdfRectangle(left, bottom, right, top));
                                        string bottomText = documentProcessor.GetText(bottomArea);
                                        texto = bottomText + "#" + left.ToString("N4") + "#" + bottom.ToString("N4") + "#" + right.ToString("N4") + "#" + top.ToString("N4");
                                        break;
                                }
                            }
                            cont++;
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            dropPosition.Value = 0;
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
        protected void btnAjustar_Click(object sender, EventArgs e)
        {
            if (hfPDF2.Value != null && hfPDFURL2.Value != null)
            {
                string file = Server.MapPath(hfPDFURL2.Value);
                double left, bottom, right, top;
                left = Convert.ToDouble(txtLeft.Value);
                bottom = Convert.ToDouble(txtBottom.Value);
                right = Convert.ToDouble(txtRight.Value);
                top = Convert.ToDouble(txtTop.Value);
                string result;
                if (testePDF(file))
                {
                    result = FindCordinate(file, left, bottom, right, top);
                    txtResultado.Text = result;
                }
                else
                {
                    string novoPdf = CriarPDF(file);
                    result = FindCordinate(novoPdf, left, bottom, right, top);
                    if (result != "")
                    {
                        hfPDFURL2.Value = System.Configuration.ConfigurationManager.AppSettings["PathContratos"] + Path.GetFileName(novoPdf);
                        txtResultado.Text = result;
                    }
                }
            }
        }
        protected void btnGravar_Click(object sender, EventArgs e)
        {

            if (!checkVerba.Checked && dropClassificador.Value == null)
            {
                lblClassificadorErro.Text = "Classificador precisa ser preenchido";
            }
            else if (checkVerba.Checked && dropVerba.Value == null)
            {
                lblClassificadorErro.Text = "Verba precisa ser preenchida";
            }
            else
            {
                lblClassificadorErro.Text = "";
                string sqlTeste;
                if (hfOpercao.Value == "Novo")
                {
                    if (!checkVerba.Checked)
                    {
                        sqlTeste = "select count(*) from LAYPDFFI FI, LAYPDFCL CL " +
                                    "WHERE CL.LAYIDENT = 1 " +
                                      "and CL.LAYIDCLA = FI.LAYIDCLA " +
                                      "AND FI.LAYIDPAI = " + hfLayoutID.Value + " " +
                                      "AND FI.LAYIDCLA = " + dropClassificador.Value.ToString() + "";
                        if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0]) > 0)
                        {
                            lblClassificadorErro.Text = "Classificador Identificador não pode ser repetido.";
                            return;
                        }
                    }
                    else
                    {
                        sqlTeste = "select count(*) from LAYPDFFI FI " +
                                    "WHERE FI.LAYIDPAI = " + hfLayoutID.Value + " " +
                                      "AND FI.MOIDMODA = " + dropVerba.Value.ToString() + "";
                        if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0]) > 0)
                        {
                            lblClassificadorErro.Text = "Verba não pode ser repetido.";
                            return;
                        }
                    }
                    string sqlInsert = "INSERT LAYPDFFI (LAYIDPAI,LAYLFFIL,LAYRGFIL,LAYTPFIL,LAYBTFIL,LAYIDCLA,LAYNMFIL,LAYCORFL,LAYQTFIL,LAYTIPOF,MOIDMODA) VALUES (@LAYIDPAI,@LAYLFFIL,@LAYRGFIL,@LAYTPFIL,@LAYBTFIL,@LAYIDCLA,'@LAYNMFIL',@LAYCORFL,@LAYQTFIL,'@LAYTIPOF',@MOIDMODA)";
                    sqlInsert = sqlInsert.Replace("@LAYIDPAI", hfLayoutID.Value);
                    sqlInsert = sqlInsert.Replace("@LAYLFFIL", txtLeft.Value.ToString().Replace(",", "."));
                    sqlInsert = sqlInsert.Replace("@LAYRGFIL", txtRight.Value.ToString().Replace(",", "."));
                    sqlInsert = sqlInsert.Replace("@LAYTPFIL", txtTop.Value.ToString().Replace(",", "."));
                    sqlInsert = sqlInsert.Replace("@LAYBTFIL", txtBottom.Value.ToString().Replace(",", "."));
                    sqlInsert = sqlInsert.Replace("@LAYIDCLA", checkVerba.Checked ? "NULL" : dropClassificador.Value.ToString());
                    sqlInsert = sqlInsert.Replace("@LAYNMFIL", txtPesquisa.Text);
                    sqlInsert = sqlInsert.Replace("@LAYCORFL", dropApenasCord.Value.ToString());
                    sqlInsert = sqlInsert.Replace("@LAYQTFIL", txtOcorrencia.Text);
                    sqlInsert = sqlInsert.Replace("@LAYTIPOF", checkVerba.Checked ? "NULL" : dropTipo.Value.ToString());
                    sqlInsert = sqlInsert.Replace("@MOIDMODA", checkVerba.Checked ? dropVerba.Value.ToString() : "NULL");
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        gridCordenadas.DataBind();
                    }
                    else
                    {
                        lblClassificadorErro.Text = exec;
                    }
                }
                else if (hfOpercao.Value == "Editar")
                {
                    if (!checkVerba.Checked)
                    {
                        if (hfClass.Value != dropClassificador.Value.ToString())
                        {

                            sqlTeste = "select count(*) from LAYPDFFI FI, LAYPDFCL CL " +
                                    "WHERE CL.LAYIDENT = 1 " +
                                      "and CL.LAYIDCLA = FI.LAYIDCLA " +
                                      "AND FI.LAYIDPAI = " + hfLayoutID.Value + " " +
                                      "AND FI.LAYIDCLA = " + dropClassificador.Value.ToString();
                            if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0]) > 0)
                            {
                                lblClassificadorErro.Text = "Classificador Identificador não pode ser repedito.";
                                return;
                            }
                        }
                    }
                    else
                    {
                        sqlTeste = "select count(*) from LAYPDFFI FI " +
                                    "WHERE FI.LAYIDPAI = " + hfLayoutID.Value + " " +
                                      "AND FI.MOIDMODA = " + dropVerba.Value.ToString() + "";
                        if (Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0]) > 0)
                        {
                            lblClassificadorErro.Text = "Verba não pode ser repetido.";
                            return;
                        }
                    }
                    string sqlUpdate = "UPDATE LAYPDFFI SET  LAYLFFIL=@LAYLFFIL,LAYRGFIL=@LAYRGFIL,LAYTPFIL=@LAYTPFIL,LAYBTFIL=@LAYBTFIL,LAYIDCLA=@LAYIDCLA,LAYNMFIL='@LAYNMFIL',LAYCORFL=@LAYCORFL,LAYQTFIL=@LAYQTFIL,LAYTIPOF='@LAYTIPOF',MOIDMODA=@MOIDMODA WHERE LAYIDFIL=@LAYIDFIL";
                    sqlUpdate = sqlUpdate.Replace("@LAYLFFIL", txtLeft.Value.ToString().Replace(",", "."));
                    sqlUpdate = sqlUpdate.Replace("@LAYRGFIL", txtRight.Value.ToString().Replace(",", "."));
                    sqlUpdate = sqlUpdate.Replace("@LAYTPFIL", txtTop.Value.ToString().Replace(",", "."));
                    sqlUpdate = sqlUpdate.Replace("@LAYBTFIL", txtBottom.Value.ToString().Replace(",", "."));
                    sqlUpdate = sqlUpdate.Replace("@LAYIDCLA", checkVerba.Checked ? "NULL" : dropClassificador.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@LAYIDFIL", hfLayoutIDFilho.Value);
                    sqlUpdate = sqlUpdate.Replace("@LAYNMFIL", txtPesquisa.Text);
                    sqlUpdate = sqlUpdate.Replace("@LAYCORFL", dropApenasCord.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@LAYQTFIL", txtOcorrencia.Text);
                    sqlUpdate = sqlUpdate.Replace("@LAYTIPOF", checkVerba.Checked ? "NULL" : dropTipo.Value.ToString());
                    sqlUpdate = sqlUpdate.Replace("@MOIDMODA", checkVerba.Checked ? dropVerba.Value.ToString() : "NULL");
                    string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if (exec == "OK")
                    {
                        gridCordenadas.DataBind();
                    }
                    else
                    {
                        lblClassificadorErro.Text = exec;
                    }
                }
            }
        }
        protected void btnSalvarLayout_Click(object sender, EventArgs e)
        {
            if (txtNomeLayout.Text == "")
            {
                lblErrorLayout.Text = "Nome Layout precisa ser preenchido";
            }
            else if (dropFormPagt.SelectedItem == null)
            {
                lblErrorLayout.Text = "Forma de Pagamento precisa ser preenchido";
            }
            else
            {
                bool duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "SELECT count(*) FROM LAYPDFPA WHERE LAYNMPAI='" + txtNomeLayout.Text + "'", 1)[0]) > 0 ? true : false;
                if (duplicado)
                {
                    lblErrorLayout.Text = "Nome já utilizado";
                }
                else
                {
                    lblErrorLayout.Text = "";
                    string sqlInsert = "INSERT LAYPDFPA (LAYNMPAI,LAYDIRPA,BOLTPBOL) VALUES ('@LAYNMPAI','@LAYDIRPA','@BOLTPBOL')";
                    string LAYNMPAI = txtNomeLayout.Text;
                    string BOLTPBOL = dropFormPagt.SelectedItem.Value.ToString();
                    sqlInsert = sqlInsert.Replace("@LAYNMPAI", LAYNMPAI);
                    sqlInsert = sqlInsert.Replace("@LAYDIRPA", LAYNMPAI.Replace(" ", string.Empty));
                    sqlInsert = sqlInsert.Replace("@BOLTPBOL", BOLTPBOL);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        hfLayoutID.Value = DataBase.Consultas.Consulta(str_conn, "SELECT LAYIDPAI FROM LAYPDFPA WHERE LAYNMPAI='" + txtNomeLayout.Text + "'", 1)[0];
                        txtPesquisa.Enabled = true;
                        txtOcorrencia.Enabled = true;
                        dropPosition.Enabled = true;
                        dropApenasCord.Enabled = true;
                        txtNomeLayout.Enabled = false;
                        dropFormPagt.Enabled = false;
                        btnSalvarLayout.Enabled = false;
                        txtLeft.Enabled = true;
                        txtBottom.Enabled = true;
                        txtRight.Enabled = true;
                        txtTop.Enabled = true;
                        string novoDir = System.Configuration.ConfigurationManager.AppSettings["LeituraPDF"] + LAYNMPAI.Replace(" ", string.Empty);
                        if (!Directory.Exists(novoDir))
                        {
                            DirectoryInfo di = Directory.CreateDirectory(novoDir);
                        }
                        if (Request.QueryString.Count == 2)
                        {
                            string opidcont = Request.QueryString["cod"];
                            string sqlInsertAssoc = "INSERT INTO LAYOPASS (LAYIDPAI ,OPIDCONT) VALUES (@LAYIDPAI ,@OPIDCONT)";
                            sqlInsertAssoc = sqlInsertAssoc.Replace("@LAYIDPAI", hfLayoutID.Value);
                            sqlInsertAssoc = sqlInsertAssoc.Replace("@OPIDCONT", opidcont);
                            string exec2 = DataBase.Consultas.InsertInto(str_conn, sqlInsertAssoc);
                            if (exec2 == "OK")
                            {

                            }
                        }
                    }
                    else
                    {
                        lblErrorLayout.Text = exec;
                    }
                }
            }
        }
        protected void btn_selGrid_Click(object sender, EventArgs e)
        {
            checkVerba.Checked = gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "MOIDMODA").ToString() != string.Empty;
            if (checkVerba.Checked)
                mvVerba.SetActiveView(this.vw_Verba);
            else
                mvVerba.SetActiveView(this.vw_Class);
            hfOpercao.Value = "Editar";
            txtPesquisa.Text = gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYNMFIL").ToString();
            dropPosition.Value = 0;
            txtTop.Value = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYTPFIL").ToString());
            txtTop.Position = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYTPFIL").ToString());
            txtLeft.Value = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYLFFIL").ToString());
            txtLeft.Position = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYLFFIL").ToString());
            txtRight.Value = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYRGFIL").ToString());
            txtRight.Position = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYRGFIL").ToString());
            txtBottom.Value = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYBTFIL").ToString());
            txtBottom.Position = Convert.ToDecimal(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYBTFIL").ToString());
            hfClass.Value = gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYIDCLA").ToString();
            dropApenasCord.Value = Convert.ToInt32(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYCORFL").ToString());
            if (checkVerba.Checked)
            {
                dropClassificador.Value = string.Empty;
                dropTipo.Value = "Int";
                dropVerba.Value = Convert.ToInt32(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "MOIDMODA").ToString());
            }
            else
            {
                dropClassificador.Value = Convert.ToInt32(gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYIDCLA").ToString());
                dropTipo.Value = gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYTIPOF").ToString();
                dropVerba.Value = string.Empty;
            }
            hfLayoutIDFilho.Value = gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYIDFIL").ToString();
            txtOcorrencia.Text = gridCordenadas.GetRowValues(gridCordenadas.FocusedRowIndex, "LAYQTFIL").ToString();
            btnDelete.Enabled = perfil != "3";
        }
        protected void dropLayouts_SelectedIndexChanged(object sender, EventArgs e)
        {
            hfLayoutID.Value = dropLayouts.SelectedItem.Value.ToString();
            txtNomeLayout.Text = dropLayouts.SelectedItem.Text;
            var item = dropFormPagt.Items.FindByValue("B");
            dropFormPagt.Value = DataBase.Consultas.Consulta(str_conn, "SELECT BOLTPBOL FROM LAYPDFPA where LAYIDPAI=" + hfLayoutID.Value, 1)[0].Trim();
            txtPesquisa.Enabled = true;
            txtOcorrencia.Enabled = true;
            dropPosition.Enabled = true;
            txtNomeLayout.Enabled = false;
            dropFormPagt.Enabled = false;
            btnSalvarLayout.Enabled = false;
            txtLeft.Enabled = true;
            txtBottom.Enabled = true;
            txtRight.Enabled = true;
            txtTop.Enabled = true;
            btnAjustar.Enabled = true;
            btnGravar.Enabled = perfil != "3";
            dropClassificador.Enabled = true;
            dropTipo.Enabled = true;
            dropApenasCord.Enabled = true;
            dropVerba.Enabled = true;
            //sqlCordenadas.SelectParameters.Clear();
            //sqlCordenadas.SelectParameters[0].DefaultValue = dropLayouts.SelectedItem.Value.ToString();
            sqlCordenadas.DataBind();
            gridCordenadas.DataBind();
        }
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string sqlDelete = "delete from LAYPDFFI where LAYIDFIL= " + hfLayoutIDFilho.Value + "";
            string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
            if (exec == "OK")
            {
                gridCordenadas.DataBind();
            }
            else
            {
                lblClassificadorErro.Text = exec;
            }
        }
        protected void btnVoltar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Monitor");
        }
        protected void gridCordenadas_DataBound(object sender, EventArgs e)
        {
            string sqlClass = "SELECT C.LAYNMCLA FROM LAYPDFCL C where C.LAYIDENT=1 " +
            "AND NOT EXISTS(SELECT NULL FROM LAYPDFFI L WHERE C.LAYIDCLA = L.LAYIDCLA AND L.LAYIDPAI = " + hfLayoutID.Value + ")";
            try
            {
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sqlClass);
                if (dt.Rows.Count > 0)
                {
                    lblIdentidade.Text = "Classificador de Identidade obrigatório: ";
                    foreach (DataRow row in dt.Rows)
                    {
                        lblIdentidade.Text += row[0].ToString() + ",";
                    }
                    lblIdentidade.Text = lblIdentidade.Text.Substring(0, lblIdentidade.Text.Length - 1);
                }
                else
                {
                    lblIdentidade.Text = "";
                }
            }
            catch (Exception ex)
            {
                RegistraLog log = new RegistraLog();
                log.SaveLog(ex);
            }
        }
        protected void ASPxCheckBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (checkVerba.Checked)
                mvVerba.SetActiveView(this.vw_Verba);
            else
                mvVerba.SetActiveView(this.vw_Class);
        }
        protected void btnSalvarLayout_Load(object sender, EventArgs e)
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