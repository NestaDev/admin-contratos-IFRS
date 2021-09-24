using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using System.Diagnostics;
using Clock.Pdf;
using Clock.Util;

namespace Clock.ImageProcessing
{
    public class ImageMagick : OsUtil
    {
        const string mogrify = "mogrify";
		const string convert = "convert";

        public static string ConvertToGrayScale(string image, OcrMode mode)
        {
            string args = string.Concat(" -auto-level -colorspace gray -type grayscale -density 300 -gaussian-blur 0.05 ", image);

            RunCommand(mogrify, args);

            return image;
        }

		
		/// <summary>
		/// Convert the specified input image to another format.
		/// </summary>
		/// <param name='input'>
		/// Input.
		/// </param>
		/// <returns>The path to the newly converted image</returns>
		public static string Convert (Image input, PdfImageType type)
		{
            string imageFile = TempData.Instance.CreateTempFile(".bmp");
			input.Save(imageFile, ImageFormat.Bmp);
			string output = Convert(imageFile, type);
            TempData.Instance.Cleanup(imageFile);
			return output;
		}

		/// <summary>
		/// Convert the specified input image to another format.
		/// </summary>
		/// <param name='input'>
		/// Input.
		/// </param>
		/// <returns>The path to the newly converted image</returns>
		public static string Convert (string input, PdfImageType type)
		{

			string output = input.Replace(Path.GetExtension(input), "." + type.ToString().ToLower());
			string quality = "";
			if(type == PdfImageType.Jpg || type == PdfImageType.Png)
				quality = "-quality 80 ";
			//-colorspace RGB -auto-level 
			string args = string.Concat(" -colorspace RGB -auto-level -strip -gaussian-blur 0.05 -density 600 ", quality, " ", input, " ", output, "\"");

			if(Path.GetExtension(input).ToLower() == Path.GetExtension(output).ToLower())
				RunCommand(mogrify, args);
			else
				RunCommand(convert, args);

			return output;
		}
        
        public static string Deskew(string image, OcrMode mode)
        {
            string args = string.Concat(" -background white -deskew 40% ", image);

            RunCommand(mogrify, args);

            return image;
        }

        public static string Despeckle(string image, OcrMode mode)
        {
            string args = string.Concat(" -despeckle ", image);

            RunCommand(mogrify, args);

            return image;
        }

        private static void RunCommand(string command, string args)
        {

			if (IsLinux == false) {
				command = "cmd.exe";
				args = "/C " + mogrify + " " + args;
			}
            Process p = new Process();
			ProcessStartInfo s = new ProcessStartInfo(command, args);
            s.RedirectStandardOutput = false;
            s.RedirectStandardError = false;
            s.CreateNoWindow = true;
            s.UseShellExecute = false;
            p.StartInfo = s;

            p.Start();
            p.WaitForExit();
        }
    }
}
