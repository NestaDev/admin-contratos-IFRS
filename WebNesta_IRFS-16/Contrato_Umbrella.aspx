<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contrato_Umbrella.aspx.cs" Inherits="WebNesta_IRFS_16.Contrato_Umbrella1" %>
<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            var paneName1 = $("[id*=panelActive1]").val() != "" ? $("[id*=panelActive1]").val() : "collapseInsertInfoImovel";
            //Remove the previous selected Pane.
            $("#cardContrato .show").removeClass("show");
            //Set the selected Pane.
            $("#" + paneName1).collapse("show");
            //When Pane is clicked, save the ID to the Hidden Field.
            $(".card-header a").click(function () {
                $("[id*=panelActive1]").val($(this).attr("href").replace("#", ""));
            });
        });
        function clickBases() {
            var valor = '<%=hfOperacao.Value%>';
            if (valor == "inserir") {
                document.getElementById('myLinkTagBtn').click();
            }
        }
        function ClearSelection() {
            TreeList.SetFocusedNodeKey("");
            UpdateControls(null, "");
            document.getElementById('hfDropEstr').value = "";
        }
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropEstr').value = TreeList.GetFocusedNodeKey();
            dropCarteiraInsert2.PerformCallback(document.getElementById('hfDropEstr').value);
            dropAgenteFinanceiroInsert2.PerformCallback(document.getElementById('hfDropEstr').value);
            dropBenefIns.PerformCallback(document.getElementById('hfDropEstr').value);
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
        function OnCountryChanged(cmbCountry) {
            dropClasseProdutoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
        }
        function OnClasseInsertChanged(dropClasseProdutoInsert2) {
            dropProdutoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString().concat('#', dropClasseProdutoInsert2.GetSelectedItem().value.toString(), '#', document.getElementById('hfDropEstr').value));
        }
        function QuickGuide(guide) {
            switch (guide) {
                case 'aba1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_titulo1_quickguide%>';
                    break;
                case 'aba2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_titulo1_quickguide%>';
                    break;
                case 'aba3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp3_titulo1_quickguide%>';
                    break;
                case 'aba4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp4_titulo1_quickguide%>';
                    break;
                case 'aba5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp5_titulo1_quickguide%>';
                    break;
                case '1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl1_guide%>';
                    break;
                case '2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl2_guide%>';
                    break;
                case '3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl3_guide%>';
                    break;
                case '31':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl31_guide%>';
                    break;
                case '4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl4_guide%>';
                    break;
                case '5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl5_guide%>';
                    break;
                case '6':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl6_guide%>';
                    break;
                case '7':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl7_guide%>';
                    break;
                case '8':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl8_guide%>';
                    break;
                case '9':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl9_guide%>';
                    break;
                case '10':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl10_guide%>';
                    break;
                case '11':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl11_guide%>';
                    break;
                case '12':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl12_guide%>';
                    break;
                case '13':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl13_guide%>';
                    break;
                case '14':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl14_guide%>';
                    break;
                case '15':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl15_guide%>';
                    break;
                case '16':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl16_guide%>';
                    break;
                case '17':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl1_guide%>';
                    break;
                case '18':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl2_guide%>';
                    break;
                case '19':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl3_guide%>';
                    break;
                case '20':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl4_guide%>';
                    break;
                case '21':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl5_guide%>';
                    break;
                case '22':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl6_guide%>';
                    break;
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_right_titulo_guide%>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.quickguide_inicial %>';
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
                case 'historico':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Aquisicao.aquisição_btn_historico_guide %>';
                    break;
                case 'replicar':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Aquisicao.aquisição_btn_replicar_guide %>';
                    break;
                case 'aditamento':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Aquisicao.aquisição_btn_aditamento_guide %>';
                    break;
            }

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Button ID="Button10gridDeAte" ClientIDMode="Static" CausesValidation="false" CssClass="Loading" OnClick="Button10gridDeAte_Click" Style="display: none" runat="server" Text="Button" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfOperacao" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfUser" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfPaisUser" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfCodInterno" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfInsertOK" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfOPIDCONT" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfProduto" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfCHIDCODI" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfEstruturaCorporativa" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfSqlInsert" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfOPCDCONT" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfTVDSESTR" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfPRPRODES" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfOPVLCONT" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfPRPRODID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfIndexGrid" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfqueryRpt" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="panelActive1" ClientIDMode="Static" runat="server" />
    <div class="container">
        <div class="row">
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:RequisitaContrato, requisita_content_tutorial %>" />
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
            <div class="col-sm-10 pl-4">
                <asp:MultiView ID="mv_contrato" runat="server">
                    <asp:View ID="view_1" runat="server">
                <div id="cardInsert">
                    <%--Painel com campos para Insert--%>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" style="height: 40px" onmouseover="QuickGuide('aba1');">
                            <a class="card-link" data-toggle="collapse" href="#collapseInsertInfo" aria-expanded="true">
                                <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label7" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp1_titulo1 %>"></asp:Label></h5>
                                <asp:Panel ID="pnlHeaderInsert" Visible="false" runat="server">
                                    <h5 style="text-align: right; float: left; padding-left: 5px">
                                        <asp:Label ID="Label71" runat="server" CssClass="labels" Text="Código Interno: "></asp:Label>
                                        <asp:Label ID="txtCodInternoInsert" runat="server" CssClass="labels" Text=""></asp:Label></h5>
                                </asp:Panel>
                            </a>
                        </div>
                        <div id="collapseInsertInfo" class="collapse show" data-parent="#cardInsert">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblEstruturaCorporativaInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="margin-top: 2px" onmouseover="QuickGuide('1');">
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
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator19" ValidationGroup="InsertReq" ControlToValidate="ddeEstruturaInsert" runat="server" ForeColor="Red" Display="None" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl1 %>"></asp:RequiredFieldValidator>
                                                        <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Enabled="false" Visible="true" CssClass=" drop-down" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                                            Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
                                                            <ClientSideEvents Init="UpdateSelection" DropDown="OnDropDown" />
                                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                            </ButtonStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            <DropDownWindowTemplate>
                                                                <div>
                                                                    <dx:ASPxTreeList ID="TreeList" DataSourceID="SqlDataSource1" ClientInstanceName="TreeList" runat="server"
                                                                        Width="350px" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                                                        KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE" OnLoad="TreeList_Load">
                                                                        <Settings VerticalScrollBarMode="Auto" ScrollableHeight="150" />
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
                                                                                <ClientSideEvents Click="function(s,e) {
                                                            UpdateSelection();
                                                            if (document.getElementById('hfDropEstr').value != '') {
                                                                document.getElementById('btnSelEmp').click();
                                                            }
                                                            }" />
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
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl31 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('31');">
                                            <asp:TextBox ID="txtOperadorInsert" Enabled="false" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblNumProcessoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl4 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator9" ValidationGroup="InsertReq" ControlToValidate="txtNumProcessoInsert" runat="server" ForeColor="Red" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl3 %>"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('4');">
                                            <asp:TextBox ID="txtNumProcessoInsert" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <br />
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('4');">
                                            <asp:TextBox ID="TextBox2" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblDescricaoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator10" ValidationGroup="InsertReq" ControlToValidate="txtDescricaoInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl5 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('5');">
                                            <dx:ASPxTextBox ID="txtDescricaoInsert" Enabled="false" MaxLength="60" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <ValidationSettings ValidateOnLeave="true" RegularExpression-ValidationExpression="[^']*" ErrorDisplayMode="None"></ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblCodAuxInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('6');">
                                            <asp:TextBox ID="txtCodAuxInsert" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblDtAquisiInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator11" ValidationGroup="InsertReq" ControlToValidate="txtDtAquisiInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl6 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('7');">
                                            <dx:ASPxDateEdit ID="txtDtAquisiInsert" Enabled="false" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblHrAquisiInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl8 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator12" ValidationGroup="InsertReq" ControlToValidate="txtDtAssInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('8');">
                                            <dx:ASPxDateEdit ID="txtDtAssInsert" Enabled="false" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
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
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label31" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl9 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator20" ValidationGroup="InsertReq" ControlToValidate="txtDtEncerraInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto " style="margin-top: 1px" onmouseover="QuickGuide('9');">
                                            <dx:ASPxDateEdit ID="txtDtEncerraInsert" Enabled="false" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblValorContInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl10 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('10');">
                                            <dx:ASPxTextBox ID="txtValorContInsert2" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <MaskHintStyle Paddings-Padding="0px"></MaskHintStyle>
                                                <CaptionCellStyle Paddings-Padding="0px"></CaptionCellStyle>
                                                <RootStyle Paddings-Padding="0px"></RootStyle>
                                                <Paddings Padding="0px" />
                                                <ValidationSettings ErrorDisplayMode="None" Display="None" ErrorFrameStyle-Paddings-Padding="0px"></ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label62" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl11 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator32" ValidationGroup="InsertReq" ControlToValidate="txtIniPagInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto " style="margin-top: 1px" onmouseover="QuickGuide('11');">
                                            <dx:ASPxDateEdit ID="txtIniPagInsert" Enabled="false" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label61" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl12 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator28" ValidationGroup="InsertReq" ControlToValidate="txtFimPagInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto " style="margin-top: 1px" onmouseover="QuickGuide('12');">
                                            <dx:ASPxDateEdit ID="txtFimPagInsert" Enabled="false" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
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
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblEstruturaInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl13 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator14" ValidationGroup="InsertReq" ControlToValidate="dropEstruturaInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl8 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('13');">
                                            <dx:ASPxComboBox ID="dropEstruturaInsert2" Enabled="false" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropEstruturaInsert2" CssClass="drop-down" runat="server" DataSourceID="sqlEstruturaInsert"
                                                TextField="cmtpdscm" ValueField="cmtpidcm" Theme="Material" Width="100%">
                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCountryChanged(s); }"></ClientSideEvents>
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <asp:SqlDataSource runat="server" ID="sqlEstruturaInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="select cmtpdscm, cmtpidcm from cmtpcmcl where paidpais = ? order by cmtpidcm">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblClasseProdutoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl14 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator15" ValidationGroup="InsertReq" ControlToValidate="dropClasseProdutoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl9 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('14');">
                                            <dx:ASPxComboBox ID="dropClasseProdutoInsert2" Enabled="false" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropClasseProdutoInsert2" runat="server" CssClass="drop-down" DataSourceID="sqlClasseProdutosInsert"
                                                TextField="PRTPNMOP" ValueField="PRTPIDOP" Theme="Material" Width="100%" OnCallback="dropClasseProdutoInsert2_Callback">
                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnClasseInsertChanged(s); }"></ClientSideEvents>
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <asp:SqlDataSource runat="server" ID="sqlClasseProdutosInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select PRTPNMOP,PRTPIDOP from prtpoper po, cmtpcmcl cm
            where cm.cmtpidcm = ?
            and cm.paidpais = ?
            and po.cmtpidcm = cm.cmtpidcm
            and po.paidpais = cm.paidpais
            order by po.prtpnmop">
                                                <SelectParameters>
                                                    <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                    <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblProdutoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl15 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator16" ValidationGroup="InsertReq" ControlToValidate="dropProdutoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl10 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                            <dx:ASPxComboBox ID="dropProdutoInsert2" Enabled="false" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropProdutoInsert2" runat="server" CssClass="drop-down"
                                                Theme="Material" Width="100%" DataSourceID="sqlProdutoInsert" TextField="prprodes" ValueField="value" ValueType="System.String" OnCallback="dropProdutoInsert2_Callback">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <%--<asp:DropDownList ID="dropProdutoInsert" Width="100%" CssClass="drop-down2" runat="server" AutoPostBack="False" OnSelectedIndexChanged="dropProdutoInsert_SelectedIndexChanged"></asp:DropDownList>--%>
                                            <asp:SqlDataSource runat="server" ID="sqlProdutoInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select CONCAT(pr.prprodid,'|',pr.chidcodi) value, pr.prprodes
            from prprodut pr, prtpoper po, cmtpcmcl cm,TPESTRPR T 
            where cm.cmtpidcm = ?
            and po.PRTPIDOP = ?
            and cm.paidpais = ?
            and t.TVIDESTR=?
            and t.PRPRODID = pr.prprodid
            and po.cmtpidcm = cm.cmtpidcm
            and po.paidpais = cm.paidpais            
            and pr.prtpidop = po.PRTPIDOP
            and pr.cmtpidcm = po.cmtpidcm
            order by 2">
                                                <SelectParameters>
                                                    <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                    <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                    <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                    <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblCarteiraInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl16 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator17" ValidationGroup="InsertReq" ControlToValidate="dropCarteiraInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl11 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('16');">
                                            <dx:ASPxComboBox ID="dropCarteiraInsert2" Enabled="false" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropCarteiraInsert2" runat="server" CssClass="drop-down"
                                                Theme="Material" Width="100%" TextField="CADSCTRA" ValueField="CAIDCTRA" ValueType="System.String" OnCallback="dropCarteiraInsert2_Callback">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba2');">
                            <a class="card-link" data-toggle="collapse" href="#collapseInsertClass">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label8" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp2_titulo %>"></asp:Label></h5>
                            </a>
                        </div>
                        <div class="card-body bg-transparent pb-0 pt-1">
                            <div id="collapseInsertClass" class="collapse" data-parent="#cardInsert">
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl1 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="InsertReq" ControlToValidate="dropAgenteFinanceiroInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp2_lbl1 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('17');">
                                            <dx:ASPxComboBox ID="dropAgenteFinanceiroInsert2" Enabled="false" ClientInstanceName="dropAgenteFinanceiroInsert2" ForeColor="dimgray" AllowInputUser="false" runat="server"
                                                CssClass="drop-down" Theme="Material" Width="100%" TextField="FONMFORN" ValueField="FOIDFORN" OnCallback="dropAgenteFinanceiroInsert2_Callback">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <asp:SqlDataSource runat="server" ID="sqlAgenteFinanceiro" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT FOIDFORN,FONMFORN FROM FOFORNEC FO where TVIDESTR IS NULL ORDER BY 2"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label54" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('18');">
                                            <dx:ASPxComboBox ID="dropBenefIns" Enabled="false" ClientInstanceName="dropBenefIns" ForeColor="dimgray" AllowInputUser="false" runat="server"
                                                CssClass="drop-down" Theme="Material" Width="100%" TextField="FONMFORN" ValueField="FOIDFORN" OnCallback="dropBenefIns_Callback">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <br />
                                        <div class="input-group mb-auto" style="margin-top: 1px">
                                            <asp:TextBox ID="TextBox3" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <br />
                                        <div class="input-group mb-auto" style="margin-top: 1px">
                                            <asp:TextBox ID="TextBox5" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label42" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator23" ValidationGroup="InsertReq" ControlToValidate="dropParcInsert" runat="server" Text="*" ErrorMessage="Parcela Uniforme" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('20');">
                                            <dx:ASPxComboBox ID="dropParcInsert" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <Items>
                                                    <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.1 %>" Value="1" Selected="true" />
                                                    <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.2 %>" Value="0" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label43" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator24" ValidationGroup="InsertReq" ControlToValidate="dropCareInsert" runat="server" Text="*" ErrorMessage="Carência" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('21');">
                                            <dx:ASPxComboBox ID="dropCareInsert" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <Items>
                                                    <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.1 %>" Value="1" />
                                                    <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.2%>" Value="0" Selected="true" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label44" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator25" ValidationGroup="InsertReq" ControlToValidate="dropSaldoInsert" runat="server" Text="*" ErrorMessage="Saldo Implantado" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('22');">
                                            <dx:ASPxComboBox ID="dropSaldoInsert" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <Items>
                                                    <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.1 %>" Value="1" Selected="true" />
                                                    <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.2 %>" Value="0" />
                                                </Items>
                                            </dx:ASPxComboBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <br />
                                        <div class="input-group mb-auto" style="margin-top: 1px">
                                            <asp:TextBox ID="TextBox1" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba1');">
                            <asp:Button ID="myLinkTagBtn" ClientIDMode="Static" ValidationGroup="InsertReq" Style="display: none" OnClick="myLinkTagBtn_Click" runat="server" Text="Button" />
                            <a id="myLinkTag" class="card-link" data-toggle="collapse" href="#collapseInsertBases" onclick="clickBases();">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label9" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, aquisição_grp3_titulo %>"></asp:Label></h5>
                            </a>
                        </div>
                        <div class="card-body bg-transparent pb-0 pt-1">
                            <div id="collapseInsertBases" class="collapse" data-parent="#cardInsert">
                                <asp:Panel ID="pnlBases" Height="200px" ScrollBars="Vertical" runat="server" Width="100%" GroupingText="">
                                    <div class="container">
                                        <div class="row">
                                            <div class="col-12">
                                                <asp:Repeater ID="rptBasesInserir" runat="server" OnItemDataBound="rptBasesInserir_ItemDataBound" OnPreRender="rptBasesInserir_PreRender">
                                                    <HeaderTemplate>
                                                        <div class="row">
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <div class="col-x1 p-0">
                                                            <asp:Label ID="Label29" runat="server" CssClass="labels text-left" Text='<%#DataBinder.Eval(Container.DataItem, "CJDSDECR") %>'></asp:Label>
                                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                                <table style="width: 100%; padding-left: 2px">
                                                                    <tr>
                                                                        <td style="text-align: right; padding-right: 10px" class="tblRptControl">
                                                                            <asp:LinkButton ID="lnkRptBasesInsert" ClientIDMode="Static" runat="server" OnCommand="BasesEdit"
                                                                                CommandName='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>'
                                                                                CommandArgument='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>'>
                                                <%# Eval("CJTPIDTP").ToString()=="10"||Eval("CJTPIDTP").ToString()=="6" ? Eval("CJVLPROP").ToString()=="0" ? Eval("CJVLPROP").ToString() : DataBinder.Eval(Container.DataItem, "CJVLPROP", "{0:N2}") : Eval("CJTPCTTX").ToString() %>
                                                                            </asp:LinkButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </div>
                                                        <div class="col-x0"></div>

                                                        <asp:Literal ID="ltrlRepeaterBasesInserir" runat="server"></asp:Literal>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        </div>
                                                    </FooterTemplate>
                                                </asp:Repeater>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
                            </div>
                        </div>
                    </div>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba4');">
                            <a class="card-link" data-toggle="collapse" href="#collapseAlterarVerbas">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label53" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, aquisição_grp5_titulo %>"></asp:Label></h5>
                            </a>
                        </div>
                        <div id="collapseAlterarVerbas" class="collapse" data-parent="#cardInsert">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <asp:SqlDataSource ID="sqlContasCredDeb" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select PFIDPLNC,concat(PFCDPLNC,' - ', PFDSPLNC) conta from PFPLNCTA order by 2"></asp:SqlDataSource>

                                <asp:SqlDataSource ID="sqlVerbas" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select m.MODSMODA,m.moidmoda from  modalida m where m.motpidca=10 order by 1"></asp:SqlDataSource>
                                <dx:ASPxGridView ID="gridVerbasAlt" ClientInstanceName="gridVerbasAlt" KeyFieldName="VIIDMODA" ClientIDMode="Static" Width="800px" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVerbasAlt"
                                    OnCellEditorInitialize="gridVerbasAlt_CellEditorInitialize" OnRowValidating="gridVerbasAlt_RowValidating" OnBatchUpdate="gridVerbasAlt_BatchUpdate">
                                    <SettingsPopup>
                                        <HeaderFilter MinHeight="140px">
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Settings VerticalScrollableHeight="100" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                                    <SettingsPager NumericButtonCount="20" PageSize="20">
                                    </SettingsPager>
                                    <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="true" />
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
                                        <dx:GridViewCommandColumn ShowNewButtonInHeader="True" MaxWidth="50" Width="50px" Caption="  " ShowDeleteButton="true" ButtonRenderMode="Image" VisibleIndex="0"></dx:GridViewCommandColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="MOIDMODA" VisibleIndex="0" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col1 %>">
                                            <PropertiesComboBox DataSourceID="sqlVerbas" ValueType="System.Int32" TextField="MODSMODA" ValueField="MOIDMODA"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="ID" VisibleIndex="2" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col2 %>">
                                            <PropertiesComboBox DataSourceID="sqlBaseNegociada" ValueField="ID" TextField="CJDSDECR" ValueType="System.String" ConvertEmptyStringToNull="true">
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="VITPPGTO" VisibleIndex="3" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col3 %>">
                                            <PropertiesComboBox>
                                                <Items>
                                                    <dx:ListEditItem Text="Boleto" Value="1" />
                                                    <dx:ListEditItem Text="Transferência" Value="2" />
                                                    <dx:ListEditItem Text="Débito Conta" Value="3" />
                                                </Items>
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataTextColumn FieldName="VIDIAMOD" MaxWidth="110" Width="110px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col4 %>" VisibleIndex="1">
                                            <PropertiesTextEdit>
                                                <MaskSettings Mask="<1..31>" IncludeLiterals="None" />
                                            </PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="PFIDCRED" MaxWidth="170" Width="170px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col5 %>" VisibleIndex="4">
                                            <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="PFIDDEBI" MaxWidth="170" Width="170px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col6 %>" VisibleIndex="5">
                                            <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                    </Columns>
                                    <Styles>
                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                        <Header Font-Names="Arial" Font-Size="9pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
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
                                <asp:SqlDataSource ID="sqlBaseNegociada" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                    SelectCommand="SELECT CJ.CJDSDECR,concat(CJ.CHIDCODI,'#',CJ.CJIDCODI) AS ID FROM CJCLPROP CJ,OPCONTRA OP, PRPRODUT PR, VIPROEVE VI
