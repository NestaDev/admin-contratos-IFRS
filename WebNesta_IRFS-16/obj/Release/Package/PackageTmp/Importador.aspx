<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="True" CodeBehind="Importador.aspx.cs" Inherits="WebNesta_IRFS_16.Importador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfUser2" runat="server" />
    <asp:MultiView ID="mv_Importador" runat="server">
        <asp:View ID="view_guarda_chuva" runat="server">
            <asp:HiddenField ID="hfOPIDCONT" runat="server" />
            <div class="container" style="overflow-y: auto; height: 470px;">
                <div class="row ml-0 mr-0 mt-0 w-100">
                    <div class="col-sm-12 pl-4 pr-0">
                        <div class="container-fluid">
                            <div class="row card border-0 bg-transparent p-0">
                                <div class="card-header bg-transparent ">
                                    <h5 style="text-align: left; float: left;">
                                        <asp:Label ID="Label24" runat="server" CssClass="labels" Text="Contrato Guarda-Chuva" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                                </div>
                                <div class="card-body p-0 pl-3 ">
                                    <div class="row mt-3" style="margin: 0 auto">
                                        <div class="col-3 p-0">
                                            <asp:Label ID="Label30" runat="server" Text="<%$ Resources:Aquisicao, aquisição_right_titulo %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('sel_contrato');">
                                                <dx:ASPxDropDownEdit ID="ddePesqContrato" ClientInstanceName="ddePesqContrato" CssClass="drop-down" ClientIDMode="Static" Width="100%" runat="server" Theme="Material" AllowUserInput="false">
                                                    <ClientSideEvents CloseUp="function(s, e) {  
                                s.ShowDropDown();
                                }" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DropDownWindowTemplate>
                                                        <div class="container-fluid p-0">
                                                            <asp:SqlDataSource ID="sqlProcessos" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                                                SelectCommand="SELECT OP.OPCDCONT, TV.TVDSESTR, PR.PRPRODES, OP.OPVLCONT,OP.PRPRODID,OP.OPIDCONT 
