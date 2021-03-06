<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tipologia.aspx.cs" Inherits="WebNesta_IRFS_16.Tipologia" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function onBatchEditStartEditing(s, e) {
            var editor = s.GetEditor("CVDTCOIE");
            editor.SetReadOnly(e.visibleIndex == 0);
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
            //btnInserir.SetEnabled(document.getElementById('hfDropEstr').value != "");
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
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_titulo%>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_ini%>';
                    break;
                case 'acao':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_acao%>';
                    break;
                case 'grid1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid1%>';
                    break;
                case 'grid2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2%>';
                    break;
                case 'quiz':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_quiz%>';
                    break;
                case 'tipologia':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col1%>';
                    break;
                case 'origem':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col2%>';
                    break;
                case 'capital':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col3%>';
                    break;
                case 'usgaap':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col4%>';
                    break;
                case 'impostos':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col5%>';
                    break;
                case 'reajustes':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col6%>';
                    break;
                case 'carencia':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col7%>';
                    break;
                case 'fluxo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col8%>';
                    break;
                case 'calculo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col9%>';
                    break;
                case 'depreciacao':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col10%>';
                    break;
                case 'remensuracao':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col11%>';
                    break;
                case 'empresa':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Tipologia.tipologia_quickguide_grid2_col11%>';
                    break;
            }

        }

    </script>
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />


    <asp:SqlDataSource ID="sqlDisponiveis" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT p.prprodes,p.prprodid,origem,capital,usgaap,impostos,reajustes,carencia,fluxo,calculo,depreciacao,remensuracao FROM PRPRODUT P
WHERE cmtpidcm is not NULL and not exists (select null from TPESTRPR T WHERE T.TVIDESTR = ? AND P.PRPRODID=T.PRPRODID)">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Tipologia, tipologia_content_tutorial %>" />
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
                                <asp:Label ID="Label1" runat="server" onmouseover="QuickGuide('titulo');" onmouseout="QuickGuide('ini');" Text="<%$Resources:Tipologia, tipologia_tituloPag %>"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent pt-1">
                            <div class="row w-100 p-0">
                                <div class="col-lg-11 p-0">
                                    <div class="card bg-transparent p-0 w-100">
                                        <div class="card-header bg-transparent border-0 p-0" onmouseover="QuickGuide('titulo');">
                                            <%=Resources.Tipologia.tipologia_label2 %>
                                        </div>
                                        <div class="card-body bg-transparent p-0 w-100">
                                            <asp:Button ID="btnDisponiveis" ClientIDMode="Static" runat="server" CssClass="Loading d-none" CommandArgument="2" OnCommand="duploClickGrid" Text="Button" />
                                            <dx:ASPxGridView ID="gridDisponiveis" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False" SettingsPager-Visible="False" DataSourceID="sqlDisponiveis"
                                                OnDataBound="gridDisponiveis_DataBound" OnHtmlDataCellPrepared="gridDisponiveis_HtmlDataCellPrepared" Width="800px" OnLoad="gridDisponiveis_Load">
                                                <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />
                                                <ClientSideEvents RowDblClick=" function(s,e) {
                                                                document.getElementById('btnDisponiveis').click();
                                                            } " />
                                                <SettingsPopup>
                                                    <FilterControl HorizontalAlign="WindowCenter"></FilterControl>
                                                    <CustomizationWindow HorizontalAlign="WindowCenter" />
                                                    <EditForm HorizontalAlign="WindowCenter"></EditForm>
                                                    <HeaderFilter Height="200">
                                                        <SettingsAdaptivity Mode="OnWindowInnerWidth" HorizontalAlign="WindowCenter" SwitchAtWindowInnerWidth="768" MinHeight="300" />
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsBehavior AllowFocusedRow="true" />
                                                <Settings ShowFilterRow="true" ShowHeaderFilterButton="false" />
                                                <Images>
                                                    <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                                </Images>
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
                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Settings HorizontalScrollBarMode="Auto" VerticalScrollableHeight="240" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" />
                                                <ClientSideEvents BatchEditStartEditing="onBatchEditStartEditing" />
                                                <StylesFilterControl ActiveTab-HorizontalAlign="Left"></StylesFilterControl>
                                                <StylesPager>
                                                    <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                                </StylesPager>
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="prprodes" Width="75px" MaxWidth="75" Caption="<%$Resources:Tipologia, tipologia_grid1_col1 %>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="prprodid" Visible="false" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="origem" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col2 %>" ReadOnly="true" VisibleIndex="2">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_1-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_1-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="capital" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col3 %>" VisibleIndex="3">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_2-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_2-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="usgaap" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col4 %>" VisibleIndex="4">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_3-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_3-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="impostos" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col5 %>" VisibleIndex="5">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_4-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_4-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="reajustes" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col6 %>" VisibleIndex="6">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_5-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_5-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="carencia" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col7 %>" VisibleIndex="7">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_6-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_6-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="fluxo" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col8 %>" VisibleIndex="8">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_7-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_7-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="calculo" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col9 %>" VisibleIndex="9">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_8-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_8-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="depreciacao" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col10 %>" VisibleIndex="10">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_9-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_9-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="remensuracao" Width="100px" MaxWidth="100" Caption="<%$Resources:Tipologia, tipologia_grid1_col11 %>" VisibleIndex="11">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_10-1 %>" Value="1"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_10-2 %>" Value="0"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                </Columns>
                                                <Styles>
                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                    <Header Paddings-PaddingLeft="0px" Paddings-PaddingRight="0px" Wrap="True" HorizontalAlign="Center" VerticalAlign="Middle" Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                                    </Header>
                                                    <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                    </Row>
                                                    <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                    <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                        <Paddings Padding="0px" />
                                                    </BatchEditCell>
                                                    <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                    <FocusedRow BackColor="LightGreen"></FocusedRow>
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
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfDropEstr2" ClientIDMode="Static" runat="server" />
    <asp:SqlDataSource ID="sqlAssociados" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="WITH n(tvidestr,TVDSESTR) AS 
    (SELECT tvidestr, TVDSESTR
    FROM tvestrut 
    WHERE tvidestr = ?
        UNION ALL 
    SELECT nplus1.tvidestr,nplus1.TVDSESTR
    FROM tvestrut as nplus1, n 
    WHERE n.tvidestr = nplus1.tvcdpaie) 
