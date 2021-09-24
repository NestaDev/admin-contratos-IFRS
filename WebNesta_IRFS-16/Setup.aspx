<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="True" CodeBehind="Setup.aspx.cs" Inherits="WebNesta_IRFS_16.Setup1" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.XtraReports.v20.1.Web.WebForms, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var isButtonClicked = false;
        function DataCallback(result) {
            var results = result.split("#");
            if (results[0].toString() == 'valor') {
                ASPxGridView1.batchEditApi.EndEdit();
                ASPxGridView1.batchEditApi.SetCellValue(startIndex, results[0].toString(), results[1]);
                var keyIndex = gridVerbas.GetColumnByField(results[0].toString()).index;
                ASPxGridView1.batchEditApi.StartEdit(startIndex, keyIndex);
                var editor = gridVerbas.GetEditor('valor');
                if (results[2].toString() == '25700' || results[2].toString() == '25701' || results[2].toString() == '25702' || results[2].toString() == '25703') {
                    editor.SetReadOnly(true);
                }
            }
            else if (results[0].toString() == 'data_venc') {
                ASPxGridView1.batchEditApi.EndEdit();
                var d = new Date(results[1].toString());
                ASPxGridView1.batchEditApi.SetCellValue(startIndex, results[0].toString(), d);
                var keyIndex = gridVerbas.GetColumnByField(results[0].toString()).index;
                ASPxGridView1.batchEditApi.StartEdit(startIndex, keyIndex);
                var editor = gridVerbas.GetEditor('data_venc');
                editor.SetReadOnly(true);
            }
            else if (results[0].toString() == 'valor2') {
                ASPxGridView1.batchEditApi.EndEdit();
                ASPxGridView1.batchEditApi.SetCellValue(startIndex2, 'valor', results[1]);
                var keyIndex = gridEntry.GetColumnByField('valor').index;
                ASPxGridView1.batchEditApi.StartEdit(startIndex2, keyIndex);
                var editor = gridEntry.GetEditor('valor');
                //if (results[2].toString() == '25700' || results[2].toString() == '25702' || results[2].toString() == '25703') {
                //    editor.SetReadOnly(true);
                //}
            }
        }
        function onKeyPress(s, e) {
            if (e.htmlEvent.keyCode == 13)
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }
        function GetBoleto(s, e) {
            var layout = listLayout.GetValue();
            var leitura = listLeitura.GetValue();
            if (leitura == 2) {//digitado
                if (layout == 1) {//arrecadacao
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var today = new Date();
                    var date = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds(), today.getMilliseconds());
                    date.setDate(date.getDate() + parseInt(0));
                    txtDtVenc.SetDate(date);
                    var teste = barra.replace(/ /g, '').replace(/-/g, '');
                    teste = teste.substring(4, 16);
                    var teste2 = teste.substring(0, 6) + teste.substring(8, 16);
                    var valor = parseFloat(teste2).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
                else if (layout == 2) {//bancario
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var date = new Date('10/07/1997');
                    date.setDate(date.getDate() + parseInt(vencimento));
                    txtDtVenc.SetDate(date);
                    var valor = parseFloat(barra.substring(barra.length - 10, barra.length)).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
            }
            else if (leitura == 1) {//leitor
                if (layout == 1) { //Arrecadacao
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var today = new Date();
                    var date = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds(), today.getMilliseconds());
                    date.setDate(date.getDate() + parseInt(0));
                    txtDtVenc.SetDate(date);
                    var valor = parseFloat(barra.substring(4, 15)).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
                else if (layout == 2) {//bancario
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var date = new Date('10/07/1997');
                    date.setDate(date.getDate() + parseInt(vencimento));
                    txtDtVenc.SetDate(date);
                    var valor = parseFloat(barra.substring(barra.length - 10, barra.length)).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
            }
            document.getElementById('hfBoleto').value = s.GetText();
        }
    </script>
    <script type="text/javascript">
        function Capitalize(text) {
            var split = text.split(" ");
            var result = text[0];
            return result;
        }
        var fieldName;
        var startIndex = 0;
        function OnBatchEditStartEditing(s, e) {
            fieldName = e.focusedColumn.fieldName;
            startIndex = e.visibleIndex;

            var USNMPRUS = s.batchEditApi.GetCellValue(e.visibleIndex, 'USNMPRUS', false);
            var USNMSNUS = s.batchEditApi.GetCellValue(e.visibleIndex, 'USNMSNUS', false);
            if (USNMPRUS == null || USNMSNUS == null) {
                if (e.focusedColumn.fieldName == 'USNMPRUS' || e.focusedColumn.fieldName == 'USNMSNUS') {
                    editor = s.GetEditor(e.focusedColumn.fieldName);
                    editor.SetReadOnly(false);
                }
            }
            else {
                if (e.focusedColumn.fieldName == 'USNMPRUS' || e.focusedColumn.fieldName == 'USNMSNUS') {
                    editor = s.GetEditor(e.focusedColumn.fieldName);
                    editor.SetReadOnly(true);
                }
            }
        }

        function OnBatchEditEndEditing(s, e) {
            var USNMPRUS = s.GetColumnByField("USNMPRUS");
            var USNMSNUS = s.GetColumnByField("USNMSNUS");
            var USIDUSUA = s.GetColumnByField("USIDUSUA");
            var nome = e.rowValues[USNMPRUS.index].value;
            var sobrenome = e.rowValues[USNMSNUS.index].value;
            if (nome != null && sobrenome != null) {

                var newValue = Capitalize(nome).toUpperCase() + sobrenome.toUpperCase();
                newValue = newValue.substring(0, 14);
                e.rowValues[USIDUSUA.index].value = newValue;
                e.rowValues[USIDUSUA.index].text = newValue;
            }
        }

        function isQueryNameValid(name) {
            return !name || name.length < 15;
        }
        function queryBuilder_Initialize(s, e) {
            var queryNameInfo = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (item) {
                return item.displayName === "Name";
            })[0];
            queryNameInfo.validationRules = [{
                type: 'custom',
                validationCallback: function (options) {
                    var queryName = options.value;
                    if (!isQueryNameValid(queryName)) {
                        options.rule.message = "Query name is invalid!";
                    }
                    return isQueryNameValid(queryName);
                }
            }];

            var filterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === "filterString"; })[0];
            filterStringProperty.visible = true;

            var groupFilterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === "groupFilterString"; })[0];
            groupFilterStringProperty.visible = true;

            s.GetQueryBuilderModel().model.valueHasMutated();
        }
        function queryBuilder_CustomizeMenuActions(s, e) {
            var saveAction = e.Actions.filter(function (action) { return action.id === "dxqb-save" })[0];
            saveAction.clickAction = function () {
                var queryName = queryBuilder.designerModel.model().name();
                if (listTipoQuery.GetSelectedIndex() < 0) {
                    listTipoQuery.GetMainElement().style.border = "1px solid Red";
                    return;
                }
                else {
                    listTipoQuery.GetMainElement().style.border = "0px solid Red";
                }
                DevExpress.ui.dialog.confirm("Are you sure?", "Save Query")
                    .done(function (dialogResult) {
                        if (dialogResult) {
                            if (txtNomeRelat.GetText() == '')
                                alert("Nome Relatório não pode ser nulo.");
                            else
                                queryBuilder.Save()
                        }
                    });
            };
            var dataPreviewAction = e.GetById(DevExpress.Designer.QueryBuilder.ActionId.DataPreview);
            dataPreviewAction.visible = true;
            var selectStatementPreviewAction = e.GetById(DevExpress.Designer.QueryBuilder.ActionId.SelectStatementPreview);
            selectStatementPreviewAction.visible = true;
        }

        function queryBuilder2_Initialize(s, e) {
            var queryNameInfo = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (item) {
                return item.displayName === "Name";
            })[0];
            queryNameInfo.validationRules = [{
                type: 'custom',
                validationCallback: function (options) {
                    var queryName = options.value;
                    if (!isQueryNameValid(queryName)) {
                        options.rule.message = "Query name is invalid!";
                    }
                    return isQueryNameValid(queryName);
                }
            }];
            var filterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === "filterString"; })[0];
            filterStringProperty.visible = true;

            var groupFilterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === "groupFilterString"; })[0];
            groupFilterStringProperty.visible = true;

            s.GetQueryBuilderModel().model.valueHasMutated();
        }
        function queryBuilder2_CustomizeMenuActions(s, e) {
            var saveAction = e.Actions.filter(function (action) { return action.id === "dxqb-save" })[0];
            saveAction.clickAction = function () {
                var queryName = queryBuilder2.designerModel.model().name();
                if (listTipoQuery2.GetSelectedIndex() < 0) {
                    listTipoQuery2.GetMainElement().style.border = "1px solid Red";
                    return;
                }
                else {
                    listTipoQuery2.GetMainElement().style.border = "0px solid Red";
                }
                //if (txtNameQuery2.GetText() == "") {
                //    document.getElementById('divNameQuery2').style.border = "1px solid Red";
                //    return;
                //}
                //else {
                //    document.getElementById('divNameQuery2').style.border = "0px solid Red";
                //}
                DevExpress.ui.dialog.confirm("Are you sure?", "Save Query")
                    .done(function (dialogResult) {
                        if (dialogResult) {
                            queryBuilder2.Save()
                        }
                    });
            };
            var dataPreviewAction = e.GetById(DevExpress.Designer.QueryBuilder.ActionId.DataPreview);
            dataPreviewAction.visible = true;
            var selectStatementPreviewAction = e.GetById(DevExpress.Designer.QueryBuilder.ActionId.SelectStatementPreview);
            selectStatementPreviewAction.visible = true;
        }
    </script>
    <script type="text/javascript">
        function ClearSelection() {
            TreeList.SetFocusedNodeKey("");
            UpdateControls(null, "");
            document.getElementById('hfDropEstr').value = "";
        }
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropEstr').value = TreeList.GetFocusedNodeKey();
            if (focusedNodeKey != "")
                employeeName = TreeList.cpEmployeeNames[focusedNodeKey];
            UpdateControls(focusedNodeKey, employeeName);
        }
        function UpdateControls(key, text) {
            DropDownEdit.SetText(text);
            DropDownEdit.SetKeyValue(key);
            DropDownEdit.HideDropDown();
            UpdateButtons();
        }
        function UpdateButtons() {
            clearButton.SetEnabled(DropDownEdit.GetText() != "");
            selectButton.SetEnabled(TreeList.GetFocusedNodeKey() != "");
        }
        function OnDropDown() {
            TreeList.SetFocusedNodeKey(DropDownEdit.GetKeyValue());
            TreeList.MakeNodeVisible(TreeList.GetFocusedNodeKey());
        }

    </script>
    <script type="text/javascript">
        function OnItemClick(s, e) {
            ClearSelection();
            SelectParent(e.item.parent);
            e.processOnServer = e.item.GetItemCount() == 0; // Prevent generating a postback for parent menu items
        }
        function ClearSelection() {
            $(".mySelection").removeClass("mySelection");
        }
        function SelectParent(parent) {
            if (parent) {
                var parentElement = parent.menu.GetItemElement(parent.indexPath);
                $(parentElement).addClass("mySelection");
            }
        }
    </script>
    <script type="text/javascript">  
        function QuickGuide2(guide) {
            switch (guide) {
                case 'setup_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_guide%>';
                    break;
                case 'grid':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.guide_grid_edit%>';
                    break;
                case 'setup_menu3_lbl1_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl1_guide%>';
                    break;
                case 'setup_menu3_lbl2_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl2_guide%>';
                    break;
                case 'setup_menu3_lbl3_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl3_guide%>';
                    break;
                case 'setup_menu3_lbl4_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl4_guide%>';
                    break;
                case 'setup_menu3_lbl5_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl5_guide%>';
                    break;
                case 'setup_menu3_lbl6_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl6_guide%>';
                    break;
                case 'setup_menu3_lbl7_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl7_guide%>';
                    break;
                case 'setup_menu3_lbl8_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Setup.setup_menu3_lbl8_guide%>';
                    break;
            }

        }

    </script>
    <script type="text/javascript">
        var log;
        var log2;
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfOper" runat="server" />
    <asp:HiddenField ID="hfOper_Loja" runat="server" />
    <asp:HiddenField ID="hfQuery" runat="server" />
    <asp:HiddenField ID="hfTipoView" runat="server" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfDropProd" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfDropEvento" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfDropComp" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfDropCMID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfTipoQuery" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfCMTPIDCM" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfCMIDCODI" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfNameQuery" runat="server" />
    <asp:HiddenField ID="hfPerfilQuery" runat="server" />
    <asp:HiddenField ID="hfIDQuery" runat="server" />
    <asp:HiddenField ID="hfPaisUser" runat="server" />
    <div class="container-fluid">
        <div class="row ml-0 mr-0 mt-0 w-100">
            <div class="col-sm-2">
                <div class="container-fluid">
                    <div class="row mt-2">
                        <div class="col-12 text-left p-0">
                            <div class="card pr-2 pl-2 quickGuide">
                                <div class="card-header quickGuide-header">
                                    <label>Quick Guide</label>
                                </div>
                                <div class="card-body p-0 pt-2 quickGuide-body">
                                    <label id="lblquickGuide"><%=Resources.GlobalResource.quickguide_inicial %></label>
                                </div>
                                <div class="card-footer bg-transparent quickGuide-footer">
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Setup, setup_content_tutorial %>" />
                                    <dx:ASPxButton  ID="btnAjuda" runat="server" AutoPostBack="false" CssClass="btn-saiba-mais" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_readmore %>">
                                        <ClientSideEvents Click="function (s,e){
                                            popupSaibaMais.RefreshContentUrl();
                                            popupSaibaMais.SetContentUrl(document.getElementById('hfContentPage').value);
                                            setTimeout('popupSaibaMais.Show();', 500);
                                            }" />
                                    </dx:ASPxButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-10 pl-4 pr-0">
                <div class="row" onmouseover="QuickGuide2('setup_guide')">
                    <dx:ASPxMenu ID="ASPxMenu1" ClientInstanceName="ASPxMenu1" runat="server" Theme="Moderno"
                        OnItemClick="ASPxMenu1_ItemClick" OnLoad="ASPxMenu1_Load" SelectParentItem="True"
                        ItemStyle-SelectedStyle-BackColor="#669999"
                        ItemStyle-HoverStyle-BackColor="#669999"
                        SubMenuItemStyle-SelectedStyle-BackColor="#669999"
                        SubMenuItemStyle-HoverStyle-BackColor="#669999">
                        <RootItemSubMenuOffset LastItemX="8" />
                        <ClientSideEvents ItemClick="OnItemClick" />
                        <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="true"
                            EnableCollapseToSideMenu="true" CollapseToSideMenuAtWindowInnerWidth="300"
                            EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="700" />
                        <Items>
                            <dx:MenuItem Name="1" Text="<%$Resources:Setup, setup_menu1 %>">
                            </dx:MenuItem>
                            <dx:MenuItem Name="admin" Text="<%$Resources:Setup, setup_menu2 %>">
                                <Items>
                                    <dx:MenuItem Name="4" Text="<%$Resources:Setup, setup_menu2-1 %>"></dx:MenuItem>
                                    <dx:MenuItem Name="5" Text="<%$Resources:Setup, setup_menu2-2 %>"></dx:MenuItem>
                                    <dx:MenuItem Name="7" Text="<%$Resources:Setup, setup_menu2-3 %>"></dx:MenuItem>
                                </Items>
                            </dx:MenuItem>
                            <dx:MenuItem Name="config" Text="<%$Resources:Setup, setup_menu6 %>">
                                <Items>
                                    <dx:MenuItem Name="8" Text="<%$Resources:Setup, setup_menu6-1 %>"></dx:MenuItem>
                                    <dx:MenuItem Name="9" Text="<%$Resources:Setup, setup_menu6-2 %>"></dx:MenuItem>
                                    <dx:MenuItem Name="10" Text="<%$Resources:Setup, setup_menu6-3 %>"></dx:MenuItem>
                                    <dx:MenuItem Name="11" Text="<%$Resources:Setup, setup_menu6-4 %>"></dx:MenuItem>
                                    <dx:MenuItem Name="12" Text="<%$Resources:Setup, setup_menu6-5 %>"></dx:MenuItem>
                                </Items>
                            </dx:MenuItem>
                            <dx:MenuItem Name="emp" Text="<%$Resources:Setup, setup_menu3 %>">
                                <Items>
                                    <dx:MenuItem Name="2" Text="<%$Resources:Setup, setup_menu3-1 %>"></dx:MenuItem>
                                    <dx:MenuItem Name="13" Text="<%$Resources:Setup, setup_menu3-2 %>"></dx:MenuItem>
                                </Items>
                            </dx:MenuItem>
                            <dx:MenuItem Name="admin2" Text="Configurações do Sistema" Visible="false">
                            </dx:MenuItem>
                            <dx:MenuItem Name="3" Text="<%$Resources:Setup, setup_menu4 %>">
                            </dx:MenuItem>
                            <dx:MenuItem Name="6" Text="<%$Resources:Setup, setup_menu5 %>" Visible="false">
                            </dx:MenuItem>
                        </Items>

                    </dx:ASPxMenu>
                </div>
                <div class="row">
                    <asp:MultiView ID="PanelView" runat="server">
                        <asp:View ID="tela0" runat="server"></asp:View>
                        <asp:View ID="tela1" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-9 left_side p-0">
                                        <div class="card bg-transparent">
                                            <div class="card-header bg-transparent">
                                                <div class="row d-flex">
                                                    <h4>
                                                        <asp:Label ID="Label12" runat="server" Text="<%$Resources:Setup, setup_menu1_lbl1 %>" CssClass=""></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent">
                                                <dx:ASPxGridView ID="gridQueries" KeyFieldName="QUEIDPVT" Width="650px" ClientInstanceName="gridQueries" runat="server" Theme="MaterialCompact" EnableCallBacks="false"
                                                    OnDataBound="gridQueries_DataBound" OnCustomButtonCallback="gridQueries_CustomButtonCallback" OnLoad="gridQueries_Load" AutoGenerateColumns="False">
                                                    <Settings VerticalScrollableHeight="290" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" ></Settings>
                                                    <SettingsPager Visible="false"></SettingsPager>
                                                    <SettingsBehavior AllowFocusedRow="True" />
                                                    <SettingsResizing ColumnResizeMode="Control" Visualization="Postponed" />
                                                    <SettingsPopup>
                                                        <HeaderFilter Height="100px" Width="100px" MinHeight="100px" MinWidth="100px" PopupAnimationType="Fade">
                                                        </HeaderFilter>
                                                    </SettingsPopup>
                                                    <Images>
                                                        <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                                    </Images>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn Name="CommandColumn" MaxWidth="30" Width="30px" Visible="false" ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="QUENMPVT" Caption="<%$Resources:Setup, setup_menu1_col1 %>" Width="320px" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="QUETPPVT" Caption="<%$Resources:Setup, setup_menu1_col2 %>" Width="150px" VisibleIndex="2">
                                                            <PropertiesComboBox DataSourceID="SqlDataSource1" TextField="TPNMVIEW" ValueField="TPIDVIEW"></PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataButtonEditColumn FieldName="QUEBBPVT" Visible="false" Width="150px" VisibleIndex="3"></dx:GridViewDataButtonEditColumn>
                                                        <dx:GridViewCommandColumn Name="detail" Caption="<%$Resources:Setup, setup_menu1_col3 %>" Width="150px" VisibleIndex="4">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="detail" Text="<%$Resources:Setup, setup_menu1_col3-btn %>"></dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                    </Columns>
                                                    <Styles>
                                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                        <Header Font-Names="Arial" Font-Size="12pt" ForeColor="White" BackColor="#669999" Paddings-Padding="3px">
                                                        </Header>
                                                        <Row Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                                                        </Row>
                                                        <AlternatingRow Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                        <BatchEditCell Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                                                            <Paddings Padding="0px" />
                                                        </BatchEditCell>
                                                        <FocusedRow BackColor="#ccff99" ForeColor="DimGray" Font-Bold="true"></FocusedRow>
                                                        <FocusedCell Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                        <EditForm Paddings-Padding="0px"></EditForm>
                                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                        <Table></Table>
                                                        <Cell Wrap="False" Paddings-Padding="5px"></Cell>
                                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                    </Styles>
                                                </dx:ASPxGridView>
                                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT TPNMVIEW,TPIDVIEW FROM TPTPVIEW"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-3 p-0">
                                        <div class="card bg-transparent p-0">
                                            <div class="card-header bg-transparent">
                                                <h4>
                                                    <asp:Label ID="Label11" runat="server" Text="<%$Resources:Setup, setup_menu1_lbl2 %>"></asp:Label></h4>
                                            </div>
                                            <div class="card-body bg-transparent pl-3 pr-5">
                                                <div class="row mt-3" style="margin: 0 auto;">
                                                    <div class="col-lg-6 pl-0" style="text-align: center;">
                                                        <asp:Button ID="btn_inserir" runat="server" CommandArgument="inserir" OnCommand="Button1_Command" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_inserir %>" />
                                                    </div>
                                                    <div class="col-lg-6 pl-1" style="text-align: center;">
                                                        <asp:Button ID="btn_excluir" Enabled="false" runat="server" CommandArgument="excluir" OnCommand="Button1_Command" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_excluir %>" />
                                                    </div>
                                                </div>
                                                <div class="row" style="margin: 0 auto; margin-top: 9px">
                                                    <div class="col-lg-6 pl-0" style="text-align: center;">
                                                        <asp:Button ID="btn_ok" Enabled="false" runat="server" CommandArgument="ok" OnCommand="Button1_Command" CssClass="Loading btn-using ok" Text="<%$Resources:GlobalResource, btn_ok %>" />
                                                    </div>
                                                    <div class="col-lg-6 pl-1" style="text-align: center;">
                                                        <asp:Button ID="btn_cancelar" runat="server" CommandArgument="cancelar" OnCommand="Button1_Command" CssClass="Loading btn-using cancelar" Text="<%$Resources:GlobalResource, btn_cancelar %>" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </asp:View>
                        <asp:View ID="tela2" runat="server">
                            <asp:Button ID="btnSelectLoja" runat="server" CssClass="d-none Loading" ClientIDMode="Static" Text="Button" OnClick="btnSelectLoja_Click" />
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-9 w-100 left_side p-0">
                                        <asp:MultiView ID="mv_Loja" runat="server">
                                            <asp:View ID="vw_loja_Consultar" runat="server">
                                                <div class="card bg-transparent">
                                                    <div class="card-header bg-transparent">
                                                        <div class="row d-flex">
                                                            <h4>
                                                                <asp:Label ID="Label5" runat="server" Text="<%$Resources:Setup, setup_menu3_lbl1 %>" CssClass=""></asp:Label></h4>
                                                            <h6 style="margin-top: 7px !important">
                                                                <asp:Label ID="lblMensagemLoja" runat="server" Text="" ForeColor="DarkRed" CssClass="pl-3" Style="margin-top: 4px !important"></asp:Label></h6>
                                                        </div>
                                                    </div>
                                                    <div class="card-body p-0 bg-transparent">
                                                        <div class="row">
                                                            <div class="p-0 col-x1" onmouseover="QuickGuide2('setup_menu3_lbl1_guide')">
                                                                <asp:Label ID="Label6" runat="server" Text="<%$Resources:Setup, setup_menu3_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="Loja" ControlToValidate="radioModelo" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>

                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxRadioButtonList ID="radioModelo" runat="server" ValueTypeValueType="System.String" RepeatDirection="Horizontal" Theme="Moderno">
                                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) {
	var value = s.GetValue();
gropGrupo.SetEnabled(value=='1');
}"></ClientSideEvents>
                                                                        <Items>
                                                                            <dx:ListEditItem Text="<%$Resources:Setup, setup_menu3_lbl2-opt1 %>" Value="0" />
                                                                            <dx:ListEditItem Text="<%$Resources:Setup, setup_menu3_lbl2-opt2 %>" Value="1" />
                                                                        </Items>
                                                                        <Border BorderWidth="0px" />
                                                                        <Paddings Padding="0px" />
                                                                    </dx:ASPxRadioButtonList>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row w-100 mb-1 pl-3">
                                                            <div class="p-0 col-x1" onmouseover="QuickGuide2('setup_menu3_lbl2_guide')">
                                                                <asp:Label ID="Label9" runat="server" Text="<%$Resources:Setup, setup_menu3_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxComboBox ID="gropGrupo" ClientInstanceName="gropGrupo" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                                        DataSourceID="sqlLoja" ValueType="System.String" ValueField="TVIDESTR" TextField="FONMAB20" OnLoad="gropGrupo_Load">
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxComboBox>
                                                                    <asp:SqlDataSource ID="sqlLoja" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                        SelectCommand="select TV.TVIDESTR,FO.FONMAB20 from TVESTRUT TV, FOFORNEC FO
                                                                                WHERE TV.TVIDESTR = FO.TVIDESTR
                                                                                  AND FOTPIDTP=6
                                                                                ORDER BY 2"></asp:SqlDataSource>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1" onmouseover="QuickGuide2('setup_menu3_lbl3_guide')">
                                                                <asp:Label ID="lblDesc" runat="server" Text="<%$Resources:Setup, setup_menu3_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="reqRazao" ValidationGroup="Loja" ControlToValidate="txtRazao" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <asp:TextBox ID="txtRazao" CssClass="text-boxes" MaxLength="65" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1" onmouseover="QuickGuide2('setup_menu3_lbl4_guide')">
                                                                <asp:Label ID="Label7" runat="server" Text="<%$Resources:Setup, setup_menu3_lbl5 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="reqApelido" ValidationGroup="Loja" ControlToValidate="txtApelido" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <asp:TextBox ID="txtApelido" CssClass="text-boxes" MaxLength="20" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <br />
                                                                <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                                    <asp:TextBox ID="TextBox2" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                        </div>
                                                        <div class="row w-100 mb-1 pl-3">
                                                            <div class="p-0 col-x1" onmouseover="QuickGuide2('setup_menu3_lbl5_guide')">
                                                                <asp:Label ID="Label8" runat="server" Text="<%$Resources:Setup, setup_menu3_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="Loja" InitialValue="00000000000000" ControlToValidate="txtCNPJ" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxTextBox ID="txtCNPJ" runat="server" Width="100%" CssClass="text-boxes" Enabled="false">
                                                                        <MaskSettings Mask="<00000..99999999999999>" PromptChar="0" IncludeLiterals="None" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                        <ValidationSettings Display="Dynamic"></ValidationSettings>
                                                                    </dx:ASPxTextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1" onmouseover="QuickGuide2('setup_menu3_lbl6_guide')">
                                                                <asp:Label ID="Label10" runat="server" Text="<%$Resources:Setup, setup_menu3_lbl7 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="Loja" ControlToValidate="dropPais" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxComboBox ID="dropPais" ClientInstanceName="dropPais" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                                        DataSourceID="sqlPais" ValueType="System.String" ValueField="PAIDPAIS" TextField="PANMPAIS">
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxComboBox>
                                                                    <asp:SqlDataSource ID="sqlPais" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                        SelectCommand="select PAIDPAIS,PANMPAIS from PAPAPAIS order by PANMPAIS"></asp:SqlDataSource>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <br />
                                                                <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                                    <asp:TextBox ID="TextBox9" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <br />
                                                                <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                                    <asp:TextBox ID="TextBox1" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                        </div>
                                                        <div class="row w-100 mb-1 pl-3">
                                                            <div class="col-lg-6 card bg-transparent">
                                                                <div class="card-body bg-transparent p-0 " onmouseover="QuickGuide2('setup_menu3_lbl7_guide')">
                                                                    <dx:ASPxGridView ID="gridAssociadas" Enabled="false" CssClass="mt-1" ClientInstanceName="gridAssociadas" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                        Width="100%" DataSourceID="sqlAssociadas" OnCustomCallback="gridAssociadas_CustomCallback">
                                                                        <ClientSideEvents RowDblClick="function (s,e) {
                                                gridAssociadas.PerformCallback('delete#'+e.visibleIndex);
                                                }"
                                                                            EndCallback="function (s,e) { 
                                                if(s.cp_ok=='OK'){
                                                s.Refresh(); 
                                                gridDisponiveis.Refresh(); 
                                                delete(s.cp_ok);
                                                }
                                                }" />
                                                                        <SettingsPopup>
                                                                            <HeaderFilter MinHeight="140px">
                                                                            </HeaderFilter>
                                                                        </SettingsPopup>
                                                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                        <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                        </SettingsPager>
                                                                        <SettingsCommandButton>
                                                                            <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                                <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                                </Image>
                                                                            </NewButton>
                                                                            <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                                <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                                </Image>
                                                                            </DeleteButton>
                                                                            <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                                <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                                </Image>
                                                                            </RecoverButton>
                                                                        </SettingsCommandButton>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="USIDUSUA" Caption="<%$Resources:Setup, setup_menu3_grid1_col1 %>" Width="100%" VisibleIndex="0" ReadOnly="True"></dx:GridViewDataTextColumn>
                                                                        </Columns>

                                                                        <Styles>
                                                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                            <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                            </Header>
                                                                            <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                            </Row>
                                                                            <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                            <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                                <Paddings Padding="0px" />
                                                                            </BatchEditCell>
                                                                            <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                            <EditForm Paddings-Padding="0px"></EditForm>
                                                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                            <Table></Table>
                                                                            <Cell Paddings-Padding="5px"></Cell>
                                                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                        </Styles>
                                                                    </dx:ASPxGridView>
                                                                    <asp:SqlDataSource runat="server" ID="sqlAssociadas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                        SelectCommand="SELECT T.USIDUSUA FROM VIFSFUSU V
