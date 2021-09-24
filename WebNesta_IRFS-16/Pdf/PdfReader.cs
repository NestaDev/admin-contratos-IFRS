using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using iTextSharp.text.pdf;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using iTextSharp.text;
using Clock.Hocr;
using iTextSharp.text.pdf.parser;
using System.Text.RegularExpressions;
using Clock.Util;
using Clock.ImageProcessing;
using System.Diagnostics;
using System.Linq;

namespace Clock.Pdf
{
    public delegate void SplitPDFForBookmark(string BookmarkTitle, string SavedFilePath);

    public class PdfReader : IDisposable
    {
        public iTextSharp.text.pdf.PdfReader iTextReader { get; private set; }
        public static event SplitPDFForBookmark OnSplitPDFForBookmark;
        public int PageCount
        {
            get { return iTextReader.NumberOfPages; }
        }

        public PdfReader(iTextSharp.text.pdf.PdfReader r)
        {
            iTextReader = r;

        }

        public string SourcePDF { get; private set; }

        public PdfReader(string sourcePdf)
        {
            SourcePDF = sourcePdf;
            iTextReader = new iTextSharp.text.pdf.PdfReader(sourcePdf);
            RandomAccessFileOrArray raf = new iTextSharp.text.pdf.RandomAccessFileOrArray(sourcePdf);

        }

        public PdfReader(string sourcePdf, string ownerPassword)
        {
            SourcePDF = sourcePdf;
            iTextReader = new iTextSharp.text.pdf.PdfReader(sourcePdf, System.Text.UTF8Encoding.UTF8.GetBytes(ownerPassword));
            RandomAccessFileOrArray raf = new iTextSharp.text.pdf.RandomAccessFileOrArray(sourcePdf);

        }

        public PdfReader(byte[] sourcePdf)
        {
            iTextReader = new iTextSharp.text.pdf.PdfReader(sourcePdf);
            //   RandomAccessFileOrArray raf = new iTextSharp.text.pdf.RandomAccessFileOrArray(sourcePdf);

        }

        public static void SplitPDFByBookmarks(String pdf, String outputFolder)
        {
            try
            {
                iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(pdf);
                //List of bookmarks: each bookmark is a map with values for title, page, etc
                System.Collections.Generic.IList<Dictionary<string, object>> bookmarks = SimpleBookmark.GetBookmark(reader);
                if (bookmarks == null)
                    return;
                //Loop through all fo the bookmarks
                for (int i = 0; i < bookmarks.Count; i++)
                {
                    Dictionary<string, object> bm = bookmarks[i];
                    Dictionary<string, object> nextBM = i == bookmarks.Count - 1 ? null : bookmarks[i + 1];
                    //Get the title value from the bookmark
                    String title = ((String)bm["Title"]);

                    string invalidChars = Regex.Escape(new string(System.IO.Path.GetInvalidFileNameChars()));
                    string invalidReStr = string.Format(@"[{0}]+", invalidChars);
                    title = Regex.Replace(title, invalidReStr, "_");

                    //for some reason these are stored like '1 XYZ null null null' the page is the first value of an array split by spaces
                    String startPage = ((String)bm["Page"]).Split(' ')[0];
                    String startPageNextBM = nextBM == null ? "" + (reader.NumberOfPages + 1) : ((String)nextBM["Page"]).Split(' ')[0];
                    Console.WriteLine("Page: " + startPage);
                    Console.WriteLine("------------------");
                    string outFileName = (title.Length > 100 ? title.Substring(0, 100) : title) + ".pdf";
                    extractBookmarkToPDF(reader, int.Parse(startPage), int.Parse(startPageNextBM), outFileName, outputFolder);

                    if (OnSplitPDFForBookmark != null)
                        OnSplitPDFForBookmark((string)bm["Title"], System.IO.Path.Combine(outputFolder, outFileName));
                }
            }
            catch (IOException e)
            {
                Console.WriteLine(e.Message);
            }
        }

