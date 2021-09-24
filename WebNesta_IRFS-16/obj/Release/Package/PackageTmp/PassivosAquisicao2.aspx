<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PassivosAquisicao2.aspx.cs" Inherits="WebNesta_IRFS_16.PassivosAquisicao2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function OnContextMenuItemClick(sender, e) {
            if (e.item.name == 'XLS' || e.item.name == 'CSV') {
                e.processOnServer = true;
                e.usePostBack = true;
            }
        }
    </script>
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'quick1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao2.contabil_quick_guide1%>';
                    break;
                case 'quick2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao2.contabil_quick_guide2%>';
                    break;
                case 'quick3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao2.contabil_quick_guide3%>';
                    break;
                case 'quick4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao2.contabil_quick_guide4%>';
                    break;
                case 'quick5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao2.contabil_quick_guide5%>';
                    break;
                case 'quick6':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao2.contabil_quick_guide6%>';
                    break;
                case 'quick7':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao2.contabil_quick_guide7%>';
                    break;
            }

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfMsgException" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_exception %>" />
    <asp:HiddenField ID="hfMsgSuccess" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_success %>" />
    <asp:HiddenField ID="hfOPIDCONT" runat="server" />
    <asp:HiddenField ID="hfMasterRow" runat="server" />
    <asp:HiddenField ID="hfPaisUser" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfMultiProcSelect" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfTituloPag" Value="Contábil" runat="server" />
    <asp:Label ID="lblSucesso" runat="server" Text="Processamento realizado com sucesso!" Visible="false"></asp:Label>
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:PassivosAquisicao2, contabil_content_tutorial %>" />
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

            <div class="col-sm-10 pl-5 pr-0">
                <div class="row w-100 m-0">
                    <asp:Panel ID="pnlInfoContrato" runat="server" Width="100%">
                        <div class="row pt-0 mt-0 pl-2">
                            <h5>
                                <asp:Label ID="Label16" runat="server" CssClass="labels text-left mr-2" Text="<%$ Resources:PassivosAquisicao2, contabil_tituloPag %>"></asp:Label></h5>
                            <h5>
                                <%--<asp:Label ID="lblOPIDCONT" Visible="false" runat="server" CssClass="labels text-left ml-2" Text=" <%$ Resources:PassivosAquisicao2, contabil_top1 %>"></asp:Label>--%>
                                <asp:Label ID="txtOPIDCONT" CssClass="labels ml-2" runat="server" Text=""></asp:Label></h5>
                        </div>
                        <div class="row pt-0 mt-0 pl-2" onmouseover="QuickGuide('quick7');">
                            <div class="col-x1 p-0">
                                <asp:Label ID="Label1" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao2, contabil_top2 %>"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtOper" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="col-x1 p-0">
                                <asp:Label ID="Label2" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao2, contabil_top3 %>"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtIndice" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="col-x1 p-0">
                                <asp:Label ID="Label3" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao2, contabil_top4 %>"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtDesc" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="col-x1 p-0">
                                <asp:Label ID="Label4" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao2, contabil_top5 %>"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtContra" Width="100%" runat="server" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                    </asp:Panel>
                    <div class="row pt-0 mt-0 pl-2">
                        <asp:MultiView ID="MultiView1" runat="server">
                            <asp:View ID="ViewContratos" runat="server">
                                <div class="card bg-transparent w-100">
                                    <div class="card-header bg-transparent border-0 p-0">
                                        <h5>
                                            <asp:Label ID="Label7" runat="server" Text="<%$ Resources:PassivosAquisicao2, contabil_card1_titulo1 %>"></asp:Label></h5>
                                    </div>
                                    <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick2');">
                                        <div style="display: none">
                                            <asp:Button ID="btnSelect1" CausesValidation="false" ClientIDMode="Static" CssClass="Loading" OnClick="btnSelect1_Click" runat="server" Text="Button" />
                                            <asp:Button ID="btnSelect3" CausesValidation="false" ClientIDMode="Static" CssClass="Loading" OnClick="btnSelect3_Click" runat="server" Text="Button" />
                                        </div>
                                        <dx:ASPxGridView ID="ASPxGridView1" CssClass="bg-transparent" ClientInstanceName="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" Theme="Material" Width="800px"
                                            OnDetailRowGetButtonVisibility="ASPxGridView1_DetailRowGetButtonVisibility" KeyFieldName="OPIDCONT">
                                            <ClientSideEvents RowDblClick="function(s, e) { document.getElementById('btnSelect1').click() }" />
                                            <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" HorizontalScrollBarMode="Auto"></Settings>
                                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                            <SettingsBehavior AllowFocusedRow="True" />
                                            <SettingsResizing ColumnResizeMode="Control" Visualization="Postponed" />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsDetail AllowOnlyOneMasterRowExpanded="true" ShowDetailButtons="true" ShowDetailRow="true" />
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
                                                <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png">
                                                </DetailExpandedButton>
                                                <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                            </Images>
                                            <Columns>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna1 %>" Width="80px" MaxWidth="80" FieldName="OPIDCONT" VisibleIndex="0">
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" ValueField="OPIDCONT" TextField="OPIDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="0" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="Loja" Width="100px" MaxWidth="100" FieldName="TVIDESTR" VisibleIndex="1">
                                                    <PropertiesComboBox DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="1" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna2 %>" Width="100px" MaxWidth="100" FieldName="OPCDCONT" VisibleIndex="2">
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPCDCONT" ValueField="OPCDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="1" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna3 %>" Width="200px" MaxWidth="200" FieldName="OPNMCONT" VisibleIndex="4">
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPNMCONT" ValueField="OPNMCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="2" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna4 %>" Width="189px" MaxWidth="189" FieldName="FONMAB20" VisibleIndex="5">
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="FONMAB20" ValueField="FONMAB20" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="3" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna5 %>" Width="80px" MaxWidth="80" FieldName="IENMINEC" VisibleIndex="6">
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="IENMINEC" ValueField="IENMINEC" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="4" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataTextColumn FieldName="prprodes" Caption="Tipologia" Width="130px" MaxWidth="130" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                            </Columns>
                                            <Templates>
                                                <DetailRow>
                                                    <dx:ASPxGridView ID="gridContratoFilho" ClientInstanceName="gridContratoFilho" ClientIDMode="Static" Theme="Material" Width="700px" runat="server" AutoGenerateColumns="False"
                                                        OnBeforePerformDataSelect="gridContratoFilho_BeforePerformDataSelect" DataSourceID="sqlContratoFilho" KeyFieldName="OPIDCONT">
                                                        <ClientSideEvents RowDblClick="function(s, e) { document.getElementById('btnSelect3').click() }" />
                                                        <SettingsPopup>
                                                            <HeaderFilter MinHeight="140px">
                                                            </HeaderFilter>
                                                        </SettingsPopup>
                                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Visible" />
                                                        <SettingsPager Mode="ShowAllRecords">
                                                        </SettingsPager>
                                                        <SettingsBehavior AllowFocusedRow="True" />
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
                                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna1 %>" Width="80px" MaxWidth="80" FieldName="OPIDCONT" VisibleIndex="0">
                                                                <PropertiesComboBox DataSourceID="sqlComboFilter" ValueField="OPIDCONT" TextField="OPIDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                                </PropertiesComboBox>
                                                                <EditFormSettings VisibleIndex="0" />
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataComboBoxColumn Caption="Loja" Width="100px" MaxWidth="100" FieldName="TVIDESTR" VisibleIndex="1">
                                                                <PropertiesComboBox DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                                </PropertiesComboBox>
                                                                <EditFormSettings VisibleIndex="1" />
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna2 %>" Width="100px" MaxWidth="100" FieldName="OPCDCONT" VisibleIndex="2">
                                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPCDCONT" ValueField="OPCDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                                </PropertiesComboBox>
                                                                <EditFormSettings VisibleIndex="1" />
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna3 %>" Width="200px" MaxWidth="200" FieldName="OPNMCONT" VisibleIndex="4">
                                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPNMCONT" ValueField="OPNMCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                                <EditFormSettings VisibleIndex="2" />
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna4 %>" Width="189px" MaxWidth="189" FieldName="FONMAB20" VisibleIndex="5">
                                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="FONMAB20" ValueField="FONMAB20" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                                </PropertiesComboBox>
                                                                <EditFormSettings VisibleIndex="3" />
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card1_coluna5 %>" Width="80px" MaxWidth="80" FieldName="IENMINEC" VisibleIndex="6">
                                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="IENMINEC" ValueField="IENMINEC" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                                </PropertiesComboBox>
                                                                <EditFormSettings VisibleIndex="4" />
                                                            </dx:GridViewDataComboBoxColumn>
                                                            <dx:GridViewDataTextColumn FieldName="prprodes" Caption="Tipologia" Width="130px" MaxWidth="130" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                                        </Columns>
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
                                                            <FocusedRow BackColor="#669999" ForeColor="White"></FocusedRow>
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
                                                </DetailRow>
                                            </Templates>
                                            <Styles>
                                                <DetailButton Paddings-Padding="0px"></DetailButton>
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
                                            <StylesPager CurrentPageNumber-BackColor="#669999"></StylesPager>
                                        </dx:ASPxGridView>
                                        <asp:SqlDataSource runat="server" ID="sqlContratoFilho" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, OP.TVIDESTR, IE.IENMINEC, pr.prprodes
                    FROM OPCONTRA OP,
                         PRPRODUT PR, IEINDECO IE,
                         FOFORNEC FO, TVESTRUT TV 
                    WHERE OP.PRTPIDOP IN(1, 7, 8, 17)  
                    AND PR.IEIDINEC = IE.IEIDINEC
                    AND OP.PRPRODID = PR.PRPRODID 
                    AND OP.FOIDFORN = FO.FOIDFORN 
                    AND OP.TVIDESTR = TV.TVIDESTR 
                    AND EXISTS (SELECT NULL FROM VIOPMODA VI WHERE VI.OPIDCONT=OP.OPIDCONT)
                    AND OP.OPIDAACC=?
					order by OP.OPIDCONT">
                                            <SelectParameters>
                                                <asp:Parameter DefaultValue="" Name="?"></asp:Parameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" EnableCaching="false" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                            SelectCommand="SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, OP.TVIDESTR, IE.IENMINEC, pr.prprodes
                    FROM OPCONTRA OP,
                         PRPRODUT PR, IEINDECO IE,
                         FOFORNEC FO, TVESTRUT TV 
                    WHERE OP.PRTPIDOP IN(1, 7, 8, 17)  
                                AND PR.IEIDINEC = IE.IEIDINEC
                    AND OP.PRPRODID = PR.PRPRODID 
                    AND OP.FOIDFORN = FO.FOIDFORN 
                    AND OP.TVIDESTR = TV.TVIDESTR 
                                            AND EXISTS (SELECT NULL FROM VIOPMODA VI WHERE VI.OPIDCONT=OP.OPIDCONT)
                                AND OP.OPTPTPID not in (99)
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?) 
                                            AND (OP.OPIDAACC IS NULL or (OP.OPIDAACC IS NOT NULL AND OP.OPIDCONT IN (SELECT O2.OPIDCONT FROM OPCONTRA O2 WHERE O2.OPIDCONT=OP.OPIDCONT AND O2.OPTPTPID=91)))
                                            order by OP.OPIDCONT">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:SqlDataSource ID="sqlComboFilter" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, IE.IENMINEC 
                    FROM OPCONTRA OP,
                         PRPRODUT PR, IEINDECO IE,
                         FOFORNEC FO, TVESTRUT TV 
                    WHERE OP.PRTPIDOP IN(1, 7, 8, 17)  
                                AND PR.IEIDINEC = IE.IEIDINEC
                    AND OP.PRPRODID = PR.PRPRODID 
                    AND OP.FOIDFORN = FO.FOIDFORN 
                    AND OP.TVIDESTR = TV.TVIDESTR 
                                            AND EXISTS (SELECT NULL FROM VIOPMODA VI WHERE VI.OPIDCONT=OP.OPIDCONT)
                                AND OP.OPTPTPID not in (99)
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?) 
                                            AND (OP.OPIDAACC IS NULL or (OP.OPIDAACC IS NOT NULL AND OP.OPIDCONT IN (SELECT O2.OPIDCONT FROM OPCONTRA O2 WHERE O2.OPIDCONT=OP.OPIDCONT AND O2.OPTPTPID=91)))
                                            order by OP.OPIDCONT">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:SqlDataSource ID="sqlLoja" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select TV.TVIDESTR,FO.FONMAB20 from TVESTRUT TV, FOFORNEC FO
