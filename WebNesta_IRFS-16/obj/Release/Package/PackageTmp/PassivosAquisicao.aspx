<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="True" EnableEventValidation="false" CodeBehind="PassivosAquisicao.aspx.cs" Inherits="WebNesta_IRFS_16.PassivosAquisicaoDevExpress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var indexRadioFiltro;
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
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide1%>';
                    break;
                case 'quick2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide2%>';
                    break;
                case 'quick3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide3%>';
                    break;
                case 'quick4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide4%>';
                    break;
                case 'quick5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide5%>';
                    break;
                case 'quick6':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide6%>';
                    break;
                case 'quick7':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide7%>';
                    break;
                case 'quick8':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PassivosAquisicao.contabil_quick_guide8%>';
                    break;
            }

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfMsgException" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_exception %>" />
    <asp:HiddenField ID="hfMsgSuccess" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_success %>" />
    <asp:HiddenField ID="hfOPIDCONT" runat="server" />
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:PassivosAquisicao, contabil_content_tutorial %>" />
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

            <div class="col-sm-10" style="padding-left: 40px">
                <asp:Panel ID="pnlInfoContrato" runat="server" Width="100%">
                    <div class="row pt-0 mt-0 pl-2">
                        <h5 class="mb-0">
                            <asp:Label ID="Label16" runat="server" CssClass="labels text-left mr-2" Text="<%$ Resources:PassivosAquisicao, contabil_tituloPag %>"></asp:Label></h5>
                        <h5 class="mb-0">
                            <%--<asp:Label ID="lblOPIDCONT" Visible="false" runat="server" CssClass="labels text-left ml-2" Text=" <%$ Resources:PassivosAquisicao, contabil_top1 %>"></asp:Label>--%>
                            <asp:Label ID="txtOPIDCONT" CssClass="labels ml-2" runat="server" Text=""></asp:Label></h5>
                    </div>
                    <div class="row pt-0 mt-0 pl-2" onmouseover="QuickGuide('quick7');">
                        <div class="col-x1 p-0">
                            <asp:Label ID="Label1" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_top2 %>"></asp:Label>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtOper" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x1 p-0">
                            <asp:Label ID="Label2" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_top3 %>"></asp:Label>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtDesc" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x1 p-0">
                            <asp:Label ID="Label3" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_top4 %>"></asp:Label>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtContra" Width="100%" runat="server" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x1 p-0">
                            <br />
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="TextBox1" Width="100%" runat="server" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="row pt-0 mt-0 pl-2" onmouseover="QuickGuide('quick7');">
                        <div class="col-x1 p-0">
                            <asp:Label ID="Label21" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_top5 %>"></asp:Label>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtIndice" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x1 p-0">
                            <asp:Label ID="Label22" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_top6 %>"></asp:Label>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtIndice2" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x1 p-0">
                            <asp:Label ID="Label23" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_top7 %>"></asp:Label>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtIndice3" runat="server" Width="100%" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x1 p-0">
                            <br />
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="TextBox4" Width="100%" runat="server" CssClass="text-boxes" Enabled="false"></asp:TextBox>
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
                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card1_titulo1 %>"></asp:Label></h5>
                                </div>
                                <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick2');">
                                    <div style="display: none">
                                        <asp:Button ID="btnSelect1" CausesValidation="false" ClientIDMode="Static" CssClass="Loading" OnClick="btnSelect1_Click" runat="server" Text="Button" />
                                    </div>
                                    <dx:ASPxGridView ID="ASPxGridView1" EnableRowsCache="true" CssClass="bg-transparent" ClientInstanceName="ASPxGridView1" runat="server" AutoGenerateColumns="False" Theme="Material" Width="800px">
                                        <ClientSideEvents RowDblClick="function(s, e) { document.getElementById('btnSelect1').click() }" />
                                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" HorizontalScrollBarMode="Auto"></Settings>
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
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna1 %>" Width="80px" MaxWidth="80" FieldName="OPIDCONT" VisibleIndex="0">
                                                <%--<DataItemTemplate>
                                            <div style="width: 50px; overflow: hidden"><%#Container.Text%></div>
                                        </DataItemTemplate>--%>
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" ValueField="OPIDCONT" TextField="OPIDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <Settings AllowAutoFilter="True" />
                                                <EditFormSettings VisibleIndex="0" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna6 %>" Width="150px" MaxWidth="150" FieldName="TVIDESTR" VisibleIndex="1">
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="1" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna2 %>" Width="100px" MaxWidth="100" FieldName="OPCDCONT" VisibleIndex="2">
                                                <%--<DataItemTemplate>
                                            <div style="width: 100px; overflow: hidden"><%#Container.Text%></div>
                                        </DataItemTemplate>--%>
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPCDCONT" ValueField="OPCDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="1" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna3 %>" Width="200px" MaxWidth="200" FieldName="OPNMCONT" VisibleIndex="4">
                                                <%--<DataItemTemplate>
                                            <div style="width: 300px; overflow: hidden"><%#Container.Text%></div>
                                        </DataItemTemplate>--%>
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPNMCONT" ValueField="OPNMCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="2" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna4 %>" Width="189px" MaxWidth="189" FieldName="FONMAB20" VisibleIndex="5">
                                                <%--<DataItemTemplate>
                                            <div style="width: 200px; overflow: hidden"><%#Container.Text%></div>
                                        </DataItemTemplate>--%>
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="FONMAB20" ValueField="FONMAB20" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="3" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna5 %>" Width="80px" MaxWidth="80" FieldName="IENMINEC" VisibleIndex="6">
                                                <%--<DataItemTemplate>
                                            <div style="width: 50px; overflow: hidden"><%#Container.Text%></div>
                                        </DataItemTemplate>--%>
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="IENMINEC" ValueField="IENMINEC" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="4" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="prprodes" Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna7 %>" Width="130px" MaxWidth="130" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="OPCDAUXI" Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna8 %>" Width="130px" MaxWidth="130" VisibleIndex="3"></dx:GridViewDataTextColumn>
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
                                        <StylesPager CurrentPageNumber-BackColor="#669999"></StylesPager>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" EnableCaching="false" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                        SelectCommand="SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, IE.IENMINEC, OP.TVIDESTR,PR.prprodes,OP.OPCDAUXI
                    FROM OPCONTRA OP,
                         PRPRODUT PR, IEINDECO IE,
                         FOFORNEC FO, TVESTRUT TV 
                    WHERE OP.PRTPIDOP IN(1, 7, 8, 17)  
                                AND PR.IEIDINEC = IE.IEIDINEC
                    AND OP.PRPRODID = PR.PRPRODID 
                    AND OP.FOIDFORN = FO.FOIDFORN 
                    AND OP.TVIDESTR = TV.TVIDESTR 
                                AND OP.OPTPTPID not in (99)
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?)">
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
                                AND OP.OPTPTPID not in (99)
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?)">
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
                                    <div class="row">
                                        <div class="col-3 m-auto">
                                            <h5>
                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card2_titulo1 %>"></asp:Label></h5>
                                        </div>
                                        <div class="col-7 m-auto" onmouseover="QuickGuide('quick8');">
                                            <dx:ASPxRadioButtonList ID="radioFiltroFluxo" ClientInstanceName="radioFiltroFluxo" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="MaterialCompact" runat="server"
                                                ValueType="System.String" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default" Paddings-Padding="0px"
                                                OnLoad="radioFiltroFluxo_Load">
                                                <ClientSideEvents SelectedIndexChanged="function(s,e) { 
                                                    if(s.GetValue()==0)
                                                    {
                                                        s.SetSelectedIndex(indexRadioFiltro);
                                                    }
                                                    else
                                                    {
                                                    gridFluxoCaixa.PerformCallback(s.GetValue()); 
                                                    }
                                                    }"
                                                    GotFocus="function(s,e){
                                                    indexRadioFiltro = s.GetSelectedIndex();
                                                    }" />
                                            </dx:ASPxRadioButtonList>
                                        </div>
                                    </div>
                                </div>
                                <div class="bg-transparent card-body p-0" onmouseover="QuickGuide('quick5');">
                                    <asp:HiddenField ID="hfTabelaFluxo" runat="server" />
                                    <%--<asp:SqlDataSource ID="sqlFluxoCaixa" EnableCaching="false" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                        SelectCommand="SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO],[PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [PHPLANIF] WHERE ([OPIDCONT] = ?) ORDER BY [PHNRPARC], [PHDTEVEN]"
                                        
                                        >
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfOPIDCONT" Name="OPIDCONT" PropertyName="Value" Type="Int32" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>--%>
                                    <dx:ASPxGridView ID="gridFluxoCaixa" EnableRowsCache="false" ClientInstanceName="gridFluxoCaixa" CssClass="bg-transparent" OnFillContextMenuItems="gridFluxoCaixa_FillContextMenuItems" OnContextMenuItemClick="gridFluxoCaixa_ContextMenuItemClick"
                                        OnCustomCallback="gridFluxoCaixa_CustomCallback" Width="100%" runat="server" AutoGenerateColumns="False" Theme="Material">
                                        <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="220" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
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
                                        <Images>
                                            <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                        </Images>
                                        <Columns>
                                            <dx:GridViewDataDateColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna1 %>" Width="90px" FieldName="PHDTEVEN" VisibleIndex="0">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna2 %>" Width="90px" FieldName="PHDTPAGT" VisibleIndex="1">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna3 %>" Width="40px" FieldName="PHNMSEQU" VisibleIndex="2">
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna4 %>" Width="40px" FieldName="PHNRPARC" VisibleIndex="3">
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna5 %>" Width="40px" FieldName="PHNRDIAS" VisibleIndex="4">
                                                <CellStyle HorizontalAlign="Center"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna6 %>" Width="90px" FieldName="PHVLDEVE" VisibleIndex="5">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna7 %>" Width="90px" FieldName="PHVLAMOR" VisibleIndex="6">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna8 %>" FieldName="PHVLJURO" Width="50px" VisibleIndex="7">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna9 %>" FieldName="PHVLCOMI" Width="50px" Visible="false" VisibleIndex="8">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}" ConvertEmptyStringToNull="False" NullDisplayText="0,00">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna10 %>" FieldName="PHVLSPRE" Width="50px" Visible="false" VisibleIndex="9">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}" ConvertEmptyStringToNull="False" NullDisplayText="0,00">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna11 %>" FieldName="PHVLENC1" Width="50px" Visible="false" VisibleIndex="10">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}" ConvertEmptyStringToNull="False" NullDisplayText="0,00">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna12 %>" FieldName="PHVLENC2" Width="50px" Visible="false" VisibleIndex="11">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}" ConvertEmptyStringToNull="False" NullDisplayText="0,00">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna13 %>" FieldName="PHVLIPRE" Width="50px" VisibleIndex="12">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}" ConvertEmptyStringToNull="False" NullDisplayText="0,00">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card2_coluna14 %>" FieldName="PHVLTOTA" Width="70px" VisibleIndex="13">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="OPIDCONT" Visible="False" VisibleIndex="14">
                                                <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                                </PropertiesTextEdit>
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
                                    <dx:ASPxGridViewExporter ID="ASPxGridViewExporter1" GridViewID="gridFluxoCaixa" runat="server"></dx:ASPxGridViewExporter>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="ViewExtratoFinanceiro" runat="server">
                            <div class="card bg-transparent w-100">
                                <div class="card-header bg-transparent border-0 p-0">
                                    <div class="row">
                                        <div class="col-3 m-auto">
                                            <h5>
                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card3_titulo1 %>"></asp:Label></h5>
                                        </div>
                                        <div class="col-7 m-auto" onmouseover="QuickGuide('quick8');">
                                            <dx:ASPxRadioButtonList ID="radioFiltroExtrato" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="MaterialCompact" runat="server"
                                                ValueType="System.String" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default" Paddings-Padding="0px"
                                                OnLoad="radioFiltroExtrato_Load">
                                                <ClientSideEvents SelectedIndexChanged="function(s,e) { 
                                                    if(s.GetValue()==0)
                                                    {
                                                        s.SetSelectedIndex(indexRadioFiltro);
                                                    }
                                                    else
                                                    {
                                                    gridExtratoFinanc.PerformCallback(s.GetValue()); 
                                                    }
                                                    }"
                                                    GotFocus="function(s,e){
                                                    indexRadioFiltro = s.GetSelectedIndex();
                                                    }" />
                                            </dx:ASPxRadioButtonList>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick5');">
                                    <asp:HiddenField ID="hfTabelaExtrato" runat="server" />
                                    <dx:ASPxGridView ID="gridExtratoFinanc" EnableRowsCache="false" ClientInstanceName="gridExtratoFinanc" CssClass="bg-transparent" Width="100%" runat="server" OnDataBound="gridExtratoFinanc_DataBound"
                                        OnFillContextMenuItems="gridExtratoFinanc_FillContextMenuItems" OnContextMenuItemClick="gridExtratoFinanc_ContextMenuItemClick" OnCustomCallback="gridExtratoFinanc_CustomCallback" AutoGenerateColumns="False" Theme="Material">
                                        <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                        <SettingsPager Visible="false"></SettingsPager>
                                        <SettingsResizing ColumnResizeMode="NextColumn" Visualization="Postponed" />
                                        <Images>
                                            <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                        </Images>
                                        <Columns>
                                            <dx:GridViewDataDateColumn FieldName="RZDTDATA" VisibleIndex="0" Width="10%" Caption="<%$ Resources:PassivosAquisicao, contabil_card3_coluna1 %>">
                                                <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                </PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="RZDSHIST" VisibleIndex="1" Width="40%" Caption="<%$ Resources:PassivosAquisicao, contabil_card3_coluna2 %>">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="RZVLDEBI" VisibleIndex="2" Width="10%" Caption="<%$ Resources:PassivosAquisicao, contabil_card3_coluna3 %>">
                                                <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="RZVLCRED" VisibleIndex="3" Width="10%" Caption="<%$ Resources:PassivosAquisicao, contabil_card3_coluna4 %>">
                                                <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="RZVLSALD" VisibleIndex="4" Width="10%" Caption="<%$ Resources:PassivosAquisicao, contabil_card3_coluna5 %>">
                                                <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="RZVLPRIN" VisibleIndex="5" Width="10%" Caption="<%$ Resources:PassivosAquisicao, contabil_card3_coluna6 %>">
                                                <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="RZVLCOTA" VisibleIndex="6" Width="10%" Caption="<%$ Resources:PassivosAquisicao, contabil_card3_coluna7 %>">
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
                                    <div class="row">
                                        <div class="col-3 m-auto">
                                            <h4>
                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card4_titulo1 %>"></asp:Label></h4>
                                        </div>
                                        <div class="col-7 m-auto" onmouseover="QuickGuide('quick8');">


                                            <dx:ASPxRadioButtonList ID="radioFiltroContab" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="MaterialCompact" runat="server"
                                                ValueType="System.String" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default" Paddings-Padding="0px"
                                                OnLoad="radioFiltroContab_Load">
                                                <ClientSideEvents SelectedIndexChanged="function(s,e) { 
                                                    if(s.GetValue()==0)
                                                    {
                                                        s.SetSelectedIndex(indexRadioFiltro);
                                                    }
                                                    else
                                                    {
                                                    gridContabil.PerformCallback(s.GetValue()); 
                                                    }
                                                    }"
                                                    GotFocus="function(s,e){
                                                    indexRadioFiltro = s.GetSelectedIndex();
                                                    }" />

                                            </dx:ASPxRadioButtonList>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick5');">
                                    <asp:HiddenField ID="hfTabelaContab" runat="server" />
                                    <dx:ASPxGridView ID="gridContabil" ClientInstanceName="gridContabil" CssClass="bg-transparent" Width="100%" runat="server" OnFillContextMenuItems="gridContabil_FillContextMenuItems"
                                        OnContextMenuItemClick="gridContabil_ContextMenuItemClick" EnableRowsCache="false" AutoGenerateColumns="False" Theme="Material" OnCustomCallback="gridContabil_CustomCallback">
                                        <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                        <SettingsPager Visible="false"></SettingsPager>
                                        <SettingsResizing ColumnResizeMode="NextColumn" Visualization="Postponed" />
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
                                        <Columns>
                                            <dx:GridViewDataDateColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card4_coluna1 %>" FieldName="LBDTLANC" VisibleIndex="0">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card4_coluna2 %>" FieldName="LBTPLANC" VisibleIndex="1" Width="50px">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card4_coluna3 %>" FieldName="PFCDPLNC" VisibleIndex="2">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card4_coluna4 %>" FieldName="PFDSPLNC" VisibleIndex="3">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card4_coluna5 %>" FieldName="MODSMODA" VisibleIndex="4">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card4_coluna6 %>" FieldName="LBVLLANC" VisibleIndex="5">
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
                                        <asp:Label ID="Label14" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card5_titulo1 %>"></asp:Label></h4>
                                </div>
                                <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick6');">
                                    <div style="display: none">
                                        <asp:Button ID="btnSelect2" OnClick="btnSelect2_Click" ClientIDMode="Static" CssClass="Loading" CausesValidation="false" runat="server" Text="Button" />
                                    </div>
                                    <dx:ASPxGridView ID="ASPxGridView2" EnableRowsCache="true" CssClass="bg-transparent" Width="800px" KeyFieldName="OPIDCONT" ClientInstanceName="ASPxGridView2" runat="server" AutoGenerateColumns="False" OnCustomCallback="ASPxGridView2_CustomCallback" Theme="Material">
                                        <ClientSideEvents SelectionChanged="function(s,e) {
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
                                        <Settings ShowFilterRow="True"></Settings>
                                        <SettingsBehavior ProcessSelectionChangedOnServer="false" AllowSelectByRowClick="true" AllowFocusedRow="True" />
                                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" HorizontalScrollBarMode="Auto"></Settings>
                                        <SettingsResizing ColumnResizeMode="Control" Visualization="Postponed" />
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <Images>
                                            <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                        </Images>
                                        <Columns>
                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50px" MaxWidth="50"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataComboBoxColumn SettingsHeaderFilter-Mode="CheckedList" Caption="<%$ Resources:PassivosAquisicao, contabil_card5_coluna1 %>" Width="100px" MaxWidth="100" FieldName="OPIDCONT" VisibleIndex="1">
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" ValueField="OPIDCONT" TextField="OPIDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <Settings AllowAutoFilter="True" />
                                                <EditFormSettings VisibleIndex="0" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card5_coluna6 %>" Width="150px" MaxWidth="150" FieldName="TVIDESTR" VisibleIndex="2">
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="1" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn SettingsHeaderFilter-Mode="CheckedList" Caption="<%$ Resources:PassivosAquisicao, contabil_card5_coluna2 %>" Width="100px" MaxWidth="100" FieldName="OPCDCONT" VisibleIndex="3">
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPCDCONT" ValueField="OPCDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="1" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card5_coluna3 %>" Width="300px" MaxWidth="300" FieldName="OPNMCONT" VisibleIndex="5">
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPNMCONT" ValueField="OPNMCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="2" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card5_coluna4 %>" Width="250px" MaxWidth="250" FieldName="FONMAB20" VisibleIndex="6">
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="FONMAB20" ValueField="FONMAB20" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="3" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:PassivosAquisicao, contabil_card5_coluna5 %>" Width="130px" MaxWidth="130" FieldName="IENMINEC" VisibleIndex="7">
                                                <Settings AllowAutoFilter="True" />
                                                <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="IENMINEC" ValueField="IENMINEC" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                                </PropertiesComboBox>
                                                <EditFormSettings VisibleIndex="4" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="prprodes" Caption="<%$ Resources:PassivosAquisicao, contabil_card5_coluna7 %>" Width="130px" MaxWidth="130" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="OPCDAUXI" Caption="<%$ Resources:PassivosAquisicao, contabil_card1_coluna8 %>" Width="130px" MaxWidth="130" VisibleIndex="3"></dx:GridViewDataTextColumn>

                                        </Columns>

                                        <Toolbars>
                                            <dx:GridViewToolbar Name="ToolProcess">
                                                <Items>
                                                    <dx:GridViewToolbarItem ItemStyle-Height="40px" Name="Item" ItemStyle-Width="100%" Alignment="Left">
                                                        <Template>
                                                            <div class="container-fluid">
                                                                <div class="row">
                                                                    <div class="col-2 d-none" style="margin: auto 0">

                                                                        <dx:ASPxHyperLink ID="lnkClearSelection" ClientIDMode="Static" ClientInstanceName="lnkClearSelection" ClientEnabled="true" Cursor="pointer" CssClass="labels" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card5_btn4 %>" ClientSideEvents-Click="function OnUnselectAllRowsLinkClick() {
            ASPxGridView2.UnselectRows();
        }">
                                                                        </dx:ASPxHyperLink>
                                                                        <dx:ASPxLabel ID="lblClearSelection" ClientEnabled="true" ClientIDMode="Static" ClientInstanceName="lblClearSelection" CssClass="labels" runat="server" Text="(0)" Style="padding-left: 2px"></dx:ASPxLabel>
                                                                    </div>
                                                                    <div class="col-12" style="margin: auto 0">
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
                                                                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo2 %>" Value="fluxo" />
                                                                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo3 %>" Value="extrato" />
                                                                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo4 %>" Value="contabil" />
                                                                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo8 %>" Value="integra" />
                                                                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo7 %>" Value="encerra" />
                                                                                <%--<dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo5 %>" Value="rescisao" />--%>
                                                                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo6 %>" Value="repactuacao" />

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
                        <asp:View ID="viewProcessoContabil" runat="server">
                            <div class="card bg-transparent w-100">
                                <div class="card-header bg-transparent border-0 p-0">
                                    <h5>
                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card6_titulo1 %>"></asp:Label></h5>
                                </div>
                                <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick8');">
                                    <dx:ASPxGridView ID="gridProcessaContabil" ClientInstanceName="gridProcessaContabil" CssClass="bg-transparent" Width="100%" runat="server" OnDataBound="gridProcessaContabil_DataBound"
                                        EnableRowsCache="true" AutoGenerateColumns="False" Theme="Material" OnFillContextMenuItems="gridProcessaContabil_FillContextMenuItems" OnContextMenuItemClick="gridProcessaContabil_ContextMenuItemClick">
                                        <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                        <Settings ShowFooter="true" ShowFilterRow="false" ShowHeaderFilterButton="true" HorizontalScrollBarMode="Auto" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                        <SettingsPager Visible="false"></SettingsPager>
                                        <SettingsResizing ColumnResizeMode="Control" Visualization="Postponed" />
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="country_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna1 %>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="country" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna2 %>" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="legal_entity_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna3 %>" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="legal_entity" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna4 %>" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="internal_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna5 %>" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="contract_number" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna6 %>" VisibleIndex="5"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="auxiliary_number" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna7 %>" VisibleIndex="6"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="portfolio" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna8 %>" VisibleIndex="7"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="year_month" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna9 %>" VisibleIndex="8"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="event" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna10 %>" VisibleIndex="9"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="debit_credit" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna11 %>" VisibleIndex="10"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="account_number" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna12 %>" VisibleIndex="11"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="account_description" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna13 %>" VisibleIndex="12"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="modality_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna14 %>" VisibleIndex="13"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="modality" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna15 %>" VisibleIndex="14"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="contract_currency_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna16 %>" VisibleIndex="15"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="contract_currency" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna17 %>" VisibleIndex="16"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="currency_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna18 %>" VisibleIndex="17"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="currency" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna19 %>" VisibleIndex="18"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="debit" PropertiesTextEdit-DisplayFormatString="n2" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna20 %>" VisibleIndex="19"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="credit" PropertiesTextEdit-DisplayFormatString="n2" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna21 %>" VisibleIndex="20"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="dc_value" PropertiesTextEdit-DisplayFormatString="n2" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna22 %>" VisibleIndex="21"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="cost_center_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna23 %>" VisibleIndex="22"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="cost_center" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna24 %>" VisibleIndex="23"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="profit_center_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna25 %>" VisibleIndex="24"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="profit_center" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna26 %>" VisibleIndex="25"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="transaction_currency" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna27 %>" VisibleIndex="26"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="transaction_creation_timestamp" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna28 %>" VisibleIndex="27"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn FieldName="transaction_return_timestamp" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna29 %>" VisibleIndex="28"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="transaction_flag" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna30 %>" VisibleIndex="29">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_card6_coluna30.1 %>" Value="0"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_card6_coluna30.2 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_card6_coluna30.3 %>" Value="2"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="transaction_error_logs" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna31 %>" VisibleIndex="30"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="version" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna32 %>" VisibleIndex="31"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="document_id" Caption="<%$ Resources:PassivosAquisicao, contabil_card6_coluna33 %>" VisibleIndex="32"></dx:GridViewDataTextColumn>
                                        </Columns>
                                        <TotalSummary>
                                            <dx:ASPxSummaryItem FieldName="debit" SummaryType="Sum" DisplayFormat="n2" />
                                            <dx:ASPxSummaryItem FieldName="credit" SummaryType="Sum" DisplayFormat="n2" />
                                            <dx:ASPxSummaryItem FieldName="dc_value" SummaryType="Sum" DisplayFormat="n2" />
                                        </TotalSummary>
                                        <Images>
                                            <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                        </Images>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                            <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                            </Header>
                                            <Footer Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></Footer>
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
                                        <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG">
                                        </SettingsExport>
                                        <SettingsContextMenu Enabled="true">
                                            <RowMenuItemVisibility ExportMenu-Visible="true">
                                                <GroupSummaryMenu SummaryAverage="false" SummaryMax="false" SummaryMin="false" SummarySum="false" />
                                            </RowMenuItemVisibility>
                                        </SettingsContextMenu>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource runat="server" ID="sqlProcessaContabil" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select t1.* 
