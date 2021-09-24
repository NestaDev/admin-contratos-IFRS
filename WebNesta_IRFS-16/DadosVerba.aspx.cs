using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class DadosVerba : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        public static string lang;
        public static string currentPage;
        public static bool AcessoInternet;
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
                HttpCookie cookieUser = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
                if (cookieUser == null)
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
                else
                {
                    hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], cookieUser.Value);
                }
            }
            if(Session["TVIDESTR"] != null)
            {

                ddeEstruturaInsert.Text = DataBase.Consultas.Consulta(str_conn, "select TVDSESTR from TVESTRUT where TVIDESTR="+ Session["TVIDESTR"].ToString() + "",1)[0];
            }
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = (DevExpress.Web.ASPxTreeList.ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList") as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            treeList.DataBind();
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treeList = sender as DevExpress.Web.ASPxTreeList.ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (DevExpress.Web.ASPxTreeList.TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void btnselecionar_Click(object sender, EventArgs e)
        {
            txtCompet.Text = string.Empty;
            txtCompet.Enabled = true;
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
            int Index = Convert.ToInt32(grid.FocusedRowIndex);
            hfIndexGridOper.Value = Index.ToString();
            ddePesqContrato.Text = grid.GetRowValues(Index, "OPCDCONT").ToString();
            lblOPIDCONTVerba.Text = ddePesqContrato.Text;
            UpdatePanel1.Update();
        }
        protected void btnSelEmp_Click(object sender, EventArgs e)
        {
            Session["TVIDESTR"] = hfDropEstr.Value;
            ddeEstruturaInsert.Text = DataBase.Consultas.Consulta(str_conn, "select TVDSESTR from TVESTRUT where TVIDESTR=" + Session["TVIDESTR"].ToString() + "", 1)[0];
            ddePesqContrato.Enabled = true;
        }
        protected void txtCompet_ValueChanged(object sender, EventArgs e)
        {
            lblCompet1.Visible = true;
            lblCompet.Visible = true;
            lblCompet.Text = txtCompet.Text;
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
            txtNum.Text = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPCDCONT").ToString();
            ddeEstruturaInsert.Text = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "TVDSESTR").ToString();
            txtEmpresa.Text = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "TVDSESTR").ToString();
            txtTipologia.Text = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "PRPRODES").ToString();
            txtValor.Text = Convert.ToDecimal(grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPVLCONT")).ToString("N2");
            sqlVerbasFluxo.SelectParameters[0].DefaultValue = Convert.ToDateTime("01/"+txtCompet.Text,CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[1].DefaultValue = Convert.ToDateTime("01/"+txtCompet.Text,CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[2].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlVerbasFluxo.SelectParameters[3].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[4].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[5].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlVerbasFluxo.SelectParameters[6].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlVerbasFluxo.SelectParameters[7].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[8].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[9].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlVerbasFluxo.SelectParameters[10].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[11].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[12].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlVerbasFluxo.SelectParameters[13].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlVerbasFluxo.SelectParameters[14].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[15].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlVerbasFluxo.SelectParameters[16].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlAuditoria.SelectParameters[0].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlAuditoria.SelectParameters[1].DefaultValue = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
            sqlAuditoria.SelectParameters[2].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            sqlModalida.SelectParameters[0].DefaultValue = grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString();
            gridVerbas.DataBind();
            mvBoletagem.SetActiveView(this.vw_dataentry);
            btnAuditar.Enabled = true;
            DateTime dtCompt = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR"));
            sqlFaturamento.SelectParameters[0].DefaultValue = sqlVerbasFluxo.SelectParameters[13].DefaultValue;
            sqlFaturamento.SelectParameters[1].DefaultValue = dtCompt.ToString("yyyy-MM-dd");
            sqlFaturamento.SelectParameters[2].DefaultValue = dtCompt.AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd");
            sqlFaturamento.DataBind();
            gridFaturamento.DataBind();
        }
        protected void gridVerbas_Init(object sender, EventArgs e)
        {
        }
        protected void gridVerbas_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            DateTime dtCompt = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR"));
            e.Handled = true;
            foreach(var item in e.InsertValues)
            {                
                string moidmoda = item.NewValues["verba"].ToString();
                string data = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
                string valor = item.NewValues["valor_atual"].ToString().Replace(",", ".");
                string opidcont = sqlVerbasFluxo.SelectParameters[13].DefaultValue;
                string valida = "0";
                string sqlInsert = "INSERT INTO fluxo_oper_jesse(moidmoda,data,valor,valida,opidcont) " +
                    "VALUES(@moidmoda,'@data',@valor,@valida,@opidcont)";
                sqlInsert = sqlInsert.Replace("@moidmoda", moidmoda);
                sqlInsert = sqlInsert.Replace("@data", data);
                sqlInsert = sqlInsert.Replace("@valor", valor);
                sqlInsert = sqlInsert.Replace("@opidcont", opidcont);
                sqlInsert = sqlInsert.Replace("@valida", valida);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if(exec =="OK")
                {
                    gridVerbas.DataBind();
                }
            }
            foreach(var item in e.DeleteValues)
            {
                string opidcont = sqlVerbasFluxo.SelectParameters[13].DefaultValue;
                string data = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
                string valor = item.Values["valor_atual"].ToString().Replace(",", ".");
                string moidmoda = item.Values["verba"].ToString();
                string sqlDelete = "DELETE FROM fluxo_oper_jesse WHERE opidcont=@opidcont AND moidmoda=@moidmoda AND valor=@valor and data='@data'";
                sqlDelete = sqlDelete.Replace("@opidcont",opidcont);
                sqlDelete = sqlDelete.Replace("@moidmoda", moidmoda);
                sqlDelete = sqlDelete.Replace("@valor", valor);
                sqlDelete = sqlDelete.Replace("@data", data);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlDelete);
                if (exec == "OK")
                {
                    gridVerbas.DataBind();
                }
            }
            foreach(var item in e.UpdateValues)
            {
                if (Convert.ToDecimal(item.OldValues["valor_atual"].ToString()) == 0)
                {
                    string moidmoda = item.NewValues["verba"].ToString();
                    string data = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
                    string valor = item.NewValues["valor_atual"].ToString().Replace(",", ".");
                    string opidcont = sqlVerbasFluxo.SelectParameters[13].DefaultValue;
                    string valida = "0";
                    string sqlInsert = "INSERT INTO fluxo_oper_jesse(moidmoda,data,valor,valida,opidcont) " +
                        "VALUES(@moidmoda,'@data',@valor,@valida,@opidcont)";
                    sqlInsert = sqlInsert.Replace("@moidmoda", moidmoda);
                    sqlInsert = sqlInsert.Replace("@data", data);
                    sqlInsert = sqlInsert.Replace("@valor", valor);
                    sqlInsert = sqlInsert.Replace("@opidcont", opidcont);
                    sqlInsert = sqlInsert.Replace("@valida", valida);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        gridVerbas.DataBind();
                    }
                }
                else
                {
                    string opidcont = sqlVerbasFluxo.SelectParameters[13].DefaultValue;
                    string data = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
                    string valorOld = item.OldValues["valor_atual"].ToString().Replace(",", ".");
                    string valorNew = item.NewValues["valor_atual"].ToString().Replace(",", ".");
                    string moidmoda = item.OldValues["verba"].ToString();
                    string sqlUpdate = "update fluxo_oper_jesse set valor=@valorNew WHERE opidcont=@opidcont AND moidmoda=@moidmoda AND valor=@valorOld and data='@data'";
                    sqlUpdate = sqlUpdate.Replace("@opidcont", opidcont);
                    sqlUpdate = sqlUpdate.Replace("@moidmoda", moidmoda);
                    sqlUpdate = sqlUpdate.Replace("@valorNew", valorNew);
                    sqlUpdate = sqlUpdate.Replace("@valorOld", valorOld);
                    sqlUpdate = sqlUpdate.Replace("@data", data);
                    string exec = DataBase.Consultas.InsertInto(str_conn, sqlUpdate);
                    if (exec == "OK")
                    {
                        gridVerbas.DataBind();
                    }
                }
            }
        }
        protected void gridVerbas_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            if (e.ButtonID == "duplicar")
            {
                string moidmoda = gridVerbas.GetRowValues(Convert.ToInt32(e.VisibleIndex), "verba").ToString();
                string valor_media = gridVerbas.GetRowValues(Convert.ToInt32(e.VisibleIndex), "valor_media").ToString();
                string data = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR")).ToString("yyyy-MM-dd");
                string opidcont = sqlVerbasFluxo.SelectParameters[13].DefaultValue;
                string valida = "0";
                string sqlInsert = "INSERT INTO fluxo_oper_jesse(moidmoda,data,valor,valida,opidcont) " +
                    "VALUES(@moidmoda,'@data',@valor,@valida,@opidcont)";
                sqlInsert = sqlInsert.Replace("@moidmoda", moidmoda);
                sqlInsert = sqlInsert.Replace("@data", data);
                sqlInsert = sqlInsert.Replace("@valor", valor_media);
                sqlInsert = sqlInsert.Replace("@opidcont", opidcont);
                sqlInsert = sqlInsert.Replace("@valida", valida);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if (exec == "OK")
                {
                    gridVerbas.DataBind();
                }
            }
            else if (e.ButtonID == "fluxo")
            {
                
            }
        }
        protected void gridVerbas_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            if (gridVerbas.VisibleRowCount > 0)
            {
                if (e.ButtonID == "duplicar")
                {
                    decimal tl = Convert.ToDecimal(gridVerbas.GetRowValues(e.VisibleIndex, "valor_atual"));
                    if (tl != 0)
                    {
                        e.Enabled = false;
                        e.Visible = DevExpress.Utils.DefaultBoolean.False;
                    }
                }
                else if (e.ButtonID == "fluxo")
                {
                    string sqlBases = "select CJIDCODI from VIOPMODA where OPIDCONT=" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + " and MOIDMODA="+ gridVerbas.GetRowValues(e.VisibleIndex, "verba") + " and CHIDCODI is not null and CJIDCODI is not null";
                    var dtBases = DataBase.Consultas.Consulta(str_conn, sqlBases,1)[0];
                    switch(dtBases)
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
        protected void btnAuditar_Click(object sender, EventArgs e)
        {
            btnEntrada.Enabled = true;
            btnAuditar.Enabled = false;
            mvBoletagem.SetActiveView(this.vw_auditoria);
        }
        protected void btnEntrada_Click(object sender, EventArgs e)
        {
            btnEntrada.Enabled = false;
            btnAuditar.Enabled = true;
            mvBoletagem.SetActiveView(this.vw_dataentry);
        }
        protected void gridAuditar_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            string valida = gridAuditar.GetRowValues(e.VisibleIndex, "valida").ToString();
            string moidmoda = gridAuditar.GetRowValues(e.VisibleIndex, "moidmoda").ToString();
            string idseq = gridAuditar.GetRowValues(e.VisibleIndex, "idseq").ToString();
            string data = sqlAuditoria.SelectParameters[0].DefaultValue;
            string opidcont = sqlAuditoria.SelectParameters[1].DefaultValue;
            string sqlUpdate = string.Empty;
            string exec = string.Empty;
            switch (e.ButtonID)
            {
                case "aprovar":
                    sqlUpdate = "update fluxo_oper_jesse set valida=1 where idseq=@idseq";
                    //sqlUpdate = sqlUpdate.Replace("@opidcont",opidcont);
                    //sqlUpdate = sqlUpdate.Replace("@moidmoda", moidmoda);
                    //sqlUpdate = sqlUpdate.Replace("@data", data);
                    //sqlUpdate = sqlUpdate.Replace("@valida", valida);
                    sqlUpdate = sqlUpdate.Replace("@idseq", idseq);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if(exec=="OK")
                    {
                        gridAuditar.DataBind();
                    }
                    break;
                case "rejeitar":
                     sqlUpdate = "update fluxo_oper_jesse set valida=0 where idseq=@idseq";
                    //sqlUpdate = sqlUpdate.Replace("@opidcont", opidcont);
                    //sqlUpdate = sqlUpdate.Replace("@moidmoda", moidmoda);
                    //sqlUpdate = sqlUpdate.Replace("@data", data);
                    //sqlUpdate = sqlUpdate.Replace("@valida", valida);
                    sqlUpdate = sqlUpdate.Replace("@idseq", idseq);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if (exec == "OK")
                    {
                        gridAuditar.DataBind();
                    }
                    break;
            }
        }
        protected void gridAuditar_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if(e.ButtonID=="aprovar")
            {
                int valida = Convert.ToInt32(gridAuditar.GetRowValues(e.VisibleIndex, "valida"));
                if (valida == 1)
                {
                    e.Enabled = false;
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
            else if(e.ButtonID=="rejeitar")
            {
                int valida = Convert.ToInt32(gridAuditar.GetRowValues(e.VisibleIndex, "valida"));
                if (valida == 0)
                {
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                    e.Enabled = false;
                }
            }
        }
        protected void gridVerbas_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            if (gridVerbas.VisibleRowCount > 0)
            {
                decimal tl = Convert.ToDecimal(gridVerbas.GetRowValues(e.VisibleIndex, "valor_atual"));
                if (tl == 0)
                {
                    e.Enabled = false;
                    e.Visible = false;
                }
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)ddePesqContrato.FindControl("ASPxGridView1");
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
                    sqlVIOPMODA = sqlVIOPMODA.Replace("@OPIDCONT", grid.GetRowValues(Convert.ToInt32(hfIndexGridOper.Value), "OPIDCONT").ToString());
                    sqlVIOPMODA = sqlVIOPMODA.Replace("@MOIDMODA", MOIDMODA);
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlVIOPMODA);
                    sqlModalida.DataBind();
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
        protected void gridVerbas_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            DateTime dtCompt = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR"));
            ASPxGridView grid = sender as ASPxGridView;
            string sqlBases = "select CJIDCODI,MOIDMODA from VIOPMODA where OPIDCONT=" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + " and CHIDCODI is not null and CJIDCODI is not null";
            var dtBases = DataBase.Consultas.Consulta(str_conn, sqlBases);
            foreach (DataRow row in dtBases.Rows)
            {
                if (row[1].ToString() == e.NewValues["verba"].ToString())
                {
                    switch (row[0].ToString())
                    {
                        case "25700":
                            if (e.IsNewRow)
                            {
                                string sqlValida = "select CHIDCODI,CJIDCODI from VIOPMODA where moidmoda = " + e.NewValues["verba"].ToString() + " and CHIDCODI is not null and CJIDCODI is not null";
                                var result = DataBase.Consultas.Consulta(str_conn, sqlValida, 2);
                                if (result.Length > 1)
                                {
                                    string sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + ",264),2,'0')+'" + "/" + dtCompt.Month + "/" + dtCompt.Year + "',103) Data_Verba";
                                    string sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                    string sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + " and PHDTEVEN='" + sqlDia + "' and MOIDMODA=" + e.NewValues["verba"].ToString() + "";
                                    float valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                                    if (valorContrato != (float)Convert.ToDecimal(e.NewValues["valor_atual"]))
                                        e.RowError = "ERRRO! Valor inserido " + string.Format("{0:N2}", e.NewValues["valor_atual"]) + " maior que o valor " + valorContrato.ToString("N2") + " contrato.";
                                }
                            }
                            else
                            {
                                string sqlValida = "select CHIDCODI,CJIDCODI from VIOPMODA where moidmoda = " + e.NewValues["verba"].ToString() + " and CHIDCODI is not null and CJIDCODI is not null";
                                var result = DataBase.Consultas.Consulta(str_conn, sqlValida, 2);
                                if (result.Length > 1)
                                {
                                    string sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + ",264),2,'0')+'" + "/" + dtCompt.Month + "/" + dtCompt.Year + "',103) Data_Verba";
                                    string sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                    string sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + " and PHDTEVEN='" + sqlDia + "' and MOIDMODA=" + e.NewValues["verba"].ToString() + "";
                                    float valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                                    if (valorContrato != (float)Convert.ToDecimal(e.NewValues["valor_atual"]))
                                        e.RowError = "ERRRO! Valor inserido " + string.Format("{0:N2}", e.NewValues["valor_atual"]) + " maior que o valor " + valorContrato.ToString("N2") + " contrato.";
                                }
                            }
                            break;
                    }
                }
            }
        
        }
        protected void gridVerbas_CustomDataCallback(object sender, ASPxGridViewCustomDataCallbackEventArgs e)
        {
            string sql, sqlDia, sqlValor;
            float valorContrato;
            DateTime dtCompt = Convert.ToDateTime("01/" + txtCompet.Text, CultureInfo.GetCultureInfo("pt-BR"));
            if (e.Parameters.ToString().Split('#')[0] == "verba")
            {
                string sqlBases = "select CJIDCODI,MOIDMODA from VIOPMODA where OPIDCONT=" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + " and CHIDCODI is not null and CJIDCODI is not null";
                var dtBases = DataBase.Consultas.Consulta(str_conn,sqlBases);
                foreach (DataRow row in dtBases.Rows)
                {
                    if (row[1].ToString()== e.Parameters.ToString().Split('#')[1])
                    {
                        switch (row[0].ToString())
                        {
                            case "25700":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + ",264),2,'0')+'" + "/" + dtCompt.Month + "/" + dtCompt.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                sqlValor = "select PHVLTOTA from PHPLANIF_OPER where OPIDCONT=" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + " and PHDTEVEN='" + sqlDia + "' and MOIDMODA=" + e.Parameters.ToString().Split('#')[1] + "";
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, sqlValor, 1)[0]);
                                e.Result = "valor_atual#" + valorContrato.ToString("N2").Replace(".", "")+"#"+ row[0].ToString();
                                
                                break;
                            case "25702":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + ",264),2,'0')+'" + "/" + dtCompt.Month + "/" + dtCompt.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold = "select CJTPCTTX from CJCLPROP where CJIDCODI=25702";
                                string result = DataBase.Consultas.Consulta(str_conn,sqlValorold,1)[0];
                                string codConvert = lang == "en-US" ? "101" : "103";
                                result = result.Replace("@p_opidcont", sqlVerbasFluxo.SelectParameters[13].DefaultValue);
                                result = result.Replace("@p_date","convert(date,'"+ dtCompt.ToShortDateString() + "',"+codConvert+")");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result, 1)[0]);
                                e.Result = "valor_atual#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                            case "25703":
                                sql = "select convert(date,dbo.lpad(dbo.nesta_fn_get_propdin_text(" + sqlVerbasFluxo.SelectParameters[13].DefaultValue + ",264),2,'0')+'" + "/" + dtCompt.Month + "/" + dtCompt.Year + "',103) Data_Verba";
                                sqlDia = DataBase.Consultas.Consulta(str_conn, sql, 1)[0];
                                string sqlValorold2 = "select CJTPCTTX from CJCLPROP where CJIDCODI=25703";
                                string result2 = DataBase.Consultas.Consulta(str_conn, sqlValorold2, 1)[0];
                                string codConvert2 = lang == "en-US" ? "101" : "103";
                                result2 = result2.Replace("@p_opidcont", sqlVerbasFluxo.SelectParameters[13].DefaultValue);
                                result2 = result2.Replace("@p_date", "convert(date,'" + dtCompt.ToShortDateString() + "'," + codConvert2 + ")");
                                valorContrato = (float)Convert.ToDecimal(DataBase.Consultas.Consulta(str_conn, result2, 1)[0]);
                                e.Result = "valor_atual#" + valorContrato.ToString("N2").Replace(".", "") + "#" + row[0].ToString();
                                break;
                        }
                    }
                }
            }
            
        }
    }
}