INNER JOIN TUSUSUARI T ON V.USIDUSUA=T.USIDUSUA
WHERE V.TVIDESTR=?">
                                                                        <SelectParameters>
                                                                            <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>
                                                                </div>
                                                            </div>
                                                            <div class="col-lg-6 card bg-transparent">
                                                                <div class="card-body bg-transparent p-0" onmouseover="QuickGuide2('setup_menu3_lbl8_guide')">
                                                                    <dx:ASPxGridView ID="gridDisponiveis" Enabled="false" CssClass="mt-1" ClientInstanceName="gridDisponiveis" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                        Width="100%" DataSourceID="sqlDisponiveis" OnCustomCallback="gridDisponiveis_CustomCallback">
                                                                        <ClientSideEvents RowDblClick="function (s,e) {
                                                gridDisponiveis.PerformCallback('assoc#'+e.visibleIndex);
                                                }"
                                                                            EndCallback="function (s,e) { 
                                                if(s.cp_ok=='OK'){
                                                s.Refresh(); 
                                                gridAssociadas.Refresh(); 
                                                delete(s.cp_ok);
                                                }
                                                }" />
                                                                        <SettingsPopup>
                                                                            <HeaderFilter MinHeight="140px">
                                                                            </HeaderFilter>
                                                                        </SettingsPopup>
                                                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                        <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                        <SettingsPager Mode="ShowAllRecords">
                                                                        </SettingsPager>
                                                                        <SettingsCommandButton>
                                                                            <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                                <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                                </Image>
                                                                            </NewButton>
                                                                            <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                                <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                                </Image>
                                                                            </DeleteButton>
                                                                            <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                                <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                                </Image>
                                                                            </RecoverButton>
                                                                        </SettingsCommandButton>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="USIDUSUA" Caption="<%$Resources:Setup, setup_menu3_grid2_col1 %>" Width="100%" VisibleIndex="0" ReadOnly="True"></dx:GridViewDataTextColumn>
                                                                        </Columns>

                                                                        <Styles>
                                                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                            <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                            </Header>
                                                                            <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                            </Row>
                                                                            <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                            <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                                <Paddings Padding="0px" />
                                                                            </BatchEditCell>
                                                                            <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                            <EditForm Paddings-Padding="0px"></EditForm>
                                                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                            <Table></Table>
                                                                            <Cell Paddings-Padding="5px"></Cell>
                                                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                        </Styles>
                                                                    </dx:ASPxGridView>
                                                                    <asp:SqlDataSource runat="server" ID="sqlDisponiveis" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                        SelectCommand="SELECT T.USIDUSUA FROM TUSUSUARI T
WHERE T.USIDUSUA NOT IN (SELECT V.USIDUSUA FROM VIFSFUSU V WHERE T.USIDUSUA=V.USIDUSUA AND V.TVIDESTR=?)">
                                                                        <SelectParameters>
                                                                            <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </asp:View>
                                            <asp:View ID="vw_loja_Associar" runat="server"></asp:View>
                                        </asp:MultiView>
                                    </div>
                                    <div class="col-3 w-100 p-0">
                                        <div class="card bg-transparent p-0">
                                            <div class="card-header bg-transparent">
                                                <h4>
                                                    <asp:Label ID="Label2" runat="server" Text="<%$Resources:Setup, setup_menu3_right_lbl1 %>"></asp:Label></h4>
                                            </div>
                                            <div class="card-body bg-transparent pl-1 pr-1">
                                                <h6>
                                                    <asp:Label ID="Label3" runat="server" Text="<%$Resources:Setup, setup_menu3_right_lbl2 %>"></asp:Label></h6>
                                                <div class="input-group mb-3 drop-down-div">
                                                    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                        SelectCommand="SELECT B.TVIDESTR, B.TVDSESTR, B.TVCDPAIE, B.TVNVESTR,
                                   A.FOCDXCGC, A.FOCDLICE
                            FROM TVESTRUT B, FOFORNEC A
                            WHERE B.TVIDESTR = A.TVIDESTR
                            AND A.FOTPIDTP = 6
                            AND A.FOCDLICE IS NOT NULL
