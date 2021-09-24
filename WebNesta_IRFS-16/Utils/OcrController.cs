using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using Clock.Hocr;
using Clock.Util;
using Clock.ImageProcessing;

namespace Clock.Util
{
    public enum OcrMode { Tesseract, TesseractDigitsOnly, Cuneiform, None }

    public class OcrController
    {
        static void RunCommand(string processName, string commandArgs)
        {
            Process p = new Process();

            string test = string.Concat(processName, " ", commandArgs);
            ProcessStartInfo s = new ProcessStartInfo(processName, commandArgs);
            //s.RedirectStandardOutput = true;
            //s.RedirectStandardError = true;
            s.WindowStyle = ProcessWindowStyle.Hidden;
            s.CreateNoWindow = true;
            s.UseShellExecute = true;
            p.StartInfo = s;
            //s.WorkingDirectory = @"C:\Program Files\Tesseract-OCR\";
            //s.WorkingDirectory = @"c:\Program Files (x86)\Tesseract-OCR\";
            s.WorkingDirectory = System.Configuration.ConfigurationManager.AppSettings["pathTesseract"];
            p.Start();
            p.WaitForExit();
            GC.Collect();
        }

        public static string CreateHOCR(OcrMode Mode, string Language, string imagePath)
        {
            string outputFile = imagePath.Replace(Path.GetExtension(imagePath), ".hocr");
            string inputFile = string.Concat('"', imagePath, '"');
            string commandArgs = string.Empty; // Mode == OcrMode.Tesseract ? " -l " + Language + " hocr" : " -l " + Language + " -f hocr -o ";
            string processName = Mode == OcrMode.Tesseract || Mode == OcrMode.TesseractDigitsOnly ? "tesseract" : Mode == OcrMode.Cuneiform ? "cuneiform" : "ocropus-hocr";

            if (Mode == OcrMode.Cuneiform)
            {
                string oArg = '"' + outputFile + ".html" + '"';
                commandArgs = String.Concat(" -l " + Language + " -f hocr -o ", oArg, " ", inputFile);
                RunCommand(processName, commandArgs);
            }
            if (Mode == OcrMode.Tesseract)
            {
                string oArg = '"' + outputFile + '"';
                commandArgs = String.Concat(inputFile, " ", oArg, " -l " + Language + " -psm 1 hocr ");
                RunCommand(processName, commandArgs);
            }

            if (Mode == OcrMode.TesseractDigitsOnly)
            {
                string oArg = '"' + outputFile + '"';
                commandArgs = String.Concat(inputFile, " ", oArg, " nobatch digits -l " + Language + " -psm 1 hocr ");
                RunCommand(processName, commandArgs);
            }

            //            if(Mode == OcrMode.OcrOpus)
            //            {
            //                string f = imagePath;

            ////				#ocropus-nlbin tests/testpage.png -o temp
            ////ocropus-sauvola tests/testpage.png -o temp
            ////ocropus-gpageseg 'temp/????.bin.png'

            ////ocropus-rpred 'temp/????/??????.bin.png'
            ////ocropus-hocr 'temp/????.bin.png' -o temp.html
            ////ocropus-visualize-results; temp
            ////ocropus-gtedit html temp/????/??????.bin.png -o temp-correction.html
            ////				
            //                f = f.Replace("\"", string.Empty).Trim();
            //                RunCommand("ocropus-nlbin", String.Concat("'", f, "' -o ", TempData.Instance.CurrentJobFolder + "/"));
            //                RunCommand("ocropus-sauvola",  String.Concat("'", f, "' -o ", TempData.Instance.CurrentJobFolder + "/"));
            //                RunCommand("ocropus-gpageseg", "'" + TempData.Instance.CurrentJobFolder + "/????.bin.png" + "'");
            //                RunCommand("ocropus-rpred", "'" + TempData.Instance.CurrentJobFolder + "/????/??????.bin.png" + "'");
            //                RunCommand("ocropus-hocr", String.Concat("'", TempData.Instance.CurrentJobFolder, "/????.bin.png' -o '", outputFile + ".html'"));
            //                RunCommand("ocropus-visualize-results", TempData.Instance.CurrentJobFolder + "/");
            //            }

            //  Process.Start(outputFile + ".html");
            return outputFile + ".html";
        }

        public static string GetText(OcrMode Mode, string Language, string imagePath)
        {
            string outputFile = imagePath.Replace(Path.GetExtension(imagePath), ".txt");
            string inputFile = string.Concat('"', imagePath, '"');
            string commandArgs = Mode == OcrMode.Tesseract || Mode == OcrMode.TesseractDigitsOnly ? " -l " + Language + " hocr" : " -l " + Language + " -f hocr -o ";
            string processName = Mode == OcrMode.Tesseract || Mode == OcrMode.TesseractDigitsOnly ? "tesseract" : "cuneiform";

            if (Mode == OcrMode.Cuneiform)
            {
                string oArg = '"' + outputFile + '"';
                commandArgs = String.Concat(" -l " + Language + " -f text -o ", oArg, " ", inputFile);
            }

            if (Mode == OcrMode.Tesseract)
            {
                string oArg = '"' + outputFile + '"';
                commandArgs = String.Concat(inputFile, " ", oArg, " -l " + Language + " -psm 1 ");
            }

            if (Mode == OcrMode.TesseractDigitsOnly)
            {
                string oArg = '"' + outputFile + '"';
                commandArgs = String.Concat(inputFile, " ", oArg, " nobatch digits -l " + Language + " -psm 1 ");
            }

            Process p = new Process();
            ProcessStartInfo s = new ProcessStartInfo(processName, commandArgs);
            s.RedirectStandardOutput = true;
            s.RedirectStandardError = true;
            s.CreateNoWindow = true;
            s.UseShellExecute = false;
            p.StartInfo = s;

            p.Start();
            p.WaitForExit();
            GC.Collect();

            string text = File.ReadAllText(outputFile + ".txt");

            File.Delete(outputFile + ".txt");
            return text;
        }



        public static hDocument CreateHOCR(OcrMode mode, string Language, Image image)
        {
            hDocument doc = new hDocument();

            AddToDocument(mode, Language, image, ref doc);
            foreach (hPage page in doc.Pages)
            {
                doc.Text += page.Text + Environment.NewLine;
            }
            doc.CleanText();
            return doc;
        }

        internal static void AddToDocument(OcrMode Mode, string Language, Image image, ref hDocument doc)
        {
            string imageFile = "";

            Bitmap b = ImageProcessor.GetAsBitmap(image, (int)Math.Ceiling(image.HorizontalResolution));

            if (Mode == OcrMode.Tesseract)
            {
                imageFile = TempData.Instance.CreateTempFile(".tif");
                b.Save(imageFile, ImageFormat.Tiff);
            }

            if (Mode == OcrMode.Cuneiform)
            {
                imageFile = TempData.Instance.CreateTempFile(".bmp");
                b.Save(imageFile, ImageFormat.Bmp);
            }

            string result = CreateHOCR(Mode, Language, imageFile);
            doc.AddFile(result);

            TempData.Instance.Cleanup(imageFile);
            TempData.Instance.Cleanup(result);
        }
    }
}