WHERE TV.TVIDESTR = FO.TVIDESTR
  AND FOTPIDTP=6
ORDER BY 2"></asp:SqlDataSource>
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="ViewFluxoCaixa" runat="server">
                                <div class="card bg-transparent w-100">
                                    <div class="card-header bg-transparent border-0 p-0">
                                        <h5>
                                            <asp:Label ID="Label5" runat="server" Text="<%$ Resources:PassivosAquisicao2, contabil_card2_titulo1 %>"></asp:Label></h5>
                                    </div>
                                    <div class="bg-transparent card-body p-0" onmouseover="QuickGuide('quick6');">

                                        <%--<asp:SqlDataSource ID="sqlFluxoCaixa" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                            SelectCommand="SELECT * FROM (
        SELECT data
            , m.MODSMODA
            , valor
			, opidcont
        FROM fluxo_oper_jesse f
		inner join modalida m on f.moidmoda=m.moidmoda
		where f.opidcont=? and f.valida=1
    ) AS t
    PIVOT (
        MAX(valor)
        FOR MODSMODA IN (?)) as P">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                <asp:Parameter Name="?"></asp:Parameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>--%>
                                        <dx:ASPxGridView ID="gridFluxoCaixa" CssClass="bg-transparent" OnFillContextMenuItems="gridFluxoCaixa_FillContextMenuItems" OnContextMenuItemClick="gridFluxoCaixa_ContextMenuItemClick" runat="server"
                                            AutoGenerateColumns="false" Theme="Material" OnLoad="gridFluxoCaixa_Load" OnDataBinding="gridFluxoCaixa_DataBinding">
                                            <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                            <Settings ShowFilterRow="false" ShowFooter="true" ShowHeaderFilterButton="false" HorizontalScrollBarMode="Auto" VerticalScrollableHeight="265" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                            <SettingsPager Visible="false"></SettingsPager>
                                            <SettingsResizing ColumnResizeMode="NextColumn" Visualization="Postponed" />
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
                                            <Styles>
                                                <Footer Paddings-PaddingTop="3px" Paddings-PaddingBottom="3px" BackColor="#b8cfcf" ForeColor="White">
                                                </Footer>
                                                <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                <Header Font-Names="Arial" Font-Size="10pt" BackColor="#b8cfcf" ForeColor="White" Paddings-Padding="3px">
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
                                        <dx:ASPxGridViewExporter ID="ASPxGridViewExporter1" GridViewID="gridFluxoCaixa" runat="server"></dx:ASPxGridViewExporter>
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="ViewExtratoFinanceiro" runat="server">
                                <div class="card bg-transparent w-100">
                                    <div class="card-header bg-transparent border-0 p-0">
                                        <h5>
                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:PassivosAquisicao2, contabil_card3_titulo1 %>"></asp:Label></h5>
                                    </div>
                                    <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick6');">
                                        <asp:SqlDataSource ID="sqlExtratoFinanc" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                            SelectCommand="SELECT T1.RZDTDATA, T2.MODSMODA RZDSHIST, T1.RZVLDEBI,
       T1.RZVLCRED, T1.RZVLSALD, T1.RZVLCOTA, T1.OPIDCONT
