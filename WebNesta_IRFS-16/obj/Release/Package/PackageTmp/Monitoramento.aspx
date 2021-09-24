<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Monitoramento.aspx.cs" Inherits="WebNesta_IRFS_16.Monitoramento" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function UpdateInfo() {
            var daysTotal = txtDtFinal.GetRangeDayCount();
            txtQtdDias.SetText(daysTotal !== -1 ? daysTotal : '');
        }
        function ClearSelection() {
            TreeList.SetFocusedNodeKey("");
            UpdateControls(null, "");
            document.getElementById('hfDropEstr').value = "";
            document.getElementById('hfDropEstr2').value = "";
        }
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropEstr').value = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropEstr2').value = TreeList.GetFocusedNodeKey();
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

        function OnAllCheckedChanged(s, e) {
            document.getElementById('hfAllRows').value = s.GetChecked();
            gridMonit.PerformCallback("AllROws");
        }
    </script>
        <script type="text/javascript">  
            function QuickGuide(guide) {
                switch (guide) {
                case 'lbl2':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_lbl2_guide%>';
                    break;
                case 'lbl3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_lbl3_guide%>';
                    break;
                case 'lbl4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_lbl4_guide%>';
                        break;
                    case 'lbl5':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_lbl5_guide%>';
                        break;
                    case 'btn1':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_right_btn1_guide%>';
                        break;
                    case 'btn2':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_right_btn2_guide%>';
                        break;
                    case 'grid1':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_grid1_guide%>';
                        break;
                    case 'grid2':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Monitoramento.monitoramento_grid2_guide%>';
                        break;
                }

            }
        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfAllRows" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfDropEstr2" ClientIDMode="Static" runat="server" />
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Monitoramento, monitoramento_content_tutorial %>" />
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
                                <asp:Label ID="Label1" runat="server" Text="<%$Resources:Monitoramento, monitoramento_tituloPag %>"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent">
                            <asp:MultiView ID="MultiView1" runat="server">
                                <asp:View ID="vw_monitora" runat="server">
                                    <div onmouseover="QuickGuide('grid1')">
                                    <dx:ASPxGridView ID="gridMonit" CssClass="bg-transparent" ClientInstanceName="gridMonit" EnableViewState="false" ClientIDMode="Static" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                        KeyFieldName="BOL" Width="100%" OnLoad="gridMonit_Load"
                                        OnCustomCallback="gridMonit_CustomCallback" OnDataBinding="gridMonit_DataBinding" OnCommandButtonInitialize="gridMonit_CommandButtonInitialize">
                                        <ClientSideEvents SelectionChanged="function (s,e) {
                                        btnProcessarGrid.SetEnabled(gridMonit.GetSelectedRowCount() &gt; 0);
                                    }"
                                            ColumnMoving="function OnColumnMoving(s, e) {
            e.allow = e.isGroupPanel;
        }"
                                            EndCallback="function(s,e) { 
                                            if (s.cpIsCustomCallback=='CustomCallbackCSV')
                                            {
                                                document.getElementById('btnProcessarMonit').click();
                                            }
                                            }" />
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings ShowGroupPanel="true" VerticalScrollableHeight="180" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" ShowHeaderFilterButton="true" />
                                        <SettingsBehavior AllowFocusedRow="true" />
                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                        </SettingsPager>
                                        <SettingsEditing Mode="Batch"></SettingsEditing>
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
                                        <SettingsContextMenu Enabled="true">
                                            <RowMenuItemVisibility NewRow="false" EditRow="false" DeleteRow="false"></RowMenuItemVisibility>
                                            <ColumnMenuItemVisibility ShowFooter="false" ShowSearchPanel="false" />
                                        </SettingsContextMenu>
                                        <Columns>
                                            <dx:GridViewCommandColumn Name="Command" ShowSelectCheckbox="True" VisibleIndex="0">
                                                <HeaderTemplate>
                                                    <dx:ASPxCheckBox ID="cbAll" runat="server" ClientInstanceName="cbAll" ToolTip="Select all rows" Theme="Material"
                                                        BackColor="White" OnLoad="cbAll_Load">
                                                        <ClientSideEvents CheckedChanged="OnAllCheckedChanged" />
                                                    </dx:ASPxCheckBox>
                                                </HeaderTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </dx:GridViewCommandColumn>
                                            <dx:GridViewDataDateColumn FieldName="NOME" EditFormSettings-Visible="False" VisibleIndex="3" Caption="Origem"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="COD" EditFormSettings-Visible="False" VisibleIndex="2" Caption="Contrato">
                                                <PropertiesComboBox DataSourceID="sqlContratos" TextField="opcdcont" ValueField="opidcont"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="BEN" EditFormSettings-Visible="False" VisibleIndex="4" Caption="Benefici&#225;rio"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="FAV" EditFormSettings-Visible="False" VisibleIndex="5" Caption="Favorecido"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="DATA" EditFormSettings-Visible="False" VisibleIndex="6" Caption="Vencimento">
                                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="VALOR" EditFormSettings-Visible="False" VisibleIndex="7" Caption="Valor">
                                                <PropertiesTextEdit DisplayFormatString="N2"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="BOL" Visible="false" VisibleIndex="8"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="TVIDESTR" Caption="Loja" VisibleIndex="1">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="USIDUSUA" Caption="Aprova&#231;&#227;o" VisibleIndex="9" ReadOnly="true">
                                                <PropertiesComboBox ValueType="System.String" DataSourceID="sqlAprovacao" TextField="TEXTO" ValueField="ID"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <Templates>
                                            <StatusBar>
                                                <div style="text-align: left">
                                                    <br />
                                                    <%--<dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridVerbas.UpdateEdit(); }">
                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                            </dx:ASPxButton>
                                            <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridVerbas.CancelEdit(); }">
                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                            </dx:ASPxButton>--%>
                                                    <dx:ASPxButton ID="btnProcessarGrid" ClientInstanceName="btnProcessarGrid" ClientEnabled="false" runat="server" AutoPostBack="false" CssClass="btn-using" Text="Processar" ClientSideEvents-Click="function(s, e){ gridMonit.PerformCallback('processar'); }">
                                                        <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                    </dx:ASPxButton>
                                                    <dx:ASPxButton ID="btnSMSAprov" runat="server" CssClass="btn-using" Text="Notificar" OnClick="btnSMSAprov_Click">
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
                                    </div>
                                </asp:View>
                                <asp:View ID="vw_aprova" runat="server">
                                    <div onmouseover="QuickGuide('grid2')">
                                    <dx:ASPxGridView ID="gridAprova" ClientInstanceName="gridAprova" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                        KeyFieldName="BOL" Width="100%" OnCustomCallback="gridAprova_CustomCallback" OnLoad="gridAprova_Load">
                                        <ClientSideEvents SelectionChanged="function (s,e) {
                                        btnProcessarAprova.SetEnabled(gridAprova.GetSelectedRowCount() &gt; 0);
                                    }"
                                            ColumnMoving="function OnColumnMoving(s, e) {
            e.allow = e.isGroupPanel;
        }"
                                            EndCallback="function(s,e) { 
                                            if (s.cpIsCustomCallback=='CustomCallbackCSV')
                                            {
                                                document.getElementById('btnProcessarAprova').click();
                                            }
                                            }" />
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings ShowGroupPanel="true" VerticalScrollableHeight="180" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" ShowHeaderFilterButton="true" />
                                        <SettingsBehavior AllowFocusedRow="true" />
                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                        </SettingsPager>
                                        <SettingsEditing Mode="Batch"></SettingsEditing>
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
                                        <SettingsContextMenu Enabled="true">
                                            <RowMenuItemVisibility NewRow="false" EditRow="false" DeleteRow="false"></RowMenuItemVisibility>
                                            <ColumnMenuItemVisibility ShowFooter="false" ShowSearchPanel="false" />
                                        </SettingsContextMenu>
                                        <Columns>
                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataDateColumn FieldName="NOME" EditFormSettings-Visible="False" VisibleIndex="4" Caption="Origem"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="COD" EditFormSettings-Visible="False" VisibleIndex="2" Caption="Contrato">
                                                <PropertiesComboBox DataSourceID="sqlContratos" TextField="opcdcont" ValueField="opidcont"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="BEN" EditFormSettings-Visible="False" VisibleIndex="5" Caption="Benefici&#225;rio"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="FAV" EditFormSettings-Visible="False" VisibleIndex="6" Caption="Favorecido"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="DATA" EditFormSettings-Visible="False" VisibleIndex="7" Caption="Vencimento">
                                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="VALOR" EditFormSettings-Visible="False" VisibleIndex="8" Caption="Valor">
                                                <PropertiesTextEdit DisplayFormatString="N2"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="BOL" Visible="false" VisibleIndex="9"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="TVIDESTR" Caption="Loja" VisibleIndex="1">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <Templates>
                                            <StatusBar>
                                                <div style="text-align: left">
                                                    <br />
                                                    <dx:ASPxButton ID="btnProcessarAprova" ClientInstanceName="btnProcessarAprova" ClientEnabled="false" runat="server" AutoPostBack="false" CssClass="btn-using" Text="Aprovar" ClientSideEvents-Click="function(s, e){ gridMonit.PerformCallback('processar'); }">
                                                        <ClientSideEvents Click="function(s, e){ gridAprova.PerformCallback('aprovar'); }" />
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
                                        </div>
                                </asp:View>
                            </asp:MultiView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="sqlAprovacao" runat="server" CacheDuration="Infinite" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlLoja" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select TV.TVIDESTR,FO.FONMAB20 from TVESTRUT TV, FOFORNEC FO
