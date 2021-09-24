using System;
using System.Linq;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;
using System.Diagnostics;
using System.Drawing.Imaging;
using System.Drawing;
using System.Collections.Generic;
//using MuPDFLib;
using System.Text;
using iTextSharp.text.pdf.parser;
using iTextSharp.text.html.simpleparser;
using Clock.Hocr;
using Clock.ImageProcessing;
using Clock.Util;


namespace Clock.Pdf
{
    public delegate iTextSharp.text.Image ProcessImageForDisplay(System.Drawing.Image image);
    public delegate Bitmap ProcessImageForOcr(System.Drawing.Image image);
    public class PdfCreator : IDisposable
    {
        Document doc;
        PdfWriter writer;
        public PDFSettings PDFSettings { get; set; }
        hDocument hDoc;

        public event ProcessImageForDisplay OnProcessImageForDisplay;
        public event ProcessImageForOcr OnProcessImageForOcr;

        public string PDFFilePath { get; private set; }

        public PdfCreator(string newPdf)
        {
            PDFSettings = new PDFSettings();
            PDFFilePath = newPdf;
            SetupDocumentWriter(newPdf);
            hDoc = new hDocument();

        }

        public PdfCreator(string newPdf, string hocrFilePath)
        {
            PDFSettings = new PDFSettings();
            PDFFilePath = newPdf;
            SetupDocumentWriter(newPdf);
            hDoc = new hDocument();


            AddHocrFile(hocrFilePath);

        }

        public void AddHocrFile(string hocrFilePath)
        {
            hDocument doc = new hDocument();
            doc.AddFile(hocrFilePath);

            foreach (hPage p in doc.Pages)
            {
                Stream s = File.OpenRead(p.ImageFile);
                System.Drawing.Image image = System.Drawing.Image.FromStream(s);
                Guid objGuid = image.FrameDimensionsList[0];
                FrameDimension frameDim = new FrameDimension(objGuid);
                image.SelectActiveFrame(frameDim, p.ImageFrameNumber);
                System.Drawing.Image img = ImageProcessor.GetAsBitmap(image, PDFSettings.Dpi);
                AddPage(p, img);
            }
        }

        public PdfCreator(PDFSettings settings, string newPdf)
        {
            PDFSettings = settings;
            PDFFilePath = newPdf;
            SetupDocumentWriter(newPdf);
            hDoc = new hDocument();
        }

        private void SetupDocumentWriter(string fileName)
        {
            doc = new Document();

            doc.SetMargins(0, 0, 0, 0);

            // doc.SetPageSize(PDFSettings.PdfPageSize);

            writer = PdfWriter.GetInstance(doc, new FileStream(fileName, FileMode.Create));
            // writer.SetPageSize(PDFSettings.PdfPageSize);

            writer.SetMargins(0, 0, 0, 0);
            doc.Open();

            if (PDFSettings != null)
            {
                doc.AddAuthor(PDFSettings.Author);
                doc.AddTitle(PDFSettings.Title);
                doc.AddSubject(PDFSettings.Subject);
                doc.AddKeywords(PDFSettings.Keywords);
            }
        }

        PdfOutline outline = null;

        public void AddPage(hPage page, System.Drawing.Image pageImage)
        {
            // doc.NewPage();
            AddImage(pageImage);
            WriteUnderlayContent(page);
        }

        public void AddPdf(string PdfFile, string BookMarkDesc, string ID)
        {
            if (!File.Exists(PdfFile))
                return;

            iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(PdfFile);

            PdfContentByte cb = writer.DirectContent;
            PdfOutline root = cb.RootOutline;

            for (int i = 1; i <= reader.NumberOfPages; i++)
            {
                if (i > reader.NumberOfPages)
                    break;



                PdfImportedPage page = writer.GetImportedPage(reader, i);
                doc.SetPageSize(reader.GetPageSize(i));
                doc.NewPage();

                int rot = reader.GetPageRotation(i);

                if (rot == 90 || rot == 270)
                {
                    cb.AddTemplate(page, 0, -1.0F, 1.0F, 0, 0, reader.GetPageSizeWithRotation(i).Height);
                }
                else
                {
                    cb.AddTemplate(page, 1.0F, 0, 0, 1.0F, 0, 0);
                }

                if (i == 1)
                {
                    doc.Add(new Chunk(BookMarkDesc).SetLocalDestination(ID));
                    outline = new PdfOutline(root, PdfAction.GotoLocalPage(ID, false), BookMarkDesc);
                }
            }
            reader.Close();
        }