FROM OPCONTRA OP 
INNER JOIN PRPRODUT PR   ON(OP.PRPRODID = PR.PRPRODID) 
INNER JOIN TVESTRUT TV   ON(OP.TVIDESTR = TV.TVIDESTR) 
AND PR.CMTPIDCM NOT IN(2, 4, 5) 
AND OP.OPIDAACC IS NULL 
AND OP.PRTPIDOP NOT IN(5)
AND OP.OPTPTPID = 91
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?)
ORDER BY OPIDCONT DESC">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="hfUser2" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                            <div class="row" style="display: none">
                                                                <div class="col-12 text-right">
                                                                    <asp:Button ID="btnselecionar" CausesValidation="false" ClientIDMode="Static" runat="server" CssClass="d-none" Text="<%$Resources:GlobalResource, btn_selecionar %>" OnClick="btnselecionar_Click" />
                                                                </div>
                                                            </div>
                                                            <div class="row m-1">
                                                                <dx:ASPxGridView ID="ASPxGridView1" ClientIDMode="Static" Width="900px" ClientInstanceName="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="sqlProcessos" Theme="Material">
                                                                    <ClientSideEvents RowDblClick="function(s, e) {                                            
                                                ddePesqContrato.HideDropDown();
                                                document.getElementById('btnselecionar').click();
                                            }" />
                                                                    <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" ShowFilterRow="false" ShowHeaderFilterButton="true" />
                                                                    <SettingsPager Visible="false"></SettingsPager>
                                                                    <SettingsBehavior AllowFocusedRow="True" />
                                                                    <SettingsPopup>
                                                                        <HeaderFilter MinHeight="140px">
                                                                        </HeaderFilter>
                                                                    </SettingsPopup>
                                                                    <Columns>
                                                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col1 %>" Width="80px" MaxWidth="80" FieldName="OPCDCONT" VisibleIndex="0">
                                                                            <PropertiesComboBox DataSourceID="sqlProcessos" ValueField="OPCDCONT" TextField="OPCDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                                            <Settings AllowAutoFilter="True" />
                                                                            <EditFormSettings VisibleIndex="0" />
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col2 %>" Width="170px" MaxWidth="120" FieldName="TVDSESTR" VisibleIndex="1">
                                                                            <Settings AllowAutoFilter="True" />
                                                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="TVDSESTR" ValueField="TVDSESTR" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                                            </PropertiesComboBox>
                                                                            <EditFormSettings VisibleIndex="1" />
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col3 %>" Width="120px" MaxWidth="120" FieldName="PRPRODES" VisibleIndex="2">
                                                                            <Settings AllowAutoFilter="True" />
                                                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODES" ValueField="PRPRODES" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                                            <EditFormSettings VisibleIndex="2" />
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:Aquisicao, aquisição_right_grid_col5 %>' Width="50px" MaxWidth="50" FieldName="PRPRODID" VisibleIndex="5">
                                                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID"></PropertiesComboBox>
                                                                            <Settings AllowAutoFilter="True" />
                                                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                                            </PropertiesComboBox>
                                                                            <EditFormSettings VisibleIndex="3" />
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:Aquisicao, aquisição_right_grid_col6 %>' Width="60px" MaxWidth="60" FieldName="OPIDCONT" VisibleIndex="6">
                                                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT"></PropertiesComboBox>
                                                                            <Settings AllowAutoFilter="True" />
                                                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                                            </PropertiesComboBox>
                                                                            <EditFormSettings VisibleIndex="4" />
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="OPVLCONT" MaxWidth="60" Width="60px" Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col4 %>" VisibleIndex="4">
                                                                            <PropertiesTextEdit DisplayFormatString="N2">
                                                                                <MaskSettings Mask="&lt;0..99999g&gt;.&lt;00..99&gt;"></MaskSettings>
                                                                            </PropertiesTextEdit>
                                                                            <Settings AllowAutoFilter="True"></Settings>
                                                                            <EditFormSettings VisibleIndex="5"></EditFormSettings>
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
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

                                                            </div>
                                                        </div>

                                                    </DropDownWindowTemplate>
                                                </dx:ASPxDropDownEdit>
                                            </div>

                                        </div>
                                    </div>
                                    <div class="row mt-3" style="margin: 0 auto">
                                        <div class="col-8 pl-2 p-0">
                                            <dx:ASPxGridView ID="gridSubContratos" ClientInstanceName="gridSubContratos" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static"
                                                Width="940px" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" OnLoad="gridSubContratos_Load"
                                                AutoGenerateColumns="False" SettingsResizing-ColumnResizeMode="NextColumn" DataSourceID="sqlSubContratos">

                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsBehavior AllowFocusedRow="true" ConfirmDelete="true" />
                                                <Settings ShowStatusBar="Visible" ShowHeaderFilterButton="true" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="OPIDCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col1 %>" Width="70px" VisibleIndex="0">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="OPCDCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col2 %>" Width="150px" VisibleIndex="1">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="OPNMCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col3 %>" VisibleIndex="2">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="OPVLCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col4 %>" Width="150px" VisibleIndex="3">
                                                        <PropertiesTextEdit DisplayFormatString="N2"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="OPTPTPDS" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col5 %>" Width="100px" VisibleIndex="4">
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                                <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                                </SettingsPager>
                                                <Templates>
                                                    <StatusBar>
                                                        <div style="text-align: left">
                                                            <dx:ASPxButton ID="btnImportar" runat="server" Width="80px" CssClass="btn-using" Text="<%$ Resources:Aquisicao, umbrella_grp4_grid_btn1 %>" AutoPostBack="false" ClientSideEvents-Click="function(s, e){ popupImportaExcel.Show(); }">
                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                            </dx:ASPxButton>
                                                        </div>
                                                    </StatusBar>
                                                </Templates>
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
                                            <asp:SqlDataSource runat="server" ID="sqlSubContratos" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select OPIDCONT,OPCDCONT,OPNMCONT,OPVLCONT,t.OPTPTPDS from opcontra o