from nesta_ws_Acc_Statement t1
   , (select internal_id, year_month, max(version) as version from nesta_ws_Acc_Statement 
      where internal_id = ?
      group by internal_id, year_month) t2
where t1.internal_id = ?
  and t1.internal_id = t2.internal_id
  and t1.version = t2.version
order by t1.year_month">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="viewEncerramento" runat="server">
                            <div class="card bg-transparent w-100">
                                <div class="card-header bg-transparent border-0 p-0">
                                    <h5>
                                        <asp:Label ID="Label25" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_card7_titulo %>"></asp:Label></h5>
                                </div>
                                <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('quick8');">
                                    <dx:ASPxGridView ID="gridEncerramento" ClientInstanceName="gridEncerramento" CssClass="bg-transparent" runat="server" AutoGenerateColumns="False" Theme="Material" DataSourceID="sqlEncerramento"
                                        OnFillContextMenuItems="gridEncerramento_FillContextMenuItems" OnContextMenuItemClick="gridEncerramento_ContextMenuItemClick">
                                        <ClientSideEvents ContextMenuItemClick="OnContextMenuItemClick"></ClientSideEvents>
                                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth"></Settings>
                                        <SettingsPager Visible="false"></SettingsPager>
                                        <SettingsResizing ColumnResizeMode="Control" Visualization="Postponed" />
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="130px" Caption="<%$ Resources:PassivosAquisicao, contabil_card7_col1 %>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="data" Width="200px" Caption="<%$ Resources:PassivosAquisicao, contabil_card7_col2 %>" VisibleIndex="1">
                                                <PropertiesDateEdit DisplayFormatString="{0:MMMM/yyyy}"></PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="LBFLFECH" Width="180px" Caption="<%$ Resources:PassivosAquisicao, contabil_card7_col3 %>" VisibleIndex="2">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_card7_col3.1 %>" Value="S"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_card7_col3.2 %>" Value="N"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>

                                        </Columns>

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
                                    <asp:SqlDataSource runat="server" ID="sqlEncerramento" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select OPIDCONT, dateadd(m, datediff(m, 0, LBDTLANC), 0) data, LBFLFECH from LBLCTCTB L where OPIDCONT=?
