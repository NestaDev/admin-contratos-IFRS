using System;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace DataBase
{
    public class Integra
    {

        public string urlAPI { get; set; }
        public string userAPI { get; set; }
        public string passAPI { get; set; }
        public string retornoAPI { get; set; }
        public HttpStatusCode PostRequest(String contentJSON)
        {
            try
            {
                string retorno = string.Empty;
                HttpWebRequest myRequest = (HttpWebRequest)HttpWebRequest.Create(urlAPI);
                myRequest.Method = "POST";
                byte[] dataJSON = Encoding.ASCII.GetBytes(contentJSON);
                myRequest.ContentType = "application/json";
                myRequest.ContentLength = dataJSON.Length;
                var byteArray = Encoding.ASCII.GetBytes(userAPI + ":" + passAPI);
                myRequest.Headers.Add("Authorization", "Basic " + Convert.ToBase64String(byteArray));
                Stream reqStream = myRequest.GetRequestStream();
                reqStream.Write(dataJSON, 0, dataJSON.Length);
                reqStream.Close();
                HttpWebResponse myResponse = (HttpWebResponse)myRequest.GetResponse();
                Stream respStream = myResponse.GetResponseStream();
                StreamReader myReader = new StreamReader(respStream, Encoding.Default);
                switch (myResponse.StatusCode)
                {
                    case HttpStatusCode.OK:
                        retornoAPI = myReader.ReadToEnd();
                        break;
                    default:
                        retornoAPI = "Status Code: " + myResponse.StatusCode + " Não foi possível acessar a API " + urlAPI;
                        break;
                }
                myResponse.Close();
                myReader.Close();
                respStream.Close();
                return myResponse.StatusCode;
            }
            catch (Exception ex)
            {
                throw new Exception("Não foi possível acessar a API " + urlAPI);
            }
        }
    }
}
namespace IntegraCeA
{

    public class Rootobject
    {

