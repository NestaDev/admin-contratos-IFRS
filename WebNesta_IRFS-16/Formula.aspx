<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Formula.aspx.cs" Inherits="WebNesta_IRFS_16.Formula" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            btnInserir.SetEnabled(document.getElementById('hfDropEstr').value != "");
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
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Formulas.formulas_quickguide_titulo%>';
                    break;
                case 'nome':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Formulas.formulas_quickguide_nome%>';
                    break;
                case 'base':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Formulas.formulas_quickguide_base%>';
                    break;
                case 'formula':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Formulas.formulas_quickguide_formula%>';
                    break;
                case 'variaveis':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Formulas.formulas_quickguide_variaveis%>';
                    break;
                case 'acao':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Formulas.formulas_quickguide_acao %>';
                    break;
                case 'pesquisa':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Formulas.formulas_quickguide_pesquisa %>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Formulas.formulas_quickguide_ini %>';
                    break;
                case 'teste':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Formulas.formulas_quickguide_teste %>';
                    break;
                case 'inserir':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_inserir_qg %>';
                    break;
                case 'excluir':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_excluir_qg %>';
                    break;
                case 'ok':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_ok_qg %>';
                    break;
                case 'cancelar':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_cancelar_qg %>';
                    break;
                case 'alterar':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_alterar_qg %>';
                    break;
            }

        }

    </script>
    <asp:HiddenField ID="hfMsgException" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_exception %>" />
    <asp:HiddenField ID="hfMsgSuccess" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_success %>" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfDropForm" runat="server" />
    <asp:HiddenField ID="hfTVIDESTRPAI" runat="server" />
    <asp:SqlDataSource runat="server" ID="sqlIndexadores" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="SELECT I.IEIDINEC,I.IENMINEC,I.IEINFLAG FROM IEINDECO I 
                            WHERE I.IEINFLAG = 1
                            union all 
                            select I.IEIDINEC,I.IENMINEC,I.IEINFLAG FROM IEINDECO I 
                            where I.IEINFLAG = 0 
                            order by I.IEINFLAG">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfTVIDESTRPAI" PropertyName="Value" Name="?"></asp:ControlParameter>
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Formulas, formulas_content_tutorial %>" />
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
                                <asp:Label ID="Label10" runat="server" onmouseover="QuickGuide('titulo');" Text="<%$ Resources:Formulas, formulas_titulo_pag %>" CssClass="labels text-left"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent pt-0 pb-0">
                            <div class="row w-100 mb-1 pl-3">
                                <div class="p-0 col-x1" onmouseover="QuickGuide('nome');">
                                    <asp:Label ID="Label1" runat="server" CssClass="labels text-left" Text="<%$ Resources:Formulas, formulas_lbl1 %>"></asp:Label>
                                    <div class="input-group mb-0" style="padding-left: 2px">
                                        <asp:TextBox ID="txtNomeFor" Width="100%" runat="server" Enabled="false" CssClass="text-boxes"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1" onmouseover="QuickGuide('base');">
                                    <asp:Label ID="Label3" runat="server" CssClass="labels text-left" Text="<%$ Resources:Formulas, formulas_lbl2 %>"></asp:Label>
                                    <div class="input-group mb-0" style="padding-left: 2px">
                                        <dx:ASPxComboBox ID="dropBase" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" ValueType="System.String" Theme="Material" Width="100%">
                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <Items>
                                                <dx:ListEditItem Text="Indexador" Value="I" />
                                                <dx:ListEditItem Text="Moeda" Value="I" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <br />
                                    <div class="input-group mb-0" style="padding-left: 2px; margin-top: 1px">
                                        <asp:TextBox ID="TextBox2" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <br />
                                    <div class="input-group mb-0" style="padding-left: 2px; margin-top: 1px">
                                        <asp:TextBox ID="TextBox3" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 mb-1 pl-3" onmouseover="QuickGuide('formula');" >
                                <div class="p-0 col-x2">
                                    <asp:Label ID="Label2" runat="server" CssClass="labels text-left" Text="<%$ Resources:Formulas, formulas_lbl3 %>"></asp:Label>
                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                        <asp:TextBox ID="txtFormula" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
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
                                <div class="p-0 col-x1">
                                    <br />
                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                        <asp:TextBox ID="TextBox4" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 mb-1 pl-3">
                                <div class="card bg-transparent border-0 p-0 w-100">
                                    <div class="card-header bg-transparent border-0 p-0">
                                        <h5>
                                            <asp:Label ID="Label4"  runat="server" Text="<%$ Resources:Formulas, formulas_lbl4 %>" CssClass="labels text-left"></asp:Label></h5>
                                    </div>
                                    <div class="card-body bg-transparent w-100 p-0" onmouseover="QuickGuide('variaveis');">
                                        <dx:ASPxGridView ID="gridFormula" CssClass="bg-transparent" ClientInstanceName="gridFormula" runat="server" KeyFieldName="CICDVARI;CITPDESL;IEIDINEC;CIIDCODI" AutoGenerateColumns="False" Theme="Material"
                                            DataSourceID="sqlVariaveisForm" OnBatchUpdate="gridFormula_BatchUpdate" OnRowValidating="gridFormula_RowValidating">
                                            <ClientSideEvents BatchEditStartEditing=" function(s,e) {
                                    var CICDVARI = s.batchEditApi.GetCellValue(e.visibleIndex, 'CICDVARI',false);
                                    var CITPDESL = s.batchEditApi.GetCellValue(e.visibleIndex, 'CITPDESL',false);
                                    var CIPRPART = s.batchEditApi.GetCellValue(e.visibleIndex, 'CIPRPART',false);
                                    var CINRDIAS = s.batchEditApi.GetCellValue(e.visibleIndex, 'CINRDIAS',false);
                                    var CINRCARE = s.batchEditApi.GetCellValue(e.visibleIndex, 'CINRCARE',false);
                                    var CFVLVALO = s.batchEditApi.GetCellValue(e.visibleIndex, 'CFVLVALO',false);
                                    var IEIDINEC = s.batchEditApi.GetCellValue(e.visibleIndex, 'IEIDINEC',false);
                                    if(CICDVARI==null || CITPDESL==null || CIPRPART==null || CINRDIAS==null || CINRCARE==null || CFVLVALO==null || IEIDINEC==null)
                                    {
                                        
                                    }
                                    else
                                    {
                                        if(e.focusedColumn.fieldName == 'CICDVARI' || e.focusedColumn.fieldName == 'CITPDESL' || e.focusedColumn.fieldName == 'IEIDINEC')
                                        {
                                            editor = s.GetEditor(e.focusedColumn.fieldName);  
                                            editor.SetReadOnly(true);
                                        }
                                    }
                                    } " />
                                            <Settings VerticalScrollBarMode="Auto" VerticalScrollableHeight="100" VerticalScrollBarStyle="Virtual" />
                                            <SettingsEditing Mode="Batch">
                                                <BatchEditSettings ShowConfirmOnLosingChanges="false" />
                                            </SettingsEditing>
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
                                            <Columns>
                                                <dx:GridViewCommandColumn ShowNewButtonInHeader="True" Caption="  " ShowDeleteButton="true" ButtonRenderMode="Image" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn FieldName="CICDVARI" MaxWidth="110" Width="110px" Caption="<%$ Resources:Formulas, formulas_grid_col1 %>" VisibleIndex="1">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="CITPDESL" MaxWidth="110" Width="110px" Caption="<%$ Resources:Formulas, formulas_grid_col2 %>" VisibleIndex="2">
                                                    <PropertiesComboBox>
                                                        <Items>
                                                            <dx:ListEditItem Text="Base" Value="B"></dx:ListEditItem>
                                                            <dx:ListEditItem Text="Evento" Value="E"></dx:ListEditItem>
                                                            <dx:ListEditItem Text="Pagamento" Value="P"></dx:ListEditItem>
                                                        </Items>
                                                        <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataTextColumn FieldName="CIPRPART" MaxWidth="110" Width="110px" Caption="<%$ Resources:Formulas, formulas_grid_col3 %>" VisibleIndex="3">
                                                    <PropertiesTextEdit DisplayFormatString="N0">
                                                        <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CINRDIAS" MaxWidth="110" Width="110px" Caption="<%$ Resources:Formulas, formulas_grid_col4 %>" VisibleIndex="4">
                                                    <PropertiesTextEdit DisplayFormatString="N0">
                                                        <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CINRCARE" MaxWidth="110" Visible="false" Width="110px" Caption="Carências" VisibleIndex="5">
                                                    <PropertiesTextEdit DisplayFormatString="N0">
                                                        <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CFVLVALO" MaxWidth="110" Visible="false" Width="110px" Caption="Valor" VisibleIndex="6">
                                                    <PropertiesTextEdit DisplayFormatString="N2">
                                                        <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="IEIDINEC" MaxWidth="110" Width="110px" Caption="<%$ Resources:Formulas, formulas_grid_col5 %>" VisibleIndex="7">
                                                    <PropertiesComboBox DataSourceID="sqlIndexadores" TextField="IENMINEC" ValueField="IEIDINEC">
                                                        <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                            </Columns>
                                            <StylesFilterControl ActiveTab-HorizontalAlign="Left"></StylesFilterControl>
                                            <StylesPager>
                                                <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                            </StylesPager>
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
                                        <asp:SqlDataSource runat="server" ID="sqlVariaveisForm" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                            SelectCommand="select CICDVARI,CITPDESL,CIPRPART,CINRDIAS,CINRCARE,CFVLVALO,IEIDINEC,CIIDCODI from CFFORMUL where CIIDCODI=?"
                                            UpdateCommand="select 'a'"
                                            InsertCommand="select 'a'"
                                            DeleteCommand="select 'a'">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfDropForm" PropertyName="Value" Name="?"></asp:ControlParameter>
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
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <div class="container p-0">
        <div class="row mt-3 card " style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" Text="<%$ Resources:Formulas, formulas_lbl5 %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3 text-left" style="margin: 0 auto">
            <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
            <h6>
                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:Formulas, formulas_lbl6 %>" CssClass="labels text-left"></asp:Label></h6>
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
                            <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass="dropDownEdit text-left" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
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
                                            Width="350px" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                            KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE" CssClass="text-left">
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
                                                <SelectedNode BackColor="#669999" HorizontalAlign="Left"></SelectedNode>
                                                <FocusedNode BackColor="#669999" HorizontalAlign="Left"></FocusedNode>
                                                <Header Paddings-PaddingBottom="4px" Paddings-PaddingTop="4px"></Header>
                                                <Node Cursor="pointer" HorizontalAlign="Left">
                                                </Node>
                                                <Indent Cursor="default" HorizontalAlign="Left">
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
                                                <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" Text="<%$ Resources:GlobalResource, btn_selecione_loja_fechar %>" BackColor="#669999">
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
        <div class="row mt-2" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:Formulas, formulas_lbl7 %>" CssClass="labels text-left"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('pesquisa');">
                <dx:ASPxComboBox ID="dropFormulas" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" AutoPostBack="true" OnSelectedIndexChanged="dropFormulas_SelectedIndexChanged"
                    Theme="Material" Width="100%" DataSourceID="sqlFormulas" TextField="CINMTABE" ValueField="CIIDCODI">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
                <asp:SqlDataSource runat="server" ID="sqlFormulas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="SELECT CINMTABE,CIIDCODI FROM CICIENTI C 
                            WHERE (tvidestr = ? or tvidestr = 1)">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto;">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <dx:ASPxButton ID="btnInserir" ClientInstanceName="btnInserir" OnClick="btnInserir_Click" runat="server" CssClass="btn-using" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnLoad="btnInserir_Load">
                    <Paddings PaddingBottom="1px" PaddingTop="1px" PaddingLeft="6px" PaddingRight="6px" />
                </dx:ASPxButton>
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="btn-using" OnClick="btnExcluir_Click" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnLoad="btnExcluir_Load" />
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px" >
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="btn-using" OnClick="btnAlterar_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnLoad="btnAlterar_Load" />

            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('teste');">
                <dx:ASPxButton ID="btnCalcular" runat="server" CssClass="btn-using" Enabled="false" CausesValidation="false" Text="<%$ Resources:Formulas, formulas_teste_btn %>">
                    <Paddings PaddingBottom="1px" PaddingTop="1px" PaddingLeft="6px" PaddingRight="6px" />
                </dx:ASPxButton>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                <asp:Button ID="btnOK" Enabled="false" runat="server" OnClick="btnOK_Click" CssClass="btn-using ok" Text="<%$ Resources:GlobalResource, btn_ok %>" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="btn-using cancelar" OnClick="btnCancelar_Click" Text="<%$ Resources:GlobalResource, btn_cancelar %>" CausesValidation="false" />
            </div>
        </div>
    </div>

    <dx:ASPxPopupControl ID="ASPxPopupControl1" Width="350px" HeaderText="<%$ Resources:Formulas, formulas_teste_titulo %>" PopupElementID="btnCalcular" runat="server">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <asp:HiddenField ID="hfFormula" runat="server" />
                <div class="row mt-3 text-left" style="margin: 0 auto">
                    <div class="col-x2 p-0">
                        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Formulas, formulas_teste_lbl1 %>" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-0">
                            <dx:ASPxDateEdit ID="txtDtBase" ForeColor="dimgray" CssClass="drop-down" BackColor="#e1dfdf" Theme="Material" Width="100%" runat="server" PickerType="Days">
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" BackColor="#e1dfdf" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                <CalendarProperties>
                                    <HeaderStyle BackColor="#669999" />
                                    <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                </CalendarProperties>
                            </dx:ASPxDateEdit>
                        </div>
                    </div>
                    <div class="col-x0 p-0"></div>
                    <div class="col-x2 p-0">
                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Formulas, formulas_teste_lbl2 %>" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-0">
                            <dx:ASPxDateEdit ID="txtDtEvento" ForeColor="dimgray" CssClass="drop-down" BackColor="#e1dfdf" Theme="Material" Width="100%" runat="server" PickerType="Days">
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" BackColor="#e1dfdf" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                <CalendarProperties>
                                    <HeaderStyle BackColor="#669999" />
                                    <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                </CalendarProperties>
                            </dx:ASPxDateEdit>
                        </div>
                    </div>

                </div>
                <div class="row mt-0 text-left" style="margin: 0 auto">
                    <div class="col-x2 p-0">
                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:Formulas, formulas_teste_lbl3 %>" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-0">
                            <dx:ASPxDateEdit ID="txtDtPag" ForeColor="dimgray" CssClass="drop-down" BackColor="#e1dfdf" Theme="Material" Width="100%" runat="server" PickerType="Days">
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" BackColor="#e1dfdf" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                <CalendarProperties>
                                    <HeaderStyle BackColor="#669999" />
                                    <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                </CalendarProperties>
                            </dx:ASPxDateEdit>
                        </div>
                    </div>
                    <div class="col-x0"></div>
                    <div class="col-x2 p-0">
                        <asp:Label ID="Label11" runat="server" Text="<%$ Resources:Formulas, formulas_teste_lbl4 %>" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-1">
                            <asp:TextBox ID="lblResultado" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                        </div>
                    </div>

                </div>
                <div class="row mt-3" style="margin: 0 auto">
                    <br />
                    <div class="input-group mb-1">
                        <asp:Button ID="btnExecutar" CssClass="btn-using" OnClick="btnExecutar_Click" runat="server" Text="<%$ Resources:Formulas, formulas_teste_btn %>" />
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