ORDER BY B.TVIDESTR">
                                                        <SelectParameters>
                                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                    <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" runat="server" Width="250px">
                                                        <PanelCollection>
                                                            <dx:PanelContent>
                                                                <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass="dropDownEdit" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                                                    Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false" AutoResizeWithContainer="true" PopupHorizontalAlign="NotSet">
                                                                    <ClientSideEvents
                                                                        Init="UpdateSelection"
                                                                        DropDown="OnDropDown" />
                                                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                    </ButtonStyle>
                                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    <DropDownWindowTemplate>
                                                                        <div>
                                                                            <dx:ASPxTreeList ID="TreeList" DataSourceID="SqlDataSource3" ClientInstanceName="TreeList" runat="server"
                                                                                Width="100%" CssClass="text-left" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                                                                KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE" AutoGenerateColumns="False">
                                                                                <Settings ShowFooter="false" ShowFilterBar="Hidden" ShowFilterRow="true" HorizontalScrollBarMode="Auto" VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                                                                <ClientSideEvents FocusedNodeChanged="function(s,e){ UpdateSelection(); document.getElementById(&#39;btnSelectLoja&#39;).click(); }" />
                                                                                <BorderBottom BorderStyle="Solid" />
                                                                                <SettingsBehavior ExpandNodesOnFiltering="true" AllowFocusedNode="true" AutoExpandAllNodes="false" FocusNodeOnLoad="false" />
                                                                                <SettingsPager Mode="ShowAllNodes">
                                                                                </SettingsPager>
                                                                                <Images>
                                                                                    <ExpandedButton Url="icons/icons8-seta-para-recolher-30.png" Width="30px"></ExpandedButton>
                                                                                    <CollapsedButton Url="icons/icons8-seta-para-expandir-30.png" Width="30px"></CollapsedButton>
                                                                                    <HeaderFilter Url="icons/icons8-filter-20.png" Width="25px"></HeaderFilter>
                                                                                </Images>
                                                                                <Styles>
                                                                                    <SelectedNode BackColor="#669999"></SelectedNode>
                                                                                    <FocusedNode BackColor="#669999"></FocusedNode>
                                                                                    <Node Cursor="pointer">
                                                                                    </Node>
                                                                                    <Indent Cursor="default">
                                                                                    </Indent>
                                                                                    <Header Paddings-Padding="0px"></Header>

                                                                                </Styles>
                                                                                <ClientSideEvents FocusedNodeChanged="function(s,e){ UpdateSelection(); document.getElementById(&#39;btnSelectLoja&#39;).click(); }" NodeClick="function(s, e) {
	isButtonClicked = true;
}"
                                                                                    NodeDblClick="function(s, e) {
	isButtonClicked = true;
}"
                                                                                    NodeFocusing="function(s, e) {
	if (!isButtonClicked) e.cancel = true; 
}"></ClientSideEvents>

                                                                                <Columns>
                                                                                    <dx:TreeListTextColumn FieldName="TVDSESTR" Width="150px" Caption=" " AutoFilterCondition="Default" ShowInFilterControl="Default" VisibleIndex="0"></dx:TreeListTextColumn>
                                                                                </Columns>
                                                                            </dx:ASPxTreeList>
                                                                        </div>
                                                                        <table class="d-none" style="background-color: White; width: 250px;">
                                                                            <tr>
                                                                                <td style="padding: 5px;">
                                                                                    <dx:ASPxButton ID="clearButton" ClientEnabled="false" Theme="Material" ClientInstanceName="clearButton"
                                                                                        runat="server" AutoPostBack="false" Text="Clear" BackColor="#669999" Font-Size="9pt" Paddings-PaddingLeft="2px" Paddings-PaddingRight="2px">
                                                                                        <ClientSideEvents Click="ClearSelection" />
                                                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                        <DisabledStyle BackColor="White"></DisabledStyle>
                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                                <td style="text-align: right; padding: 5px;">
                                                                                    <dx:ASPxButton ID="selectButton" ClientEnabled="false" Theme="Material" ClientInstanceName="selectButton"
                                                                                        runat="server" AutoPostBack="false" Text="Select" BackColor="#669999" Font-Size="9pt" Paddings-PaddingLeft="2px" Paddings-PaddingRight="2px">
                                                                                        <ClientSideEvents Click=" function (s,e) { 
                                                            UpdateSelection(); document.getElementById('btnSelectLoja').click(); } " />
                                                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                        <DisabledStyle BackColor="White"></DisabledStyle>
                                                                                    </dx:ASPxButton>
                                                                                    <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" Text="Close" BackColor="#669999" Font-Size="9pt" Paddings-PaddingLeft="2px" Paddings-PaddingRight="2px">
                                                                                        <ClientSideEvents Click="function(s,e) { DropDownEdit.HideDropDown(); }" />
                                                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                        <DisabledStyle BackColor="White"></DisabledStyle>

                                                                                    </dx:ASPxButton>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </DropDownWindowTemplate>
                                                                    <DropDownWindowStyle HorizontalAlign="Left" VerticalAlign="NotSet"></DropDownWindowStyle>
                                                                </dx:ASPxDropDownEdit>
                                                            </dx:PanelContent>
                                                        </PanelCollection>
                                                    </dx:ASPxCallbackPanel>
                                                </div>
                                                <h6>
                                                    <asp:Label ID="Label4" runat="server" Text="Operações" CssClass="mt-3"></asp:Label></h6>
                                                <div class="input-group mb-auto pl-3 pr-5">
                                                    <div class="row mt-3" style="margin: 0 auto">
                                                        <div class="col-lg-6 pl-0" style="text-align: center;">
                                                            <asp:Button ID="btnInserir" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_inserir %>" OnCommand="AcoesOperacores_Loja" CommandArgument="Inserir" />
                                                        </div>
                                                        <div class="col-lg-6 pl-1" style="text-align: center;">
                                                            <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_excluir %>" OnCommand="AcoesOperacores_Loja" CommandArgument="Excluir" />
                                                        </div>
                                                    </div>
                                                    <div class="row" style="margin: 0 auto; margin-top: 7px">
                                                        <div class="col-lg-6 pl-0" style="text-align: center;">
                                                            <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_alterar %>" OnCommand="AcoesOperacores_Loja" CommandArgument="Alterar" />
                                                        </div>
                                                        <div class="col-lg-6 pl-1" style="text-align: center;">
                                                            <asp:TextBox ID="TextBox10" CssClass="btn-using field_empty" Enabled="false" runat="server"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="row" style="margin: 0 auto; margin-top: 7px">
                                                        <div class="col-lg-6 pl-0" style="text-align: center;">
                                                            <asp:Button ID="btnOK" Enabled="false" runat="server" CssClass="btn-using ok" Text="<%$Resources:GlobalResource, btn_ok %>" OnClick="btnOK_Click" />
                                                        </div>
                                                        <div class="col-lg-6 pl-1" style="text-align: center;">
                                                            <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="Loading btn-using cancelar" Text="<%$Resources:GlobalResource, btn_cancelar %>" OnClick="btnCancelar_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="tela3" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="card bg-transparent">
                                        <div class="card-header bg-transparent">
                                            <div class="row d-flex">
                                                <h4>
                                                    <asp:Label ID="Label13" runat="server" Text="<%$Resources:Setup, setup_menu4_lbl1 %>" CssClass=""></asp:Label></h4>
                                            </div>
                                        </div>
                                        <div class="card-body bg-transparent">
                                            <dx:ASPxGridView ID="gridLog" CssClass="bg-transparent" KeyFieldName="LOGIDSYS" ClientInstanceName="gridLog" EnableViewState="false" ClientIDMode="Static" Width="1000px" OnLoad="gridLog_Load"
                                                Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="True" AutoGenerateColumns="False" DataSourceID="sqlLog" OnDetailRowGetButtonVisibility="gridLog_DetailRowGetButtonVisibility">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="230" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" ShowHeaderFilterButton="true" />
                                                <SettingsBehavior AllowFocusedRow="true" />
                                                <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                                </SettingsPager>
                                                <SettingsDetail AllowOnlyOneMasterRowExpanded="true" ShowDetailRow="true" ShowDetailButtons="true" />
                                                <SettingsCommandButton>
                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                        </Image>
                                                    </NewButton>
                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                        </Image>
                                                    </DeleteButton>
                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                        </Image>
                                                    </RecoverButton>
                                                </SettingsCommandButton>
                                                <Images>
                                                    <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                                    <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                                </Images>
                                                <Columns>
                                                    <dx:GridViewDataDateColumn FieldName="LOGDTSYS" Width="130px" Caption="<%$Resources:Setup, setup_menu4_col1 %>" VisibleIndex="0" HeaderStyle-Paddings-Padding="0px">
                                                        <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy HH:mm:ss"></PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="USIDUSUA" Width="200px" Caption="<%$Resources:Setup, setup_menu4_col3 %>" VisibleIndex="3" HeaderStyle-Paddings-Padding="0px">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="LOGTLSYS" Width="300px" Caption="<%$Resources:Setup, setup_menu4_col2 %>" VisibleIndex="1" HeaderStyle-Paddings-Padding="0px"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="LOGACSYS" Width="200px" Caption="<%$Resources:Setup, setup_menu4_col4 %>" VisibleIndex="5" HeaderStyle-Paddings-Padding="0px"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="LOGRESUM" Width="400px" Caption="<%$Resources:Setup, setup_menu4_col5 %>" VisibleIndex="6" HeaderStyle-Paddings-Padding="0px"></dx:GridViewDataTextColumn>
                                                </Columns>
                                                <Templates>
                                                    <DetailRow>
                                                        <dx:ASPxLabel ID="ASPxLabel1" Theme="Material" runat="server" Wrap="True" Width="300px" Text="Registro: "></dx:ASPxLabel>
                                                        <dx:ASPxMemo ID="ASPxMemo1" Theme="Material" runat="server" Height="100px" Width="400px" Text='<%# Eval("LOGTXSYS").ToString().Replace("!clf?",Environment.NewLine) %>'></dx:ASPxMemo>
                                                    </DetailRow>
                                                </Templates>
                                                <Styles>

                                                    <DetailRow BackColor="LightGray"></DetailRow>
                                                    <TitlePanel HorizontalAlign="Left" Paddings-Padding="0px"></TitlePanel>
                                                    <Header Font-Names="Arial" Font-Size="12pt" ForeColor="DimGray" Paddings-Padding="0px" HorizontalAlign="Center"></Header>
                                                    <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></Row>
                                                    <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                    <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                    <FocusedRow BackColor="#99bbbb"></FocusedRow>
                                                    <Table Paddings-Padding="0px"></Table>
                                                    <Cell Paddings-Padding="0px" Paddings-PaddingLeft="3px"></Cell>
                                                    <DetailButton Paddings-Padding="0px"></DetailButton>
                                                    <CommandColumn Paddings-Padding="0px"></CommandColumn>
                                                    <FilterCell Paddings-Padding="0px"></FilterCell>
                                                    <HeaderFilterItem Paddings-Padding="0px" HorizontalAlign="Left"></HeaderFilterItem>
                                                    <DetailCell Paddings-Padding="0px"></DetailCell>
                                                </Styles>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="sqlLog" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT * FROM [LOGUSSYS] ORDER BY [LOGDTSYS] desc"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="tela4" runat="server">
                            <div class="container-fluid">
                                <div class="row mt-1">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent">
                                            <div class="card-header border-0 bg-transparent">
                                                <div class="row d-flex">
                                                    <h5>
                                                        <asp:Label ID="Label14" runat="server" Text="<%$Resources:Setup, setup_menu2-1_lbl1 %>" CssClass=""></asp:Label></h5>
                                                </div>
                                            </div>
                                            <div class="card-body p-0 bg-transparent" onmouseover="QuickGuide2('grid')">
                                                <dx:ASPxGridView ID="gridUsuarios" CssClass="mt-1" ClientInstanceName="gridUsuarios" Theme="Material" runat="server" AutoGenerateColumns="False" OnHtmlRowPrepared="gridUsuarios_HtmlRowPrepared"  OnRowValidating="gridUsuarios_RowValidating"
                                                    Width="100%" DataSourceID="sqlUsuarios" KeyFieldName="USIDUSUA" OnBatchUpdate="gridUsuarios_BatchUpdate" OnCustomButtonInitialize="gridUsuarios_CustomButtonInitialize" OnCustomButtonCallback="gridUsuarios_CustomButtonCallback" OnCustomErrorText="gridUsuarios_CustomErrorText">
                                                    <ClientSideEvents BatchEditEndEditing="OnBatchEditEndEditing" BatchEditStartEditing="OnBatchEditStartEditing" />
                                                    <SettingsPopup>
                                                        <HeaderFilter MinHeight="140px">
                                                        </HeaderFilter>
                                                    </SettingsPopup>
                                                    <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Cell"></SettingsEditing>
                                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                    <Settings VerticalScrollableHeight="230" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                    <SettingsPager Mode="ShowAllRecords">
                                                    </SettingsPager>
                                                    <SettingsCommandButton>
                                                        <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                            <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                            </Image>
                                                        </NewButton>
                                                        <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                            <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                            </Image>
                                                        </DeleteButton>
                                                        <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                            <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                            </Image>
                                                        </RecoverButton>
                                                    </SettingsCommandButton>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowNewButtonInHeader="True" Width="60px" VisibleIndex="0" ButtonRenderMode="Image" ShowRecoverButton="False">
                                                            <CustomButtons>
                                                                <dx:GridViewCommandColumnCustomButton ID="disable" Text="<%$Resources:Setup, setup_menu2-1_hint1 %>">
                                                                    <Image ToolTip="Desativar" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                    </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="enable" Text="<%$Resources:Setup, setup_menu2-1_hint3 %>">
                                                                    <Image ToolTip="Reativar" Url="img/icons8-recyle-32.png" Width="15px">
                                                                    </Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                                <dx:GridViewCommandColumnCustomButton ID="reset" Text="<%$Resources:Setup, setup_menu2-1_hint2 %>">
                                                                    <Image ToolTip="Resetar Senha" Url="~/icons/icons8-password-reset-16.png" Width="15px"></Image>
                                                                </dx:GridViewCommandColumnCustomButton>
                                                            </CustomButtons>
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="USIDUSUA" Width="120px" VisibleIndex="5" ReadOnly="true" Caption="<%$Resources:Setup, setup_menu2-1_col5 %>">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="USNMPRUS" Width="150px" VisibleIndex="2" Caption="<%$Resources:Setup, setup_menu2-1_col2 %>">
                                                            <PropertiesTextEdit MaxLength="35">
                                                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        
                                                        <dx:GridViewDataTextColumn FieldName="USNMSNUS" Width="150px" VisibleIndex="4" Caption="<%$Resources:Setup, setup_menu2-1_col4 %>">
                                                            <PropertiesTextEdit MaxLength="30">
                                                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="USEMAILU" Width="100%" VisibleIndex="3" Caption="<%$Resources:Setup, setup_menu2-1_col3 %>">
                                                            <PropertiesTextEdit MaxLength="30">
                                                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="USNUMCEL" Width="135px" VisibleIndex="6" Caption="<%$Resources:Setup, setup_menu2-1_col6 %>">

                                                            <PropertiesTextEdit>
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="GOIDGRUP" Width="120px" Caption="<%$Resources:Setup, setup_menu2-1_col1 %>" VisibleIndex="1">
                                                            <PropertiesComboBox DataSourceID="sqlGrupoUsuarios" TextField="GODSGRUP" ValueField="GOIDGRUP">
                                                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="USLANGUE" Width="110px" Caption="<%$Resources:Setup, setup_menu2-1_col7 %>" VisibleIndex="7">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text="pt-BR" Value="pt-BR"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text="en-US" Value="en-US"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text="es-ES" Value="es-ES"></dx:ListEditItem>
                                                                </Items>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataTextColumn FieldName="USTPIDTP" Visible="False" VisibleIndex="8"></dx:GridViewDataTextColumn>
                                                    </Columns>

                                                    <Styles>
                                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                        <Header Font-Names="Arial" Font-Size="11pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                        </Header>
                                                        <Row Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                                                        </Row>
                                                        <AlternatingRow Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray"></AlternatingRow>
                                                        <BatchEditCell Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                                                            <Paddings Padding="0px" />
                                                        </BatchEditCell>
                                                        <FocusedCell Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                        <EditForm Paddings-Padding="0px"></EditForm>
                                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                        <Table></Table>
                                                        <Cell Paddings-Padding="5px"></Cell>
                                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                    </Styles>
                                                </dx:ASPxGridView>
                                                <asp:SqlDataSource ID="sqlGrupoUsuarios" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select GOIDGRUP,GODSGRUP from GOGRPUSU order by 2"></asp:SqlDataSource>
                                                <asp:SqlDataSource runat="server" ID="sqlUsuarios" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select GOIDGRUP,USIDUSUA,USLANGUE,USNMPRUS,USEMAILU,USNMSNUS,USNUMCEL,USTPIDTP from TUSUSUARI order by 4"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                    </div>


                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="tela5" runat="server">
                            <div class="container-fluid">
                                <div class="row mt-1">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent">
                                            <div class="card-header border-0 bg-transparent">
                                                <div class="row d-flex">
                                                    <h5>
                                                        <asp:Label ID="Label15" runat="server" Text="<%$Resources:Setup, setup_menu2-2_lbl1 %>" CssClass=""></asp:Label></h5>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent">
                                                <div class="row p-0">
                                                    <div class="col-lg-6 card bg-transparent">
                                                        <div class="card-body bg-transparent p-0 " onmouseover="QuickGuide2('grid')">
                                                            <dx:ASPxGridView ID="gridNivelAssociados" CssClass="mt-1" ClientInstanceName="gridNivelAssociados" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                Width="100%" DataSourceID="sqlNivelAssociados" KeyFieldName="VIIDNIUS" Settings-ShowTitlePanel="true" OnBatchUpdate="gridNivelAssociados_BatchUpdate">
                                                                <SettingsPopup>
                                                                    <HeaderFilter MinHeight="140px">
                                                                    </HeaderFilter>
                                                                </SettingsPopup>
                                                                <SettingsText Title="<%$Resources:Setup, setup_menu2-2_grid1_lbl1 %>" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                <SettingsPager Mode="ShowAllRecords">
                                                                </SettingsPager>
                                                                <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row"></SettingsEditing>
                                                                <SettingsCommandButton>
                                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                        </Image>
                                                                    </NewButton>
                                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                        </Image>
                                                                    </DeleteButton>
                                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                        </Image>
                                                                    </RecoverButton>
                                                                </SettingsCommandButton>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowDeleteButton="True" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="NIIDAPRO" Width="50%" Caption="<%$Resources:Setup, setup_menu2-2_grid1_col1 %>" VisibleIndex="1">
                                                                        <PropertiesComboBox DataSourceID="sqlNiveis" TextField="NINMAPRO" ValueField="NIIDAPRO"
                                                                            ValidationSettings-RequiredField-IsRequired="true" ValidationSettings-Display="Dynamic">
                                                                        </PropertiesComboBox>
                                                                    </dx:GridViewDataComboBoxColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="USIDUSUA" Width="50%" Caption="<%$Resources:Setup, setup_menu2-2_grid1_col2 %>" VisibleIndex="2">
                                                                        <PropertiesComboBox DataSourceID="sqlUsuers" TextField="USIDUSUA" ValueField="USIDUSUA"
                                                                            ValidationSettings-RequiredField-IsRequired="true" ValidationSettings-Display="Dynamic">
                                                                        </PropertiesComboBox>
                                                                    </dx:GridViewDataComboBoxColumn>

                                                                </Columns>
                                                                <Styles>
                                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                    <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                    </Header>
                                                                    <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                    </Row>
                                                                    <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                    <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                        <Paddings Padding="0px" />
                                                                    </BatchEditCell>
                                                                    <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                    <Table></Table>
                                                                    <Cell Paddings-Padding="5px"></Cell>
                                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                </Styles>
                                                            </dx:ASPxGridView>
                                                            <asp:SqlDataSource runat="server" ID="sqlNivelAssociados" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="SELECT VIIDNIUS,NIIDAPRO,USIDUSUA FROM VINIUSUA order by 2,3"></asp:SqlDataSource>
                                                            <asp:SqlDataSource runat="server" ID="sqlNiveis" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select NIIDAPRO, NINMAPRO from NIAPROVA ORDER BY 2"></asp:SqlDataSource>
                                                            <asp:SqlDataSource runat="server" ID="sqlUsuers" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select USIDUSUA from TUSUSUARI WHERE GOIDGRUP < 3 order by USIDUSUA"></asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-6 card  bg-transparent">
                                                        <div class="card-body bg-transparent p-0" onmouseover="QuickGuide2('grid')">
                                                            <dx:ASPxGridView ID="gridNivel" CssClass="mt-1" ClientInstanceName="gridNivel" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                Width="100%" DataSourceID="sqlNivel" KeyFieldName="NIIDAPRO" Settings-ShowTitlePanel="true" OnBatchUpdate="gridNivel_BatchUpdate">
                                                                <SettingsPopup>
                                                                    <HeaderFilter MinHeight="140px">
                                                                    </HeaderFilter>
                                                                </SettingsPopup>
                                                                <SettingsText Title="<%$Resources:Setup, setup_menu2-2_grid2_lbl1 %>" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                <SettingsPager Mode="ShowAllRecords">
                                                                </SettingsPager>
                                                                <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row"></SettingsEditing>
                                                                <SettingsCommandButton>
                                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                        </Image>
                                                                    </NewButton>
                                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                        </Image>
                                                                    </DeleteButton>
                                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                        </Image>
                                                                    </RecoverButton>
                                                                </SettingsCommandButton>
                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn FieldName="NINMAPRO" Width="33%" Caption="<%$Resources:Setup, setup_menu2-2_grid2_col1 %>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="NIVL1APR" Width="33%" Caption="<%$Resources:Setup, setup_menu2-2_grid2_col2 %>" VisibleIndex="1">
                                                                        <PropertiesTextEdit DisplayFormatString="N2"></PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="NIVL2APR" Width="33%" Caption="<%$Resources:Setup, setup_menu2-2_grid2_col3 %>" VisibleIndex="2">
                                                                        <PropertiesTextEdit DisplayFormatString="N2"></PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>

                                                                <Styles>
                                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                    <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                    </Header>
                                                                    <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                    </Row>
                                                                    <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                    <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                        <Paddings Padding="0px" />
                                                                    </BatchEditCell>
                                                                    <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                    <Table></Table>
                                                                    <Cell Paddings-Padding="5px"></Cell>
                                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                </Styles>
                                                            </dx:ASPxGridView>
                                                            <asp:SqlDataSource runat="server" ID="sqlNivel" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="SELECT NIIDAPRO,NINMAPRO,NIVL1APR,NIVL2APR FROM NIAPROVA ORDER BY 2"></asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="tela6" runat="server">
                            <asp:SqlDataSource ID="sqlVerbas2" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                SelectCommand="select distinct m.MOIDMODA,m.MODSMODA from VIOPMODA v, modalida m where v.MOIDMODA=m.MOIDMODA and OPIDCONT = ? AND MOTIPOVALO=0">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfOpidcont" PropertyName="Value" Name="?"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="sqlContratos2" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                SelectCommand="select opcdcont,opidcont from opcontra where (FOIDFORN =? or FOIDFORN2=?) and OPTPTPID=1">
                                <SelectParameters>
                                    <asp:Parameter Name="?"></asp:Parameter>
                                    <asp:Parameter Name="?"></asp:Parameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="sqlLocatario" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                SelectCommand="SELECT F.FOIDFORN,F.FONMAB20 FROM FOFORNEC F WHERE FOTPIDTP=8 
