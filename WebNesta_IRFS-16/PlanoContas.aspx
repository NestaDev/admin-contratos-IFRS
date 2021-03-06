<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PlanoContas.aspx.cs" Inherits="WebNesta_IRFS_16.PlanoContas" %>

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
            btnExcluir.SetEnabled(document.getElementById('hfDropEstr').value != "");
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
                document.getElementById('lblquickGuide').innerHTML = '<%= Resources.PlanoContas.planocontas_quickguide_titulo%>';
                    break;
                case 'grid':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.guide_grid_edit%>';
                    break;      
                case 'acao':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.PlanoContas.planocontas_quickguide_acao %>';
                break;
            case 'ini':
                document.getElementById('lblquickGuide').innerHTML = '<%=Resources.PlanoContas.planocontas_quickguide_ini %>';
                break;
            case 'selecione':
                document.getElementById('lblquickGuide').innerHTML = '<%=Resources.PlanoContas.planocontas_quickguide_selecione %>';
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
    <asp:HiddenField ID="hfOperacao" runat="server" />
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
                                   <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:PlanoContas, planocontas_content_tutorial %>" />
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
                                <asp:Label ID="Label1" runat="server" onmouseover="QuickGuide('titulo');" Text="<%$ Resources:PlanoContas, planocontas_tituloPag %>" CssClass="labels text-left"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent pt-0 pb-0">
                            <div class="row p-0" style="margin: 0 auto">
                                <div class="col-lg-12 p-0" onmouseover="QuickGuide('grid');" style="margin: 0 auto">
                                    <asp:UpdatePanel ID="uptGrid" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <dx:ASPxGridView ID="gridPlanCont" CssClass="bg-transparent" ClientInstanceName="gridPlanCont" KeyFieldName="PFIDPLNC" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False" OnBatchUpdate="gridPlanCont_BatchUpdate" DataSourceID="sqlPlanCont" OnLoad="gridPlanCont_Load">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsResizing ColumnResizeMode="NextColumn" Visualization="Live" />
                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Columns>
                                                    <dx:GridViewCommandColumn Name="CommandColumn" Visible="false" ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PFCDPLNC" Caption="<%$Resources:PlanoContas, planocontas_grid_col1 %>" VisibleIndex="1" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PFDSPLNC" Caption="<%$Resources:PlanoContas, planocontas_grid_col2 %>" VisibleIndex="2" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="TVDSESTR" Caption="<%$Resources:PlanoContas, planocontas_grid_col3 %>" VisibleIndex="3" EditFormSettings-Visible="False" ReadOnly="false"></dx:GridViewDataTextColumn>
                                                </Columns>
                                                <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="300" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
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
                                            <asp:SqlDataSource runat="server" ID="sqlPlanCont" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="WITH n(tvidestr,TVDSESTR) AS 
   (SELECT tvidestr,TVDSESTR
    FROM tvestrut
    WHERE (tvidestr = ? or tvidestr = 1)
        UNION ALL
    SELECT nplus1.tvidestr,NPLUS1.TVDSESTR
    FROM tvestrut as nplus1, n
    WHERE n.tvidestr = nplus1.tvcdpaie)
SELECT PFCDPLNC, PFDSPLNC,PFIDPLNC,N.TVDSESTR FROM n, PFPLNCTA P
where n.tvidestr=P.TVIDESTR"
                                                InsertCommand="select PFCDPLNC, PFDSPLNC,PFIDPLNC from PFPLNCTA order by 1"
                                                UpdateCommand="select PFCDPLNC, PFDSPLNC,PFIDPLNC from PFPLNCTA order by 1">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                </SelectParameters>
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
    <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
    <div class="container p-0">
        <asp:Panel ID="pnlBotoes" runat="server">
            <div class="row mt-3 card" style="margin: 0 auto">
                <div class="card-header p-1 text-left">
                    <h5>
                        <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" Text="<%$ Resources:PlanoContas, planocontas_right_lbl1 %>" CssClass="labels text-left"></asp:Label></h5>
                </div>
            </div>
            <div class="row mt-3" style="margin: 0 auto">
                <h6>
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:PlanoContas, planocontas_right_lbl2 %>" CssClass="labels text-left"></asp:Label></h6>
                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('selecione');">
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
                                                <Settings VerticalScrollBarMode="Auto" ScrollableHeight="150" />
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
                                                    <Node Cursor="pointer">
                                                    </Node>
                                                    <Indent Cursor="default">
                                                    </Indent>
                                                </Styles>
                                                <Columns>
                                                    <dx:TreeListTextColumn FieldName="TVDSESTR" Caption="Descrição" AutoFilterCondition="Default" ShowInFilterControl="Default" VisibleIndex="0"></dx:TreeListTextColumn>
                                                </Columns>
                                            </dx:ASPxTreeList>
                                        </div>
                                        <table style="background-color: White; width: 100%;">
                                            <tr>
                                                <td style="padding: 10px;">
                                                    <dx:ASPxButton ID="clearButton" ClientEnabled="false" Theme="Material" ClientInstanceName="clearButton"
                                                        runat="server" AutoPostBack="false" Text="Clear" BackColor="#669999">
                                                        <ClientSideEvents Click="ClearSelection" />
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <DisabledStyle BackColor="White"></DisabledStyle>
                                                    </dx:ASPxButton>
                                                </td>
                                                <td style="text-align: right; padding: 10px;">
                                                    <dx:ASPxButton ID="selectButton" ClientEnabled="false" Theme="Material" ClientInstanceName="selectButton"
                                                        runat="server" AutoPostBack="false" Text="Select" BackColor="#669999">
                                                        <ClientSideEvents Click=" function(s,e) {
                                                            UpdateSelection();
                                                            if (document.getElementById('hfDropEstr').value != '') {
                                                                document.getElementById('btnSelEmp').click();
                                                            } } " />
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <DisabledStyle BackColor="White"></DisabledStyle>
                                                    </dx:ASPxButton>
                                                    <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" Text="Close" BackColor="#669999">
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
                <div class="col-lg-6 pl-0" style="text-align: center;"  onmouseover="QuickGuide('inserir2');">
                    <dx:ASPxButton ID="btnInserir" ClientInstanceName="btnInserir" runat="server" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnLoad="btnInserir_Load">
                        <ClientSideEvents Click="function(s, e){gridPlanCont.AddNewRow();}" />
                    </dx:ASPxButton>
                </div>
                <div class="col-lg-6 pl-1" style="text-align: center;"  onmouseover="QuickGuide('excluir2');">
                    <dx:ASPxButton ID="btnexcluir" ClientInstanceName="btnExcluir" runat="server" OnClick="btnexcluir_Click" CssClass="btn-using" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_excluir %>" OnLoad="btnexcluir_Load">
                        <DisabledStyle ForeColor="#c0c0c0"></DisabledStyle>
                    </dx:ASPxButton>
                </div>
            </div>
            <div class="row" style="margin: 0 auto; margin-top: 7px">
                <div class="col-lg-6 pl-0" style="text-align: center;"  onmouseover="QuickGuide('ok2');">
                    <asp:Button ID="btnOK" OnClick="btnOK_Click" Enabled="false" runat="server" CssClass="Loading btn-using ok" Text="<%$ Resources:GlobalResource, btn_ok %>" />
                </div>
                <div class="col-lg-6 pl-1" style="text-align: center;"  onmouseover="QuickGuide('cancelar2');">
                    <asp:Button ID="btnCancelar" OnClick="btnCancelar_Click" Enabled="false" runat="server" CssClass="Loading btn-using cancelar" Text="<%$ Resources:GlobalResource, btn_cancelar %>" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
