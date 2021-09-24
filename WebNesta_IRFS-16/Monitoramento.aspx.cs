using DevExpress.XtraTreeList;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using DataBase.WA_API;
using System.Configuration;
using DevExpress.Spreadsheet;

namespace WebNesta_IRFS_16
{
    public partial class Monitoramento : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string perfil;
        public static bool AcessoInternet;
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["dtMonit"] != null && Session["sqlMonit"] != null)
            {
                DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlMonit"].ToString());
                Session["dtMonit"] = dt;
                gridMonit.DataSource = dt;
                gridMonit.DataBind();
            }
            if (Session["dtAprova"] != null && Session["sqlAprova"] != null)
            {
                DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlAprova"].ToString());
                Session["dtAprova"] = dt;
                gridAprova.DataSource = dt;
                gridAprova.DataBind();
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                lang = Session["langSession"].ToString();
            }
            catch
            {
                lang = System.Configuration.ConfigurationManager.AppSettings["langDefault"];
            }
            if (!IsPostBack)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
                if (myCookie == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                Session["dtMonit"] = null;
                Session["sqlMonit"] = null;                
                Session["dtAprova"] = null;
                Session["sqlAprova"] = null;
                Session["stringBuilder"] = null;                
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
                txtDtInicial.Text = DateTime.Now.ToShortDateString();
                txtDtFinal.Text = DateTime.Now.ToShortDateString();
                if (Session["dtMonit"] != null)
                {
                    DataTable dt = (DataTable)Session["dtMonit"] as DataTable;
                    gridMonit.DataSource = dt;
                    gridMonit.DataBind();
                }
                MultiView1.ActiveViewIndex = -1;
            }
            if(IsCallback || IsPostBack)
            {
                if (Session["dtMonit"] != null && Session["sqlMonit"] != null)
                {
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlMonit"].ToString());
                    Session["dtMonit"] = dt;
                    gridMonit.DataSource = dt;
                    gridMonit.DataBind();
                }
                if (Session["dtAprova"] != null && Session["sqlAprova"] != null)
                {
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlAprova"].ToString());
                    Session["dtAprova"] = dt;
                    gridAprova.DataSource = dt;
                    gridAprova.DataBind();
                }

            }
            if (IsPostBack && Session["stringBuilder"] != null)
            {
                WriteCSV(Session["stringBuilder"].ToString());
                
            }
            if (Session["dtMonit"] != null && Session["sqlMonit"] != null)
            {
                DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlMonit"].ToString());
                Session["dtMonit"] = dt;
                gridMonit.DataSource = dt;
                gridMonit.DataBind();
            }
            if (Session["dtAprova"] != null && Session["sqlAprova"] != null)
            {
                DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlAprova"].ToString());
                Session["dtAprova"] = dt;
                gridAprova.DataSource = dt;
                gridAprova.DataBind();
            }
        }
        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (IsPostBack && Session["stringBuilder"] != null)
            {
                Session["stringBuilder"] = null;

            }
        }
        protected void MsgException(string msg, int exc)
        {
            if (exc == 1)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 0)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            if (exc == 2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = sender as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (DevExpress.Web.ASPxTreeList.TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void btnProcessar_Click(object sender, EventArgs e)
        {

            string codDT = lang == "en-US" ? "101" : "103";
            string situacao = string.Empty;
            if (dropSitua.SelectedItem.Value.ToString() == "0") //Vencido
                situacao = " <= convert(date,'" + DateTime.Now.ToShortDateString() + "'," + codDT + ")";
            else if (dropSitua.SelectedItem.Value.ToString() == "1") //a Vencer
                situacao = " >= convert(date,'" + DateTime.Now.ToShortDateString() + "'," + codDT + ")";
            string sql = "select b.BOLNMBOL as NOME,convert(datetime,b.BOLDTVCT) as DATA,b.BOLVLBOL as VALOR,b.OPIDCONT as COD,b.BOLIDBOL as BOL,f1.FONMAB20 as FAV, f2.FONMAB20 as BEN,o.TVIDESTR,b.USIDUSUA from BOLVERBA f, BOLTOTBO b " +
                            "inner join opcontra o on b.OPIDCONT=o.OPIDCONT " +
                            "inner join FOFORNEC f1 on o.FOIDFORN=f1.FOIDFORN " +
                            "inner join FOFORNEC f2 on o.FOIDFORN2=f2.FOIDFORN " +
                            "where f.bolidbol = b.BOLIDBOL and BVAPROVA = 0 " +
                            "and f.BVDTVENC >= convert(date,'" + Convert.ToDateTime(txtDtInicial.Text) + "'," + codDT + ") " +
                            "and f.BVDTVENC <= convert(date,'" + Convert.ToDateTime(txtDtFinal.Text) + "'," + codDT + ")" +
                            "and f.BVDTVENC " + situacao + " " +
                            "and b.bolstbol=0 " +
                            "group by b.BOLNMBOL,b.BOLDTVCT,b.BOLVLBOL,b.OPIDCONT,b.BOLIDBOL,f1.FONMAB20,f2.FONMAB20,o.TVIDESTR,b.USIDUSUA " +
                            "having min(BVVALIDA)= 1";
            //Response.Write(sql);
            Session["sqlMonit"] = sql;
            DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
            Session["dtMonit"] = dt;
            gridMonit.DataSource = dt;
            gridMonit.DataBind();
            MultiView1.SetActiveView(this.vw_monitora);
        }
        protected void gridMonit_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "processar")
            {
                //gridMonit.JSProperties.Add("cpIsCustomCallback", null);
                //gridMonit.JSProperties["cpIsCustomCallback"] = "CustomCallbackCSV";
                var ID = gridMonit.GetSelectedFieldValues("BOL");
                //for (int i = 0; i < ID.Count; i++)
                //{
                //    string sqlUPDT = "update fluxo_oper_jesse set aprovado=1 where bolidbol=@bolidbol";
                //    sqlUPDT = sqlUPDT.Replace("@bolidbol", ID[i].ToString());
                //    string exec = DataBase.Consultas.UpdtFrom(str_conn,sqlUPDT);
                //    if(exec=="OK")
                //    {
                //        sqlUPDT = "update BOLTOTBO set bolstbol=1 where BOLIDBOL=@BOLIDBOL and bolstbol=0";
                //        sqlUPDT = sqlUPDT.Replace("@BOLIDBOL", ID[i].ToString());
                //        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUPDT);
                //    }
                //}
                //StringBuilder stringBuilder = new StringBuilder();
                //stringBuilder.AppendLine("Cabeçalho;;;;;;;Linha Lançamento item 1;;;;;;;;;;Linha Lançamento item 1;;;;;;;;;;");
                //stringBuilder.AppendLine("DATA_DOCUMENTO;TIPO_DOCUMENTO;EMPRESA;DATA_LANCAMENTO;MOEDA;REFERENCIA;TEXTO_CABECALHO;CONTA;TIPO_CONTA;DIVISAO;CENTRO_CUSTO;CENTRO_LUCRO;ORDEM;ATRIBUICAO;TEXTO_ITEM;DATA_VENCIMENTO;VALOR;CONTA_DEBITO;CONTA2;TIPO_CONTA2;DIVISAO2;CENTRO_CUSTO2;CENTRO_LUCRO2;ORDEM2;ATRIBUICAO2;TEXTO_ITEM2;DATA_VENCIMENTO2;LINHA_DIGITAVEL_BOLETO");
                //var ID = gridMonit.GetSelectedFieldValues("BOL");
                for (int i = 0; i < ID.Count; i++)
                {
                    //string sqlDT = "select convert(varchar,DATEADD(month, DATEDIFF(month, 0, f.BVDTVENC), 0),103) as DATA_DOCUMENTO " +
                    //            ",'KR' AS TIPO_DOCUMENTO " +
                    //            ",'1000' AS EMPRESA " +
                    //            ", convert(varchar,DATEADD(month, DATEDIFF(month, 0, f.BVDTVENC), 0),103) AS DATA_LANCAMENTO " +
                    //            ",'BRL' AS MOEDA " +
                    //            ",concat('AL-',replace(cast(B.BOLVLBOL as varchar),'.','')) AS REFERENCIA " +
                    //            ",UPPER(m.MODSMODA) as TEXTO_CABECALHO " +
                    //            ",'42106003' AS CONTA " +
                    //            ",'R' AS TIPO_CONTA " +
                    //            ", O.OPCDCONT AS DIVISAO " +
                    //            ",'1020020552' AS CENTRO_CUSTO " +
                    //            ", NULL AS CENTRO_LUCRO " +
                    //            ", NULL AS ORDEM " +
                    //            ", NULL AS ATRIBUICAO " +
                    //            ",case when m.MORECUPMOD=1 then CONCAT('BLOCO F ', UPPER(M.MODSMODA)) else UPPER(M.MODSMODA) end AS TEXTO_ITEM " +
                    //            ", convert(varchar, F.BVDTVENC, 103) AS DATA_VENCIMENTO " +
                    //            ", CAST(f.BVVLVERB as varchar) AS VALOR " +
                    //            ",'D' AS CONTA_DEBITO " +
                    //            ",'110000520' AS CONTA2 " +
                    //            ",'F' AS TIPO_CONTA2 " +
                    //            ", O.OPCDCONT AS DIVISAO2 " +
                    //            ",'1020020552' AS CENTRO_CUSTO2 " +
                    //            ",NULL AS CENTRO_LUCRO2 " +
                    //            ",NULL AS ORDEM2 " +
                    //            ", NULL AS ATRIBUICAO2 " +
                    //            ",case when m.MORECUPMOD=1 then CONCAT('BLOCO F ', UPPER(M.MODSMODA)) else UPPER(M.MODSMODA) end AS TEXTO_ITEM2 " +
                    //            ", convert(varchar, f.BVDTVENC, 103) AS DATA_VENCIMENTO2 " +
                    //            ", B.BOLCDBOL AS LINHA_DIGITAVEL_BOLETO " +
                    //            "from BOLVERBA f " +
                    //            "inner join BOLTOTBO b on f.bolidbol = b.BOLIDBOL " +
                    //            "inner join opcontra o on f.opidcont = o.OPIDCONT " +
                    //            "inner join modalida m on f.moidmoda = m.MOIDMODA " +
                    //            "where f.opidcont = b.OPIDCONT and b.BOLIDBOL = " + ID[i].ToString();
                    //sqlDT = sqlDT.Replace("@opidcont", DataBase.Consultas.Consulta(str_conn, "select OPIDCONT from BOLTOTBO where BOLIDBOL=" + ID[i].ToString() + "", 1)[0]);
                    //var DTLinhas = DataBase.Consultas.Consulta(str_conn, sqlDT);
                    //foreach (DataRow row in DTLinhas.Rows)
                    //{
                    //    string strRow = string.Empty;
                    //    for (int j = 0; j < DTLinhas.Columns.Count; j++)
                    //    {
                    //        strRow += row[j].ToString() + ";";
                    //    }
                    //    strRow = strRow.Substring(0, strRow.Length - 1);
                    //    stringBuilder.AppendLine(strRow);
                    //}
                    string sqlUPDT = "update BOLVERBA set BVAPROVA=1 where BOLIDBOL=@bolidbol";
                    sqlUPDT = sqlUPDT.Replace("@bolidbol", ID[i].ToString());
                    string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUPDT);
                    if (exec == "OK")
                    {
                        sqlUPDT = "update BOLTOTBO set bolstbol=1 where BOLIDBOL=@BOLIDBOL and bolstbol=0";
                        sqlUPDT = sqlUPDT.Replace("@BOLIDBOL", ID[i].ToString());
                        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUPDT);
                    }
                }
                if (Session["dtMonit"] != null && Session["sqlMonit"] != null)
                {
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlMonit"].ToString());
                    Session["dtMonit"] = dt;
                    gridMonit.DataSource = dt;
                    gridMonit.DataBind();
                }
                //Session["stringBuilder"] = stringBuilder.ToString();
            }
            else if (e.Parameters == "AllROws")
            {
                if (hfAllRows.Value != string.Empty)
                {
                    if (Convert.ToBoolean(hfAllRows.Value))
                    {
                        for (int i = 0; i < gridMonit.VisibleRowCount; i++)
                        {
                            bool rowEnabled = getRowEnabledStatus(i);
                            if (rowEnabled)
                                gridMonit.Selection.SelectRow(i);
                            else
                                gridMonit.Selection.UnselectRow(i);
                        }
                    }
                    else
                    {
                        gridMonit.Selection.UnselectAll();
                    }
                }
            }
        }
        protected void btnIntegrarCSV_Click(object sender, EventArgs e)
        {
            //StringBuilder stringBuilder = new StringBuilder();
            //stringBuilder.AppendLine("Cabeçalho;;;;;;;Linha Lançamento item 1;;;;;;;;;;Linha Lançamento item 1;;;;;;;;;;");
            //stringBuilder.AppendLine("DATA_DOCUMENTO;TIPO_DOCUMENTO;EMPRESA;DATA_LANCAMENTO;MOEDA;REFERENCIA;TEXTO_CABECALHO;CONTA;TIPO_CONTA;DIVISAO;CENTRO_CUSTO;CENTRO_LUCRO;ORDEM;ATRIBUICAO;TEXTO_ITEM;DATA_VENCIMENTO;VALOR;CONTA_DEBITO;CONTA2;TIPO_CONTA2;DIVISAO2;CENTRO_CUSTO2;CENTRO_LUCRO2;ORDEM2;ATRIBUICAO2;TEXTO_ITEM2;DATA_VENCIMENTO2;LINHA_DIGITAVEL_BOLETO");
            //var ID = gridMonit.GetSelectedFieldValues("BOL");
            //for (int i = 0; i < ID.Count; i++)
            //{
            //    string sqlDT = "select convert(varchar,f.data,103) as DATA_DOCUMENTO " +
            //                ",'KR' AS TIPO_DOCUMENTO " +
            //                ",'1000' AS EMPRESA " +
            //                ", convert(varchar, f.data, 103) AS DATA_LANCAMENTO " +
            //                ",'BRL' AS MOEDA " +
            //                ", B.BOLNMBOL AS REFERENCIA " +
            //                ",UPPER(m.MODSMODA) as TEXTO_CABECALHO " +
            //                ",'42106003' AS CONTA " +
            //                ",'R' AS TIPO_CONTA " +
            //                ", O.OPCDCONT AS DIVISAO " +
            //                ",'1020020552' AS CENTRO_CUSTO " +
            //                ", NULL AS CENTRO_LUCRO " +
            //                ", NULL AS ORDEM " +
            //                ", NULL AS ATRIBUICAO " +
            //                ", CONCAT('BLOCO F ', UPPER(M.MODSMODA)) AS TEXTO_ITEM " +
            //                ", convert(varchar, F.data_venc, 103) AS DATA_VENCIMENTO " +
            //                ", CONVERT(CHAR, f.valor) AS VALOR " +
            //                ",'D' AS CONTA_DEBITO " +
            //                ",'110000520' AS CONTA2 " +
            //                ",'F' AS TIPO_CONTA2 " +
            //                ", O.OPCDCONT AS DIVISAO2 " +
            //                ",'1020020552' AS CENTRO_CUSTO2 " +
            //                ",NULL AS CENTRO_LUCRO2 " +
            //                ",NULL AS ORDEM2 " +
            //                ", NULL AS ATRIBUICAO2 " +
            //                ", CONCAT('BLOCO F ', UPPER(M.MODSMODA)) AS TEXTO_ITEM2 " +
            //                ", convert(varchar, f.data_venc, 103) AS DATA_VENCIMENTO2 " +
            //                ", B.BOLCDBOL AS LINHA_DIGITAVEL_BOLETO " +
            //                "from fluxo_oper_jesse f " +
            //                "inner join BOLTOTBO b on f.bolidbol = b.BOLIDBOL " +
            //                "inner join opcontra o on f.opidcont = o.OPIDCONT " +
            //                "inner join modalida m on f.moidmoda = m.MOIDMODA " +
            //                "where f.opidcont = @opidcont";
            //    sqlDT = sqlDT.Replace("@opidcont", DataBase.Consultas.Consulta(str_conn, "select OPIDCONT from BOLTOTBO where BOLIDBOL=" + ID[i].ToString() + "", 1)[0]);
            //    var DTLinhas = DataBase.Consultas.Consulta(str_conn, sqlDT);
            //    foreach (DataRow row in DTLinhas.Rows)
            //    {
            //        string strRow = string.Empty;
            //        for (int j = 0; j < DTLinhas.Columns.Count; j++)
            //        {
            //            strRow += row[j].ToString() + ";";
            //        }
            //        strRow = strRow.Substring(0, strRow.Length - 1);
            //        stringBuilder.AppendLine(strRow);
            //    }
            //    string sqlUPDT = "update fluxo_oper_jesse set aprovado=1 where bolidbol=@bolidbol";
            //    sqlUPDT = sqlUPDT.Replace("@bolidbol", ID[i].ToString());
            //    string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUPDT);
            //    if (exec == "OK")
            //    {
            //        sqlUPDT = "update BOLTOTBO set bolstbol=1 where BOLIDBOL=@BOLIDBOL and bolstbol=0";
            //        sqlUPDT = sqlUPDT.Replace("@BOLIDBOL", ID[i].ToString());
            //        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUPDT);
            //    }
            //}
            //if (Session["dtMonit"] != null && Session["sqlMonit"] != null)
            //{
            //    DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlMonit"].ToString());
            //    Session["dtMonit"] = dt;
            //    gridMonit.DataSource = dt;
            //    gridMonit.DataBind();
            //}
            //WriteCSV(stringBuilder.ToString());

        }
        protected void WriteCSV(string texto)
        {
            string csvpath = Server.MapPath("ExportingContaPagar_"+DateTime.Now.ToString("ddMMyyyyHHmmss")+".csv");

            if (File.Exists(csvpath))
            {
                File.Delete(csvpath);
            }

            //using (StreamWriter sw = File.CreateText(csvpath))
            using (StreamWriter sw = new StreamWriter(csvpath, false, Encoding.UTF8))
            {
                sw.Write(texto);
            }

            DownLoad(csvpath);
        }
        protected void DownLoad(string FName)
        {
            FileStream fs = null;
            long fsize = 0;
            byte[] buffer = null;
            var pasta = new System.IO.DirectoryInfo(FName);
            System.IO.FileInfo file = new System.IO.FileInfo(pasta.FullName);
            if (file.Exists)
            {
                //Response.Clear();
                //Response.ContentType = "text/plain";
                //Response.Charset = "utf-8";
                //Response.ContentEncoding = Encoding.UTF8;
                //Response.AddHeader("Content-Disposition", "attachment; filename=" + DateTime.Now.ToString("ddMMyyyyHHmmssfff") + ".csv");
                //Response.AddHeader("Content-Length", file.Length.ToString());
                //Response.Flush();
                //Response.WriteFile(file.FullName);
                try
                {
                    fs = new FileStream(FName, FileMode.Open);
                    if (fs != null)
                    {
                        fsize = fs.Length;
                        buffer = new byte[(int)fsize];
                        fs.Read(buffer, 0, (int)fsize);
                    }
                    Response.ClearHeaders();
                    Response.ClearContent();
                    Response.Clear();
                    Response.ContentType = "application/octet-stream";
                    Response.AddHeader("Content-Disposition", "attachment;filename=" + file.Name);
                    //file is being downloaded as a stream of bytes(binary form).
                    Response.BinaryWrite(buffer);
                    Response.Flush();
                    Response.End();
                }
                catch { }
                finally
                {
                    fs.Close();
                    //Delete the temporary zip file irrespective of the result.
                    if (File.Exists(file.FullName))
                    { File.Delete(file.FullName); }
                }
            }
        }
        protected void btnProcessarAprov_Click(object sender, EventArgs e)
        {
            string codDT = lang == "en-US" ? "101" : "103";
            string situacao = string.Empty;
            if (dropSitua.SelectedItem.Value.ToString() == "0") //Vencido
                situacao = " <= convert(date,'" + DateTime.Now.ToShortDateString() + "'," + codDT + ")";
            else if (dropSitua.SelectedItem.Value.ToString() == "1") //a Vencer
                situacao = " >= convert(date,'" + DateTime.Now.ToShortDateString() + "'," + codDT + ")";
            string sql = "select b.BOLNMBOL as NOME,convert(datetime,b.BOLDTVCT) as DATA,b.BOLVLBOL as VALOR,b.OPIDCONT as COD,b.BOLIDBOL as BOL,f1.FONMAB20 as FAV, f2.FONMAB20 as BEN,o.TVIDESTR "+
                        "from BOLVERBA f, BOLTOTBO b "+
                        "inner join VINIUSUA V ON v.USIDUSUA = '"+ hfUser.Value + "' " +
                        "inner join NIAPROVA A on a.NIIDAPRO = v.NIIDAPRO " +
                        "inner join opcontra o on b.OPIDCONT = o.OPIDCONT " +
                        "inner join FOFORNEC f1 on o.FOIDFORN = f1.FOIDFORN " +
                        "inner join FOFORNEC f2 on o.FOIDFORN2 = f2.FOIDFORN " +
                        "where f.bolidbol = b.BOLIDBOL and BVAPROVA = 0 " +
                        "and f.BVDTVENC >= convert(date,'" + Convert.ToDateTime(txtDtInicial.Text) + "'," + codDT + ") " +
                        "and f.BVDTVENC <= convert(date,'" + Convert.ToDateTime(txtDtFinal.Text) + "'," + codDT + ")" +
                        "and f.BVDTVENC " + situacao + " " +
                        "and b.bolstbol = 0 " +
                        "and b.BOLVLBOL between a.NIVL1APR and a.NIVL2APR " +
                        "and b.USIDUSUA = '0' " +
                        "group by b.BOLNMBOL,b.BOLDTVCT,b.BOLVLBOL,b.OPIDCONT,b.BOLIDBOL,f1.FONMAB20,f2.FONMAB20,o.TVIDESTR " +
                        "having min(BVVALIDA) = 1";
            //Response.Write(sql);
            Session["sqlAprova"] = sql;
            DataTable dt = DataBase.Consultas.Consulta(str_conn, sql);
            Session["dtAprova"] = dt;
            gridAprova.DataSource = dt;
            gridAprova.DataBind();
            MultiView1.SetActiveView(this.vw_aprova);
        }
        protected void gridAprova_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "aprovar")
            {
                var ID = gridAprova.GetSelectedFieldValues("BOL");
                for (int i = 0; i < ID.Count; i++)
                {
                    string sqlUPDT = "update BOLTOTBO set USIDUSUA='"+hfUser.Value+"' where BOLIDBOL=@BOLIDBOL and bolstbol=0";
                    sqlUPDT = sqlUPDT.Replace("@BOLIDBOL", ID[i].ToString());
                    string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUPDT);
                    if (exec == "OK")
                    {
                        
                    }
                }
                if (Session["dtAprova"] != null && Session["sqlAprova"] != null)
                {
                    DataTable dt = DataBase.Consultas.Consulta(str_conn, Session["sqlAprova"].ToString());
                    Session["dtAprova"] = dt;
                    gridAprova.DataSource = dt;
                    gridAprova.DataBind();
                }
            }
        }
        protected void gridMonit_DataBinding(object sender, EventArgs e)
        {
            bool internet = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["AcessoInternet"]);
            if (internet)
            {
                sqlAprovacao.SelectCommand = "select TBIDUSER ID, TBUSUSER TEXTO from TBTBUSER " +
                        "union all " +
                        "select '0' ID, 'Pendente' TEXTO " +
                        "order by 1";
                sqlAprovacao.SelectCommandType = SqlDataSourceCommandType.Text;
                sqlAprovacao.DataBind();
            }
            else
            {
                sqlAprovacao.SelectCommand = "select USIDUSUA ID, USIDUSUA TEXTO from TUSUSUARI " +
                                            "union all " +
                                            "select '0' ID, 'Pendente' TEXTO " +
                                            "order by 1";
                sqlAprovacao.SelectCommandType = SqlDataSourceCommandType.Text;
                sqlAprovacao.DataBind();
            }
        }
        protected void gridMonit_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            if (e.ButtonType == ColumnCommandButtonType.SelectCheckbox)
            {
                string aprovacao = gridMonit.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString();
                if (aprovacao == "0")
                {                    
                    e.Enabled = false;
                }
            }
        }
        private bool getRowEnabledStatus(int VisibleIndex)
        {
            string CategoryID = gridMonit.GetRowValues(VisibleIndex, "USIDUSUA").ToString();
            return (CategoryID != "0") ? true : false;
        }
        protected void cbAll_Load(object sender, EventArgs e)
        {
            if (hfAllRows.Value == string.Empty) return;
            ASPxCheckBox chk = sender as ASPxCheckBox;
            chk.Checked = Convert.ToBoolean(hfAllRows.Value);
        }
        protected void btnSMSAprov_Click(object sender, EventArgs e)
        {
            CultureInfo culture = CultureInfo.GetCultureInfo(lang);
            WaApi wa = new WaApi(ConfigurationManager.AppSettings["CHAT-API_URL"], ConfigurationManager.AppSettings["CHAT-API_TOKEN"]);
            string textoSMS = string.Empty;
            for (int i = 0; i < gridMonit.VisibleRowCount; i++)
            {
                bool rowEnabled = getRowEnabledStatus(i);
                if (!rowEnabled)
                {
                    string valor = gridMonit.GetRowValues(i, "VALOR").ToString();
                    valor = lang == "en-US" ? valor.Replace(",", "") : valor.Replace(".", "").Replace(",", ".");
                    var result = DataBase.Consultas.Consulta(str_conn, "select N.NIIDAPRO,N.NINMAPRO,N.NIVL1APR,N.NIVL2APR,T.USNUMCEL from NIAPROVA N, VINIUSUA V, TUSUSUARI T WHERE N.NIIDAPRO=V.NIIDAPRO AND V.USIDUSUA=T.USIDUSUA AND " + valor+" between NIVL1APR and NIVL2APR", 5);
                    string loja = DataBase.Consultas.Consulta(str_conn, "select FO.FONMAB20 from TVESTRUT TV, FOFORNEC FO WHERE TV.TVIDESTR = FO.TVIDESTR AND FOTPIDTP=6 AND TV.TVIDESTR="+ gridMonit.GetRowValues(i, "TVIDESTR").ToString(), 1)[0];
                    string contrato = DataBase.Consultas.Consulta(str_conn, "select opcdcont from opcontra where opidcont=" + gridMonit.GetRowValues(i, "COD").ToString(), 1)[0];
                    DateTime vencimento = Convert.ToDateTime(gridMonit.GetRowValues(i, "DATA").ToString());
                    textoSMS += "Notificação enviado para grupo " + result[1] + " de aprovação.";
                    textoSMS += "<BR />";
                    if(result[4]!=null)
                        wa.SendWhats(result[4], string.Format("*Monitoramento > Contas a Pagar*\n*Loja*:{0}\n*Contrato*:{1}\n*Vencimento*:{2}\nEstá pendente de aprovação.",loja,contrato,vencimento.ToShortDateString()));
                }

            }
            //MsgException(textoSMS, 2);        
        }
        protected void gridAprova_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
        protected void gridMonit_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
        public void downloadStream(string filename, string filepath)
        {
            FileStream fs = null;
            long fsize = 0;
            byte[] buffer = null;
            try
            {
                if (File.Exists(filepath))
                    fs = new FileStream(filepath, FileMode.Open);

                if (fs != null)
                {
                    fsize = fs.Length;
                    buffer = new byte[(int)fsize];
                    fs.Read(buffer, 0, (int)fsize);
                }
                Response.ClearHeaders();
                Response.ClearContent();
                Response.Clear();
                Response.ContentType = "application/octet-stream";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + filename);
                //file is being downloaded as a stream of bytes(binary form).
                Response.BinaryWrite(buffer);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            { throw new Exception(ex.Message); }
            finally
            {
                fs.Close();
                //Delete the temporary zip file irrespective of the result.
                if (File.Exists(filepath))
                { File.Delete(filepath); }
            }
        }
    }
}