        public void AddPdf(string PdfFile)
        {
            if (!File.Exists(PdfFile))
                return;

            iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(PdfFile);

            PdfContentByte cb = writer.DirectContent;
            for (int i = 1; i <= reader.NumberOfPages; i++)
            {
                if (i > reader.NumberOfPages)
                    break;

                doc.NewPage();
                PdfImportedPage page = writer.GetImportedPage(reader, i);

                int rot = reader.GetPageRotation(i);

                if (rot == 90 || rot == 270)
                {
                    cb.AddTemplate(page, 0, -1.0F, 1.0F, 0, 0, reader.GetPageSizeWithRotation(i).Height);
                }
                else
                {
                    cb.AddTemplate(page, 1.0F, 0, 0, 1.0F, 0, 0);
                }
            }
            reader.Close();
        }

        public void AddPdf(byte[] PdfPage)
        {
            iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(PdfPage);

            PdfContentByte cb = writer.DirectContent;
            for (int i = 1; i <= reader.NumberOfPages; i++)
            {
                if (i > reader.NumberOfPages)
                    break;

                //set the current page size using the source page
                doc.SetPageSize(reader.GetPageSize(i));
                doc.NewPage();

                PdfImportedPage page = writer.GetImportedPage(reader, i);

                int rot = reader.GetPageRotation(i);

                if (rot == 90 || rot == 270)
                {
                    cb.AddTemplate(page, 0, -1.0F, 1.0F, 0, 0, reader.GetPageSizeWithRotation(i).Height);
                }
                else
                {
                    cb.AddTemplate(page, 1.0F, 0, 0, 1.0F, 0, 0);
                }
            }
            reader.Close();

        }

        public void AddPage(string ImagePath, PdfMode mode)
        {
            AddPage(System.Drawing.Image.FromFile(ImagePath), mode);

            //if (mode == PdfMode.Ocr) {
            //    string f = OcrController.CreateHOCR (PDFSettings.PdfOcrMode, PDFSettings.Language, ImagePath);
            //    AddHocrFile (f);
            //} else {
            //    AddPage (System.Drawing.Image.FromFile (ImagePath), mode);
            //}
        }

        public void AddPage(System.Drawing.Image image, PdfMode Mode)
        {
            Guid objGuid = image.FrameDimensionsList[0];
            FrameDimension frameDim = new FrameDimension(objGuid);
            int frameCount = image.GetFrameCount(frameDim);
            for (int i = 0; i < frameCount; i++)
            {
                // doc.NewPage();
                Bitmap img;

                image.SelectActiveFrame(frameDim, i);

                if (image is Bitmap == false)
                {
                    img = ImageProcessor.GetAsBitmap(image, PDFSettings.Dpi);

                }
                else
                    img = image as Bitmap;

                img.SetResolution(PDFSettings.Dpi, PDFSettings.Dpi);


                if (Mode == PdfMode.ImageOnly)
                {
                    AddImage(image);
                }
                if (Mode == PdfMode.Ocr)
                {
                    try
                    {
                        AddImage(image);

                        if (OnProcessImageForOcr != null)
                            img = OnProcessImageForOcr(img);
                        OcrController.AddToDocument(PDFSettings.PdfOcrMode, PDFSettings.Language.ToString(), image, ref hDoc);
                        hPage page = hDoc.Pages[hDoc.Pages.Count - 1];
                        WriteUnderlayContent(page);
                    }
                    catch (Exception x)
                    {
                        string message = x.Message;
                    }
                }
                if (Mode == PdfMode.TextOnly)
                {
                    try
                    {
                        doc.NewPage();
                        OcrController.AddToDocument(PDFSettings.PdfOcrMode, PDFSettings.Language.ToString(), image, ref hDoc);
                        hPage page = hDoc.Pages[hDoc.Pages.Count - 1];
                        WriteDirectContent(page);
                    }
                    catch (Exception)
                    {
                    }
                }


                if (Mode == PdfMode.DrawBlocks)
                {
                    try
                    {
                        OcrController.AddToDocument(PDFSettings.PdfOcrMode, PDFSettings.Language.ToString(), image, ref hDoc);
                        hPage page = hDoc.Pages[hDoc.Pages.Count - 1];
                        WritePageDrawBlocks(image, page);

                    }
                    catch (Exception)
                    {
                    }
                }

                if (Mode == PdfMode.Debug)
                {
                    try
                    {
                        OcrController.AddToDocument(PDFSettings.PdfOcrMode, PDFSettings.Language.ToString(), image, ref hDoc);
                        hPage page = hDoc.Pages[hDoc.Pages.Count - 1];
                        WritePageDrawBlocks(image, page);
                        WriteDirectContent(page);

                    }
                    catch (Exception)
                    {
                    }
                }

                img.Dispose();
            }
        }

