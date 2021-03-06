<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClasseContabil.aspx.cs" Inherits="WebNesta_IRFS_16.ClasseContabil" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var startIndex = 0;
        function DataCallback(result) {
            var results = result.split("#");
            gridContas.batchEditApi.EndEdit();
            gridContas.batchEditApi.SetCellValue(startIndex, results[0].toString(), results[1]);
            var keyIndex = gridContas.GetColumnByField(results[0].toString()).index;
            gridContas.batchEditApi.StartEdit(startIndex, keyIndex);
        }
        function onStartEditing(s, e) {
            startIndex = e.visibleIndex;
        }
        var valuesArray = new Array();
        var currentColumn = null;
        function OnBeginCallback(s, e) {
            if (e.command == "UPDATEEDIT")
                hf.Set("modifiedValues", valuesArray);
        }
        function OnStartEditing(s, e) {
            currentColumn = e.focusedColumn;
        }
        function OnEndCallback(s, e) {
            hf.Set("modifiedValues", new Array());
        }
        function OnEndEditing(s, e) {

            var productNameColumn = s.GetColumnByField("ID");
            if (!e.rowValues.hasOwnProperty(productNameColumn.index) || currentColumn.fieldName != "ID") {
                currentColumn = null;
                return;
            }
            var cellInfo = e.rowValues[productNameColumn.index];
            var matchFlag = false;
            for (var i = valuesArray.length - 1; i > -1; i--) {
                if (valuesArray[i].key == s.GetRowKey(e.visibleIndex)) {
                    valuesArray[i].fieldValue = cellInfo.value;
                    matchFlag = true;
                    break;
                }
            }
            if (!matchFlag)
                valuesArray.push({ key: s.GetRowKey(e.visibleIndex), fieldValue: cellInfo.value });

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
            dropProduto.SetText('');
            DropDownEdit.SetText(text);
            DropDownEdit.SetKeyValue(key);
            DropDownEdit.HideDropDown();
            UpdateButtons();
        }
        function UpdateButtons() {
            dropProduto.SetEnabled(document.getElementById('hfDropEstr').value != "");
            clearButton.SetEnabled(DropDownEdit.GetText() != "");
            selectButton.SetEnabled(TreeList.GetFocusedNodeKey() != "");
        }
        function OnDropDown() {
            TreeList.SetFocusedNodeKey(DropDownEdit.GetKeyValue());
            TreeList.MakeNodeVisible(TreeList.GetFocusedNodeKey());
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.ClasseContabil.classecontabil_quickguide_ini %>';
                    break;
                case 'selecione':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.ClasseContabil.classecontabil_quickguide_selecione %>';
                    break;
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.ClasseContabil.classecontabil_quickguide_titulo %>';
                    break;
                case 'lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.ClasseContabil.classecontabil_quickguide_lbl1 %>';
                    break;
                case 'acao':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.ClasseContabil.classecontabil_quickguide_acao %>';
                    break;
                case 'produto':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.ClasseContabil.classecontabil_quickguide_produto %>';
                    break;
                case 'grid':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.ClasseContabil.classecontabil_quickguide_grid %>';
                    break;
                case 'inserir2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_inserir2_qg %>';
                    break;
                case 'excluir2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_excluir2_qg %>';
                    break;
                case 'ok2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_ok2_qg %>';
                    break;
                case 'cancelar2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_cancelar2_qg %>';
                    break;
            }

        }
    </script>
    <asp:HiddenField ID="hfPRPRODID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfPFIDDEBI" runat="server" />
    <asp:HiddenField ID="hfPFIDCRED" runat="server" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfTituloPag" Value="Classe Contabil" runat="server" />
    <div class="container-fluid">
        <div class="row ml-0 mr-0 mt-0 w-100">
            <div class="col-sm-2 pl-1">
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:ClasseContabil, classecontabil_content_tutorial %>" />
                                    <dx:ASPxButton ID="btnAjuda" runat="server" AutoPostBack="false" CssClass="btn-saiba-mais" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_readmore %>">
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
                <div class="row w-100 m-0">
                    <div class="card w-100 bg-transparent">
                        <div class="card-header bg-transparent">
                            <h4>
                                <asp:Label ID="Label1" runat="server" onmouseover="QuickGuide('titulo');" Text="<%$ Resources:ClasseContabil, classecontabil_tituloPag %>" CssClass="labels text-left"></asp:Label></h4>
                        </div>
                        <div class="card-body pt-0 bg-transparent">
                            <div class="row w-100 mb-0 pl-3">
                                <div class="col-lg-12" style="margin: 0 auto">
                                    <div class="row">
                                        <div class="col-x1 p-0" onmouseover="QuickGuide('lbl1');">
                                            <asp:Label ID="Label2" runat="server" CssClass="labels text-left" Text="<%$ Resources:ClasseContabil, classecontabil_label_1 %>"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px;">
                                                <asp:TextBox ID="txtDescri" Width="100%" runat="server" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0">
                                        </div>
                                        <div class="p-0 col-x1">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                <asp:TextBox ID="TextBox1" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0">
                                        </div>
                                        <div class="p-0 col-x1">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                <asp:TextBox ID="TextBox2" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0">
                                        </div>
                                        <div class="p-0 col-x1">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                <asp:TextBox ID="TextBox3" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-1 " style="margin: 0 auto">
                                <div class="col-lg-12 p-0" onmouseover="QuickGuide('grid');" style="margin: 0 auto">
                                    <dx:ASPxHiddenField runat="server" ID="hf" ClientInstanceName="hf"></dx:ASPxHiddenField>
                                    <dx:ASPxGridView ID="gridContas" ClientInstanceName="gridContas" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static" Width="100%" KeyFieldName="ID;PRPRODID;TVIDESTR" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False"
                                        OnCustomDataCallback="gridContas_CustomDataCallback" OnRowValidating="gridContas_RowValidating" OnBatchUpdate="gridContas_BatchUpdate" AutoGenerateColumns="False" DataSourceID="sqlGridContas">
                                        <ClientSideEvents EndCallback="OnEndCallback" BeginCallback="OnBeginCallback"
                                            BatchEditStartEditing="function onStartEditing(s, e) {
                                                startIndex = e.visibleIndex;
                                                OnStartEditing(s,e);
                                            }"
                                            BatchEditEndEditing="OnEndEditing" />
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsResizing ColumnResizeMode="NextColumn" Visualization="Live" />
                                        <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                        <SettingsText Title="<%$ Resources:ClasseContabil, classecontabil_label_2 %>" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Columns>
                                            <dx:GridViewCommandColumn Name="CommandColumn" Visible="false" ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="ID" Caption="<%$ Resources:ClasseContabil, classecontabil_grid_col1 %>" VisibleIndex="1">
                                                <PropertiesComboBox ValidationSettings-RequiredField-IsRequired="true" DataSourceID="sqlMODALIDADE" TextField="MODSMODA" ValueField="MOIDMODA">
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="CDCRED" EditFormSettings-Visible="True" Caption="<%$ Resources:ClasseContabil, classecontabil_grid_col2 %>" VisibleIndex="2">
                                                <PropertiesComboBox DataSourceID="sqlCredDebit" ValidationSettings-RequiredField-IsRequired="true" TextField="pfcdplnc" ValueField="pfidplnc">
                                                    <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            var newValueOfComboBox = 'CDCRED#'+s.GetValue();                                    
            gridContas.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="DSCRED" EditFormSettings-Visible="True" Caption="<%$ Resources:ClasseContabil, classecontabil_grid_col3 %>" VisibleIndex="3">
                                                <PropertiesComboBox DataSourceID="sqlCredDebit" TextField="pfdsplnc" ValueField="pfidplnc">
                                                    <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            var newValueOfComboBox = 'DSCRED#'+s.GetValue();                                    
            gridContas.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                    <ValidationSettings>
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="CDDEBI" EditFormSettings-Visible="True" Caption="<%$ Resources:ClasseContabil, classecontabil_grid_col4 %>" VisibleIndex="4">
                                                <PropertiesComboBox DataSourceID="sqlCredDebit" ValidationSettings-RequiredField-IsRequired="true" TextField="pfcdplnc" ValueField="pfidplnc">
                                                    <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            var newValueOfComboBox = 'CDDEBI#'+s.GetValue();                                    
            gridContas.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="DSDEBI" EditFormSettings-Visible="True" Caption="<%$ Resources:ClasseContabil, classecontabil_grid_col5 %>" VisibleIndex="5">
                                                <PropertiesComboBox DataSourceID="sqlCredDebit" TextField="pfdsplnc" ValueField="pfidplnc">
                                                    <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            var newValueOfComboBox = 'DSDEBI#'+s.GetValue();                                    
            gridContas.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                    <ValidationSettings>
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>

                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                        </SettingsPager>
                                        <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="true" />
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                            <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            </Row>
                                            <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                            <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                <Paddings Padding="0px" />
                                            </BatchEditCell>
                                            <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource runat="server" ID="sqlGridContas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select MOIDMODA as ID,PFIDCRED as CDCRED, PFIDCRED as DSCRED, PFIDDEBI as CDDEBI, PFIDDEBI as DSDEBI,PRPRODID,V.TVIDESTR
