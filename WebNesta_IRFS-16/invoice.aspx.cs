using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class invoice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            XtraReport1 report = new XtraReport1();
            report.Parameters["OPIDCONT"].Value = 7201;
            report.Parameters["OPIDCONT"].Visible = false;
            ASPxWebDocumentViewer1.OpenReport(report);
        }
    }
}