        public void AddPage(System.Drawing.Image image)
        {

            Guid objGuid = image.FrameDimensionsList[0];
            FrameDimension frameDim = new FrameDimension(objGuid);
            int frameCount = 0;
            try
            {
                frameCount = image.GetFrameCount(frameDim);

            }
            catch (Exception x)
            {
                Bitmap img;
                if (image is Bitmap == false)
                {
                    img = ImageProcessor.GetAsBitmap(image, PDFSettings.Dpi); // AForge.Imaging.Image.Clone((Bitmap)image, PixelFormat.Format24bppRgb);
                }
                else
                    img = image as Bitmap;
                img.SetResolution(PDFSettings.Dpi, PDFSettings.Dpi);

                AddImage(img);

            }
            for (int i = 0; i < frameCount; i++)
            {
                //doc.NewPage();

                Bitmap img;

                image.SelectActiveFrame(frameDim, i);

                if (image is Bitmap == false)
                {
                    img = ImageProcessor.GetAsBitmap(image, PDFSettings.Dpi);
                }
                else
                    img = image as Bitmap;

                img.SetResolution(PDFSettings.Dpi, PDFSettings.Dpi);
                AddImage(image);
                img.Dispose();
            }
        }


        public void SaveAndClose()
        {
            try
            {
                if (doc.PageNumber == 0)
                    doc.NewPage();

                writer.CompressionLevel = 100;
                writer.SetFullCompression();

                doc.Close();

            }
            catch (Exception)
            {
            }


        }

        private void WritePageDrawBlocks(System.Drawing.Image img, hPage page)
        {
            System.Drawing.Image himage = img;

            Pen bpen = null;
            Pen gpen = null;
            Pen rpen = null;
            Graphics bg = null;
            Bitmap rect_canvas = null;

            rect_canvas = new Bitmap(himage.Width, himage.Height);
            Graphics grPhoto = Graphics.FromImage(rect_canvas);
            grPhoto.DrawImage(himage, new System.Drawing.Rectangle(0, 0, rect_canvas.Width, rect_canvas.Height), 0, 0, rect_canvas.Width, rect_canvas.Height, GraphicsUnit.Pixel);
            bg = Graphics.FromImage(rect_canvas);
            bpen = new Pen(System.Drawing.Color.Red, 3);
            rpen = new Pen(System.Drawing.Color.Blue, 3);
            gpen = new Pen(System.Drawing.Color.Green, 3);
            var ppen = new Pen(System.Drawing.Color.HotPink, 3);
            //dpiX = (int)rect_canvas.HorizontalResolution;
            //dpiY = (int)rect_canvas.VerticalResolution;


            foreach (hParagraph para in page.Paragraphs)
            {
                bg.DrawRectangle(gpen, new System.Drawing.Rectangle(new Point((int)para.BBox.Left, (int)para.BBox.Top), new Size((int)para.BBox.Width, (int)para.BBox.Height)));

                foreach (hLine line in para.Lines)
                {
                    foreach (hWord word in line.Words)
                    {
                        bg.DrawRectangle(rpen, new System.Drawing.Rectangle(new Point((int)word.BBox.Left, (int)word.BBox.Top), new Size((int)word.BBox.Width, (int)word.BBox.Height)));

                    }
                    bg.DrawRectangle(bpen, new System.Drawing.Rectangle(new Point((int)line.BBox.Left, (int)line.BBox.Top), new Size((int)line.BBox.Width, (int)line.BBox.Height)));
                }

            }
            var combinedLines = page.CombineSameRowLines();
            foreach (hLine l in combinedLines.Where(x => x.LineWasCombined == true))
            {
                bg.DrawRectangle(ppen, new System.Drawing.Rectangle(new Point((int)l.BBox.Left, (int)l.BBox.Top), new Size((int)l.BBox.Width, (int)l.BBox.Height)));

            }

            AddImage(rect_canvas);
        }

        private void WriteDirectContent(hPage page)
        {
            string pageText = page.Text;
            var allLines = new List<hLine>();

            foreach (hParagraph para in page.Paragraphs)
            {
                foreach (hLine line in para.Lines)
                {
                    allLines.Add(line);
                }
            }
            foreach (hParagraph para in page.Paragraphs)
            {
                foreach (hLine line in para.Lines)
                {
                    line.CleanText();
                    if (line.Text.Trim() == string.Empty)
                        continue;

                    BBox b = BBox.ConvertBBoxToPoints(line.BBox, PDFSettings.Dpi);

                    if (b.Height > 28)
                        continue;

                    PdfContentByte cb = writer.DirectContent;

                    BaseFont base_font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.WINANSI, false);
                    iTextSharp.text.Font font = new iTextSharp.text.Font(base_font);
                    if (PDFSettings.FontName != null && PDFSettings.FontName != string.Empty)
                    {
                        var fontPath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Fonts), PDFSettings.FontName);
                        base_font = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                        // BaseFont base_font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.WINANSI, false);
                        font = new iTextSharp.text.Font(base_font);
                    }

