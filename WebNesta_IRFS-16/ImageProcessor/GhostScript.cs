using System;
using System.Drawing;
using System.Diagnostics;
using System.IO;
using Clock.Util;

namespace Clock.ImageProcessing
{
	public class GhostScript : OsUtil
	{
        string GSPath = string.Empty;
		public GhostScript()
		{
		}

		private string OS
		{
			get{
                if (IsLinux)
                    return "gs";
                else
                {
                    if (Environment.Is64BitOperatingSystem == false)
                        return "gswin32c";
                    else
                        return "gswin64c";
                }
			}
		}

		void RunCommand (string command)
		{
			Process p = new Process ();
            string os = OS;
            if (IsLinux == false)
            {
                string ProgramW6432 = Environment.GetEnvironmentVariable("ProgramW6432");
                string pgFolder = Path.Combine(ProgramW6432 == null ? string.Empty : ProgramW6432, "gs");
				string pg86Folder = Path.Combine(Environment.GetEnvironmentVariable("ProgramFiles"), "gs");
                
                if (Directory.Exists(pg86Folder))
                {
                    string[] gsfiles = Directory.GetFiles(pg86Folder, "gswin32c.exe", SearchOption.AllDirectories);

                    foreach (string gs in gsfiles)
                        os = gs;
                }

                if (Directory.Exists(pgFolder))
                {
                    string[] gsfiles = Directory.GetFiles(pgFolder, "gswin64c.exe", SearchOption.AllDirectories);

                    foreach (string gs in gsfiles)
                        os = gs;
                }
                //temp added
                //os = @"C:\Program Files\gs\gs9.52\bin\gswin64c.exe";
            }
			ProcessStartInfo s = new ProcessStartInfo (os, command);
			s.RedirectStandardOutput = true;
			s.RedirectStandardError = true;
			s.CreateNoWindow = true;
			s.UseShellExecute = false;
			p.StartInfo = s;
			p.Start ();
			p.WaitForExit ();
			GC.Collect ();

		}

        private string getOutPutFileName(string extWithDot)
        {
            if (IsLinux)
                return TempData.Instance.CreateTempFile(extWithDot);

            return "\"" + TempData.Instance.CreateTempFile(extWithDot) + "\"";

        }

        //gs -dSAFER -sDEVICE=png16m -dINTERPOLATE -dNumRenderingThreads=8
        //-dFirstPage=1 -dLastPage=1 -r300 -o ./output\_image.png -c 30000000 setvmthreshold
//setvmthreshold -f my\_pdf.pdf

        public string ConvertPDFToPNG(string PDF, int StartPageNum, int EndPageNum)
        {
            string OutPut = getOutPutFileName(".png");
            PDF = "\"" + PDF + "\"";
            string command = String.Concat("-dNOPAUSE -r300 -q -dSAFER -sDEVICE=png16m -dINTERPOLATE -dNumRenderingThreads=8  -dBATCH -dFirstPage=", StartPageNum.ToString(), " -dLastPage=", EndPageNum.ToString(), " -sOutputFile=" + OutPut + " " + PDF + " 30000000 setvmthreshold -c quit");
            RunCommand(command);

            return new FileInfo(OutPut.Replace('"', ' ').Trim()).FullName;
        }

        public string ConvertPDFToBitmap(string PDF, int StartPageNum, int EndPageNum)
		{
            string OutPut = getOutPutFileName(".bmp");
			PDF = "\"" + PDF + "\"";
            string command = String.Concat("-dNOPAUSE -q -r300 -sDEVICE=bmp16m -dBATCH -dFirstPage=", StartPageNum.ToString(), " -dLastPage=", EndPageNum.ToString(), " -sOutputFile=" + OutPut + " " + PDF + " -c quit");
			RunCommand(command);

            return new FileInfo(OutPut.Replace('"', ' ').Trim()).FullName;
		}

           public string ConvertPDFToJPEG(string PDF, int StartPageNum, int EndPageNum)
		{
            string OutPut = getOutPutFileName(".jpeg");
			PDF = "\"" + PDF + "\"";
            string command = String.Concat("-dNOPAUSE -q -r300 -sDEVICE=jpeg -dNumRenderingThreads=8 -dBATCH -dFirstPage=", StartPageNum.ToString(), " -dLastPage=", EndPageNum.ToString(), " -sOutputFile=" + OutPut + " " + PDF + " -c quit");
			RunCommand(command);

            return new FileInfo(OutPut.Replace('"', ' ').Trim()).FullName;
		}
        
		public const string tiff12nc = "tiff12nc";
		public const string tiffg4 = "tiffg4";
        /// <summary>
        /// Converts entire PDF to a multipage-tiff
        /// </summary>
        /// <param name="PDF"></param>
        /// <returns></returns>
		public string ConvertPDFToMultiPageTiff(string PDF, string type)
		{
            string OutPut = TempData.Instance.CreateTempFile(".tif");

			PDF = "\"" + PDF + "\"";
			string command = "-dNOPAUSE -q -r300 -sDEVICE="+ type.ToString() + " -dBATCH -sOutputFile=" + OutPut + " " + PDF + " -c quit";
			RunCommand(command);

            return OutPut ;
		}
	}
}

