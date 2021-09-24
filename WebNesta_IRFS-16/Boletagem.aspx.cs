using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using WebNesta_IRFS_16.Utils;

namespace WebNesta_IRFS_16
{
    public partial class Boletagem : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static string perfil;
        public static bool AcessoInternet;
        protected void Page_Init(object sender, EventArgs e)
        {
            mvBoletagem.SetActiveView(this.vw_dataentry);

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
                radioExibir.Value = 1;
                mvBoletagem.ActiveViewIndex = Convert.ToInt32(radioExibir.Value) - 1;
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
                if (Session["dtNovaBoleta"] != null)
                {
                    Session["dtNovaBoleta"] = null;
                }               
            }
            if(Session["dtNovaBoleta"] != null)
            {
                DataTable dt = (DataTable)Session["dtNovaBoleta"] as DataTable;
                gridEntry.DataSource = dt;
                gridEntry.DataBind();
            }
            if (Session["dtFaturamento"] != null)
            {
                DataTable dt = (DataTable)Session["dtFaturamento"] as DataTable;
                gridFaturamento.DataSource = dt;
                gridFaturamento.DataBind();
            }
            if (Session["dtMedicao"] != null)
            {
                DataTable dt = (DataTable)Session["dtMedicao"] as DataTable;
                gridMedicao.DataSource = dt;
                gridMedicao.DataBind();
            }
            //Bind the grid only once
            if (!IsPostBack)
                gridLeitura.DataBind();
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void MsgException(string msg, int exc, string curr = "")
        {
            if (exc == 1)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = "Exception: " + msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 0)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = false;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 2)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 3)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-sucess";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
            else if (exc == 4)
            {
                (this.Master.FindControl("lblMsgException") as Label).CssClass = "text-danger";
                (this.Master.FindControl("lblMsgException") as Label).Text = msg;
                (this.Master.FindControl("hfControle") as HiddenField).Value = "3";
                (this.Master.FindControl("hfCurrentPage") as HiddenField).Value = curr;
                (this.Master.FindControl("btnOK") as Button).Visible = true;
                (this.Master.FindControl("btnClose") as Button).Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "LaunchServerSide", "$(function() { openModal(); });", true);
            }
        }
        protected void gridVerbas_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach(var item in e.InsertValues)
            {
                string moidmoda = item.NewValues["moidmoda"].ToString();
                string data = DateTime.Now.ToString("dd/MM/yyyy");
                string valor = item.NewValues["valor"].ToString().Replace(",", ".");
                string opidcont = item.NewValues["opidcont"].ToString();
                string usidusua = hfUser.Value;
                string data_venc = Convert.ToDateTime(item.NewValues["data_venc"].ToString()).ToString("dd/MM/yyyy");
                string bolidbol = item.NewValues["bolidbol"] == null ? "NULL" : item.NewValues["bolidbol"].ToString();
                string sqlInsert = "INSERT INTO BOLVERBA (moidmoda,BVDTTRAN,BVVLVERB,BVVALIDA,opidcont,BVAPROVA,BVDTVENC,bolidbol,usidusua) " +
     "VALUES(@moidmoda, convert(date, '@BVDTTRAN', 103), @BVVLVERB, 0, @opidcont, 0, convert(date, '@BVDTVENC', 103), @bolidbol, '@usidusua')";
                sqlInsert = sqlInsert.Replace("@moidmoda",moidmoda);
                sqlInsert = sqlInsert.Replace("@BVDTVENC", data_venc);
                sqlInsert = sqlInsert.Replace("@BVDTTRAN", data);
                sqlInsert = sqlInsert.Replace("@BVVLVERB", valor);
                sqlInsert = sqlInsert.Replace("@opidcont", opidcont);                
                sqlInsert = sqlInsert.Replace("@bolidbol", bolidbol);
                sqlInsert = sqlInsert.Replace("@usidusua", usidusua);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if (exec == "OK")
                {
                    gridVerbas.DataBind();
                }
            }
            foreach (var item in e.DeleteValues)
            {
                string idseq = item.Keys["idseq"].ToString();
                string sqlDelete = "DELETE FROM BOLVERBA WHERE BVIDSEQU=@BVIDSEQU";
                sqlDelete = sqlDelete.Replace("@BVIDSEQU", idseq);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlDelete);
                if (exec == "OK")
                {
                    gridVerbas.DataBind();
                }
            }
            foreach (var item in e.UpdateValues)
            {
                string idseq = item.Keys["idseq"].ToString();
                //string opidcont = item.OldValues["opidcont"].ToString();
                string valor = item.NewValues["valor"].ToString().Replace(",",".");
                //string moidmoda = item.OldValues["moidmoda"].ToString();
                //string data_venc = Convert.ToDateTime(item.OldValues["data_venc"].ToString()).ToString("dd/MM/yyyy");
                //string bolidbol = item.NewValues["bolidbol"] == null ? item.OldValues["bolidbol"].ToString() : item.NewValues["bolidbol"].ToString();
                string sqlUpdate = "update BOLVERBA set BVVLVERB=@valor WHERE BVIDSEQU=@idseq";
                sqlUpdate = sqlUpdate.Replace("@idseq", idseq);
                //sqlUpdate = sqlUpdate.Replace("@opidcont", opidcont);
                sqlUpdate = sqlUpdate.Replace("@valor", valor.Replace(",","."));
                //sqlUpdate = sqlUpdate.Replace("@data_venc", data_venc);
                //sqlUpdate = sqlUpdate.Replace("@moidmoda", moidmoda);
                //sqlUpdate = sqlUpdate.Replace("@bolidbol", bolidbol);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlUpdate);
                if (exec == "OK")
                {
                    string IDBOLETA = DataBase.Consultas.Consulta(str_conn, "select BOLIDBOL from BOLVERBA where BVIDSEQU="+idseq, 1)[0];
                    decimal valorTotal = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, "SELECT sum(BVVLVERB) FROM BOLVERBA WHERE BOLIDBOL IN (select BOLIDBOL from BOLVERBA where BVIDSEQU="+idseq+")", 1)[0]);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, "UPDATE BOLTOTBO SET BOLVLBOL="+valorTotal+" where BOLIDBOL="+IDBOLETA);
                    gridVerbas.DataBind();
                }

            }
        }
        protected void gridVerbas_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            if (gridVerbas.VisibleRowCount > 0)
            {
                if (e.ButtonID == "fluxo")
                {
                    string sqlBases = "select CJIDCODI from VIOPMODA where OPIDCONT=" + gridVerbas.GetRowValues(e.VisibleIndex, "opidcont") + " and MOIDMODA=" + gridVerbas.GetRowValues(e.VisibleIndex, "moidmoda") + " and CHIDCODI is not null and CJIDCODI is not null";
                    var dtBases = DataBase.Consultas.Consulta(str_conn, sqlBases, 1)[0];
                    switch (dtBases)
                    {
                        case "25702"://Aluguel complementar
                            e.Enabled = true;
                            e.Visible = DevExpress.Utils.DefaultBoolean.True;
                            break;
                        default:
                            e.Enabled = false;
                            e.Visible = DevExpress.Utils.DefaultBoolean.False;
                            break;
                    }
                }
            }
        }
        protected void btnNovaVerba_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string sqlInsert = "INSERT INTO MODALIDA (MOIDMODA, MODSMODA, MOTPIDCA, MOFLPADR, MOCDMODA, MOIDORDE, MOIFRSMO, LAYIDCLA,MOTIPOVALO,MOTEMPMODA,MORECUPMOD,MOPERIOMOD) VALUES ((select max(moidmoda) + 1 from modalida),'@MODSMODA',10,1,NULL,0,@MOIFRSMO,@LAYIDCLA,@MOTIPOVALO,@MOTEMPMODA,@MORECUPMOD,'@MOPERIOMOD')";
                sqlInsert = sqlInsert.Replace("@MODSMODA", txtDesc.Text);
                sqlInsert = sqlInsert.Replace("@MOIFRSMO", dropIFRS.Value.ToString());
                sqlInsert = sqlInsert.Replace("@LAYIDCLA", dropClass.Value.ToString());
                sqlInsert = sqlInsert.Replace("@MOTIPOVALO", dropTipo.Value.ToString());
                sqlInsert = sqlInsert.Replace("@MOTEMPMODA", dropTempo.Value.ToString());
                sqlInsert = sqlInsert.Replace("@MORECUPMOD", dropRecupera.Value.ToString());
                sqlInsert = sqlInsert.Replace("@MOPERIOMOD", dropPeriodi.Value.ToString());
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if (exec == "OK")
                {
                    string MOIDMODA = DataBase.Consultas.Consulta(str_conn, "select max(moidmoda) from modalida", 1)[0];
                    string sqlVIOPMODA = "INSERT INTO VIOPMODA (OPIDCONT,MOIDMODA) VALUES (@OPIDCONT,@MOIDMODA)";
                    sqlVIOPMODA = sqlVIOPMODA.Replace("@OPIDCONT", dropContratos.Value.ToString());
                    sqlVIOPMODA = sqlVIOPMODA.Replace("@MOIDMODA", MOIDMODA);
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlVIOPMODA);
                    sqlVerbas.DataBind();
                    gridVerbas.DataBind();
                    txtDesc.Text = string.Empty;
                    dropIFRS.Value = -1;
                    dropClass.Value = string.Empty;
                    dropTipo.Value = string.Empty;
                    dropTempo.Value = string.Empty;
                    dropRecupera.Value = string.Empty;
                    dropPeriodi.Value = string.Empty;
                    popupNovaVerba.ShowOnPageLoad = false;
                }
            }
        }
        protected void reqDesc2_ServerValidate(object source, ServerValidateEventArgs args)
        {
            bool existe = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from modalida m where MOTPIDCA=10 and UPPER(MODSMODA)='" + txtDesc.Text.ToUpper() + "'", 1)[0]) == 0 ? false : true;
            if (existe)
            {
                args.IsValid = false;
                return;
            }
            else
            {
                args.IsValid = true;
                return;
            }
        }
        protected void gridVerbas_CustomDataCallback(object sender, DevExpress.Web.ASPxGridViewCustomDataCallbackEventArgs e)
        {
            string sql, sqlDia, sqlValor;
            float valorContrato;
            if (e.Parameters.ToString().Split('#')[0] == "moidmoda")
            {
                string sqlBases = "select CJIDCODI,MOIDMODA from VIOPMODA where OPIDCONT=" + e.Parameters.ToString().Split('#')[2] + " and CHIDCODI is not null and CJIDCODI is not null";
                var dtBases = DataBase.Consultas.Consulta(str_conn, sqlBases);
                foreach (DataRow row in dtBases.Rows)
                {
                    if (row[1].ToString() == e.Parameters.ToString().Split('#')[1])
                    {
                        switch (row[0].ToString())
                        {
                            case "25700":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + e.Parameters.ToString().Split('#')[2] + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + e.Parameters.ToString().Split('#')[2] + " and PHDTEVEN='" + sqlDia + "' and MOIDMODA=" + e.Parameters.ToString().Split('#')[1] + "";
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                                e.Result = "valor#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();

                                break;
                            case "25702":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + e.Parameters.ToString().Split('#')[2] + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold = "select CJTPCTTX from CJCLPROP where CJIDCODI=25702";
                                string result = DataBase.Consultas.Consulta(str_conn, sqlValorold, 1)[0];
                                string codConvert = lang == "en-US" ? "101" : "103";
                                result = result.Replace("@p_opidcont", e.Parameters.ToString().Split('#')[2]);
                                result = result.Replace("@p_date", "'"+sqlDia+"'");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result, 1)[0]);
                                e.Result = "valor#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                            case "25703":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + e.Parameters.ToString().Split('#')[2] + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold2 = "select CJTPCTTX from CJCLPROP where CJIDCODI=25703";
                                string result2 = DataBase.Consultas.Consulta(str_conn, sqlValorold2, 1)[0];
                                string codConvert2 = lang == "en-US" ? "101" : "103";
                                result2 = result2.Replace("@p_opidcont", e.Parameters.ToString().Split('#')[2]);
                                result2 = result2.Replace("@p_date", "'" + sqlDia + "'");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result2, 1)[0]);
                                e.Result = "valor#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                        }
                    }
                }
            }
            else if(e.Parameters.ToString().Split('#')[0] == "bolidbol")
            {
                string dataVenct = DataBase.Consultas.Consulta(str_conn, "select convert(date,BOLDTVCT) from BOLTOTBO where BOLIDBOL="+ e.Parameters.ToString().Split('#')[1], 1)[0];
                e.Result = "data_venc#" + dataVenct;
            }
        }
        protected void gridVerbas_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            if (e.ButtonID == "fluxo")
            {
                DateTime dtVenc = Convert.ToDateTime(gridVerbas.GetRowValues(Convert.ToInt32(e.VisibleIndex), "data_venc").ToString());
                DateTime dt1 = new DateTime(dtVenc.Year, dtVenc.Month, 01);
                DateTime dt2 = dt1.AddMonths(1).AddDays(-1);
                string opidcont = gridVerbas.GetRowValues(Convert.ToInt32(e.VisibleIndex), "opidcont").ToString();
                string data1 = dt1.ToString("dd/MM/yyyy");
                string data2 = dt2.ToString("dd/MM/yyyy");
                string sql = "select convert(datetime,FLDTAFLX) AS FLDTAFLX,FLVALBRT,FLVALLIQ from FLDIAFLX where opidcont="+opidcont+" "+
                            "and FLDTAFLX >= convert(date, '"+data1+"', 103) "+
                            "and FLDTAFLX <= convert(date, '"+data2+"', 103)";
                var dtFaturamento = DataBase.Consultas.Consulta(str_conn, sql);
                Session["dtFaturamento"] = dtFaturamento;
                gridFaturamento.DataSource = dtFaturamento;
                gridFaturamento.DataBind();
                gridVerbas.JSProperties.Add("cpIsCustomCallback", null);
                gridVerbas.JSProperties["cpIsCustomCallback"] = "CustomCallbackFluxo";
            }
        }
        protected void radioExibir_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtCompet.Text = "";
            mvBoletagem.ActiveViewIndex = Convert.ToInt32(radioExibir.Value)-1;
        }
        protected void CustomValidator1_ServerValidate(object source, ServerValidateEventArgs args)
        {
            bool existe = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from BOLTOTBO where upper(BOLNMBOL)='" + txtNomeBoleto.Text.ToUpper() + "' and OPIDCONT="+ dropContratosBoleto.Value.ToString() + "", 1)[0]) > 0;
            if (existe)
            {
                args.IsValid = false;
                return;
            }
            else
            {
                args.IsValid = true;
                return;
            }
        }
        protected void txtCompet_ValueChanged(object sender, EventArgs e)
        {
            sqlAuditoria.SelectParameters[1].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("dd/MM/yyyy");
            sqlAuditoria.SelectParameters[2].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("dd/MM/yyyy");
        }
        protected void gridAuditoria_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.ButtonID == "aprovar")
            {
                int valida = Convert.ToInt32(gridAuditoria.GetRowValues(e.VisibleIndex, "valida"));
                if (valida == 1)
                {
                    e.Enabled = false;
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
            else if (e.ButtonID == "rejeitar")
            {
                int valida = Convert.ToInt32(gridAuditoria.GetRowValues(e.VisibleIndex, "valida"));
                if (valida == 0)
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                    e.Enabled = false;
                }
            }
        }
        protected void gridAuditoria_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string idseq = gridAuditoria.GetRowValues(e.VisibleIndex, "idseq").ToString();
            string sqlUpdate = string.Empty;
            string exec = string.Empty;
            switch (e.ButtonID)
            {
                case "aprovar":
                    sqlUpdate = "update BOLVERBA set BVVALIDA=1 where BVIDSEQU=@idseq";
                    sqlUpdate = sqlUpdate.Replace("@idseq", idseq);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if (exec == "OK")
                    {
                        gridAuditoria.DataBind();
                    }
                    break;
                case "rejeitar":
                    sqlUpdate = "update BOLVERBA set BVVALIDA=0,BVAPROVA=0 where BVIDSEQU=@idseq";
                    sqlUpdate = sqlUpdate.Replace("@idseq", idseq);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);                    
                    if (exec == "OK")
                    {
                        sqlUpdate = "UPDATE BOLTOTBO SET USIDUSUA='0' where BOLIDBOL in (select BOLIDBOL from BOLVERBA where BVIDSEQU=@idseq)";
                        sqlUpdate = sqlUpdate.Replace("@idseq", idseq);
                        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                        gridAuditoria.DataBind();
                    }
                    break;
            }
        }
        protected void callbackMask_Callback1(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            string id = e.Parameter.Split('#')[0];
            string controle = e.Parameter.Split('#')[1];
            if (controle == "listLayout")
            {
                if (listLeitura.Value == null)
                    return;
                if (listLeitura.Value.ToString() == "2")
                {
                    switch (listLayout.Value.ToString())
                    {
                        case "1":
                            txtCodBarras.MaskSettings.Mask = "00000000000-0 00000000000-0 00000000000-0 00000000000-0";
                            txtCodBarras.MaskSettings.IncludeLiterals = DevExpress.Web.MaskIncludeLiteralsMode.None;
                            break;
                        case "2":
                            txtCodBarras.MaskSettings.Mask = @"00000\.00000 00000\.000000 00000\.000000 0 00000000000000";
                            txtCodBarras.MaskSettings.IncludeLiterals = DevExpress.Web.MaskIncludeLiteralsMode.DecimalSymbol;
                            break;
                    }
                }
                else if (listLeitura.Value.ToString() == "1")
                {
                    txtCodBarras.MaskSettings.Mask = "000000000000000000000000000000000000000000000000";
                    txtCodBarras.MaskSettings.IncludeLiterals = DevExpress.Web.MaskIncludeLiteralsMode.None;
                }
            }
            else if(controle == "listLeitura")
            {
                if (listLayout.Value == null)
                    return;
                if (listLeitura.Value.ToString() == "2")
                {
                    switch (listLayout.Value.ToString())
                    {
                        case "1":
                            txtCodBarras.MaskSettings.Mask = "00000000000-0 00000000000-0 00000000000-0 00000000000-0";
                            txtCodBarras.MaskSettings.IncludeLiterals = DevExpress.Web.MaskIncludeLiteralsMode.None;
                            break;
                        case "2":
                            txtCodBarras.MaskSettings.Mask = @"00000\.00000 00000\.000000 00000\.000000 0 00000000000000";
                            txtCodBarras.MaskSettings.IncludeLiterals = DevExpress.Web.MaskIncludeLiteralsMode.DecimalSymbol;
                            break;
                    }
                }
                else if (listLeitura.Value.ToString() == "1")
                {
                    txtCodBarras.MaskSettings.Mask = "000000000000000000000000000000000000000000000000";
                    txtCodBarras.MaskSettings.IncludeLiterals = DevExpress.Web.MaskIncludeLiteralsMode.None;
                }
            }
            txtCodBarras.Enabled = true;
        }
        protected void btnNextBoleto_Click(object sender, EventArgs e)
        {
            int VITPPGTO = 0;
            switch (dropFormPagt.Value)
            {
                case "B": //Boleto
                    VITPPGTO = 1;
                    break;

                case "T": //Deposito
                    VITPPGTO = 2;
                    break;
                case "D": //Debito em conta
                    VITPPGTO = 3;
                    break;
            }
            txtCodBarras.Text = hfBoleto.Value;
            txtCodBarras.Enabled = false;
            txtBoletoTotal.Enabled = false;
            dropContratosBoleto.Enabled = false;
            txtNomeBoleto.Enabled = false;
            dropLoja2.Enabled = false;
            dropFormPagt.Enabled = false;
            txtDtVenc.Enabled = false;
            DateTime dtVenc = Convert.ToDateTime(txtDtVenc.Text);
            listLayout.Enabled = false;
            DataTable dt = new DataTable();
            dt.Columns.Add("ID");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "valor";
            dc.DataType = System.Type.GetType("System.Decimal");
            dt.Columns.Add(dc);
            dt.Columns.Add("moidmoda");
            DataRow dr;
            int cont = 1;
            foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select MOIDMODA,CJIDCODI from VIOPMODA where VITPPGTO="+ VITPPGTO + " AND OPIDCONT=" + dropContratosBoleto.Value.ToString() + " ").Rows)
            {
                dr = dt.NewRow();
                dr["ID"] = DateTime.Now.ToString("ddMMyyHHmmss") + cont.ToString();
                switch(row[1].ToString())
                {
                    case "25700":
                        //string sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        //string sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        //string sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and PHDTEVEN=convert(date,'" + Convert.ToDateTime(sqlDia).ToString("dd/MM/yyyy") + "',103) and MOIDMODA=" + row[0].ToString() + "";
                        //float valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                        //dr["valor"] = valorContrato;
                        string sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        LogWriter log = new LogWriter(sql);
                        string sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        string sqlValorold = "select CJTPCTTX from CJCLPROP where CJTPCTTX is not null and CJIDCODI=25700";
                        string result = DataBase.Consultas.Consulta(str_conn, sqlValorold, 1)[0];
                        LogWriter log2 = new LogWriter(result);
                        string codConvert = lang == "en-US" ? "101" : "103";
                        result = result.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                        result = result.Replace("@p_date", "convert(datetime,'" + sqlDia + "',103)");
                        float valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result, 1)[0]);
                        dr["valor"] = valorContrato;
                        break;
                    case "25701":
                        sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        string sqlValorFix = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and PHDTEVEN=convert(date,'" + Convert.ToDateTime(sqlDia).ToString("dd/MM/yyyy") + "',103) and MOIDMODA=" + row[0].ToString() + "";
                        float valorContratoFix = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValorFix, 1)[0]);
                        dr["valor"] = valorContratoFix;
                        break;
                    case "25702":
                        sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        sqlValorold = "select CJTPCTTX from CJCLPROP where CJIDCODI=25702";
                        result = DataBase.Consultas.Consulta(str_conn, sqlValorold, 1)[0];
                        codConvert = lang == "en-US" ? "101" : "103";
                        result = result.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                        result = result.Replace("@p_date", "convert(datetime,'" + sqlDia + "',103)");
                        valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result, 1)[0]);
                        dr["valor"] = valorContrato;
                        break;
                    case "25703":
                        sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + dtVenc.Month + "/" + dtVenc.Year + "',103) Data_Verba";
                        sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                        string sqlValorold2 = "select CJTPCTTX from CJCLPROP where CJIDCODI=25703";
                        string result2 = DataBase.Consultas.Consulta(str_conn, sqlValorold2, 1)[0];
                        string codConvert2 = lang == "en-US" ? "101" : "103";
                        result2 = result2.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                        result2 = result2.Replace("@p_date", "convert(datetime,'" + sqlDia + "',103)");
                        valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result2, 1)[0]);
                        dr["valor"] = valorContrato;
                        break;
                    default:
                        dr["valor"] = 0;
                        break;
                }              
                dr["moidmoda"] = row[0].ToString();
                dt.Rows.Add(dr);
                cont++;
            }
            
            sqlVerbas2.SelectParameters[0].DefaultValue = hfOpidcont.Value;
            sqlVerbas2.DataBind();
            Session["dtNovaBoleta"] = dt;
            gridEntry.DataSource = dt;
            gridEntry.DataBind();
        }
        protected void gridEntry_CustomDataCallback(object sender, DevExpress.Web.ASPxGridViewCustomDataCallbackEventArgs e)
        {
            string sql, sqlDia, sqlValor;
            float valorContrato;
            if (e.Parameters.ToString().Split('#')[0] == "moidmoda")
            {
                string sqlBases = "select CJIDCODI,MOIDMODA from VIOPMODA where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and CHIDCODI is not null and CJIDCODI is not null";
                var dtBases = DataBase.Consultas.Consulta(str_conn, sqlBases);
                foreach (DataRow row in dtBases.Rows)
                {
                    if (row[1].ToString() == e.Parameters.ToString().Split('#')[1])
                    {
                        switch (row[0].ToString())
                        {
                            case "25700":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + dropContratosBoleto.Value.ToString() + " and PHDTEVEN='" + sqlDia + "' and MOIDMODA=" + e.Parameters.ToString().Split('#')[1] + "";
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                                e.Result = "valor2#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                            case "25702":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold = "select CJTPCTTX from CJCLPROP where CJIDCODI=25702";
                                string result = DataBase.Consultas.Consulta(str_conn, sqlValorold, 1)[0];
                                string codConvert = lang == "en-US" ? "101" : "103";
                                result = result.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                                result = result.Replace("@p_date", "'" + sqlDia + "'");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result, 1)[0]);
                                e.Result = "valor2#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                            case "25703":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + dropContratosBoleto.Value.ToString() + ",264),2,'0')+'" + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold2 = "select CJTPCTTX from CJCLPROP where CJIDCODI=25703";
                                string result2 = DataBase.Consultas.Consulta(str_conn, sqlValorold2, 1)[0];
                                string codConvert2 = lang == "en-US" ? "101" : "103";
                                result2 = result2.Replace("@p_opidcont", dropContratosBoleto.Value.ToString());
                                result2 = result2.Replace("@p_date", "'" + sqlDia + "'");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result2, 1)[0]);
                                e.Result = "valor2#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                        }
                    }
                }
            }
        }
        protected void gridEntry_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            if (Session["dtNovaBoleta"] != null)
            {
                DataTable dt = (DataTable)Session["dtNovaBoleta"] as DataTable;                
                DataRow dr;
                int cont = 1;
                Decimal fTotal = Convert.ToDecimal(txtBoletoTotal.Text);
                Decimal fParcial = 0;
                foreach (var item in e.InsertValues)
                {
                    dr = dt.NewRow();
                    dr["ID"] = DateTime.Now.ToString("ddMMyyHHmmss")+cont.ToString();
                    dr["valor"] = item.NewValues["valor"].ToString();
                    dr["moidmoda"] = item.NewValues["moidmoda"].ToString();
                    dt.Rows.Add(dr);
                    cont++;
                }
                foreach(var item in e.DeleteValues)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID"].ToString() == item.Keys["ID"].ToString())
                            dr.Delete();
                    }
                    dt.AcceptChanges();
                }
                foreach(var item in e.UpdateValues)
                {
                    string valor = item.NewValues["valor"]==null?item.OldValues["valor"].ToString():item.NewValues["valor"].ToString();
                    string moidmoda = item.NewValues["moidmoda"] ==null?item.OldValues["moidmoda"].ToString():item.NewValues["moidmoda"].ToString();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID"].ToString() == item.Keys["ID"].ToString())
                        {
                            dr["valor"] = valor;
                            dr["moidmoda"] = moidmoda;
                        }
                    }
                    dt.AcceptChanges();
                }
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dr = dt.Rows[i];
                    fParcial += Convert.ToDecimal(dr["valor"].ToString());
                }
                if (dt.Rows.Count == 0)
                {
                    txtBoletoTotal.ForeColor = System.Drawing.Color.DimGray;
                    lblErroTotal.Text = string.Empty;
                }
                else
                {
                    if (fTotal != fParcial)
                    {
                        lblErroTotal.Text = "Valores boletados não batem com total.";
                        txtBoletoTotal.ForeColor = System.Drawing.Color.Red;
                    }
                    else
                    {
                        txtBoletoTotal.ForeColor = System.Drawing.Color.DimGray;
                        lblErroTotal.Text = string.Empty;
                    }
                }
                Session["dtNovaBoleta"] = dt;
                gridEntry.DataSource = dt;
                gridEntry.DataBind();
            }
        }
        protected void btnGravarBoleto_Click1(object sender, EventArgs e)
        {
            if (Session["dtNovaBoleta"] != null)
            {
                DataTable dt = (DataTable)Session["dtNovaBoleta"] as DataTable;
                if (Page.IsValid)
                {
                    string BOLCDBOL = dropFormPagt.Value.ToString() == "B" ? "'" + txtCodBarras.Text.Replace(" ", "").Replace("-", "").Replace(".", "") + "'" : DateTime.Now.ToString("ddMMyyHHmmss");
                    string BOLDTVCT = Convert.ToDateTime(txtDtVenc.Text).ToString("dd/MM/yyyy");
                    float valortotal = 0;
                    foreach(DataRow row in dt.Rows)
                    {
                        valortotal = valortotal + (float)Convert.ToDecimal(row["valor"].ToString());
                    }
                    //string BOLVLBOL = txtBoletoTotal.Text.Replace(".", "").Replace(",", ".");
                    string BOLVLBOL = valortotal.ToString().Replace(".", "").Replace(",", ".");
                    string BOLNMBOL = txtNomeBoleto.Text;
                    string OPIDCONT = dropContratosBoleto.Value.ToString();
                    string BOLTPBOL = dropFormPagt.Value.ToString();
                    string sqlInsert = "INSERT INTO BOLTOTBO(BOLCDBOL,BOLDTVCT,BOLVLBOL,BOLNMBOL,OPIDCONT,BOLTPBOL,BOLSTBOL) " +
                                        "VALUES(@BOLCDBOL, convert(date, '@BOLDTVCT', 103), @BOLVLBOL, '@BOLNMBOL', @OPIDCONT,'@BOLTPBOL',0)";
                    sqlInsert = sqlInsert.Replace("@BOLCDBOL", BOLCDBOL);
                    sqlInsert = sqlInsert.Replace("@BOLDTVCT", BOLDTVCT);
                    sqlInsert = sqlInsert.Replace("@BOLVLBOL", BOLVLBOL);
                    sqlInsert = sqlInsert.Replace("@BOLNMBOL", BOLNMBOL);
                    sqlInsert = sqlInsert.Replace("@OPIDCONT", OPIDCONT);
                    sqlInsert = sqlInsert.Replace("@BOLTPBOL", BOLTPBOL);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        for(int i=0;i<dt.Rows.Count;i++)
                        {
                            DataRow dr = dt.Rows[i];
                            string moidmoda = dr["moidmoda"].ToString();
                            string data = DateTime.Now.ToString("dd/MM/yyyy");
                            string valor = dr["valor"].ToString().Replace(",", ".");
                            string opidcont = OPIDCONT;
                            string usidusua = hfUser.Value;
                            string data_venc = BOLDTVCT;
                            string bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(BOLIDBOL) from BOLTOTBO where BOLDTVCT=convert(date,'"+ BOLDTVCT + "',103) and OPIDCONT="+ OPIDCONT, 1)[0];
                            string sqlInsert2 = "INSERT INTO BOLVERBA (moidmoda,BVDTTRAN,BVVLVERB,BVVALIDA,opidcont,BVAPROVA,BVDTVENC,bolidbol,usidusua,BVFLFLAG) " +
                 "VALUES(@moidmoda, convert(date, '@data', 103), @valor, 0, @opidcont, 0, convert(date, '@data_venc', 103), @bolidbol, '@usidusua',15)";
                            sqlInsert2 = sqlInsert2.Replace("@moidmoda", moidmoda);
                            sqlInsert2 = sqlInsert2.Replace("@data_venc", data_venc);
                            sqlInsert2 = sqlInsert2.Replace("@data", data);
                            sqlInsert2 = sqlInsert2.Replace("@valor", valor);
                            sqlInsert2 = sqlInsert2.Replace("@opidcont", opidcont);
                            sqlInsert2 = sqlInsert2.Replace("@bolidbol", bolidbol);
                            sqlInsert2 = sqlInsert2.Replace("@usidusua", usidusua);
                            exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert2);
                            if (exec == "OK")
                            {
                                sqlBoletos.DataBind();
                                gridVerbas.DataBind();
                                Session["dtNovaBoleta"] = null;
                                gridEntry.DataSource = null;
                                gridEntry.DataBind();
                                listLayout.SelectedIndex = -1;
                                listLeitura.SelectedIndex = -1;
                                txtCodBarras.Enabled = true;
                                txtCodBarras.Text = string.Empty;
                                txtBoletoTotal.Enabled = true;
                                dropContratosBoleto.Enabled = true;
                                txtNomeBoleto.Enabled = true;
                                dropLoja2.Enabled = true;
                                dropFormPagt.Enabled = true;
                                txtDtVenc.Enabled = true;
                                listLayout.Enabled = true;
                            }
                        }
                        popupNovoBoleto.ShowOnPageLoad = false;
                    }
                }
            }
        }
        protected void btnLimparBoleto_Click(object sender, EventArgs e)
        {
            hfBoleto.Value = string.Empty;
            txtCodBarras.Text = string.Empty;
            txtCodBarras.Enabled = true;
            txtBoletoTotal.Enabled = true;
            txtBoletoTotal.Text = string.Empty;
            dropContratosBoleto.Enabled = true;
            dropContratosBoleto.Value = string.Empty;
            dropLoja2.Enabled = true;
            dropLoja2.Value = string.Empty;
            dropFormPagt.Enabled = true;
            dropFormPagt.Value = string.Empty;
            txtNomeBoleto.Enabled = true;
            txtNomeBoleto.Text = string.Empty;
            txtDtVenc.Enabled = true;
            txtDtVenc.Text = string.Empty;
            listLayout.Enabled = true;
            listLayout.Value = string.Empty;
            if (Session["dtNovaBoleta"] != null)
            {
                DataTable dt = (DataTable)Session["dtNovaBoleta"] as DataTable;
                dt = null;
                Session["dtNovaBoleta"] = null;
                gridEntry.DataSource = null;
                gridEntry.DataBind();
            }
        }
        protected void dropFormPagt_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch(dropFormPagt.Value)
            {
                case "B": //Boleto
                    listLayout.Value = null;
                    listLeitura.Value = null;
                    txtCodBarras.Text = string.Empty;
                    listLayout.Enabled = true;
                    listLeitura.Enabled = true;
                    txtCodBarras.Enabled = true;
                    RequiredFieldValidator10.Enabled = true;
                    break;

                case "T": //Deposito
                    listLayout.Value = null;
                    listLeitura.Value = null;
                    txtCodBarras.Text = string.Empty;
                    listLayout.Enabled = false;
                    listLeitura.Enabled = false;
                    txtCodBarras.Enabled = false;
                    RequiredFieldValidator10.Enabled = false;
                    break;
                case "D": //Debito em conta
                    listLayout.Value = null;
                    listLeitura.Value = null;
                    txtCodBarras.Text = string.Empty;
                    listLayout.Enabled = false;
                    listLeitura.Enabled = false;
                    txtCodBarras.Enabled = false;
                    RequiredFieldValidator10.Enabled = false;
                    break;
            }
        }
        protected void dropLoja_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlContratos2.SelectParameters[0].DefaultValue = dropLoja.Value.ToString();
            sqlContratos2.DataBind();
            dropContratos.DataBind();
            if (dropContratos.Items.Count == 1)
            {
                dropContratos.Value = dropContratos.Items[0];
            }
            else if (dropContratos.Items.Count > 1)
            {
                dropContratos.Value = string.Empty;
            }
        }
        protected void dropLoja2_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlContratos2.SelectParameters[0].DefaultValue = dropLoja2.Value.ToString();
            sqlContratos2.DataBind();
            dropContratosBoleto.DataBind();
            if (dropContratosBoleto.Items.Count == 1)
            {
                dropContratosBoleto.Value = dropContratosBoleto.Items[0];
                hfOpidcont.Value = dropContratosBoleto.Items[0].Value.ToString();
            }
            else if (dropContratosBoleto.Items.Count > 1)
            {
                dropContratosBoleto.Value = string.Empty;
            }
        }
        protected void btnLeitura_Click(object sender, EventArgs e)
        {
            bool ok=false;
            bool erro=false;
            bool duplicado=false;
            string dir = @"C:\LeituraXML";
            var dirInfo = new DirectoryInfo(dir);
            var list = dirInfo.GetFiles("*.xml");
            string BOLNMBOL, OPIDCONT, BOLDTVCT, BOLCDBOL, BOLVLBOL;
            string despesas,exec;
            string moidmoda, data, valor, opidcont, data_venc, bolidbol, usidusua;
            if (list.Length > 0)
            {
                foreach (var file in list)
                {
                    string sqlBoleto = "INSERT INTO BOLTOTBO(BOLCDBOL, BOLDTVCT, BOLVLBOL, BOLNMBOL, OPIDCONT, BOLSTBOL, BOLTPBOL) " +
                    "VALUES('@BOLCDBOL', convert(date, '@BOLDTVCT', 103), @BOLVLBOL, '@BOLNMBOL', @OPIDCONT, 0, 'B')";
                    
                    var reader = XmlReader.Create(file.FullName);
                    reader.ReadToFollowing("OCUPACAO");
                    do
                    {
                        reader.MoveToFirstAttribute();

                        reader.ReadToFollowing("ocupacaoReferencia"); //Nome Boleto
                        BOLNMBOL = reader.ReadElementContentAsString();

                        reader.ReadToFollowing("ocupacaoDivisao"); //Código da Loja no Contrato
                        string contrato = DataBase.Consultas.Consulta(str_conn, "select opidcont from OPCONTRA where OPCDCONT='" + reader.ReadElementContentAsString() + "'", 1)[0];
                        OPIDCONT = contrato==string.Empty? string.Empty:contrato;
                        opidcont = contrato==string.Empty? string.Empty:contrato;

                        reader.ReadToFollowing("ocupacaoDataVencimto"); //Data Vencimento DD/MM/YYYY
                        DateTime dt_venc = Convert.ToDateTime(reader.ReadElementContentAsString(),CultureInfo.GetCultureInfo("pt-BR"));
                        BOLDTVCT = dt_venc.ToString("dd/MM/yyyy");
                        data_venc = dt_venc.ToString("dd/MM/yyyy");

                        reader.ReadToFollowing("ocupacaoCodBarras"); //Código de Barra do boleto (apenas número)
                        BOLCDBOL = reader.ReadElementContentAsString();

                        reader.ReadToFollowing("ocupacaoValorTotal"); //Valor total do boleto
                        BOLVLBOL = reader.ReadElementContentAsString();

                        duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from BOLTOTBO where BOLCDBOL='" + BOLCDBOL + "'", 1)[0]) > 0;
                        if(duplicado)
                        {
                            break;
                        }
                        reader.ReadToFollowing("ocupacaoDescDespesas"); //Array Split(;) Verba ; Valor
                        despesas = reader.ReadElementContentAsString();
                        despesas = despesas.Substring(1);
                        sqlBoleto = sqlBoleto.Replace("@BOLCDBOL", BOLCDBOL);
                        sqlBoleto = sqlBoleto.Replace("@BOLDTVCT", BOLDTVCT);
                        sqlBoleto = sqlBoleto.Replace("@BOLVLBOL", BOLVLBOL.Replace(",","."));
                        sqlBoleto = sqlBoleto.Replace("@BOLNMBOL", BOLNMBOL);
                        sqlBoleto = sqlBoleto.Replace("@OPIDCONT", OPIDCONT);
                        exec = DataBase.Consultas.InsertInto(str_conn, sqlBoleto);
                        if(exec=="OK")
                        {
                            bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(bolidbol) from BOLTOTBO", 1)[0];
                            var arrayDespesas = despesas.Split(';');
                            for (int i = 0; i < arrayDespesas.Length; i++)
                            {
                                Decimal Val = 0;
                                if (!Decimal.TryParse(arrayDespesas[i],NumberStyles.Float, CultureInfo.GetCultureInfo("pt-BR"), out Val))
                                {
                                    string sqlVerba = "INSERT INTO BOLVERBA(moidmoda,BVDTTRAN,BVVLVERB,BVVALIDA,opidcont,BVAPROVA,BVDTVENC,bolidbol,usidusua) " +
            "VALUES(@moidmoda, convert(date, '@data', 103), @valor, 1, @opidcont, 0, convert(date, '@data_venc', 103), @bolidbol, '@usidusua')";
                                    moidmoda = DataBase.Consultas.Consulta(str_conn, "select moidmoda from vimodxml where vitxtxml='" + arrayDespesas[i] + "'", 1)[0];
                                    valor = arrayDespesas[i + 1].Replace(",", ".");
                                    usidusua = hfUser.Value;
                                    data = DateTime.Now.ToString("dd/MM/yyyy");
                                    sqlVerba = sqlVerba.Replace("@moidmoda",moidmoda);
                                    sqlVerba = sqlVerba.Replace("@data_venc", data_venc);
                                    sqlVerba = sqlVerba.Replace("@data", data);
                                    sqlVerba = sqlVerba.Replace("@valor", valor.Replace(",","."));
                                    sqlVerba = sqlVerba.Replace("@opidcont", opidcont);                                    
                                    sqlVerba = sqlVerba.Replace("@bolidbol", bolidbol);
                                    sqlVerba = sqlVerba.Replace("@usidusua", usidusua);
                                    exec = DataBase.Consultas.InsertInto(str_conn, sqlVerba);
                                    if(exec=="OK")
                                    {
                                        ok = true;
                                    }
                                    else
                                    {
                                        erro = true;
                                        break;
                                    }
                                }
                            }
                        }
                        else
                        {
                            erro = true;
                            break;
                        }                       
                    } while (reader.ReadToFollowing("OCUPACAO"));
                    reader.Dispose();
                    if(duplicado)
                    {
                        string destino = Path.Combine(dir, "DUPLICADO", file.Name+DateTime.Now.ToString("ddMMyyyyHHmmssfff"));
                        File.Move(file.FullName, destino);
                    }
                    else if(ok)
                    {
                        string destino = Path.Combine(dir, "OK", file.Name);
                        File.Move(file.FullName, destino);
                    }
                    else if(erro)
                    {
                        string destino = Path.Combine(dir, "ERRO", file.Name + DateTime.Now.ToString("ddMMyyyyHHmmssfff"));
                        File.Move(file.FullName, destino);
                    }
                }
            }
        }
        protected DataTable GetXML()
        {
            string dir = @"C:\LeituraXML";
            var dirInfo = new DirectoryInfo(dir);
            var list = dirInfo.GetFiles("*.xml");
            DataTable dt = new DataTable();
            dt.Columns.Add("ID");
            dt.Columns.Add("Nome");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Data";
            dc.DataType = System.Type.GetType("System.DateTime");
            dt.Columns.Add(dc);
            dt.Columns.Add("KB");
            DataRow dr;
            int cont = 1;
            if (list.Length > 0)
            {
                foreach (var file in list)
                {
                    dr = dt.NewRow();
                    dr["ID"] = DateTime.Now.ToString("ddMMyyHHmmss") + cont.ToString();
                    dr["Nome"] = file.Name;
                    dr["Data"] = File.GetLastWriteTime(file.FullName);
                    dr["KB"] = file.Length / 1000;
                    dt.Rows.Add(dr);
                    cont++;
                }
            }
            return dt;
        }
        protected void gridLeitura_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters=="processar")
            {
                var ID = gridLeitura.GetSelectedFieldValues("Nome");
                bool ok = false;
                bool erro = false;
                bool duplicado = false;
                string dir = @"C:\LeituraXML";
                var dirInfo = new DirectoryInfo(dir);
                var list = dirInfo.GetFiles("*.xml");
                string BOLNMBOL, OPIDCONT, BOLDTVCT, BOLCDBOL, BOLVLBOL;
                string despesas, exec;
                string moidmoda, data, valor, opidcont, data_venc, bolidbol, usidusua;
                for (int j = 0; j < ID.Count; j++)
                {
                    var file = new FileInfo(Path.Combine(dir, ID[j].ToString()));
                    string sqlBoleto = "INSERT INTO BOLTOTBO(BOLCDBOL, BOLDTVCT, BOLVLBOL, BOLNMBOL, OPIDCONT, BOLSTBOL, BOLTPBOL) " +
                    "VALUES('@BOLCDBOL', convert(date, '@BOLDTVCT', 103), @BOLVLBOL, '@BOLNMBOL', @OPIDCONT, 0, 'B')";
                    var reader = XmlReader.Create(file.FullName);
                    reader.ReadToFollowing("OCUPACAO");
                    do
                    {
                        reader.MoveToFirstAttribute();

                        reader.ReadToFollowing("ocupacaoReferencia"); //Nome Boleto
                        BOLNMBOL = reader.ReadElementContentAsString();

                        reader.ReadToFollowing("ocupacaoDivisao"); //Código da Loja no Contrato
                        string contrato = DataBase.Consultas.Consulta(str_conn, "select opidcont from OPCONTRA where OPCDCONT='" + reader.ReadElementContentAsString() + "'", 1)[0];
                        OPIDCONT = contrato == string.Empty ? string.Empty : contrato;
                        opidcont = contrato == string.Empty ? string.Empty : contrato;

                        reader.ReadToFollowing("ocupacaoDataVencimto"); //Data Vencimento DD/MM/YYYY
                        DateTime dt_venc = Convert.ToDateTime(reader.ReadElementContentAsString(), CultureInfo.GetCultureInfo("pt-BR"));
                        BOLDTVCT = dt_venc.ToString("dd/MM/yyyy");
                        data_venc = dt_venc.ToString("dd/MM/yyyy");

                        reader.ReadToFollowing("ocupacaoCodBarras"); //Código de Barra do boleto (apenas número)
                        BOLCDBOL = reader.ReadElementContentAsString();

                        reader.ReadToFollowing("ocupacaoValorTotal"); //Valor total do boleto
                        BOLVLBOL = reader.ReadElementContentAsString();

                        duplicado = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select count(*) from BOLTOTBO where BOLCDBOL='" + BOLCDBOL + "'", 1)[0]) > 0;
                        if (duplicado)
                        {
                            break;
                        }
                        reader.ReadToFollowing("ocupacaoDescDespesas"); //Array Split(;) Verba ; Valor
                        despesas = reader.ReadElementContentAsString();
                        despesas = despesas.Substring(1);
                        sqlBoleto = sqlBoleto.Replace("@BOLCDBOL", BOLCDBOL);
                        sqlBoleto = sqlBoleto.Replace("@BOLDTVCT", BOLDTVCT);
                        sqlBoleto = sqlBoleto.Replace("@BOLVLBOL", BOLVLBOL.Replace(",", "."));
                        sqlBoleto = sqlBoleto.Replace("@BOLNMBOL", BOLNMBOL);
                        sqlBoleto = sqlBoleto.Replace("@OPIDCONT", OPIDCONT);
                        exec = DataBase.Consultas.InsertInto(str_conn, sqlBoleto);
                        if (exec == "OK")
                        {
                            bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(bolidbol) from BOLTOTBO", 1)[0];
                            var arrayDespesas = despesas.Split(';');
                            for (int i = 0; i < arrayDespesas.Length; i++)
                            {
                                Decimal Val = 0;
                                if (!Decimal.TryParse(arrayDespesas[i], NumberStyles.Float, CultureInfo.GetCultureInfo("pt-BR"), out Val))
                                {
                                    string sqlVerba = "INSERT INTO BOLVERBA(moidmoda,BVDTTRAN,BVVLVERB,BVVALIDA,opidcont,BVAPROVA,BVDTVENC,bolidbol,usidusua) " +
            "VALUES(@moidmoda, convert(date, '@data', 103), @valor, 1, @opidcont, 0, convert(date, '@data_venc', 103), @bolidbol, '@usidusua')";
                                    moidmoda = DataBase.Consultas.Consulta(str_conn, "select moidmoda from vimodxml where vitxtxml='" + arrayDespesas[i] + "'", 1)[0];
                                    valor = arrayDespesas[i + 1].Replace(",", ".");
                                    usidusua = hfUser.Value;
                                    data = DateTime.Now.ToString("dd/MM/yyyy");
                                    sqlVerba = sqlVerba.Replace("@moidmoda", moidmoda);
                                    sqlVerba = sqlVerba.Replace("@data_venc", data_venc);
                                    sqlVerba = sqlVerba.Replace("@data", data);
                                    sqlVerba = sqlVerba.Replace("@valor", valor.Replace(",", "."));
                                    sqlVerba = sqlVerba.Replace("@opidcont", opidcont);
                                    sqlVerba = sqlVerba.Replace("@bolidbol", bolidbol);
                                    sqlVerba = sqlVerba.Replace("@usidusua", usidusua);
                                    exec = DataBase.Consultas.InsertInto(str_conn, sqlVerba);
                                    if (exec == "OK")
                                    {
                                        ok = true;
                                    }
                                    else
                                    {
                                        erro = true;
                                        break;
                                    }
                                }
                            }
                        }
                        else
                        {
                            erro = true;
                            break;
                        }
                    } while (reader.ReadToFollowing("OCUPACAO"));
                    reader.Dispose();
                    if (duplicado)
                    {
                        string destino = Path.Combine(dir, "DUPLICADO", file.Name + DateTime.Now.ToString("ddMMyyyyHHmmssfff"));
                        File.Move(file.FullName, destino);
                    }
                    else if (ok)
                    {
                        string destino = Path.Combine(dir, "OK", file.Name);
                        File.Move(file.FullName, destino);
                    }
                    else if (erro)
                    {
                        string destino = Path.Combine(dir, "ERRO", file.Name + DateTime.Now.ToString("ddMMyyyyHHmmssfff"));
                        File.Move(file.FullName, destino);
                    }
                }
                gridLeitura.DataBind();
            }
        }
        protected void gridLeitura_DataBinding(object sender, EventArgs e)
        {
            //gridLeitura.DataSource = GetXML();
        }
        protected void gridAuditoria_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridViewTableRowEventArgs e)
        {
            
            if (e.RowType != GridViewRowType.Data) return;
            string sqlTeste = "select MOVARPER from MODALIDA where moidmoda = " + gridAuditoria.GetRowValues(e.VisibleIndex, "moidmoda").ToString();
            if (DataBase.Consultas.Consulta(str_conn, sqlTeste, 1)[0] == "0")
                return;
            string sql = "SELECT avg((f.BVVLVERB - f.BVVLVERB*(m.MOVARPER/100))) as min " +
                         ", avg((f.BVVLVERB + f.BVVLVERB * (m.MOVARPER / 100))) as max " +
                         "FROM MODALIDA M, bolverba f " +
                    "where M.MOIDMODA = @moidmoda AND F.moidmoda = M.MOIDMODA " +
                      "and f.opidcont = @opidcont " +
                      "and f.BVIDSEQU NOT IN(@idseq) " +
                      "and f.BVDTVENC between DATEADD(month, (M.MOVARTIM * -1), f.BVDTVENC) and f.BVDTVENC";
            sql = sql.Replace("@idseq", gridAuditoria.GetRowValues(e.VisibleIndex,"idseq").ToString());
            sql = sql.Replace("@opidcont", gridAuditoria.GetRowValues(e.VisibleIndex, "opidcont").ToString());
            sql = sql.Replace("@moidmoda", gridAuditoria.GetRowValues(e.VisibleIndex, "moidmoda").ToString());
            var result = DataBase.Consultas.Consulta(str_conn,sql,2);
            if (result[0] == "" || result[1] == "")
                return;
            decimal min = Convert.ToDecimal(result[0]);
            decimal max = Convert.ToDecimal(result[1]);
            decimal valor = Convert.ToDecimal(e.GetValue("valor").ToString());
            if(valor >= min & valor <= max)
            {
                e.Row.ToolTip = "";
                return;
            }
            else
            {                
                e.Row.ToolTip = "Valor está fora do limite variável. (mínimo: "+min.ToString("N2")+" e máximo:  "+max.ToString("N2")+")";
                e.Row.BackColor = System.Drawing.Color.Red;
                e.Row.ForeColor = System.Drawing.Color.White;
            }
            gridAuditoria.FocusedRowIndex = -1;
            //decimal vl = 0;
            //foreach (DataRow row in DataBase.Consultas.Consulta(str_conn, "select LAYIDCLA from LAYPDFCL where LAYIDENT <> 1").Rows)
            //{
            //    vl = vl + Convert.ToDecimal(e.GetValue(row[0].ToString()).ToString() == string.Empty ? "0" : e.GetValue(row[0].ToString()));
            //}
            //decimal tl = Convert.ToDecimal(e.GetValue("10"));
            //if (vl != tl)
            //{
            //    e.Row.ForeColor = System.Drawing.Color.LightGray;
            //}

        }
        protected void gridVerbas_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled= perfil != "3";
        }
        protected void gridAuditoria_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
        protected void gridToday_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
        protected void gridToday_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.DeleteValues)
            {
                string ID = item.Keys["idseq"].ToString();
                string sql = "DELETE FROM BOLAGEND WHERE BVIDSEQU=@BVIDSEQU";
                sql = sql.Replace("@BVIDSEQU", ID);
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
                if (exec == "OK")
                    gridToday.DataBind();
            }
            foreach (var item in e.UpdateValues)
            {
                string ID = item.Keys["idseq"].ToString();
                string BVDTVENC = item.NewValues["data_venc"] == null ? item.OldValues["data_venc"].ToString() : item.NewValues["data_venc"].ToString();
                string BVVLVERB = item.NewValues["valor"] == null ? item.OldValues["valor"].ToString() : item.NewValues["valor"].ToString();
                string sql = "UPDATE BOLAGEND SET BVDTVENC=CONVERT(DATE,'@BVDTVENC',103), BVVLVERB=@BVVLVERB WHERE BVIDSEQU=@BVIDSEQU";
                sql = sql.Replace("@BVIDSEQU", ID);
                sql = sql.Replace("@BVDTVENC", Convert.ToDateTime(BVDTVENC).ToString("dd/MM/yyyy"));
                sql = sql.Replace("@BVVLVERB", BVVLVERB.Replace(",","."));
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sql);
                if (exec == "OK")
                    gridToday.DataBind();
            }
        }
        protected void cbAll_Load(object sender, EventArgs e)
        {
            if (hfAllRows.Value == string.Empty) return;
            ASPxCheckBox chk = sender as ASPxCheckBox;
            chk.Checked = Convert.ToBoolean(hfAllRows.Value);
        }
        protected void gridToday_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "AllRows")
            {
                if (hfAllRows.Value != string.Empty)
                {
                    if (Convert.ToBoolean(hfAllRows.Value))
                    {
                        for (int i = 0; i < gridToday.VisibleRowCount; i++)
                        {
                            bool rowEnabled = getRowEnabledStatus(gridToday,i);
                            if (rowEnabled)
                                gridToday.Selection.SelectRow(i);
                            else
                                gridToday.Selection.UnselectRow(i);
                        }
                    }
                    else
                    {
                        gridToday.Selection.UnselectAll();
                    }
                }
            }
            if (e.Parameters == "processar")
            {
                var dataVenct = gridToday.GetSelectedFieldValues("data_venc");
                if (areSame(dataVenct))
                {
                    var ID = gridToday.GetSelectedFieldValues("idseq");
                    for (int i = 0; i < ID.Count; i++)
                    {

                    }
                }
                else
                {
                    MsgException("Para criar a Boletagem é necessário que as verbas tenham a mesma Data de Vencimento.", 1);
                }
            }
        }
        private bool getRowEnabledStatus(object sender, int VisibleIndex)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            string CategoryID = obj.GetRowValues(VisibleIndex, "usidusua").ToString();
            return (CategoryID != "0") ? true : false;
        }
        public static bool areSame(List<object> arr)
        {

            // Put all array elements in a HashSet 
            HashSet<object> s = new HashSet<object>();
            for (int i = 0; i < arr.Count; i++)
                s.Add(arr[i]);

            // If all elements are same, size of 
            // HashSet should be 1. As HashSet 
            // contains only distinct values. 
            return (s.Count == 1);
        }
        protected void btnConfirmar_Click(object sender, EventArgs e)
        {
            var dataVenct = gridToday.GetSelectedFieldValues("data_venc");
            var tipoBol = gridToday.GetSelectedFieldValues("VITPPGTO");
            var opidcont = gridToday.GetSelectedFieldValues("opidcont");
            if (areSame(dataVenct))
            {
                if (areSame(tipoBol))
                {
                    if (areSame(opidcont))
                    {
                        var ID = gridToday.GetSelectedFieldValues("idseq");
                        if (ID.Count > 0)
                        {
                            string sqlInsert = "INSERT INTO BOLTOTBO(BOLCDBOL,BOLDTVCT,BOLVLBOL,BOLNMBOL,OPIDCONT,BOLTPBOL,BOLSTBOL) " +
                                "VALUES(@BOLCDBOL, convert(date, '@BOLDTVCT', 103), @BOLVLBOL, '@BOLNMBOL', @OPIDCONT,'@BOLTPBOL',0)";
                            sqlInsert = sqlInsert.Replace("@BOLCDBOL", "0000");
                            sqlInsert = sqlInsert.Replace("@BOLNMBOL", DateTime.Now.ToString("MMMddyyyyss"));
                            decimal valorTotal = 0;
                            DateTime VencTotal = new DateTime();
                            string Contrato=string.Empty;
                            string TipoPagamento = string.Empty;
                            string[] sqlInsert2 = new string[ID.Count];
                            for (int i = 0; i < ID.Count; i++)
                            {
                                decimal valorVerba = 0;
                                valorVerba = Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, "select BVVLVERB from BOLVERBA where BVIDSEQU=" + ID[i], 1)[0]);
                                valorTotal += valorVerba;
                                VencTotal = Convert.ToDateTime(DataBase.Consultas.Consulta(str_conn, "select BVDTVENC from BOLVERBA where BVIDSEQU=" + ID[i], 1)[0]);
                                DateTime dtTran = new DateTime();
                                dtTran = Convert.ToDateTime(DataBase.Consultas.Consulta(str_conn, "select BVDTTRAN from BOLVERBA where BVIDSEQU=" + ID[i], 1)[0]);
                                Contrato = DataBase.Consultas.Consulta(str_conn, "select B.OPIDCONT from BOLVERBA B where BVIDSEQU=" + ID[i], 1)[0];
                                TipoPagamento = DataBase.Consultas.Consulta(str_conn, "select v.VITPPGTO from BOLVERBA B, VIOPMODA V where B.MOIDMODA=V.MOIDMODA AND BVIDSEQU=" + ID[i], 1)[0];
                                TipoPagamento = TipoPagamento == "1" ? "B" : TipoPagamento == "2" ? "T" : TipoPagamento == "3" ? "D" : "0";
                                sqlInsert2[i] = "UPDATE BOLVERBA SET BVFLFLAG=15, BOLIDBOL=@BOLIDBOL, USIDUSUA='@USIDUSUA' WHERE BVIDSEQU="+ ID[i];
                            }
                            sqlInsert = sqlInsert.Replace("@BOLVLBOL", valorTotal.ToString().Replace(",","."));
                            sqlInsert = sqlInsert.Replace("@BOLDTVCT", VencTotal.ToString("dd/MM/yyyy"));
                            sqlInsert = sqlInsert.Replace("@OPIDCONT", Contrato);
                            sqlInsert = sqlInsert.Replace("@BOLTPBOL", TipoPagamento);
                            string exec = DataBase.Consultas.InsertInto(str_conn,sqlInsert);
                            if(exec=="OK")
                            {
                                string bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(BOLIDBOL) from BOLTOTBO where BOLDTVCT=convert(date,'" + VencTotal.ToString("dd/MM/yyyy") + "',103) and OPIDCONT=" + Contrato, 1)[0];
                                for (int i = 0; i < sqlInsert2.Length; i++)
                                {
                                    sqlInsert2[i] = sqlInsert2[i].Replace("@BOLIDBOL", bolidbol);
                                    sqlInsert2[i] = sqlInsert2[i].Replace("@USIDUSUA", hfUser.Value);
                                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlInsert2[i]);   
                                }

                            }
                        }
                    }
                    else
                    {
                        MsgException("Para criar a Boletagem é necessário que as verbas sejam do mesmo Contrato", 1);
                    }
                }
                else
                {
                    MsgException("Para criar a Boletagem é necessário que as verbas tenham a mesma Forma de Pagamento.", 1);
                }
            }
            else
            {
                MsgException("Para criar a Boletagem é necessário que as verbas tenham a mesma Data de Vencimento.", 1);
            }
            gridToday.Selection.UnselectAll();
            gridToday.DataBind();
        }
        protected void dropLoja3_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlContratos2.SelectParameters[0].DefaultValue = dropLoja3.Value.ToString();
            sqlContratos2.DataBind();
            dropContratos3.DataBind();
            if (dropContratos3.Items.Count == 1)
            {
                dropContratos3.Value = dropContratos3.Items[0];
                hfOpidcont.Value = dropContratos3.Items[0].Value.ToString();
            }
            else if (dropContratos3.Items.Count > 1)
            {
                dropContratos3.Value = string.Empty;
            }
        }
        protected void gridDebiAuto_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "AllRows")
            {
                if (hfAllRows.Value != string.Empty)
                {
                    if (Convert.ToBoolean(hfAllRows.Value))
                    {
                        for (int i = 0; i < gridDebiAuto.VisibleRowCount; i++)
                        {
                                gridDebiAuto.Selection.SelectRow(i);
                        }
                    }
                    else
                    {
                        gridDebiAuto.Selection.UnselectAll();
                    }
                }
            }
        }
        protected void gridDebiAuto_Load(object sender, EventArgs e)
        {
            ASPxGridView obj = (ASPxGridView)sender;
            obj.Enabled = perfil != "3";
        }
        protected void btnConfirmar2_Click(object sender, EventArgs e)
        {
            var ID = gridDebiAuto.GetSelectedFieldValues("DAIDDEBI");
            if (ID.Count > 0)
            {
                for (int i = 0; i < ID.Count; i++)
                {
                    string BOLCDBOL, BOLVLBOL, BOLNMBOL, OPIDCONT, BOLTPBOL;
                    BOLCDBOL = "0000";
                    DateTime BOLDTVCT = Convert.ToDateTime(DataBase.Consultas.Consulta(str_conn, "select DADTLANC from DEBIAUTO where DAIDDEBI="+ID[i], 1)[0]);
                    BOLVLBOL = DataBase.Consultas.Consulta(str_conn, "select DAVALODA from DEBIAUTO where DAIDDEBI=" + ID[i], 1)[0];
                    BOLNMBOL = "DA_" + BOLDTVCT.ToString("MMddyyyy");
                    OPIDCONT = hfOpidcont.Value;
                    BOLTPBOL = "D";
                    string sqlInsert = "INSERT INTO BOLTOTBO(BOLCDBOL,BOLDTVCT,BOLVLBOL,BOLNMBOL,OPIDCONT,BOLTPBOL,BOLSTBOL) " +
    "VALUES(@BOLCDBOL, convert(date, '@BOLDTVCT', 103), @BOLVLBOL, '@BOLNMBOL', @OPIDCONT,'@BOLTPBOL',0)";
                    sqlInsert = sqlInsert.Replace("@BOLCDBOL", BOLCDBOL);
                    sqlInsert = sqlInsert.Replace("@BOLDTVCT", BOLDTVCT.ToString("dd/MM/yyyy"));
                    sqlInsert = sqlInsert.Replace("@BOLVLBOL", BOLVLBOL.Replace(",", "."));
                    sqlInsert = sqlInsert.Replace("@BOLNMBOL", BOLNMBOL);
                    sqlInsert = sqlInsert.Replace("@OPIDCONT", OPIDCONT);
                    sqlInsert = sqlInsert.Replace("@BOLTPBOL", BOLTPBOL);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        string moidmoda, valor, bolidbol;
                        moidmoda= DataBase.Consultas.Consulta(str_conn, "select MOIDMODA from DEBIAUTO where DAIDDEBI=" + ID[i], 1)[0];
                        valor = BOLVLBOL;
                        bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(BOLIDBOL) from BOLTOTBO where BOLDTVCT=convert(date,'" + BOLDTVCT + "',103) and OPIDCONT=" + OPIDCONT, 1)[0];
                        DateTime data = Convert.ToDateTime(DataBase.Consultas.Consulta(str_conn, "select DADTTRAN from DEBIAUTO where DAIDDEBI=" + ID[i], 1)[0]);
                        string sqlInsert2 = "INSERT INTO BOLVERBA (moidmoda,BVDTTRAN,BVVLVERB,BVVALIDA,opidcont,BVAPROVA,BVDTVENC,bolidbol,usidusua,BVFLFLAG) " +
    "VALUES(@moidmoda, convert(date, '@data', 103), @valor, 0, @opidcont, 0, convert(date, '@data_venc', 103), @bolidbol, '@usidusua',15)";
                        sqlInsert2 = sqlInsert2.Replace("@moidmoda", moidmoda);
                        sqlInsert2 = sqlInsert2.Replace("@data_venc", BOLDTVCT.ToString("dd/MM/yyyy"));
                        sqlInsert2 = sqlInsert2.Replace("@data", data.ToString("dd/MM/yyyy"));
                        sqlInsert2 = sqlInsert2.Replace("@valor", valor.Replace(",","."));
                        sqlInsert2 = sqlInsert2.Replace("@opidcont", OPIDCONT);
                        sqlInsert2 = sqlInsert2.Replace("@bolidbol", bolidbol);
                        sqlInsert2 = sqlInsert2.Replace("@usidusua", hfUser.Value);
                        exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert2);
                        if(exec=="OK")
                        {
                            exec = DataBase.Consultas.UpdtFrom(str_conn, "update DEBIAUTO set DAFLFLAG=1 where DAIDDEBI=" + ID[i]);
                        }
                    }
                }
            }
            gridDebiAuto.DataBind();
            gridVerbas.DataBind();
        }
        protected void cbAll2_Load(object sender, EventArgs e)
        {
            if (hfAllRows.Value == string.Empty) return;
            ASPxCheckBox chk = sender as ASPxCheckBox;
            chk.Checked = Convert.ToBoolean(hfAllRows.Value);
        }
        protected void btnRecusar2_Click(object sender, EventArgs e)
        {
            var ID = gridDebiAuto.GetSelectedFieldValues("DAIDDEBI");
            if (ID.Count > 0)
            {
                for (int i = 0; i < ID.Count; i++)
                {
                    string sqlUpd = "UPDATE DEBIAUTO SET DAFLFLAG=-1 WHERE DAIDDEBI=" + ID[i];
                    string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpd);
                }
            }
            gridDebiAuto.DataBind();
        }
        protected void dropMedContr_SelectedIndexChanged(object sender, EventArgs e)
        {
            var result = DataBase.Consultas.Consulta(str_conn, "select OPNMCONT,OPCDCONT,OPCDAUXI from opcontra o where o.OPIDCONT="+dropMedContr.Value.ToString(), 3);
            txtMedDesc.Text = result[0];
            txtMedContr.Text = result[1];
            gridMedicao.Enabled = true;
            sqlItensMedicaoGrid.SelectParameters[0].DefaultValue = dropMedContr.Value.ToString();
            sqlItensMedicaoGrid.DataBind();
            sqlVerbaMedicaoGrid.SelectParameters[0].DefaultValue = dropMedContr.Value.ToString();
            sqlVerbaMedicaoGrid.DataBind();
            if (Session["dtMedicao"] != null)
                Session["dtMedicao"] = null;

            DataTable dt = new DataTable();
            dt.Columns.Add("ID");
            DataColumn dc = new DataColumn();
            dc.ColumnName = "preco";
            dc.DataType = System.Type.GetType("System.Decimal");
            dt.Columns.Add(dc);
            DataColumn dc2 = new DataColumn();
            dc2.ColumnName = "total";
            dc2.DataType = System.Type.GetType("System.Decimal");
            dt.Columns.Add(dc2);
            DataColumn dc3 = new DataColumn();
            dc3.ColumnName = "inicio";
            dc3.DataType = System.Type.GetType("System.DateTime");
            dt.Columns.Add(dc3);
            DataColumn dc4 = new DataColumn();
            dc4.ColumnName = "fim";
            dc4.DataType = System.Type.GetType("System.DateTime");
            dt.Columns.Add(dc4);
            dt.Columns.Add("verba");
            dt.Columns.Add("item");
            dt.Columns.Add("contratada");
            dt.Columns.Add("saldo");
            dt.Columns.Add("quantidade");
            Session["dtMedicao"] = dt;
            gridMedicao.DataSource = dt;
            gridMedicao.DataBind();
        }
        protected void btnGravarMedicao_Load(object sender, EventArgs e)
        {
            ASPxButton btn = (ASPxButton)sender;
            btn.ClientEnabled = gridMedicao.VisibleRowCount > 0;
        }
        protected void btnLimparMedicao_Load(object sender, EventArgs e)
        {
            ASPxButton btn = (ASPxButton)sender;
            btn.ClientEnabled = gridMedicao.VisibleRowCount > 0;
        }
        protected void gridMedicao_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            if (Session["dtMedicao"] != null)
            {
                DataTable dt = (DataTable)Session["dtMedicao"] as DataTable;
                DataRow dr;
                int cont = 1;
                foreach (var item in e.InsertValues)
                {
                    dr = dt.NewRow();
                    dr["ID"] = DateTime.Now.ToString("ddMMyyHHmmss") + cont.ToString();
                    dr["preco"] = Convert.ToDecimal(item.NewValues["preco"]);
                    dr["total"] = Convert.ToDecimal(item.NewValues["total"]);
                    dr["inicio"] = Convert.ToDateTime(item.NewValues["inicio"]);
                    dr["fim"] = Convert.ToDateTime(item.NewValues["fim"]);
                    dr["verba"] = item.NewValues["verba"].ToString();
                    dr["item"] = item.NewValues["item"].ToString();
                    dr["contratada"] = item.NewValues["contratada"].ToString();
                    dr["saldo"] = item.NewValues["saldo"].ToString();
                    dr["quantidade"] = item.NewValues["quantidade"].ToString();
                    dt.Rows.Add(dr);
                    cont++;
                }
                foreach (var item in e.DeleteValues)
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID"].ToString() == item.Keys["ID"].ToString())
                            dr.Delete();
                    }
                    dt.AcceptChanges();
                }
                foreach (var item in e.UpdateValues)
                {
                    string preco = item.NewValues["preco"] == null ? item.OldValues["preco"].ToString() : item.NewValues["preco"].ToString();
                    string total = item.NewValues["total"] == null ? item.OldValues["total"].ToString() : item.NewValues["total"].ToString();
                    string inicio = item.NewValues["inicio"] == null ? item.OldValues["inicio"].ToString() : item.NewValues["inicio"].ToString();
                    string fim = item.NewValues["fim"] == null ? item.OldValues["fim"].ToString() : item.NewValues["fim"].ToString();
                    string verba = item.NewValues["verba"] == null ? item.OldValues["verba"].ToString() : item.NewValues["verba"].ToString();
                    string _item = item.NewValues["item"] == null ? item.OldValues["item"].ToString() : item.NewValues["item"].ToString();
                    string contratada = item.NewValues["contratada"] == null ? item.OldValues["contratada"].ToString() : item.NewValues["contratada"].ToString();
                    string saldo = item.NewValues["saldo"] == null ? item.OldValues["saldo"].ToString() : item.NewValues["saldo"].ToString();
                    string quantidade = item.NewValues["quantidade"] == null ? item.OldValues["quantidade"].ToString() : item.NewValues["quantidade"].ToString();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        dr = dt.Rows[i];
                        if (dr["ID"].ToString() == item.Keys["ID"].ToString())
                        {
                            dr["preco"] = Convert.ToDecimal(preco);
                            dr["total"] = Convert.ToDecimal(total);
                            dr["inicio"] = Convert.ToDateTime(inicio);
                            dr["fim"] = Convert.ToDateTime(fim);
                            dr["verba"] = verba;
                            dr["item"] = _item;
                            dr["contratada"] = contratada;
                            dr["saldo"] = saldo;
                            dr["quantidade"] = quantidade;
                        }
                    }
                    dt.AcceptChanges();
                }
                Session["dtMedicao"] = dt;
                gridMedicao.DataSource = dt;
                gridMedicao.DataBind();
            }
        }
        protected void gridMedicao_CustomDataCallback(object sender, ASPxGridViewCustomDataCallbackEventArgs e)
        {
            var parameter = e.Parameters.ToString().Split('#');
            if (parameter[0] == "item")
            {
                var result = DataBase.Consultas.Consulta(str_conn, "select FRQTITEM,FRSLDITE,FRVLITEM from FRFITENS F WHERE F.FRIDITEM = "+ parameter[1], 3);
                
                e.Result = "item#"+result[0]+"#"+result[1]+"#"+result[2]+"";
            }
            else if (parameter[0] == "quantidade")
            {
                var result = DataBase.Consultas.Consulta(str_conn, "select FRQTITEM,FRSLDITE,convert(float,FRVLITEM,103) from FRFITENS F WHERE F.FRIDITEM = " + parameter[2], 3);
                decimal preco = Convert.ToDecimal(result[2]);
                int qtd = Convert.ToInt32(parameter[1]);
                decimal total = preco * qtd;
                e.Result = "quantidade#" + total;
            }
        }
        protected void btnGravarMedicao_Click(object sender, EventArgs e)
        {
            if (Session["dtMedicao"] != null)
            {
                DataTable dt = (DataTable)Session["dtMedicao"] as DataTable;
                if (Page.IsValid)
                {
                    string BOLCDBOL = "0";
                    string BOLDTVCT = Convert.ToDateTime(txtDtVencMedi.Text).ToString("dd/MM/yyyy");
                    float valortotal = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        valortotal = valortotal + (float)Convert.ToDecimal(row["total"].ToString());
                    }
                    string BOLVLBOL = valortotal.ToString().Replace(".", "").Replace(",", ".");
                    string BOLNMBOL = "Medicao | "+ Convert.ToDateTime(txtDtVencMedi.Text).ToString("dd/MM/yyyy");
                    string OPIDCONT = dropMedContr.Value.ToString();
                    string BOLTPBOL = "T";
                    string sqlInsert = "INSERT INTO BOLTOTBO(BOLCDBOL,BOLDTVCT,BOLVLBOL,BOLNMBOL,OPIDCONT,BOLTPBOL,BOLSTBOL) " +
                                        "VALUES(@BOLCDBOL, convert(date, '@BOLDTVCT', 103), @BOLVLBOL, '@BOLNMBOL', @OPIDCONT,'@BOLTPBOL',0)";
                    sqlInsert = sqlInsert.Replace("@BOLCDBOL", BOLCDBOL);
                    sqlInsert = sqlInsert.Replace("@BOLDTVCT", BOLDTVCT);
                    sqlInsert = sqlInsert.Replace("@BOLVLBOL", BOLVLBOL);
                    sqlInsert = sqlInsert.Replace("@BOLNMBOL", BOLNMBOL);
                    sqlInsert = sqlInsert.Replace("@OPIDCONT", OPIDCONT);
                    sqlInsert = sqlInsert.Replace("@BOLTPBOL", BOLTPBOL);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            DataRow dr = dt.Rows[i];
                            string moidmoda = dr["verba"].ToString();
                            string data = Convert.ToDateTime(dr["inicio"]).ToString("dd/MM/yyyy");
                            string valor = dr["total"].ToString().Replace(",", ".");
                            string opidcont = OPIDCONT;
                            string usidusua = hfUser.Value;
                            string data_venc = BOLDTVCT;
                            string bolidbol = DataBase.Consultas.Consulta(str_conn, "select max(BOLIDBOL) from BOLTOTBO where BOLDTVCT=convert(date,'" + BOLDTVCT + "',103) and OPIDCONT=" + OPIDCONT, 1)[0];
                            string sqlInsert2 = "INSERT INTO BOLVERBA (moidmoda,BVDTTRAN,BVVLVERB,BVVALIDA,opidcont,BVAPROVA,BVDTVENC,bolidbol,usidusua,BVFLFLAG) " +
                 "VALUES(@moidmoda, convert(date, '@data', 103), @valor, 0, @opidcont, 0, convert(date, '@data_venc', 103), @bolidbol, '@usidusua',15)";
                            sqlInsert2 = sqlInsert2.Replace("@moidmoda", moidmoda);
                            sqlInsert2 = sqlInsert2.Replace("@data_venc", data_venc);
                            sqlInsert2 = sqlInsert2.Replace("@data", data);
                            sqlInsert2 = sqlInsert2.Replace("@valor", valor);
                            sqlInsert2 = sqlInsert2.Replace("@opidcont", opidcont);
                            sqlInsert2 = sqlInsert2.Replace("@bolidbol", bolidbol);
                            sqlInsert2 = sqlInsert2.Replace("@usidusua", usidusua);
                            exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert2);
                            if (exec == "OK")
                            {
                                Session["dtMedicao"] = null;
                                gridMedicao.DataSource = null;
                                sqlBoletos.DataBind();
                                gridMedicao.DataBind();
                                gridVerbas.DataBind();
                                gridAuditoria.DataBind();
                            }
                        }
                        popupMedicao.ShowOnPageLoad = false;
                    }
                }
            }
        }
        protected void btnLimparMedicao_Click(object sender, EventArgs e)
        {
            Session["dtMedicao"] = null;
            gridMedicao.DataSource = null;
            gridMedicao.DataBind();
        }

        protected void dropContratosBoleto_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}