using DataBase.WA_API;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace DataBase
{
    public class Funcoes
    {
        public static string getBetween(string strSource, string strStart, string strEnd)
        {
            int Start, End;
            if (strSource.Contains(strStart) && strSource.Contains(strEnd))
            {
                Start = strSource.IndexOf(strStart, 0) + strStart.Length;
                End = strSource.IndexOf(strEnd, Start);
                return strSource.Substring(Start, End - Start);
            }
            else
            {
                return "";
            }
        }
        public static string RemoveAccents(string text)
        {
            StringBuilder sbReturn = new StringBuilder();
            var arrayText = text.Normalize(NormalizationForm.FormD).ToCharArray();
            foreach (char letter in arrayText)
            {
                if (CharUnicodeInfo.GetUnicodeCategory(letter) != UnicodeCategory.NonSpacingMark)
                    sbReturn.Append(letter);
            }
            return sbReturn.ToString();
        }
        private static Rijndael CriarInstanciaRijndael(
            string chave, string vetorInicializacao)
        {
            if (!(chave != null &&
                  (chave.Length == 16 ||
                   chave.Length == 24 ||
                   chave.Length == 32)))
            {
                throw new Exception(
                    "A chave de criptografia deve possuir " +
                    "16, 24 ou 32 caracteres.");
            }

            if (vetorInicializacao == null ||
                vetorInicializacao.Length != 16)
            {
                throw new Exception(
                    "O vetor de inicialização deve possuir " +
                    "16 caracteres.");
            }

            Rijndael algoritmo = Rijndael.Create();
            algoritmo.Key =
                Encoding.ASCII.GetBytes(chave);
            algoritmo.IV =
                Encoding.ASCII.GetBytes(vetorInicializacao);

            return algoritmo;
        }

        public static string Encriptar(
            string chave,
            string vetorInicializacao,
            string textoNormal)
        {
            if (String.IsNullOrWhiteSpace(textoNormal))
            {
                throw new Exception(
                    "O conteúdo a ser encriptado não pode " +
                    "ser uma string vazia.");
            }
            using (Rijndael algoritmo = CriarInstanciaRijndael(
                chave, vetorInicializacao))
            {
                ICryptoTransform encryptor =
                    algoritmo.CreateEncryptor(
                        algoritmo.Key, algoritmo.IV);

                using (MemoryStream streamResultado =
                       new MemoryStream())
                {
                    using (CryptoStream csStream = new CryptoStream(
                        streamResultado, encryptor,
                        CryptoStreamMode.Write))
                    {
                        using (StreamWriter writer =
                            new StreamWriter(csStream))
                        {
                            writer.Write(textoNormal);
                        }
                    }

                    return ArrayBytesToHexString(
                        streamResultado.ToArray());
                }
            }
        }
        private static string ArrayBytesToHexString(byte[] conteudo)
        {
            string[] arrayHex = Array.ConvertAll(
                conteudo, b => b.ToString("X2"));
            return string.Concat(arrayHex);
        }
        public static string Decriptar(
            string chave,
            string vetorInicializacao,
            string textoEncriptado)
        {
            if (String.IsNullOrWhiteSpace(textoEncriptado))
            {
                throw new Exception(
                    "O conteúdo a ser decriptado não pode " +
                    "ser uma string vazia.");
            }
            if (textoEncriptado.Length % 2 != 0)
            {
                throw new Exception(
                    "O conteúdo a ser decriptado é inválido.");
            }
            using (Rijndael algoritmo = CriarInstanciaRijndael(
                chave, vetorInicializacao))
            {
                ICryptoTransform decryptor =
                    algoritmo.CreateDecryptor(
                        algoritmo.Key, algoritmo.IV);

                string textoDecriptografado = null;
                using (MemoryStream streamTextoEncriptado =
                    new MemoryStream(
                        HexStringToArrayBytes(textoEncriptado)))
                {
                    using (CryptoStream csStream = new CryptoStream(
                        streamTextoEncriptado, decryptor,
                        CryptoStreamMode.Read))
                    {
                        using (StreamReader reader =
                            new StreamReader(csStream))
                        {
                            textoDecriptografado =
                                reader.ReadToEnd();
                        }
                    }
                }

                return textoDecriptografado;
            }
        }
        private static byte[] HexStringToArrayBytes(string conteudo)
        {
            int qtdeBytesEncriptados =
                conteudo.Length / 2;
            byte[] arrayConteudoEncriptado =
                new byte[qtdeBytesEncriptados];
            for (int i = 0; i < qtdeBytesEncriptados; i++)
            {
                arrayConteudoEncriptado[i] = Convert.ToByte(
                    conteudo.Substring(i * 2, 2), 16);
            }

            return arrayConteudoEncriptado;
        }
        public static string GerarHashMd5(string input)
        {
            MD5 md5Hash = MD5.Create();
            // Converter a String para array de bytes, que é como a biblioteca trabalha.
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));
            // Cria-se um StringBuilder para recompôr a string.
            StringBuilder sBuilder = new StringBuilder();
            // Loop para formatar cada byte como uma String em hexadecimal
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }
            return sBuilder.ToString();
        }
        public static bool IsBase64(string base64String)
        {
             if (string.IsNullOrEmpty(base64String) || base64String.Length % 4 != 0
                || base64String.Contains(" ") || base64String.Contains("\t") || base64String.Contains("\r") || base64String.Contains("\n"))
                        return false;
                    try
                    {
                        Convert.FromBase64String(base64String);
                        return true;
                    }
                    catch (Exception exception)
                    {
                        // Handle the exception
                    }
             return false;
         }
        public static decimal GetCotacoes(long codigo, string data)
        {
            decimal retorno = (decimal)0;
            var cotacaoService = new CotacoesService.FachadaWSSGSService();
            retorno = cotacaoService.getValor(codigo, data);
            return retorno;
        }
        public static void NotifySome(string from, string to, string str_conn,int notify,string wfidflow,string opidcont)
        {
            string numFrom = Consultas.Consulta(str_conn, "select USNUMCEL from TUSUSUARI where USIDUSUA='"+from+"'", 1)[0];
            string numTo = Consultas.Consulta(str_conn, "select USNUMCEL from TUSUSUARI where USIDUSUA='"+to+"'", 1)[0];
            string WFBBCHAT = DataBase.Consultas.Consulta(str_conn, "SELECT WFMSGTXT FROM WFTXTNTF where WFIDTEXT="+ notify, 1)[0];
            WFBBCHAT = WFBBCHAT.Replace("{WFIDFLOW}",wfidflow);
            WFBBCHAT = WFBBCHAT.Replace("{OPIDCONT}", opidcont);
            SecretariaNaty naty = new SecretariaNaty(ConfigurationManager.AppSettings["CHAT-API_URL"], ConfigurationManager.AppSettings["CHAT-API_TOKEN"]);
            naty.SendMessage(to, "55" + numTo.Replace(" ", "").Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", ""), "*Remetente:* " + from + "\n*Alerta:* " + WFBBCHAT);
            //WaApi wa = new WaApi(ConfigurationManager.AppSettings["CHAT-API_URL"], ConfigurationManager.AppSettings["CHAT-API_TOKEN"]);
            //wa.SendWhats(numTo.Replace(" ", "").Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", ""), "*Remetente:* "+from+ "\n*Alerta:* "+WFBBCHAT);
                string sqlInsert = "INSERT INTO WFWFCHAT(USIDUSUA1,USIDUSUA2,WFBBCHAT) VALUES('@USIDUSUA1', '@USIDUSUA2', '@WFBBCHAT')";
                sqlInsert = sqlInsert.Replace("@USIDUSUA1", from);
                sqlInsert = sqlInsert.Replace("@USIDUSUA2", to);
                sqlInsert = sqlInsert.Replace("@WFBBCHAT", WFBBCHAT);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
        }
        public static void NotifyDenuncia(string from, string to, string str_conn, int notify, string ID, bool contrato)
        {
            string texto = contrato ? "Contrato " + ID : "Imóvel " + ID;
            string numFrom = Consultas.Consulta(str_conn, "select USNUMCEL from TUSUSUARI where USIDUSUA='" + from + "'", 1)[0];
            string numTo = Consultas.Consulta(str_conn, "select USNUMCEL from TUSUSUARI where USIDUSUA='" + to + "'", 1)[0];
            var result = DataBase.Consultas.Consulta(str_conn, "select DNTEXTAL,DNDNDECR from DENUNCIA where DNIDDENU=" + notify, 2);
            result[0] = result[0].Replace("{DNDNDECR}", result[1]);
            result[0] = result[0].Replace("{TEXTO}", texto);
            SecretariaNaty naty = new SecretariaNaty(ConfigurationManager.AppSettings["CHAT-API_URL"], ConfigurationManager.AppSettings["CHAT-API_TOKEN"]);
            naty.SendMessage(to, "55"+numTo.Replace(" ", "").Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", ""), "*Remetente:* " + from + "\n*Alerta:* " + texto);
            //WaApi wa = new WaApi(ConfigurationManager.AppSettings["CHAT-API_URL"], ConfigurationManager.AppSettings["CHAT-API_TOKEN"]);
            //wa.SendWhats(numTo.Replace(" ", "").Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", ""), "*Remetente:* " + from + "\n*Alerta:* " +texto);
            
                string sqlInsert = "INSERT INTO WFWFCHAT(USIDUSUA1,USIDUSUA2,WFBBCHAT) VALUES('@USIDUSUA1', '@USIDUSUA2', '@WFBBCHAT')";
                sqlInsert = sqlInsert.Replace("@USIDUSUA1", from);
                sqlInsert = sqlInsert.Replace("@USIDUSUA2", to);
                sqlInsert = sqlInsert.Replace("@WFBBCHAT", result[0]);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            
        }
        public static void SendingWhats(string str_conn,string numTo, string from, string msg)
        {
            //WaApi wa = new WaApi(ConfigurationManager.AppSettings["CHAT-API_URL"], ConfigurationManager.AppSettings["CHAT-API_TOKEN"]);
            //wa.SendWhats(numTo.Replace(" ","").Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", ""), "*Remetente:* " + from + "\n*Mensagem:* " + msg);
            SecretariaNaty naty = new SecretariaNaty(ConfigurationManager.AppSettings["CHAT-API_URL"], ConfigurationManager.AppSettings["CHAT-API_TOKEN"]);
            naty.SendMessage("", "55" + numTo.Replace(" ", "").Replace("+", "").Replace("-", "").Replace("(", "").Replace(")", ""), "*Remetente:* " + from + "\n*Mensagem:* " + msg);
        }
        /// <summary>
        /// Evaluates a dynamically built logical expression 
        /// Implement try catch when calling this function : if an exception is thrown, the logical expression is not valid
        /// </summary>
        /// <param name="logicalExpression">True AND False OR True</param>
        /// <returns></returns>
        public static bool EvaluateLogicalExpression(string logicalExpression)
        {
            System.Data.DataTable table = new System.Data.DataTable();
            table.Columns.Add("", typeof(bool));
            table.Columns[0].Expression = logicalExpression;

            System.Data.DataRow r = table.NewRow();
            table.Rows.Add(r);
            bool result = (Boolean)r[0];
            return result;
        }
        public DateTime GetFirstBusinessDay(int Year, int Month)
        {
            DateTime FirstOfMonth = default(DateTime);
            DateTime FirstBusinessDay = default(DateTime);
            FirstOfMonth = new DateTime(Year, Month, 1);
            if (FirstOfMonth.DayOfWeek == DayOfWeek.Sunday)
            {
                FirstBusinessDay = FirstOfMonth.AddDays(1);
            }
            else if (FirstOfMonth.DayOfWeek == DayOfWeek.Saturday)
            {
                FirstBusinessDay = FirstOfMonth.AddDays(2);
            }
            else
            {
                FirstBusinessDay = FirstOfMonth;
            }
            return FirstBusinessDay;
        }
    }
    public class StringToFormula
    {
        private string[] _operators = { "-", "+", "/", "*", "^" };
        private Func<double, double, double>[] _operations = {
        (a1, a2) => a1 - a2,
        (a1, a2) => a1 + a2,
        (a1, a2) => a1 / a2,
        (a1, a2) => a1 * a2,
        (a1, a2) => Math.Pow(a1, a2)
    };

        public double Eval(string expression)
        {
            List<string> tokens = getTokens(expression);
            Stack<double> operandStack = new Stack<double>();
            Stack<string> operatorStack = new Stack<string>();
            int tokenIndex = 0;

            while (tokenIndex < tokens.Count)
            {
                string token = tokens[tokenIndex];
                if (token == "(")
                {
                    string subExpr = getSubExpression(tokens, ref tokenIndex);
                    operandStack.Push(Eval(subExpr));
                    continue;
                }
                if (token == ")")
                {
                    throw new ArgumentException("Mis-matched parentheses in expression");
                }
                //If this is an operator  
                if (Array.IndexOf(_operators, token) >= 0)
                {
                    while (operatorStack.Count > 0 && Array.IndexOf(_operators, token) < Array.IndexOf(_operators, operatorStack.Peek()))
                    {
                        string op = operatorStack.Pop();
                        double arg2 = operandStack.Pop();
                        double arg1 = operandStack.Pop();
                        operandStack.Push(_operations[Array.IndexOf(_operators, op)](arg1, arg2));
                    }
                    operatorStack.Push(token);
                }
                else
                {
                    operandStack.Push(double.Parse(token));
                }
                tokenIndex += 1;
            }

            while (operatorStack.Count > 0)
            {
                string op = operatorStack.Pop();
                double arg2 = operandStack.Pop();
                double arg1 = operandStack.Pop();
                operandStack.Push(_operations[Array.IndexOf(_operators, op)](arg1, arg2));
            }
            return operandStack.Pop();
        }
        private string getSubExpression(List<string> tokens, ref int index)
        {
            StringBuilder subExpr = new StringBuilder();
            int parenlevels = 1;
            index += 1;
            while (index < tokens.Count && parenlevels > 0)
            {
                string token = tokens[index];
                if (tokens[index] == "(")
                {
                    parenlevels += 1;
                }

                if (tokens[index] == ")")
                {
                    parenlevels -= 1;
                }

                if (parenlevels > 0)
                {
                    subExpr.Append(token);
                }

                index += 1;
            }

            if ((parenlevels > 0))
            {
                throw new ArgumentException("Mis-matched parentheses in expression");
            }
            return subExpr.ToString();
        }
        private List<string> getTokens(string expression)
        {
            string operators = "()^*/+-";
            List<string> tokens = new List<string>();
            StringBuilder sb = new StringBuilder();

            foreach (char c in expression.Replace(" ", string.Empty))
            {
                if (operators.IndexOf(c) >= 0)
                {
                    if ((sb.Length > 0))
                    {
                        tokens.Add(sb.ToString());
                        sb.Length = 0;
                    }
                    tokens.Add(c.ToString());
                }
                else
                {
                    sb.Append(c);
                }
            }

            if ((sb.Length > 0))
            {
                tokens.Add(sb.ToString());
            }
            return tokens;
        }
    }
    public class WorkflowAdmin
    {
        public string str_conn { get; set; }
        public string Usuario { get; set; }
        public int ID { get; set; }
        public int TipoDenuncia { get; set; } = 0;
        public int Renova { get; set; } = 0;
        public DateTime DataExpira { get; set; }
        public string OPIDCONT { get; set; } = "NULL";
        public string REIDIMOV { get; set; } = "NULL";
        public bool Encerramento { get; set; } = false;
        public bool Iptu { get; set; } = false;
        public bool Seguro { get; set; } = false;

        public bool CriarWfw()
        {
            if(Encerramento && TipoDenuncia==0)
            {
                TipoDenuncia = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select DNIDDENU from denuncia where dnvience=1", 1)[0]);
            }
            else if (Iptu && TipoDenuncia == 0)
            {
                TipoDenuncia = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select DNIDDENU from denuncia where dnviiptu=1", 1)[0]);
            }
            else if (Seguro && TipoDenuncia == 0)
            {
                TipoDenuncia = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select DNIDDENU from denuncia where DNVISEGU=1", 1)[0]);
            }
            
            int qtdDias = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select DNDIASANT from denuncia where DNIDDENU="+TipoDenuncia, 1)[0])+1;
            string sqlInsert = "INSERT INTO DNALERTA (DNIDDENU ,REIDIMOV ,OPIDCONT ,ALDTINIC ,ALDTEXPI ,ALRENOVA,USIDUSUA ) "+
                               "VALUES(@DNIDDENU, @REIDIMOV, @OPIDCONT, convert(date, '@ALDTINIC', 103), convert(date, '@ALDTEXPI', 103), @ALRENOVA,'@USIDUSUA')";
            sqlInsert = sqlInsert.Replace("@DNIDDENU",TipoDenuncia.ToString());
            if (string.IsNullOrEmpty(REIDIMOV))
            {
                sqlInsert = sqlInsert.Replace("@REIDIMOV", "NULL");
            }
            else
            {
                sqlInsert = sqlInsert.Replace("@REIDIMOV", REIDIMOV);
            }            
            sqlInsert = sqlInsert.Replace("@USIDUSUA", Usuario);
            if (string.IsNullOrEmpty(OPIDCONT))
            {
                sqlInsert = sqlInsert.Replace("@OPIDCONT", "NULL");
            }
            else
            {
                sqlInsert = sqlInsert.Replace("@OPIDCONT", OPIDCONT);
            }
            
            sqlInsert = sqlInsert.Replace("@ALDTEXPI", DataExpira.ToString("dd/MM/yyyy"));
            sqlInsert = sqlInsert.Replace("@ALDTINIC", DataExpira.AddDays(-qtdDias).ToString("dd/MM/yyyy"));
            sqlInsert = sqlInsert.Replace("@ALRENOVA", Renova.ToString());
            string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
            if (exec == "OK")
                return true;
            else
                return false;
        }
        public bool RecusarWfw()
        {
            string sqlUpdate = "UPDATE DNALERTA SET ALSTATUS = -1 WHERE ALIDALSQ = " + ID.ToString();
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
                return true;
            else
                return false;
        }
        public bool ReativarWfw()
        {
            string sqlUpdate = "UPDATE DNALERTA SET ALSTATUS = 0 WHERE ALIDALSQ = " + ID.ToString();
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
                return true;
            else
                return false;
        }
        public bool AprovarWfw()
        {
            string sqlUpdate = "UPDATE DNALERTA SET ALSTATUS = 1 WHERE ALIDALSQ = " + ID.ToString();
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
            {
                bool renovar = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select D.ALRENOVA from DNALERTA D where ALIDALSQ="+ID, 1)[0]) == 1;
                if (renovar)
                {
                    string sqlInsert = "INSERT INTO DNALERTA (DNIDDENU,REIDIMOV,OPIDCONT,ALDTINIC,ALDTEXPI,ALRENOVA,ALSTATUS,USIDUSUA) " +
    "(SELECT DNIDDENU, REIDIMOV, OPIDCONT, dateadd(day, 365, ALDTINIC), dateadd(day, 365, ALDTEXPI), ALRENOVA, 0,USIDUSUA FROM DNALERTA where ALIDALSQ = " + ID + ")";
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                        return true;
                    else
                        return false;
                }                
                else
                    return true;
            }
            else
                return false;
        }
        public bool ExcluirWfw()
        {
            string sqlUpdate = "DELETE DNALERTA WHERE ALIDALSQ = " + ID.ToString();
            string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
            if (exec == "OK")
                return true;
            else
                return false;
        }
    }
    public class RastreioLogon
    {
        public string Modulo { get; set; }
        public string Usuario { get; set; }
        public string str_conn { get; set; }
        public void RastrearLogon()
        {
            string sqlUpdt = "UPDATE TUSUSUARI "+
                                "SET USLASTUPD = convert(datetime, '@USLASTUPD', 103) "+
                                  ", USLASTACT = '@USLASTACT' "+
                             "WHERE USIDUSUA = '@USIDUSUA'";
            sqlUpdt = sqlUpdt.Replace("@USLASTUPD",DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"));
            sqlUpdt = sqlUpdt.Replace("@USLASTACT", Modulo);
            sqlUpdt = sqlUpdt.Replace("@USIDUSUA", Usuario);
            if(CheckUsuario())
            {
                DataBase.Consultas.GravaLog = false;
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdt);
            }
        }
        private bool CheckUsuario()
        {
            return Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "SELECT COUNT(*) FROM TUSUSUARI WHERE USIDUSUA='" + Usuario + "'", 1)[0])==1;
        }

    }
}