        public string str_conn { get; set; }
        public string mmyyyy { get; set; }
        public string opidcont { get; set; }
        public bool Existe()
        {
            string sql = "SELECT count(*) " +
                    "from nesta_ws_Acc_Statement, opcontra, PFPLNCTA, DPTVESTR " +
                    "where event between convert(date, '01/" + mmyyyy + "', 103) and DATEADD(Day,-1, DATEADD(MONTH,1, convert(date,'01/" + mmyyyy + "',103))) " +
                    "and nesta_ws_Acc_Statement.internal_id    = opcontra.opidcont " +
                    "and nesta_ws_Acc_Statement.account_number = PFPLNCTA.PFCDPLNC " +
                    "and nesta_ws_Acc_Statement.legal_entity_id= DPTVESTR.TVIDESTR " +
                    "and transaction_currency = 'NOMINAL' " +
                    "and opidcont in (" + opidcont + ") ";
            return Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, sql, 1)[0]) > 0;
        }
        public void Get()
        {
            string sql = "SELECT document_key id_processo, " +
                    "dptvestr.DPIDESAP empresa, " +
                    "event data_documento, " +
                    "event data_lancamento, " +
                    "year(event) exercicio, " +
                    "dbo.LPAD(month(event),2,0) periodo, " +
                    "'SA' tipo_documento, " +
                    "contract_number referencia, " +
                    "dbo.LPAD(ROW_NUMBER() OVER(ORDER BY abs(dc_value) ASC),10,0) AS item_num, " +
                    "dbo.LPAD(account_number,'10',0)  account_number, " +
                    "dbo.nesta_fn_Remove_Acentuacao(concat(modality,'-', DBO.LPAD((Convert(char(2),month(event))),2,'0'), '/', format(event,'yy'))) texto, " +
                    "OPNMCONT num_atribuicao, " +
                    "CASE PFPLNCTA.PFFLCCCL " +
                       "WHEN 'C' THEN " +
                         "dbo.LPAD(cost_center,'10',0) " +
                      "ELSE " +
                        "NULL END cost_center, " +
                    "CASE PFPLNCTA.PFFLCCCL " +
                      "WHEN 'L' THEN " +
                        "dbo.LPAD(profit_center,'10',0) " +
                      "ELSE " +
                        "NULL END profit_center, " +
                    "'BRL' moeda, " +
                    "CASE  " +
                      "WHEN dc_value > 0 THEN " +
                        "convert(varchar(15), (format(dc_value, '#.0000'))) " +
                      "ELSE " +
                        "(REPLACE((convert(varchar(15), (format(dc_value, '#.0000')))), '-', '')) + '-' END montante, " +
                        "document_key texto_cabec " +
                    "from nesta_ws_Acc_Statement, opcontra, PFPLNCTA, DPTVESTR " +
                    "where event between convert(date, '01/" + mmyyyy + "', 103) and DATEADD(Day,-1, DATEADD(MONTH,1, convert(date,'01/" + mmyyyy + "',103))) " +
                    "and nesta_ws_Acc_Statement.internal_id    = opcontra.opidcont " +
                    "and nesta_ws_Acc_Statement.account_number = PFPLNCTA.PFCDPLNC " +
                    "and nesta_ws_Acc_Statement.legal_entity_id= DPTVESTR.TVIDESTR " +
                    "and transaction_currency = 'NOMINAL' " +
                    "and opidcont in (" + opidcont + ") " +
                    "order by abs(dc_value)";
            var result = DataBase.Consultas.Consulta(str_conn, sql, 17);
            Row _row = new Row();
            _row.id_processo = result[0];
            Header _header = new Header();
            _header.operacao = "RFBU";
            _header.username = "JOBTRK";
            _header.empresa = result[1];
            _header.data_documento = Convert.ToDateTime(result[2]).ToString("yyyy-MM-dd");
            _header.data_lancamento = Convert.ToDateTime(result[3]).ToString("yyyy-MM-dd");
            _header.exercicio = result[4];
            _header.periodo = result[5];
            _header.tipo_documento = result[6];
            _header.referencia = result[7];
            _header.texto_cabec = result[16];
            DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
            Account_Gl[] account_Gls = new Account_Gl[dt.Rows.Count];

            Currency_Amount[] currency_Amounts = new Currency_Amount[dt.Rows.Count];

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                DataRow row = dt.Rows[i];
                Account_Gl account_Gl = new Account_Gl();
                Currency_Amount currency_Amount = new Currency_Amount();
                account_Gl.item_num = row["item_num"].ToString();
                currency_Amount.item_num = row["item_num"].ToString();
                account_Gl.account = row["account_number"].ToString();
                account_Gl.texto = row["texto"].ToString();
                account_Gl.empresa = result[1];
                account_Gl.num_atribuicao = row["num_atribuicao"].ToString();
                account_Gl.centro_custo = row["cost_center"].ToString();
                account_Gl.centro_lucro = row["profit_center"].ToString();
                currency_Amount.moeda = row["moeda"].ToString();
                currency_Amount.montante = row["montante"].ToString();
                account_Gls[i] = account_Gl;
                currency_Amounts[i] = currency_Amount;
            }
            _row.header = _header;
            _row.account_gl = account_Gls;
            _row.currency_amount = currency_Amounts;
            row = _row;
        }
        public Row row { get; set; }
        
    }
    public class Rootobject2
    {
        public string str_conn { get; set; }
        public string mmyyyy { get; set; }
        public string opidcont { get; set; }
        public void Get()
        {
            string sql = "SELECT document_key id_processo, " +
                    "dptvestr.DPIDESAP empresa, " +
                    "event data_documento, " +
                    "event data_lancamento, " +
                    "year(event) exercicio, " +
                    "dbo.LPAD(month(event),2,0) periodo, " +
                    "'SA' tipo_documento, " +
                    "contract_number referencia, " +
                    "dbo.LPAD(ROW_NUMBER() OVER(ORDER BY abs(dc_value) ASC),10,0) AS item_num, " +
                    "dbo.LPAD(account_number,'10',0)  account_number, " +
                    "dbo.nesta_fn_Remove_Acentuacao(concat(modality,'-', DBO.LPAD((Convert(char(2),month(event))),2,'0'), '/', format(event,'yy'))) texto, " +
                    "OPNMCONT num_atribuicao, " +
                    "CASE PFPLNCTA.PFFLCCCL " +
                       "WHEN 'C' THEN " +
                         "dbo.LPAD(cost_center,'10',0) " +
                      "ELSE " +
                        "NULL END cost_center, " +
                    "CASE PFPLNCTA.PFFLCCCL " +
                      "WHEN 'L' THEN " +
                        "dbo.LPAD(profit_center,'10',0) " +
                      "ELSE " +
                        "NULL END profit_center, " +
                    "'BRL' moeda, " +
                    "CASE  " +
                      "WHEN dc_value > 0 THEN " +
                        "convert(varchar(15), (format(dc_value, '#.0000'))) " +
                      "ELSE " +
                        "(REPLACE((convert(varchar(15), (format(dc_value, '#.0000')))), '-', '')) + '-' END montante, " +
                        "document_key texto_cabec " +
                    "from nesta_ws_Acc_Statement, opcontra, PFPLNCTA, DPTVESTR " +
                    "where event between convert(date, '01/" + mmyyyy + "', 103) and DATEADD(Day,-1, DATEADD(MONTH,1, convert(date,'01/" + mmyyyy + "',103))) " +
                    "and nesta_ws_Acc_Statement.internal_id    = opcontra.opidcont " +
                    "and nesta_ws_Acc_Statement.account_number = PFPLNCTA.PFCDPLNC " +
                    "and nesta_ws_Acc_Statement.legal_entity_id= DPTVESTR.TVIDESTR " +
                    "and transaction_currency = 'NOMINAL' " +
                    "and opidcont in (" + opidcont + ") " +
                    "order by 1, abs(dc_value)";
            string sql2 = "SELECT document_key id_processo,  "+
                            "dptvestr.DPIDESAP empresa, " +
                            "event data_documento,  " +
                            "event data_lancamento,  " +
                            "year(event) exercicio,  " +
                            "dbo.LPAD(month(event),2,0) periodo,  " +
                            "'SA' tipo_documento,  " +
                            "contract_number referencia,  " +
                            "document_key texto_cabec " +
                            "from nesta_ws_Acc_Statement, opcontra, PFPLNCTA, DPTVESTR " +
                    "where event between convert(date, '01/" + mmyyyy + "', 103) and DATEADD(Day,-1, DATEADD(MONTH,1, convert(date,'01/" + mmyyyy + "',103))) " +
                            "and nesta_ws_Acc_Statement.internal_id    = opcontra.opidcont " +
                            "and nesta_ws_Acc_Statement.account_number = PFPLNCTA.PFCDPLNC " +
                            "and nesta_ws_Acc_Statement.legal_entity_id= DPTVESTR.TVIDESTR " +
                            "and transaction_currency = 'NOMINAL' " +
                            "and opidcont in ("+opidcont+") " +
                            "group by document_key,  " +
                            "dptvestr.DPIDESAP,  " +
                            "event,  " +
                            "event,  " +
                            "year(event),  " +
                            "dbo.LPAD(month(event),2,0),  " +
                            "contract_number,  " +
                            "document_key " +
                            "order by 1";
            DataTable dTable = DataBase.Consultas.Consulta(str_conn, sql2);
            row = new Row[dTable.Rows.Count];
            int contRow = 0;
            foreach (DataRow result in dTable.Rows)
            {
                Row _row = new Row();
                _row.id_processo = result[0].ToString();
                Header _header = new Header();
                _header.operacao = "RFBU";
                _header.username = "JOBTRK";
                _header.empresa = result[1].ToString();
                _header.data_documento = Convert.ToDateTime(result[2]).ToString("yyyy-MM-dd");
                _header.data_lancamento = Convert.ToDateTime(result[3]).ToString("yyyy-MM-dd");
                _header.exercicio = result[4].ToString();
                _header.periodo = result[5].ToString();
                _header.tipo_documento = result[6].ToString();
                _header.referencia = result[7].ToString();
                _header.texto_cabec = result[8].ToString();
                DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
                Account_Gl[] account_Gls = new Account_Gl[dt.Rows.Count];
                Currency_Amount[] currency_Amounts = new Currency_Amount[dt.Rows.Count];

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    DataRow row = dt.Rows[i];
                    Account_Gl account_Gl = new Account_Gl();
                    Currency_Amount currency_Amount = new Currency_Amount();
                    account_Gl.item_num = row["item_num"].ToString();
                    currency_Amount.item_num = row["item_num"].ToString();
                    account_Gl.account = row["account_number"].ToString();
                    account_Gl.texto = row["texto"].ToString();
                    account_Gl.empresa = result[1].ToString();
                    account_Gl.num_atribuicao = row["num_atribuicao"].ToString();
                    account_Gl.centro_custo = row["cost_center"].ToString();
                    account_Gl.centro_lucro = row["profit_center"].ToString();
                    currency_Amount.moeda = row["moeda"].ToString();
                    currency_Amount.montante = row["montante"].ToString();
                    account_Gls[i] = account_Gl;
                    currency_Amounts[i] = currency_Amount;
                }
                _row.header = _header;
                _row.account_gl = account_Gls;
                _row.currency_amount = currency_Amounts;
                row[contRow] = _row;
                contRow++;
            }

        }
        public Row[] row { get; set; }
    }
    public class Row
    {
        public string id_processo { get; set; }
        public Header header { get; set; }
        public Account_Gl[] account_gl { get; set; }
        public Currency_Amount[] currency_amount { get; set; }
    }
    public class Header
    {
        public string operacao { get; set; }
        public string username { get; set; }
        public string empresa { get; set; }
        public string data_documento { get; set; }
        public string data_lancamento { get; set; }
        public string exercicio { get; set; }
        public string periodo { get; set; }
        public string tipo_documento { get; set; }
        public string referencia { get; set; }
        public string texto_cabec { get; set; }
    }
    public class Account_Gl
    {
        public string item_num { get; set; }
        public string account { get; set; }
        public string texto { get; set; }
        public string empresa { get; set; }
        public string num_atribuicao { get; set; }
        public string centro_lucro { get; set; }
        public string centro_custo { get; set; }
        public bool ShouldSerializecentro_custo()
        {
            // don't serialize the Manager property if an employee is their own manager
            return (!string.IsNullOrEmpty(centro_custo));
        }
        public bool ShouldSerializecentro_lucro()
        {
            // don't serialize the Manager property if an employee is their own manager
            return (!string.IsNullOrEmpty(centro_lucro));
        }
    }
    public class Currency_Amount
    {
        public string item_num { get; set; }
        public string moeda { get; set; }
        public string montante { get; set; }
    }

    public class RootobjectRetorno
    {
        public Row2 row { get; set; }
    }
    public class RootobjectRetorno2
    {
        public Row2[] row { get; set; }
    }
    public class Row2
    {
        public string id_processo { get; set; }
        public string num_documento_sap { get; set; }
        public string msg_id { get; set; }
        public string msg_type { get; set; }
        public string msg_number { get; set; }
        public string message { get; set; }
    }

}
