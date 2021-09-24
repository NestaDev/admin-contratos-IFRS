using DevExpress.Web.ASPxTreeList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebNesta_IRFS_16
{
    public partial class Item : BasePage.BasePage
    {
        public static string str_conn = System.Configuration.ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        public static string lang;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                mv_Content.SetActiveView(this.vw_Itemização);
            }
            ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
            treeView.DataBind();
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)dropEditProduto.FindControl("gridItemProdutos");
            grid.DataBind();
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
        protected void btnSelectLoja_Click(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)dropEditProduto.FindControl("gridItemProdutos");
            int Index = Convert.ToInt32(grid.FocusedRowIndex);
            string ENDSITEM, ENCDITEM, TVIDITEM;
            ENDSITEM = grid.GetRowValues(grid.FocusedRowIndex, "ENDSITEM").ToString();
            ENCDITEM = grid.GetRowValues(grid.FocusedRowIndex, "ENCDITEM").ToString();
            TVIDITEM = grid.GetRowValues(grid.FocusedRowIndex, "TVIDITEM").ToString();
            dropEditProduto.Text = ENDSITEM;
            CarregaProduto(Index);
        }
        protected void CarregaProduto(int RowIndex,string codigo=null ,bool index=true)
        {
            string ENDSITEM=null, ENCDITEM=null, TVIDITEM=null;
            if (index)
            {
                DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)dropEditProduto.FindControl("gridItemProdutos");                
                ENDSITEM = grid.GetRowValues(RowIndex, "ENDSITEM").ToString();
                ENCDITEM = grid.GetRowValues(RowIndex, "ENCDITEM").ToString();
                TVIDITEM = grid.GetRowValues(RowIndex, "TVIDITEM").ToString();
            }
            else
            {
                TVIDITEM = codigo.Split('#')[0];
                ENCDITEM = codigo.Split('#')[1];
            }
            if (TVIDITEM != null)
            {
                string sqlSelect = "SELECT I.ENCDITEM,I.ENSGITEM,I.ENDSITEM, " +
                "REPLICATE(0,3-LEN(N.TVIDITEM)) + CAST(N.TVIDITEM AS VARCHAR) + '.' + REPLICATE(0,3-LEN(G.TVIDITEM)) + CAST(G.TVIDITEM AS VARCHAR) + '.' + REPLICATE(0,3-LEN(T.TVIDITEM)) + CAST(T.TVIDITEM AS VARCHAR) + '.' + REPLICATE(0,3-LEN(I.ENCDITEM)) + CAST(I.ENCDITEM AS VARCHAR) NGTI, " +
                "I.ENCDLINH,I.ENCDCATA,I.ENDSDESE,I.ENQTPESO,I.ENQTEMBA,I.ENUNIMED " +
                "FROM TVITEMIZ N " +
                "JOIN TVITEMIZ G ON(G.TVCDITEM = N.TVIDITEM) " +
                "JOIN TVITEMIZ T ON(T.TVCDITEM = G.TVIDITEM) " +
                "JOIN ENGENHAR I ON(I.TVIDITEM = T.TVIDITEM) " +
                "LEFT OUTER JOIN FOFORNEC B ON(B.FOIDFORN = I.ENIDBOLS) " +
                "LEFT OUTER JOIN PRPRODUT P ON(P.PRPRODID = I.ENDIPRDB) " +
                "where I.TVIDITEM=" + TVIDITEM + " AND I.ENCDITEM = " + ENCDITEM + " ";
                var result = DataBase.Consultas.Consulta(str_conn,sqlSelect,10);
                txtCodigo.Text = result[0];
                txtCodigo.Enabled = false;
                txtDescAbre.Text = result[1];
                txtDescAbre.Enabled = false;
                txtDesc.Text = result[2];
                dropEditProduto.Text = result[2];
                txtDesc.Enabled = false;
                txtNGTI.Text = result[3];
                txtNGTI.Enabled = false;
                txtLinProd.Text = result[4];
                txtLinProd.Enabled = false;
                txtCatalogo.Text = result[5];
                txtCatalogo.Enabled = false;
                txtDesenho.Text = result[6];
                txtDesenho.Enabled = false;
                txtPeso.Text = result[7];
                txtPeso.Enabled = false;
                txtQtdEmba.Text = result[8];
                txtQtdEmba.Enabled = false;
                dropUnidadeMedida.Value = result[9];
                dropUnidadeMedida.Enabled = false;
                mv_Content.SetActiveView(this.vw_Itemização);
                btnExcluirProd.ClientEnabled = true;
                btnAlterarProd.ClientEnabled = true;
            }
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSITEM"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void TreeList2_CustomJSProperties(object sender, TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSITEM"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void ComandProdutos(object sender, CommandEventArgs args)
        {
            hfOperacao.Value = args.CommandArgument.ToString();
            switch(hfOperacao.Value)
            {
                case "inserir":
                    string ENCDITEM = DataBase.Consultas.Consulta(str_conn, "select case when max(ENCDITEM) is null then 1 else max(ENCDITEM)+1 end from ENGENHAR where TVIDITEM=" + hfDropItem.Value, 1)[0];
                    txtCodigo.Text = ENCDITEM;
                    txtDescAbre.Enabled = true;
                    txtDesc.Enabled = true;
                    txtLinProd.Enabled = true;
                    txtCatalogo.Enabled = true;
                    txtDesenho.Enabled = true;
                    txtPeso.Enabled = true;
                    txtQtdEmba.Enabled = true;
                    dropUnidadeMedida.Enabled = true;
                    mv_Content.SetActiveView(this.vw_Itemização);
                    break;
                case "InserirNGT":
                    mv_Content.SetActiveView(this.vw_Produto);
                    if (hfDropItem.Value != "")
                        dropNivel.Value = hfDropItem.Value;
                    dropNivel.Enabled = true;
                    txtDescNGT.Enabled = true;
                    break;
                case "AlterarNGT":
                    mv_Content.SetActiveView(this.vw_Produto);
                    var result = DataBase.Consultas.Consulta(str_conn, "select TVDSITEM,TVCDITEM from TVITEMIZ where TVIDITEM="+ hfDropItem.Value, 2);
                    if (result[1] == "0")
                        dropNivel.Value = null;
                    else
                        dropNivel.Value = result[1];
                    txtDescNGT.Text = result[0];
                    dropNivel.Enabled = true;
                    txtDescNGT.Enabled = true;
                    break;
                case "alterar":
                    txtDescAbre.Enabled = true;
                    txtDesc.Enabled = true;
                    txtLinProd.Enabled = true;
                    txtCatalogo.Enabled = true;
                    txtDesenho.Enabled = true;
                    txtPeso.Enabled = true;
                    txtQtdEmba.Enabled = true;
                    dropUnidadeMedida.Enabled = true;
                    btnExcluirProd.ClientEnabled = false;
                    btnAlterarProd.ClientEnabled = false;
                    mv_Content.SetActiveView(this.vw_Itemização);
                    break;
                case "excluir":
                    btnExcluirProd.ClientEnabled = false;
                    btnAlterarProd.ClientEnabled = false;
                    mv_Content.SetActiveView(this.vw_Itemização);
                    break;
            }
            btnOKProd.ClientEnabled = true;
            btnOKCancelar.ClientEnabled = true;
        }
        protected void btnOKProd_Click(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxGridView grid = (DevExpress.Web.ASPxGridView)dropEditProduto.FindControl("gridItemProdutos");
            ASPxTreeList treeView = ((ASPxTreeList)ddeEstruturaInsert.FindControl("TreeList"));
            
            string exec;
            switch (hfOperacao.Value)
            {
                case "inserir":
                    string sqlInsert= "insert into ENGENHAR (TVIDITEM,ENCDITEM,ENSGITEM,ENDSITEM,ENCDLINH,ENCDCATA,ENDSDESE,ENQTPESO,ENQTEMBA,ENUNIMED) " +
                            "values(@TVIDITEM,'@ENCDITEM', '@ENSGITEM', '@ENDSITEM', '@ENCDLINH', '@ENCDCATA', '@ENDSDESE', @ENQTPESO, @ENQTEMBA, '@ENUNIMED')";
                    sqlInsert = sqlInsert.Replace("@TVIDITEM", hfDropItem.Value);
                    sqlInsert = sqlInsert.Replace("@ENCDITEM", txtCodigo.Text);
                    sqlInsert = sqlInsert.Replace("@ENSGITEM", txtDescAbre.Text);
                    sqlInsert = sqlInsert.Replace("@ENDSITEM", txtDesc.Text);
                    sqlInsert = sqlInsert.Replace("@ENCDLINH", txtLinProd.Text);
                    sqlInsert = sqlInsert.Replace("@ENCDCATA", txtCatalogo.Text);
                    sqlInsert = sqlInsert.Replace("@ENDSDESE", txtDesenho.Text);
                    sqlInsert = sqlInsert.Replace("@ENQTPESO", txtPeso.Text.Replace(",","."));
                    sqlInsert = sqlInsert.Replace("@ENQTEMBA", txtQtdEmba.Text.Replace(",", "."));
                    sqlInsert = sqlInsert.Replace("@ENUNIMED", dropUnidadeMedida.Value.ToString());
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                    if (exec == "OK")
                    {
                        grid.DataBind();
                        CarregaProduto(0, hfDropItem.Value + "#" + txtCodigo.Text, false);
                    }
                    else
                        MsgException(exec, 1);
                    break;
                case "alterar":
                    string sqlUpdate = "update ENGENHAR set ENSGITEM='@ENSGITEM',ENDSITEM='@ENDSITEM',ENCDLINH='@ENCDLINH',ENCDCATA='@ENCDCATA',ENDSDESE='@ENDSDESE',ENQTPESO=@ENQTPESO,ENQTEMBA=@ENQTEMBA,ENUNIMED='@ENUNIMED' " +
        " where TVIDITEM=@TVIDITEM and ENCDITEM='@ENCDITEM'";
                    sqlUpdate = sqlUpdate.Replace("@TVIDITEM", hfDropItem.Value);
                    sqlUpdate = sqlUpdate.Replace("@ENCDITEM", txtCodigo.Text);
                    sqlUpdate = sqlUpdate.Replace("@ENSGITEM", txtDescAbre.Text);
                    sqlUpdate = sqlUpdate.Replace("@ENDSITEM", txtDesc.Text);
                    sqlUpdate = sqlUpdate.Replace("@ENCDLINH", txtLinProd.Text);
                    sqlUpdate = sqlUpdate.Replace("@ENCDCATA", txtCatalogo.Text);
                    sqlUpdate = sqlUpdate.Replace("@ENDSDESE", txtDesenho.Text);
                    sqlUpdate = sqlUpdate.Replace("@ENQTPESO", txtPeso.Text.Replace(",", "."));
                    sqlUpdate = sqlUpdate.Replace("@ENQTEMBA", txtQtdEmba.Text.Replace(",", "."));
                    sqlUpdate = sqlUpdate.Replace("@ENUNIMED", dropUnidadeMedida.SelectedItem.Text.ToString());
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                    if (exec == "OK")
                    {
                        grid.DataBind();
                        CarregaProduto(0, hfDropItem.Value + "#" + txtCodigo.Text, false);
                    }
                    else
                        MsgException(exec, 1);
                    break;
                case "excluir":
                    break;
                case "InserirNGT":
                    mv_Content.SetActiveView(this.vw_Produto);
                    string TVIDITEM = DataBase.Consultas.Consulta(str_conn, "select max(TVIDITEM)+1 from TVITEMIZ", 1)[0];
                    string TVDSITEM = txtDescNGT.Text;
                    string TVCDITEM = hfDropItem.Value == "" ? "0" : hfDropItem.Value;
                    string TVNVITEMtemp = DataBase.Consultas.Consulta(str_conn, "select TVNVITEM FROM TVITEMIZ where TVIDITEM="+ TVCDITEM, 1)[0];
                    string TVNVITEM = TVNVITEMtemp == null ? "0" : TVNVITEMtemp;
                    string sqlInsertNGT = "INSERT INTO TVITEMIZ (TVIDITEM,TVDSITEM,TVCDITEM,TVNVITEM) "+
                                        "VALUES(@TVIDITEM, '@TVDSITEM', @TVCDITEM, @TVNVITEM)";
                    sqlInsertNGT = sqlInsertNGT.Replace("@TVIDITEM", TVIDITEM);
                    sqlInsertNGT = sqlInsertNGT.Replace("@TVDSITEM", TVDSITEM);
                    sqlInsertNGT = sqlInsertNGT.Replace("@TVCDITEM", TVCDITEM);
                    sqlInsertNGT = sqlInsertNGT.Replace("@TVNVITEM", TVNVITEM);
                    exec = DataBase.Consultas.InsertInto(str_conn, sqlInsertNGT);
                    if (exec == "OK")
                    {
                        treeView.DataBind();
                        dropNivel.Enabled = false;
                        txtDescNGT.Enabled = false;
                    }
                    else
                        MsgException(exec, 1);
                    
                    break;
                case "AlterarNGT":
                    mv_Content.SetActiveView(this.vw_Produto);
                    string sqlUpdateNGT = "UPDATE TVITEMIZ SET TVDSITEM='@TVDSITEM', TVCDITEM=@TVCDITEM" +
                                        "WHERE TVIDITEM=@TVIDITEM ";
                    sqlUpdateNGT = sqlUpdateNGT.Replace("@TVIDITEM", hfDropItem.Value);
                    sqlUpdateNGT = sqlUpdateNGT.Replace("@TVDSITEM", txtDescNGT.Text);
                    if(dropNivel.Value==null)
                        sqlUpdateNGT = sqlUpdateNGT.Replace("@TVCDITEM", "0");
                    else
                        sqlUpdateNGT = sqlUpdateNGT.Replace("@TVCDITEM", dropNivel.Value.ToString());
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdateNGT);
                    if (exec == "OK")
                    {
                        treeView.DataBind();
                        dropNivel.Enabled = false;
                        txtDescNGT.Enabled = false;
                    }
                    else
                        MsgException(exec, 1);
                    break;
            }
            btnOKProd.ClientEnabled = false;
            btnOKCancelar.ClientEnabled = false;
        }
        protected void btnOKCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Item");
        }
    }
}