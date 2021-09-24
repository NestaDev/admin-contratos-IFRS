using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Configuration;
using Microsoft.SqlServer;
using Microsoft.SqlServer.Server;
using System.Data;
using System.Text;

namespace WebNesta_IRFS_16
{
    public partial class testeSP : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                OleDbConnection con = new OleDbConnection(ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString);
                con.Open();
                OleDbCommand sqlCommand = new OleDbCommand("sys.sp_helptext", con);
                sqlCommand.CommandType = CommandType.StoredProcedure;
                sqlCommand.Parameters.AddWithValue("@objname", "sp_teste");
                OleDbDataReader dr = sqlCommand.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        ASPxMemo1.Text += dr[0].ToString();
                    }
                }
                con.Close();
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            StringBuilder sbSP = new StringBuilder();
            sbSP.AppendLine(ASPxMemo1.Text);
            using (OleDbConnection connection = new OleDbConnection(ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString))
            {

                using (OleDbCommand cmd = new OleDbCommand(ASPxMemo1.Text.Replace("\r\n",Environment.NewLine).Replace("\t","    "), connection))
                {
                    connection.Open();
                    cmd.CommandType = CommandType.Text;
                    try
                    {
                        cmd.ExecuteNonQuery();
                        Label1.Text = "Compliado com sucesso!";
                    }
                    catch (Exception ex)
                    {
                        Label1.Text = ex.Message.ToString();
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
            }
        }
    }
}