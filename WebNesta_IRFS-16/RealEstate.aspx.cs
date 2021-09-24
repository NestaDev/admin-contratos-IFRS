using DevExpress.Web;
using DevExpress.Web.ASPxTreeList;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.EnterpriseServices;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;

namespace WebNesta_IRFS_16
{
    public partial class RealEstate : BasePage.BasePage
    {
        public static string str_conn = ConfigurationManager.ConnectionStrings["bd_app"].ConnectionString;
        List<string> imageNames;
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("acesso")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            else
            {
                hfUser.Value = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
                hfUser2.Value = hfUser.Value;
            }
            if (!IsPostBack)
            {
                hfIDImovel.Value = null;
                ControlesView("consulta");
            }
            DataBase.Consultas.Usuario = hfUser.Value;
            DataBase.Consultas.Tela = Request.Url.Segments[Request.Url.Segments.Length - 1].Replace(".aspx", "");
        }
        protected void TreeList_CustomJSProperties(object sender, DevExpress.Web.ASPxTreeList.TreeListCustomJSPropertiesEventArgs e)
        {
            ASPxTreeList treeList = sender as ASPxTreeList;
            System.Collections.Hashtable nameTable = new System.Collections.Hashtable();
            foreach (TreeListNode node in treeList.GetVisibleNodes())
                nameTable.Add(node.Key, string.Format("{0}", node["TVDSESTR"]));
            e.Properties["cpEmployeeNames"] = nameTable;
        }
        protected void TreeList_Load(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treelist = (DevExpress.Web.ASPxTreeList.ASPxTreeList)sender;
            if (SqlDataSource1 == null) return;
            treelist.DataBind();
        }
        protected void btnSalvar_Click(object sender, EventArgs e)
        {
            if (hfDropEstr.Value != string.Empty)
            {
                lblEstCorpoErro.Visible = false;
                string sqlInsert = "INSERT INTO REIMOVEL(TVIDESTR,TPIDIMOV,REREGIAO,RECONTRI,REENDERC,RECEPZIP,RELOGRAD,REANOCTR,RESITLEG,REPROREG,RETESTAD,REM2TERR,REM2EDIF,REM2COMU,REFRACAO,REVVENAL,REDTREGI) " +
                                    "VALUES(@TVIDESTR, @TPIDIMOV, @REREGIAO, @RECONTRI, @REENDERC, @RECEPZIP, @RELOGRAD, @REANOCTR, @RESITLEG, @REPROREG, @RETESTAD, @REM2TERR, @REM2EDIF, @REM2COMU, @REFRACAO, @REVVENAL, convert(date, '@REDTREGI', 103))";
                string TVIDESTR = hfDropEstr.Value;
                string TPIDIMOV = dropTipoImov.Value.ToString();
                string REREGIAO = txtRegAdmin.Text == string.Empty ? "NULL" : "'" + txtRegAdmin.Text + "'";
                string RECONTRI = txtNoContribu.Text == string.Empty ? "NULL" : "'" + txtNoContribu.Text + "'";
                string REENDERC = ddeGeoLocal.Text == string.Empty ? "NULL" : "'" + ddeGeoLocal.Text + "'";
                string RECEPZIP = txtCep.Text == string.Empty ? "NULL" : "'" + txtCep.Text + "'";
                string RELOGRAD = dropLogradoura.Value.ToString() == string.Empty ? "NULL" : "'" + dropLogradoura.Value.ToString() + "'";
                string REANOCTR = txtAnoConst.Text == string.Empty ? "NULL" : txtAnoConst.Text;
                string RESITLEG = dropSituacao.SelectedItem.Value.ToString() == string.Empty ? "NULL" : "'" + dropSituacao.SelectedItem.Value.ToString() + "'";
                string REPROREG = txtNoProcRegis.Text == string.Empty ? "NULL" : "'" + txtNoProcRegis.Text + "'";
                string RETESTAD = txtTestadaPrinc.Text == string.Empty ? "NULL" : txtTestadaPrinc.Text;
                string REM2TERR = txtAreaTerreno.Text == string.Empty ? "NULL" : txtAreaTerreno.Text;
                string REM2EDIF = txtAreaEdificada.Text == string.Empty ? "NULL" : txtAreaEdificada.Text;
                string REM2COMU = txtAreaComum.Text == string.Empty ? "NULL" : txtAreaComum.Text;
                string REFRACAO = txtFracIdeal.Text == string.Empty ? "NULL" : txtFracIdeal.Text;
                string REVVENAL = txtValorVenal.Text == string.Empty ? "NULL" : txtValorVenal.Text;
                string REDTREGI = txtDataRegis.Text == string.Empty ? "NULL" : txtDataRegis.Text;
                sqlInsert = sqlInsert.Replace("@TVIDESTR", TVIDESTR);
                sqlInsert = sqlInsert.Replace("@TPIDIMOV", TPIDIMOV);
                sqlInsert = sqlInsert.Replace("@REREGIAO", REREGIAO);
                sqlInsert = sqlInsert.Replace("@RECONTRI", RECONTRI);
                sqlInsert = sqlInsert.Replace("@REENDERC", REENDERC);
                sqlInsert = sqlInsert.Replace("@RECEPZIP", RECEPZIP.Replace("-", ""));
                sqlInsert = sqlInsert.Replace("@RELOGRAD", RELOGRAD);
                sqlInsert = sqlInsert.Replace("@REANOCTR", REANOCTR);
                sqlInsert = sqlInsert.Replace("@RESITLEG", RESITLEG);
                sqlInsert = sqlInsert.Replace("@REPROREG", REPROREG);
                sqlInsert = sqlInsert.Replace("@RETESTAD", RETESTAD.Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REM2TERR", REM2TERR.Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REM2EDIF", REM2EDIF.Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REM2COMU", REM2COMU.Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REFRACAO", REFRACAO.Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REVVENAL", REVVENAL.Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REDTREGI", Convert.ToDateTime(REDTREGI, CultureInfo.GetCultureInfo("pt-BR")).ToString("dd/MM/yyyy"));
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if (exec == "OK")
                {
                    hfIDImovel.Value = DataBase.Consultas.Consulta(str_conn, "select max(REIDIMOV) from REIMOVEL", 1)[0];
                    if (hfIDImovel.Value != string.Empty)
                    {

                    }
                }

            }
            else
            {
                lblEstCorpoErro.Visible = true;
            }
        }
        protected void ControlesView(String tipo)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            switch (tipo)
            {
                case "inserir":
                    hfOperacao.Value = "inserir";
                    btnDelete.Enabled = false;
                    btnEdit.Enabled = false;
                    btnInsert.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    ddeEstruturaInsert.Enabled = true;
                    dropTipoImov.Enabled = true;
                    txtRegAdmin.Enabled = true;
                    txtNoContribu.Enabled = true;
                    ddeGeoLocal.Enabled = true;
                    txtCep.Enabled = true;
                    dropLogradoura.Enabled = true;
                    txtAnoConst.Enabled = true;
                    dropSituacao.Enabled = true;
                    txtNoProcRegis.Enabled = true;
                    txtTestadaPrinc.Enabled = true;
                    txtAreaTerreno.Enabled = true;
                    txtAreaEdificada.Enabled = true;
                    txtAreaComum.Enabled = true;
                    txtFracIdeal.Enabled = true;
                    txtDataRegis.Enabled = true;
                    txtValorVenal.Enabled = true;
                    txtDataVistoria.Enabled = true;
                    txtDataReceb.Enabled = true;
                    txtDataDevol.Enabled = true;
                    txtDataInaug.Enabled = true;
                    gridPropri.SettingsDataSecurity.AllowInsert = false;
                    gridPropri.SettingsDataSecurity.AllowDelete = false;
                    gridPropri.SettingsDataSecurity.AllowEdit = false;
                    gridImpostos.SettingsDataSecurity.AllowInsert = false;
                    gridImpostos.SettingsDataSecurity.AllowDelete = false;
                    gridImpostos.SettingsDataSecurity.AllowEdit = false;
                    break;
                case "inserir2":
                    btnDelete.Enabled = false;
                    btnEdit.Enabled = false;
                    btnInsert.Enabled = false;
                    btnOK.Enabled = false;
                    btnCancelar.Enabled = true;
                    ddeEstruturaInsert.Enabled = false;
                    dropTipoImov.Enabled = false;
                    txtRegAdmin.Enabled = false;
                    txtNoContribu.Enabled = false;
                    ddeGeoLocal.Enabled = false;
                    txtCep.Enabled = false;
                    dropLogradoura.Enabled = false;
                    txtAnoConst.Enabled = false;
                    dropSituacao.Enabled = false;
                    txtNoProcRegis.Enabled = false;
                    txtTestadaPrinc.Enabled = false;
                    txtAreaTerreno.Enabled = false;
                    txtAreaEdificada.Enabled = false;
                    txtAreaComum.Enabled = false;
                    txtFracIdeal.Enabled = false;
                    txtDataRegis.Enabled = false;
                    txtValorVenal.Enabled = false;
                    txtDataVistoria.Enabled = false;
                    txtDataReceb.Enabled = false;
                    txtDataDevol.Enabled = false;
                    txtDataInaug.Enabled = false;
                    gridPropri.SettingsDataSecurity.AllowInsert = true;
                    gridPropri.SettingsDataSecurity.AllowDelete = true;
                    gridPropri.SettingsDataSecurity.AllowEdit = true;
                    gridImpostos.SettingsDataSecurity.AllowInsert = true;
                    gridImpostos.SettingsDataSecurity.AllowDelete = true;
                    gridImpostos.SettingsDataSecurity.AllowEdit = true;
                    fileManager.SettingsEditing.AllowCreate = true;
                    fileManager.SettingsEditing.AllowDelete = true;
                    fileManager.SettingsEditing.AllowMove = true;
                    fileManager.SettingsEditing.AllowRename = true;
                    fileManager.SettingsEditing.AllowCopy = true;
                    fileManager.SettingsEditing.AllowDownload = true;
                    fileManager.SettingsUpload.Enabled = true;
                    break;
                case "consulta":
                    hfOperacao.Value = "consulta";
                    if (!IsPostBack)
                    {
                        btnDelete.Enabled = false;
                        btnEdit.Enabled = false;
                        btnInsert.Enabled = perfil != "3";
                        btnOK.Enabled = false;
                        btnCancelar.Enabled = false;
                    }
                    else
                    {
                        btnDelete.Enabled = perfil != "3";
                        btnEdit.Enabled = perfil != "3";
                        btnInsert.Enabled = false;
                        btnOK.Enabled = false;
                        btnCancelar.Enabled = false;
                    }
                    ddeEstruturaInsert.Enabled = false;
                    dropTipoImov.Enabled = false;
                    txtRegAdmin.Enabled = false;
                    txtNoContribu.Enabled = false;
                    ddeGeoLocal.Enabled = false;
                    txtCep.Enabled = false;
                    dropLogradoura.Enabled = false;
                    txtAnoConst.Enabled = false;
                    dropSituacao.Enabled = false;
                    txtNoProcRegis.Enabled = false;
                    txtTestadaPrinc.Enabled = false;
                    txtAreaTerreno.Enabled = false;
                    txtAreaEdificada.Enabled = false;
                    txtAreaComum.Enabled = false;
                    txtFracIdeal.Enabled = false;
                    txtDataRegis.Enabled = false;
                    txtValorVenal.Enabled = false;
                    txtDataVistoria.Enabled = false;
                    txtDataReceb.Enabled = false;
                    txtDataDevol.Enabled = false;
                    txtDataInaug.Enabled = false;
                    gridPropri.SettingsDataSecurity.AllowInsert = false;
                    gridPropri.SettingsDataSecurity.AllowDelete = false;
                    gridPropri.SettingsDataSecurity.AllowEdit = false;
                    gridImpostos.SettingsDataSecurity.AllowInsert = false;
                    gridImpostos.SettingsDataSecurity.AllowDelete = false;
                    gridImpostos.SettingsDataSecurity.AllowEdit = false;
                    fileManager.SettingsEditing.AllowCreate = false;
                    fileManager.SettingsEditing.AllowDelete = false;
                    fileManager.SettingsEditing.AllowMove = false;
                    fileManager.SettingsEditing.AllowRename = false;
                    fileManager.SettingsEditing.AllowCopy = false;
                    fileManager.SettingsEditing.AllowDownload = false;
                    fileManager.SettingsUpload.Enabled = false;
                    break;
                case "alterar":
                    hfOperacao.Value = "alterar";
                    btnDelete.Enabled = false;
                    btnEdit.Enabled = false;
                    btnInsert.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    ddeEstruturaInsert.Enabled = false;
                    dropTipoImov.Enabled = false;
                    txtRegAdmin.Enabled = true;
                    txtNoContribu.Enabled = false;
                    ddeGeoLocal.Enabled = false;
                    txtCep.Enabled = false;
                    dropLogradoura.Enabled = false;
                    txtAnoConst.Enabled = false;
                    dropSituacao.Enabled = true;
                    txtNoProcRegis.Enabled = false;
                    txtTestadaPrinc.Enabled = true;
                    txtAreaTerreno.Enabled = true;
                    txtAreaEdificada.Enabled = true;
                    txtAreaComum.Enabled = true;
                    txtFracIdeal.Enabled = true;
                    txtDataRegis.Enabled = false;
                    txtValorVenal.Enabled = true;
                    txtDataVistoria.Enabled = true;
                    txtDataReceb.Enabled = true;
                    txtDataDevol.Enabled = true;
                    txtDataInaug.Enabled = true;
                    gridPropri.SettingsDataSecurity.AllowInsert = true;
                    gridPropri.SettingsDataSecurity.AllowDelete = true;
                    gridPropri.SettingsDataSecurity.AllowEdit = true;
                    gridImpostos.SettingsDataSecurity.AllowInsert = true;
                    gridImpostos.SettingsDataSecurity.AllowDelete = true;
                    gridImpostos.SettingsDataSecurity.AllowEdit = true;
                    fileManager.SettingsEditing.AllowCreate = true;
                    fileManager.SettingsEditing.AllowDelete = true;
                    fileManager.SettingsEditing.AllowMove = true;
                    fileManager.SettingsEditing.AllowRename = true;
                    fileManager.SettingsEditing.AllowCopy = true;
                    fileManager.SettingsEditing.AllowDownload = true;
                    fileManager.SettingsUpload.Enabled = true;
                    break;
                case "excluir":
                    hfOperacao.Value = "excluir";
                    btnDelete.Enabled = false;
                    btnEdit.Enabled = false;
                    btnInsert.Enabled = false;
                    btnOK.Enabled = true;
                    btnCancelar.Enabled = true;
                    break;
            }
        }
        protected void btnInsert_Command(object sender, CommandEventArgs e)
        {
            ControlesView(e.CommandArgument.ToString());
        }
        protected void btnOK_Click(object sender, EventArgs e)
        {
            string exec = string.Empty;
            switch (hfOperacao.Value)
            {
                case "inserir":
                    if (hfDropEstr.Value != string.Empty)
                    {
                        lblEstCorpoErro.Visible = false;
                        string sqlInsert = "INSERT INTO REIMOVEL(TVIDESTR,TPIDIMOV,REREGIAO,RECONTRI,REENDERC,RECEPZIP,RELOGRAD,REANOCTR,RESITLEG,REPROREG,RETESTAD,REM2TERR,REM2EDIF,REM2COMU,REFRACAO,REVVENAL,REDTREGI) " +
                                            "VALUES(@TVIDESTR, @TPIDIMOV, @REREGIAO, @RECONTRI, @REENDERC, @RECEPZIP, @RELOGRAD, @REANOCTR, @RESITLEG, @REPROREG, @RETESTAD, @REM2TERR, @REM2EDIF, @REM2COMU, @REFRACAO, @REVVENAL, convert(date, '@REDTREGI', 103))";
                        string TVIDESTR = hfDropEstr.Value;
                        string TPIDIMOV = dropTipoImov.Value.ToString();
                        string REREGIAO = txtRegAdmin.Text == string.Empty ? "NULL" : "'" + txtRegAdmin.Text + "'";
                        string RECONTRI = txtNoContribu.Text == string.Empty ? "NULL" : "'" + txtNoContribu.Text + "'";
                        string REENDERC = ddeGeoLocal.Text == string.Empty ? "NULL" : "'" + ddeGeoLocal.Text + "'";
                        string RECEPZIP = txtCep.Text == string.Empty ? "NULL" : "'" + txtCep.Text + "'";
                        string RELOGRAD = dropLogradoura.Value.ToString() == string.Empty ? "NULL" : "'" + dropLogradoura.Value.ToString() + "'";
                        string REANOCTR = txtAnoConst.Text == string.Empty ? "NULL" : txtAnoConst.Text;
                        string RESITLEG = dropSituacao.SelectedItem.Value.ToString() == string.Empty ? "NULL" : "'" + dropSituacao.SelectedItem.Value.ToString() + "'";
                        string REPROREG = txtNoProcRegis.Text == string.Empty ? "NULL" : "'" + txtNoProcRegis.Text + "'";
                        string RETESTAD = txtTestadaPrinc.Text == string.Empty ? "NULL" : txtTestadaPrinc.Text;
                        string REM2TERR = txtAreaTerreno.Text == string.Empty ? "NULL" : txtAreaTerreno.Text;
                        string REM2EDIF = txtAreaEdificada.Text == string.Empty ? "NULL" : txtAreaEdificada.Text;
                        string REM2COMU = txtAreaComum.Text == string.Empty ? "NULL" : txtAreaComum.Text;
                        string REFRACAO = txtFracIdeal.Text == string.Empty ? "NULL" : txtFracIdeal.Text;
                        string REVVENAL = txtValorVenal.Text == string.Empty ? "NULL" : txtValorVenal.Text;
                        string REDTREGI = txtDataRegis.Text == string.Empty ? "NULL" : txtDataRegis.Text;
                        sqlInsert = sqlInsert.Replace("@TVIDESTR", TVIDESTR);
                        sqlInsert = sqlInsert.Replace("@TPIDIMOV", TPIDIMOV);
                        sqlInsert = sqlInsert.Replace("@REREGIAO", REREGIAO);
                        sqlInsert = sqlInsert.Replace("@RECONTRI", RECONTRI);
                        sqlInsert = sqlInsert.Replace("@REENDERC", REENDERC);
                        sqlInsert = sqlInsert.Replace("@RECEPZIP", RECEPZIP.Replace("-", ""));
                        sqlInsert = sqlInsert.Replace("@RELOGRAD", RELOGRAD);
                        sqlInsert = sqlInsert.Replace("@REANOCTR", REANOCTR);
                        sqlInsert = sqlInsert.Replace("@RESITLEG", RESITLEG);
                        sqlInsert = sqlInsert.Replace("@REPROREG", REPROREG);
                        sqlInsert = sqlInsert.Replace("@RETESTAD", RETESTAD.Replace(",", "."));
                        sqlInsert = sqlInsert.Replace("@REM2TERR", REM2TERR.Replace(",", "."));
                        sqlInsert = sqlInsert.Replace("@REM2EDIF", REM2EDIF.Replace(",", "."));
                        sqlInsert = sqlInsert.Replace("@REM2COMU", REM2COMU.Replace(",", "."));
                        sqlInsert = sqlInsert.Replace("@REFRACAO", REFRACAO.Replace(",", "."));
                        sqlInsert = sqlInsert.Replace("@REVVENAL", REVVENAL.Replace(",", "."));
                        sqlInsert = sqlInsert.Replace("@REDTREGI", Convert.ToDateTime(REDTREGI, CultureInfo.GetCultureInfo("pt-BR")).ToString("dd/MM/yyyy"));
                        exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                        if (exec == "OK")
                        {
                            hfIDImovel.Value = DataBase.Consultas.Consulta(str_conn, "select max(REIDIMOV) from REIMOVEL", 1)[0];
                            if (hfIDImovel.Value != string.Empty)
                            {
                                string sqlInsPosse = "INSERT INTO REPOSSES(REIDIMOV,REDTVIST,REDTRECH,REDTDVCH,REDTINAU) " +
                                "VALUES(@REIDIMOV, convert(date, '@REDTVIST', 103), convert(date, '@REDTRECH', 103), convert(date, '@REDTDVCH', 103), convert(date, '@REDTINAU', 103))";
                                sqlInsPosse = sqlInsPosse.Replace("@REIDIMOV", hfIDImovel.Value);
                                sqlInsPosse = sqlInsPosse.Replace("@REDTVIST", Convert.ToDateTime(txtDataVistoria.Text).ToString("dd/MM/yyyy"));
                                sqlInsPosse = sqlInsPosse.Replace("@REDTRECH", Convert.ToDateTime(txtDataReceb.Text).ToString("dd/MM/yyyy"));
                                sqlInsPosse = sqlInsPosse.Replace("@REDTDVCH", Convert.ToDateTime(txtDataDevol.Text).ToString("dd/MM/yyyy"));
                                sqlInsPosse = sqlInsPosse.Replace("@REDTINAU", Convert.ToDateTime(txtDataInaug.Text).ToString("dd/MM/yyyy"));
                                exec = DataBase.Consultas.InsertInto(str_conn, sqlInsPosse);
                                string sqlInsFolder = "INSERT INTO REFOLDER(REIDIMOV,REFOLDER)VALUES(@REIDIMOV,'@REFOLDER')";
                                sqlInsFolder = sqlInsFolder.Replace("@REIDIMOV", hfIDImovel.Value);
                                string dirNew = hfIDImovel.Value + DateTime.Now.ToString("ddMMyyyyHHmmssfff");
                                sqlInsFolder = sqlInsFolder.Replace("@REFOLDER", dirNew);
                                exec = DataBase.Consultas.InsertInto(str_conn, sqlInsFolder);
                                if (exec == "OK")
                                {
                                    string dir = Server.MapPath("GED");
                                    if (Directory.Exists(Path.Combine(dir, dirNew)))
                                        Directory.Delete(Path.Combine(dir, dirNew), true);
                                    Directory.CreateDirectory(Path.Combine(dir, dirNew));
                                    if (Directory.Exists(Path.Combine(dir, dirNew)))
                                    {
                                        fileManager.Settings.RootFolder = @"~/GED/" + dirNew;
                                        fileManager.Visible = true;
                                    }
                                }
                                ControlesView("inserir2");
                            }
                        }

                    }
                    else
                    {
                        lblEstCorpoErro.Visible = true;
                    }
                    break;
                case "alterar":
                    string sqlUpdImovel = "UPDATE REIMOVEL SET REREGIAO = '@REREGIAO' ,RESITLEG = '@RESITLEG' ,RETESTAD = @RETESTAD ,REM2TERR = @REM2TERR ,REM2EDIF = @REM2EDIF ,REM2COMU = @REM2COMU ,REFRACAO = @REFRACAO ,REVVENAL = @REVVENAL " +
 "WHERE REIDIMOV = @REIDIMOV";
                    sqlUpdImovel = sqlUpdImovel.Replace("@REREGIAO", txtRegAdmin.Text);
                    sqlUpdImovel = sqlUpdImovel.Replace("@RESITLEG", dropSituacao.SelectedItem.Value.ToString());
                    sqlUpdImovel = sqlUpdImovel.Replace("@RETESTAD", txtTestadaPrinc.Text.Replace(",", "."));
                    sqlUpdImovel = sqlUpdImovel.Replace("@REM2TERR", txtAreaTerreno.Text.Replace(",", "."));
                    sqlUpdImovel = sqlUpdImovel.Replace("@REM2EDIF", txtAreaEdificada.Text.Replace(",", "."));
                    sqlUpdImovel = sqlUpdImovel.Replace("@REM2COMU", txtAreaComum.Text.Replace(",", "."));
                    sqlUpdImovel = sqlUpdImovel.Replace("@REFRACAO", txtFracIdeal.Text.Replace(",", "."));
                    sqlUpdImovel = sqlUpdImovel.Replace("@REVVENAL", txtValorVenal.Text.Replace(",", "."));
                    sqlUpdImovel = sqlUpdImovel.Replace("@REIDIMOV", hfIDImovel.Value);
                    exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdImovel);
                    if (exec == "OK")
                    {
                        string sqlUpdPosse = "UPDATE REPOSSES " +
                                               "SET REDTVIST = convert(date, '@REDTVIST', 103) " +
                                                  ", REDTRECH = convert(date, '@REDTRECH', 103) " +
                                                  ", REDTDVCH = convert(date, '@REDTDVCH', 103) " +
                                                  ", REDTINAU = convert(date, '@REDTINAU', 103) " +
                                             "WHERE REIDIMOV = @REIDIMOV";
                        sqlUpdPosse = sqlUpdPosse.Replace("@REDTVIST", Convert.ToDateTime(txtDataVistoria.Text).ToString("dd/MM/yyy"));
                        sqlUpdPosse = sqlUpdPosse.Replace("@REDTRECH", Convert.ToDateTime(txtDataReceb.Text).ToString("dd/MM/yyy"));
                        sqlUpdPosse = sqlUpdPosse.Replace("@REDTDVCH", Convert.ToDateTime(txtDataDevol.Text).ToString("dd/MM/yyy"));
                        sqlUpdPosse = sqlUpdPosse.Replace("@REDTINAU", Convert.ToDateTime(txtDataInaug.Text).ToString("dd/MM/yyy"));
                        sqlUpdPosse = sqlUpdPosse.Replace("@REIDIMOV", hfIDImovel.Value);
                        exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdPosse);
                        if (exec == "OK")
                        {
                            ControlesView("consulta");
                        }
                    }
                    break;
                case "excluir":

                    break;
            }
        }
        protected void gridPropri_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.InsertValues)
            {
                string ID = hfIDImovel.Value;
                string sqlInsert = "INSERT INTO REVIFORN(REIDIMOV,FOIDFORN,TPIDPROP,REDTVINC,REPERCVL) " +
                                    "VALUES("+ID+", "+ item.NewValues["FOIDFORN"].ToString() + ", "+ item.NewValues["TPIDPROP"].ToString() + ", convert(date, '"+ Convert.ToDateTime(item.NewValues["REDTVINC"]).ToString("dd/MM/yyyy") + "', 103),"+ item.NewValues["REPERCVL"].ToString() + ")";
                //sqlInsert = sqlInsert.Replace("@REIDIMOV", ID);
                //sqlInsert = sqlInsert.Replace("@FOIDFORN", );
                //sqlInsert = sqlInsert.Replace("@TPIDPROP", );
                //sqlInsert = sqlInsert.Replace("@REDTVINC", );
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if (exec == "OK")
                {
                    gridPropri.DataBind();
                }
            }
            foreach (var item in e.DeleteValues)
            {
                string sqlDelete = "DELETE FROM REVIFORN WHERE REIDVIFO=@REIDVIFO";
                sqlDelete = sqlDelete.Replace("@REIDVIFO", item.Keys["REIDVIFO"].ToString());
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
                if (exec == "OK")
                {
                    gridPropri.DataBind();
                }
            }
            foreach (var item in e.UpdateValues)
            {
                string FOIDFORN = item.NewValues["FOIDFORN"].ToString() == string.Empty ? item.OldValues["FOIDFORN"].ToString() : item.NewValues["FOIDFORN"].ToString();
                string TPIDPROP = item.NewValues["TPIDPROP"].ToString() == string.Empty ? item.OldValues["TPIDPROP"].ToString() : item.NewValues["TPIDPROP"].ToString();
                string REDTVINC = item.NewValues["REDTVINC"].ToString() == string.Empty ? item.OldValues["REDTVINC"].ToString() : item.NewValues["REDTVINC"].ToString();
                string REPERCVL = item.NewValues["REPERCVL"].ToString() == string.Empty ? item.OldValues["REPERCVL"].ToString() : item.NewValues["REPERCVL"].ToString();
                string sqlUpdate = "UPDATE REVIFORN SET FOIDFORN=@FOIDFORN,TPIDPROP=@TPIDPROP,REDTVINC=convert(date,'@REDTVINC',103),REPERCVL=@REPERCVL WHERE REIDVIFO=@REIDVIFO";
                sqlUpdate = sqlUpdate.Replace("@REIDVIFO", item.Keys["REIDVIFO"].ToString());
                sqlUpdate = sqlUpdate.Replace("@FOIDFORN", FOIDFORN);
                sqlUpdate = sqlUpdate.Replace("@TPIDPROP", TPIDPROP);
                sqlUpdate = sqlUpdate.Replace("@REPERCVL", REPERCVL);
                sqlUpdate = sqlUpdate.Replace("@REDTVINC", Convert.ToDateTime(REDTVINC).ToString("dd/MM/yyyy"));
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                if (exec == "OK")
                {
                    gridPropri.DataBind();
                }
            }
        }
        protected void btnSelectRE_Click(object sender, EventArgs e)
        {
            sqlImoveis.DataBind();
        }
        protected void dropImoveis_SelectedIndexChanged(object sender, EventArgs e)
        {

            CarregaImovel(dropImoveis.Value.ToString());
        }
        protected void CarregaImovel(string ID)
        {
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            dropLogradoura.DataBind();
            dropTipoImov.DataBind();
            hfIDImovel.Value = ID;
            string sqlConsulta = "SELECT T.TVIDESTR,TPIDIMOV,REREGIAO,RECONTRI,REENDERC,RECEPZIP,RELOGRAD,REANOCTR,RESITLEG,REPROREG,RETESTAD,REM2TERR,REM2EDIF,REM2COMU,REFRACAO,REVVENAL,convert(varchar,REDTREGI,103),T.TVDSESTR " +
                                    "FROM REIMOVEL R INNER JOIN TVESTRUT T ON R.TVIDESTR = T.TVIDESTR where R.REIDIMOV=" + ID;
            var result = DataBase.Consultas.Consulta(str_conn, sqlConsulta, 18);
            hfDropEstr.Value = result[0];
            hfDropEstr2.Value = result[0];
            dropTipoImov.Value = result[1];
            txtRegAdmin.Text = result[2];
            txtNoContribu.Text = result[3];
            ddeGeoLocal.Text = result[4];
            txtCep.Text = result[5];
            dropLogradoura.Value = result[6];
            txtAnoConst.Text = result[7];
            dropSituacao.Value = result[8];
            txtNoProcRegis.Text = result[9];
            txtTestadaPrinc.Text = result[10];
            txtAreaTerreno.Text = result[11];
            txtAreaEdificada.Text = result[12];
            txtAreaComum.Text = result[13];
            txtFracIdeal.Text = result[14];
            txtValorVenal.Text = result[15];
            txtDataRegis.Text = result[16];
            ddeEstruturaInsert.Text = result[17];


            string sqlConsulta2 = "SELECT convert(varchar,REDTVIST,103) " +
                                  ", convert(varchar, REDTRECH, 103) " +
                                  ", convert(varchar, REDTDVCH, 103) " +
                                  ", convert(varchar, REDTINAU, 103) " +
                              "FROM REPOSSES where REIDIMOV = " + ID;
            var result2 = DataBase.Consultas.Consulta(str_conn, sqlConsulta2, 4);
            txtDataVistoria.Text = result2[0];
            txtDataReceb.Text = result2[1];
            txtDataDevol.Text = result2[2];
            txtDataInaug.Text = result2[3];

            string sqlFolder = "SELECT REFOLDER FROM REFOLDER where REIDIMOV=" + ID + " and OPIDCONT is null";
            var result3 = DataBase.Consultas.Consulta(str_conn, sqlFolder, 1)[0];
            fileManager.Settings.RootFolder = @"~/GED/" + result3;
            fileManager.Settings.InitialFolder = @"~/GED/" + result3;
            fileManager.Visible = true;
            btnInsert.Enabled = false;
            btnEdit.Enabled = perfil != "3";
            btnDelete.Enabled = perfil != "3";
            ControlesView("consulta");
        }
        protected void TreeList_Load1(object sender, EventArgs e)
        {
            DevExpress.Web.ASPxTreeList.ASPxTreeList treelist = (DevExpress.Web.ASPxTreeList.ASPxTreeList)sender;
            if (sqlLojas == null) return;
            treelist.DataBind();
        }
        protected void gridPropri_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.VisibleIndex < 0) return;
            if (e.ButtonID == "btn_whatsapp_grid")
            {
                string whatsnum = gridPropri.GetRowValues(e.VisibleIndex, "FOWHATFO").ToString();
                if (whatsnum == string.Empty)
                {
                    e.Enabled = false;
                    e.Visible = DevExpress.Utils.DefaultBoolean.False;
                }
            }
        }
        protected void gridPropri_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            if (e.ButtonID == "btn_whatsapp_grid")
            {
                txtMsgWhats.Text = string.Empty;
                gridPropri.JSProperties["cp_origem"] = e.ButtonID;
                gridPropri.JSProperties["cp_whatsnumber"] = gridPropri.GetRowValues(e.VisibleIndex, "FOWHATFO").ToString();
                gridPropri.JSProperties["cp_contato"] = gridPropri.GetRowValues(e.VisibleIndex, "FONMCOTT").ToString();
                Session["Contato"] = gridPropri.GetRowValues(e.VisibleIndex, "FONMCOTT").ToString();
                Session["WhatsNum"] = gridPropri.GetRowValues(e.VisibleIndex, "FOWHATFO").ToString();
            }
            else if (e.ButtonID == "btn_email_grid")
            {
                string[] filePaths = Directory.GetFiles(Server.MapPath(@"\ImgEmailsTemp"));
                foreach (string filePath in filePaths)
                    File.Delete(filePath);
                Session["EmailTo"] = gridPropri.GetRowValues(e.VisibleIndex, "FOMAILFO").ToString();
                Session["Contato"] = gridPropri.GetRowValues(e.VisibleIndex, "FONMCOTT").ToString();
                Session["WhatsNum"] = gridPropri.GetRowValues(e.VisibleIndex, "FOWHATFO").ToString();
                gridPropri.JSProperties["cp_origem"] = e.ButtonID;
                gridPropri.JSProperties["cp_whatsnumber"] = gridPropri.GetRowValues(e.VisibleIndex, "FOWHATFO").ToString();
                gridPropri.JSProperties["cp_contato"] = gridPropri.GetRowValues(e.VisibleIndex, "FONMCOTT").ToString();
            }
        }
        protected void ASPxButton1_Click(object s, EventArgs e)
        {
            try
            {
                // Assign a sender, recipient and subject to new mail message
                MailAddress sender = new MailAddress(ConfigurationManager.AppSettings["SMTP_User"], "Nesta RealEstate Mail");
                MailAddress recipient = new MailAddress(Session["EmailTo"].ToString(), Session["Contato"].ToString());
                MailMessage m = new MailMessage(sender, recipient);
                m.Subject = "Test Message";

                // Define the plain text alternate view and add to message
                AlternateView plainTextView = AlternateView.CreateAlternateViewFromString("You must use an email client that supports HTML messages", null, MediaTypeNames.Text.Plain);
                m.AlternateViews.Add(plainTextView);

                imageNames = new List<string>();
                string htmlBody = GetBodyHtml(htmlEditor.Html);

                AlternateView htmlView = AlternateView.CreateAlternateViewFromString(htmlBody, null, MediaTypeNames.Text.Html);
                foreach (string imgName in imageNames)
                {
                    LinkedResource sampleImage = new LinkedResource(MapPath(string.Format("~/" + Server.MapPath(@"\ImgEmailsTemp") + "/{0}.jpg", imgName)), MediaTypeNames.Image.Jpeg);
                    sampleImage.ContentId = imgName;
                    htmlView.LinkedResources.Add(sampleImage);
                }
                m.AlternateViews.Add(htmlView);

                //SmtpClient smtp = new SmtpClient(ConfigurationManager.AppSettings["SMTP_Server"],587);
                //smtp.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["SMTP_User"], ConfigurationManager.AppSettings["SMTP_Pass"]);
                //smtp.Send(m);

                SmtpClient smtp = new SmtpClient();
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.UseDefaultCredentials = false;
                smtp.EnableSsl = true;
                smtp.Host = ConfigurationManager.AppSettings["SMTP_Server"];
                smtp.Port = 587;
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                smtp.Credentials = new NetworkCredential(ConfigurationManager.AppSettings["SMTP_User"], ConfigurationManager.AppSettings["SMTP_Pass"]);
                smtp.Send(m);

                SmtpClient client = new SmtpClient(ConfigurationManager.AppSettings["SMTP_Server"]);
                client.DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory;
                string sqlFolder = "SELECT REFOLDER FROM REFOLDER where REIDIMOV=" + hfIDImovel.Value + " and OPIDCONT is null";
                var result3 = DataBase.Consultas.Consulta(str_conn, sqlFolder, 1)[0];
                string dir = Path.Combine(Server.MapPath("GED"), result3, ConfigurationManager.AppSettings["HistEmail"].Split('#')[0], ConfigurationManager.AppSettings["HistEmail"].Split('#')[1]);
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);
                client.PickupDirectoryLocation = dir;
                client.Send(m);

                popupMail.ShowOnPageLoad = false;
            }
            catch (ArgumentException)
            {
                throw new
                    ArgumentException("Undefined sender and/or recipient.");
            }
            catch (FormatException)
            {
                throw new
                    FormatException("Invalid sender and/or recipient.");
            }
            catch (InvalidOperationException)
            {
                throw new
                    InvalidOperationException("Undefined SMTP server.");
            }
        }
        private string GetBodyHtml(string htmlString)
        {
            Regex rgx = new Regex(@"<(img)\b[^>]*>", RegexOptions.IgnoreCase);
            MatchCollection matches = rgx.Matches(htmlString);

            string img;
            for (int i = 0, l = matches.Count; i < l; i++)
            {
                string imgName = GetImageName(matches[i].Value);
                imageNames.Add(imgName);
                img = string.Format("<img src=\"cid:{0}\">", imgName);
                htmlString = htmlString.Replace(matches[i].Value, img);
            }
            return htmlString;
        }
        public string GetImageName(string imgSource)
        {
            string src = XElement.Parse(imgSource).Attribute("src").Value;
            return Path.GetFileNameWithoutExtension(src);
        }
        protected void btnEnviarWhats_Click(object sender, EventArgs e)
        {
            string sqlFolder = "SELECT REFOLDER FROM REFOLDER where REIDIMOV=" + hfIDImovel.Value + " and OPIDCONT is null";
            var result3 = DataBase.Consultas.Consulta(str_conn, sqlFolder, 1)[0];
            string dir = Path.Combine(Server.MapPath("GED"), result3, ConfigurationManager.AppSettings["HistWhats"].Split('#')[0], ConfigurationManager.AppSettings["HistWhats"].Split('#')[1]);
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);
            string msg = string.Empty;
            msg = "#line#-----------------------";
            msg += "#line#Data hora: " + DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss");
            msg += "#line#Destinatário: " + Session["Contato"].ToString();
            msg += "#line#WhatsApp: " + Session["WhatsNum"].ToString();
            msg += "#line#Mensagem: " + txtMsgWhats.Text;
            msg += "#line#-----------------------";
            using (StreamWriter sw = File.CreateText(Path.Combine(dir, DateTime.Now.ToString("yyyy-MM-dd_HHmmss") + ".txt")))
            {
                sw.WriteLine(msg.Replace("#line#", Environment.NewLine));
            }
            string numTo = Session["WhatsNum"].ToString().Replace("-","").Replace(" ", "").Replace("(", "").Replace(")", "");
            string WMSG = txtMsgWhats.Text.Replace(" ", "%20");
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenWindow", "window.open('https://wa.me/55" + Session["WhatsNum"].ToString().Replace("(", "").Replace(")", "").Replace("-", "") + "?text=" + WMSG + "', '_blank');", true);
            DataBase.Funcoes.SendingWhats(str_conn, "55"+numTo, hfUser.Value, txtMsgWhats.Text);
            popupWhatsapp.ShowOnPageLoad = false;
        }
        protected void gridImpIncidencia_BeforePerformDataSelect(object sender, EventArgs e)
        {
            sqlREINCIDE.SelectParameters[0].DefaultValue = (sender as ASPxGridView).GetMasterRowKeyValue().ToString();

        }
        protected void gridImpostos_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            e.Handled = true;
            foreach (var item in e.InsertValues)
            {
                string sqlInsert = "INSERT INTO REVITXIM(REIDIMOV,REIDTAXA,REISENTO) VALUES(@REIDIMOV,@REIDTAXA,'@REISENTO')";
                sqlInsert = sqlInsert.Replace("@REIDIMOV", hfIDImovel.Value);
                sqlInsert = sqlInsert.Replace("@REIDTAXA", item.NewValues["REIDTAXA"].ToString());
                sqlInsert = sqlInsert.Replace("@REISENTO", item.NewValues["REISENTO"].ToString());
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if (exec == "OK")
                {
                    gridImpostos.DataBind();
                }
            }
            foreach (var item in e.DeleteValues)
            {
                string sqlDelete = "DELETE FROM REVITXIM WHERE REIDVITI=@REIDVITI";
                sqlDelete = sqlDelete.Replace("@REIDVITI", item.Keys["REIDVITI"].ToString());
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
                if (exec == "OK")
                {
                    gridImpostos.DataBind();
                }
            }
            foreach (var item in e.UpdateValues)
            {
                string REIDTAXA = item.NewValues["REIDTAXA"].ToString() == string.Empty ? item.OldValues["REIDTAXA"].ToString() : item.NewValues["REIDTAXA"].ToString();
                string REISENTO = item.NewValues["REISENTO"].ToString() == string.Empty ? item.OldValues["REISENTO"].ToString() : item.NewValues["REISENTO"].ToString();
                string sqlUpdate = "UPDATE REVITXIM SET REIDTAXA=@REIDTAXA,REISENTO='@REISENTO' WHERE REIDVITI=@REIDVITI";
                sqlUpdate = sqlUpdate.Replace("@REIDVITI", item.Keys["REIDVITI"].ToString());
                sqlUpdate = sqlUpdate.Replace("@REIDTAXA", REIDTAXA);
                sqlUpdate = sqlUpdate.Replace("@REISENTO", REISENTO);
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);
                if (exec == "OK")
                {
                    gridImpostos.DataBind();
                }
            }
        }
        protected void gridImpostos_DetailRowGetButtonVisibility(object sender, ASPxGridViewDetailRowButtonEventArgs e)
        {
            string Isento = gridImpostos.GetRowValues(e.VisibleIndex, "REISENTO").ToString();
            if (Isento == "S")
                e.ButtonState = GridViewDetailRowButtonState.Hidden;
        }
        protected void gridImpIncidencia_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            e.Handled = true;
            foreach (var item in e.InsertValues)
            {
                string sqlInsert = "INSERT INTO REINCIDE (REIDVITI,REDSINCI,REVLTOTA,RENRPARC,REDTVCPP,REVLPARC,REDTBOLE,REMAILBO,RESITEPM,REDTVCPD,REVLPAUN,REPARUNI,REANOFIS,REVLPPAR) " +
                                    "VALUES(@REIDVITI, '@REDSINCI', @REVLTOTA, @RENRPARC, convert(date, '@REDTVCPP', 103), @REVLPARC, convert(date,'@REDTBOLE',103), '@REMAILBO', '@RESITEPM', convert(date, '@REDTVCPD', 103), @REVLPAUN, '@REPARUNI',@REANOFIS,@REVLPPAR)";
                sqlInsert = sqlInsert.Replace("@REIDVITI", sqlREINCIDE.SelectParameters[0].DefaultValue);
                sqlInsert = sqlInsert.Replace("@REDSINCI", item.NewValues["REDSINCI"].ToString());
                sqlInsert = sqlInsert.Replace("@REVLTOTA", item.NewValues["REVLTOTA"].ToString().Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@RENRPARC", item.NewValues["RENRPARC"].ToString());
                sqlInsert = sqlInsert.Replace("@REDTVCPP", Convert.ToDateTime(item.NewValues["REDTVCPP"]).ToString("dd/MM/yyyy"));
                sqlInsert = sqlInsert.Replace("@REVLPARC", item.NewValues["REVLPARC"].ToString().Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REDTBOLE", Convert.ToDateTime(item.NewValues["REDTBOLE"]).ToString("dd/MM/yyyy"));
                sqlInsert = sqlInsert.Replace("@REMAILBO", item.NewValues["REMAILBO"].ToString());
                sqlInsert = sqlInsert.Replace("@RESITEPM", item.NewValues["RESITEPM"].ToString());
                sqlInsert = sqlInsert.Replace("@REDTVCPD", Convert.ToDateTime(item.NewValues["REDTVCPD"]).ToString("dd/MM/yyyy"));
                sqlInsert = sqlInsert.Replace("@REVLPAUN", item.NewValues["REVLPAUN"].ToString().Replace(",", "."));
                sqlInsert = sqlInsert.Replace("@REPARUNI", item.NewValues["REPARUNI"].ToString());
                sqlInsert = sqlInsert.Replace("@REANOFIS", Convert.ToDateTime(item.NewValues["REANOFIS"]).ToString("yyyy"));
                sqlInsert = sqlInsert.Replace("@REVLPPAR", item.NewValues["REVLPPAR"].ToString().Replace(",", "."));
                string exec = DataBase.Consultas.InsertInto(str_conn, sqlInsert);
                if(exec=="OK")
                {
                    DateTime dtExpira = Convert.ToDateTime(item.NewValues["REDTVCPP"]);
                    DataBase.WorkflowAdmin wflow = new DataBase.WorkflowAdmin();
                    wflow.str_conn = str_conn;
                    int TipoAlerta = Convert.ToInt32(DataBase.Consultas.Consulta(str_conn, "select REALTAXA from REIMPTAX WHERE REIDTAXA IN ( SELECT REIDTAXA FROM REVITXIM WHERE REIDVITI="+ sqlREINCIDE.SelectParameters[0].DefaultValue + ")",1)[0]);
                    if(TipoAlerta==1) //IPTU
                    {
                        wflow.Iptu = true;
                        wflow.DataExpira = dtExpira;
                    }
                    else if (TipoAlerta==2) //SEGURO
                    {
                        wflow.Seguro = true;
                        wflow.DataExpira = dtExpira;
                    }
                    wflow.REIDIMOV = hfIDImovel.Value;
                    wflow.Usuario = hfUser.Value;
                    wflow.Renova = 0;
                    wflow.CriarWfw();
                }
            }
            foreach (var item in e.DeleteValues)
            {
                string sqlDelete = "DELETE FROM REINCIDE WHERE REIDINCI=@REIDINCI";
                sqlDelete = sqlDelete.Replace("@REIDINCI", item.Keys["REIDINCI"].ToString());
                string exec = DataBase.Consultas.DeleteFrom(str_conn, sqlDelete);
            }
            foreach (var item in e.UpdateValues)
            {
                string REIDINCI = item.Keys["REIDINCI"].ToString();
                string REDSINCI = item.NewValues["REDSINCI"].ToString() == string.Empty ? item.OldValues["REDSINCI"].ToString() : item.NewValues["REDSINCI"].ToString();
                string REVLTOTA = item.NewValues["REVLTOTA"].ToString() == string.Empty ? item.OldValues["REVLTOTA"].ToString() : item.NewValues["REVLTOTA"].ToString();
                string RENRPARC = item.NewValues["RENRPARC"].ToString() == string.Empty ? item.OldValues["RENRPARC"].ToString() : item.NewValues["RENRPARC"].ToString();
                string REDTVCPP = item.NewValues["REDTVCPP"].ToString() == string.Empty ? item.OldValues["REDTVCPP"].ToString() : item.NewValues["REDTVCPP"].ToString();
                string REVLPARC = item.NewValues["REVLPARC"].ToString() == string.Empty ? item.OldValues["REVLPARC"].ToString() : item.NewValues["REVLPARC"].ToString();
                string REDTBOLE = item.NewValues["REDTBOLE"].ToString() == string.Empty ? item.OldValues["REDTBOLE"].ToString() : item.NewValues["REDTBOLE"].ToString();
                string REMAILBO = item.NewValues["REMAILBO"].ToString() == string.Empty ? item.OldValues["REMAILBO"].ToString() : item.NewValues["REMAILBO"].ToString();
                string RESITEPM = item.NewValues["RESITEPM"].ToString() == string.Empty ? item.OldValues["RESITEPM"].ToString() : item.NewValues["RESITEPM"].ToString();
                string REDTVCPD = item.NewValues["REDTVCPD"].ToString() == string.Empty ? item.OldValues["REDTVCPD"].ToString() : item.NewValues["REDTVCPD"].ToString();
                string REVLPAUN = item.NewValues["REVLPAUN"].ToString() == string.Empty ? item.OldValues["REVLPAUN"].ToString() : item.NewValues["REVLPAUN"].ToString();
                string REPARUNI = item.NewValues["REPARUNI"].ToString() == string.Empty ? item.OldValues["REPARUNI"].ToString() : item.NewValues["REPARUNI"].ToString();
                string REANOFIS = item.NewValues["REANOFIS"].ToString() == string.Empty ? item.OldValues["REANOFIS"].ToString() : item.NewValues["REANOFIS"].ToString();
                string REVLPPAR = item.NewValues["REVLPPAR"].ToString() == string.Empty ? item.OldValues["REVLPPAR"].ToString() : item.NewValues["REVLPPAR"].ToString();
                string sqlUpdate = "UPDATE REINCIDE SET REDSINCI='@REDSINCI',REVLTOTA=@REVLTOTA,RENRPARC=@RENRPARC,REDTVCPP=convert(date,'@REDTVCPP',103),REVLPARC=@REVLPARC,REDTBOLE=convert(date,'@REDTBOLE',103),REMAILBO='@REMAILBO',RESITEPM='@RESITEPM',REDTVCPD=convert(date,'@REDTVCPD',103),REVLPAUN='@REVLPAUN',REPARUNI='@REPARUNI',REANOFIS=@REANOFIS,REVLPPAR=@REVLPPAR where REIDINCI=@REIDINCI";
                sqlUpdate = sqlUpdate.Replace("@REIDINCI", REIDINCI);
                sqlUpdate = sqlUpdate.Replace("@REDSINCI", REDSINCI);
                sqlUpdate = sqlUpdate.Replace("@REVLTOTA", REVLTOTA.Replace(",", "."));
                sqlUpdate = sqlUpdate.Replace("@RENRPARC", RENRPARC);
                sqlUpdate = sqlUpdate.Replace("@REDTVCPP", Convert.ToDateTime(REDTVCPP).ToString("dd/MM/yyyy"));
                sqlUpdate = sqlUpdate.Replace("@REVLPARC", REVLPARC.Replace(",", "."));
                sqlUpdate = sqlUpdate.Replace("@REDTBOLE", Convert.ToDateTime(REDTBOLE).ToString("dd/MM/yyyy"));
                sqlUpdate = sqlUpdate.Replace("@REMAILBO", REMAILBO);
                sqlUpdate = sqlUpdate.Replace("@RESITEPM", RESITEPM);
                sqlUpdate = sqlUpdate.Replace("@REDTVCPD", Convert.ToDateTime(REDTVCPD).ToString("dd/MM/yyyy"));
                sqlUpdate = sqlUpdate.Replace("@REVLPAUN", REVLPAUN.Replace(",", "."));
                sqlUpdate = sqlUpdate.Replace("@REPARUNI", REPARUNI);
                sqlUpdate = sqlUpdate.Replace("@REANOFIS", Convert.ToDateTime(REANOFIS).ToString("yyyy"));
                sqlUpdate = sqlUpdate.Replace("@REVLPPAR", REVLPPAR.Replace(",", "."));
                string exec = DataBase.Consultas.UpdtFrom(str_conn, sqlUpdate);

            }
            grid.DataBind();
        }
        protected void gridImpIncidencia_Load(object sender, EventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            switch (hfOperacao.Value)
            {
                case "alterar":
                    grid.SettingsDataSecurity.AllowInsert = true;
                    grid.SettingsDataSecurity.AllowEdit = true;
                    grid.SettingsDataSecurity.AllowDelete = true;
                    break;
                case "inserir":
                    grid.SettingsDataSecurity.AllowInsert = true;
                    grid.SettingsDataSecurity.AllowEdit = true;
                    grid.SettingsDataSecurity.AllowDelete = true;
                    break;
                case "inserir2":
                    grid.SettingsDataSecurity.AllowInsert = true;
                    grid.SettingsDataSecurity.AllowEdit = true;
                    grid.SettingsDataSecurity.AllowDelete = true;
                    break;
                default:
                    grid.SettingsDataSecurity.AllowInsert = false;
                    grid.SettingsDataSecurity.AllowEdit = false;
                    grid.SettingsDataSecurity.AllowDelete = false;
                    break;
            }
        }
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            ControlesView("consulta");
        }
        protected void htmlEditor_Init(object sender, EventArgs e)
        {
            htmlEditor.SettingsDialogs.InsertImageDialog.SettingsImageUpload.FileSystemSettings.UploadFolder = Server.MapPath(@"\ImgEmailsTemp");

        }
        protected void gridImpIncidencia_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            int qtd = e.NewValues["RENRPARC"] == null ? Convert.ToInt32(e.OldValues["RENRPARC"]) : Convert.ToInt32(e.NewValues["RENRPARC"]);
            Decimal vlTotal = e.NewValues["REVLTOTA"] == null ? Convert.ToDecimal(e.OldValues["REVLTOTA"]) : Convert.ToDecimal(e.NewValues["REVLTOTA"]);
            Decimal vl1 = e.NewValues["REVLPPAR"] == null ? Convert.ToDecimal(e.OldValues["REVLPPAR"]) : Convert.ToDecimal(e.NewValues["REVLPPAR"]);
            Decimal vlmes = e.NewValues["REVLPARC"] == null ? Convert.ToDecimal(e.OldValues["REVLPARC"]) : Convert.ToDecimal(e.NewValues["REVLPARC"]);
            Decimal conta = (vlmes * qtd) + vl1;
            if (conta != vlTotal)
            {
                e.RowError = "Fórmula 1a Parcela + (Valor Mensal * Qtd) deve ser igual a Valor Total: " + vl1.ToString() + "+ (" + vlmes.ToString() + " * " + qtd.ToString() + ") = " + vlTotal.ToString();
            }
        }
        protected void callBackGeoLocal_Callback(object sender, CallbackEventArgsBase e)
        {
            string latlong = "", address = "";
            string Zip = e.Parameter.ToString();
            if (Zip != string.Empty)
            {
                address = "https://maps.googleapis.com/maps/api/geocode/json?components=postal_code:" + Zip.Trim() + "&sensor=false&key=AIzaSyDjz5JIH7U_kZDGyHMaMizXy5a3DDLFjEM";
                using (WebClient webClient = new WebClient())
                {
                    webClient.Encoding = Encoding.UTF8;
                    var result = webClient.DownloadString(address);
                    Rootobject root = Newtonsoft.Json.JsonConvert.DeserializeObject<Rootobject>(result);
                    var lat = root.results[0].geometry.location.lat.ToString().Replace(",", ".");
                    var lng = root.results[0].geometry.location.lng.ToString().Replace(",", ".");
                    latlong = Convert.ToString(lat) + "," + Convert.ToString(lng);
                    callBackGeoLocal.JSProperties["cp_latlng"] = latlong;
                    ddeGeoLocal.Text = root.results[0].formatted_address;
                }
            }
        }
        protected void btnInsert_Load(object sender, EventArgs e)
        {
            Button obj = (Button)sender;
            HttpCookie myCookie = HttpContext.Current.Request.Cookies[DataBase.Funcoes.GerarHashMd5("perfil_cliente")];
            if (myCookie == null)
                Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["login"]);
            string perfil = DataBase.Funcoes.Decriptar(System.Configuration.ConfigurationManager.AppSettings["chaveCript"], System.Configuration.ConfigurationManager.AppSettings["vetorCript"], myCookie.Value);
            obj.Enabled = perfil != "3";
        }
        protected void btnDelete_Load(object sender, EventArgs e)
        {
        }
        protected void btnEdit_Load(object sender, EventArgs e)
        {
        }
    }

    public class Rootobject
    {
        public Result[] results { get; set; }
        public string status { get; set; }
    }
    public class Result
    {
        public Address_Components[] address_components { get; set; }
        public string formatted_address { get; set; }
        public Geometry geometry { get; set; }
        public string place_id { get; set; }
        public string[] types { get; set; }
    }
    public class Geometry
    {
        public Bounds bounds { get; set; }
        public Location location { get; set; }
        public string location_type { get; set; }
        public Viewport viewport { get; set; }
    }
    public class Bounds
    {
        public Northeast northeast { get; set; }
        public Southwest southwest { get; set; }
    }
    public class Northeast
    {
        public float lat { get; set; }
        public float lng { get; set; }
    }
    public class Southwest
    {
        public float lat { get; set; }
        public float lng { get; set; }
    }
    public class Location
    {
        public float lat { get; set; }
        public float lng { get; set; }
    }
    public class Viewport
    {
        public Northeast1 northeast { get; set; }
        public Southwest1 southwest { get; set; }
    }
    public class Northeast1
    {
        public float lat { get; set; }
        public float lng { get; set; }
    }
    public class Southwest1
    {
        public float lat { get; set; }
        public float lng { get; set; }
    }
    public class Address_Components
    {
        public string long_name { get; set; }
        public string short_name { get; set; }
        public string[] types { get; set; }
    }

}
