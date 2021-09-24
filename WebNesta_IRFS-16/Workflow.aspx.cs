using DataBase;
using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Workflow : BasePage.BasePage
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
        }
        protected void gridWF_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            DateTime dt = Convert.ToDateTime(gridWF.GetRowValues(e.VisibleIndex, "WFDTTASK").ToString());
            //Response.Write(dt.ToString());
            DateTime dtGoal = DateTime.Now;
            DateTime dtGoal2 = Convert.ToDateTime(gridWF.GetRowValues(e.VisibleIndex, "REDTRECH").ToString());
            var compara = DateTime.Compare(dt, dtGoal);
            //Response.Write();
            if (compara < 0)
            {
                int dias = ((dt - dtGoal).Days) < 0 ? ((dt - dtGoal).Days) * -1 : ((dt - dtGoal).Days) * -1;
                string texto = dias == 1 ? "Tarefa atrasada em " + dias + " dia." : "Tarefa atrasada em " + dias + " dias.";
                e.Row.ToolTip = texto;
                e.Row.BackColor = System.Drawing.Color.Red;
                e.Row.ForeColor = System.Drawing.Color.White;
            }
            else if (DateTime.Compare(dtGoal2, dtGoal) < 0)
            {
                int dias = ((dt - dtGoal).Days) < 0 ? ((dt - dtGoal).Days) * -1 : ((dt - dtGoal).Days) * -1;
                string texto = dias == 1 ? "Tarefa atrasada em " + dias + " dia." : "Tarefa atrasada em " + dias + " dias.";
                e.Row.ToolTip = texto;
                e.Row.BackColor = System.Drawing.Color.Red;
                e.Row.ForeColor = System.Drawing.Color.White;
            }
            else if (((dt - dtGoal).Days) <= 30 && ((dt - dtGoal).Days) >= 15)
            {
                e.Row.ToolTip = "Tarefa com prazo para expirar em " + (dt - dtGoal).Days.ToString() + " dias.";
                e.Row.BackColor = System.Drawing.Color.Orange;
                e.Row.ForeColor = System.Drawing.Color.DimGray;
            }
            else if (((dt - dtGoal).Days) < 15)
            {
                e.Row.ToolTip = "Tarefa com prazo para expirar em " + (dt - dtGoal).Days.ToString() + " dias.";
                e.Row.BackColor = System.Drawing.Color.Yellow;
                e.Row.ForeColor = System.Drawing.Color.DimGray;
            }
        }
        protected void gridWF_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            gridWF.JSProperties["cp_origem"] = e.ButtonID;
            switch (e.ButtonID)
            {
                case "notify":
                    DataBase.Funcoes.NotifySome(hfUser.Value,
                                    gridWF.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString(),
                                    str_conn,
                                    4,
                                    gridWF.GetRowValues(e.VisibleIndex, "WFDSFLOW").ToString(),
                                    gridWF.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString());
                    gridWF.JSProperties["cp_ok"] = "OK";
                    break;
                case "analitico":
                    gridWF.JSProperties["cp_opidcont"] = gridWF.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString();
                    gridWF.JSProperties["cp_ok"] = "OK";
                    break;
            }
        }
        protected void gridWfAnalitico_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            grid.JSProperties["cp_origem"] = e.ButtonID;
            string sqlUpdTask, sqlUpdTask2, exec;
            switch (e.ButtonID)
            {
                case "alterar":
                    Session["visibleIndex"] = e.VisibleIndex.ToString();
                    grid.JSProperties["cp_visibleIndex"] = e.VisibleIndex.ToString();
                    grid.JSProperties["cp_responsavel"] = grid.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString();
                    grid.JSProperties["cp_prioridade"] = grid.GetRowValues(e.VisibleIndex, "WFIDPRIO").ToString();
                    grid.JSProperties["cp_prazo"] = grid.GetRowValues(e.VisibleIndex, "WFDTTASK").ToString();
                    break;
                case "aprovar":
                    int final = Convert.ToInt32(Consultas.Consulta(str_conn, "select WFIDNEXT from WORKFLOW where WFIDFLOW = " + grid.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString(), 1)[0]);
                    if (final > 0)
                    {
                        sqlUpdTask = "UPDATE WFTASKOP SET WFSTTASK = 1 WHERE WFIDTASK=" + grid.GetRowValues(e.VisibleIndex, "WFIDTASK").ToString();
                        sqlUpdTask2 = "UPDATE WFTASKOP SET WFSTTASK = 0 " +
    "where OPIDCONT = " + grid.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString() + " " +
    "AND WFIDFLOW in  " +
    "(select WFIDNEXT from WORKFLOW where WFIDFLOW = " + grid.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString() + ")";
                        exec = Consultas.UpdtFrom(str_conn, sqlUpdTask);
                        if (exec == "OK")
                        {
                            exec = Consultas.UpdtFrom(str_conn, sqlUpdTask2);
                            if (exec == "OK")
                            {
                                Funcoes.NotifySome(hfUser.Value,
                                    grid.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString(),
    str_conn,
    3,
    DataBase.Consultas.Consulta(str_conn, "select wf.WFDSFLOW from WORKFLOW wf, WFTASKOP wo where wf.WFIDFLOW=wo.WFIDFLOW and wo.WFIDTASK=" + grid.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString(), 1)[0],
    grid.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString());
                                grid.JSProperties["cp_ok"] = "OK";
                            }
                        }
                    }
                    break;
                case "recusar":
                    sqlUpdTask = "UPDATE WFTASKOP SET WFSTTASK = -1 WHERE WFIDTASK=" + grid.GetRowValues(e.VisibleIndex, "WFIDTASK").ToString();
                    sqlUpdTask2 = "UPDATE WFTASKOP SET WFSTTASK = 0 " +
"where OPIDCONT = " + grid.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString() + " " +
"AND WFIDFLOW in  " +
"(select WFIDFLOW from WORKFLOW where WFIDNEXT = " + grid.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString() + ")";
                    exec = Consultas.UpdtFrom(str_conn, sqlUpdTask);
                    if (exec == "OK")
                    {
                        exec = Consultas.UpdtFrom(str_conn, sqlUpdTask2);
                        if (exec == "OK")
                        {
                            Funcoes.NotifySome(hfUser.Value,
                                    grid.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString(),
    str_conn,
    2,
    DataBase.Consultas.Consulta(str_conn, "select wf.WFDSFLOW from WORKFLOW wf, WFTASKOP wo where wf.WFIDFLOW=wo.WFIDFLOW and wo.WFIDTASK=" + grid.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString(), 1)[0],
    grid.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString());
                            grid.JSProperties["cp_ok"] = "OK";
                        }
                    }
                    break;
            }
        }
        protected void gridWfAnalitico_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            int status = Convert.ToInt32(gridWfAnalitico.GetRowValues(e.VisibleIndex, "WFSTTASK").ToString());
            int idFlow = Convert.ToInt32(gridWfAnalitico.GetRowValues(e.VisibleIndex, "WFIDFLOW").ToString());
            int idNext = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select WFIDNEXT from WORKFLOW WHERE WFIDFLOW="+idFlow.ToString(), 1)[0]);
            switch (status)
            {
                case 0:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = true;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = true;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = true;
                    }
                    break;
                case 1:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = false;
                    }
                    break;
                case -1:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = false;
                    }
                    break;
                case -2:
                    if (e.ButtonID == "alterar")
                    {
                        e.Enabled = true;
                    }
                    else if (e.ButtonID == "aprovar")
                    {
                        e.Enabled = false;
                    }
                    else if (e.ButtonID == "recusar")
                    {
                        e.Enabled = false;
                    }
                    break;
            }
            if (e.ButtonID == "recusar" && idFlow == 1)
            {
                e.Enabled = false;
            }
            if (e.ButtonID == "aprovar" && idNext < 0)
            {
                e.Enabled = false;
            }
        }
        protected void radioExibir_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                radioExibir.SelectedIndex = 0;
            }
        }
        protected void radioExibir_SelectedIndexChanged(object sender, EventArgs e)
        {
            mvWflow.ActiveViewIndex = radioExibir.SelectedIndex;
        }
        protected void mvWflow_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                mvWflow.ActiveViewIndex = 0;
            }
        }
        protected void gridWFAdmin_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            grid.JSProperties["cp_origem"] = e.ButtonID;
            DataBase.WorkflowAdmin workflowAdmin = new WorkflowAdmin();
            workflowAdmin.str_conn = str_conn;
            string ID;
            switch (e.ButtonID)
            {
                case "aprovar2":
                    int status = Convert.ToInt32(gridWFAdmin.GetRowValues(e.VisibleIndex, "ALSTATUS").ToString());                    
                    workflowAdmin.ID = Convert.ToInt32(gridWFAdmin.GetRowValues(e.VisibleIndex, "ALIDALSQ").ToString());
                    if (status == 0)
                    {
                        if (workflowAdmin.AprovarWfw())
                        {
                            grid.JSProperties["cp_ok"] = "OK";
                        }
                    }
                    else if(status==-1)
                    {
                        if (workflowAdmin.ReativarWfw())
                        {
                            grid.JSProperties["cp_ok"] = "OK";
                        }
                    }
                    break;
                case "recusar2":
                    workflowAdmin.ID = Convert.ToInt32(gridWFAdmin.GetRowValues(e.VisibleIndex, "ALIDALSQ").ToString());
                    if (workflowAdmin.RecusarWfw())
                    {
                        grid.JSProperties["cp_ok"] = "OK";

                    }
                    break;
                case "notify2":                    
                    if(gridWFAdmin.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString()==string.Empty)
                    {

                        DataBase.Funcoes.NotifyDenuncia(hfUser.Value,
                            gridWFAdmin.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString(),
                            str_conn,
                            Convert.ToInt32(gridWFAdmin.GetRowValues(e.VisibleIndex, "DNIDDENU").ToString()),
                            gridWFAdmin.GetRowValues(e.VisibleIndex, "REIDIMOV").ToString(), false) ;
                    }
                    else
                    {
                        DataBase.Funcoes.NotifyDenuncia(hfUser.Value,
                            gridWFAdmin.GetRowValues(e.VisibleIndex, "USIDUSUA").ToString(),
                            str_conn,
                            Convert.ToInt32(gridWFAdmin.GetRowValues(e.VisibleIndex, "DNIDDENU").ToString()),
                            gridWFAdmin.GetRowValues(e.VisibleIndex, "OPIDCONT").ToString(), true);
                    }                    
                    gridWF.JSProperties["cp_ok"] = "OK";
                    Site myMasterPage = Page.Master as Site;
                    myMasterPage.AtualizaNotificao();
                    break;
            }
        }
        protected void gridWFAdmin_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            //DateTime dt = Convert.ToDateTime(gridWF.GetRowValues(e.VisibleIndex, "WFDTTASK").ToString());
            //Response.Write(dt.ToString());
            DateTime dtGoal = DateTime.Now;
            DateTime dtGoal2 = Convert.ToDateTime(gridWFAdmin.GetRowValues(e.VisibleIndex, "ALDTEXPI").ToString());
            //var compara = DateTime.Compare(dt, dtGoal);
            //Response.Write();
            if (((dtGoal2 - dtGoal).Days) < 0)
            {
                int dias = ((dtGoal2 - dtGoal).Days) < 0 ? ((dtGoal2 - dtGoal).Days) * -1 : ((dtGoal2 - dtGoal).Days) * -1;
                string texto = dias == 1 ? "Tarefa atrasada em " + dias + " dia." : "Tarefa atrasada em " + dias + " dias.";
                e.Row.ToolTip = texto;
                e.Row.BackColor = System.Drawing.Color.Red;
                e.Row.ForeColor = System.Drawing.Color.White;
            }
            else if (((dtGoal2 - dtGoal).Days) <= 30 && ((dtGoal2 - dtGoal).Days) >= 15)
            {
                e.Row.ToolTip = "Tarefa com prazo para expirar em "+ (dtGoal2 - dtGoal).Days.ToString() + " dias.";
                e.Row.BackColor = System.Drawing.Color.Orange;
                e.Row.ForeColor = System.Drawing.Color.DimGray;
            }
            else if (((dtGoal2 - dtGoal).Days) < 15)
            {
                e.Row.ToolTip = "Tarefa com prazo para expirar em " + (dtGoal2 - dtGoal).Days.ToString() + " dias.";
                e.Row.BackColor = System.Drawing.Color.Yellow;
                e.Row.ForeColor = System.Drawing.Color.DimGray;
            }
        }
        protected void gridWFAdmin_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            int status = Convert.ToInt32(gridWFAdmin.GetRowValues(e.VisibleIndex, "ALSTATUS").ToString());
            if (e.ButtonID == "notify2")
            {
                //e.Enabled = true;
            }
            else if (e.ButtonID == "aprovar2")
            {
                //e.Enabled = true;
            }
            else if (e.ButtonID == "recusar2")
            {
                e.Enabled = status>=0;
            }
        }
        protected void gridAcoes_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach(var item in e.InsertValues)
            {
                string sqlIns= "INSERT INTO DNALERTA (DNIDDENU ,REIDIMOV ,OPIDCONT ,ALDTINIC ,ALDTEXPI ,ALRENOVA ,ALSTATUS ,USIDUSUA) "+
                            "VALUES(@DNIDDENU, @REIDIMOV, @OPIDCONT, convert(date, '@ALDTINIC', 103), convert(date, '@ALDTEXPI', 103), @ALRENOVA, 0, '@USIDUSUA')";
                string DNIDDENU = item.NewValues["DNIDDENU"].ToString();
                string REIDIMOV = item.NewValues["REIDIMOV"] == null ?"NULL": item.NewValues["REIDIMOV"].ToString();
                string OPIDCONT = item.NewValues["OPIDCONT"] == null ? "NULL" : item.NewValues["OPIDCONT"].ToString();
                string ALDTINIC = item.NewValues["ALDTINIC"].ToString();
                string ALDTEXPI = item.NewValues["ALDTEXPI"].ToString();
                string ALRENOVA = item.NewValues["ALRENOVA"].ToString();
                string USIDUSUA = hfUser.Value;
                sqlIns = sqlIns.Replace("@DNIDDENU", DNIDDENU);
                sqlIns = sqlIns.Replace("@REIDIMOV", REIDIMOV);
                sqlIns = sqlIns.Replace("@OPIDCONT", OPIDCONT);
                sqlIns = sqlIns.Replace("@ALDTINIC", Convert.ToDateTime(ALDTINIC).ToString("dd/MM/yyyy"));
                sqlIns = sqlIns.Replace("@ALDTEXPI", Convert.ToDateTime(ALDTEXPI).ToString("dd/MM/yyyy"));
                sqlIns = sqlIns.Replace("@ALRENOVA", ALRENOVA);
                sqlIns = sqlIns.Replace("@USIDUSUA", USIDUSUA);
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlIns);
            }
            foreach(var item in e.UpdateValues)
            {

            }
            foreach(var item in e.DeleteValues)
            {
                string sqlDel = "DELETE DNALERTA where ALIDALSQ=" + item.Keys["ALIDALSQ"].ToString();
                string exec = DataBase.Consultas.DeleteFrom(str_conn,sqlDel);
            }
            gridAcoes.DataBind();
            gridWFAdmin.DataBind();
        }
    }
}