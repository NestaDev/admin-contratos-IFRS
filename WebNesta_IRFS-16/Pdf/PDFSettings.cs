using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing.Imaging;
using Clock.Util;
using iTextSharp.text;
using System.Drawing;

namespace Clock.Pdf
{
    public enum PdfMode { Ocr, DrawBlocks, TextOnly, ImageOnly, Debug }
    public enum WriteTextMode { Line, Word, Character }
    public enum PdfImageType { Bmp, Jpg, Tif, Png, JBig2, Gif }
 //   public enum OcrLanguage { Eng, Ger }
    // Bmp, JPeg, Tiff, Png,
    public class PDFSettings
    {
        public string Author{get;set;}
        public string Title { get; set; }
        public string Subject { get; set; }
        public string Keywords { get; set; }
        public PdfImageType ImageType { get; set; }
        public OcrMode PdfOcrMode { get; set; }
        public int Dpi { get; set; }
        public string Language { get; set; }

        /// <summary>
        /// Name of the installed font file that you want to use and embed in the pdf, Ex. "ARIALUNI.TTF"
        /// </summary>
        public string FontName { get; set; }
        /// <summary>
        /// write unlerlay text by lin e or word. by line creates smalled pdf files. word is ignored if OcrMode == cuneiform
        /// </summary>
        public WriteTextMode WriteTextMode { get; set; }

        public long ImageQuality { get; set; }
        public iTextSharp.text.Rectangle PdfPageSize { get; set; }


        public PDFSettings()
        {
            Dpi = 600;
            //ImageType = PdfImageType.JBig2;
            ImageType = PdfImageType.Png;
            PdfOcrMode = OcrMode.Tesseract;
            ImageQuality = 30;
            WriteTextMode = WriteTextMode.Word;
          //  PdfPageSize =  Clock.Pdf.PageSize.LETTER;
            Language = "eng";
        }

    }
}