and TVIDESTR IN (SELECT DISTINCT TVIDESTR FROM VIFSFUSU  WHERE USIDUSUA = ?) order by fonmforn">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:HiddenField ID="hfBoleto" ClientIDMode="Static" runat="server" />
                            <asp:HiddenField ID="hfOpidcont" ClientIDMode="Static" runat="server" />
                            <div class="container-fluid">
                                <div class="row w-100 m-0">
                                    <div class="card w-100 bg-transparent">
                                        <div class="card-header bg-transparent">
                                            <div class="row">
                                                <div class="col-4 m-auto">
                                                    <h4>
                                                        <asp:Label ID="Label23" runat="server" CssClass="labels text-left" Text="Lançamento de Boletas - Locatário"></asp:Label></h4>
                                                </div>
                                                <div class="col-8 m-auto">
                                                    <dx:ASPxRadioButtonList ID="radioExibir" Caption=" " RepeatDirection="Horizontal" CssClass="m-0 p-0 border-0" runat="server" ValueType="System.Int32"
                                                        AutoPostBack="true" OnSelectedIndexChanged="radioExibir_SelectedIndexChanged" Theme="MaterialCompact">
                                                        <Items>
                                                            <dx:ListEditItem Text="Entrada de Boleto" Value="0" />
                                                            <dx:ListEditItem Text="Histórico de Boletos" Value="1" />
                                                        </Items>
                                                        <CaptionStyle Font-Size="10pt"></CaptionStyle>
                                                    </dx:ASPxRadioButtonList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card-body bg-transparent">
                                            <asp:MultiView ID="mv_PortalLocatario" runat="server" ActiveViewIndex="-1">
                                                <asp:View ID="vw_PortalLocatario_entrada" runat="server">

                                                    <div class="container-fluid">
                                                        <div class="row">
                                                            <div class="col-x1 p-0">
                                                                <asp:Label ID="Label17" Font-Size="12pt" runat="server" Text="Locatário" CssClass="labels text-left"></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxComboBox ID="dropLocatario" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                                        DataSourceID="sqlLocatario" TextField="FONMAB20" ValueField="FOIDFORN" ValueType="System.Int32" AutoPostBack="true" OnSelectedIndexChanged="dropLocatario_SelectedIndexChanged">
                                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxComboBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <asp:Label ID="Label18" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" ValidationGroup="NovoBoleto" ControlToValidate="dropContratosBoleto" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxComboBox ID="dropContratosBoleto" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                                        DataSourceID="sqlContratos2" ValueField="opidcont" TextField="opcdcont">
                                                                        <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
                                    document.getElementById('hfOpidcont').value = s.GetValue();
        }" />
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>

                                                                    </dx:ASPxComboBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <asp:Label ID="Label19" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="*" ValidationGroup="NovoBoleto" ControlToValidate="txtNomeBoleto" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                                                <asp:CustomValidator ID="CustomValidator1" runat="server" ValidationGroup="NovoBoleto" ControlToValidate="txtNomeBoleto" Display="Dynamic" ForeColor="Red" ErrorMessage="Nome já existente" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <asp:TextBox ID="txtNomeBoleto" CssClass="text-boxes" ValidationGroup="NovoBoleto" Width="100%" runat="server"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <asp:Label ID="Label16" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxComboBox ID="dropFormPagt" ForeColor="dimgray" AllowInputUser="false" runat="server" ValueType="System.String" CssClass="drop-down" Theme="Material" Width="100%">
                                                                        <Items>
                                                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item1 %>" Value="B" />
                                                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item2 %>" Value="T" />
                                                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item3 %>" Value="D" />
                                                                        </Items>
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxComboBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="p-0 col-x1">
                                                                <asp:Label ID="Label20" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl5 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="*" ValidationGroup="NovoBoleto" ControlToValidate="txtBoletoTotal" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxTextBox ID="txtBoletoTotal" ClientInstanceName="txtBoletoTotal" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%">
                                                                        <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                        <MaskHintStyle Paddings-Padding="0px"></MaskHintStyle>
                                                                        <CaptionCellStyle Paddings-Padding="0px"></CaptionCellStyle>
                                                                        <RootStyle Paddings-Padding="0px"></RootStyle>
                                                                        <Paddings Padding="0px" />
                                                                        <ValidationSettings ErrorDisplayMode="None" Display="None" ErrorFrameStyle-Paddings-Padding="0px"></ValidationSettings>
                                                                    </dx:ASPxTextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <asp:Label ID="Label21" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="*" ValidationGroup="NovoBoleto" ControlToValidate="txtDtVenc" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxDateEdit ID="txtDtVenc" ClientInstanceName="txtDtVenc" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days">
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                        <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                                            <MonthGridPaddings Padding="0px" />
                                                                            <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                                            <HeaderStyle BackColor="#669999" />
                                                                            <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                                                        </CalendarProperties>
                                                                        <ValidationSettings ValidationGroup="NovoBoleto"></ValidationSettings>
                                                                    </dx:ASPxDateEdit>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <br />
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <dx:ASPxButton ID="btnNextBoleto" runat="server" ValidationGroup="NovoBoleto" CssClass="btn-using" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn1 %>"
                                                                        OnClick="btnNextBoleto_Click" Height="30px">
                                                                        <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                    </dx:ASPxButton>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <div class="p-0 col-x1">
                                                                <br />
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <asp:Label ID="lblErroTotal" runat="server" Text="" ForeColor="Red" CssClass="labels text-left"></asp:Label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <dx:ASPxGridView ID="ASPxGridView1" ClientInstanceName="ASPxGridView1" runat="server" Theme="Material"
                                                                OnBatchUpdate="ASPxGridView1_BatchUpdate" OnCustomDataCallback="ASPxGridView1_CustomDataCallback">
                                                                <Settings ShowFooter="true" VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                                <SettingsBehavior AllowFocusedRow="true" />
                                                                <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="false"></SettingsEditing>
                                                                <SettingsCommandButton>
                                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                        </Image>
                                                                    </NewButton>
                                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                        </Image>
                                                                    </DeleteButton>
                                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                        </Image>
                                                                    </RecoverButton>
                                                                </SettingsCommandButton>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowDeleteButton="True" ButtonRenderMode="Image">
                                                                    </dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="valor" VisibleIndex="2" Caption="<%$Resources:Boletagem, boletagem_grid1_popup2_grid_col1 %>" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true">
                                                                        <PropertiesTextEdit DisplayFormatString="{0:N2}"></PropertiesTextEdit>

                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="moidmoda" Caption="<%$Resources:Boletagem, boletagem_grid1_popup2_grid_col2 %>" VisibleIndex="1" PropertiesComboBox-ValidationSettings-RequiredField-IsRequired="true">
                                                                        <PropertiesComboBox DataSourceID="sqlVerbas2" TextField="MODSMODA" ValueField="MOIDMODA">
                                                                            <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
                                                                    var newValueOfComboBox = 'moidmoda#'+s.GetValue();                                    
                                                                    ASPxGridView1.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                                        </PropertiesComboBox>
                                                                    </dx:GridViewDataComboBoxColumn>
                                                                </Columns>
                                                                <TotalSummary>
                                                                    <dx:ASPxSummaryItem FieldName="valor" DisplayFormat="{0:N2}" SummaryType="Sum" Visible="true" ShowInColumn="valor" />
                                                                </TotalSummary>
                                                                <Templates>
                                                                    <StatusBar>
                                                                        <div style="text-align: left">
                                                                            <br />
                                                                            <dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ ASPxGridView1.UpdateEdit(); }">
                                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                            </dx:ASPxButton>
                                                                            <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ ASPxGridView1.CancelEdit(); }">
                                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                            </dx:ASPxButton>
                                                                            <dx:ASPxButton ID="btnGravarBoleto" runat="server" ValidationGroup="NovoBoleto" CssClass="btn-using ok" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn2 %>" OnClick="btnGravarBoleto_Click">
                                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                            </dx:ASPxButton>
                                                                            <dx:ASPxButton ID="btnLimparBoleto" runat="server" CausesValidation="false" CssClass="btn-using cancelar" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn3 %>" OnClick="btnLimparBoleto_Click">
                                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                            </dx:ASPxButton>
                                                                        </div>
                                                                    </StatusBar>
                                                                </Templates>
                                                                <Styles>
                                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                    <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                                                    </Header>
                                                                    <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                                    </Row>
                                                                    <EditFormCell Font-Size="8pt"></EditFormCell>
                                                                    <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                    <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                                        <Paddings Padding="0px" />
                                                                    </BatchEditCell>
                                                                    <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                    <FocusedRow BackColor="#99bbbb"></FocusedRow>
                                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                    <Table></Table>
                                                                    <Cell Paddings-Padding="5px"></Cell>
                                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                </Styles>
                                                            </dx:ASPxGridView>
                                                            <dx:ASPxGridView ID="gridEntry22" Visible="false" CssClass="bg-transparent" EnableCallBacks="false" ClientInstanceName="gridEntry2" EnableViewState="false" ClientIDMode="Static" Width="300px" Settings-ShowTitlePanel="true" runat="server" EnableRowsCache="false" AutoGenerateColumns="False"
                                                                OnBatchUpdate="gridEntry_BatchUpdate1" OnCustomDataCallback="gridEntry_CustomDataCallback">
                                                                <ClientSideEvents BatchEditStartEditing=" function(s,e) {
                                                    startIndex2 = e.visibleIndex; }" />
                                                                <SettingsPopup>
                                                                    <HeaderFilter MinHeight="140px">
                                                                    </HeaderFilter>
                                                                </SettingsPopup>


                                                            </dx:ASPxGridView>
                                                        </div>
                                                    </div>
                                                </asp:View>
                                                <asp:View ID="vw_PortalLocatario_historico" runat="server">
                                                    <div class="container-fluid">
                                                        <div class="row w-100 m-0">
                                                            <div class="card w-100 bg-transparent">
                                                                <div class="card-header bg-transparent">
                                                                    <asp:Label ID="Label22" Font-Size="12pt" runat="server" Text="Locatário" CssClass="labels text-left"></asp:Label>
                                                                    <div class="input-group mb-auto" style="padding-left: 2px">
                                                                        <dx:ASPxComboBox ID="dropLocatario2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="300px"
                                                                            DataSourceID="sqlLocatario" TextField="FONMAB20" ValueField="FOIDFORN" ValueType="System.Int32" AutoPostBack="true" OnSelectedIndexChanged="dropLocatario2_SelectedIndexChanged">
                                                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                            </ButtonStyle>
                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                        </dx:ASPxComboBox>
                                                                    </div>
                                                                </div>

                                                                <div class="card-body bg-transparent">
                                                                    <dx:ASPxGridView ID="gridBoleto" ClientInstanceName="gridBoleto" KeyFieldName="BOL" ClientIDMode="Static" Width="450px" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlBoletosGrid">
                                                                        <SettingsPopup>
                                                                            <HeaderFilter MinHeight="140px">
                                                                            </HeaderFilter>
                                                                        </SettingsPopup>
                                                                        <Settings VerticalScrollableHeight="594"  />
                                                                        <SettingsPager NumericButtonCount="20" PageSize="20">
                                                                        </SettingsPager>
                                                                        <SettingsCommandButton>
                                                                            <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                                <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                                </Image>
                                                                            </NewButton>
                                                                            <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                                <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                                </Image>
                                                                            </DeleteButton>
                                                                            <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                                <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                                </Image>
                                                                            </RecoverButton>
                                                                        </SettingsCommandButton>
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="NOME" Caption="Boleto" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataDateColumn FieldName="DATAVNCT" Caption="Vencimento" ReadOnly="True" VisibleIndex="1">
                                                                            </dx:GridViewDataDateColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="VALOR" Caption="Total" VisibleIndex="2">
                                                                                <PropertiesTextEdit DisplayFormatString="N2"></PropertiesTextEdit>
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>

                                                                        <SettingsDetail AllowOnlyOneMasterRowExpanded="true" ShowDetailButtons="true" ShowDetailRow="true" />
                                                                        <Images>
                                                                            <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                                                            <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                                                        </Images>
                                                                        <Templates>
                                                                            <DetailRow>
                                                                                <dx:ASPxGridView ID="gridDetalheBoleto" ClientInstanceName="gridDetalheBoleto" ClientIDMode="Static" Theme="Material" Width="100%" runat="server" AutoGenerateColumns="False"
                                                                                    OnBeforePerformDataSelect="gridDetalheBoleto_BeforePerformDataSelect" DataSourceID="sqlDetalheBoletos" KeyFieldName="idseq">
                                                                                    <SettingsPopup>
                                                                                        <HeaderFilter MinHeight="140px">
                                                                                        </HeaderFilter>
                                                                                    </SettingsPopup>

                                                                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                                    <Settings VerticalScrollableHeight="100" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Visible" />
                                                                                    <SettingsPager NumericButtonCount="20" PageSize="20">
                                                                                    </SettingsPager>
                                                                                    <SettingsCommandButton>
                                                                                        <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                                            <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                                            </Image>
                                                                                        </NewButton>
                                                                                        <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                                            <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                                            </Image>
                                                                                        </DeleteButton>
                                                                                        <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                                            <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                                            </Image>
                                                                                        </RecoverButton>
                                                                                    </SettingsCommandButton>
                                                                                    <Columns>
                                                                                        <dx:GridViewDataComboBoxColumn FieldName="moidmoda" Caption="<%$Resources:Boletagem, boletagem_grid1_popup2_grid_col2 %>" VisibleIndex="0" PropertiesComboBox-ValidationSettings-RequiredField-IsRequired="true">
                                                                                            <PropertiesComboBox DataSourceID="sqlVerbas2" TextField="MODSMODA" ValueField="MOIDMODA">
                                                                                            </PropertiesComboBox>
                                                                                        </dx:GridViewDataComboBoxColumn>
                                                                                        <dx:GridViewDataDateColumn FieldName="DATAVNCT" Caption="Vencimento" ReadOnly="True" VisibleIndex="1"></dx:GridViewDataDateColumn>
                                                                                        <dx:GridViewDataTextColumn FieldName="valor" Caption="Valor" VisibleIndex="2">
                                                                                            <PropertiesTextEdit DisplayFormatString="N2"></PropertiesTextEdit>
                                                                                        </dx:GridViewDataTextColumn>
                                                                                    </Columns>
                                                                                    <Images>
                                                                                        <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                                                                        <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                                                                    </Images>
                                                                                    <Styles>
                                                                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                                        <StatusBar BackColor="Transparent" CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                                        <Header Wrap="True" VerticalAlign="Middle" HorizontalAlign="Center" Font-Names="Arial" Font-Size="8pt" BackColor="#669999" ForeColor="White" Paddings-Padding="1px">
                                                                                        </Header>
                                                                                        <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                                                        </Row>
                                                                                        <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                                        <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="Red">
                                                                                            <Paddings Padding="0px" />
                                                                                        </BatchEditCell>
                                                                                        <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                                        <InlineEditCell ForeColor="Red"></InlineEditCell>
                                                                                        <EditForm Paddings-Padding="0px" Font-Size="8pt"></EditForm>
                                                                                        <EditFormCell Paddings-Padding="0px" Font-Size="8pt"></EditFormCell>
                                                                                        <Table>
                                                                                        </Table>

                                                                                        <Cell Paddings-Padding="5px" Font-Size="8pt"></Cell>
                                                                                        <CommandColumn Paddings-Padding="0px"></CommandColumn>
                                                                                    </Styles>
                                                                                </dx:ASPxGridView>
                                                                                <asp:SqlDataSource ID="sqlVerbas2" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                                    SelectCommand="select distinct m.MOIDMODA,m.MODSMODA from modalida m "></asp:SqlDataSource>
                                                                            </DetailRow>
                                                                        </Templates>
                                                                        <Styles>
                                                                            <DetailButton Paddings-Padding="0px"></DetailButton>
                                                                            <DetailRow BackColor="#f1f1f1">
                                                                            </DetailRow>
                                                                            <DetailCell Paddings-Padding="3px"></DetailCell>
                                                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                            <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-PaddingBottom="0px" Paddings-PaddingTop="0px" Paddings-Padding="3px">
                                                                            </Header>
                                                                            <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                            </Row>
                                                                            <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                            <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                                <Paddings Padding="0px" />
                                                                            </BatchEditCell>
                                                                            <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                            <EditForm Paddings-Padding="0px"></EditForm>
                                                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                            <Table></Table>
                                                                            <Cell Paddings-Padding="5px"></Cell>
                                                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                        </Styles>
                                                                    </dx:ASPxGridView>
                                                                    <asp:SqlDataSource runat="server" ID="sqlDetalheBoletos" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                        SelectCommand="select moidmoda,convert(datetime,data_venc) as DATAVNCT,valor,idseq from fluxo_oper_jesse where bolidbol=?">
                                                                        <SelectParameters>
                                                                            <asp:Parameter Name="?"></asp:Parameter>
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>
                                                                    <asp:SqlDataSource ID="sqlBoletosGrid" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                        SelectCommand="select b.BOLNMBOL as NOME,convert(datetime,b.BOLDTVCT) as DATAVNCT,b.BOLVLBOL as VALOR,b.BOLIDBOL as BOL from fluxo_oper_jesse f, BOLTOTBO b
