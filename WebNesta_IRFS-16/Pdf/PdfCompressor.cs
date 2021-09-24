using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Drawing;
using iTextSharp.text.pdf;
using System.Threading;
using System.Threading.Tasks;
using System.Drawing.Imaging;
using Clock.Util;
using Clock.ImageProcessing;

namespace Clock.Pdf
{
    public delegate void CompressorProgress(int Page, int TotalPages, double TotalSeconds);
    public delegate void CompressorJobFinished(PdfCompressor c);
    public delegate void CompressorExceptionOccurred(PdfCompressor c, Exception x);
    public delegate string PreProcessImage(string bitmapPath);
    public enum CompressorState { Pending, Paused, Running, Complete, Cancelled }

    public class PdfCompressor
    {
        string inputPDF;
        string outputPDf;

        CompressorState state;
        public CompressorState State { get { return state; } }
        public event CompressorProgress OnProgressComplete;
        public event CompressorJobFinished OnJobFinished;
        public event CompressorExceptionOccurred OnExceptionOccurred;

		/// <summary>
		/// PreProcess the image before ocr and converting. Useful for deskewing, etc..
		/// </summary>
		public event PreProcessImage OnPreProcessImage;
        public PDFSettings PdfSettings { get; set; }
        public PdfMode Mode { get; set; }
  
        public string InputFileName { get { return inputPDF; } }
        public string OutputFileName { get { return outputPDf; } }
        string progress = string.Empty;
        public string Progress { get { return progress; } }
	
        public PdfCompressor(PDFSettings s, string InputPDF, string OutputPDF)
        {
            inputPDF = InputPDF;
            outputPDf = OutputPDF;
            PdfSettings = s;
            state = CompressorState.Pending;

        }

        public PdfCompressor(string InputPDF, string OutputPDF, bool ocr)
        {
            inputPDF = InputPDF;
            outputPDf = OutputPDF;
            PdfSettings = new PDFSettings();
			if(ocr == false)
				PdfSettings.PdfOcrMode = OcrMode.Tesseract;
            

            state = CompressorState.Pending;
        }


        public void Start()
        {
           StartThread();

        }

        private void StartThread ()
		{
			state = CompressorState.Running;
            //added by prasad
            PdfSettings.PdfOcrMode = OcrMode.Tesseract;
            PdfSettings.Dpi = 600;

			if (PdfSettings.PdfOcrMode == OcrMode.None)
				RecompressImages ();
			else
				CompressAndOCR ();

        }

        public void Pause()
        {
			state = CompressorState.Paused;
        }

        public void Resume()
        {
            state = CompressorState.Running;
        }

        public void Cancel()
        {
            state = CompressorState.Cancelled;

			if(OnJobFinished != null)
				OnJobFinished(this);
        }

        private void RecompressImages()
        {

            PdfReader reader = new PdfReader(inputPDF);
            PdfCreator writer = new PdfCreator(PdfSettings, outputPDf);
            writer.PDFSettings.WriteTextMode = WriteTextMode.Word;
            
           
            try
            {
                for (int i = 1; i <= reader.PageCount; i++)
                {

                    if (this.State == CompressorState.Cancelled)
                        return;

                    writer.PDFSettings.PdfPageSize = reader.iTextReader.GetPageSize(i);
                    DateTime start = DateTime.Now;
                    string img = reader.GetPageImage(i, true);
                    if (img == null)
                        continue;

                    if (OnPreProcessImage != null)
                        img = OnPreProcessImage(img);

                    writer.AddPage(img, PdfMode.ImageOnly);
                    DateTime end = DateTime.Now;

                    var loc = reader.GetWordLocationsForPage(i);
                    writer.WriteUnderlayContent(loc);
                    if (OnProgressComplete != null)
                    {
                        progress = string.Concat(i, " of ", reader.PageCount);
                        OnProgressComplete(i, reader.PageCount, (end - start).TotalSeconds);
                    }

                    TempData.Instance.Cleanup(img);
                }
                writer.SaveAndClose();
                writer.Dispose();
                reader.Dispose();

                state = CompressorState.Complete;

                if (OnJobFinished != null)
                    OnJobFinished(this);
            }
            catch (Exception x)
            {
                Console.WriteLine(x.Message);
                Console.WriteLine("Image not supported in " + Path.GetFileName(inputPDF) + ". Skipping");
                writer.SaveAndClose();
                writer.Dispose();
                reader.Dispose();
                writer = null;
                reader = null;
                GC.Collect();

                if (OnExceptionOccurred != null)
                    OnExceptionOccurred(this, x);

            }
        }

