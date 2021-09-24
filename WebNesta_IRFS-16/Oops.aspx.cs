using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Oops : BasePage.BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Title = hfTitulo.Value;
            Exception ex = Session["error"] as Exception;
            if (ex != null)
            {
                ex = ex.GetBaseException();
                lblErrorMsg.Text = ex.Message;
                lblSource.Text = ex.Source;
                lblStackTrace.Text = ex.StackTrace;
                Session["error"] = null;
            }

        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            Session["ClickBtnApp"] = null;
            Response.Redirect("Default");
        }
    }
}