inner join OPTPTIPO T on o.OPTPTPID=t.OPTPTPID and t.CMTPIDCM=o.CMTPIDCM and t.PAIDPAIS=1
where o.OPIDAACC=? order by 1">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
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
        <asp:View ID="view_ettj" runat="server">
            <div class="container" style="overflow-y: auto; height: 470px;">
                <div class="row ml-0 mr-0 mt-0 w-100">
                    <div class="col-sm-12 pl-4 pr-0">
                        <div class="container-fluid">
                            <div class="row card border-0 bg-transparent p-0">
                                <div class="card-header bg-transparent ">
                                    <h5 style="text-align: left; float: left;">
                                        <asp:Label ID="Label1" runat="server" CssClass="labels" Text="Curva ETTJ" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                                </div>
                                <div class="card-body p-0 pl-3 ">
                                    <div class="row mt-3" style="margin: 0 auto">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label3" runat="server" Text="Book"></asp:Label>
                                            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('pesquisa');" onmouseout="QuickGuide('ini');">
                                                <dx:ASPxComboBox ID="dropListagemETTJ" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" AutoPostBack="true"
                                                    Theme="Material" Width="100%" DataSourceID="sqlIndexadores" TextField="BODSBOOK" ValueField="BOIDBOOK" OnSelectedIndexChanged="dropListagemETTJ_SelectedIndexChanged">
                                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                                <asp:SqlDataSource runat="server" ID="sqlIndexadores" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                    SelectCommand="select BODSBOOK,C.BOIDBOOK from BOBOBOOK C INNER JOIN ETTJETTJ E ON C.BOIDBOOK=E.BOIDBOOK ORDER BY 1"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-x0 p-0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label9" runat="server" Text="<%$Resources:ETTJ, ettj_guia1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('lbl2');">
                                                <asp:TextBox ID="txtCenario" ClientIDMode="Static" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label4" runat="server" Text="<%$Resources:ETTJ, ettj_guia1_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('lbl3');">
                                                <dx:ASPxComboBox ID="dropCriterio" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" AutoPostBack="true"
                                                    Theme="Material" Width="100%" DataSourceID="sqlCriterio" TextField="CRDSCCRI" ValueField="CRDSCCRI">
                                                    <Border BorderStyle="Solid" BorderWidth="1px" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                                <asp:SqlDataSource runat="server" ID="sqlCriterio" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                    SelectCommand="select CRDSCCRI from CRITETTJ ORDER BY 1