where b.boltpent=1 and b.OPIDCONT IN (
SELECT OPIDCONT FROM OPCONTRA WHERE (FOIDFORN =? or FOIDFORN2=?) and OPTPTPID=1
)
and f.bolidbol = b.BOLIDBOL">
                                                                        <SelectParameters>
                                                                            <asp:Parameter Name="?"></asp:Parameter>
                                                                            <asp:Parameter Name="?"></asp:Parameter>
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                </asp:View>
                                            </asp:MultiView>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="tela7" runat="server">
                            <div class="container-fluid">
                                <div class="row mt-1">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent">
                                            <div class="card-header border-0 bg-transparent">
                                                <div class="row d-flex">
                                                    <h5>
                                                        <asp:Label ID="Label24" runat="server" Text="<%$Resources:Setup, setup_menu2-3_lbl1 %>" CssClass=""></asp:Label></h5>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent">
                                                <div class="row p-0">
                                                    <div class="col-lg-9 card bg-transparent">
                                                        <dx:ASPxGridView ID="gridUsuariosLogados" CssClass="mt-1" ClientInstanceName="gridUsuariosLogados" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                            Width="100%" DataSourceID="sqlUsuariosLogados" KeyFieldName="USIDUSUA" Settings-ShowTitlePanel="true">
                                                            <SettingsPopup>
                                                                <HeaderFilter MinHeight="140px">
                                                                </HeaderFilter>
                                                            </SettingsPopup>
                                                            <SettingsText Title="<%$Resources:Setup, setup_menu2-3_grid1_lbl1 %>" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                            <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                            <SettingsPager Mode="ShowAllRecords">
                                                            </SettingsPager>
                                                            <SettingsCommandButton>
                                                                <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                    <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                    </Image>
                                                                </NewButton>
                                                                <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                    <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                    </Image>
                                                                </DeleteButton>
                                                                <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                    <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                    </Image>
                                                                </RecoverButton>
                                                            </SettingsCommandButton>
                                                            <Columns>
                                                                <dx:GridViewDataTextColumn FieldName="USNMPRUS" Width="70px" Caption="<%$Resources:Setup, setup_menu2-3_grid1_col1 %>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="USNMSNUS" Width="70px" Caption="<%$Resources:Setup, setup_menu2-3_grid1_col2 %>" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="USIDUSUA" Width="70px" Caption="<%$Resources:Setup, setup_menu2-3_grid1_col3 %>" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="data" Width="100px" Caption="<%$Resources:Setup, setup_menu2-3_grid1_col4 %>" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataTextColumn FieldName="USLASTACT" Width="70px" Caption="<%$Resources:Setup, setup_menu2-3_grid1_col5 %>" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                                                <dx:GridViewDataComboBoxColumn FieldName="Situacao" Width="70px" Caption="<%$Resources:Setup, setup_menu2-3_grid1_col6 %>" VisibleIndex="5">
                                                                    <PropertiesComboBox>
                                                                        <Items>
                                                                            <dx:ListEditItem Text="Ativo" Value="0"></dx:ListEditItem>
                                                                            <dx:ListEditItem Text="Expirado" Value="-1"></dx:ListEditItem>
                                                                        </Items>
                                                                    </PropertiesComboBox>
                                                                </dx:GridViewDataComboBoxColumn>

                                                            </Columns>
                                                            <Styles>
                                                                <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                </Header>
                                                                <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                </Row>
                                                                <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                    <Paddings Padding="0px" />
                                                                </BatchEditCell>
                                                                <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                <EditForm Paddings-Padding="0px"></EditForm>
                                                                <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                <Table></Table>
                                                                <Cell Paddings-Padding="5px"></Cell>
                                                                <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                            </Styles>
                                                        </dx:ASPxGridView>
                                                        <asp:SqlDataSource runat="server" ID="sqlUsuariosLogados" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                            SelectCommand=""></asp:SqlDataSource>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="vw_Componente" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent pt-0 pb-0">
                                            <div class="card-header bg-transparent p-0">
                                                <div class="row d-flex">
                                                    <h4>
                                                        <asp:Label ID="Label25" runat="server" Text="<%$Resources:Setup, setup_menu6-1_lbl1 %>" CssClass=""></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent p-0">
                                                <div class="row pt-0">
                                                    <dx:ASPxGridView ID="gridComponente" ClientInstanceName="gridComponente" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False"
                                                        AutoGenerateColumns="False" SettingsResizing-ColumnResizeMode="NextColumn" DataSourceID="sqlComponente" KeyFieldName="chidcodi"
                                                        OnRowDeleting="gridComponente_RowDeleting" OnRowInserting="gridComponente_RowInserting" OnRowUpdating="gridComponente_RowUpdating">
                                                        <SettingsPopup>
                                                            <HeaderFilter MinHeight="140px">
                                                            </HeaderFilter>
                                                        </SettingsPopup>
                                                        <SettingsBehavior ConfirmDelete="true" />
                                                        <SettingsEditing Mode="EditForm"></SettingsEditing>
                                                        <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowEditButton="True" ShowDeleteButton="True" ButtonRenderMode="Image" Width="50px"></dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="chidcodi" Caption="ID" VisibleIndex="1" Width="100px">
                                                                <PropertiesTextEdit>
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorFrameStyle-ForeColor="Red">
                                                                        <RequiredField IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="chdsdecr" Caption="Componente" VisibleIndex="2" Width="450px">
                                                                <PropertiesTextEdit>
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorFrameStyle-ForeColor="Red">
                                                                        <RequiredField IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </PropertiesTextEdit>
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataComboBoxColumn FieldName="cmidcodi" Caption="Classe" VisibleIndex="3">
                                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlClasseComponente" TextField="TEXTO" ValueField="CMIDCODI">
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorFrameStyle-ForeColor="Red">
                                                                        <RequiredField IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </PropertiesComboBox>
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataComboBoxColumn FieldName="chflsimp" Caption="Modelo" VisibleIndex="4">
                                                                <PropertiesComboBox>
                                                                    <Items>
                                                                        <dx:ListEditItem Text="Simplificado" Value="1"></dx:ListEditItem>
                                                                        <dx:ListEditItem Text="Complexo" Value="2"></dx:ListEditItem>
                                                                    </Items>
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorFrameStyle-ForeColor="Red">
                                                                        <RequiredField IsRequired="true" />
                                                                    </ValidationSettings>
                                                                </PropertiesComboBox>
                                                            </dx:GridViewDataComboBoxColumn>
                                                        </Columns>
                                                        <SettingsCommandButton>
                                                            <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                </Image>
                                                            </NewButton>
                                                            <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                </Image>
                                                            </DeleteButton>
                                                            <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                </Image>
                                                            </RecoverButton>
                                                            <EditButton>
                                                                <Image ToolTip="Edit" Url="img/icons8-edit-80.png" Width="15px" />
                                                            </EditButton>
                                                            <UpdateButton RenderMode="Image">
                                                                <Image ToolTip="Save changes and close Edit Form" Url="img/ok.png" Width="50px" />
                                                            </UpdateButton>
                                                            <CancelButton RenderMode="Image">
                                                                <Image ToolTip="Close Edit Form without saving changes" Url="img/cancel.png" Width="50px" />
                                                            </CancelButton>
                                                        </SettingsCommandButton>
                                                        <Columns>
                                                        </Columns>
                                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                                        </SettingsPager>
                                                        <Styles>
                                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                            <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                            </Header>
                                                            <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                            </Row>
                                                            <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                            <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                <Paddings Padding="0px" />
                                                            </BatchEditCell>
                                                            <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                            <EditForm Paddings-Padding="0px"></EditForm>
                                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                            <Table></Table>
                                                            <Cell Paddings-Padding="5px"></Cell>
                                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                        </Styles>
                                                    </dx:ASPxGridView>
                                                    <asp:SqlDataSource runat="server" ID="sqlComponente" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                        SelectCommand="select chidcodi,chdsdecr,cmidcodi,chflsimp from CHCOMPOT where cmidcodi not in (0) order by 1"></asp:SqlDataSource>
                                                    <asp:SqlDataSource runat="server" ID="sqlClasseComponente" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                        SelectCommand="select CMIDCODI,CONCAT(C2.CMTPDSCM,'-',C.CMDSCLAN) AS TEXTO from CMCLACOM C,CMTPCMCL C2 WHERE C.CMTPIDCM=C2.CMTPIDCM AND C2.PAIDPAIS=1 ORDER BY 2