from VIPRESCT V  where (V.TVIDESTR=? or V.TVIDESTR=1) AND PRPRODID=?"
                                        UpdateCommand="UPDATE VIPRESCT SET PFIDDEBI=?,PFIDCRED=? WHERE TVIDESTR=? and PRPRODID =? and MOIDMODA=?"
                                        InsertCommand="INSERT INTO VIPRESCT (TVIDESTR,PRPRODID,MOIDMODA,PFIDCRED,PFIDDEBI) VALUES (?,?,?,?,?)">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            <asp:ControlParameter ControlID="hfPRPRODID" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                        <UpdateParameters>
                                            <asp:Parameter Name="CDDEBI" Type="String" />
                                            <asp:Parameter Name="CDCRED" Type="String" />
                                            <asp:ControlParameter ControlID="hfDropEstr" Name="TVIDESTR" PropertyName="Value" Type="String"></asp:ControlParameter>
                                            <asp:ControlParameter ControlID="hfPRPRODID" Name="PRPRODID" PropertyName="Value" Type="String" />
                                            <asp:Parameter Name="ID" Type="String" />
                                        </UpdateParameters>
                                        <InsertParameters>
                                            <asp:ControlParameter ControlID="hfDropEstr" Name="TVIDESTR" PropertyName="Value" Type="String"></asp:ControlParameter>
                                            <asp:ControlParameter ControlID="hfPRPRODID" Name="PRPRODID" PropertyName="Value" Type="String" />
                                            <asp:Parameter Name="ID" Type="String" />
                                            <asp:Parameter Name="CDCRED" Type="String" />
                                            <asp:Parameter Name="CDDEBI" Type="String" />
                                        </InsertParameters>
                                    </asp:SqlDataSource>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <asp:SqlDataSource ID="sqlMODALIDADE" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="SELECT MO.MOIDMODA, concat(MO.MOIDMODA,'-',MO.MODSMODA) MODSMODA FROM MODALIDA MO, VIPROMOD VI