group by OPIDCONT, dateadd(m, datediff(m, 0, LBDTLANC), 0), LBFLFECH
order by 1,2,3">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                        </asp:View>
                    </asp:MultiView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="row card mt-3 pl-2" style="margin: 0 auto">
        <div class="card-header p-0 text-left">
            <h5>
                <asp:Label ID="Label33" runat="server" Text="<%$ Resources:PassivosAquisicao, contabil_right_titulo1 %>" CssClass="labels text-left"></asp:Label></h5>
        </div>
    </div>
    <div class="row mt-3 pl-2" style="margin: 0 auto">
        <h6>
            <asp:Label ID="Label13" runat="server" CssClass="labels mt-2" Text="<%$ Resources:PassivosAquisicao, contabil_right_titulo2 %>"></asp:Label></h6>
        <div class="input-group" onmouseover="QuickGuide('quick1');">
            <dx:ASPxCheckBox ID="ASPxCheckBox1" runat="server" CssClass="labels" Font-Size="12pt" Text="<%$ Resources:PassivosAquisicao, contabil_right_checkbox1 %>" AutoPostBack="true" OnCheckedChanged="ASPxCheckBox1_CheckedChanged" OnLoad="ASPxCheckBox1_Load"></dx:ASPxCheckBox>
        </div>
    </div>
    <div class="row mt-3 pl-2" style="margin: 0 auto">
        <asp:Panel ID="pnlNavegacao" Width="100%" runat="server" Visible="true">
            <h6>
                <asp:Label ID="Label8" runat="server" CssClass="labels" Text="<%$ Resources:PassivosAquisicao, contabil_right_titulo3 %>"></asp:Label></h6>
            <div class="input-group mb-auto" onmouseover="QuickGuide('quick3');">
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
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo1 %>" Value="0" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo2 %>" Value="1" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo3 %>" Value="2" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo4 %>" Value="3" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo8 %>" Value="7" />
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo7 %>" Value="6" />
                        <%--<dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo5 %>" Value="4" />--%>
                        <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_combo6 %>" Value="5" />
                    </Items>
                </dx:ASPxComboBox>
            </div>
        </asp:Panel>
    </div>
    <div class="row mt-3 pl-2" style="margin: 0 auto">
        <asp:Panel ID="pnlProcFluxo" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <div class="input-group mb-auto">
                    <div class="row">
                        <div class="col-6">
                            <dx:ASPxCheckBoxList ID="checkFiltroFluxo" ForeColor="dimgray" Width="100px" CssClass="m-0 p-0" Theme="MaterialCompact" runat="server"
                                ValueType="System.String" RepeatDirection="Vertical" Border-BorderStyle="None" FocusedStyle-Wrap="Default" Paddings-Padding="0px"
                                OnLoad="checkFiltroFluxo_Load">
                                <ValidationSettings RequiredField-IsRequired="true" Display="Static" ErrorTextPosition="Bottom" ValidationGroup="FiltroFluxo" ErrorFrameStyle-ForeColor="Red" RequiredField-ErrorText="*"></ValidationSettings>
                            </dx:ASPxCheckBoxList>
                        </div>
                        <div class="col-6" onmouseover="QuickGuide('quick4');">
                            <asp:Button ID="btnProcFluxo" CssClass="Loading btn-using" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnProcFluxo_Click" OnLoad="btnProcFluxo_Load" />

                        </div>
                    </div>

                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlProcExtrato" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <dx:ASPxRadioButtonList ID="ASPxRadioButtonList1" ForeColor="dimgray" Width="100%" CssClass="m-0 p-0" Theme="Moderno" runat="server" ValueType="System.String" AutoPostBack="True" OnSelectedIndexChanged="ASPxRadioButtonList1_SelectedIndexChanged" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default">
                            <Items>
                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_checkbox2 %>" Value="2" />
                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_checkbox3 %>" Value="1" />
                            </Items>
                        </dx:ASPxRadioButtonList>
                        <asp:Label ID="lblDataExtrato" runat="server" CssClass="labels text-left" Visible="false" Text="<%$ Resources:PassivosAquisicao, contabil_right_date %>"></asp:Label>
                        <div class="input-group mb-1">
                            <dx:ASPxDateEdit ID="txtDataExtrato" Visible="false" Enabled="true" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" UseMaskBehavior="True" OnInit="txtDataExtrato_Init">

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
                <div class="input-group mb-auto">
                    <div class="row">
                        <div class="col-6">
                            <dx:ASPxCheckBoxList ID="checkFiltroExtrato" ForeColor="dimgray" Width="100px" CssClass="m-0 p-0" Theme="MaterialCompact" runat="server"
                                ValueType="System.String" RepeatDirection="Vertical" Border-BorderStyle="None" FocusedStyle-Wrap="Default" Paddings-Padding="0px"
                                OnLoad="checkFiltroExtrato_Load">
                                <ValidationSettings RequiredField-IsRequired="true" Display="Static" ErrorTextPosition="Bottom" ValidationGroup="FiltroFluxo" ErrorFrameStyle-ForeColor="Red" RequiredField-ErrorText="*"></ValidationSettings>
                            </dx:ASPxCheckBoxList>
                        </div>
                        <div class="col-6" onmouseover="QuickGuide('quick4');">
                            <asp:Button ID="btnProcExtrato" CssClass="btn-using Loading" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnProcExtrato_Click" OnLoad="btnProcExtrato_Load" />

                        </div>
                    </div>

                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlProcContab" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <asp:Label ID="lblDataConta" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_right_date %>"></asp:Label>
                <div class="input-group mb-2">
                    <dx:ASPxDateEdit ID="txtDataConta" Enabled="true" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                <div class="input-group mb-2">
                    <div class="row">
                        <div class="col-6">
                            <dx:ASPxCheckBoxList ID="checkFiltroContabil" ForeColor="dimgray" Width="100px" CssClass="m-0 p-0" Theme="MaterialCompact" runat="server"
                                ValueType="System.String" RepeatDirection="Vertical" Border-BorderStyle="None" FocusedStyle-Wrap="Default" Paddings-Padding="0px"
                                OnLoad="checkFiltroContabil_Load">
                                <ValidationSettings RequiredField-IsRequired="true" Display="Static" ErrorTextPosition="Bottom" ValidationGroup="FiltroFluxo" ErrorFrameStyle-ForeColor="Red" RequiredField-ErrorText="*"></ValidationSettings>
                            </dx:ASPxCheckBoxList>
                        </div>
                        <div class="col-6" onmouseover="QuickGuide('quick4');">
                            <asp:Button ID="btnProcContab" CssClass="btn-using Loading" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnProcContab_Click" OnLoad="btnProcContab_Load" />
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlEncerraContab" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <asp:Label ID="Label10" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_right_date %>"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="dateEncerra" Display="Dynamic" ForeColor="Red" ValidationGroup="EncerraContab" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                <div class="input-group mb-2">
                    <dx:ASPxDateEdit ID="dateEncerra" Enabled="true" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Months" PopupVerticalAlign="Below">
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

                <div class="container-fluid">
                    <div class="row">
                        <dx:ASPxRadioButtonList ID="checkEncerra" ClientInstanceName="checkEncerra" ForeColor="dimgray" Width="100px" CssClass="m-0 p-0" Theme="MaterialCompact" runat="server"
                            ValueType="System.String" RepeatDirection="Vertical" Border-BorderStyle="None" FocusedStyle-Wrap="Default" Paddings-Padding="0px" OnLoad="checkEncerra_Load" EncodeHtml="false">

                            <ClientSideEvents SelectedIndexChanged="function(s,e) { 
                                                    if(s.GetValue()==-1)
                                                    {
                                                        s.SetSelectedIndex(indexRadioFiltro);
                                                    }
                                                    }"
                                GotFocus="function(s,e){
                                                    indexRadioFiltro = s.GetSelectedIndex();
                                                    }" />
                            <Items>
                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_checkbox4 %>" Value="0" />
                                <dx:ListEditItem Text="<%$ Resources:PassivosAquisicao, contabil_right_checkbox5 %>" Value="1" />
                            </Items>
                        </dx:ASPxRadioButtonList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="checkEncerra" Display="Dynamic" ForeColor="Red" ValidationGroup="EncerraContab" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                    </div>
                    <div class="row" onmouseover="QuickGuide('quick4');">
                        <asp:Button ID="btnEncerra" CssClass="btn-using" ValidationGroup="EncerraContab" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnEncerra_Click" OnLoad="btnEncerra_Load" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlRescisao" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <asp:Label ID="Label15" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_right_rescisao_date %>"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="Valida" runat="server" ControlToValidate="txtDataResci" ForeColor="Red" ErrorMessage="*"></asp:RequiredFieldValidator>
                <div class="input-group mb-2">
                    <dx:ASPxDateEdit ID="txtDataResci" Enabled="true" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                <asp:Label ID="Labeal16" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_right_rescisao_valor %>"></asp:Label>
                <div class="input-group mb-2">
                    <dx:ASPxTextBox ID="txtMultaRescisoria" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                        <MaskSettings Mask="<0..9999g>.<00..999999>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                        <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                    </dx:ASPxTextBox>
                </div>
                <div class="input-group mb-2" onmouseover="QuickGuide('quick4');">
                    <asp:Button ID="btnProcResci" OnClick="btnProcResci_Click" CssClass="btn-using" CausesValidation="true" ValidationGroup="Valida" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnLoad="btnProcResci_Load" />
                    <asp:CustomValidator ID="CustomValidator1" runat="server" EnableClientScript="false" ControlToValidate="txtDataResci" OnServerValidate="CustomValidator1_ServerValidate" ValidationGroup="Valida" Display="Dynamic" ForeColor="Red"></asp:CustomValidator>
                </div>
            </div>
            <dx:ASPxPopupControl ID="pupRescisao" ClientIDMode="Static" ClientInstanceName="pupRescisao" Width="600px" Height="400px"
                PopupHorizontalAlign="WindowCenter" ShowHeader="false" PopupVerticalAlign="WindowCenter" runat="server" EnableViewState="false"
                EnableHierarchyRecreation="true" CloseAction="OuterMouseClick" CssClass="rounding" CloseOnEscape="false" PopupAnimationType="Fade"
                Modal="true">
                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <div class="container p-0" style="background-color: transparent; background-image: url('img/fnd_about.png'); background-repeat: no-repeat; background-position: 70% center; background-size: 85%">
                            <asp:Image ID="Image7" ImageUrl="~/img/lamp.png" runat="server" Style="width: 4%; opacity: 0.5; position: absolute; z-index: 10; top: 78%; right: 5%;" />
                            <div class="row">
                                <div class="col-8 p-0">
                                    <asp:Image ID="Image2" ImageUrl="~/img/fnd_about_nesta.png" runat="server" Width="55%" Style="padding-left: 20px; padding-top: 5px;" />
                                </div>
                                <div class="col-4 p-1 titulo2 text-right">
                                    <asp:Image ID="Image3" ImageUrl="~/img/engrenagem.png" runat="server" Width="30%" Style="padding-right: 10px; margin-bottom: 5px;" /><asp:Label ID="Label20" runat="server" Text="IFRS.16"></asp:Label>
                                </div>
                            </div>
                            <div class="row pt-1" style="height: 300px; padding-right: 15px;">

                                <div class="col-4 p-0 card" style="background-color: transparent">
                                    <div class="card-header border-bottom-0" style="background-color: transparent">
                                        <asp:Label ID="lblTitulo" runat="server" Font-Names="Calibri" ForeColor="#4E01D4" Font-Size="14pt" CssClass="labels" Text="Mensagem Alerta:"></asp:Label>
                                    </div>
                                    <div class="card-body" style="background-color: transparent">
                                        <asp:Button ID="Button11" runat="server" CssClass="btn-saiba-mais" Text="Saiba mais" Enabled="false" />
                                    </div>
                                    <div class="card-footer bg-transparent border-top-0">
                                        <asp:Image ID="Image6" ImageUrl="~/img/etc.png" runat="server" Width="30%" Style="padding-right: 10px" />
                                    </div>
                                </div>
                                <div class="col-8 pl-2 p-0" style="background-color: transparent; border: 2px solid #BA9BC9; border-radius: 5px">
                                    <h5>
                                        <asp:Label ID="Label19" runat="server" Text="Parabéns, essa é a sua data de aniversário, deseja prosseguir?"></asp:Label></h5>
                                </div>
                            </div>
                            <div class="row pt-1 text-right" style="padding-right: 15px;">
                                <div class="col-9 text-right">
                                    <asp:Button ID="btnYes" OnCommand="btnYes_Command" CommandArgument="1" CausesValidation="false" runat="server" Text="<%$Resources:GlobalResource, popup_session_btnYes %>" CssClass="Loading btn yes" />
                                </div>
                                <div class="col-3 text-right">
                                    <asp:Button ID="btnNo" OnCommand="btnYes_Command" CommandArgument="0" CausesValidation="false" runat="server" Text="<%$Resources:GlobalResource, popup_session_btnNo %>" CssClass="Loading btn no" />
                                </div>
                            </div>
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </asp:Panel>
        <asp:Panel ID="pnlRepactuacao" Width="100%" Visible="false" runat="server">
            <div class="col-lg-12 p-0" style="text-align: left;">
                <asp:Label ID="Label17" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_right_repact_date %>"></asp:Label>
                <%--<ajaxToolkit:CalendarExtender ID="CalendarExtender4" TargetControlID="txtDataRepac" runat="server" />--%>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="Repact" runat="server" ControlToValidate="txtDataRepac" ForeColor="Red" ErrorMessage="*"></asp:RequiredFieldValidator>
                <div class="input-group mb-2">
                    <dx:ASPxDateEdit ID="txtDataRepac" ForeColor="dimgray" Theme="Material" Width="100%" runat="server" AllowUserInput="true" UseMaskBehavior="True" PickerType="Months">
                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                            <HoverStyle BackColor="#669999"></HoverStyle>
                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                        </ButtonStyle>
                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                        <CalendarProperties>
                            <HeaderStyle BackColor="#669999" />
                            <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                        </CalendarProperties>
                    </dx:ASPxDateEdit>
                    <%--<asp:TextBox ID="txtDataRepac" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>--%>
                </div>
                <asp:Label ID="Label18" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_right_repact_taxa %>"></asp:Label>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="Repact" runat="server" InitialValue="0,000000" ControlToValidate="txtTaxaRepac" ForeColor="Red" ErrorMessage="*"></asp:RequiredFieldValidator>
                <div class="input-group mb-2">
                    <dx:ASPxTextBox ID="txtTaxaRepac" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                        <MaskSettings Mask="<0..9999g>.<00..999999>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                        <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                    </dx:ASPxTextBox>
                </div>
                <div class="input-group mb-2" onmouseover="QuickGuide('quick4');">
                    <asp:Button ID="btnProcRepac" OnClick="btnProcRepac_Click" ValidationGroup="Repact" CssClass="btn-using" CausesValidation="true" Enabled="false" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnLoad="btnProcRepac_Load" />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlProcessoContabil" Width="100%" Visible="false" runat="server">
                    <div class="col-lg-12 p-0" style="text-align: left;">
                        <asp:Label ID="Label24" runat="server" CssClass="labels text-left" Text="<%$ Resources:PassivosAquisicao, contabil_right_processo_date %>"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ValidationGroup="ProcessoContabil" runat="server" ControlToValidate="dateProcessoContabil" ForeColor="Red" ErrorMessage="*"></asp:RequiredFieldValidator>
                        <div class="input-group mb-2">
                            <dx:ASPxDateEdit ID="dateProcessoContabil" ForeColor="dimgray" Theme="Material" Width="100%" runat="server" AllowUserInput="true" UseMaskBehavior="True" PickerType="Months" AutoPostBack="true" OnDateChanged="dateProcessoContabil_DateChanged">
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <CalendarProperties>
                                    <HeaderStyle BackColor="#669999" />
                                    <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                </CalendarProperties>
                            </dx:ASPxDateEdit>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <asp:Button ID="btnProcessoContabil" Enabled="false" CssClass="btn-using" ValidationGroup="ProcessoContabil" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnLoad="btnProcessoContabil_Load" OnClick="btnProcessoContabil_Click" />
                        </div>
                        <div class="col-lg-6 p-0">
                            <asp:Button ID="btnProcessoIntegrar" Enabled="false" CssClass="btn-using" ValidationGroup="ProcessoContabil" runat="server" Text="<%$ Resources:GlobalResource, btn_integrar %>" OnLoad="btnProcessoIntegrar_Load" OnClick="btnProcessoIntegrar_Click" />
                        </div>
                    </div>
        </asp:Panel>
    </div>
</asp:Content>