"></asp:SqlDataSource>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="vw_Produto" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent pt-0 pb-0">
                                            <div class="card-header bg-transparent p-0">
                                                <div class="row d-flex">
                                                    <h4>
                                                        <asp:Label ID="Label26" runat="server" Text="<%$Resources:Setup, setup_menu6-2_lbl1 %>" CssClass=""></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent p-0">
                                                <dx:ASPxGridView ID="gridProduto" ClientInstanceName="gridProduto" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False"
                                                    AutoGenerateColumns="False" DataSourceID="sqlProdutos" SettingsResizing-ColumnResizeMode="NextColumn" KeyFieldName="prprodid" OnRowUpdating="gridProduto_RowUpdating" OnRowInserting="gridProduto_RowInserting" OnRowDeleting="gridProduto_RowDeleting">
                                                    <SettingsPopup>
                                                        <HeaderFilter MinHeight="140px">
                                                        </HeaderFilter>
                                                    </SettingsPopup>
                                                    <SettingsBehavior ConfirmDelete="true" />
                                                    <SettingsEditing Mode="EditForm"></SettingsEditing>
                                                    <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                    <SettingsCommandButton>
                                                        <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                            <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                            </Image>
                                                        </NewButton>
                                                        <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                            <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                            </Image>
                                                        </DeleteButton>
                                                        <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                            <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                            </Image>
                                                        </RecoverButton>
                                                        <EditButton>
                                                            <Image ToolTip="Edit" Url="img/icons8-edit-80.png" Width="15px" />
                                                        </EditButton>
                                                        <UpdateButton RenderMode="Image">
                                                            <Image ToolTip="Save changes and close Edit Form" Url="img/ok.png" Width="50px" />
                                                        </UpdateButton>
                                                        <CancelButton RenderMode="Image">
                                                            <Image ToolTip="Close Edit Form without saving changes" Url="img/cancel.png" Width="50px" />
                                                        </CancelButton>
                                                    </SettingsCommandButton>
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ShowEditButton="True" VisibleIndex="0" ShowNewButtonInHeader="True" ButtonRenderMode="Image" Width="75px"></dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="prprodid" ReadOnly="True" VisibleIndex="1" Visible="false">
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="prprodes" Caption="Produto" VisibleIndex="2">
                                                            <PropertiesTextEdit>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="prmonint" Caption="Monitor de Interface" VisibleIndex="3" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text="Sim" Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text="Não" Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="origem" ShowInCustomizationForm="True" Caption="<%$ Resources:Tipologia, tipologia_grid1_col2 %>" Visible="False" VisibleIndex="7">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text="<%$ Resources:Tipologia, tipologia_quiz_1-1 %>" Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text="<%$ Resources:Tipologia, tipologia_quiz_1-2 %>" Value="0"></dx:ListEditItem>
                                                                </Items>

                                                                <ValidationSettings ErrorDisplayMode="None" Display="Dynamic">
                                                                    <RequiredField IsRequired="True"></RequiredField>
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>

                                                            <EditFormSettings Visible="True"></EditFormSettings>
                                                        </dx:GridViewDataComboBoxColumn>

                                                        <dx:GridViewDataComboBoxColumn FieldName="capital" Caption='<%$ Resources:Tipologia, tipologia_grid1_col3 %>' ShowInCustomizationForm="True" Visible="False" VisibleIndex="8">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_2-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_2-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>

                                                            <EditFormSettings Visible="True"></EditFormSettings>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="usgaap" Caption='<%$ Resources:Tipologia, tipologia_grid1_col4 %>' ShowInCustomizationForm="True" Visible="False" VisibleIndex="9">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_3-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_3-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>

                                                            <EditFormSettings Visible="True"></EditFormSettings>
                                                        </dx:GridViewDataComboBoxColumn>

                                                        <dx:GridViewDataComboBoxColumn FieldName="impostos" Caption='<%$ Resources:Tipologia, tipologia_grid1_col5 %>' VisibleIndex="10" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_4-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_4-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="reajustes" Caption='<%$ Resources:Tipologia, tipologia_grid1_col6 %>' VisibleIndex="11" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_5-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_5-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="carencia" Caption='<%$ Resources:Tipologia, tipologia_grid1_col7 %>' VisibleIndex="12" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_6-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_6-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="fluxo" Caption='<%$ Resources:Tipologia, tipologia_grid1_col8 %>' VisibleIndex="13" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_7-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_7-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="calculo" Caption='<%$ Resources:Tipologia, tipologia_grid1_col9 %>' VisibleIndex="14" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_8-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_8-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="depreciacao" Caption='<%$ Resources:Tipologia, tipologia_grid1_col10 %>' VisibleIndex="15" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_9-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_9-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="remensuracao" Caption='<%$ Resources:Tipologia, tipologia_grid1_col11 %>' VisibleIndex="16" Visible="false" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox>
                                                                <Items>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_10-1 %>' Value="1"></dx:ListEditItem>
                                                                    <dx:ListEditItem Text='<%$ Resources:Tipologia, tipologia_quiz_10-2 %>' Value="0"></dx:ListEditItem>
                                                                </Items>
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        
                                                        <dx:GridViewDataComboBoxColumn FieldName="id" Caption="Classe" VisibleIndex="6" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox DataSourceID="sqlPRTPNMOP" TextField="PRTPNMOP" ValueField="id">
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="ieidinec" Caption="&#205;ndice" VisibleIndex="5" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox DataSourceID="sqlIndexador" TextField="IENMINEC" ValueField="IEIDINEC" ValueType="System.Int32">
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="chidcodi" Caption="Componente" VisibleIndex="4" EditFormSettings-Visible="True">
                                                            <PropertiesComboBox DataSourceID="sqlCompProdutos" TextField="texto" ValueField="chidcodi" ValueType="System.Int32">
                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None">
                                                                    <RequiredField IsRequired="true" />
                                                                </ValidationSettings>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                    </Columns>
                                                    <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                                    </SettingsPager>
                                                    <Styles>
                                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                        <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                        </Header>
                                                        <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                        </Row>
                                                        <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                        <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                            <Paddings Padding="0px" />
                                                        </BatchEditCell>
                                                        <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                        <EditForm Paddings-Padding="0px"></EditForm>
                                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                        <Table></Table>
                                                        <Cell Paddings-Padding="5px"></Cell>
                                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                    </Styles>
                                                </dx:ASPxGridView>
                                                <asp:SqlDataSource runat="server" ID="sqlProdutos" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select prprodid,prprodes,chidcodi,ieidinec,concat(PRTPIDOP,'#',cmtpidcm) id,origem,capital,usgaap,impostos,reajustes,carencia,fluxo,calculo,depreciacao,remensuracao,prmonint from PRPRODUT order by 2"></asp:SqlDataSource>
                                                <asp:SqlDataSource runat="server" ID="sqlIndexador" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select IEIDINEC,IENMINEC from IEINDECO order by 2"></asp:SqlDataSource>
                                                <asp:SqlDataSource runat="server" ID="sqlPRTPNMOP" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select concat(PRTPIDOP,'#',cmtpidcm) id, PRTPNMOP from PRTPOPER where paidpais=1 order by 2"></asp:SqlDataSource>
                                                <asp:SqlDataSource runat="server" ID="sqlCompProdutos" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select concat(chidcodi,'-',chdsdecr) texto,chidcodi from CHCOMPOT where cmidcodi not in (0) order by 2"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="vw_Propriedades" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent">
                                            <div class="card-header bg-transparent">
                                                <div class="row d-flex">
                                                    <h4>
                                                        <asp:Label ID="Label27" runat="server" Text="<%$Resources:Setup, setup_menu6-3_lbl1 %>" CssClass=""></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent pt-0 pb-0">
                                                <div class="row d-flex justify-content-center pt-0 pb-0">
                                                    <div class="col-x1">
                                                        <h6>
                                                            <asp:Label ID="Label34" runat="server" Text="Selecione o Componente"></asp:Label></h6>
                                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('produto');">
                                                            <dx:ASPxComboBox ID="dropComponenteProp" ClientIDMode="Static" ClientInstanceName="dropComponenteProp" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2 drop-down" Theme="Material" Width="100%"
                                                                TextField="chdsdecr" ValueField="chidcodi" DataSourceID="sqlComponenteProp" AutoPostBack="true" OnSelectedIndexChanged="dropComponenteProp_SelectedIndexChanged">
                                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                </ButtonStyle>
                                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            </dx:ASPxComboBox>
                                                            <asp:SqlDataSource runat="server" ID="sqlComponenteProp" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select concat(chidcodi,'#',cmidcodi) chidcodi,concat(chidcodi,' - ',chdsdecr) chdsdecr from CHCOMPOT where cmidcodi not in (0) order by 2"></asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                    <div class="col-x1">
                                                        <h6>
                                                            <asp:Label ID="Label33" runat="server" Text="Selecione o Evento"></asp:Label></h6>
                                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('produto');">
                                                            <dx:ASPxComboBox ID="dropEventoProp" ClientIDMode="Static" ClientInstanceName="dropEventoProp" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2 drop-down" Theme="Material" Width="100%"
                                                                TextField="CHTPDSEV" ValueField="CHTPIDEV" DataSourceID="sqlEventoProp">
                                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                </ButtonStyle>
                                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                <ClientSideEvents SelectedIndexChanged="function (s,e) {
                                                                    document.getElementById('hfDropEvento').value = s.GetValue();
                                                                    gridPropVinculadas.Refresh();
                                                                    gridPropNaoVinculadas.Refresh();
                                                                    }" />
                                                            </dx:ASPxComboBox>
                                                            <asp:SqlDataSource runat="server" ID="sqlEventoProp" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="SELECT CHTPIDEV, CHTPDSEV FROM CMTPEVEN WHERE CMIDCODI=? and paidpais=1 ORDER BY 2">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfDropCMID" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                    <div class="col-x1">
                                                        <br />
                                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 10px">
                                                            <asp:TextBox ID="TextBox6" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                    <div class="col-x1">
                                                        <br />
                                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 10px">
                                                            <asp:TextBox ID="TextBox7" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                </div>
                                                <div class="row mt-3">
                                                    <div class="col-lg-4 card bg-transparent p-0">
                                                        <div class="card-header bg-transparent p-0">
                                                            <h6>
                                                                <asp:Label ID="Label35" runat="server" Text="Propriedades Vinculadas" CssClass=""></asp:Label></h6>
                                                        </div>
                                                        <div class="card-body bg-transparent p-0 pr-1">
                                                            <dx:ASPxGridView ID="gridPropVinculadas" CssClass="mt-1" ClientInstanceName="gridPropVinculadas" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                Width="100%" DataSourceID="sqlPropVinculadas" OnCustomButtonCallback="gridPropVinculadas_CustomButtonCallback" KeyFieldName="CJIDCODI" OnRowUpdating="gridPropVinculadas_RowUpdating">
                                                                <ClientSideEvents EndCallback="function (s,e) { 
                                                                if(s.cp_ok=='OK'){
                                                                s.Refresh(); 
                                                                gridPropNaoVinculadas.Refresh(); 
                                                                delete(s.cp_ok);
                                                                }

                                                                }" />
                                                                <SettingsPopup>
                                                                    <HeaderFilter MinHeight="140px">
                                                                    </HeaderFilter>
                                                                </SettingsPopup>
                                                                <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
                                                                <SettingsPopup>
                                                                    <EditForm VerticalAlign="Middle" HorizontalAlign="Center" Width="700px" ShowHeader="false" ShowFooter="false"></EditForm>
                                                                </SettingsPopup>
                                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                <SettingsPager Mode="ShowAllRecords">
                                                                </SettingsPager>
                                                                <SettingsCommandButton>
                                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                        </Image>
                                                                    </NewButton>
                                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                        </Image>
                                                                    </DeleteButton>
                                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                        </Image>
                                                                    </RecoverButton>
                                                                    <EditButton>
                                                                        <Image ToolTip="Edit" Url="img/icons8-edit-80.png" Width="15px" />
                                                                    </EditButton>
                                                                    <UpdateButton RenderMode="Image">
                                                                        <Image ToolTip="Save changes and close Edit Form" Url="img/ok.png" Width="50px" />
                                                                    </UpdateButton>
                                                                    <CancelButton RenderMode="Image">
                                                                        <Image ToolTip="Close Edit Form without saving changes" Url="img/cancel.png" Width="50px" />
                                                                    </CancelButton>
                                                                </SettingsCommandButton>
                                                                <Columns>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJTPIDTP" ReadOnly="True" Width="100%" Caption="Tipo" VisibleIndex="3">
                                                                        <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlTipoCJCLPROP" TextField="CJTPDSTP" ValueField="CJTPIDTP">
                                                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorFrameStyle-ForeColor="Red">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </PropertiesComboBox>
                                                                    </dx:GridViewDataComboBoxColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJIDCODI" Caption="#ID" VisibleIndex="0" ReadOnly="True" Visible="false">
                                                                        <EditFormSettings Visible="True" />
                                                                        <PropertiesTextEdit NullText=" "></PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJDSDECR" Caption="Propriedade" Width="100%" VisibleIndex="1">
                                                                        <EditFormSettings Visible="True" />
                                                                        <PropertiesTextEdit NullText=" ">
                                                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ErrorFrameStyle-ForeColor="Red">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJTPCTTX" Caption="Valor" Width="100%" VisibleIndex="2" Visible="false">
                                                                        <EditFormSettings Visible="True" />
                                                                        <PropertiesTextEdit NullText=" "></PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJORORDE" Caption="Ordem" Width="100%" VisibleIndex="5" Visible="true">
                                                                        <EditFormSettings Visible="True" />
                                                                        <PropertiesTextEdit NullText=" "></PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJCHAVE" Caption="Chave" Width="100%" VisibleIndex="8" Visible="false">
                                                                        <EditFormSettings Visible="True" />
                                                                        <PropertiesTextEdit NullText=" "></PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJFLOBRG" ShowInCustomizationForm="True" Width="100%" Caption="Obrigat&#243;rio" Visible="False" VisibleIndex="6">
                                                                        <PropertiesComboBox NullText=" ">
                                                                            <Items>
                                                                                <dx:ListEditItem Text="Sim" Value="S"></dx:ListEditItem>
                                                                                <dx:ListEditItem Text="N&#227;o" Value="N"></dx:ListEditItem>
                                                                            </Items>
                                                                        </PropertiesComboBox>
                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataComboBoxColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJTPCAID" Width="100%" Caption="Formato Alimenta&#231;&#227;o" Visible="False" VisibleIndex="4">
                                                                        <PropertiesComboBox NullText=" " DataSourceID="sqlTipoAlimentacao" TextField="CJTPCADS" ValueField="CJTPCAID" ValueType="System.Int32">
                                                                        </PropertiesComboBox>
                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataComboBoxColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJFLAQUI" Width="100%" Caption="Vis&#237;vel" Visible="False" VisibleIndex="7">
                                                                        <PropertiesComboBox NullText=" ">
                                                                            <Items>
                                                                                <dx:ListEditItem Text="Sim" Value="S"></dx:ListEditItem>
                                                                                <dx:ListEditItem Text="N&#227;o" Value="N"></dx:ListEditItem>
                                                                            </Items>
                                                                        </PropertiesComboBox>
                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataComboBoxColumn>
                                                                    <dx:GridViewCommandColumn ShowEditButton="true" VisibleIndex="13" Caption=" " Width="50px" ButtonRenderMode="Image">
                                                                        <CustomButtons>
                                                                            <dx:GridViewCommandColumnCustomButton ID="deleteProp">
                                                                                <Image Url="~/img/right_arrow.png" ToolTip="Desassociar" Width="15px"></Image>
                                                                            </dx:GridViewCommandColumnCustomButton>
                                                                        </CustomButtons>
                                                                    </dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataMemoColumn FieldName="CJDSMENS" Width="100%" Caption="Mensagem" Visible="False" VisibleIndex="10">
                                                                        <PropertiesMemoEdit NullText=" " Height="70px"></PropertiesMemoEdit>
                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataMemoColumn>
                                                                    <dx:GridViewDataMemoColumn FieldName="CJFILTRO" Width="100%" Caption="Filtro" Visible="False" VisibleIndex="12">
                                                                        <PropertiesMemoEdit NullText=" " Height="70px"></PropertiesMemoEdit>
                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataMemoColumn>
                                                                    <dx:GridViewDataMemoColumn FieldName="CJDSEXPR" Width="100%" Caption="Valida&#231;&#227;o" Visible="False" VisibleIndex="9">
                                                                        <PropertiesMemoEdit NullText=" " Height="70px"></PropertiesMemoEdit>
                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataMemoColumn>
                                                                </Columns>
                                                                <Styles>
                                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                    <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                    </Header>
                                                                    <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                    </Row>
                                                                    <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                    <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                        <Paddings Padding="0px" />
                                                                    </BatchEditCell>
                                                                    <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                    <Table></Table>
                                                                    <Cell Paddings-Padding="5px"></Cell>
                                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                </Styles>
                                                            </dx:ASPxGridView>
                                                            <asp:SqlDataSource runat="server" ID="sqlPropVinculadas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select c.* 
                                                                from CJCLPROP c, VIPROEVE v
where c.CHIDCODI=v.CHIDCODI
  and c.CJIDCODI=v.CJIDCODI
  and v.CHTPIDEV=?
  and c.CHIDCODI=? order by CJDSDECR"
                                                                UpdateCommand="select * from CJCLPROP c">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfDropEvento" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    <asp:ControlParameter ControlID="hfDropComp" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                            <asp:SqlDataSource runat="server" ID="sqlOrdemProp" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select CONCAT(CJORORDE,'#', CJORORDE+1) ID, CJDSDECR from CJCLPROP C where CHIDCODI=? AND CJORORDE is not null order by 1">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfDropComp" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-8 card bg-transparent p-0">
                                                        <div class="card-header bg-transparent p-0">
                                                            <h6>
                                                                <asp:Label ID="Label36" runat="server" Text="Propriedades Não Vinculadas" CssClass=""></asp:Label></h6>
                                                        </div>
                                                        <div class="card-body bg-transparent p-0 pr-1">
                                                            <dx:ASPxGridView ID="gridPropNaoVinculadas" Enabled="false" CssClass="mt-1" ClientInstanceName="gridPropNaoVinculadas" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                Width="100%" DataSourceID="sqlPropNaoVinculadas" KeyFieldName="CJIDCODI" OnCustomButtonCallback="gridPropNaoVinculadas_CustomButtonCallback" OnRowUpdating="gridPropNaoVinculadas_RowUpdating" OnRowInserting="gridPropNaoVinculadas_RowInserting"
                                                                OnCellEditorInitialize="gridPropNaoVinculadas_CellEditorInitialize" OnRowValidating="gridPropNaoVinculadas_RowValidating">
                                                                <ClientSideEvents EndCallback="function (s,e) { 
                                                                if(s.cp_ok=='OK'){
                                                                s.Refresh(); 
                                                                gridPropVinculadas.Refresh(); 
                                                                delete(s.cp_ok);
                                                                }

                                                                }" />
                                                                <SettingsPopup>
                                                                    <HeaderFilter MinHeight="140px">
                                                                    </HeaderFilter>
                                                                </SettingsPopup>
                                                                <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
                                                                <SettingsPopup>
                                                                    <EditForm VerticalAlign="Middle" HorizontalAlign="Center" Width="700px" ShowHeader="false" ShowFooter="false"></EditForm>
                                                                </SettingsPopup>
                                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                <SettingsPager Mode="ShowAllRecords">
                                                                </SettingsPager>
                                                                <SettingsCommandButton>
                                                                    <NewButton>
                                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                        </Image>
                                                                    </NewButton>
                                                                    <DeleteButton>
                                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                        </Image>
                                                                    </DeleteButton>
                                                                    <RecoverButton>
                                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                        </Image>
                                                                    </RecoverButton>
                                                                    <EditButton>
                                                                        <Image ToolTip="Edit" Url="img/icons8-edit-80.png" Width="15px" />
                                                                    </EditButton>
                                                                    <UpdateButton RenderMode="Image">
                                                                        <Image ToolTip="Save changes and close Edit Form" Url="img/ok.png" Width="50px" />
                                                                    </UpdateButton>
                                                                    <CancelButton RenderMode="Image">
                                                                        <Image ToolTip="Close Edit Form without saving changes" Url="img/cancel.png" Width="50px" />
                                                                    </CancelButton>
                                                                </SettingsCommandButton>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowEditButton="true" VisibleIndex="0" Caption=" " Width="70px" ButtonRenderMode="Image">
                                                                        <CustomButtons>
                                                                            <dx:GridViewCommandColumnCustomButton ID="AssocProp">
                                                                                <Image Url="~/img/left_arrow.png" ToolTip="Vincular" Width="15px"></Image>
                                                                            </dx:GridViewCommandColumnCustomButton>
                                                                        </CustomButtons>
                                                                    </dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJTPIDTP" Width="100%" Caption="Tipo" VisibleIndex="4">
                                                                        <EditFormSettings Visible="True" />
                                                                        <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlTipoCJCLPROP" TextField="CJTPDSTP" ValueField="CJTPIDTP">
                                                                            <ValidationSettings Display="Dynamic" ErrorTextPosition="Bottom" ErrorDisplayMode="None">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </PropertiesComboBox>
                                                                    </dx:GridViewDataComboBoxColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJIDCODI" Caption="#ID" VisibleIndex="1" ReadOnly="True" Visible="true">
                                                                        <EditFormSettings Visible="True" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJDSDECR" Caption="Propriedade" Width="100%" VisibleIndex="2">
                                                                        <EditFormSettings Visible="True" />
                                                                        <PropertiesTextEdit>
                                                                            <ValidationSettings Display="Dynamic" ErrorTextPosition="Bottom" ErrorDisplayMode="None">
                                                                                <RequiredField IsRequired="true" />
                                                                            </ValidationSettings>
                                                                        </PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJTPCTTX" Caption="Valor" Width="100%" VisibleIndex="3" Visible="false">
                                                                        <EditFormSettings Visible="True" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJORORDE" Caption="Ordem" Width="100%" VisibleIndex="6" Visible="true">
                                                                        <EditFormSettings Visible="True" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="CJCHAVE" Caption="Chave" Width="100%" VisibleIndex="8" Visible="false">
                                                                        <EditFormSettings Visible="True" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJFLOBRG" ShowInCustomizationForm="True" Width="100%" Caption="Obrigat&#243;rio" Visible="False" VisibleIndex="7">
                                                                        <PropertiesComboBox>
                                                                            <Items>
                                                                                <dx:ListEditItem Text="Sim" Value="S"></dx:ListEditItem>
                                                                                <dx:ListEditItem Text="N&#227;o" Value="N"></dx:ListEditItem>
                                                                            </Items>
                                                                        </PropertiesComboBox>

                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataComboBoxColumn>

                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJTPCAID" Width="100%" Caption="Formato Alimenta&#231;&#227;o" Visible="False" VisibleIndex="5">
                                                                        <PropertiesComboBox DataSourceID="sqlTipoAlimentacao" TextField="CJTPCADS" ValueField="CJTPCAID" ValueType="System.Int32">
                                                                        </PropertiesComboBox>

                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataComboBoxColumn>

                                                                    <dx:GridViewDataComboBoxColumn FieldName="CJFLAQUI" Width="100%" Caption="Vis&#237;vel" Visible="False" VisibleIndex="9">
                                                                        <PropertiesComboBox>
                                                                            <Items>
                                                                                <dx:ListEditItem Text="Sim" Value="S"></dx:ListEditItem>
                                                                                <dx:ListEditItem Text="N&#227;o" Value="N"></dx:ListEditItem>
                                                                            </Items>
                                                                        </PropertiesComboBox>

                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataComboBoxColumn>

                                                                    <dx:GridViewDataMemoColumn FieldName="CJDSEXPR" Width="100%" Caption="Valida&#231;&#227;o" Visible="False" VisibleIndex="10">
                                                                        <PropertiesMemoEdit Height="70px"></PropertiesMemoEdit>

                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataMemoColumn>
                                                                    <dx:GridViewDataMemoColumn FieldName="CJDSMENS" Width="100%" Caption="Mensagem" Visible="False" VisibleIndex="12">
                                                                        <PropertiesMemoEdit Height="70px"></PropertiesMemoEdit>

                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataMemoColumn>
                                                                    <dx:GridViewDataMemoColumn FieldName="CJFILTRO" Width="100%" Caption="Filtro" Visible="False" VisibleIndex="11">
                                                                        <PropertiesMemoEdit Height="70px"></PropertiesMemoEdit>

                                                                        <EditFormSettings Visible="True"></EditFormSettings>
                                                                    </dx:GridViewDataMemoColumn>
                                                                </Columns>
                                                                <Styles>
                                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                    <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                    </Header>
                                                                    <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                    </Row>
                                                                    <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                    <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                        <Paddings Padding="0px" />
                                                                    </BatchEditCell>
                                                                    <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                    <Table></Table>
                                                                    <Cell Paddings-Padding="5px"></Cell>
                                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                </Styles>
                                                            </dx:ASPxGridView>
                                                            <asp:SqlDataSource runat="server" ID="sqlPropNaoVinculadas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select * from CJCLPROP c
