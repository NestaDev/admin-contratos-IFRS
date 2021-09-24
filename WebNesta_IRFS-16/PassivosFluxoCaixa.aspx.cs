using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataBase;

namespace WebNesta_IRFS_16
{
    public partial class PassivosAquisicao :BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                lang = Session["langSession"].ToString();
            }
            catch
            {
                lang = "en-US";
            }
            if (!IsPostBack)
            {
                string sql = "SELECT TOP 100 OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, IE.IENMINEC " +
                    "FROM OPCONTRA OP, CACTEIRA CA, OPTPFRCO FR, " +
                         "TPSIMNAO SN, OPTPRGCO RG, OPTPTIPO TP, " +
                         "PRPRODUT PR, PRTPOPER PE, IEINDECO IE, " +
                         "FOFORNEC FO, TVESTRUT TV " +
                    "WHERE OP.CAIDCTRA = CA.CAIDCTRA " +
                    "AND OP.PRTPIDOP IN(1, 7, 8, 17)  " +
                    "AND OP.OPTPFRID = FR.OPTPFRID " +
                    "AND OP.TPIDSINA = SN.TPIDSINA " +
                    "AND OP.OPTPTPID = TP.OPTPTPID " +
                    "AND OP.PRPRODID = PR.PRPRODID " +
                    "AND OP.OPTPRGID = RG.OPTPRGID " +
                    "AND OP.PRTPIDOP = PE.PRTPIDOP " +
                    "AND PR.IEIDINEC = IE.IEIDINEC " +
                    "AND OP.FOIDFORN = FO.FOIDFORN " +
                    "AND OP.TVIDESTR = TV.TVIDESTR " +
                    "AND PE.CMTPIDCM = FR.CMTPIDCM " +
                    "AND PE.CMTPIDCM = RG.CMTPIDCM " +
                    "AND PE.CMTPIDCM = TP.CMTPIDCM " +
                    "AND PE.CMTPIDCM IN(1, 8)  " +
                    "AND PE.PAIDPAIS = 1 " +
                    "AND FR.CMTPIDCM IN(1, 8) " +
                    "AND FR.PAIDPAIS = 1 " +
                    "AND SN.PAIDPAIS = 1 " +
                    "AND RG.CMTPIDCM IN(1, 8) " +
                    "AND RG.PAIDPAIS = 1 " +
                    "AND TP.CMTPIDCM IN(1, 8)  " +
                    "AND TP.PAIDPAIS = 1 " +
                    "AND TV.TVIDESTR IN(11,111,112,113,114)";
                GridView1.DataSource = Consultas.Consulta(str_conn, sql);
                GridView1.DataBind();
            }
        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            CultureInfo cultureInfo = CultureInfo.GetCultureInfo(lang);
            GridView _gridView = (GridView)sender;
            // Get the selected index and the command name
            int _selectedIndex = int.Parse(e.CommandArgument.ToString());
            string _commandName = e.CommandName;
            if (_commandName == "DoubleClick")
            {
                txtOper.Text = GridView1.Rows[_selectedIndex].Cells[1].Text.ToString();
                Session["OPIDCONT"] = txtOper.Text;
                txtDesc.Text = GridView1.Rows[_selectedIndex].Cells[3].Text.ToString();
                txtIndice.Text = GridView1.Rows[_selectedIndex].Cells[5].Text.ToString();
                txtContra.Text = GridView1.Rows[_selectedIndex].Cells[4].Text.ToString();
            }
        }
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                
                // Get the LinkButton control in the second cell
                LinkButton _doubleClickButton = (LinkButton)e.Row.Cells[0].Controls[0];
                // Get the javascript which is assigned to this LinkButton
                string _jsDouble =
                ClientScript.GetPostBackClientHyperlink(_doubleClickButton, "");
                // Add this javascript to the ondblclick Attribute of the row
                e.Row.Attributes["ondblclick"] = _jsDouble;
            }
        }
    }
}