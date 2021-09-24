using System;
using System.IO;
using System.Reflection;
using System.Text;

namespace WebNesta_IRFS_16
{
    public class RegistraLog
    {
        private static string caminhoExe = string.Empty;
        private static bool Log(Exception strMensagem, string strNomeArquivo )
        {
            try
            {
                caminhoExe = System.Configuration.ConfigurationManager.AppSettings["DirLogs"];
                string caminhoArquivo = Path.Combine(caminhoExe, strNomeArquivo);
                if (!File.Exists(caminhoArquivo))
                {
                    FileStream arquivo = File.Create(caminhoArquivo);
                    arquivo.Close();
                }
                using (StreamWriter w = File.AppendText(caminhoArquivo))
                {
                    //AppendLog(strMensagem, w);
                    w.WriteLine(String.Format($"{"Log criado em "} : {DateTime.Now}"));
                    w.WriteLine(String.Format("Error: "));
                    w.WriteLine(String.Format(strMensagem.Message));
                    w.WriteLine(String.Format("Source: "));
                    w.WriteLine(String.Format(strMensagem.Source));
                    w.WriteLine(String.Format("StackTrace : "));
                    w.WriteLine(String.Format(strMensagem.StackTrace));
                    w.WriteLine(String.Format("-----------------------------------------------------------------"));
                }
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        private static void AppendLog(string logMensagem, TextWriter txtWriter)
        {
            try
            {
                txtWriter.Write("\r\nLog Entrada : ");
                txtWriter.WriteLine($"{DateTime.Now.ToLongTimeString()} {DateTime.Now.ToLongDateString()}");
                txtWriter.WriteLine("  :");
                txtWriter.WriteLine($"  :{logMensagem}");
                txtWriter.WriteLine("------------------------------------");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SaveLog(Exception lastError)
        {

            string Arqlog = DateTime.Now.ToString("ddMMyyyy") + ".log";
            Log(lastError, Arqlog);
            //Log(String.Format($"{"Log criado em "} : {DateTime.Now}"), Arqlog);
            //Log(String.Format("Error: "), Arqlog);
            //Log(String.Format(lastError.Message), Arqlog);
            //Log(String.Format("Source: "), Arqlog);
            //Log(String.Format(lastError.Source), Arqlog);
        }

    }
}