where c.CJIDCODI not in (
select CJIDCODI from VIPROEVE v
where v.CHTPIDEV=?
  and v.CHIDCODI=?)
  and c.CHIDCODI=? order by CJDSDECR"
                                                                UpdateCommand="select * from CJCLPROP c">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfDropEvento" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    <asp:ControlParameter ControlID="hfDropComp" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    <asp:ControlParameter ControlID="hfDropComp" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="vw_Modalidade" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent">
                                            <div class="card-header bg-transparent">
                                                <div class="row d-flex">
                                                    <h4>
                                                        <asp:Label ID="Label28" runat="server" Text="<%$Resources:Setup, setup_menu6-4_lbl1 %>" CssClass=""></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent pt-0 pb-0">
                                                <div class="row d-flex justify-content-center pt-0">
                                                    <div class="col-x1">
                                                        <h6>
                                                            <asp:Label ID="Label31" runat="server" Text="<%$Resources:Setup, setup_menu3_right_lbl2 %>"></asp:Label></h6>
                                                        <div class="input-group mb-3 drop-down-div">
                                                            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="SELECT B.TVIDESTR, B.TVDSESTR, B.TVCDPAIE, B.TVNVESTR,
                                   A.FOCDXCGC, A.FOCDLICE
                            FROM TVESTRUT B, FOFORNEC A
                            WHERE B.TVIDESTR = A.TVIDESTR
                            AND A.FOTPIDTP = 6
                            AND A.FOCDLICE IS NOT NULL
ORDER BY B.TVIDESTR">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                            <dx:ASPxCallbackPanel ID="ASPxCallbackPanel2" runat="server" Width="100%">
                                                                <PanelCollection>
                                                                    <dx:PanelContent>
                                                                        <dx:ASPxDropDownEdit ID="ASPxDropDownEdit1" Visible="true" CssClass="dropDownEdit drop-down" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                                                            Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false" AutoResizeWithContainer="true" PopupHorizontalAlign="NotSet">
                                                                            <ClientSideEvents
                                                                                Init="UpdateSelection"
                                                                                DropDown="OnDropDown" />
                                                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                            </ButtonStyle>
                                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                            <DropDownWindowTemplate>
                                                                                <div>
                                                                                    <dx:ASPxTreeList ID="TreeList" DataSourceID="SqlDataSource3" ClientInstanceName="TreeList" runat="server"
                                                                                        Width="100%" CssClass="text-left" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                                                                        KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE" AutoGenerateColumns="False">
                                                                                        <Settings ShowFooter="false" ShowFilterBar="Hidden" ShowFilterRow="true" HorizontalScrollBarMode="Auto" VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                                                                        <ClientSideEvents FocusedNodeChanged="function(s,e){ UpdateSelection(); document.getElementById(&#39;btnSelectLoja&#39;).click(); }" />
                                                                                        <BorderBottom BorderStyle="Solid" />
                                                                                        <SettingsBehavior ExpandNodesOnFiltering="true" AllowFocusedNode="true" AutoExpandAllNodes="false" FocusNodeOnLoad="false" />
                                                                                        <SettingsPager Mode="ShowAllNodes">
                                                                                        </SettingsPager>
                                                                                        <Images>
                                                                                            <ExpandedButton Url="icons/icons8-seta-para-recolher-30.png" Width="30px"></ExpandedButton>
                                                                                            <CollapsedButton Url="icons/icons8-seta-para-expandir-30.png" Width="30px"></CollapsedButton>
                                                                                            <HeaderFilter Url="icons/icons8-filter-20.png" Width="25px"></HeaderFilter>
                                                                                        </Images>
                                                                                        <Styles>
                                                                                            <SelectedNode BackColor="#669999"></SelectedNode>
                                                                                            <FocusedNode BackColor="#669999"></FocusedNode>
                                                                                            <Node Cursor="pointer">
                                                                                            </Node>
                                                                                            <Indent Cursor="default">
                                                                                            </Indent>
                                                                                            <Header Paddings-Padding="0px"></Header>

                                                                                        </Styles>
                                                                                        <ClientSideEvents FocusedNodeChanged="function(s,e){ UpdateSelection(); }" NodeClick="function(s, e) {
	isButtonClicked = true;
}"
                                                                                            NodeDblClick="function(s, e) {
	isButtonClicked = true;
}"
                                                                                            NodeFocusing="function(s, e) {
	if (!isButtonClicked) e.cancel = true; 
}"></ClientSideEvents>

                                                                                        <Columns>
                                                                                            <dx:TreeListTextColumn FieldName="TVDSESTR" Width="150px" Caption=" " AutoFilterCondition="Default" ShowInFilterControl="Default" VisibleIndex="0"></dx:TreeListTextColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxTreeList>
                                                                                    <table class="d-none" style="background-color: White; width: 250px;">
                                                                                        <tr>
                                                                                            <td style="padding: 5px;">
                                                                                                <dx:ASPxButton ID="clearButton" ClientEnabled="false" Theme="Material" ClientInstanceName="clearButton"
                                                                                                    runat="server" AutoPostBack="false" Text="Clear" BackColor="#669999" Font-Size="9pt" Paddings-PaddingLeft="2px" Paddings-PaddingRight="2px">
                                                                                                    <ClientSideEvents Click="ClearSelection" />
                                                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                                                                </dx:ASPxButton>
                                                                                            </td>
                                                                                            <td style="text-align: right; padding: 5px;">
                                                                                                <dx:ASPxButton ID="selectButton" ClientEnabled="false" Theme="Material" ClientInstanceName="selectButton"
                                                                                                    runat="server" AutoPostBack="false" Text="Select" BackColor="#669999" Font-Size="9pt" Paddings-PaddingLeft="2px" Paddings-PaddingRight="2px">
                                                                                                    <ClientSideEvents Click=" function (s,e) { 
                                                            UpdateSelection();  } " />
                                                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                                                                </dx:ASPxButton>
                                                                                                <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" Text="Close" BackColor="#669999" Font-Size="9pt" Paddings-PaddingLeft="2px" Paddings-PaddingRight="2px">
                                                                                                    <ClientSideEvents Click="function(s,e) { DropDownEdit.HideDropDown(); }" />
                                                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                                    <DisabledStyle BackColor="White"></DisabledStyle>

                                                                                                </dx:ASPxButton>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </div>
                                                                            </DropDownWindowTemplate>
                                                                            <DropDownWindowStyle HorizontalAlign="Left" VerticalAlign="NotSet"></DropDownWindowStyle>
                                                                        </dx:ASPxDropDownEdit>
                                                                    </dx:PanelContent>
                                                                </PanelCollection>
                                                            </dx:ASPxCallbackPanel>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                    <div class="col-x1">
                                                        <h6>
                                                            <asp:Label ID="Label32" runat="server" Text="<%$ Resources:ClasseContabil, classecontabil_right_lbl3 %>"></asp:Label></h6>
                                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('produto');">
                                                            <dx:ASPxComboBox ID="dropProdutoModalidade" ClientIDMode="Static" ClientInstanceName="dropProdutoModalidade" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2 drop-down" Theme="Material" Width="100%"
                                                                TextField="descr" ValueField="cod" DataSourceID="sqlDropProd">
                                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                </ButtonStyle>
                                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                <ClientSideEvents SelectedIndexChanged="function (s,e) {
                                                                    document.getElementById('hfDropProd').value = s.GetValue();
                                                                    gridModalidadesDisponiveis.Refresh();
                                                                    gridModalidadesAssociadas.Refresh();
                                                                    }" />
                                                            </dx:ASPxComboBox>
                                                            <asp:SqlDataSource runat="server" ID="sqlDropProd" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="SELECT PT.PRPRODID cod,PT.PRPRODES descr 
                                FROM PRPRODUT PT,CHCOMPOT CH 
                                WHERE PT.CMTPIDCM != 3 
                                AND PT.CHIDCODI = CH.CHIDCODI 
                                ORDER BY PT.PRPRODES"></asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                    <div class="col-x1">
                                                        <br />
                                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 10px">
                                                            <asp:TextBox ID="TextBox4" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                    <div class="col-x1">
                                                        <br />
                                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 10px">
                                                            <asp:TextBox ID="TextBox3" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-lg-5 card bg-transparent p-0">
                                                        <div class="card-header bg-transparent p-0">
                                                            <h6>
                                                                <asp:Label ID="Label29" runat="server" Text="Modalidades Associadas" CssClass=""></asp:Label></h6>
                                                        </div>
                                                        <div class="card-body bg-transparent p-0 pr-1" onmouseover="QuickGuide2('setup_menu3_lbl7_guide')">
                                                            <dx:ASPxGridView ID="gridModalidadesAssociadas" CssClass="mt-1" ClientInstanceName="gridModalidadesAssociadas" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                Width="100%" DataSourceID="sqlModalidadesAssociadas" KeyFieldName="VI.MOIDMODA" OnCustomButtonCallback="gridModalidadesAssociadas_CustomButtonCallback">
                                                                <ClientSideEvents EndCallback="function (s,e) { 
                                                                if(s.cp_ok=='OK'){
                                                                s.Refresh(); 
                                                                gridModalidadesDisponiveis.Refresh(); 
                                                                delete(s.cp_ok);
                                                                }

                                                                }" />
                                                                <SettingsPopup>
                                                                    <HeaderFilter MinHeight="140px">
                                                                    </HeaderFilter>
                                                                </SettingsPopup>
                                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                <SettingsPager Mode="ShowAllRecords">
                                                                </SettingsPager>
                                                                <SettingsCommandButton>
                                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                        </Image>
                                                                    </NewButton>
                                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                        </Image>
                                                                    </DeleteButton>
                                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                        </Image>
                                                                    </RecoverButton>
                                                                </SettingsCommandButton>
                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn FieldName="MOIDMODA" VisibleIndex="0" ReadOnly="True" Visible="false"></dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="MODSMODA" Caption="Modalidade" Width="100%" VisibleIndex="1" ReadOnly="True"></dx:GridViewDataTextColumn>
                                                                    <dx:GridViewCommandColumn VisibleIndex="2" Caption=" " Width="50px" ButtonRenderMode="Image">
                                                                        <CustomButtons>
                                                                            <dx:GridViewCommandColumnCustomButton ID="delete">
                                                                                <Image Url="~/img/right_arrow.png" ToolTip="Desassociar" Width="15px"></Image>
                                                                            </dx:GridViewCommandColumnCustomButton>
                                                                        </CustomButtons>
                                                                    </dx:GridViewCommandColumn>
                                                                </Columns>

                                                                <Styles>
                                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                    <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                    </Header>
                                                                    <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                    </Row>
                                                                    <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                    <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                        <Paddings Padding="0px" />
                                                                    </BatchEditCell>
                                                                    <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                    <Table></Table>
                                                                    <Cell Paddings-Padding="5px"></Cell>
                                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                </Styles>
                                                            </dx:ASPxGridView>
                                                            <asp:SqlDataSource runat="server" ID="sqlModalidadesAssociadas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select VI.MOIDMODA,concat(VI.MOIDMODA,'-',MO.MODSMODA) as MODSMODA from VIPROMOD VI, PRPRODUT PR, MODALIDA MO, TVESTRUT TV
WHERE VI.MOIDMODA=MO.MOIDMODA
  AND VI.PRPRODID=PR.prprodid
  AND VI.TVIDESTR=TV.TVIDESTR
  AND VI.TVIDESTR=? and PR.PRPRODID=? order by 2">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    <asp:ControlParameter ControlID="hfDropProd" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-7 card bg-transparent p-0">
                                                        <div class="card-header bg-transparent p-0">
                                                            <h6>
                                                                <asp:Label ID="Label30" runat="server" Text="Modalidades Disponíveis" CssClass=""></asp:Label></h6>
                                                        </div>
                                                        <div class="card-body bg-transparent p-0 pl-1" onmouseover="QuickGuide2('setup_menu3_lbl8_guide')">
                                                            <dx:ASPxGridView ID="gridModalidadesDisponiveis" CssClass="mt-1" ClientInstanceName="gridModalidadesDisponiveis" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                Width="100%" DataSourceID="sqlModalidadesDisponiveis" OnCustomButtonCallback="gridModalidadesDisponiveis_CustomButtonCallback" KeyFieldName="MOIDMODA" OnBatchUpdate="gridModalidadesDisponiveis_BatchUpdate">
                                                                <ClientSideEvents EndCallback="function (s,e) { 
                                                if(s.cp_ok=='OK'){
                                                s.Refresh(); 
                                                gridModalidadesAssociadas.Refresh(); 
                                                delete(s.cp_ok);
                                                }
                                                if(s.cp_msgErro)
                                                {
                                                    
                                                     delete(s.cp_msgErro);                   
                                                }
                                                }" />
                                                                <SettingsPopup>
                                                                    <HeaderFilter MinHeight="140px">
                                                                    </HeaderFilter>
                                                                </SettingsPopup>
                                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                                                <SettingsPager Mode="ShowAllRecords">
                                                                </SettingsPager>
                                                                <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-StartEditAction="Click"></SettingsEditing>
                                                                <SettingsCommandButton>
                                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                        </Image>
                                                                    </NewButton>
                                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                        </Image>
                                                                    </DeleteButton>
                                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                        </Image>
                                                                    </RecoverButton>
                                                                </SettingsCommandButton>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn ShowDeleteButton="true" ShowNewButtonInHeader="True" VisibleIndex="0" Width="50px" ButtonRenderMode="Image">
                                                                        <CustomButtons>
                                                                            <dx:GridViewCommandColumnCustomButton ID="assoc">
                                                                                <Image Url="~/img/left_arrow.png" ToolTip="Associar" Width="15px"></Image>
                                                                            </dx:GridViewCommandColumnCustomButton>
                                                                        </CustomButtons>

                                                                    </dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="MODSMODA" Caption="Modalidade" Width="100%" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataComboBoxColumn FieldName="MOTPIDCA" Width="100%" Caption="Tipo" VisibleIndex="2">
                                                                        <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlTipoModalidade" TextField="MOTPDSCA" ValueField="MOTPIDCA"></PropertiesComboBox>
                                                                    </dx:GridViewDataComboBoxColumn>

                                                                </Columns>

                                                                <Styles>

                                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                    <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                    </Header>
                                                                    <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                    </Row>
                                                                    <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                    <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                        <Paddings Padding="0px" />
                                                                    </BatchEditCell>
                                                                    <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                    <Table></Table>
                                                                    <Cell Paddings-Padding="5px"></Cell>
                                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                </Styles>
                                                            </dx:ASPxGridView>
                                                            <asp:SqlDataSource runat="server" ID="sqlModalidadesDisponiveis" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select MO.MOIDMODA,concat(MO.MOIDMODA,'-',MO.MODSMODA) as MODSMODA,MO.MOTPIDCA from MODALIDA MO
WHERE MO.MOIDMODA not in ( select moidmoda from VIPROMOD where TVIDESTR=? and prprodid=?) order by 2">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    <asp:ControlParameter ControlID="hfDropProd" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="vw_Eventos" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent pt-0 pb-0">
                                            <div class="card-header bg-transparent p-0">
                                                <div class="row d-flex">
                                                    <h4>
                                                        <asp:Label ID="Label37" runat="server" Text="<%$Resources:Setup, setup_menu6-5_lbl1 %>" CssClass=""></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent p-0">
                                                <div class="row pt-0">
                                                    <div class="col-x1">
                                                        <h6>
                                                            <asp:Label ID="Label38" runat="server" Text="Classe Produto"></asp:Label></h6>
                                                        <div class="input-group mb-auto drop-down-div">
                                                            <dx:ASPxComboBox ID="dropClasse" ClientIDMode="Static" ClientInstanceName="dropClasse" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2 drop-down" Theme="Material" Width="100%"
                                                                TextField="CMTPDSCM" ValueField="CMTPIDCM" DataSourceID="sqlDropClasse" AutoPostBack="true" OnSelectedIndexChanged="dropClasse_SelectedIndexChanged">
                                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                </ButtonStyle>
                                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            </dx:ASPxComboBox>
                                                            <asp:SqlDataSource runat="server" ID="sqlDropClasse" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select CMTPIDCM,CMTPDSCM from CMTPCMCL where PAIDPAIS=1 order by 2"></asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                    <div class="col-x1">
                                                        <h6>
                                                            <asp:Label ID="Label39" runat="server" Text="Classe Componente"></asp:Label></h6>
                                                        <div class="input-group mb-auto drop-down-div">
                                                            <dx:ASPxComboBox ID="dropClasseComp" ClientIDMode="Static" ClientInstanceName="dropClasseComp" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2 drop-down" Theme="Material" Width="100%"
                                                                TextField="cmdsclan" ValueField="cmidcodi" DataSourceID="sqlClasseComp">
                                                                <ClientSideEvents SelectedIndexChanged="function (s,e) {
                                                                    document.getElementById('hfCMIDCODI').value = s.GetValue();
                                                                    gridEventos.Refresh();
                                                                    gridEventos.PerformCallback();
                                                                    }" />
                                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                </ButtonStyle>
                                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            </dx:ASPxComboBox>
                                                            <asp:SqlDataSource runat="server" ID="sqlClasseComp" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                SelectCommand="select CMIDCODI,cmdsclan from CMCLACOM where CMTPIDCM=? order by 2">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfCMTPIDCM" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                    <div class="col-x0"></div>
                                                </div>
                                                <div class="row pt-0">
                                                    <dx:ASPxGridView ID="gridEventos" Enabled="false" ClientInstanceName="gridEventos" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False"
                                                        AutoGenerateColumns="False" SettingsResizing-ColumnResizeMode="NextColumn" DataSourceID="sqlEventos" KeyFieldName="CMIDCODI;CHTPIDEV;PAIDPAIS" OnRowUpdating="gridEventos_RowUpdating" OnRowInserting="gridEventos_RowInserting" OnRowDeleting="gridEventos_RowDeleting" OnLoad="gridEventos_Load">
                                                        <SettingsPopup>
                                                            <HeaderFilter MinHeight="140px">
                                                            </HeaderFilter>
                                                        </SettingsPopup>
                                                        <SettingsBehavior ConfirmDelete="true" />
                                                        <SettingsEditing Mode="EditForm"></SettingsEditing>
                                                        <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowEditButton="True" Width="70px" ShowDeleteButton="True" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CHTPIDEV" Width="100px" Caption="ID" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CHTPDSEV" Caption="Evento" VisibleIndex="3"></dx:GridViewDataTextColumn>