                    float h = 9;

                    float font_size = (float)(allLines.Select(x => x.BBox.Height).Average() / PDFSettings.Dpi) * 72.0f;// Math.Ceiling(b.Height);

                    if (font_size == 0)
                        font_size = 2;

                    cb.BeginText();
                    cb.SetFontAndSize(base_font, (int)Math.Floor(font_size) - 1);
                    cb.SetTextMatrix(b.Left, doc.PageSize.Height - b.Top - b.Height);
                    cb.ShowText(line.Text);
                    cb.EndText();
                }

            }

        }

        public void WriteUnderlayContent(IList<HOcrClass> Locations)
        {
            BaseFont base_font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.WINANSI, false);
            iTextSharp.text.Font font = new iTextSharp.text.Font(base_font);
            if (PDFSettings.FontName != null && PDFSettings.FontName != string.Empty)
            {
                var fontPath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Fonts), PDFSettings.FontName);
                base_font = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                // BaseFont base_font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.WINANSI, false);
                font = new iTextSharp.text.Font(base_font);
            }

            foreach (HOcrClass c in Locations)
            {
                BBox b = c.BBox;         
         
                PdfContentByte cb = writer.DirectContentUnder;

                cb.BeginText();
                cb.SetFontAndSize(base_font, c.BBox.Height > 0 ? c.BBox.Height : 2);
                if(b.Format == UnitFormat.Point)
                cb.SetTextMatrix(b.Left, b.Top - b.Height + 2);
                else
                    cb.SetTextMatrix(b.Left, doc.PageSize.Height - b.Top - b.Height + 2);
       
                cb.ShowText(c.Text.Trim());
                cb.EndText();
            }

        }

        private void WriteUnderlayContent(hPage page)
        {
            string pageText = page.Text;
            foreach (hParagraph para in page.Paragraphs)
            {
                foreach (hLine line in para.Lines)
                {
                    if (PDFSettings.WriteTextMode == WriteTextMode.Word)
                    {
                        line.AlignTops();

                        foreach (hWord c in line.Words)
                        {
                            c.CleanText();
                            BBox b = BBox.ConvertBBoxToPoints(c.BBox, PDFSettings.Dpi);

                            if (b.Height > 28)
                                continue;
                            PdfContentByte cb = writer.DirectContentUnder;

                            BaseFont base_font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.WINANSI, false);
                            iTextSharp.text.Font font = new iTextSharp.text.Font(base_font);
                            if (PDFSettings.FontName != null && PDFSettings.FontName != string.Empty)
                            {
                                var fontPath = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Fonts), PDFSettings.FontName);
                                base_font = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                                // BaseFont base_font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.WINANSI, false);
                                font = new iTextSharp.text.Font(base_font);
                            }

                            cb.BeginText();
                            cb.SetFontAndSize(base_font, b.Height > 0 ? b.Height : 2);
                            cb.SetTextMatrix(b.Left, doc.PageSize.Height - b.Top - b.Height + 2);
                            cb.SetWordSpacing(PdfWriter.SPACE);
                            cb.ShowText(c.Text.Trim() + " ");
                            cb.EndText();
                        }
                    }

                    if (PDFSettings.WriteTextMode == WriteTextMode.Line)
                    {
                        line.CleanText();
                        BBox b = BBox.ConvertBBoxToPoints(line.BBox, PDFSettings.Dpi);

                        if (b.Height > 28)
                            continue;

                        BBox lineBox = BBox.ConvertBBoxToPoints(line.BBox, PDFSettings.Dpi);
                        PdfContentByte cb = cb = writer.DirectContentUnder;

                        BaseFont base_font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.WINANSI, false);
                        iTextSharp.text.Font font = new iTextSharp.text.Font(base_font);

                        cb.BeginText();
                        cb.SetFontAndSize(base_font, b.Height > 0 ? b.Height : 2);
                        cb.SetTextMatrix(b.Left, doc.PageSize.Height - b.Top - b.Height + 2);
                        cb.SetWordSpacing(.25f);
                        cb.ShowText(line.Text);
                        cb.EndText();
                    }

                    if (PDFSettings.WriteTextMode == WriteTextMode.Character)
                    {
                        line.AlignTops();

                        foreach (hWord word in line.Words)
                        {
                            word.AlignCharacters();
                            foreach (hChar c in word.Characters)
                            {
                                BBox b = BBox.ConvertBBoxToPoints(c.BBox, PDFSettings.Dpi);
                                BBox lineBox = BBox.ConvertBBoxToPoints(c.BBox, PDFSettings.Dpi);
                                PdfContentByte cb = cb = writer.DirectContentUnder;

                                BaseFont base_font = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.WINANSI, false);
                                iTextSharp.text.Font font = new iTextSharp.text.Font(base_font);

                                cb.BeginText();
                                cb.SetFontAndSize(base_font, b.Height > 0 ? b.Height : 2);

                                cb.SetTextMatrix(b.Left, doc.PageSize.Height - b.Top - b.Height + 2);
                                cb.SetCharacterSpacing(-1f);
                                cb.ShowText(c.Text.Trim());
                                cb.EndText();
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// If adding an image directly, don't forget to call CreatePage
        /// </summary>
        /// <param name="image"></param>
        private void AddImage(System.Drawing.Image image)
        {
            try
            {
                if (OnProcessImageForDisplay != null)
                {
                    AddImage(OnProcessImageForDisplay(image));
                    return;
                }

                Bitmap bmp = ImageProcessor.GetAsBitmap(image, PDFSettings.Dpi);
                iTextSharp.text.Image i = GetImageForPDF(bmp);
                AddImage(i);
                //  i.SetAbsolutePosition(0, 0);
                // doc.SetPageSize(new iTextSharp.text.Rectangle(i.Width, i.Height));
                // i.ScaleAbsolute(doc.PageSize.Width, doc.PageSize.Height);
                // doc.Add(i);
            }
            catch (Exception x)
            {
                Debug.WriteLine(x.Message);
                throw x;
            }
        }

        private iTextSharp.text.Image GetImageForPDF(System.Drawing.Bitmap image)
        {
            iTextSharp.text.Image i = null;

      

            switch (PDFSettings.ImageType)
            {
                case PdfImageType.Tif:
                    i = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToCCITTFaxTiff(image), ImageFormat.Tiff);
                    break;
                case PdfImageType.Png:
                    i = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToImage(image, "PNG", PDFSettings.ImageQuality, PDFSettings.Dpi), ImageFormat.Png);
                    break;
                case PdfImageType.Jpg:
                    i = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToImage(image, "JPEG", PDFSettings.ImageQuality, PDFSettings.Dpi), ImageFormat.Jpeg);
                    break;
                case PdfImageType.Bmp:
                    i = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToImage(image, "BMP", PDFSettings.ImageQuality, PDFSettings.Dpi), ImageFormat.Bmp);
                    break;
                case PdfImageType.JBig2:
                    JBig2 jbig = new JBig2();
                    i = jbig.ProcessImage(image); ;
                    break;
            }
            return i;
        }

        private void AddImage(iTextSharp.text.Image image)
        {
            try
            {
                //Getting Width of the image width adding the page right & left margin
                var width = (image.Width / PDFSettings.Dpi) * 72;

                //Getting Height of the image height adding the page top & bottom margin
                var height = (image.Height / PDFSettings.Dpi) * 72;


                //Creating pdf rectangle with the specified height & width for page size declaration
                iTextSharp.text.Rectangle r = new iTextSharp.text.Rectangle(width, height);

                /*you __MUST__ call SetPageSize() __BEFORE__ calling NewPage()
                * AND __BEFORE__ adding the image to the document
                */

                //Changing the page size of the pdf document based on the rectangle defined
                if (PDFSettings.PdfPageSize == null)
                    doc.SetPageSize(r);
                else
                    doc.SetPageSize(PDFSettings.PdfPageSize);

                image.SetAbsolutePosition(0, 0);
                image.ScaleAbsolute(doc.PageSize.Width, doc.PageSize.Height);
                doc.NewPage();
                doc.Add(image);
                GC.Collect();
            }
            catch (Exception x)
            {
                Debug.WriteLine(x.Message);
                throw x;
            }
        }

        private void AddImage(string imagePath)
        {
            System.Drawing.Image image = System.Drawing.Image.FromFile(imagePath);
            AddImage(image);
        }


        #region IDisposable Members

        public void Dispose()
        {

            try
            {
                doc.Dispose();
                writer.Dispose();

                doc = null;
                writer = null;
                GC.Collect();
            }
            catch { }
        }

        #endregion
    }
}