"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label13" runat="server" Text="<%$Resources:ETTJ, ettj_guia1_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" ControlToValidate="txtDescricao" ValidationGroup="ValidaEETJ" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('lbl4');">
                                                <asp:TextBox ID="txtDescricao" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row mt-3" style="margin: 0 auto">
                                        <asp:HiddenField ID="hfIndexCenarios" ClientIDMode="Static" runat="server" />
                                        <asp:Button ID="btnDblClickCenarios" ClientIDMode="Static" CssClass="d-none" runat="server" Text="Button" OnClick="btnDblClickCenarios_Click" />
                                        <dx:ASPxGridView ID="gridCenarios" CssClass="mt-1" ClientInstanceName="gridCenarios" KeyFieldName="CENAETTJ" Theme="Material" runat="server" AutoGenerateColumns="False"
                                            Width="550px" DataSourceID="sqlCenarios" OnCustomButtonInitialize="gridCenarios_CustomButtonInitialize" OnCustomButtonCallback="gridCenarios_CustomButtonCallback" OnLoad="gridCenarios_Load">
                                            <ClientSideEvents EndCallback="function(s, e) {
	                                    if (s.cp_origem == 'ativar') {
                                            if(s.cp_ok=='OK')
                                            {
                                                document.getElementById('txtCenario').value = s.cp_cenario;
                                                gridCenarios.Refresh();
                                                s.Refresh();
                                                delete(s.cp_cenario);
                                                delete(s.cp_intervalos);
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                    }"
                                                RowDblClick="function(s, e) {
                                    document.getElementById('hfIndexCenarios').value = e.visibleIndex;
                                    document.getElementById('btnDblClickCenarios').click();
                                    } "></ClientSideEvents>
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                            <SettingsPager NumericButtonCount="20" PageSize="20">
                                            </SettingsPager>
                                            <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="FocusedCellClick"></SettingsEditing>
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
                                                <dx:GridViewDataTextColumn FieldName="CENAETTJ" Caption="<%$Resources:ETTJ, ettj_guia2_grid_col1 %>" VisibleIndex="0" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DESCETTJ" Caption="<%$Resources:ETTJ, ettj_guia2_grid_col2 %>" VisibleIndex="1" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>

                                                <dx:GridViewDataComboBoxColumn FieldName="Status" Caption="<%$Resources:ETTJ, ettj_guia2_grid_col3 %>" VisibleIndex="4" EditFormSettings-Visible="False">
                                                    <PropertiesComboBox>
                                                        <Items>
                                                            <dx:ListEditItem Text="<%$Resources:ETTJ, ettj_guia2_grid_opt1 %>" Value="1"></dx:ListEditItem>
                                                            <dx:ListEditItem Text="<%$Resources:ETTJ, ettj_guia2_grid_opt2 %>" Value="0"></dx:ListEditItem>
                                                        </Items>
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>

                                                <dx:GridViewCommandColumn VisibleIndex="5" Caption="  ">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="ativar" Text="<%$Resources:ETTJ, ettj_guia2_grid_opt1 %>"></dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                </dx:GridViewCommandColumn>
                                            </Columns>
                                            <Templates>
                                                <StatusBar>
                                                    <div style="text-align: left">
                                                        <br />
                                                        <dx:ASPxButton ID="btnNovoCenario" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:ETTJ, ettj_guia2_btn1 %>" ClientSideEvents-Click="function(s, e){ popupImportaExcel2.Show(); }" OnLoad="btnNovoCenario_Load">
                                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                    </div>
                                                </StatusBar>
                                            </Templates>
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
                                        <asp:SqlDataSource runat="server" ID="sqlCenarios" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                            SelectCommand="select case when E.CENAETTJ=I.CENAETTJ THEN 1 ELSE 0 END as Status,I.CENAETTJ,E.DESCETTJ
                                                from ETTJETTJ E, INTEETTJ I
                                                WHERE E.BOIDBOOK=I.BOIDBOOK
                                                AND E.BOIDBOOK=?
                                                GROUP BY case when E.CENAETTJ=I.CENAETTJ THEN 1 ELSE 0 END,I.CENAETTJ,E.DESCETTJ
                                    order by I.CENAETTJ">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="dropListagemETTJ" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <dx:ASPxPopupControl ID="popupShowETTJ" ClientInstanceName="popupShowETTJ" runat="server"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Detalhes Cenário" Modal="true" Width="320px" Height="550px">
                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <dx:ASPxGridView ID="gridDetalheCenario" CssClass="mt-1" ClientInstanceName="gridDetalheCenario" Theme="Material" runat="server" AutoGenerateColumns="False"
                            Width="310px">
                            <SettingsPopup>
                                <HeaderFilter MinHeight="140px">
                                </HeaderFilter>
                            </SettingsPopup>
                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                            <Settings VerticalScrollableHeight="540" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
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
                                <dx:GridViewDataTextColumn FieldName="intervalo" Width="145px" Caption="Intervalo" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="taxa" Width="145px" Caption="Taxa" VisibleIndex="1">
                                    <PropertiesTextEdit DisplayFormatString="N6"></PropertiesTextEdit>
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
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
            <dx:ASPxPopupControl ID="popupImportaExcel2" ClientInstanceName="popupImportaExcel2" runat="server"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Importação Excel" Modal="true" Width="600px" Height="250px">
                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <div class="container-fluid">
                            <div class="row p-0">
                                <div class="col-8">
                                    <h6>
                                        <asp:Label ID="Label5" runat="server" Text="Data Aplicação" CssClass="labels text-left"></asp:Label></h6>
                                    <div class="input-group mb-auto">
                                        <dx:ASPxDateEdit ID="txtDtAplic" ClientInstanceName="txtDtAplic" ForeColor="dimgray" UseMaskBehavior="True" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above">
                                            <ClientSideEvents DateChanged=" function (s,e) { fileImport2.SetEnabled(txtDtAplic.GetValue() != null); } " />
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
                            </div>
                            <div class="row p-0 mt-2">
                                <div class="col-8">
                                    <asp:Button ID="Button1" ClientIDMode="Static" CssClass="Loading d-none" OnClick="btnSel_Click" runat="server" Text="Button" />
                                    <dx:ASPxUploadControl ID="fileImport2" ClientInstanceName="fileImport2" ClientEnabled="false" runat="server" Theme="Material" Width="100%"
                                        OnFileUploadComplete="fileImport_FileUploadComplete" BrowseButton-Text="Procurar"
                                        UploadMode="Advanced" AutoStartUpload="true" ShowUploadButton="false" ShowProgressPanel="True">
                                        <ClientSideEvents FilesUploadComplete="function (s,e) { document.getElementById('btnSel').click(); }" />
                                        <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                        <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".xls,.xlsx">
                                        </ValidationSettings>
                                        <ButtonStyle CssClass="btn-using" ForeColor="White" Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></ButtonStyle>
                                        <DisabledButtonStyle ForeColor="LightGray"></DisabledButtonStyle>
                                    </dx:ASPxUploadControl>
                                </div>
                                <div class="col-4">
                                    <asp:Button ID="Button2" runat="server" CssClass="btn-using" Width="120px" Height="33px" Text="Planilha Modelo" OnClick="btnDownloadModelo_Click" />

                                </div>
                            </div>
                            <div class="row p-0">
                                <div class="col-12">
                                    <asp:Label ID="Label6" runat="server" Text="" CssClass="labels text-left text-danger"></asp:Label>
                                </div>
                            </div>
                        </div>

                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </asp:View>
        <asp:View ID="view_faturamento" runat="server">
            <div class="container" style="overflow-y: auto; height: 470px;">
                <div class="row ml-0 mr-0 mt-0 w-100">
                    <div class="col-sm-12 pl-4 pr-0">
                        <div class="container-fluid">
                            <div class="row card border-0 bg-transparent p-0">
                                <div class="card-header bg-transparent ">
                                    <h5 style="text-align: left; float: left;">
                                        <asp:Label ID="Label2" runat="server" CssClass="labels" Text="Faturamento Diário" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                                </div>
                                <div class="card-body p-0 pl-3 ">
                                    <div class="row p-0">
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto">
                                    <asp:Button ID="Button3" runat="server" CssClass="btn-using" Width="120px" Height="33px" Text="Planilha Modelo" OnClick="btnDownloadModelo_Click" />
                                            </div>
                                        </div>
                                        <div class="col-x0 p-0"></div>
                                        <div class="col-x2 p-0">
                                            <asp:Label ID="Label7" runat="server" CssClass="labels" Text="Selecione a planilha para importação" Style="color: #666666;"></asp:Label>
                                            <div class="input-group mb-auto">
                                            <dx:ASPxUploadControl ID="fileImport3" ClientInstanceName="fileImport3" runat="server" Theme="Material" Width="100%"
                                OnFileUploadComplete="fileImport_FileUploadComplete" BrowseButton-Text="Procurar"
                                UploadMode="Advanced" AutoStartUpload="true" ShowUploadButton="false" ShowProgressPanel="True">
                                <ClientSideEvents FilesUploadComplete="function (s,e) { document.getElementById('btnSel').click(); }" />
                                <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".xls,.xlsx">
                                </ValidationSettings>
                                <ButtonStyle CssClass="btn-using" ForeColor="White" Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></ButtonStyle>
                                <DisabledButtonStyle ForeColor="LightGray"></DisabledButtonStyle>
                            </dx:ASPxUploadControl></div>
                                            </div>
                                        <div class="col-x0 p-0"></div>
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto">
                                            <asp:Label ID="lblError3" runat="server" CssClass="labels text-danger" Text="" style="width: 100%;white-space: break-spaces;height: 100px;overflow: auto;"  ></asp:Label>
                                            </div>
                                        </div>
                                        <div class="col-x0 p-0"></div>
                                    </div>
                                    <div class="row p-0 mt-2">
                                        <div class="col-12 p-0">
                                            <dx:ASPxGridView ID="gridFatura" CssClass="mt-1" ClientInstanceName="gridFatura" KeyFieldName="ID" Theme="Material" runat="server" AutoGenerateColumns="False"
                                            Width="750px"  OnLoad="gridFatura_Load">
                                            
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                            <SettingsPager NumericButtonCount="20" PageSize="20">
                                            </SettingsPager>
                                            <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="FocusedCellClick"></SettingsEditing>
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
                                                <dx:GridViewDataTextColumn FieldName="OPCDCONT" Caption="Código Contrato" VisibleIndex="0" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="FOCDXCGC" Caption="Código Locador" VisibleIndex="1" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="FLDTAFLX" Caption="Data" VisibleIndex="2" EditFormSettings-Visible="False">
                                                    <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy"></PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="FLVALBRT" Caption="Valor Bruto" VisibleIndex="4" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="FLVALLIQ" Caption="Valor Líquido" VisibleIndex="5" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>

                                            </Columns>
                                            <Templates>
                                                <StatusBar>
                                                    <div style="text-align: left">
                                                        <br />
                                                        <dx:ASPxButton ID="btnProcessaFatura" runat="server" AutoPostBack="false" CssClass="btn-using" Text="Processar Importação" OnClick="btnProcessaFatura_Click">
                                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                    </div>
                                                </StatusBar>
                                            </Templates>
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
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:View>
        <asp:View ID="view_cargacontratos" runat="server">
            <div class="container" style="overflow-y: auto; height: 470px;">
                <div class="row ml-0 mr-0 mt-0 w-100">
                    <div class="col-sm-12 pl-4 pr-0">
                        <div class="container-fluid">
                            <div class="row card border-0 bg-transparent p-0">
                                <div class="card-header bg-transparent ">
                                    <h5 style="text-align: left; float: left;">
                                        <asp:Label ID="Label10" runat="server" CssClass="labels" Text="Faturamento Diário" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                                </div>
                                <div class="card-body p-0 pl-3 ">
                                    <div class="row p-0">
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto">
                                    <asp:Button ID="Button4" runat="server" CssClass="btn-using" Width="120px" Height="33px" Text="Planilha Modelo" OnClick="btnDownloadModelo_Click" />
                                            </div>
                                        </div>
                                        <div class="col-x0 p-0"></div>
                                        <div class="col-x2 p-0">
                                            <asp:Label ID="Label11" runat="server" CssClass="labels" Text="Selecione a planilha para importação" Style="color: #666666;"></asp:Label>
                                            <div class="input-group mb-auto">
                                            <dx:ASPxUploadControl ID="fileImport4" ClientInstanceName="fileImport4" runat="server" Theme="Material" Width="100%"
                                OnFileUploadComplete="fileImport_FileUploadComplete" BrowseButton-Text="Procurar"
                                UploadMode="Advanced" AutoStartUpload="true" ShowUploadButton="false" ShowProgressPanel="True">
                                <ClientSideEvents FilesUploadComplete="function (s,e) { document.getElementById('btnSel').click(); }" />
                                <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".xls,.xlsx">
                                </ValidationSettings>
                                <ButtonStyle CssClass="btn-using" ForeColor="White" Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></ButtonStyle>
                                <DisabledButtonStyle ForeColor="LightGray"></DisabledButtonStyle>
                            </dx:ASPxUploadControl></div>
                                            </div>
                                        <div class="col-x0 p-0"></div>
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto">
                                            <asp:Label ID="lblErrorCarga" runat="server" CssClass="labels text-danger" Text="" style="width: 100%;white-space: break-spaces;height: 100px;overflow: auto;"  ></asp:Label>
                                            </div>
                                        </div>
                                        <div class="col-x0 p-0"></div>
                                    </div>
                                    <div class="row p-0 mt-2">
                                        <div class="col-12 p-0">
                                            <dx:ASPxGridView ID="gridCargaContratos" CssClass="mt-1" ClientInstanceName="gridCargaContratos" KeyFieldName="ID" Theme="Material" runat="server" AutoGenerateColumns="False"
                                            Width="900px"  OnLoad="gridCargaContratos_Load">
                                            
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                            <SettingsPager NumericButtonCount="20" PageSize="20">
                                            </SettingsPager>
                                            <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="FocusedCellClick"></SettingsEditing>
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
                                                <dx:GridViewDataTextColumn FieldName="CONTRATO" Caption="Nº Contrato" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="NAUXILIAR" Caption="Nº Auxiliar" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DESCONTRATO" Caption="Descrição Contrato" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CODCREDOR" Caption="CNPJ/CPF Credor" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="NOMECREDOR" Caption="Nome Credor" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DTASSINATURA" Caption="Data Assinatura" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DATALIBERACAO" Caption="Data Liberação" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DATAENCERRAMENTO" Caption="Data Encerramento" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="OPVLCONT" Caption="Valor Contrato" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CODCARTEIRA" Caption="Carteira" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="EMPRESA" Caption="CNPJ Empresa" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="NOMEEMPRESA" Caption="Nome Empresa" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DIAANIVERSARIO" Caption="Dia Aniversário" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="VALOROPERACAO" Caption="Saldo do Contrato" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="VALORMENSAL" Caption="Valor da Parcela" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DATA1PARCELA" Caption="Data 1ª Parcela" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="NPARCELAS" Caption="Nr. Parcelas" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="INTERVALODIAS" Caption="Intervalo em dias" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="TAXAJUROS" Caption="Taxa Juros (a.a)" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="MOEDA" Caption="Moeda" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DESCINDEXADOR" Caption="Indexador" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="FORREAJUSTE" Caption="Fórmula Reajuste" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PERREAJUSTE" Caption="Período Reajuste" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PESSOAFJ" Caption="Personalidade Jurídica" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ALIQPIS" Caption="Alíquota PIS" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ALIQCOFINS" Caption="Alíquota COFINS" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="REAJUSTE" Caption="Reajuste de Locação" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DTREAJUSTE" Caption="Data de Reajuste" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PERCENTUAL" Caption="Percentual Reajuste" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ALUGUELEXTRA" Caption="Aluguel Extra" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="MESEXTRA" Caption="Mes do Aluguel Extra" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DATALIBERIFRS" Caption="Data Liberação IFRS" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ATR" Caption="Valor do ATR" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CARENCIADIAS" Caption="Carencia em Dias" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="NPARCCARENCIA" Caption="Nr. Parcelas Carencia" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ESCALAPARCELA" Caption="Escala Parcela" ></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ESCALATAXAJUROS" Caption="Escala Taxa Juros (a.a)" ></dx:GridViewDataTextColumn>

                                            </Columns>
                                            <Templates>
                                                <StatusBar>
                                                    <div style="text-align: left">
                                                        <br />
                                                        <dx:ASPxButton ID="btnProcessaCarga" runat="server" AutoPostBack="false" CssClass="btn-using" Text="Processar Importação" OnClick="btnProcessaCarga_Click">
                                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                    </div>
                                                </StatusBar>
                                            </Templates>
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
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
    <asp:Button ID="btnSel" ClientIDMode="Static" CssClass="Loading d-none" OnClick="btnSel_Click" runat="server" Text="Button" />

    <dx:ASPxPopupControl ID="popupImportaExcel" ClientInstanceName="popupImportaExcel" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Importação Excel" Modal="true" Width="600px" Height="250px" ScrollBars="Auto">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row p-0 mt-2">
                        <div class="col-8">
                            <dx:ASPxUploadControl ID="fileImport" ClientInstanceName="fileImport" runat="server" Theme="Material" Width="100%"
                                OnFileUploadComplete="fileImport_FileUploadComplete" BrowseButton-Text="Procurar"
                                UploadMode="Advanced" AutoStartUpload="true" ShowUploadButton="false" ShowProgressPanel="True">
                                <ClientSideEvents FilesUploadComplete="function (s,e) { document.getElementById('btnSel').click(); }" />
                                <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".xls,.xlsx">
                                </ValidationSettings>
                                <ButtonStyle CssClass="btn-using" ForeColor="White" Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></ButtonStyle>
                                <DisabledButtonStyle ForeColor="LightGray"></DisabledButtonStyle>
                            </dx:ASPxUploadControl>
                        </div>
                        <div class="col-4">
                            <asp:Button ID="btnDownloadModelo" runat="server" CssClass="btn-using" Width="120px" Height="33px" Text="Planilha Modelo" OnClick="btnDownloadModelo_Click" />

                        </div>
                    </div>
                    <div class="row p-0">
                        <div class="col-12">
                            <asp:Label ID="lblErrorFileUpload" runat="server" Text="" CssClass="labels text-left text-danger"></asp:Label>
                        </div>
                    </div>
                </div>

            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="Importador Excel" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label8" runat="server" Text="Selecione:"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('pesquisa');" onmouseout="QuickGuide('ini');">
                <dx:ASPxComboBox ID="dropImportador" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" AutoPostBack="true"
                    Theme="Material" Width="100%" OnSelectedIndexChanged="dropImportador_SelectedIndexChanged">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Items>
                        <dx:ListEditItem Text="Contrato Guarda-Chuva" Value="0" />
                        <dx:ListEditItem Text="Cenário ETTJ" Value="1" />
                        <dx:ListEditItem Text="Faturamento Diário" Value="2" />
                        <dx:ListEditItem Text="Carga Contratos" Value="3" />
                    </Items>
                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
            </div>
        </div>
    </div>
</asp:Content>
