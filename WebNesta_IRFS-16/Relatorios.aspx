<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Relatorios.aspx.cs" Inherits="WebNesta_IRFS_16.Relatorios1" %>
<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxPivotGrid.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxPivotGrid" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">


        function openModalEstrutura() {
            $('#ModalEstrutura').modal('show');
        }
        var exportInitiated = false;
        function OnContextMenuItemClick(s, e) {
            if (e.item.name == 'XLSX' || e.item.name == 'CSV' || e.item.name == 'PDF') {
                e.processOnServer = true;
                e.usePostBack = true;
            }
        }
    </script>
    <script type="text/javascript">
        function ClearSelection() {
            TreeList.SetFocusedNodeKey("");
            UpdateControls(null, "");
        }
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            if (focusedNodeKey != "")
                employeeName = TreeList.cpEmployeeNames[focusedNodeKey];
            UpdateControls(focusedNodeKey, employeeName);
        }
        function UpdateControls(key, text) {
            DropDownEdit.SetText(text);
            DropDownEdit.SetKeyValue(key);
            $("#hfTVIDESTR").val(key);
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
        function OnGridSelectionChanged() {
            gridLayouts.GetSelectedFieldValues('CADSLAYO', OnGridSelectionComplete);
        }
        function OnGridSelectionComplete(values) {
            ASPxDropDownEdit1.SetText(values);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfTituloPag" Value="Relatórios" runat="server" />
    <asp:HiddenField ID="hfTVIDESTR" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfData1" runat="server" />
    <asp:HiddenField ID="hfData2" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <dx:ASPxPivotGridExporter ID="ASPxPivotGridExporter1" runat="server" ASPxPivotGridID="ASPxPivotGrid1"></dx:ASPxPivotGridExporter>
    <div class="container-fluid">
        <div class="row mt-2 pr-2">
            <asp:MultiView ID="MultiView1" runat="server">
                <asp:View ID="vwSelect" runat="server">
                    <div class="col-4">
                        <h5>
                            <asp:Label ID="Label2" CssClass="labels" runat="server" Text="Selecione o relatório"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="combo" ControlToValidate="dropQueries" CssClass="labels" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator></h5>
                        <div class="input-group mb-auto drop-down-div">
                            <dx:ASPxComboBox ID="dropQueries" ForeColor="DimGray" AllowInputUser="false" ValueType="System.Int32" runat="server" CssClass="drop-down2" Theme="Material" Width="100%">
                                <ButtonStyle Border-BorderColor="#669999" Border-BorderStyle="Solid" Border-BorderWidth="0px">
                                    <HoverStyle BackColor="#669999">
                                    </HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                <ValidationSettings ValidationGroup="combo">
                                </ValidationSettings>
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="col-4">
                        <br />
                        <div class="input-group mb-auto">
                            <asp:Button ID="btn_click_Relatorios" runat="server" ValidationGroup="combo" Text="<%$ Resources:GlobalResource, btn_consultar %>" CssClass="btn-using" OnClick="btn_click_Relatorios_Click" />
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="vwPivot" runat="server">
                    <div class="card bg-transparent col-lg-12 p-0">
                        <div class="card-header bg-transparent">
                            <h4>
                                <asp:Label ID="Label5" CssClass="labels" runat="server" Text="<%$ Resources:Relatorios, relatorio_titulo %>"></asp:Label><asp:Label ID="lblNomeQuery" CssClass="labels pl-1" runat="server"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent">

                            <dx:ASPxPivotGrid ForeColor="DimGray" ID="ASPxPivotGrid1" runat="server" OnInit="ASPxPivotGrid1_Init" OnDataBound="ASPxPivotGrid1_DataBound" ClientIDMode="AutoID"
                                Width="1000px" Height="300px" EnableCallbackAnimation="True" Theme="MaterialCompact">
                                <ClientSideEvents EndCallback="function(s, e) {
	var popup = s.GetPrefilterWindow();
                                    if (popup != null) {
                                    var filterPanel = popup.GetCurrentWindowElement();
                                    if (filterPanel != null) {
                                    filterPanel.style.left = &quot;25%&quot;; 
                                    filterPanel.style.top = &quot;25%&quot;; 
                                    filterPanel.style.width = &quot;700px&quot;; } } 
}"></ClientSideEvents>
                                <OptionsPager Visible="False">
                                </OptionsPager>
                                <OptionsData DataProcessingEngine="Optimized" AutoExpandGroups="False" />
                                <OptionsCustomization AllowFilterInCustomizationForm="true" CustomizationFormStyle="Excel2007" />
                                <OptionsFilter FilterPanelMode="Filter" />
                                <Styles>
                                    <RowAreaStyle CssClass="cell-pivot" Wrap="True"></RowAreaStyle>
                                    <FieldValueStyle Wrap="False"></FieldValueStyle>
                                    <FieldValueTotalStyle BackColor="LightGray">
                                    </FieldValueTotalStyle>
                                    <FilterWindowStyle CssClass="filterPivot"></FilterWindowStyle>
                                </Styles>
                            </dx:ASPxPivotGrid>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="vwTabela" runat="server">
                    <div class="card bg-transparent col-lg-12 p-0">
                        <div class="card-header bg-transparent">
                            <h4>
                                <asp:Label ID="Label7" CssClass="labels" runat="server" Text="<%$ Resources:Relatorios, relatorio_titulo %>"></asp:Label><asp:Label ID="lblNomeQuery2" CssClass="labels pl-1" runat="server"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent">
                            <asp:Button ID="btnLoading" ClientIDMode="Static" CssClass="Loading d-none" runat="server" Text="Button" />
                            <dx:ASPxGridView ID="gridTabela" ClientInstanceName="gridTabela" CssClass="bg-transparent" OnFillContextMenuItems="gridTabela_FillContextMenuItems" OnContextMenuItemClick="gridTabela_ContextMenuItemClick"
                                DataSourceID="dsPivotGrid" Width="1000px" runat="server" AutoGenerateColumns="true" Theme="Material" OnDataBound="gridTabela_DataBound">
                                <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"
                                    EndCallback="function(s,e){ LoadingPanel.Hide(); }"></ClientSideEvents>
                                <Settings ShowGroupPanel="true" ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" HorizontalScrollBarMode="Auto"></Settings>
                                <SettingsPager Visible="false"></SettingsPager>
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <SettingsExport EnableClientSideExportAPI="true"></SettingsExport>
                                <SettingsContextMenu Enabled="true">
                                    <RowMenuItemVisibility ExportMenu-Visible="true">
                                        <GroupSummaryMenu SummaryAverage="false" SummaryMax="false" SummaryMin="false" SummarySum="false" />
                                    </RowMenuItemVisibility>
                                </SettingsContextMenu>

                                <Images>
                                    <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                </Images>
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
                                    <FocusedRow BackColor="#669999" ForeColor="White"></FocusedRow>
                                    <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                    <EditForm Paddings-Padding="0px"></EditForm>
                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                    <Table></Table>
                                    <Cell Wrap="False" Paddings-Padding="5px"></Cell>
                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                </Styles>
                            </dx:ASPxGridView>
                            <dx:ASPxGridViewExporter ID="gridTabelaExporter" GridViewID="gridTabela" runat="server" PageHeader-Center="RIT" OnRenderBrick="gridTabelaExporter_RenderBrick">
                            </dx:ASPxGridViewExporter>
                        </div>
                    </div>
                </asp:View>
            </asp:MultiView>
            <asp:SqlDataSource ID="dsPivotGrid" EnableCaching="True" CacheDuration="Infinite" CacheKeyDependency="MyCacheDependency" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' OnSelecting="dsPivotGrid_Selecting"></asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <dx:ASPxPopupControl ID="popupMail" ClientInstanceName="popupMail" runat="server" Theme="Material" AllowDragging="True" PopupElementID="lblLnkDimen" CloseAction="CloseButton"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="<%$ Resources:Relatorios, relatorio_popup_titulo %>" Modal="True" Width="400px" Height="500px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxPivotCustomizationControl ID="ASPxPivotCustomizationControl1"
                    Layout="StackedDefault" AllowedLayouts="StackedDefault" DeferredUpdates="true"
                    ASPxPivotGridID="ASPxPivotGrid1" runat="server" AllowFilter="true"
                    Height="500px" Width="400px" meta:resourcekey="ASPxPivotCustomizationControl1Resource1">
                    <Border BorderWidth="0px" />
                </dx:ASPxPivotCustomizationControl>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <asp:HiddenField ID="hfIDRelatorio" runat="server" />
    <asp:HiddenField ID="hfUser2" runat="server" />
    <asp:HiddenField ID="hfLayout" runat="server" />
    <asp:Panel ID="Panel1" runat="server">
        <div class="container text-left pl-0 pr-0">
            <div id="accordion_Menu">
                <div class="card p-0 ">
                    <div class="card-header pb-0 ">
                        <a class="card-link" data-toggle="collapse" href="#collapseView">
                            <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                <asp:Label ID="Label1" runat="server" CssClass="labels" Text="<%$ Resources:Relatorios, relatorio_right_titulo4 %>"></asp:Label>
                            </h5>
                        </a>
                    </div>
                    <div id="collapseView" class="collapse show" data-parent="#accordion_Menu">
                        <div class="card-body pb-0 pt-1">
                            <dx:ASPxRadioButtonList ID="listView" ClientInstanceName="listView" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="Moderno" runat="server" RepeatDirection="Horizontal" Border-BorderStyle="None"
                                FocusedStyle-Wrap="Default" ValueType="System.Int32" OnSelectedIndexChanged="listView_SelectedIndexChanged" AutoPostBack="true">
                                <Items>
                                    <dx:ListEditItem Text="<%$ Resources:Relatorios, relatorio_right_opt1 %>" Value="1" />
                                    <dx:ListEditItem Text="<%$ Resources:Relatorios, relatorio_right_opt2 %>" Value="2" Selected="true" />
                                </Items>
                            </dx:ASPxRadioButtonList>
                        </div>
                    </div>
                </div>
                <asp:Panel ID="pnlPivot" runat="server">
                    <div class="card p-0 ">
                        <div class="card-header pb-0 ">
                            <a class="card-link" data-toggle="collapse" href="#" onclick="popupMail.Show();">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="lblLnkDimen" runat="server" CssClass="labels" Text="<%$ Resources:Relatorios, relatorio_right_titulo1 %>"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapseCampos" class="collapse" data-parent="#accordion_Menu">
                            <div class="card-body pb-0 pt-1">
                            </div>
                        </div>
                    </div>
                    <div class="card p-0 ">
                        <div class="card-header pb-0 ">
                            <a class="card-link" data-toggle="collapse" href="#collapseExporta" >
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label3" runat="server" CssClass="labels" Text="<%$ Resources:Relatorios, relatorio_right_titulo2 %>"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapseExporta" class="collapse" data-parent="#accordion_Menu">
                            <div class="card-body pb-0 pt-1">
                                <dx:ASPxRadioButtonList Font-Size="10pt" Width="100%" ForeColor="DimGray" ID="lstExporting" runat="server" ValueType="System.Int32" Caption="<%$ Resources:Relatorios, relatorio_right_subtitulo1 %>" RightToLeft="False" SelectedIndex="0">
                                    <Items>
                                        <dx:ListEditItem Selected="True" Text="<%$ Resources:Relatorios, relatorio_right_checkbox1 %>" Value="1" />
                                        <dx:ListEditItem Text="<%$ Resources:Relatorios, relatorio_right_checkbox2 %>" Value="2" />
                                        <dx:ListEditItem Text="<%$ Resources:Relatorios, relatorio_right_checkbox3 %>" Value="3" />
                                    </Items>
                                    <CaptionSettings Position="Top" />
                                    <Border BorderWidth="0px" />
                                </dx:ASPxRadioButtonList>
                            </div>
                            <div class="card-footer row border-top-0 bg-light p-0 mt-1 pl-3" style="margin: 0 auto">
                                <asp:Button ID="Button2" CssClass="btn-using" runat="server" Text="<%$ Resources:Relatorios, relatorio_right_btn1 %>" OnClick="Button2_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="card p-0">
                        <div class="card-header pb-0">
                            <a class="card-link" data-toggle="collapse" href="#collapseLayout">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label4" runat="server" CssClass="labels" Text="<%$ Resources:Relatorios, relatorio_right_titulo3 %>"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapseLayout" class="collapse" data-parent="#accordion_Menu">
                            <div class="card-body pb-0 pt-1">
                                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Relatorios, relatorio_right_subtitulo2 %>" Font-Size="14pt" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" style="padding-left: 2px">
                                        <dx:ASPxDropDownEdit ID="ASPxDropDownEdit1" CssClass="dropDownEdit" ClientInstanceName="ASPxDropDownEdit1" Theme="Material"
                                            Width="100%" runat="server" AnimationType="Slide" AllowUserInput="False">
                                            <DropDownWindowTemplate>
                                                <div style="position: relative">
                                                    <dx:ASPxGridView ID="gridLayouts" runat="server" AutoGenerateColumns="False" ClientIDMode="Static" ClientInstanceName="gridLayouts" DataSourceID="sqlLayouts" EnableCallBacks="False" KeyFieldName="CAIDLAYO" OnBatchUpdate="gridLayouts_BatchUpdate" OnToolbarItemClick="gridLayouts_ToolbarItemClick" Theme="DevEx" Width="350px">
                                                        <ClientSideEvents SelectionChanged="function(s,e){ OnGridSelectionChanged(); }" ToolbarItemClick="function onToolbarItemClick(s, e) { $('#coverScreen').show();e.processOnServer = true; }" />
                                                        <SettingsEditing Mode="Batch">
                                                        </SettingsEditing>
                                                        <SettingsBehavior AllowSelectSingleRowOnly="True" />
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
                                                        </SettingsCommandButton>
                                                        <SettingsText BatchEditChangesPreviewDeletedValues="<%$ Resources:GlobalResource, btn_grid_batch_deletevalues %>" BatchEditChangesPreviewInsertedValues="<%$ Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewUpdatedValues="<%$ Resources:GlobalResource, btn_grid_batch_updatevalues %>" CommandBatchEditCancel="<%$ Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$ Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$ Resources:GlobalResource, btn_grid_batch_preview %>" CommandBatchEditUpdate="<%$ Resources:GlobalResource, btn_grid_batch_save %>" />
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ButtonRenderMode="Image" ButtonType="Image" MaxWidth="30" SelectAllCheckboxMode="Page" ShowDeleteButton="True" ShowInCustomizationForm="True" ShowNewButtonInHeader="True" ShowSelectCheckbox="True" VisibleIndex="0" Width="30px">
                                                                <CellStyle CssClass="text-center">
                                                                </CellStyle>
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataTextColumn FieldName="CABBLAYO" MaxWidth="320" ReadOnly="True" ShowInCustomizationForm="True" Visible="False" VisibleIndex="2" Width="320px">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Layout" FieldName="CADSLAYO" ShowInCustomizationForm="True" VisibleIndex="1">
                                                            </dx:GridViewDataTextColumn>
                                                        </Columns>
                                                        <Toolbars>
                                                            <dx:GridViewToolbar>
                                                                <Items>
                                                                    <dx:GridViewToolbarItem Name="select" Text="<%$ Resources:Relatorios, relatorio_right_grid_btn1 %>">
                                                                    </dx:GridViewToolbarItem>
                                                                    <dx:GridViewToolbarItem Name="update" Text="<%$ Resources:Relatorios, relatorio_right_grid_btn2 %>">
                                                                    </dx:GridViewToolbarItem>
                                                                </Items>
                                                            </dx:GridViewToolbar>
                                                        </Toolbars>
                                                    </dx:ASPxGridView>
                                                </div>
                                            </DropDownWindowTemplate>
                                            <ButtonStyle Border-BorderColor="#669999" Border-BorderStyle="Solid" Border-BorderWidth="0px">
                                                <HoverStyle BackColor="#669999">
                                                </HoverStyle>
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                        </dx:ASPxDropDownEdit>
                                </div>
                            </div>
                            <asp:SqlDataSource runat="server" ID="sqlLayouts" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                SelectCommand="SELECT CAIDLAYO,CADSLAYO,CABBLAYO FROM CALAYOUT WHERE USIDUSUA=? AND CARLLAYO=?"
                                UpdateCommand="update CALAYOUT set CADSLAYO=? where CAIDLAYO=?"
                                DeleteCommand="delete CALAYOUT where CAIDLAYO=?"
                                InsertCommand="select * from CALAYOUT">

                                <DeleteParameters>
                                    <asp:Parameter Name="CAIDLAYO" Type="Int32" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfUser2" Name="?" PropertyName="Value" />
                                    <asp:ControlParameter ControlID="hfIDRelatorio" Name="?" PropertyName="Value" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="CADSLAYO" Type="String" />
                                    <asp:Parameter Name="CAIDLAYO" Type="Int32" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                            <div class="card-footer row border-top-0 bg-light p-0 pl-3 mt-1" style="margin: 0 auto">
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