WHERE MO.MOIDMODA = VI.MOIDMODA AND VI.PRPRODID = ? and mo.MOTPIDCA not in (2,5)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfPRPRODID" PropertyName="Value" Name="?"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="sqlCredDebit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="WITH n(tvidestr) AS 
   (SELECT tvidestr
    FROM tvestrut
    WHERE (tvidestr = ? or tvidestr = 1)
        UNION ALL
    SELECT nplus1.tvidestr
    FROM tvestrut as nplus1, n
    WHERE n.tvidestr = nplus1.tvcdpaie)
	select pfidplnc,pfdsplnc,pfcdplnc from PFPLNCTA P, n
where n.tvidestr=P.TVIDESTR">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="sqlMODALIDA" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" 
                    SelectCommand="SELECT MO.MOIDMODA, MO.MODSMODA FROM MODALIDA MO, VIPROMOD VI
WHERE MO.MOIDMODA=VI.MOIDMODA AND VI.PRPRODID=? AND VI.TVIDESTR=1">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfPRPRODID" Name="PRPRODID" PropertyName="Value" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>

            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" Text="<%$ Resources:ClasseContabil, classecontabil_right_lbl1 %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:ClasseContabil, classecontabil_right_lbl2 %>" onmouseover="QuickGuide('selecione');"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div">
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT B.TVIDESTR, B.TVDSESTR, B.TVCDPAIE, B.TVNVESTR,
                                   A.FOCDXCGC, A.FOCDLICE
                            FROM TVESTRUT B, FOFORNEC A
                            WHERE B.TVIDESTR = A.TVIDESTR
                            AND A.FOTPIDTP = 6
                            AND A.FOCDLICE IS NOT NULL
                            AND B.TVIDESTR IN(SELECT DISTINCT TVIDESTR 
                                               FROM VIFSFUSU 
                                               WHERE USIDUSUA = ?)