        //private void RecompressImages()
        //{

        //    //Bind a reader to our large PDF
        //    iTextSharp.text.pdf.PdfReader reader = new iTextSharp.text.pdf.PdfReader(inputPDF);

        //    //Create our output PDF
        //    using (FileStream fs = new FileStream(outputPDf, FileMode.Create, FileAccess.Write, FileShare.None))
        //    {
        //        //Bind a stamper to the file and our reader
        //        using (PdfStamper stamper = new PdfStamper(reader, fs))
        //        {

        //          //  stamper.Writer.Info.Put(new PdfName("Producer"), new PdfString("Columbia County FLA. Board of County Commissioners"));
        //            //NOTE: This code only deals with page 1, you'd want to loop more for your code
        //            for (int i = 1; i <= reader.NumberOfPages; i++)
        //            {
        //                if (state == CompressorState.Cancelled)
        //                {
        //                    progress = string.Empty;
        //                    return;
        //                }
        //                while (state == CompressorState.Paused)
        //                {
        //                    Thread.Sleep(100);
        //                }
        //                PdfDictionary page = reader.GetPageN(i);
        //                //Get the xobject structure
        //                PdfDictionary resources = (PdfDictionary)iTextSharp.text.pdf.PdfReader.GetPdfObject(page.Get(PdfName.RESOURCES));
        //                PdfDictionary xobject = (PdfDictionary)iTextSharp.text.pdf.PdfReader.GetPdfObject(resources.Get(PdfName.XOBJECT));
        //                DateTime start = DateTime.Now;
        //                DateTime end;
        //                if (xobject != null)
        //                {
                            
        //                    PdfObject obj;
        //                    bool imageReplaced = false;

                        
        //                    //Loop through each key
        //                    foreach (PdfName name in xobject.Keys)
        //                    {
  
        //                        obj = xobject.Get(name);
        //                        if (obj.IsIndirect())
        //                        {
        //                            //Get the current key as a PDF object
        //                            PdfDictionary imgObject = (PdfDictionary)iTextSharp.text.pdf.PdfReader.GetPdfObject(obj);
        //                            //See if its an image
        //                            if (imgObject.Get(PdfName.SUBTYPE).Equals(PdfName.IMAGE))
        //                            {

                            

        //                                if (imageReplaced == true)
        //                                    continue;

        //                                iTextSharp.text.Image compressedImage = null;
        //                                PdfReader r = new PdfReader(inputPDF);
                                                                           
        //                                string image = r.GetPageImage(i, true);
                                       
        //                                if (image == null)
        //                                    continue;

        //                                if (OnPreProcessImage != null)
        //                                {
        //                                    image = OnPreProcessImage(image);
        //                                }
                                        
        //                                switch (PdfSettings.ImageType)
        //                                {
        //                                    case PdfImageType.Tif:
        //                                        compressedImage = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToCCITTFaxTiff(image), ImageFormat.Tiff);
        //                                        break;
        //                                    case PdfImageType.Png:
        //                                        compressedImage = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToImage(image, "PNG", PdfSettings.ImageQuality, PdfSettings.Dpi), ImageFormat.Png);
        //                                        break;
        //                                    case PdfImageType.Jpg:
        //                                        compressedImage = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToImage(image, "JPEG", PdfSettings.ImageQuality, PdfSettings.Dpi), ImageFormat.Jpeg);
        //                                        break;
        //                                    case PdfImageType.Bmp:
        //                                        compressedImage = iTextSharp.text.Image.GetInstance(ImageProcessor.ConvertToImage(image, "BMP", PdfSettings.ImageQuality, PdfSettings.Dpi), ImageFormat.Bmp);
        //                                        break;
        //                                    case PdfImageType.JBig2:
        //                                        JBig2 jbig = new JBig2();
        //                                        compressedImage = jbig.ProcessImage(image); ;
        //                                        break;
        //                                }