WHERE TV.TVIDESTR = FO.TVIDESTR
  AND FOTPIDTP=6
ORDER BY 2"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlContratos" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select opcdcont,opidcont from opcontra"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlMonitor" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'></asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="hfUser" runat="server" />
            <div class="container p-0">
                <div class="row mt-3 card" style="margin: 0 auto">
                    <div class="card-header p-1 text-left">
                        <h5>
                            <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" onmouseout="QuickGuide('ini');" Text="<%$ Resources:Monitoramento, monitoramento_tituloRight %>" CssClass="labels text-left"></asp:Label></h5>
                    </div>
                </div>
                <div class="row mt-1" style="margin: 0 auto">
                    <h6>
                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl2 %>" CssClass="labels text-left"></asp:Label></h6>
                    <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('lbl2');">
                        <dx:ASPxTextBox ID="txtQtdDias" Enabled="true" ClientInstanceName="txtQtdDias" MaxLength="5" runat="server" CssClass="text-boxes" Width="100%">
                            <ClientSideEvents TextChanged="function (s,e) {
                                var date = txtDtInicial.GetDate(); 
                                date.setDate(date.getDate() + parseInt(txtQtdDias.GetText()));  
                                txtDtFinal.SetDate(date); 
                        }" />
                            <ValidationSettings RegularExpression-ValidationExpression="^([1-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-9][0-9][0-9][0-9][0-9])$" Display="Dynamic" ErrorTextPosition="Bottom" RegularExpression-ErrorText="Apenas números."></ValidationSettings>
                        </dx:ASPxTextBox>
                    </div>
                </div>
                <div class="row mt-1" style="margin: 0 auto">
                    <h6>
                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl3 %>" CssClass="labels text-left"></asp:Label></h6>
                    <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('lbl3');">
                        <dx:ASPxDateEdit ID="txtDtInicial" Enabled="true" ClientInstanceName="txtDtInicial" UseMaskBehavior="True" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above">
                            <ClientSideEvents DateChanged="UpdateInfo"></ClientSideEvents>
                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
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
                                <FastNavProperties DisplayMode="Inline" />
                            </CalendarProperties>
                        </dx:ASPxDateEdit>
                    </div>
                </div>
                <div class="row mt-1" style="margin: 0 auto">
                    <h6>
                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl4 %>" CssClass="labels text-left"></asp:Label></h6>
                    <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('lbl4');">
                        <dx:ASPxDateEdit ID="txtDtFinal" Enabled="true" ClientInstanceName="txtDtFinal" ForeColor="dimgray" UseMaskBehavior="True" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above">
                            <ClientSideEvents DateChanged="UpdateInfo"></ClientSideEvents>
                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                <HoverStyle BackColor="#669999"></HoverStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                            </ButtonStyle>
                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            <DateRangeSettings StartDateEditID="txtDtInicial"></DateRangeSettings>
                            <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                <MonthGridPaddings Padding="0px" />
                                <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                <HeaderStyle BackColor="#669999" />
                                <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                <FastNavProperties DisplayMode="Inline" />
                            </CalendarProperties>
                        </dx:ASPxDateEdit>
                    </div>
                </div>
                <div class="row mt-1" style="margin: 0 auto">
                    <h6>
                        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl5 %>" CssClass="labels text-left"></asp:Label></h6>
                    <asp:RequiredFieldValidator ID="reqSitua" runat="server" ValidationGroup="Pesquisa" ControlToValidate="dropSitua" InitialValue="-1" ForeColor="Red" ErrorMessage="*"></asp:RequiredFieldValidator>
                    <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('lbl5');">
                        <dx:ASPxComboBox ID="dropSitua" Enabled="true" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                <HoverStyle BackColor="#669999"></HoverStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                            </ButtonStyle>
                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            <Items>
                                <dx:ListEditItem Text="  " Value="-1" Selected="true" />
                                <dx:ListEditItem Text="<%$ Resources:Monitoramento, monitoramento_right_combo1_item1 %>" Value="0" />
                                <dx:ListEditItem Text="<%$ Resources:Monitoramento, monitoramento_right_combo1_item2 %>" Value="1" />
                            </Items>
                        </dx:ASPxComboBox>
                    </div>
                </div>
                <div class="row mt-3" style="margin: 0 auto">
                    <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('btn1');">
                        <asp:Button ID="btnProcessarMonit" ClientIDMode="Static" Enabled="true" runat="server" ValidationGroup="Pesquisa" CssClass="btn-using" Text="Contas Pagar" OnClick="btnProcessar_Click" />
                    </div>
                    <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('btn2');">
                        <asp:Button ID="btnProcessarAprov" ClientIDMode="Static" Enabled="true" runat="server" ValidationGroup="Pesquisa" CssClass="btn-using" Text="Aprovação" OnClick="btnProcessarAprov_Click" />
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnProcessarMonit" />
            <asp:PostBackTrigger ControlID="btnProcessarAprov" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