<dx:GridViewDataComboBoxColumn FieldName="PAIDPAIS" Caption="Pais" VisibleIndex="4">
                                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlPais" TextField="PANMPAIS" ValueField="PAIDPAIS"></PropertiesComboBox>
                                                            </dx:GridViewDataComboBoxColumn>
                                                        </Columns>
                                                        <SettingsCommandButton>
                                                            <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                </Image>
                                                            </NewButton>
                                                            <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                </Image>
                                                            </DeleteButton>
                                                            <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                </Image>
                                                            </RecoverButton>
                                                            <EditButton>
                                                                <Image ToolTip="Edit" Url="img/icons8-edit-80.png" Width="15px" />
                                                            </EditButton>
                                                            <UpdateButton RenderMode="Image">
                                                                <Image ToolTip="Save changes and close Edit Form" Url="img/ok.png" Width="50px" />
                                                            </UpdateButton>
                                                            <CancelButton RenderMode="Image">
                                                                <Image ToolTip="Close Edit Form without saving changes" Url="img/cancel.png" Width="50px" />
                                                            </CancelButton>
                                                        </SettingsCommandButton>
                                                        <Columns>
                                                        </Columns>
                                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                                        </SettingsPager>
                                                        <Styles>
                                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                            <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                            </Header>
                                                            <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                            </Row>
                                                            <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                            <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                <Paddings Padding="0px" />
                                                            </BatchEditCell>
                                                            <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                            <EditForm Paddings-Padding="0px"></EditForm>
                                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                            <Table></Table>
                                                            <Cell Paddings-Padding="5px"></Cell>
                                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                        </Styles>
                                                    </dx:ASPxGridView>
                                                    <asp:SqlDataSource runat="server" ID="sqlEventos" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select CMIDCODI,CHTPIDEV,CHTPDSEV,PAIDPAIS from CMTPEVEN where CMIDCODI=? order by 2">
                                                        <SelectParameters>
                                                            <asp:ControlParameter ControlID="hfCMIDCODI" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="vw_Mercado" runat="server">
                            <div class="container-fluid">
                                <div class="row pt-2">
                                    <div class="col-12 p-0">
                                        <div class="card bg-transparent pt-0 pb-0">
                                            <div class="card-header bg-transparent p-0">
                                                <div class="row d-flex">
                                                    <h4>
                                                        <asp:Label ID="Label40" runat="server" Text="Mercado Financeiro" CssClass=""></asp:Label></h4>
                                                </div>
                                            </div>
                                            <div class="card-body bg-transparent p-0">                                                
                                                <div class="row pt-0">
                                                    <dx:ASPxGridView ID="gridMercado" ClientInstanceName="gridMercado" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False"
                                                        AutoGenerateColumns="False" SettingsResizing-ColumnResizeMode="NextColumn" DataSourceID="sqlMercado" KeyFieldName="VIIDINDE" OnRowUpdating="gridMercado_RowUpdating" OnRowInserting="gridMercado_RowInserting" OnRowDeleting="gridMercado_RowDeleting" OnLoad="gridMercado_Load">
                                                        <SettingsPopup>
                                                            <HeaderFilter MinHeight="140px">
                                                            </HeaderFilter>
                                                        </SettingsPopup>
                                                        <SettingsBehavior ConfirmDelete="true" />
                                                        <SettingsEditing Mode="EditForm"></SettingsEditing>
                                                        <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowEditButton="True" Width="50px" VisibleIndex="0" ShowDeleteButton="True" ShowNewButtonInHeader="True" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                                            <dx:GridViewDataComboBoxColumn FieldName="TVIDESTR" Caption="Empresa" VisibleIndex="1">
                                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlEmpresasMerc" TextField="TVDSESTR" ValueField="TVIDESTR"></PropertiesComboBox>
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataComboBoxColumn FieldName="IEIDINEC" Caption="Indexador" VisibleIndex="2">
                                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlIndexMerc" TextField="IENMINEC" ValueField="IEIDINEC"></PropertiesComboBox>
                                                            </dx:GridViewDataComboBoxColumn>
                                                        </Columns>
                                                        <SettingsCommandButton>
                                                            <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                                <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                                </Image>
                                                            </NewButton>
                                                            <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                                <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                                </Image>
                                                            </DeleteButton>
                                                            <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                                <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                                </Image>
                                                            </RecoverButton>
                                                            <EditButton>
                                                                <Image ToolTip="Edit" Url="img/icons8-edit-80.png" Width="15px" />
                                                            </EditButton>
                                                            <UpdateButton RenderMode="Image">
                                                                <Image ToolTip="Save changes and close Edit Form" Url="img/ok.png" Width="50px" />
                                                            </UpdateButton>
                                                            <CancelButton RenderMode="Image">
                                                                <Image ToolTip="Close Edit Form without saving changes" Url="img/cancel.png" Width="50px" />
                                                            </CancelButton>
                                                        </SettingsCommandButton>
                                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                                        </SettingsPager>
                                                        <Styles>
                                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                            <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                            </Header>
                                                            <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                            </Row>
                                                            <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                            <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                                                <Paddings Padding="0px" />
                                                            </BatchEditCell>
                                                            <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                            <EditForm Paddings-Padding="0px"></EditForm>
                                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                            <Table></Table>
                                                            <Cell Paddings-Padding="5px"></Cell>
                                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                        </Styles>
                                                    </dx:ASPxGridView>
                                                    <asp:SqlDataSource runat="server" ID="sqlMercado" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select VIIDINDE,TVIDESTR,IEIDINEC from VIEMPIND order by 2,3">
                                                    </asp:SqlDataSource>
                                                    <asp:SqlDataSource runat="server" ID="sqlIndexMerc" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT IEIDINEC,IENMINEC FROM IEINDECO ORDER BY 2">
                                                    </asp:SqlDataSource>
                                                    <asp:SqlDataSource runat="server" ID="sqlEmpresasMerc" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select TVIDESTR,TVDSESTR from TVESTRUT ORDER BY 2">
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                    </asp:MultiView>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="sqlTipoAlimentacao" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT CJTPCAID,CJTPCADS  FROM CJTPCAAU where PAIDPAIS=1 order by 2"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlTipoCJCLPROP" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT CJTPIDTP,CJTPDSTP from CJTPTIPO where PAIDPAIS=1 order by 1"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlModalidade" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select MO.MOIDMODA,MO.MODSMODA from MODALIDA MO order by 2"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlTipoModalidade" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT MOTPIDCA,MOTPDSCA FROM MOTPCARA where PAIDPAIS=1 order by 2"></asp:SqlDataSource>
    <dx:ASPxPopupControl ID="popupControle" Width="1200px" Height="750px" runat="server"
        PopupHorizontalAlign="WindowCenter" ShowHeader="false" HeaderText="" PopupVerticalAlign="WindowCenter"
        AllowResize="true" CloseAction="OuterMouseClick" CssClass="rounding" ShowCloseButton="true" CloseOnEscape="false" PopupAnimationType="Fade"
        Modal="true" ScrollBars="Auto" RenderIFrameForPopupElements="True">
        <ClientSideEvents Shown="function(s,e){
                        log = document.getElementById('lblquickGuide2');
            log2 = document.getElementById('lblquickGuide3');
            }"
            Init="function(s,e){
                        log = document.getElementById('lblquickGuide2');
            log2 = document.getElementById('lblquickGuide3');
            }" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <asp:MultiView ID="mvQueryBuilder" runat="server">
                    <asp:View ID="viewQueryBuilderInsert" runat="server">
                        <div class="card">
                            <div class="card-header p-0">
                                <div class="row p-0">
                                    <div class="col-x1 pl-3" onmouseover="QuickGuide('relatorio_nome')">
                                        <asp:Label ID="lblEstCorpo" runat="server" Text="<%$Resources:Setup, relatorio_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto">
                                            <dx:ASPxTextBox ID="txtNomeRelat" ClientInstanceName="txtNomeRelat" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" ErrorFrameStyle-ForeColor="Red"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                        </div>
                                    </div><div class="col-x0 p-0"></div>
                                    <div class="col-x1 p-0" >
                                        <asp:Label ID="Label41" runat="server" Text="Título Cabeçalho" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto">
                                            <dx:ASPxTextBox ID="txtTituloRelat" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" ErrorFrameStyle-ForeColor="Red"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                        </div>
                                    </div><div class="col-x0 p-0"></div>
                                    <div class="col-x1 p-0" >
                                        <asp:Label ID="Label42" runat="server" Text="SubTítulo Cabeçalho" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto">
                                            <dx:ASPxTextBox ID="txtTituloRelat2" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" ErrorFrameStyle-ForeColor="Red"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                        </div>
                                    </div><div class="col-x0 p-0"></div>
                                </div>
                                <div class="row" onmouseover="QuickGuide('relatorio_tipo')">
                                    <div class="col-lg-12">
                                        <dx:ASPxRadioButtonList ID="listTipoQuery" ClientInstanceName="listTipoQuery" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="Moderno" runat="server" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default" ValueField="TPIDVIEW" ValueType="System.Int32" TextField="TPNMVIEW" DataSourceID="sqlTipoView">
                                        </dx:ASPxRadioButtonList>
                                        <asp:SqlDataSource runat="server" ID="sqlTipoView" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' 
SelectCommand="SELECT TPIDVIEW,TPNMVIEW FROM TPTPVIEW where paidpais=? ORDER BY 2">
  <SelectParameters>
    <asp:SessionParameter Name="?" SessionField="LandID"
      DefaultValue="1" />
  </SelectParameters>
</asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="container-fluid">
                                    <div class="row ml-0 mr-0 mt-0 w-100">
                                        <div class="col-sm-2">
                                            <div class="container-fluid">
                                                <div class="row mt-2">
                                                    <div class="col-12 text-left p-0">
                                                        <div class="card pr-2 pl-2 quickGuide">
                                                            <div class="card-header quickGuide-header">
                                                                <label>Quick Guide</label>
                                                            </div>
                                                            <div class="card-body p-0 pt-2 quickGuide-body">
                                                                <asp:Label ID="lblquickGuide2" ClientIDMode="Static" runat="server"><%=Resources.Setup.relatorio_guide_ini %></asp:Label>
                                                            </div>
                                                            <div class="card-footer bg-transparent quickGuide-footer">
                                                                <asp:HiddenField ID="HiddenField1" ClientIDMode="Static" runat="server" Value="<%$Resources:Setup, relatorio_content_tutorial %>" />
                                                                <dx:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" CssClass="btn-saiba-mais" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_readmore %>">
                                                                    <ClientSideEvents Click="function (s,e){
                                            popupSaibaMais.RefreshContentUrl();
                                            popupSaibaMais.SetContentUrl(document.getElementById('HiddenField1').value);
                                            setTimeout('popupSaibaMais.Show();', 500);
                                            }" />
                                                                </dx:ASPxButton>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-sm-10 pl-4 pr-0" onmouseover="QuickGuide('relatorio_query')">
                                            <div class="row">

                                                <dx:ASPxQueryBuilder ID="queryBuilder" ClientInstanceName="queryBuilder" runat="server"
                                                    OnSaveQuery="queryBuilder_SaveQuery" Width="1150px" Height="550px"
                                                    ClientSideEvents-Init="queryBuilder_Initialize"
                                                    ClientSideEvents-CustomizeToolbarActions="queryBuilder_CustomizeMenuActions"
                                                    ParametersMode="ReadWrite" DisableHttpHandlerValidation="False" HandlerUri="DXQB.axd">
                                                    <ClientSideEvents CustomizeToolbarActions="queryBuilder_CustomizeMenuActions" Init="function (s, e) {
            var queryNameInfo = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (item) {
                return item.displayName === &quot;Name&quot;;
            })[0];
            queryNameInfo.validationRules = [{
                type: &#39;custom&#39;,
                validationCallback: function (options) {
                    var queryName = options.value;
                    if (!isQueryNameValid(queryName)) {
                        options.rule.message = &quot;Query name is invalid!&quot;;
                    }
                    return isQueryNameValid(queryName);
                }
            }];
            var filterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === &quot;filterString&quot;; })[0];
            filterStringProperty.visible = true;
            var groupFilterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === &quot;groupFilterString&quot;; })[0];
            groupFilterStringProperty.visible = false;
            s.GetQueryBuilderModel().model.valueHasMutated();
        }"></ClientSideEvents>

                                                </dx:ASPxQueryBuilder>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:View>
                    <asp:View ID="viewQueryBuilderAlterar" runat="server">
                        <div class="card">
                            <div class="card-header">
                                <div class="row p-0">
                                    <div class="col-x1 pl-3" onmouseover="QuickGuide('relatorio_nome')">
                                        <asp:Label ID="Label43" runat="server" Text="<%$Resources:Setup, relatorio_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto">
                                            <dx:ASPxTextBox ID="txtNomeRelat2" ClientInstanceName="txtNomeRelat2" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" ErrorFrameStyle-ForeColor="Red"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                        </div>
                                    </div><div class="col-x0 p-0"></div>
                                    <div class="col-x1 p-0" >
                                        <asp:Label ID="Label44" runat="server" Text="Título Cabeçalho" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto">
                                            <dx:ASPxTextBox ID="txtTituloRelatorio1" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" ErrorFrameStyle-ForeColor="Red"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                        </div>
                                    </div><div class="col-x0 p-0"></div>
                                    <div class="col-x1 p-0" >
                                        <asp:Label ID="Label45" runat="server" Text="SubTítulo Cabeçalho" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto">
                                            <dx:ASPxTextBox ID="txtTituloRelatorio2" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" ErrorFrameStyle-ForeColor="Red"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                        </div>
                                    </div><div class="col-x0 p-0"></div>
                                </div>
                                <div class="row" onmouseover="QuickGuide('relatorio_tipo')">
                                    <div class="col-lg-12">
                                        <dx:ASPxRadioButtonList ID="listTipoQuery2" ClientInstanceName="listTipoQuery2" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="Moderno" runat="server" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default" ValueField="TPIDVIEW" ValueType="System.Int32" TextField="TPNMVIEW" DataSourceID="SqlDataSource2">
                                        </dx:ASPxRadioButtonList>
                                        <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' 
SelectCommand="SELECT TPIDVIEW,TPNMVIEW FROM TPTPVIEW where paidpais=? ORDER BY 2">
  <SelectParameters>
    <asp:SessionParameter Name="?" SessionField="LandID"
      DefaultValue="1" />
  </SelectParameters></asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="container-fluid">
                                    <div class="row ml-0 mr-0 mt-0 w-100">
                                        <div class="col-sm-2">
                                            <div class="container-fluid">
                                                <div class="row mt-2">
                                                    <div class="col-12 text-left p-0">
                                                        <div class="card pr-2 pl-2 quickGuide">
                                                            <div class="card-header quickGuide-header">
                                                                <label>Quick Guide</label>
                                                            </div>
                                                            <div class="card-body p-0 pt-2 quickGuide-body">
                                                                <asp:Label ID="lblquickGuide3" ClientIDMode="Static" runat="server"><%=Resources.Setup.relatorio_guide_ini %></asp:Label>
                                                            </div>
                                                            <div class="card-footer bg-transparent quickGuide-footer">
                                                                <asp:HiddenField ID="HiddenField2" ClientIDMode="Static" runat="server" Value="<%$Resources:Setup, relatorio_content_tutorial %>" />
                                                                <dx:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="false" CssClass="btn-saiba-mais" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_readmore %>">
                                                                    <ClientSideEvents Click="function (s,e){
                                            popupSaibaMais.RefreshContentUrl();
                                            popupSaibaMais.SetContentUrl(document.getElementById('HiddenField2').value);
                                            setTimeout('popupSaibaMais.Show();', 500);
                                            }" />
                                                                </dx:ASPxButton>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-sm-10 pl-4 pr-0" onmouseover="QuickGuide('relatorio_query')">
                                            <div class="row">
                                                <dx:ASPxQueryBuilder ID="queryBuilder2" ClientInstanceName="queryBuilder2" runat="server"
                                                    OnSaveQuery="queryBuilder2_SaveQuery" Width="1150px" Height="550px"
                                                    ClientSideEvents-Init="queryBuilder2_Initialize"
                                                    ClientSideEvents-CustomizeToolbarActions="queryBuilder2_CustomizeMenuActions"
                                                    ParametersMode="ReadWrite" DisableHttpHandlerValidation="False" HandlerUri="DXQB.axd">
                                                    <ClientSideEvents CustomizeToolbarActions="queryBuilder2_CustomizeMenuActions" Init="function (s, e) {
            var queryNameInfo = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (item) {
                return item.displayName === &quot;Name&quot;;
            })[0];
            queryNameInfo.validationRules = [{
                type: &#39;custom&#39;,
                validationCallback: function (options) {
                    var queryName = options.value;
                    if (!isQueryNameValid(queryName)) {
                        options.rule.message = &quot;Query name is invalid!&quot;;
                    }
                    return isQueryNameValid(queryName);
                }
            }];
            var filterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === &quot;filterString&quot;; })[0];
            filterStringProperty.visible = true;
            var groupFilterStringProperty = DevExpress.QueryBuilder.Elements.Metadata.querySerializationsInfo.filter(function (p) { return p.propertyName === &quot;groupFilterString&quot;; })[0];
            groupFilterStringProperty.visible = false;
            s.GetQueryBuilderModel().model.valueHasMutated();
        }"></ClientSideEvents>
                                                </dx:ASPxQueryBuilder>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:View>
                </asp:MultiView>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <script type="text/javascript">
        function QuickGuide(guide) {
            switch (guide) {
                case 'relatorio_nome':
                    if (log != null)
                        log.innerHTML = '<%= Resources.Setup.relatorio_nome_guide%>';
                    if (log2 != null)
                        log2.innerHTML = '<%= Resources.Setup.relatorio_nome_guide%>';
                    break;
                case 'relatorio_tipo':
                    if (log != null)
                        log.innerHTML = '<%= Resources.Setup.relatorio_tipo_guide%>';
                    if (log2 != null)
                        log2.innerHTML = '<%= Resources.Setup.relatorio_tipo_guide%>';
                    break;
                case 'relatorio_query':
                    if (log != null)
                        log.innerHTML = '<%= Resources.Setup.relatorio_query_guide%>';
                    if (log2 != null)
                        log2.innerHTML = '<%= Resources.Setup.relatorio_query_guide%>';
                    break;
            }
        }
    </script>
</asp:Content>

