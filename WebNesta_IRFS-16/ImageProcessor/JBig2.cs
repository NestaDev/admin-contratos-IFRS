using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using Clock.Util;

namespace Clock.ImageProcessing
{
    public class JBig2 : OsUtil
    {

        private string jbig2Path;

        public string JBig2Path
        {
            get
            {
				if(IsLinux == false)
				{
                string applicationDirectory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);

                return '"' +  Path.Combine(applicationDirectory, "jbig2.exe") + '"';
				}
				else
				{
					return "jbig2";
				}
               
            }
        }

        public JBig2()
        {
            jbig2Path = JBig2Path;
           
        }
        public JBig2(string jbig2EXEPath)
        {
            jbig2Path = jbig2EXEPath;
  
        }

        public iTextSharp.text.Image ProcessImage(string imagePath)
        {
            Image img = Image.FromFile(imagePath);
            //Bitmap bmp = new Bitmap(img.Width, img.Height);
            //Graphics gImage = Graphics.FromImage(bmp);
            //gImage.DrawImage(img, 0, 0, img.Width, img.Height);

            //ImageFormat saveToFormat = ImageFormat.Jpeg;

            string newImage = imagePath;// TempData.Instance.CreateTempFile("." + saveToFormat.ToString().ToLower());

            //bmp.SetResolution(300, 300);
            //bmp.Save(newImage, saveToFormat);

            string symFilePath = newImage.Replace(Path.GetExtension(newImage), ".sym");
            string symIndexFilePath = newImage.Replace(Path.GetExtension(newImage), ".0000");

            CompressJBig2(newImage);

            iTextSharp.text.Image i = iTextSharp.text.ImgJBIG2.GetInstance(img.Width, img.Height, File.ReadAllBytes(symIndexFilePath), File.ReadAllBytes(symFilePath));
            Cleanup(symFilePath);
            Cleanup(symIndexFilePath);
            Cleanup(newImage);
     
            GC.Collect();

            return i;
        }

        public iTextSharp.text.Image ProcessImage(Bitmap b)
        {

            var img = ImageProcessor.GetAsBitmap(b, (int)b.HorizontalResolution);
            var s = TempData.Instance.CreateTempFile(".bmp");
            img.Save(s);

            return ProcessImage(s);
        }

        private void CompressJBig2(string imagePath)
        {
            Process p = new Process();
            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = JBig2Path;
            info.UseShellExecute = false;
            info.RedirectStandardError = true;
            info.RedirectStandardOutput = true;
            info.WindowStyle = ProcessWindowStyle.Hidden;
            info.CreateNoWindow = true;
			//-t .75
            info.Arguments = "-d -p -s -S -b " + '"' + imagePath.Replace(Path.GetExtension(imagePath), string.Empty) + '"' + " " + '"' + imagePath + '"';
            p.StartInfo = info;
            try
            {
                p.Start();
                p.WaitForExit();
            }
            catch (Exception x)
            {
                Debug.WriteLine(x.Message);
                throw x;
            }

        }

        private void Cleanup(string f)
        {
            if (File.Exists(f))
                try
                {
                    File.Delete(f);
                }
                catch (Exception x) { }
        }

    }
}
