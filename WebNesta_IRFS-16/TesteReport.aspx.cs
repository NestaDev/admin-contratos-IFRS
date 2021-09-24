using DevExpress.DataAccess.ConnectionParameters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class TesteReport : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string connS = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            MsSqlConnectionParameters connectionParameters = new MsSqlConnectionParameters(
                System.Configuration.ConfigurationManager.AppSettings["hostDB"], System.Configuration.ConfigurationManager.AppSettings["nameDB"],
                System.Configuration.ConfigurationManager.AppSettings["userDB"], System.Configuration.ConfigurationManager.AppSettings["passDB"], MsSqlAuthorizationType.SqlServer);
            string query = DataBase.Consultas.Consulta(str_conn, "select QUEBBPVT from QUERYPVT where QUEIDPVT=10072", 1)[0];
            SqlDataSource ds = new SqlDataSource(connS,query);

            ASPxReportDesigner1.DataSources.Add("DataSource", ds);

            Report1 report1 = new Report1();
            ASPxReportDesigner1.OpenReport(report1);
        }
    }
}