        public static void SplitBookMarkChildren(iTextSharp.text.pdf.PdfReader reader, string outputFolder, System.Collections.Generic.IList<Dictionary<string, object>> bookmark)
        {
            foreach (Dictionary<string, object> dict in bookmark)
            {
                System.Collections.Generic.IList<Dictionary<string, object>> bookmarks = null;

                foreach (KeyValuePair<string, object> entry in dict)
                {
                    if (entry.Value is System.Collections.Generic.IList<Dictionary<string, object>>)
                    {
                        bookmarks = entry.Value as System.Collections.Generic.IList<Dictionary<string, object>>;
                    }
                    else
                        continue;

                    for (int i = 0; i < bookmarks.Count; i++)
                    {
                        Dictionary<string, object> bm = bookmarks[i];
                        Dictionary<string, object> nextBM = i == bookmarks.Count - 1 ? null : bookmarks[i + 1];
                        //Get the title value from the bookmark
                        String title = ((String)bm["Title"]);

                        string invalidChars = Regex.Escape(new string(System.IO.Path.GetInvalidFileNameChars()));
                        string invalidReStr = string.Format(@"[{0}]+", invalidChars);
                        title = Regex.Replace(title, invalidReStr, "_");

                        //for some reason these are stored like '1 XYZ null null null' the page is the first value of an array split by spaces
                        String startPage = ((String)bm["Page"]).Split(' ')[0];
                        String startPageNextBM = nextBM == null ? "" + (reader.NumberOfPages + 1) : ((String)nextBM["Page"]).Split(' ')[0];
                        Console.WriteLine("Page: " + startPage);
                        Console.WriteLine("------------------");
                        extractBookmarkToPDF(reader, int.Parse(startPage), int.Parse(startPageNextBM), title + ".pdf", outputFolder);

                        string outFileName = (title.Length > 100 ? title.Substring(0, 100) : title) + ".pdf";
                        extractBookmarkToPDF(reader, int.Parse(startPage), int.Parse(startPageNextBM), outFileName, outputFolder);
                        if (OnSplitPDFForBookmark != null)
                            OnSplitPDFForBookmark((string)bm["Title"], System.IO.Path.Combine(outputFolder, outFileName));

                        //SplitBookMarkChildren(reader, outputFolder, bookmarks);
                    }
                }
            }

        }

        public void ExtractPages(string outputPdfPath, int startRange, int endRage)
        {
            // create new pdf of pages in the extractPages list
            Document document = new Document();

            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfWriter writer = PdfWriter.GetInstance(document, memoryStream);
                document.Open();
                document.AddDocListener(writer);
                for (int p = 1; p <= iTextReader.NumberOfPages; p++)
                {
                    if (p < startRange || p > endRage)
                        continue;

                    document.SetPageSize(iTextReader.GetPageSizeWithRotation(p));
                    document.NewPage();
                    PdfContentByte cb = writer.DirectContent;
                    PdfImportedPage pageImport = writer.GetImportedPage(iTextReader, p);
                    int rot = iTextReader.GetPageRotation(p);
                    if (rot == 90 || rot == 270)
                    {
                        cb.AddTemplate(pageImport, 0, -1.0F, 1.0F, 0, 0, iTextReader.GetPageSizeWithRotation(p).Height);
                    }
                    else
                    {
                        cb.AddTemplate(pageImport, 1.0F, 0, 0, 1.0F, 0, 0);
                    }
                }
                iTextReader.Close();
                document.Close();
                File.WriteAllBytes(outputPdfPath, memoryStream.ToArray());
            }
        }

