using System;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataBase
{
    public class Logger
    {
        public string str_conn { get; set; }
        public string Usuario { get; set; }
        public string Tela { get; set; }
        public string Acao { get; set; }
        public string Resumo { get; set; }
        public string Alteracao { get; set; }
        public void GravarLog()
        {
            if (Tela.ToUpper().Contains("USERPROFILE"))
            {
                if (Alteracao.ToUpper().Contains("USCDSEUS"))
                {
                    Alteracao = "Alterações relacionadas à dados pessoais do usuário.";
                }
            }
            string sql = "INSERT INTO LOGUSSYS (LOGTLSYS ,LOGTXSYS ,USIDUSUA,LOGACSYS,LOGRESUM) VALUES ('@LOGTLSYS' ,'@LOGTXSYS' ,'@USIDUSUA','@LOGACSYS','@LOGRESUM')";
            sql = sql.Replace("@LOGTLSYS",Tela);
            sql = sql.Replace("@LOGTXSYS",Alteracao.Replace("'","").Replace("\"",""));
            sql = sql.Replace("@USIDUSUA",Usuario);
            sql = sql.Replace("@LOGACSYS", Acao);
            sql = sql.Replace("@LOGRESUM", Resumo);
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(sql, conn);
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
