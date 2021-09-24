using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace DataBase
{
    public class Consultas
    {
        public static string Usuario { get; set; }
        public static string Tela { get; set; }
        public static string Acao { get; set; }
        public static string Resumo { get; set; }
        public static string Alteracao { get; set; }
        public static bool GravaLog { get; set; } = true;

        public static int CredencialValida(String str_conn, String user, String pass, String sgbd)
        {
            int retorno = 0;
            string sql;
            OleDbConnection conn;
            OleDbCommand cmd;
            OleDbDataReader dr;
            switch (sgbd)
            {
                case "sql":
                    sql = "SELECT [dbo].[nesta_fn_Credencial_Valida]('" + user + "' ,'" + pass + "')";
                    conn = new OleDbConnection(str_conn);
                    cmd = new OleDbCommand(sql, conn);
                    try
                    {
                        conn.Open();
                        dr = cmd.ExecuteReader();
                        if (dr.HasRows)
                        {
                            dr.Read();
                            if (dr[0].ToString() == "1")
                            {
                                retorno = 1;
                            }
                            else if (dr[0].ToString() == "0")
                            {

                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        
                    }
                    break;
                case "oracle":
                    sql = "select nesta_fn_credencial_valida('"+user+"','"+pass+"') from dual";
                    conn = new OleDbConnection(str_conn);
                    cmd = new OleDbCommand(sql, conn);
                    try
                    {
                        conn.Open();
                        dr = cmd.ExecuteReader();
                        if (dr.HasRows)
                        {
                            dr.Read();
                            if (dr[0].ToString() == "1")
                            {
                                retorno = 1;
                            }
                            else if (dr[0].ToString() == "0")
                            {

                            }
                        }
                    }
                    catch (Exception ex)
                    {

                    }
                    break;
            }
            return retorno;
        }
        public static int ValidaUsuario(String str_conn,String user)
        {
            int retorno = 0;
            OleDbConnection conn = new OleDbConnection(str_conn);
            try
            {
                conn.Open();
                OleDbCommand cmd = new OleDbCommand("SELECT USFLFLAG,MAX(UTIDUTSE) FROM UTUTISEN WHERE UPPER(USIDUSUA) = UPPER('"+user+"') GROUP BY USFLFLAG",conn);
                OleDbDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    dr.Read();
                    if (dr[0].ToString() == "1")
                    {
                        retorno = 1;
                    }
                }                
            }
            catch
            {

            }
            finally
            {
                conn.Close();
            }
            return retorno;
        }
        public static string CarregaCodInterno(String p_ngcdtinu, double p_tvidestr, String str_conn)
        {
            string retorno = null;
            string storedProc = "FUNC_NUMERADOR";
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                OleDbParameter outValue = new OleDbParameter("@return_val", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                conn.Open();
                OleDbCommand cmd = new OleDbCommand();
                cmd.Connection = conn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = storedProc;
                cmd.Parameters.AddWithValue("@p_ngcdtinu", p_ngcdtinu);
                cmd.Parameters.AddWithValue("@p_tvidestr", p_tvidestr);
                cmd.Parameters.Add(outValue);
                cmd.ExecuteScalar();
                retorno = outValue.Value.ToString();
                conn.Close();
            }
            return retorno;
        }
        public static int SeqPKTabelas(String str_conn, String queryMax)
        {
            int seq = 0;
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(queryMax, conn);
            try
            {
                conn.Open();
                OleDbDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    dr.Read();
                    seq = Convert.ToInt32(dr[0].ToString()) + 1;
                }
            }
            catch
            {

            }
            finally
            {
                conn.Close();
            }
            return seq;
        }
        public static string UpdtFrom(String str_conn, String queryUpdate)
        {
            Logger log = new Logger();
            log.Usuario = Usuario;
            log.Tela = Tela;
            if (queryUpdate.IndexOf("QUERYPVT") > 0)
                log.Alteracao = queryUpdate.Replace("<", "[").Replace(">", "]");
            else 
                log.Alteracao = queryUpdate;
            if (log.Tela == "Fornecedores" && GravaLog)
            {
                string AlteraNovo = log.Alteracao;
                AlteraNovo = AlteraNovo.Substring(AlteraNovo.IndexOf("update FOFORNEC set"));
                var array = AlteraNovo.Split(new string[] { "where" }, StringSplitOptions.None)[0].Split(',');
                for (int i = 0; i < array.Length; i++)
                {
                    log.Alteracao = log.Alteracao.Replace(array[i].Split('=')[1], "XXXXX");
                }
            }
            if(Tela == "Setup" && !string.IsNullOrEmpty(Alteracao))
            {
                log.Alteracao = Alteracao;
            }
            log.str_conn = str_conn;
            log.Acao = "Alteração";
            log.Resumo = log.Acao + " realizada no módulo: " + log.Tela;
            string result = string.Empty;
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(queryUpdate, conn);
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                result = "OK";
                if (GravaLog)
                    log.GravarLog();
            }
            catch(OleDbException ex)
            {
                result = ex.Message.ToString();
                throw (ex);
            }
            finally
            {
                conn.Close();
            }
            return result;
        }
        public static string DeleteFrom(String str_conn, String queryDelete)
        {
            Logger log = new Logger();
            log.Usuario = Usuario;
            log.Tela = Tela;
            if (queryDelete.IndexOf("QUERYPVT") > 0)
                log.Alteracao = queryDelete.Replace("<", "[").Replace(">", "]");
            else
                log.Alteracao = queryDelete;
            log.str_conn = str_conn;
            log.Acao = "Exclusão";
            log.Resumo = log.Acao + " realizada no módulo: " + log.Tela;
            string result = string.Empty;
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(queryDelete, conn);
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                result = "OK";
                if(GravaLog)
                    log.GravarLog();
            }
            catch (OleDbException ex)
            {
                result = ex.Message.ToString();
                throw (ex);
            }
            finally
            {
                conn.Close();
            }
            return result;
        }
        public static string InsertInto(String str_conn, String queryInsert)
        {
            Logger log = new Logger();
            log.Usuario = Usuario;
            log.Tela = Tela;
            if (queryInsert.IndexOf("QUERYPVT") > 0)
                log.Alteracao = queryInsert.Replace("<", "[").Replace(">", "]");
            else
                log.Alteracao = queryInsert;
            if (log.Tela == "Fornecedores")
            {
                if (log.Alteracao.IndexOf("insert into FOFORNEC") < 0)
                {
                    string AlteraNovo = log.Alteracao;
                    AlteraNovo = AlteraNovo.Substring(AlteraNovo.IndexOf("update FOFORNEC set"));
                    var array = AlteraNovo.Split(new string[] { "where" }, StringSplitOptions.None)[0].Split(',');
                    for (int i = 0; i < array.Length; i++)
                    {
                        log.Alteracao = log.Alteracao.Replace(array[i].Split('=')[1], "XXXXX");
                    }
                }
            }
            log.str_conn = str_conn;
            log.Acao = "Inclusão";
            log.Resumo = log.Acao + " realizada no módulo: " + log.Tela;
            string result = string.Empty;
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(queryInsert, conn);
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                result = "OK";
                if(GravaLog)
                    log.GravarLog();
            }
            catch(OleDbException ex)
            {
                result = ex.Message.ToString();
                throw (ex);
            }
            finally
            {
                conn.Close();
            }
            return result;
        }
        public static void UpdateFrom(String str_conn, String queryUpdate)
        {
            Logger log = new Logger();
            log.Usuario = Usuario;
            log.Tela = Tela;
            if(queryUpdate.IndexOf("QUERYPVT")>0)
                log.Alteracao = queryUpdate.Replace("<", "[").Replace(">", "]");
            else
                log.Alteracao = queryUpdate;
            if(log.Tela== "Fornecedores")
            {
                string AlteraNovo = log.Alteracao;
                AlteraNovo = AlteraNovo.Substring(AlteraNovo.IndexOf("update FOFORNEC set"));
                var array = AlteraNovo.Split(new string[] { "where" }, StringSplitOptions.None)[0].Split(',');
                for(int i=0;i<array.Length;i++)
                {
                    log.Alteracao = log.Alteracao.Replace(array[i].Split('=')[1], "XXXXX");
                }
            }
            log.str_conn = str_conn;
            log.Acao = "Alteração";
            log.Resumo = log.Acao + " realizada no módulo: " + log.Tela;
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(queryUpdate, conn);
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                if(GravaLog)
                    log.GravarLog();
            }
            catch (OleDbException ex)
            {
                throw (ex);
            }
            finally
            {
                conn.Close();
            }
        }
        public static DataTable Consulta(String str_conn, String query)
        {
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(query, conn);
            OleDbDataAdapter da = new OleDbDataAdapter(cmd);
            DataTable resumo = new DataTable();
            try
            {
                conn.Open();
                cmd.CommandType = CommandType.Text;
                da.Fill(resumo);
            }
            catch (Exception ex)
            {
                resumo = null;
                throw (ex);
            }
            finally
            {
                conn.Close();
                OleDbConnection.ReleaseObjectPool();
            }
            return resumo;
        }
        public static string[] Consulta(String str_conn, String query, int qnt)
        {

            string[] resultados = new string[qnt];
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(query, conn);
            OleDbDataReader dr = null;
            try
            {
                conn.Open();
                dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    for (int i = 0; i < qnt; i++)
                    {
                        resultados[i] = dr[i].ToString();
                    }
                }
            }
            catch (OleDbException ex)
            {
                resultados[0] = ex.Message.ToString();
                throw (ex);
            }
            finally
            {
                conn.Close();
                OleDbConnection.ReleaseObjectPool();
            }
            return resultados;
        }
        public static OleDbDataReader ConsultaDR(String str_conn, String query)
        {
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(query, conn);
            OleDbDataReader dr = null;
            try
            {
                conn.Open();
                dr = cmd.ExecuteReader();
                dr.Read();
            }
            catch (Exception ex)
            {
                
            }
            finally
            {
                conn.Close();
                OleDbConnection.ReleaseObjectPool();
            }
            return dr;
        }
        public static string BasesInsert(String str_conn, String query, String lang)
        {
            string codigoAspX = null;
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(query, conn);
            try
            {
                conn.Open();
                OleDbDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    codigoAspX = "<table style='width: 100%'>";
                    int i = 0;
                    while (dr.Read())
                    {
                        if (i == 0)
                        {
                            codigoAspX += "<tr style='width: 100%'>";
                        }
                        else if ((i % 4) == 0)
                        {
                            codigoAspX += "</tr><tr style='width: 100%'>";
                        }
                        if (dr["CJTPIDTP"].ToString() == "3") //Tipo Data
                        {
                            codigoAspX += "<td style='width: 25% '><asp:Label ID='lbl" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "'  runat='server' Text='" + dr["CJDSDECR"].ToString() + "' CssClass='form-control-sm'></asp:Label>";
                            codigoAspX += "<div class='input-group mb-3'>";
                            codigoAspX += "<asp:TextBox ID='dt" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "' CssClass='border-1 form-control-sm' runat='server' TextMode='Date' Text=''></asp:TextBox>";
                            codigoAspX += "</div></td>";
                        }
                        else if (dr["CJTPIDTP"].ToString() == "12") //Tipo SQL
                        {
                            codigoAspX += "<td style='width: 25% '><asp:Label ID='lbl" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "'  runat='server' Text='" + dr["CJDSDECR"].ToString() + "' CssClass='form-control-sm'></asp:Label>";
                            codigoAspX += "<div class='input-group mb-3'>";
                            codigoAspX += "<asp:DropDownList ID='drop" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "' CssClass='border-1 form-control-sm' runat='server'>";
                            codigoAspX += RetornoDropDown(str_conn, dr["COMBO"].ToString().Replace("FROM DUAL", ""), lang);
                            codigoAspX += "</asp:DropDownList>";
                            codigoAspX += "</div></td>";
                        }
                        //else if (dr["CJTPIDTP"].ToString() == "4") //Tipo De Até
                        //{
                        //    codigoAspX += "<td style='width: 25% '><asp:Label ID='lbl" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "'  runat='server' Text='" + dr["CJDSDECR"].ToString() + "' CssClass='form-control-sm'></asp:Label>";
                        //    codigoAspX += "<div class='input-group mb-3'>";
                        //    codigoAspX += "<asp:DropDownList ID='id" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "' CssClass='badge-secondary border-0 form-control-sm' runat='server' AutoPostBack='True' OnCommand='FuncaoDeAte'>";
                        //    codigoAspX += "<asp:ListItem Value='0'>  </asp:ListItem><asp:ListItem Value='1'> 1 Item</asp:ListItem><asp:ListItem Value='2'> 2 Itens</asp:ListItem><asp:ListItem Value='3'> 3 Itens</asp:ListItem>";
                        //    codigoAspX += "</asp:DropDownList>";
                        //    codigoAspX += "</div></td>";
                        //}
                        else
                        {
                            codigoAspX += "<td style='width: 25% '><asp:Label ID='lbl" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "'  runat='server' Text='" + dr["CJDSDECR"].ToString() + "' CssClass='form-control-sm'></asp:Label>";
                            codigoAspX += "<div class='input-group mb-3'>";
                            codigoAspX += "<asp:TextBox ID='txt" + dr["CJIDCODI"].ToString() + "_" + i.ToString() + "' CssClass='badge-secondary border-0 form-control-sm' runat='server' Text=''></asp:TextBox>";
                            codigoAspX += "</div></td>";
                        }
                        i++;
                    }
                    codigoAspX += "</tr></table>";
                }
            }
            catch (Exception ex)
            {

            }
            finally
            {

                conn.Close();
                OleDbConnection.ReleaseObjectPool();
            }
            return codigoAspX;
        }
        public static string RetornoDropDown(String str_conn, String query, String lang)
        {
            string retorno = null;
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(query, conn);
            try
            {
                conn.Open();
                OleDbDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        retorno += "<asp:ListItem Value='" + dr[0].ToString() + "'>" + dr[0].ToString() + "</asp:ListItem>";
                    }
                }
            }
            catch (Exception ex)
            {
                retorno = null;
            }
            finally
            {
                conn.Close();
                OleDbConnection.ReleaseObjectPool();
            }
            return retorno;
        }
        public static string InsertContrato(String str_conn, String query)
        {
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(query, conn);
            string result = null;
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                result = "Sucesso";
            }
            catch (Exception ex)
            {
                result = ex.Message.ToString();
            }
            finally
            {
                conn.Close();
                OleDbConnection.ReleaseObjectPool();
            }
            return result;
        }
        public static string CallProc1(String str_conn,String proc, String opidcont, String sgdb)
        {
            string retorno = string.Empty;
            string storedProc = proc;
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                try
                {
                    OleDbParameter outValue = new OleDbParameter("@p_mensagem", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                    conn.Open();
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = storedProc;
                    cmd.Parameters.AddWithValue("@p_opidcont", opidcont);
                    cmd.Parameters.Add(outValue);
                    cmd.ExecuteScalar();
                    retorno = outValue.Value.ToString();
                }
                catch (Exception ex)
                {
                    retorno = ex.Message.ToString();
                }
                finally
                {
                    conn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }

            }
            return retorno;
        }
        public static int ValidaRescisao(String str_conn,DateTime dataRescisao,String opidcont, CultureInfo culture)
        {
            DateTime dt = new DateTime(dataRescisao.Year,dataRescisao.Month,1);
            dt = dt.AddDays(-1);
            int fechMesCont = Convert.ToInt32(Consulta(str_conn, "SELECT count(*) FROM LBLCTCTB where opidcont="+opidcont+ " and LBDTEXER = convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", dt) + "',103) and LBFLFECH='S'", 1)[0]);
            int fechdiaCont = Convert.ToInt32(Consulta(str_conn, "SELECT count(*) FROM SBSLDOEX T1 WHERE T1.OPIDCONT = "+opidcont+ " AND T1.SBDTSALD >= convert(datetime,'"+string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", dataRescisao)+"',103) AND T1.SBFLFECH = 'S'", 1)[0]);
            DateTime data = new DateTime(2020, 3, 31);
            if (diaUtil(dataRescisao, str_conn))
            {
                if(dataRescisao > DateTime.Now)
                {
                    return 2; //Data Posterior
                }
                else if(fechMesCont == 0)
                {
                    return 3; //Mês Anterior não fechado
                }
                else if(fechdiaCont > 0)
                {
                    return 4; //Dia com Fechamento
                }
                else
                    return 0;//Dia útil
            }
            else
            {
                return 1;//Dia não útil
            }
        }
        public static bool diaUtil(DateTime dt, String str_conn)
        {
                if (dt.DayOfWeek == DayOfWeek.Saturday)
                {
                    return false;
                }
                else if (dt.DayOfWeek == DayOfWeek.Sunday)
                {
                    return false;
                }
                else if (Feriado(dt,str_conn) == true)
                {
                    return false;
                }
                else return true;
        }
        public static bool Feriado(DateTime dt, String str_conn)
        {
            DateTime data = new DateTime(1986, 3, 26);
            if (dt == data)
            {
                return true;
            }
            else
                return false;
        }
        public static void CriaFeriado(String str_conn,String Url, String Key, String Ano)
        {
            string urlApi = Url + "json=true&ano=" + Ano + "&token=" + Key;
            //string urlGCApi = "https://api.calendario.com.br/?json=true&ano=2020&token=amVzc2Uub2xpdmVpcmFham9AZ21haWwuY29tJmhhc2g9OTU2OTcyMzA";
            var reqWeb = WebRequest.CreateHttp(urlApi);
            reqWeb.Method = "GET";
            reqWeb.UserAgent = "RequisicaoGoogleCalendar";
            using (var resposta = reqWeb.GetResponse())
            {
                var streamDados = resposta.GetResponseStream();
                try
                {                    
                    StreamReader reader = new StreamReader(streamDados);
                    object objResponse = reader.ReadToEnd();
                    var get = Newtonsoft.Json.JsonConvert.DeserializeObject<IEnumerable<Holiday.Item>>(objResponse.ToString());
                    //Holiday.Item[] itens = new Holiday.Item[get.ite];
                    var itens = get.ToArray();
                    for (int i = 0; i < itens.Length; i++)
                    {
                        var dt = Convert.ToDateTime(itens[i].date, CultureInfo.GetCultureInfo("pt-BR"));
                        var feriado = itens[i].name;
                        if (Convert.ToInt32(itens[i].type_code) == 1)
                        {
                            string exec = DataBase.Consultas.InsertInto(str_conn, "INSERT INTO TBFERIAD (TBDTFERI,TBNMFERI,PAIDPAIS) VALUES(convert(datetime,'" + string.Format(CultureInfo.GetCultureInfo("pt-BR"), "{0:d}", dt) + "',103),'" + feriado + "',1)");
                        }
                    }
                }
                catch { }
                finally
                {
                    streamDados.Close();
                    resposta.Close();
                }
            }
        }
        public static string nesta_sp_ins_Boleta_Provisoria(int p_idboleta,String str_conn)
        {
            string retorno = null;
            string storedProc = "nesta_sp_ins_Boleta_Provisoria";
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                try
                {
                    OleDbParameter outValue = new OleDbParameter("@p_mensagem", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                    conn.Open();
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = storedProc;
                    cmd.Parameters.AddWithValue("@p_idboleta", p_idboleta);
                    cmd.Parameters.Add(outValue);
                    cmd.ExecuteScalar();
                    retorno = outValue.Value.ToString();
                }
                catch (Exception ex)
                {
                    retorno = ex.Message.ToString();
                }
                finally
                {
                    conn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }

            }
            return retorno;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="str_conn">Banco de Acesso</param>
        /// <param name="procName">Nome da procedure a ser executada</param>
        /// <param name="param_dados">array com parametros de execução, exemplo Parametro#valor[0]</param>
        /// <param name="paramOutPut">Nome de campo output, inserir null caso não tenha retorno</param>
        /// <returns></returns>
        public static string ExecProcedure(String str_conn,String procName, String[] param_dados,String paramOutPut)
        {
            Logger log = new Logger();
            log.Usuario = Usuario;
            log.Tela = Tela;
            log.Alteracao = Alteracao;
            log.str_conn = str_conn;
            log.Acao = Acao;
            log.Resumo = Resumo;
            string retorno = string.Empty;
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                try
                {
                    if (paramOutPut == "null")
                    {
                        conn.Open();
                        OleDbCommand cmd = new OleDbCommand();
                        cmd.CommandTimeout = 120000;
                        cmd.Connection = conn;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = procName;
                        for (int i = 0; i < param_dados.Length; i++)
                        {
                            cmd.Parameters.AddWithValue(param_dados[i].Split('#')[0], param_dados[i].Split('#')[1]);
                        }
                        cmd.ExecuteScalar();
                        retorno = "OK";
                    }
                    else
                    {
                        OleDbParameter outValue = new OleDbParameter(paramOutPut, OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                        conn.Open();
                        OleDbCommand cmd = new OleDbCommand();
                        cmd.CommandTimeout = 120000;
                        cmd.Connection = conn;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = procName;                        
                        for (int i = 0; i < param_dados.Length; i++)
                        {
                            if (param_dados[i].Split('#')[1] == "NULL")
                            {
                                OleDbParameter paramNulo = new OleDbParameter(param_dados[i].Split('#')[0], SqlDbType.Int);
                                paramNulo.Value = DBNull.Value;
                                cmd.Parameters.Add(paramNulo);
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue(param_dados[i].Split('#')[0], param_dados[i].Split('#')[1]);
                            }
                        }
                        cmd.Parameters.Add(outValue);
                        cmd.ExecuteScalar();
                        retorno = outValue.Value.ToString();
                        if(retorno=="OK")
                        {
                            log.GravarLog();
                        }
                    }
                }
                catch(Exception ex)
                {
                    retorno = ex.Message.ToString();
                }
                finally
                {
                    conn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }
            }
            return retorno;
        }
        public static string InsertPropriedadesDinamicas(String str_conn,String lang,int p_opidcont, int p_chidcodi, int p_cjidcodi, int p_cjtpidtp, String p_cjtpcttx, int p_cjinprop, float p_cjvlprop, DateTime ? p_cjdtprop, DateTime ? p_cjdtdtde, DateTime ? p_cjdtdtat, float p_cjvldeat)
        {
            string retorno = null;
            string storedProc = "nesta_sp_insert_CJCLPROP_DIN";
            using (OleDbConnection conn = new OleDbConnection(str_conn))
            {
                try
                {
                    OleDbParameter outValue = new OleDbParameter("o_mensagem", OleDbType.VarChar, 4000) { Direction = ParameterDirection.Output };
                    conn.Open();
                    OleDbCommand cmd = new OleDbCommand();
                    cmd.Connection = conn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = storedProc;
                    cmd.Parameters.AddWithValue("p_opidcont", p_opidcont);
                    cmd.Parameters.AddWithValue("p_chidcodi", p_chidcodi);
                    cmd.Parameters.AddWithValue("p_cjidcodi", p_cjidcodi);
                    cmd.Parameters.AddWithValue("p_cjtpidtp", p_cjtpidtp);
                    cmd.Parameters.AddWithValue("p_cjtpcttx", p_cjtpcttx);
                    cmd.Parameters.AddWithValue("p_cjinprop", p_cjinprop);
                    cmd.Parameters.AddWithValue("p_cjvlprop", p_cjvlprop);
                    cmd.Parameters.AddWithValue("p_cjdtprop", p_cjdtprop);
                    cmd.Parameters.AddWithValue("p_cjdtdtde", p_cjdtdtde);
                    cmd.Parameters.AddWithValue("p_cjdtdtat", p_cjdtdtat);
                    cmd.Parameters.AddWithValue("p_cjvldeat", p_cjvldeat);
                    cmd.Parameters.AddWithValue("p_idioma", lang);
                    cmd.Parameters.Add(outValue);
                    cmd.ExecuteScalar();
                    retorno = outValue.Value.ToString();
                }
                catch (Exception ex)
                {
                    retorno = "ERROR:021 "+ ex.Message.ToString();
                }
                finally
                {
                    conn.Close();
                    OleDbConnection.ReleaseObjectPool();
                }

            }
            return retorno;
        }
        public static string HierarquiaEstrut(String str_conn, String TVIDESTR, String sgbd)
        {
            string retorno = string.Empty;
            string sql = string.Empty;
            switch(sgbd)
            {
                case "oracle":
                    break;
                case "sql":
                    sql = "WITH n(tvcdpaie,tvidestr, tvdsestr) AS ";
                    sql += "(SELECT tvcdpaie,tvidestr,tvdsestr ";
                    sql += "FROM tvestrut ";
                    sql += "WHERE tvidestr = " + TVIDESTR + " ";
                    sql += "UNION ALL ";
                    sql += "SELECT nplus1.tvcdpaie,nplus1.tvidestr,nplus1.tvdsestr ";
                    sql += "FROM tvestrut as nplus1, n ";
                    sql += "WHERE n.tvidestr = nplus1.tvcdpaie) ";
                    sql += "SELECT * FROM n";
                    break;
            }            
            OleDbConnection conn = new OleDbConnection(str_conn);
            OleDbCommand cmd = new OleDbCommand(sql, conn);
            try
            {
                conn.Open();
                OleDbDataReader dr = cmd.ExecuteReader();
                if(dr.HasRows)
                {
                    while(dr.Read())
                    {
                        retorno += "'"+dr[1].ToString() + "',";
                    }
                }
                retorno = retorno.Substring(0, retorno.Length - 1);
            }
            catch(Exception ex)
            {
                retorno = ex.Message;
            }
            finally
            {
                conn.Close();
            }
            return retorno;
        }
    }
}
