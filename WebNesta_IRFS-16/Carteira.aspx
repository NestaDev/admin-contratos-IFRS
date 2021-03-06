<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Carteira.aspx.cs" Inherits="WebNesta_IRFS_16.Carteira" %>

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
            btnexcluir.SetEnabled(document.getElementById('hfDropEstr').value != "");
            clearButton.SetEnabled(DropDownEdit.GetText() != "");
            selectButton.SetEnabled(TreeList.GetFocusedNodeKey() != "");

        }
        function OnDropDown() {
            TreeList.SetFocusedNodeKey(DropDownEdit.GetKeyValue());
            TreeList.MakeNodeVisible(TreeList.GetFocusedNodeKey());
        }
        function BatchEditStartEditing(s, e) {

        }
        function BatchEditEndEditing(s, e) {
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Carteira.carteira_quickguide_titulo%>';
                    break;
                case 'selecione':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Carteira.carteira_quickguide_selecione %>';
                    break;
                case 'grid':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.guide_grid_edit%>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Carteira.carteira_quickguide_ini %>';
                    break;
                case 'acao':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Carteira.carteira_quickguide_acao %>';
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
    <asp:HiddenField ID="hfHierarqEstr" runat="server" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
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
                                   <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Carteira, carteira_content_tutorial %>" />
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
                                <asp:Label ID="Label1" onmouseover="QuickGuide('titulo');" runat="server" Text="<%$ Resources:Carteira, carteira_tituloPag %>" CssClass="labels text-left"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent">
                            <div class="row w-100 mb-1 pl-3">
                                <div class="col-lg-12 p-0" onmouseover="QuickGuide('grid');" style="margin: 0 auto">
                                    <asp:UpdatePanel ID="uptGrid" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:HiddenField ID="hfOperacao" runat="server" />
                                            <dx:ASPxGridView ID="gridCarteira" CssClass="bg-transparent" ClientInstanceName="gridCarteira" KeyFieldName="CAIDCTRA" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                                OnLoad="gridCarteira_Load" OnBatchUpdate="gridCarteira_BatchUpdate" DataSourceID="sqlCarteira">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Columns>
                                                    <dx:GridViewCommandColumn Name="CommandColumn" Visible="false" ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CAIDCTRA" Caption="<%$Resources:Carteira, carteira_grid_col1 %>" VisibleIndex="1" ReadOnly="true"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CADSCTRA" Caption="<%$Resources:Carteira, carteira_grid_col2 %>" VisibleIndex="2" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true">
                                                        <PropertiesTextEdit MaxLength="40">
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="CADSAB20" Caption="<%$Resources:Carteira, carteira_grid_col3 %>" VisibleIndex="3" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true">
                                                        <PropertiesTextEdit MaxLength="20">
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                                <Settings VerticalScrollableHeight="594" />
                                                <SettingsPager NumericButtonCount="20" PageSize="20">
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
                                            <asp:SqlDataSource runat="server" ID="sqlCarteira" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                OnLoad="sqlCarteira_Load"
                                                UpdateCommand="update CACTEIRA set CADSCTRA=?,CADSAB20=? where CAIDCTRA=?"
                                                InsertCommand="INSERT INTO CACTEIRA (CAIDCTRA,CADSCTRA,CADSAB20,TVIDESTR) VALUES ((select max(CAIDCTRA)+1 from CACTEIRA),?,?,?)"
                                                SelectCommand="WITH n(tvidestr) AS 
   (SELECT tvidestr
    FROM tvestrut
    WHERE (tvidestr = ? or tvidestr = 1)
        UNION ALL
    SELECT nplus1.tvidestr
    FROM tvestrut as nplus1, n
    WHERE n.tvidestr = nplus1.tvcdpaie)
SELECT CAIDCTRA, CADSCTRA,CADSAB20,c.tvidestr FROM n, CACTEIRA C
where n.tvidestr=c.TVIDESTR">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                </SelectParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="CADSCTRA" Type="String" />
                                                    <asp:Parameter Name="CADSAB20" Type="String" />
                                                    <asp:Parameter Name="CAIDCTRA" Type="Int32" />
                                                </UpdateParameters>
                                                <InsertParameters>
                                                    <asp:Parameter Name="CADSCTRA" Type="String" />
                                                    <asp:Parameter Name="CADSAB20" Type="String" />
                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?" Type="Int32"></asp:ControlParameter>
                                                </InsertParameters>
                                            </asp:SqlDataSource>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
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
    <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="Button1_Click" Text="Button" />
    <div class="container p-0">
        <asp:Panel ID="pnlRightCol" runat="server">
            <div class="row mt-3 card" style="margin: 0 auto">
                <div class="card-header p-1 text-left">
                    <h5>
                        <asp:Label ID="lblRightTitle" onmouseover="QuickGuide('acao');" runat="server" Text="<%$ Resources:Carteira, carteira_label_1 %>" CssClass="labels text-left"></asp:Label></h5>
                </div>
            </div>
            <div class="row mt-3" style="margin: 0 auto">
                <h5>
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Carteira, carteira_label_2 %>" CssClass="labels text-left"></asp:Label></h5>
                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('selecione');" >
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
                                                                                    <ExpandedButton url="icons/icons8-seta-para-recolher-30.png" Width="25px"></ExpandedButton>
                                                                                    <CollapsedButton url="icons/icons8-seta-para-expandir-30.png" Width="25px"></CollapsedButton>
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
                                                            } } " />
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
            <div class="row mt-3" style="margin: 0 auto;">
                <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir2');">
                    <dx:ASPxButton ID="btnInserir" ClientInstanceName="btnInserir" runat="server" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnLoad="btnInserir_Load">
                        <ClientSideEvents Click="function(s, e){gridCarteira.AddNewRow();}" />
                        <DisabledStyle ForeColor="#c0c0c0"></DisabledStyle>
                    </dx:ASPxButton>
                </div>
                <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir2');">
                    <dx:ASPxButton ID="btnexcluir" ClientInstanceName="btnexcluir" runat="server" OnClick="btnexcluir_Click" CssClass="btn-using" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_excluir %>" OnLoad="btnexcluir_Load">
                        <DisabledStyle ForeColor="#c0c0c0"></DisabledStyle>
                    </dx:ASPxButton>
                </div>
            </div>
            <div class="row" style="margin: 0 auto; margin-top: 7px">
                <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok2');">
                    <dx:ASPxButton ID="btnOK" Enabled="false" ClientInstanceName="btnOK" runat="server" OnClick="btnOK_Click" CssClass="ok btn-using" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_ok %>">
                        <DisabledStyle ForeColor="#c0c0c0"></DisabledStyle>
                    </dx:ASPxButton>
                </div>
                <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar2');">
                    <dx:ASPxButton ID="btnCancelar" Enabled="false" ClientInstanceName="btnCancelar" runat="server" OnClick="btnCancelar_Click" CssClass="cancelar btn-using" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_cancelar %>">
                        <DisabledStyle ForeColor="#c0c0c0"></DisabledStyle>
                    </dx:ASPxButton>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