FROM RZRAZCTB_OPER T1, MODALIDA T2
WHERE T1.MOIDMODA = T2.MOIDMODA AND
      T2.MOTPIDCA &lt;&gt; 1 AND OPIDCONT = ?
ORDER BY T1.RZDTDATA, T1.RZNRREGI">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfOPIDCONT" Name="OPIDCONT" PropertyName="Value" Type="Int32" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <dx:ASPxGridView ID="gridExtratoFinanc" CssClass="bg-transparent" DataSourceID="sqlExtratoFinanc" Width="100%" runat="server" OnFillContextMenuItems="gridExtratoFinanc_FillContextMenuItems" OnContextMenuItemClick="gridExtratoFinanc_ContextMenuItemClick" AutoGenerateColumns="False" Theme="Material">
                                            <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                            <Settings ShowFilterRow="false" ShowHeaderFilterButton="false" VerticalScrollableHeight="290" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                            <SettingsPager Visible="false"></SettingsPager>
                                            <Columns>
                                                <dx:GridViewDataDateColumn FieldName="RZDTDATA" VisibleIndex="0" Width="10%" Caption="<%$ Resources:PassivosAquisicao2, contabil_card3_coluna1 %>">
                                                    <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataTextColumn FieldName="RZDSHIST" VisibleIndex="1" Width="40%" Caption="<%$ Resources:PassivosAquisicao2, contabil_card3_coluna2 %>">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RZVLDEBI" VisibleIndex="2" Width="10%" Caption="<%$ Resources:PassivosAquisicao2, contabil_card3_coluna3 %>">
                                                    <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RZVLCRED" VisibleIndex="3" Width="10%" Caption="<%$ Resources:PassivosAquisicao2, contabil_card3_coluna4 %>">
                                                    <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RZVLSALD" VisibleIndex="4" Width="10%" Caption="<%$ Resources:PassivosAquisicao2, contabil_card3_coluna5 %>">
                                                    <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RZVLCOTA" VisibleIndex="6" Width="10%" Caption="<%$ Resources:PassivosAquisicao2, contabil_card3_coluna7 %>">
                                                    <PropertiesTextEdit DisplayFormatString="{0:N6}">
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                            <SettingsContextMenu Enabled="true">
                                                <RowMenuItemVisibility ExportMenu-Visible="true">
                                                    <GroupSummaryMenu SummaryAverage="false" SummaryMax="false" SummaryMin="false" SummarySum="false" />
                                                </RowMenuItemVisibility>
                                            </SettingsContextMenu>
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
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsExport EnableClientSideExportAPI="true">
                                            </SettingsExport>
                                        </dx:ASPxGridView>
                                        <dx:ASPxGridViewExporter ID="ASPxGridViewExporter2" GridViewID="gridExtratoFinanc" runat="server"></dx:ASPxGridViewExporter>
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="ViewContabil" runat="server">
                                <div class="card bg-transparent w-100">
                                    <div class="card-header bg-transparent border-0 p-0">
                                        <h4>
                                            <asp:Label ID="Label9" runat="server" Text="<%$ Resources:PassivosAquisicao2, contabil_card4_titulo1 %>"></asp:Label></h4>
                                    </div>
                                    <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick6');">
                                        <asp:SqlDataSource ID="sqlContabil" EnableCaching="true" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                            SelectCommand="SELECT T1.LBDTLANC, T1.LBTPLANC, T2.PFCDPLNC,
                                                       T2.PFDSPLNC, T3.MODSMODA, T1.LBVLLANC
                                                FROM LBLCTCTB T1
                                                 LEFT OUTER JOIN  PFPLNCTA T2 ON (T1.PFIDPLNC = T2.PFIDPLNC) 
                                                 INNER JOIN MODALIDA T3 ON (T1.MOIDMODA = T3.MOIDMODA) 
                                                WHERE   T1.MOIDMODA = T3.MOIDMODA
                                                  AND T1.OPIDCONT = ?
                                                ORDER BY LBDTLANC, T3.MOIDMODA, T1.LBTPLANC,
                                                         T2.PFCDPLNC">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfOPIDCONT" Name="OPIDCONT" PropertyName="Value" Type="Int32" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <dx:ASPxGridView ID="gridContabil" CssClass="bg-transparent" Width="100%" runat="server" OnFillContextMenuItems="gridContabil_FillContextMenuItems" OnContextMenuItemClick="gridContabil_ContextMenuItemClick" AutoGenerateColumns="False" Theme="Material" DataSourceID="sqlContabil">
                                            <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                            <Settings ShowFilterRow="false" ShowHeaderFilterButton="false" VerticalScrollableHeight="290" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                            <SettingsPager Visible="false"></SettingsPager>
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
                                            <Columns>
                                                <dx:GridViewDataDateColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card4_coluna1 %>" FieldName="LBDTLANC" VisibleIndex="0">
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card4_coluna2 %>" FieldName="LBTPLANC" VisibleIndex="1" Width="50px">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card4_coluna3 %>" FieldName="PFCDPLNC" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card4_coluna4 %>" FieldName="PFDSPLNC" VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card4_coluna5 %>" FieldName="MODSMODA" VisibleIndex="4">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card4_coluna6 %>" FieldName="LBVLLANC" VisibleIndex="5">
                                                    <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG">
                                            </SettingsExport>
                                            <SettingsContextMenu Enabled="true">
                                                <RowMenuItemVisibility ExportMenu-Visible="true">
                                                    <GroupSummaryMenu SummaryAverage="false" SummaryMax="false" SummaryMin="false" SummarySum="false" />
                                                </RowMenuItemVisibility>
                                            </SettingsContextMenu>
                                        </dx:ASPxGridView>
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="viewMultiProc" runat="server">
                                <div class="card bg-transparent w-100">
                                    <div class="card-header bg-transparent border-0 p-0">
                                        <h4>
                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:PassivosAquisicao2, contabil_card5_titulo1 %>"></asp:Label></h4>
                                    </div>
                                    <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick2');">
                                        <div style="display: none">
                                            <asp:Button ID="btnSelect2" OnClick="btnSelect2_Click" ClientIDMode="Static" CssClass="Loading" CausesValidation="false" runat="server" Text="Button" />
                                        </div>
                                        <dx:ASPxGridView ID="ASPxGridView2" CssClass="bg-transparent" Width="800px" KeyFieldName="OPIDCONT" ClientInstanceName="ASPxGridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" OnCustomCallback="ASPxGridView2_CustomCallback" Theme="Material">
                                            <Settings ShowFilterRow="True"></Settings>
                                            <SettingsBehavior ProcessSelectionChangedOnServer="false" AllowSelectByRowClick="true" AllowFocusedRow="True" />
                                            <Settings HorizontalScrollBarMode="Auto" ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="290" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                            <SettingsPager Visible="false"></SettingsPager>
                                            <SettingsResizing ColumnResizeMode="Control" Visualization="Postponed" />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <Images>
                                                <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                            </Images>
                                            <Columns>
                                                <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0" Width="50px" MaxWidth="50"></dx:GridViewCommandColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card5_coluna1 %>" Width="100px" MaxWidth="100" FieldName="OPIDCONT" VisibleIndex="1">
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" ValueField="OPIDCONT" TextField="OPIDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <Settings AllowAutoFilter="True" />
                                                    <EditFormSettings VisibleIndex="0" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="Loja" Width="150px" MaxWidth="150" FieldName="TVIDESTR" VisibleIndex="2">
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="1" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card5_coluna2 %>" Width="100px" MaxWidth="100" FieldName="OPCDCONT" VisibleIndex="3">
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPCDCONT" ValueField="OPCDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="1" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card5_coluna3 %>" Width="300px" MaxWidth="300" FieldName="OPNMCONT" VisibleIndex="5">
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPNMCONT" ValueField="OPNMCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="2" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card5_coluna4 %>" Width="250px" MaxWidth="250" FieldName="FONMAB20" VisibleIndex="6">
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="FONMAB20" ValueField="FONMAB20" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="3" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao2, contabil_card5_coluna5 %>" Width="130px" MaxWidth="130" FieldName="IENMINEC" VisibleIndex="7">
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="IENMINEC" ValueField="IENMINEC" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="4" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataTextColumn FieldName="prprodes" Caption="Tipologia" Width="130px" MaxWidth="130" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                            </Columns>
                                            <ClientSideEvents SelectionChanged="function onSelectionChangedClick(s,e) { 
                                    var cont = s.GetSelectedRowCount(); 
                                    if(cont!=0)
                                    {
                                        itemlist_toolbar.SetEnabled(true);
                                    }
                                    else if(cont==0)
                                    {
                                        itemlist_toolbar.SetEnabled(false);
                                        itemlist_toolbar.SetSelectedIndex(-1);
                                        document.getElementById('btnSelect2').click();
                                    }
                                    var nstr = '('+cont.toString()+')';
                                    lblClearSelection.SetText(nstr);                                   
                                     }"
                                                Init="function onInit(s,e) { 
                                    var cont = s.GetSelectedRowCount();                                    
                                    var nstr = '('+cont.toString()+')';
                                    lblClearSelection.SetText(nstr);                                   
                                     }" />
                                            <Toolbars>
                                                <dx:GridViewToolbar Name="ToolProcess">
                                                    <Items>
                                                        <dx:GridViewToolbarItem ItemStyle-Height="40px" Name="Item" ItemStyle-Width="100%" Alignment="Left">
                                                            <Template>
                                                                <div class="container-fluid">
                                                                    <div class="row">
                                                                        <div class="col-3" style="margin: auto 0">

                                                                            <dx:ASPxHyperLink ID="lnkClearSelection" ClientIDMode="Static" ClientInstanceName="lnkClearSelection" ClientEnabled="true" Cursor="pointer" CssClass="labels" runat="server" Text="<%$ Resources:PassivosAquisicao2, contabil_card5_btn4 %>" ClientSideEvents-Click="function OnUnselectAllRowsLinkClick() {
            ASPxGridView2.UnselectRows();
        }">
                                                                            </dx:ASPxHyperLink>
                                                                            <dx:ASPxLabel ID="lblClearSelection" ClientEnabled="true" ClientIDMode="Static" ClientInstanceName="lblClearSelection" CssClass="labels" runat="server" Text="(0)" Style="padding-left: 2px"></dx:ASPxLabel>
                                                                        </div>
                                                                        <div class="col-9" style="margin: auto 0">
                                                                            <dx:ASPxRadioButtonList ID="itemlist_toolbar" Paddings-Padding="0px" ClientIDMode="Static" ClientInstanceName="itemlist_toolbar" Height="40px" runat="server" ValueType="System.String" ForeColor="dimgray" Width="100%" CssClass="labels m-0 p-0" Theme="Moderno" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default">
                                                                                <ClientSideEvents SelectedIndexChanged="function OnClickItem(s, e) {    
                                                                        document.getElementById('hfMultiProcSelect').value=null;
                                                                        document.getElementById('hfMultiProcSelect').value=itemlist_toolbar.GetSelectedItem().value;
                                                                        document.getElementById('btnSelect2').click();}"
                                                                                    Init="function onInit2(s,e) { 
                                                            var cont = ASPxGridView2.GetSelectedRowCount();
                                                            if(cont!=0)
                                                        {
                                                            itemlist_toolbar.SetEnabled(true);
                                                        }
                                                            else if(cont==0)
                                                            {
                                                            itemlist_toolbar.SetEnabled(false); 
                                                            itemlist_toolbar.SetSelectedIndex(-1); 
                                                            }
                                     }" />
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo2 %>" Value="fluxo" />
                                                                                    <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo3 %>" Value="extrato" />
                                                                                    <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo4 %>" Value="contabil" />
                                                                                    <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo5 %>" Value="rescisao" />
                                                                                    <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo6 %>" Value="repactuacao" />
                                                                                </Items>
                                                                                <CheckedImage Url="icons/checked.png" Height="30px" Width="30px"></CheckedImage>
                                                                                <UncheckedImage Url="icons/unchecked.png" Height="30px" Width="30px"></UncheckedImage>
                                                                                <DisabledStyle CssClass="disRbtn"></DisabledStyle>
                                                                            </dx:ASPxRadioButtonList>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </Template>
                                                        </dx:GridViewToolbarItem>
                                                    </Items>
                                                </dx:GridViewToolbar>
                                            </Toolbars>
                                            <StylesToolbar Item-Height="40px">
                                            </StylesToolbar>
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
                            </asp:View>
                        </asp:MultiView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="row card mt-3 pl-2" style="margin: 0 auto">
        <div class="card-header p-0 text-left">
            <h5>
                <asp:Label ID="Label33" runat="server" Text="<%$ Resources:PassivosAquisicao2, contabil_right_titulo1 %>" CssClass="labels text-left"></asp:Label></h5>
        </div>
    </div>
    <div class="row mt-3 pl-2" style="margin: 0 auto">
        <h6>
            <asp:Label ID="Label13" runat="server" CssClass="labels mt-2" Text="<%$ Resources:PassivosAquisicao2, contabil_right_titulo2 %>"></asp:Label></h6>
        <div class="input-group" onmouseover="QuickGuide('quick1');">
            <dx:ASPxCheckBox ID="ASPxCheckBox1" runat="server" CssClass="labels" Font-Size="12pt" Text="<%$ Resources:PassivosAquisicao2, contabil_right_checkbox1 %>" AutoPostBack="true" OnCheckedChanged="ASPxCheckBox1_CheckedChanged"></dx:ASPxCheckBox>
        </div>
    </div>
    <div class="row mt-3 pl-2" style="margin: 0 auto">
        <asp:Panel ID="pnlNavegacao" Width="100%" runat="server" Visible="true">
            <h6>
                <asp:Label ID="Label8" runat="server" CssClass="labels" Text="<%$ Resources:PassivosAquisicao2, contabil_right_titulo3 %>"></asp:Label></h6>
            <div class="input-group mb-auto" onmouseover="QuickGuide('quick4');">
                <dx:ASPxComboBox ID="dropMultiView" Enabled="false" ForeColor="dimgray" AllowInputUser="false" AutoPostBack="true" OnSelectedIndexChanged="dropMultiView_SelectedIndexChanged" runat="server" CssClass="drop-down2" Theme="Material" Width="100%">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                    <ItemStyle HoverStyle-BackColor="#669999" HoverStyle-ForeColor="White" SelectedStyle-BackColor="#669999" SelectedStyle-ForeColor="White" />
                    <Items>
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo1 %>" Value="0" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo2 %>" Value="1" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo3 %>" Value="2" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_combo4 %>" Value="3" />
                    </Items>
                </dx:ASPxComboBox>
            </div>
        </asp:Panel>
    </div>
    <div class="row mt-3 pl-2" style="margin: 0 auto">
        <asp:Panel ID="pnlProcFluxo" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;" onmouseover="QuickGuide('quick5');">
                <asp:Button ID="btnProcFluxo" CssClass="Loading btn-using" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnProcFluxo_Click" OnLoad="btnProcFluxo_Load" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlProcExtrato" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <dx:ASPxRadioButtonList ID="ASPxRadioButtonList1" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="Moderno" runat="server" ValueType="System.String" AutoPostBack="True" OnSelectedIndexChanged="ASPxRadioButtonList1_SelectedIndexChanged" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default">
                            <Items>
                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_checkbox2 %>" Value="2" />
                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao2, contabil_right_checkbox3 %>" Value="1" />
                            </Items>
                        </dx:ASPxRadioButtonList>
                        <asp:Label ID="lblDataExtrato" runat="server" CssClass="labels text-left" Visible="false" Text="<%$ Resources:PassivosAquisicao2, contabil_right_date %>"></asp:Label>
                        <div class="input-group mb-1">
                            <dx:ASPxDateEdit ID="txtDataExtrato" Visible="false" Enabled="true" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="ASPxRadioButtonList1" />
                    </Triggers>
                </asp:UpdatePanel>
                <asp:Label ID="Label12" runat="server" CssClass="labels text-left" Text=""></asp:Label>
                <div class="input-group mb-auto" onmouseover="QuickGuide('quick5');">
                    <asp:Button ID="btnProcExtrato" CssClass="btn-using Loading" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnProcExtrato_Click" OnLoad="btnProcExtrato_Load" />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlProcContab" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <asp:Label ID="lblDataConta" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao2, contabil_right_date %>"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDataConta" ForeColor="Red" ErrorMessage="*"></asp:RequiredFieldValidator>
                <div class="input-group mb-2">
                    <dx:ASPxDateEdit ID="txtDataConta" Visible="true" Enabled="true" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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

                <asp:Label ID="Label11" runat="server" CssClass="label text-left" Text=""></asp:Label>
                <div class="input-group mb-2" onmouseover="QuickGuide('quick5');">
                    <asp:Button ID="btnProcContab" CssClass="btn-using" CausesValidation="true" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnProcContab_Click" OnLoad="btnProcContab_Load" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