        //                                //Kill off the old image
        //                                iTextSharp.text.pdf.PdfReader.KillIndirect(obj);
        //                                //Add our image in its place
        //                                stamper.Writer.AddDirectImageSimple(compressedImage, (PRIndirectReference)obj);
        //                                imageReplaced = true;
        //                                TempData.Instance.Cleanup(image);
        //                                Console.WriteLine("Compressed page: " + i.ToString());
        //                            //	File.Delete(image);
        //                            }
        //                        }
        //                    }

        //                }

        //                if (OnProgressComplete != null)
        //                {
        //                    end = DateTime.Now;
        //                    progress = string.Concat(i, " of ", reader.NumberOfPages);
        //                    OnProgressComplete(i, reader.NumberOfPages, (start - end).TotalSeconds);
        //                }
        //            }

        //            stamper.SetFullCompression();
        //            stamper.Writer.CompressionLevel = 9;
        //            stamper.FreeTextFlattening = true;
        //            stamper.FormFlattening = true;
        //            if(PdfSettings.ImageType != PdfImageType.JBig2)
        //                stamper.Writer.SetPdfVersion(PdfWriter.PDF_VERSION_1_5);

        //            state = CompressorState.Complete;

        //            reader.Close();
        //            reader = null;
        //            stamper.Close();
        //            stamper.Dispose();
        //            if (OnJobFinished != null)
        //                OnJobFinished(this);

        //        }
        //    }

        //    Cleanup();
        //}

		public void Cleanup()
		{
				try {
				Directory.Delete (TempData.Instance.CurrentJobFolder, true);
			} catch (Exception x) {
				string msg = x.Message;
			}
		}

        private void CompressAndOCR()
        {

            PdfReader reader = new PdfReader(inputPDF);
            PdfCreator writer = new PdfCreator(PdfSettings, outputPDf);
            writer.PDFSettings.WriteTextMode = WriteTextMode.Word;
            try
            {
                for (int i = 1; i <= reader.PageCount; i++)
                {
                    if (this.State == CompressorState.Cancelled)
                        return;
                    DateTime start = DateTime.Now;
                    //int? dpi;
					string img = reader.GetPageImage (i, true);
                  //  System.Diagnostics.Process.Start(img);
                    var bmp = Image.FromFile(img);
                   // PdfSettings.Dpi = (int)bmp.VerticalResolution;
					if (img == null)
						continue;

					if (OnPreProcessImage != null)
						img = OnPreProcessImage (img);

					writer.AddPage(img, PdfMode.Ocr);
                    DateTime end = DateTime.Now;

                    if (OnProgressComplete != null)
                    {
                        progress = string.Concat(i, " of ", reader.PageCount);
                        OnProgressComplete(i, reader.PageCount, (end - start).TotalSeconds);
                    }

					//File.Delete(img);
                }
                writer.SaveAndClose();
                writer.Dispose();
                reader.Dispose();

                state = CompressorState.Complete;

                if (OnJobFinished != null)
                    OnJobFinished(this);
            }
            catch (Exception x)
            {
				Console.WriteLine(x.Message);
                Console.WriteLine("Image not supported in " + Path.GetFileName(inputPDF) + ". Skipping");
                writer.SaveAndClose();
                writer.Dispose();
                reader.Dispose();
                writer = null;
                reader = null;
                GC.Collect();

                if (OnExceptionOccurred != null)
                    OnExceptionOccurred(this, x);

            }
        }
    }
}
