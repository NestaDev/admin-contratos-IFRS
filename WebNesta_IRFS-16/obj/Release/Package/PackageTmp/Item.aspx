<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Item.aspx.cs" Inherits="WebNesta_IRFS_16.Item" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var isButtonClicked = false;
        var isButtonClicked2 = false;
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropItem').value = TreeList.GetFocusedNodeKey();
            if (focusedNodeKey != "")
                employeeName = TreeList.cpEmployeeNames[focusedNodeKey];
            gridItemProdutos.Refresh();
            UpdateControls(focusedNodeKey, employeeName);
        }
        function UpdateControls(key, text) {
            DropDownEdit.SetText(text);
            DropDownEdit.SetKeyValue(key);
            DropDownEdit.HideDropDown();
        }
        function OnDropDown() {
            TreeList.SetFocusedNodeKey(DropDownEdit.GetKeyValue());
            TreeList.MakeNodeVisible(TreeList.GetFocusedNodeKey());
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
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
                                    <label id="lblquickGuide"><%=Resources.Fornecedores.fornecedor_guide_ini %></label>
                                </div>
                                <div class="card-footer bg-transparent quickGuide-footer">
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Fornecedores, fornecedor_content_tutorial %>" />
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
                        <asp:MultiView ID="mv_Content" runat="server">
                            <asp:View ID="vw_Itemização" runat="server">
                                <div class="card-header bg-transparent">
                                    <h4>
                                        <asp:Label ID="Label1" runat="server" Text="Produto"></asp:Label></h4>
                                </div>
                                <div class="card-body bg-transparent">
                                    <div class="row">
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="lblCpf" runat="server" Text="Código" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtCodigo" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>

                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="lblDesc" runat="server" Text="Descrição Abreviada" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtDescAbre" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x2">
                                            <asp:Label ID="Label9" runat="server" Text="Descrição" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtDesc" MaxLength="40" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label2" runat="server" Text="N.G.T.I" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtNGTI" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label3" runat="server" Text="Linha Produto" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtLinProd" MaxLength="5" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label4" runat="server" Text="Catálogo" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtCatalogo" MaxLength="4" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label8" runat="server" Text="Revisão/Desenho" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtDesenho" MaxLength="10" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label5" runat="server" Text="Peso" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtPeso" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic" ControlToValidate="txtPeso" ValidationExpression="^\d+(\.\d{1,2})?$" runat="server" ForeColor="Red" ErrorMessage="Apenas valores decimais"></asp:RegularExpressionValidator>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label6" runat="server" Text="Qtd Emgalagem" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtQtdEmba" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" Display="Dynamic" ControlToValidate="txtQtdEmba" ValidationExpression="^\d+(\.\d{1,2})?$" runat="server" ForeColor="Red" ErrorMessage="Apenas valores decimais"></asp:RegularExpressionValidator>

                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label7" runat="server" Text="Unidade Medida" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <dx:ASPxComboBox ID="dropUnidadeMedida" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                    DataSourceID="sqlUnidadeMedida" ValueField="UNDSAB20" ValueType="System.String" TextField="UNDSAB20">
                                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                                <asp:SqlDataSource runat="server" ID="sqlUnidadeMedida" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                    SelectCommand="SELECT UNDSAB20 FROM UNUNIDAD ORDER BY UNDSUNID"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="TextBox8" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="vw_Produto" runat="server">
                                <div class="card-header bg-transparent">
                                    <h4>
                                        <asp:Label ID="Label12" runat="server" Text="N.G.T."></asp:Label></h4>
                                </div>
                                <div class="card-body bg-transparent">
                                    <div class="row">
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label13" runat="server" Text="Nível Superior" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <dx:ASPxComboBox ID="dropNivel" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                    DataSourceID="sqlNivel" ValueField="TVIDITEM" ValueType="System.String" TextField="TVDSITEM">
                                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                                <asp:SqlDataSource runat="server" ID="sqlNivel" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                    SelectCommand="select TVDSITEM,TVIDITEM from TVITEMIZ order by TVCDITEM,TVIDITEM">
                                                </asp:SqlDataSource>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x2">
                                            <asp:Label ID="Label14" runat="server" Text="Descrição" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="txtDescNGT" MaxLength="60" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:TextBox ID="TextBox3" MaxLength="40" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
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
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfDropItem" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfDropItemProd" ClientIDMode="Static" runat="server" />
    <asp:Button ID="btnSelectLoja" runat="server" CssClass="d-none Loading" ClientIDMode="Static" CausesValidation="false" Text="Button" OnClick="btnSelectLoja_Click" />
    <asp:SqlDataSource ID="sqlTreeList" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select TVDSITEM,TVIDITEM,TVCDITEM from TVITEMIZ ORDER BY TVDSITEM"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlTreeList2" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="SELECT REPLICATE(0,3-LEN(N.TVIDITEM)) + CAST(N.TVIDITEM AS VARCHAR) + '.' + 
REPLICATE(0,3-LEN(G.TVIDITEM)) + CAST(G.TVIDITEM AS VARCHAR) + '.' + 
REPLICATE(0,3-LEN(T.TVIDITEM)) + CAST(T.TVIDITEM AS VARCHAR) + '.' + 
REPLICATE(0,3-LEN(I.ENCDITEM)) + CAST(I.ENCDITEM AS VARCHAR) NGTI, 
I.*, P.PRPRODES, B.FONMAB20 
FROM TVITEMIZ N 
JOIN TVITEMIZ G ON (G.TVCDITEM = N.TVIDITEM) 
JOIN TVITEMIZ T ON (T.TVCDITEM = G.TVIDITEM) 
JOIN ENGENHAR I ON (I.TVIDITEM = T.TVIDITEM) 
LEFT OUTER JOIN FOFORNEC B ON (B.FOIDFORN = I.ENIDBOLS) 
LEFT OUTER JOIN PRPRODUT P ON (P.PRPRODID = I.ENDIPRDB) 
WHERE I.TVIDITEM = ?
ORDER BY I.ENDSITEM ">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfDropItem" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <div class="container p-0">
        <div class="mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="Itemização" CssClass="labels text-left"></asp:Label></h5>
            </div>
            <div class="card-body p-0">
                <div class="row">
                    <div class="col-12">
                        <div class="card mt-3 p-0" style="margin: 0 auto">
                            <div class="card-header bg-transparent border-0 p-0 text-left">
                                <h6>
                                    <asp:Label ID="Label10" runat="server" Text="N.G.T."></asp:Label></h6>
                            </div>

                            <div class="card-body p-0 ">
                                <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass="dropDownEdit" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                                Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below">
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
                                                    <dx:ASPxTreeList ID="TreeList" DataSourceID="sqlTreeList" ClientInstanceName="TreeList" runat="server"
                                                        Width="350px" CssClass="text-left" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                                        KeyFieldName="TVIDITEM" ParentFieldName="TVCDITEM" AutoGenerateColumns="False">
                                                        <Settings GridLines="Horizontal" />
                                                        <Columns>
                                                            <dx:TreeListTextColumn FieldName="TVDSITEM" Width="100%" Caption=" " ShowInFilterControl="False" VisibleIndex="1"></dx:TreeListTextColumn>
                                                        </Columns>
                                                        <Settings ShowFooter="false" ShowFilterBar="Hidden" ShowFilterRow="false" HorizontalScrollBarMode="Auto" VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                                        <ClientSideEvents FocusedNodeChanged="function(s,e){ 
                                                            selectButton.SetEnabled(true);
                                                            btnAlterarNGT.SetEnabled(true);
                                                            btnInserirProd.SetEnabled(true);
                                                            }" />
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
                                                    </dx:ASPxTreeList>
                                                    <div class="row mt-3" style="margin: 0 auto;">
                                                        <div class="col-lg-4 pl-0" style="text-align: center;">
                                                            <dx:ASPxButton ID="selectButton" ClientEnabled="false" CssClass="btn-using h-75" ClientInstanceName="selectButton"
                                                                runat="server" AutoPostBack="false" Text="Selecionar">
                                                                <ClientSideEvents Click=" function (s,e) { 
                                                            UpdateSelection(); } " />
                                                            </dx:ASPxButton>
                                                        </div>
                                                        <div class="col-lg-4 pl-0" style="text-align: center;">
                                                            <dx:ASPxButton ID="btnInserirNGT" ClientEnabled="true" runat="server" CssClass="btn-using h-75" AutoPostBack="true" CausesValidation="false" CommandArgument="InserirNGT" OnCommand="ComandProdutos" Text="<%$ Resources:GlobalResource, btn_inserir %>">
                                                            <ClientSideEvents Click=" function (s,e) { 
                                                            UpdateSelection(); } " />
                                                            </dx:ASPxButton>
                                                        </div>
                                                        <div class="col-lg-4 pl-1" style="text-align: center;">
                                                            <dx:ASPxButton ID="btnAlterarNGT" ClientInstanceName="btnAlterarNGT" ClientEnabled="false" runat="server" CssClass="btn-using h-75" AutoPostBack="true" CausesValidation="false" CommandArgument="AlterarNGT" OnCommand="ComandProdutos" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                            <ClientSideEvents Click=" function (s,e) { 
                                                            UpdateSelection(); } " />
                                                            </dx:ASPxButton>
                                                        </div>
                                                    </div>
                                                </DropDownWindowTemplate>
                                            </dx:ASPxDropDownEdit>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxCallbackPanel>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card mt-3 p-0" style="margin: 0 auto">
                            <div class="card-header bg-transparent border-0 p-0 text-left">
                                <h6>
                                    <asp:Label ID="Label11" runat="server" Text="Produto"></asp:Label></h6>
                            </div>
                            <div class="card-body p-0">

                                <dx:ASPxCallbackPanel ID="ASPxCallbackPanel2" runat="server">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <dx:ASPxDropDownEdit ID="dropEditProduto" Visible="true" CssClass="dropDownEdit" ClientIDMode="Static" ClientInstanceName="dropDownEdit2" Theme="Material"
                                                Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below">
                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <DropDownWindowTemplate>
                                                    <dx:ASPxGridView ID="gridItemProdutos" ClientIDMode="Static" Width="400px" ClientInstanceName="gridItemProdutos" runat="server" AutoGenerateColumns="False" DataSourceID="sqlTreeList2" Theme="Material">
                                                        <ClientSideEvents RowDblClick="function(s, e) {                                            
                                                dropDownEdit2.HideDropDown();
                                                document.getElementById('btnSelectLoja').click();
                                            }" />
                                                        <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" />
                                                        <SettingsPager Visible="false"></SettingsPager>
                                                        <SettingsBehavior AllowFocusedRow="True" />
                                                        <SettingsPopup>
                                                            <HeaderFilter MinHeight="140px">
                                                            </HeaderFilter>
                                                        </SettingsPopup>
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="NGTI" Caption="N.G.T.I." ReadOnly="True" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="TVIDITEM" VisibleIndex="1" Visible="false"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ENCDITEM" VisibleIndex="2" Visible="false"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ENDSITEM" Caption="Descrição" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                                        </Columns>
                                                        <Styles>
                                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                            <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                                            </Header>
                                                            <Row CssClass="text-left" Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                            </Row>
                                                            <AlternatingRow CssClass="text-left" Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
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

                                                </DropDownWindowTemplate>
                                            </dx:ASPxDropDownEdit>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxCallbackPanel>
                            </div>
                            <div class="card-footer border-0 bg-transparent p-0">
                                <div class="row mt-3" style="margin: 0 auto;">
                                    <div class="col-lg-6 pl-0" style="text-align: center;">
                                        <dx:ASPxButton ID="btnInserirProd" ClientInstanceName="btnInserirProd" ClientEnabled="false" CommandArgument="inserir" OnCommand="ComandProdutos" runat="server" CssClass="btn-using " CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>">
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-lg-6 pl-1" style="text-align: center;">
                                        <dx:ASPxButton ID="btnExcluirProd" ClientInstanceName="btnExcluirProd" ClientEnabled="false" CommandArgument="excluir" OnCommand="ComandProdutos" runat="server" CssClass="btn-using " CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                        </dx:ASPxButton>
                                    </div>
                                </div>
                                <div class="row" style="margin: 0 auto; margin-top: 7px">
                                    <div class="col-lg-6 pl-0" style="text-align: center;">
                                        <dx:ASPxButton ID="btnAlterarProd" ClientEnabled="false" runat="server" CssClass="btn-using" CommandArgument="alterar" OnCommand="ComandProdutos" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-lg-6 pl-1" style="text-align: center;">
                                        <asp:TextBox ID="TextBox15" Enabled="false" runat="server" CssClass="btn-using field_empty "></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row" style="margin: 0 auto; margin-top: 7px">
                                    <div class="col-lg-6 pl-0" style="text-align: center;">
                                        <dx:ASPxButton ID="btnOKProd" ClientEnabled="false" runat="server" CssClass="btn-using  ok" OnClick="btnOKProd_Click" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_ok %>">
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-lg-6 pl-1" style="text-align: center;">
                                        <dx:ASPxButton ID="btnOKCancelar" ClientEnabled="false" runat="server" CssClass="btn-using  cancelar" OnClick="btnOKCancelar_Click" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_cancelar %>">
                                        </dx:ASPxButton>
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