ORDER BY B.TVNVESTR, B.TVCDPAIE, B.TVIDESTR">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
                <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" runat="server" Width="350px">
                    <PanelCollection>
                        <dx:PanelContent>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator19" ValidationGroup="InsertReq" ControlToValidate="ddeEstruturaInsert" runat="server" ForeColor="Red" Display="None" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl1 %>"></asp:RequiredFieldValidator>
                            <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass="dropDownEdit" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
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
                                        <dx:ASPxTreeList ID="TreeList" DataSourceID="SqlDataSource1" ClientInstanceName="TreeList" runat="server"
                                            Width="350px" CssClass="text-left" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                            KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE">
                                            <Settings ShowHeaderFilterButton="true" VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                            <ClientSideEvents FocusedNodeChanged="function(s,e){ selectButton.SetEnabled(true); }" />
                                            <BorderBottom BorderStyle="Solid" />
                                            <SettingsBehavior AllowFocusedNode="true" AutoExpandAllNodes="false" FocusNodeOnLoad="false" />
                                            <SettingsPager Mode="ShowAllNodes">
                                            </SettingsPager>
                                            <Images>
                                                <ExpandedButton Url="icons/icons8-seta-para-recolher-30.png" Width="25px"></ExpandedButton>
                                                <CollapsedButton Url="icons/icons8-seta-para-expandir-30.png" Width="25px"></CollapsedButton>
                                            </Images>
                                            <Styles>
                                                <SelectedNode BackColor="#669999"></SelectedNode>
                                                <FocusedNode BackColor="#669999"></FocusedNode>
                                                <Header Paddings-PaddingBottom="4px" Paddings-PaddingTop="4px"></Header>
                                                <Node Cursor="pointer">
                                                </Node>
                                                <Indent Cursor="default">
                                                </Indent>
                                            </Styles>
                                            <Columns>
                                                <dx:TreeListTextColumn FieldName="TVDSESTR" Caption="<%$ Resources:GlobalResource, geral_selecione_loja_header %>" AutoFilterCondition="Default" ShowInFilterControl="Default" VisibleIndex="0"></dx:TreeListTextColumn>
                                            </Columns>
                                        </dx:ASPxTreeList>
                                    </div>
                                    <table style="background-color: White; width: 100%;">
                                        <tr>
                                            <td style="padding: 10px;">
                                                <dx:ASPxButton ID="clearButton" ClientEnabled="false" Theme="Material" ClientInstanceName="clearButton"
                                                    runat="server" AutoPostBack="false" Text="<%$ Resources:GlobalResource, btn_selecione_loja_limpar %>" BackColor="#669999">
                                                    <ClientSideEvents Click="ClearSelection" />
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </td>
                                            <td style="text-align: right; padding: 10px;">
                                                <dx:ASPxButton ID="selectButton" ClientEnabled="false" Theme="Material" ClientInstanceName="selectButton"
                                                    runat="server" AutoPostBack="false" Text="<%$ Resources:GlobalResource, btn_selecione_loja_selecione %>" BackColor="#669999">
                                                    <ClientSideEvents Click=" function (s,e) { 
                                                            UpdateSelection(); } " />
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" 
                                                    Text="<%$ Resources:GlobalResource, btn_selecione_loja_fechar %>" BackColor="#669999">
                                                    <ClientSideEvents Click="function(s,e) { DropDownEdit.HideDropDown(); }" />
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </DropDownWindowTemplate>
                            </dx:ASPxDropDownEdit>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:ClasseContabil, classecontabil_right_lbl3 %>"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('produto');">
                <dx:ASPxComboBox ID="dropProduto" ClientIDMode="Static" ClientInstanceName="dropProduto" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" AutoPostBack="true" OnSelectedIndexChanged="dropProduto_SelectedIndexChanged1" Theme="Material" Width="100%" TextField="descr" ValueField="cod" DataSourceID="sqlDropProd">
                    <ClientSideEvents SelectedIndexChanged="function(s, e){document.getElementById('hfPRPRODID').value=s.GetValue();}" />
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
                <asp:SqlDataSource runat="server" ID="sqlDropProd" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT PT.PRPRODID cod,PT.PRPRODES descr 
                                FROM PRPRODUT PT,CHCOMPOT CH 
                                WHERE PT.CMTPIDCM != 3 
                                AND PT.CHIDCODI = CH.CHIDCODI 
                                ORDER BY PT.PRPRODES"></asp:SqlDataSource>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto;">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir2');">
                <dx:ASPxButton ID="btnInserir" Enabled="false" runat="server" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>">
                    <ClientSideEvents Click="function(s, e){gridContas.AddNewRow();}" />
                </dx:ASPxButton>
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir2');">
                <asp:Button ID="btnexcluir" Enabled="false" runat="server" CssClass="Loading btn-using" OnClick="btnexcluir_Click" Text="<%$ Resources:GlobalResource, btn_excluir %>" />
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok2');">
                <asp:Button ID="btnOK" Enabled="false" runat="server" CssClass="Loading btn-using ok" OnClick="btnOK_Click" Text="<%$ Resources:GlobalResource, btn_ok %>" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar2');">
                <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="Loading btn-using cancelar" OnClick="btnCancelar_Click" Text="<%$ Resources:GlobalResource, btn_cancelar %>" CausesValidation="false" />
            </div>
        </div>
    </div>
</asp:Content>