        private static void extractBookmarkToPDF(iTextSharp.text.pdf.PdfReader reader, int pageFrom, int pageTo, String outputName, String outputFolder)
        {
            Document document = new Document();
            try
            {
                // Create a writer for the outputstream
                PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(outputFolder + outputName, FileMode.Create));
                document.Open();
                PdfContentByte cb = writer.DirectContent; // Holds the PDF data
                PdfImportedPage page;

                while (pageFrom <= pageTo)
                {
                    if (pageFrom > pageTo)
                        break;

                    document.NewPage();
                    page = writer.GetImportedPage(reader, pageFrom);

                    cb.AddTemplate(page, 0, 0);

                    //document.SetPageSize(new iTextSharp.text.Rectangle(page.Width, page.Height));
                    pageFrom++;
                }
                document.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                if (document.IsOpen())
                    document.Close();
            }
        }

        public void Close()
        {
            iTextReader.Close();
        }

        public string GetPageText(int PageNumber)
        {
            PdfTextExtractionStrategy strat = new PdfTextExtractionStrategy();
            string te = PdfTextExtractor.GetTextFromPage(this.iTextReader, PageNumber, strat);


            return te;

        }

        public string ExtractText()
        {
            PdfTextExtractionStrategy strat = new PdfTextExtractionStrategy();
            StringBuilder sb = new StringBuilder();
            for (int i = 1; i < iTextReader.NumberOfPages; i++)
            {
      
                string te = PdfTextExtractor.GetTextFromPage(this.iTextReader, i, strat);
                sb.Append(te);

            }
            return sb.ToString();
        }

        //public string ExtractText(int PageNumber)
        //{
        //    StringBuilder sb = new StringBuilder();

        //    byte[] fileBytes = iTextReader.GetPageContent(PageNumber);
        //    PRTokeniser token = new PRTokeniser(fileBytes);
        //    try
        //    {
        //        while (token.NextToken())
        //        {
        //            if (token.TokenType == PRTokeniser.TokType.STRING)
        //            {
        //                try
        //                {
        //                    sb.Append(token.StringValue);
        //                }
        //                catch (Exception x)
        //                {
        //                    continue;
        //                }
        //            }
        //        }
        //    }
        //    catch (Exception x)
        //    {

        //        return string.Empty;
        //    }

        //    return sb.ToString();
        //}

        public void ExtractPages(string sourcePdfPath, string outputPdfPath, string extractRange, string password)
        {
            if (sourcePdfPath == outputPdfPath)
            {
                throw new Exception("For Extracting PDFs the source and output cannot be the same -- use Delete and inverse your range");
            }

            List<int> pagesToExtract = StringRangeToListInt(extractRange);
            // create new pdf of pages in the extractPages list
            Document document = new Document();
            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfWriter writer = PdfWriter.GetInstance(document, memoryStream);
                document.Open();
                document.AddDocListener(writer);
                for (int p = 1; p <= iTextReader.NumberOfPages; p++)
                {
                    if (pagesToExtract.FindIndex(s => s == p) == -1) continue;
                    document.SetPageSize(iTextReader.GetPageSizeWithRotation(p));
                    document.NewPage();
                    PdfContentByte cb = writer.DirectContent;
                    PdfImportedPage pageImport = writer.GetImportedPage(iTextReader, p);
                    int rot = iTextReader.GetPageRotation(p);
                    if (rot == 90 || rot == 270)
                    {
                        cb.AddTemplate(pageImport, 0, -1.0F, 1.0F, 0, 0, iTextReader.GetPageSizeWithRotation(p).Height);
                    }
                    else
                    {
                        cb.AddTemplate(pageImport, 1.0F, 0, 0, 1.0F, 0, 0);
                    }
                }
                iTextReader.Close();
                document.Close();
                File.WriteAllBytes(outputPdfPath, memoryStream.ToArray());
            }
        }

        /// <summary>
        /// Watermark a PDF.
        /// </summary>
        /// <param name="waterMarkText"></param>
        /// <returns>Newly watermarked PDF in bytes</returns>
        public byte[] WatermarkToPDF(string waterMarkText)
        {
            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfStamper pdfStamper = new PdfStamper(iTextReader, memoryStream);

                for (int i = 1; i <= iTextReader.NumberOfPages; i++) // Must start at 1 because 0 is not an actual page.
                {
                    PdfDictionary page = iTextReader.GetPageN(i);
                    //Get the raw content
                    PdfArray contentarray = page.GetAsArray(PdfName.CONTENTS);
                    if (contentarray != null)
                    {
                        //Loop through content
                        for (int j = 0; j < contentarray.Size; j++)
                        {
                            //Get the raw byte stream
                            PRStream stream = (PRStream)contentarray.GetAsStream(j);
                            //Convert to a string. NOTE, you might need a different encoding here
                            String content = System.Text.Encoding.ASCII.GetString(iTextSharp.text.pdf.PdfReader.GetStreamBytes(stream));
                            //Look for the OCG token in the stream as well as our watermarked text
                            if (content.IndexOf(waterMarkText) >= 0)
                            {
                                //Remove it by giving it zero length and zero data
                                stream.Put(PdfName.LENGTH, new PdfNumber(0));
                                stream.SetData(new byte[0]);
                            }
                        }
                    }

                    iTextSharp.text.Rectangle pageSize = iTextReader.GetPageSizeWithRotation(i);
                    PdfContentByte pdfPageContents = pdfStamper.GetOverContent(i);

                    PdfGState gstate = new PdfGState();
                    gstate.FillOpacity = 0.5f;
                    gstate.StrokeOpacity = 0.5f;

                    pdfPageContents.SaveState();
                    pdfPageContents.SetGState(gstate);

                    pdfPageContents.BeginText(); // Start working with text.
                    BaseFont baseFont = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, Encoding.ASCII.EncodingName, false);
                    pdfPageContents.SetFontAndSize(baseFont, 120); // 40 point font

                    pdfPageContents.SetRGBColorFill(Color.DarkGray.R, Color.DarkGray.G, Color.DarkGray.B); // Sets the color of the font, RED in this instance
                    float textAngle =
                        (float)GetHypotenuseAngleInDegreesFrom(pageSize.Height, pageSize.Width);

                    pdfPageContents.ShowTextAligned(PdfContentByte.ALIGN_CENTER, waterMarkText,
                                   pageSize.Width / 2,
                                   pageSize.Height / 2 + 600,
                                   textAngle);

                    pdfPageContents.ShowTextAligned(PdfContentByte.ALIGN_CENTER, waterMarkText,
                                                    pageSize.Width / 2,
                                                    pageSize.Height / 2 + 200,
                                                    textAngle);

                    pdfPageContents.ShowTextAligned(PdfContentByte.ALIGN_CENTER, waterMarkText,
                                                    pageSize.Width / 2,
                                                    pageSize.Height / 2 - 200,
                                                    textAngle);

                    pdfPageContents.ShowTextAligned(PdfContentByte.ALIGN_CENTER, waterMarkText,
                                             pageSize.Width / 2,
                                             pageSize.Height / 2 - 600,
                                             textAngle);


                    pdfPageContents.EndText(); // Done working with text
                }
                pdfStamper.FormFlattening = true; // enable this if you want the PDF flattened. 
                pdfStamper.Close(); // Always close the stamper or you'll have a 0 byte stream. 

                MemoryStream saveToMS = new MemoryStream();
                PdfEncryptor.Encrypt(
                  new iTextSharp.text.pdf.PdfReader(memoryStream.ToArray()),
                  saveToMS,
                  true,
                  null,
                  "C0lumbi@",
                  PdfWriter.ALLOW_PRINTING | PdfWriter.ALLOW_COPY

                );
                return saveToMS.ToArray();
            }
        }

        static double GetHypotenuseAngleInDegreesFrom(double opposite, double adjacent)
        {
            //http://www.regentsprep.org/Regents/Math/rtritrig/LtrigA.htm
            // Tan <angle> = opposite/adjacent
            // Math.Atan2: http://msdn.microsoft.com/en-us/library/system.math.atan2(VS.80).aspx 

            double radians = Math.Atan2(opposite, adjacent); // Get Radians for Atan2
            double angle = radians * (180 / Math.PI); // Change back to degrees
            return angle;
        }

        public byte[] ExtractPagesToPDFBytes(string extractRange, string password)
        {
            List<int> pagesToExtract = StringRangeToListInt(extractRange);
            // create new pdf of pages in the extractPages list
            Document document = new Document();
            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfWriter writer = PdfWriter.GetInstance(document, memoryStream);
                document.Open();
                document.AddDocListener(writer);
                for (int p = 1; p <= iTextReader.NumberOfPages; p++)
                {
                    if (pagesToExtract.FindIndex(s => s == p) == -1) continue;
                    document.SetPageSize(iTextReader.GetPageSizeWithRotation(p));
                    document.NewPage();
                    PdfContentByte cb = writer.DirectContent;
                    PdfImportedPage pageImport = writer.GetImportedPage(iTextReader, p);
                    int rot = iTextReader.GetPageRotation(p);

                    // cb.AddTemplate(pageImport, 1.0F, 0, 0, 1.0F, 0, 0);
                    if (rot == 90 || rot == 270)
                    {
                        cb.AddTemplate(pageImport, 0, -1.0F, 1.0F, 0, 0, iTextReader.GetPageSizeWithRotation(p).Height);
                    }
                    else
                    {
                        cb.AddTemplate(pageImport, 1.0F, 0, 0, 1.0F, 0, 0);
                    }
                }
                iTextReader.Close();
                document.Close();
                return memoryStream.ToArray();
            }
        }

        private string GetPageImageWithGhostScript(int PageNumber)
        {
            GhostScript g = new GhostScript();
            string imgFile = g.ConvertPDFToBitmap(SourcePDF, PageNumber, PageNumber);
            return imgFile;
        }


        public string GetPageImage(int PageNumber, bool useGhostscript)
        {
            if (useGhostscript) 
                return GetPageImageWithGhostScript(PageNumber);

            PdfReaderContentParser parser = new PdfReaderContentParser(iTextReader);
            MyImageRenderListener listener = new MyImageRenderListener();
            listener.PageNumber = PageNumber;
            listener.Reader = this;

            try
            {

                parser.ProcessContent(PageNumber, listener);

                if (listener.ParsedImages.Count > 1 && GetPageText(PageNumber).Trim() != string.Empty)
                    return null;

                if (listener.ParsedImages.Count > 0)
                {
                    //   Dpi = (int)Math.Ceiling(listener.ParsedImages[0].Image.HorizontalResolution + listener.ParsedImages[0].Image.VerticalResolution);
                    string s = TempData.Instance.CreateTempFile(".bmp");
                    var bmp = ImageProcessor.ConvertToImage(listener.ParsedImages[0].Image, "BMP", 100, 300);

                    bmp.Save(s);
                    return s;
                }

            }
            catch (Exception x)
            {
                return GetPageImageWithGhostScript(PageNumber);

            }
            return null;
        }

        /// <summary>
        /// Extract a range of pages to an image
        /// </summary>
        /// <param name="PageNumber"></param>
        /// <returns></returns>
        //        public void GetPagesToGreyscaleImage(int startPage, int endPage, string saveTiffTo)
        //        {
        //
        //            byte[] bytes = ExtractPagesToPDFBytes(string.Concat(startPage, "-", endPage), "");
        //                byte[] imgBytes = MuPdfConverter.ConvertPdfToTiff(bytes, 300, RenderType.Grayscale, false, false, 0, "");
        //                File.WriteAllBytes(saveTiffTo, imgBytes);
        //        }

        //public System.Drawing.Bitmap GetPageImage(int PageNumber)
        //{
        //    PdfDictionary page = pdf.GetPageN(PageNumber);
        //    PdfDictionary res = (PdfDictionary)iTextSharp.text.pdf.PdfReader.GetPdfObject(page.Get(PdfName.RESOURCES));
        //    PdfDictionary xobj = (PdfDictionary)iTextSharp.text.pdf.PdfReader.GetPdfObject(res.Get(PdfName.XOBJECT));

        //    if (xobj != null)
        //    {
        //        foreach (PdfName name in xobj.Keys)
        //        {
        //            PdfObject obj = xobj.Get(name);
        //            if (obj.IsIndirect())
        //            {
        //                PdfDictionary tg = (PdfDictionary)iTextSharp.text.pdf.PdfReader.GetPdfObject(obj);
        //                PdfName type = (PdfName)iTextSharp.text.pdf.PdfReader.GetPdfObject(tg.Get(PdfName.SUBTYPE));

        //                //image at the root of the pdf 
        //                if (PdfName.IMAGE.Equals(type))
        //                {
        //                    int XrefIndex = Convert.ToInt32(((PRIndirectReference)obj).Number.ToString(System.Globalization.CultureInfo.InvariantCulture));
        //                    PdfObject pdfObj = pdf.GetPdfObject(XrefIndex);
        //                    PdfStream pdfStrem = (PdfStream)pdfObj;

        //                    string filter = tg.Get(PdfName.FILTER).ToString();
        //                    string width = "";
        //                    string height = "";
        //                    string bpp = "";
        //                    string extent = ".";
        //                    byte[] imgData = null;
        //                    Bitmap bmp = null;
        //                    switch (filter)
        //                    {
        //                        case "/FlateDecode":
        //                            width = tg.Get(PdfName.WIDTH).ToString();
        //                            height = tg.Get(PdfName.HEIGHT).ToString();
        //                            bpp = tg.Get(PdfName.BITSPERCOMPONENT).ToString();
        //                            extent = ".";
        //                            imgData = iTextSharp.text.pdf.PdfReader.FlateDecode(iTextSharp.text.pdf.PdfReader.GetStreamBytesRaw((PRStream)obj), true);
        //                            bmp = new Bitmap(Int32.Parse(width), Int32.Parse(height), PixelFormat.Format24bppRgb);
        //                            BitmapData bmd = bmp.LockBits(new System.Drawing.Rectangle(0, 0, Int32.Parse(width), Int32.Parse(height)), ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);
        //                            Marshal.Copy(imgData, 0, bmd.Scan0, imgData.Length);
        //                            bmp.UnlockBits(bmd);
        //                            return bmp;
        //                        case "/CCITTFaxDecode":
        //                            bmp = ImageProcessor.GetAsBitmap(GetImage(PageNumber, RenderType.Grayscale));
        //                            return ImageProcessor.ConvertImageToGreyScale(bmp);
        //                        case "/JBIG2Decode":
        //                            bmp = ImageProcessor.GetAsBitmap(GetImage(PageNumber, RenderType.Grayscale));
        //                            return ImageProcessor.ConvertImageToGreyScale(bmp); ;
        //                        case "/JPXDecode":
        //                            bmp = ImageProcessor.GetAsBitmap(GetImage(PageNumber, RenderType.RGB));
        //                            return bmp;
        //                        case "/DCTDecode":
        //                            bmp = ImageProcessor.GetAsBitmap(GetImage(PageNumber, RenderType.RGB));
        //                            return bmp;
        //                        default:
        //                            bmp = ImageProcessor.GetAsBitmap(GetImage(PageNumber, RenderType.Grayscale));
        //                            return ImageProcessor.ConvertImageToGreyScale(bmp);
        //                            ;
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    return null;
        //}
        //
        //        public System.Drawing.Image GetPageImageGreyScale(int PageNumber)
        //        {
        //            byte[] bytes = ExtractPagesToPDFBytes(string.Concat(PageNumber, "-", PageNumber), "");    
        //            byte[] imgBytes = MuPdfConverter.ConvertPdfToTiff(bytes, 300, RenderType.Grayscale, true, true, 0, "");
        //            return System.Drawing.Image.FromStream(new MemoryStream(imgBytes));
        //
        //        }

        //        public System.Drawing.Image GetPageImageMonoChrome(int PageNumber)
        //        {
        //            byte[] bytes = ExtractPagesToPDFBytes(string.Concat(PageNumber, "-", PageNumber), "");
        //
        //
        //            byte[] imgBytes = MuPdfConverter.ConvertPdfToTiff(bytes, 300, RenderType.Monochrome, true, true, 0, "");
        //            return System.Drawing.Image.FromStream(new MemoryStream(imgBytes));
        //
        //        }


        //        public System.Drawing.Image GetPageImageRGB(int PageNumber)
        //        {
        //            byte[] bytes = ExtractPagesToPDFBytes(string.Concat(PageNumber, "-", PageNumber), "");
        //
        //       
        //            byte[] imgBytes = MuPdfConverter.ConvertPdfToTiff(bytes, 300, RenderType.RGB, true, true, 0, "");
        //            return System.Drawing.Image.FromStream(new MemoryStream(imgBytes));
        //
        //        }  

        public void Dispose()
        {
            iTextReader.Close();
            iTextReader = null;

        }

        private List<int> StringRangeToListInt(string userRange)
        {

            // parse pagesToExtract string to List of all pages

            List<int> pagesToList = new List<int>();

            // check for non-consecutive ranges :: 1,5,10

            if (userRange.IndexOf(",") != -1)
            {

                string[] tmpHold = userRange.Split(',');

                foreach (string nonconseq in tmpHold)
                {

                    // check for ranges :: 1-5

                    if (nonconseq.IndexOf("-") != -1)
                    {

                        string[] rangeHold = nonconseq.Split('-');

                        for (int i = Convert.ToInt32(rangeHold[0]); i <= Convert.ToInt32(rangeHold[1]); i++)
                        {

                            pagesToList.Add(i);

                        }

                    }

                    else
                    {

                        pagesToList.Add(Convert.ToInt32(nonconseq));

                    }

                }

            }

            else
            {

                // check for ranges :: 1-5

                if (userRange.IndexOf("-") != -1)
                {

                    string[] rangeHold = userRange.Split('-');

                    for (int i = Convert.ToInt32(rangeHold[0]); i <= Convert.ToInt32(rangeHold[1]); i++)
                    {

                        pagesToList.Add(i);

                    }

                }

                else
                {

                    // single number found :: 1

                    pagesToList.Add(Convert.ToInt32(userRange));

                }

            }

            return pagesToList;

        }


        /// <summary>
        /// Get text that is contained within a rectangle on a page 
        /// </summary>
        /// <param name="PageNumber"></param>
        /// <param name="rect"></param>
        /// <returns></returns>
        public IList<HOcrClass> GetTextWithinBounds(int PageNumber, BBox rect)
        {
            IList<HOcrClass> Elements = new List<HOcrClass>();
            PdfTextExtractionStrategy strat = new PdfTextExtractionStrategy();
            string te = PdfTextExtractor.GetTextFromPage(this.iTextReader, PageNumber, strat);

            if (rect.Format == UnitFormat.Pixel) 
                rect = rect.DefaultPointBBox;
            rect.Top = iTextReader.GetPageSize(PageNumber).Height - rect.Top;
            foreach (var e in strat.Elements)
            {
                if (rect.Rectangle.Contains(e.BBox.Rectangle) || rect.Rectangle.IntersectsWith(e.BBox.Rectangle))
                        Elements.Add(e);
                
            }
            return Elements;
        } 

        /// <summary>
        /// 
        /// </summary>
        /// <param name="PageNumber"></param>
        /// <returns>Returns BBox values of found text in points, not pixels</returns>
        public IList<HOcrClass> GetWordLocationsForPage(int PageNumber)
        {
            IList<HOcrClass> Elements = new List<HOcrClass>();
            PdfTextExtractionStrategy strat = new PdfTextExtractionStrategy();
            string te = PdfTextExtractor.GetTextFromPage(this.iTextReader, PageNumber, strat);

            return strat.Elements;
        }
    }

    internal class PdfTextExtractionStrategy : LocationTextExtractionStrategy
    {
        public IList<HOcrClass> Elements { get; private set; }
        public PdfTextExtractionStrategy()
        {
            Elements = new List<HOcrClass>();
        }
        void BeginTextBlock() { }
        void EndTextBlock() { }
        void RenderImage(ImageRenderInfo info) { }
        public override void RenderText(TextRenderInfo info)
        {

            Vector bottomLeft = info.GetDescentLine().GetStartPoint();
            Vector topRight = info.GetAscentLine().GetEndPoint();
            iTextSharp.text.Rectangle rect = new iTextSharp.text.Rectangle(bottomLeft[Vector.I1],
                                           bottomLeft[Vector.I2],
                                           topRight[Vector.I1],
                                           topRight[Vector.I2]);
            BBox b = new BBox();
            b.Format = UnitFormat.Point;
            b.Height = rect.Height;
            b.Left = rect.Left;
            b.Height = rect.Height;
            b.Width = rect.Width;
            b.Top = rect.Top;
            var o = new HOcrClass();
            o.BBox = b;
            o.Text = info.GetText();
            o.ClassName = "xocr_word";
            Elements.Add(o);
            base.RenderText(info);
        }

    }
    internal class MyImageRenderListener : IRenderListener
    {
        public void RenderText(TextRenderInfo renderInfo) { }
        public void BeginTextBlock() { }
        public void EndTextBlock() { }

        public PdfReader Reader { get; set; }
        public int PageNumber { get; set; }
        public List<ParsedPageImage> ParsedImages = new List<ParsedPageImage>();
        PdfName filter;

        public void RenderImage(ImageRenderInfo renderInfo)
        {
            PdfImageObject image = null;

            try
            {
                image = renderInfo.GetImage();
                if (image == null) return;

                if (renderInfo.GetRef() == null)
                    return;

                int num = renderInfo.GetRef().Number;


                byte[] bytes = image.GetImageAsBytes();
                if (bytes == null)
                    return;

                ParsedPageImage pi = new ParsedPageImage();
                pi.IndirectReferenceNum = num;
                pi.PdfImageObject = image;


                filter = (PdfName)image.Get(PdfName.FILTER);
                pi.Image = image.GetDrawingImage();
                //                if (filter.ToString() == "/DCTDecode")
                //                {
                //                    byte[] dbytes = Reader.ExtractPagesToPDFBytes(string.Concat(PageNumber, "-", PageNumber), "");
                //                    byte[] dimgBytes = MuPdfConverter.ConvertPdfToTiff(dbytes, 300, RenderType.RGB, false, false, 0, "");
                //                    System.Drawing.Image dcolor = System.Drawing.Image.FromStream(new MemoryStream(dimgBytes));
                //                    pi.Image = dcolor;
                //                    ParsedImages.Add(pi);
                //                    return;
                //                }
                //
                //                if (filter.ToString() == "/JBIG2Decode")
                //                {
                //                    byte[] imgBytes;
                //                    bytes = Reader.ExtractPagesToPDFBytes(string.Concat(PageNumber, "-", PageNumber), "");
                //                    imgBytes = MuPdfConverter.ConvertPdfToTiff(bytes, 300, RenderType.Grayscale, false, false, 0, "");
                //                    System.Drawing.Image grey = System.Drawing.Image.FromStream(new MemoryStream(imgBytes));
                //                    grey = ImageProcessor.ConvertToBitonal(ImageProcessor.GetAsBitmap(grey));
                //                    pi.Image = grey;
                //                    ParsedImages.Add(pi);
                //                    return;
                //                }

                using (MemoryStream ms = new MemoryStream(bytes))
                {
                    pi.Image = System.Drawing.Image.FromStream(new MemoryStream(bytes));
                    ParsedImages.Add(pi);
                    return;

                }
            }
            catch (IOException ie)
            {
                //PdfIndirectReference r = renderInfo.GetRef();


                //bytes = Reader.ExtractPagesToPDFBytes(string.Concat(PageNumber, "-", PageNumber), "");
                //imgBytes = MuPdfConverter.ConvertPdfToTiff(bytes, 300, RenderType.RGB, false,false, 0, "");
                //System.Drawing.Image color = System.Drawing.Image.FromStream(new MemoryStream(imgBytes));

                //Images.Add(color);
            }

        }
    }
    internal class ParsedPageImage
    {
        public System.Drawing.Image Image { get; set; }
        public PdfImageObject PdfImageObject { get; set; }
        public int IndirectReferenceNum { get; set; }
        public PRStream PRStream { get; set; }
    }
}