SELECT distinct p.prprodes,n.TVDSESTR,n.tvidestr,p.prprodid FROM n, PRPRODUT P
WHERE exists (select null from TPESTRPR T WHERE N.tvidestr = T.TVIDESTR AND P.PRPRODID=T.PRPRODID)">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfDropEstr2" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:HiddenField ID="hfUser" runat="server" />
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" onmouseout="QuickGuide('ini');" Text="<%$ Resources:Tipologia, tipologia_right_lbl1 %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto" onmouseover="QuickGuide('empresa');" onmouseout="QuickGuide('ini');">
            <h5>
                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:Tipologia, tipologia_right_lbl2 %>" CssClass="labels text-left"></asp:Label></h5>
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
                <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
                <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" runat="server" Width="350px">
                    <PanelCollection>
                        <dx:PanelContent>
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
                                                    <ClientSideEvents Click=" function(s,e) {
                                                            UpdateSelection();
                                                            if (document.getElementById('hfDropEstr').value != '') {
                                                                document.getElementById('btnSelEmp').click();
                                                            }
                                                            } " />
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
            <div class="card p-0">
                <div class="card-header bg-transparent border-0 p-0" onmouseover="QuickGuide('grid2');" >
                    <%=Resources.Tipologia.tipologia_label3 %>
                </div>
                <div class="card-body p-0" onmouseover="QuickGuide('grid2');">
                    <asp:Button ID="btnAssociadas" ClientIDMode="Static" runat="server" CssClass="Loading d-none" CommandArgument="1" OnCommand="duploClickGrid" Text="Button" />
                    <dx:ASPxGridView ID="gridAssociadas" Theme="Material" runat="server" Width="225px" EnableRowsCache="False" AutoGenerateColumns="False" SettingsPager-Visible="False" DataSourceID="sqlAssociados"
                        OnDataBound="gridAssociadas_DataBound" OnLoad="gridAssociadas_Load">
                        <ClientSideEvents RowDblClick=" function(s,e) {
                                                                document.getElementById('btnAssociadas').click();
                                                            } " />
                        <SettingsPopup>
                            <FilterControl HorizontalAlign="WindowCenter"></FilterControl>
                            <CustomizationWindow HorizontalAlign="WindowCenter" />
                            <EditForm HorizontalAlign="WindowCenter"></EditForm>
                            <HeaderFilter Height="200">
                                <SettingsAdaptivity Mode="OnWindowInnerWidth" HorizontalAlign="WindowCenter" SwitchAtWindowInnerWidth="768" MinHeight="300" />
                            </HeaderFilter>
                        </SettingsPopup>
                        <SettingsBehavior AllowFocusedRow="true" />
                        <Settings ShowFilterRow="false" ShowHeaderFilterButton="true" />
                        <Images>
                            <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                        </Images>
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
                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                        <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" />
                        <ClientSideEvents BatchEditStartEditing="onBatchEditStartEditing" />
                        <StylesFilterControl ActiveTab-HorizontalAlign="Left"></StylesFilterControl>
                        <StylesPager>
                            <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                        </StylesPager>
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="prprodes" Caption="<%$Resources:Tipologia, tipologia_grid2_col1%>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="TVDSESTR" Caption="<%$Resources:Tipologia, tipologia_grid2_col2 %>" VisibleIndex="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="prprodid" Visible="false" VisibleIndex="2"></dx:GridViewDataTextColumn>
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
                            <FocusedRow BackColor="LightGreen"></FocusedRow>
                            <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
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
</asp:Content>