WHERE OP.OPIDCONT=?
  AND PR.prprodid=OP.PRPRODID
  AND CJ.CHIDCODI=PR.chidcodi
  AND CJ.CJTPIDTP=6
  AND VI.CHIDCODI=PR.chidcodi
  AND VI.CJIDCODI=CJ.CJIDCODI
  AND VI.CHTPIDEV=1">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource runat="server" ID="sqlVerbasAlt" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                    SelectCommand="select m.MOIDMODA,v.VIIDMODA, case when V.CHIDCODI is null then '' else CONCAT(V.CHIDCODI,'#',V.CJIDCODI) end AS ID,convert(int,v.VIDIAMOD) as VIDIAMOD,convert(int,v.VITPPGTO) as VITPPGTO,PFIDCRED,PFIDDEBI from VIOPMODA v, MODALIDA m where m.MOIDMODA=v.MOIDMODA and m.MOTPIDCA=10 and v.OPIDCONT=?">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 mr-2 ml-2">
                            <a class="card-link" data-toggle="collapse" href="#collapseInsertContratos">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label1" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, umbrella_grp4_titulo1 %>"></asp:Label></h5>
                            </a>
                        </div>
                        <div class="card-body bg-transparent pb-0 pt-1">
                            <asp:Button ID="btnSelectSubContrato" ClientIDMode="Static" OnClick="btnSelectSubContrato_Click" runat="server" Text="" CssClass="d-none Loading" />
                            <div id="collapseInsertContratos" class="collapse" data-parent="#cardInsert">
                                <dx:ASPxGridView ID="gridSubContratos" ClientInstanceName="gridSubContratos" CssClass="bg-transparent" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False"
                                    AutoGenerateColumns="False" SettingsResizing-ColumnResizeMode="NextColumn" OnCustomButtonCallback="gridSubContratos_CustomButtonCallback" OnLoad="gridSubContratos_Load" DataSourceID="sqlSubContratos">
                                    <ClientSideEvents RowDblClick="function(s, e) { 
                                                document.getElementById('btnSelectSubContrato').click();
                                            }" />
                                    <SettingsPopup>
                                        <HeaderFilter MinHeight="140px">
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <SettingsBehavior AllowFocusedRow="true" ConfirmDelete="true" />
                                    <Settings ShowStatusBar="Visible" ShowHeaderFilterButton="true" VerticalScrollableHeight="110" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="OPIDCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col1 %>" Width="70px" VisibleIndex="0">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="OPCDCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col2 %>" Width="130px" VisibleIndex="1">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="OPNMCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col3 %>" VisibleIndex="2">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="OPVLCONT" Caption="<%$ Resources:Aquisicao, umbrella_grp4_grid_col4 %>" Width="130px" VisibleIndex="3">
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
                                                <%-- <dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridVerbas.UpdateEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridVerbas.CancelEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>--%>
                                                <dx:ASPxButton ID="btnImportar" Enabled="false" runat="server" Width="80px" CssClass="btn-using" Text="<%$ Resources:Aquisicao, umbrella_grp4_grid_btn1 %>" AutoPostBack="false" ClientSideEvents-Click="function(s, e){ popupImportaExcel.Show(); }">
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
                        </asp:View>
                    <asp:View ID="view_2" runat="server">
                                            <br />
                    <div class="row text-center">
                        <br />
                        <div class="col-2"></div>
                        <div class="col-lg-8 card bg-transparent align-items-center">
                            <div class="card-header bg-transparent">
                                <h3>
                                    <asp:Label ID="Label27" runat="server" CssClass=" text-danger" Text="<%$Resources:Aquisicao, aquisição_delete_titulo %>"></asp:Label></h3>
                            </div>
                            <div class="card-body bg-transparent">
                                <table>
                                    <tr>
                                        <td colspan="2" class="text-left">
                                            <h6>
                                                <asp:Label ID="Label28" runat="server" CssClass="text-left" Text="<%$Resources:Aquisicao, aquisição_delete_texto %>"></asp:Label></h6>
                                        </td>
                                    </tr>
                                </table>

                            </div>
                        </div>
                        <div class="col-2"></div>
                    </div>
                    </asp:View>
                </asp:MultiView>
            </div>
        </div>
    </div>
    <asp:Button ID="btnSel" ClientIDMode="Static" CssClass="Loading d-none" OnClick="Button1_Click" runat="server" Text="Button" />
    <dx:ASPxPopupControl ID="popupBasesAlterar" ClientInstanceName="popupBasesAlterar" ClientIDMode="Static" CloseAction="CloseButton" CloseOnEscape="false" Modal="true"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="true"
        PopupAnimationType="None" AutoUpdatePosition="true" runat="server">
        <ContentStyle Paddings-PaddingBottom="20px"></ContentStyle>
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <div class="text-center">
                    <asp:Panel ID="pnlGridEdit" runat="server">
                        <asp:HiddenField ID="hfOPIDCONT2" runat="server" />
                        <asp:HiddenField ID="hfCHIDCODI2" runat="server" />
                        <asp:HiddenField ID="hfCJIDCODI2" runat="server" />
                        <asp:HiddenField ID="hfCJTPIDTP2" runat="server" />
                        <asp:MultiView ID="MultiView1" runat="server">
                            <asp:View ID="viewData" runat="server">
                                <table>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="lblEditarData" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <ajaxToolkit:CalendarExtender ID="CalendarExtender2" TargetControlID="txtEditarData" Enabled="true" runat="server" BehaviorID="CalendarExtender2" />
                                                <asp:TextBox ID="txtEditarData" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                <div class="input-group-append">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarData" CssClass="btn-using ok p-2" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarData_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnEditarDataDel" CssClass="ml-3 btn-using cancelar p-2" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewMoeda" runat="server">
                                <table>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="lblEditarMoeda" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <dx:ASPxTextBox ID="txtEditarMoeda" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <MaskSettings Mask="<-9999999..9999999g>.<00..99>" PromptChar="0" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                    <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                                <%--<asp:TextBox ID="txtEditarMoeda" CssClass="text-boxes valor" runat="server"></asp:TextBox>--%>
                                                <div class="input-group-append">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarMoeda" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarMoeda_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button4" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewInteiro" runat="server">
                                <table>
                                    <tr>
                                        <td colspan="2">
                                            <asp:CustomValidator ID="CustomValidator1" EnableClientScript="false" Display="Dynamic" ControlToValidate="txtEditarInteiro" runat="server" ValidationGroup="grpInteiro" ValidateEmptyText="true" OnServerValidate="CustomValidator1_ServerValidate" ErrorMessage="CustomValidator"></asp:CustomValidator>
                                            <asp:Label ID="lblEditarInteiro" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <dx:ASPxTextBox ID="txtEditarInteiro" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <ValidationSettings CausesValidation="true" ValidationGroup="grpInteiro" ErrorDisplayMode="None"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                                <div class="input-group-append">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarInteiro" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="true" ValidationGroup="grpInteiro" OnClick="btnEditarInteiro_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button5" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewFlutuante" runat="server">
                                <table>
                                    <tr>
                                        <td colspan="2">

                                            <asp:Label ID="lblEditarFlutuante" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <dx:ASPxTextBox ID="txtEditarFlutuante" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <MaskSettings Mask="<-9999999..9999999g>.<00..99>" PromptChar="0" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                    <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                                <%--<asp:TextBox ID="txtEditarFlutuante" CssClass="text-boxes valor" runat="server"></asp:TextBox>--%>
                                                <div class="input-group-append">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarFlutuante" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarFlutuante_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button6" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewFormula" runat="server">
                                <table>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="lblEditarFormula" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <asp:DropDownList ID="dropEditarFormula" CssClass="text-boxes" runat="server"></asp:DropDownList>
                                                <div class="input-group-append">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarFormula" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarFormula_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button7" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewIndice" runat="server">
                                <table>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="lblEditarIndice" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <asp:TextBox ID="txtEditarIndice" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                <div class="input-group-append">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarIndice" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarIndice_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button8" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewSql" runat="server">
                                <table>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="lblEditarSql" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <dx:ASPxComboBox ID="dropEditarSql2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" Theme="Material" Width="100%">
                                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarSql" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarSql_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button9" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewDeAte" runat="server">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <dx:ASPxGridView ID="gridRptDeAte" Theme="Material" runat="server" KeyFieldName="ID" Width="100%" OnInitNewRow="gridRptDeAte_InitNewRow" OnBatchUpdate="gridRptDeAte_BatchUpdate" AutoGenerateColumns="False">
                                            <ClientSideEvents BatchEditChangesSaving="function(s,e){ popupBasesAlterar.Hide(); }"
                                                EndCallback="function(s,e) { document.getElementById('Button10gridDeAte').click(); } " />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsCommandButton>
                                                <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="20px">
                                                    <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="20px">
                                                    </Image>
                                                </NewButton>
                                                <DeleteButton Image-ToolTip="Excluir" Image-Url="img/icons8-delete-bin-32.png" Image-Width="20px">
                                                    <Image ToolTip="Excluir" Url="img/icons8-delete-bin-32.png" Width="20px">
                                                    </Image>
                                                </DeleteButton>
                                                <RecoverButton Image-ToolTip="Cancelar" Image-Url="img/icons8-recyle-32.png" Image-Width="20px">
                                                    <Image ToolTip="Cancelar" Url="img/icons8-recyle-32.png" Width="20px">
                                                    </Image>
                                                </RecoverButton>
                                            </SettingsCommandButton>
                                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Columns>
                                                <dx:GridViewCommandColumn MaxWidth="8" Width="8" ButtonRenderMode="Image" ButtonType="Image" ShowDeleteButton="true" ShowNewButtonInHeader="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                <dx:GridViewDataDateColumn FieldName="De" Caption="<%$ Resources:Aquisicao, aquisição_grid_de %>" VisibleIndex="1">
                                                    <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                        <ValidationSettings Display="Dynamic">
                                                        </ValidationSettings>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataDateColumn FieldName="Ate" Caption="<%$ Resources:Aquisicao, aquisição_grid_ate %>" VisibleIndex="2">
                                                    <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                        <ValidationSettings Display="Dynamic">
                                                        </ValidationSettings>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataTextColumn FieldName="Valor" Caption="<%$ Resources:Aquisicao, aquisição_grid_valor %>" VisibleIndex="3" ShowInCustomizationForm="true">
                                                    <PropertiesTextEdit DisplayFormatString="N8" DisplayFormatInEditMode="true">
                                                        <ValidationSettings Display="Dynamic">
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                            <Settings VerticalScrollableHeight="150" />
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
                                    </div>
                                </div>
                            </asp:View>
                            <asp:View ID="viewTexto" runat="server">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblEditarTexto" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-3">
                                                <asp:TextBox ID="txtEditarTexto" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                <div class="input-group-append">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnEditarTexto" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarTexto_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="Button3" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:View>
                            <asp:View ID="viewDeAteData" runat="server">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <dx:ASPxGridView ID="gridRptDeAteData" Theme="Material" runat="server" KeyFieldName="ID" Width="100%" OnInitNewRow="gridRptDeAteData_InitNewRow" OnBatchUpdate="gridRptDeAteData_BatchUpdate" AutoGenerateColumns="False">
                                            <ClientSideEvents BatchEditChangesSaving="function(s,e){ popupBasesAlterar.Hide(); }"
                                                EndCallback="function(s,e) { document.getElementById('Button10gridDeAte').click(); } " />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsCommandButton>
                                                <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="20px">
                                                    <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="20px">
                                                    </Image>
                                                </NewButton>
                                                <DeleteButton Image-ToolTip="Excluir" Image-Url="img/icons8-delete-bin-32.png" Image-Width="20px">
                                                    <Image ToolTip="Excluir" Url="img/icons8-delete-bin-32.png" Width="20px">
                                                    </Image>
                                                </DeleteButton>
                                                <RecoverButton Image-ToolTip="Cancelar" Image-Url="img/icons8-recyle-32.png" Image-Width="20px">
                                                    <Image ToolTip="Cancelar" Url="img/icons8-recyle-32.png" Width="20px">
                                                    </Image>
                                                </RecoverButton>
                                            </SettingsCommandButton>
                                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Columns>
                                                <dx:GridViewCommandColumn MaxWidth="8" Width="8" ButtonRenderMode="Image" ButtonType="Image" ShowDeleteButton="true" ShowNewButtonInHeader="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                <dx:GridViewDataDateColumn FieldName="De" Caption="<%$ Resources:Aquisicao, aquisição_grid_de %>" VisibleIndex="1">
                                                    <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                        <ValidationSettings Display="Dynamic">
                                                        </ValidationSettings>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataDateColumn FieldName="Ate" Caption="<%$ Resources:Aquisicao, aquisição_grid_ate %>" VisibleIndex="2">
                                                    <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                        <ValidationSettings Display="Dynamic">
                                                        </ValidationSettings>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataTextColumn FieldName="Valor" Caption="<%$ Resources:Aquisicao, aquisição_grid_valor %>" VisibleIndex="3" ShowInCustomizationForm="true">
                                                    <PropertiesTextEdit DisplayFormatString="N8" DisplayFormatInEditMode="true">
                                                        <ValidationSettings Display="Dynamic">
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataDateColumn FieldName="Data" Caption="<%$ Resources:Aquisicao, aquisição_grid_data %>" VisibleIndex="4">
                                                    <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                        <ValidationSettings Display="Dynamic">
                                                        </ValidationSettings>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                            </Columns>
                                            <Settings VerticalScrollableHeight="150" />
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
                                    </div>
                                </div>
                            </asp:View>
                        </asp:MultiView>
                    </asp:Panel>

                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
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
    <asp:HiddenField ID="hfUser2" runat="server" />
    <div class="container p-0">
        <div class="row card" style="margin: 0 auto">
            <div class="card-header p-0 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:Aquisicao, umbrella_right_titulo %>" CssClass="labels text-left" Font-Size="15pt"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
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
                                <dx:ASPxGridView ID="ASPxGridView1" ClientIDMode="Static" Width="990px" ClientInstanceName="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="sqlProcessos" Theme="Material">
                                    <ClientSideEvents RowDblClick="function(s, e) {                                            
                                                ddePesqContrato.HideDropDown();
                                                document.getElementById('btnselecionar').click();
                                            }" />
                                    <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" ShowFilterRow="True" />
                                    <SettingsPager Visible="false"></SettingsPager>
                                    <SettingsBehavior AllowFocusedRow="True" />
                                    <SettingsPopup>
                                        <HeaderFilter MinHeight="140px">
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <Columns>
                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col1 %>" Width="70px" MaxWidth="70" FieldName="OPCDCONT" VisibleIndex="0">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" ValueField="OPCDCONT" TextField="OPCDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <EditFormSettings VisibleIndex="0" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col2 %>" Width="170px" MaxWidth="170" FieldName="TVDSESTR" VisibleIndex="1">
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
        <div class="row mt-3" style="margin: 0 auto">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <asp:Button ID="btnInsert" Enabled="true" CausesValidation="false" CssClass="Loading btn-using" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" CommandArgument="inserir" OnCommand="AcoesBotoes" OnLoad="btnInsert_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnDelete" Enabled="false" CausesValidation="false" CssClass="Loading btn-using" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CommandArgument="excluir" OnCommand="AcoesBotoes" OnLoad="btnDelete_Load" />

            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 8px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnEdit" Enabled="false" CausesValidation="false" CssClass="Loading btn-using" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CommandArgument="alterar" OnCommand="AcoesBotoes" OnLoad="btnEdit_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;">
                <asp:TextBox ID="TextBox10" CssClass="btn-using field_empty" Enabled="false" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 8px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                <dx:ASPxButton ID="btnOK1" runat="server" CssClass="btn-using ok" Enabled="false" AutoPostBack="true" OnClick="btnOK1_Click" CausesValidation="true" Text="OK">
                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                </dx:ASPxButton>
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                <asp:Button ID="btnCancelar1" Enabled="false" CausesValidation="false" runat="server" CssClass="Loading btn-using" Text="<%$ Resources:GlobalResource, btn_cancelar %>" Style="background-color: #CC9999;" OnClick="btnCancelar1_Click" />
            </div>
        </div>

    </div>
</asp:Content>
