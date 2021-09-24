<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RequisitaContrato.aspx.cs" Inherits="WebNesta_IRFS_16.RequisitaContrato" %>

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
            $("#myLinkTag").on('click', function () {
                $("#myLinkTagBtn").click();

            });
        });
        function ClearSelection() {
            TreeList.SetFocusedNodeKey("");
            UpdateControls(null, "");
            document.getElementById('hfDropEstr').value = "";
        }
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropEstr').value = TreeList.GetFocusedNodeKey();
            //dropCarteiraInsert2.PerformCallback(document.getElementById('hfDropEstr').value);
            //dropAgenteFinanceiroInsert2.PerformCallback(document.getElementById('hfDropEstr').value);
            //dropBenefIns.PerformCallback(document.getElementById('hfDropEstr').value);
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
            dropTipoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
        }
    </script>
        <script type="text/javascript">  
            function QuickGuide(guide) {
                switch (guide) {
                    case 'grp1_01':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_01_guide%>';
                        break;
                    case 'grp1_02':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_02_guide%>';
                        break;
                    case 'grp1_03':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_03_guide%>';
                        break;
                    case 'grp1_04':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_04_guide%>';
                        break;
                    case 'grp1_05':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_05_guide%>';
                        break;
                    case 'grp1_06':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_06_guide%>';
                        break;
                    case 'grp1_07':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_07_guide%>';
                        break;
                    case 'grp1_08':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_08_guide%>';
                        break;
                    case 'grp1_09':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_09_guide%>';
                        break;
                    case 'grp1_10':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_10_guide%>';
                        break;
                    case 'grp1_11':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_11_guide%>';
                        break;
                    case 'grp1_12':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_12_guide%>';
                        break;
                    case 'grp1_13':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_13_guide%>';
                        break;
                    case 'grp1_14':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_14_guide%>';
                        break;
                    case 'grp1_15':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_15_guide%>';
                        break;
                    case 'grp1_16':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_16_guide%>';
                        break;
                    case 'grp1_17':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp1_17_guide%>';
                        break;
                    case 'grp2_01':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp2_01_guide%>';
                        break;
                    case 'grp2_02':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp2_02_guide%>';
                        break;
                    case 'grp2_03':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp2_03_guide%>';
                        break;
                    case 'grp2_04':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp2_04_guide%>';
                        break;
                    case 'grp3_01':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_01_guide%>';
                        break;
                    case 'grp3_02':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_02_guide%>';
                        break;
                    case 'grp3_03':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_03_guide%>';
                        break;
                    case 'grp3_04':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_04_guide%>';
                        break;
                    case 'grp3_05':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_05_guide%>';
                        break;
                    case 'grp3_06':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_06_guide%>';
                        break;
                    case 'grp3_07':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_07_guide%>';
                        break;
                    case 'grp3_08':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_08_guide%>';
                        break;
                    case 'grp3_09':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_09_guide%>';
                        break;
                    case 'grp3_10':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp3_10_guide%>';
                        break;
                    case 'grp4':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp4_guide%>';
                        break;
                    case 'grp5':
                        document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RequisitaContrato.label_grp5_guide%>';
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
                    case 'sel_contrato':
                        document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.sel_contrato_guide %>';
                        break;
                }

            }

        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfIDImovel" runat="server" />
    <asp:HiddenField ID="hfIndexGridWF" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfIndexGrid" runat="server" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="panelActive1" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfPaisUser" runat="server" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfqueryRpt" runat="server" />
    <asp:HiddenField ID="hfInsertOK" runat="server" />
    <asp:HiddenField ID="hfCodInterno" runat="server" />
    <asp:HiddenField ID="hfProduto" runat="server" />
    <asp:HiddenField ID="hfCHIDCODI" runat="server" />
    <asp:HiddenField ID="hfOPIDCONT" runat="server" />
    <asp:HiddenField ID="hfCJIDCODI" runat="server" />
    <asp:HiddenField ID="hfCJTPIDTP" runat="server" />
    <asp:HiddenField ID="hfOPCDCONT" runat="server" />
    <asp:HiddenField ID="hfTVDSESTR" runat="server" />
    <asp:HiddenField ID="hfPRPRODES" runat="server" />
    <asp:HiddenField ID="OPNMCONT" runat="server" />
    <asp:HiddenField ID="hfOPVLCONT" runat="server" />
    <asp:HiddenField ID="hfPRPRODID" runat="server" />
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
                <div id="cardContrato">
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" style="height: 40px">
                            <a class="card-link" data-toggle="collapse" href="#collapseInsertInfoImovel" aria-expanded="true">
                                <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label11" runat="server" CssClass="labels" Text="Informações Imóvel"></asp:Label></h5>
                            </a>
                        </div>
                        <div id="collapseInsertInfoImovel" class="collapse show" data-parent="#cardContrato">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Button ID="btnSelEmp" runat="server" CausesValidation="false" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
                                        <asp:Label ID="lblEstruturaCorporativaInsert" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_01 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="margin-top: 2px" onmouseover="QuickGuide('grp1_01');">
                                            <asp:SqlDataSource ID="sqlTreeList" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT B.TVIDESTR, B.TVDSESTR, B.TVCDPAIE, B.TVNVESTR,
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
                                                                    <dx:ASPxTreeList ID="TreeList" DataSourceID="sqlTreeList" ClientInstanceName="TreeList" runat="server"
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
                                        <asp:Label ID="Label42" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_011 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_011');">
                                            <dx:ASPxComboBox ID="comboImovel" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlImovel"
                                                ValueType="System.String" ValueField="REIDIMOV" TextField="REREGIAO" AutoPostBack="true" OnSelectedIndexChanged="comboImovel_SelectedIndexChanged">
                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>

                                            <asp:SqlDataSource runat="server" ID="sqlImovel" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="select REREGIAO,REIDIMOV from REIMOVEL where TVIDESTR=?">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label12" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_02 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" ControlToValidate="dropTipoImov" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_02');">
                                            <dx:ASPxComboBox ID="dropTipoImov" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlTipoImovel"
                                                ValueType="System.String" ValueField="TPIDIMOV" TextField="TPDSIMOV">
                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>

                                            <asp:SqlDataSource runat="server" ID="sqlTipoImovel" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="SELECT TPIDIMOV,TPDSIMOV FROM TPIMOVEL order by 2"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label13" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_03 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" ControlToValidate="txtRegAdmin" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_03');">
                                            <asp:TextBox ID="txtRegAdmin" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label14" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_04 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" ControlToValidate="txtNoContribu" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_04');">
                                            <asp:TextBox ID="txtNoContribu" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label16" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_06 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator17" ControlToValidate="txtCep" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_06');">
                                            <dx:ASPxTextBox ID="txtCep" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <ClientSideEvents TextChanged="function(s,e) { callBackGeoLocal.PerformCallback(s.GetText()); } " />
                                                <MaskSettings Mask="<99999>-<999>" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="InsertReq">
                                                    <RequiredField IsRequired="true" ErrorText="*" />

                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x2 p-0">
                                        <asp:Label ID="Label15" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_05 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="margin-top: 2px" onmouseover="QuickGuide('grp1_05');">
                                            <dx:ASPxCallbackPanel ID="callBackGeoLocal" ClientInstanceName="callBackGeoLocal" OnCallback="callBackGeoLocal_Callback" runat="server" Width="100%">
                                                <ClientSideEvents EndCallback="function(s,e) {
                                                    if(s.cp_latlng != null)
                                                    {
                                                        var site = 'https://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q={latlng}&z=14&output=embed';
                                                    site = site.replace('{latlng}',s.cp_latlng);
                                                        document.getElementById('framGeoLocal').src = site;
                                                        delete (s.cp_latlng);
                                                    }
                                                    }" />

                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxDropDownEdit ID="ddeGeoLocal" Enabled="false" runat="server" CssClass="drop-down text-left" Theme="Material"
                                                            Width="100%" AnimationType="Slide" AllowUserInput="true">
                                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                            </ButtonStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            <DropDownWindowTemplate>
                                                                <iframe id="framGeoLocal" width="500" height="300" frameborder="0" style="border: 0;" allowfullscreen="" aria-hidden="false" tabindex="0"></iframe>
                                                            </DropDownWindowTemplate>
                                                        </dx:ASPxDropDownEdit>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxCallbackPanel>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label17" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_07 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator20" ControlToValidate="dropLogradoura" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_07');">
                                            <dx:ASPxComboBox ID="dropLogradoura" Enabled="false" ForeColor="dimgray" AllowInputUser="false" CssClass="drop-down" runat="server"
                                                TextField="texto" ValueField="id" ValueType="System.String" Theme="Material" Width="100%" DataSourceID="sqlLogradouros">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <asp:SqlDataSource runat="server" ID="sqlLogradouros" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select LOGCODID as id ,concat(LOGTXTCD, ' - ', LOGRANOM) as texto from LOGRACOD order by 2"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label18" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_08 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator21" ControlToValidate="txtAnoConst" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_08');">
                                            <dx:ASPxDateEdit ID="txtAnoConst" Enabled="false" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Years" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label19" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_09 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator22" ControlToValidate="dropSituacao" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" style="margin-top: 2px" onmouseover="QuickGuide('grp1_09');">
                                            <dx:ASPxComboBox ID="dropSituacao" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlSituacao"
                                                ValueType="System.String" ValueField="TPIDSITU" TextField="TPDSSITU">
                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <ValidationSettings RequiredField-IsRequired="true" RequiredField-ErrorText="*" ErrorFrameStyle-ForeColor="Red" Display="Dynamic" ValidationGroup="Imovel"></ValidationSettings>
                                            </dx:ASPxComboBox>

                                            <asp:SqlDataSource runat="server" ID="sqlSituacao" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="select TPIDSITU,TPDSSITU from TPSITIMO ORDER BY 2"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label20" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_10 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator23" ControlToValidate="txtNoProcRegis" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_10');">
                                            <asp:TextBox ID="txtNoProcRegis" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label21" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_11 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator24" InitialValue="0,00" ControlToValidate="txtTestadaPrinc" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_11');">
                                            <dx:ASPxTextBox ID="txtTestadaPrinc" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="InsertReq">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label22" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_12 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator25" InitialValue="0,00" ControlToValidate="txtAreaTerreno" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_12');">
                                            <dx:ASPxTextBox ID="txtAreaTerreno" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="InsertReq" CausesValidation="true" ErrorText="*">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label23" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_13 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator26" InitialValue="0,00" ControlToValidate="txtAreaEdificada" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_13');">
                                            <dx:ASPxTextBox ID="txtAreaEdificada" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="InsertReq" CausesValidation="true" ErrorText="*">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label24" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_14 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator27" InitialValue="0,00" ControlToValidate="txtAreaComum" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_14');">
                                            <dx:ASPxTextBox ID="txtAreaComum" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="InsertReq" CausesValidation="true" ErrorText="*">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label25" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_15 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator28" InitialValue="0,00" ControlToValidate="txtFracIdeal" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_15');">
                                            <dx:ASPxTextBox ID="txtFracIdeal" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="InsertReq" CausesValidation="true" ErrorText="*">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label26" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_16 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator29" ControlToValidate="txtDataRegis" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_16');">
                                            <dx:ASPxDateEdit ID="txtDataRegis" Enabled="false" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                                    <div class="col-x0"></div>
                                    <div class="p-0 col-x1">
                                        <asp:Label ID="Label27" runat="server" Text="<%$Resources:RequisitaContrato, label_grp1_17 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator30" InitialValue="0,00" ControlToValidate="txtValorVenal" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp1_17');">
                                            <dx:ASPxTextBox ID="txtValorVenal" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="InsertReq">
                                                    <RequiredField IsRequired="true" ErrorText="*" />

                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="p-0 col-x1">
                                        <br />
                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                            <asp:TextBox ID="TextBox1" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label28" runat="server" Text="<%$Resources:RequisitaContrato, label_grp2_01 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp2_01');">
                                            <dx:ASPxDateEdit ID="txtDataVistoria" Enabled="false" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above" PopupHorizontalAlign="Center">
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
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label31" runat="server" Text="<%$Resources:RequisitaContrato, label_grp2_02 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator31" ControlToValidate="txtDataReceb" ValidationGroup="InsertReq" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp2_02');">
                                            <dx:ASPxDateEdit ID="txtDataReceb" Enabled="false" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above" PopupHorizontalAlign="Center">
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
                                    <div class="col-x0"></div>
                                    <div class="p-0 col-x1">
                                        <asp:Label ID="Label32" runat="server" Text="<%$Resources:RequisitaContrato, label_grp2_03 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px" onmouseover="QuickGuide('grp2_03');">
                                            <dx:ASPxDateEdit ID="txtDataDevol" Enabled="false" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above" PopupHorizontalAlign="Center">
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
                                    <div class="col-x0"></div>
                                    <div class="p-0 col-x1">
                                        <asp:Label ID="Label34" runat="server" Text="<%$Resources:RequisitaContrato, label_grp2_04 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px" onmouseover="QuickGuide('grp2_04');">
                                            <dx:ASPxDateEdit ID="txtDataInaug" Enabled="false" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above" PopupHorizontalAlign="Center">
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
                            </div>
                        </div>
                    </div>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" style="height: 40px">
                            <a class="card-link" data-toggle="collapse" href="#collapseInsertInfo">
                                <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label7" runat="server" CssClass="labels" Text="Informações Contrato"></asp:Label></h5>
                            </a>
                        </div>
                        <div id="collapseInsertInfo" class="collapse" data-parent="#cardContrato">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_01 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp3_01');">
                                            <asp:TextBox ID="txtOperadorInsert" Width="100%" Enabled="false" CssClass="text-boxes" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblNumProcessoInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_02 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator9" ValidationGroup="InsertReq" ControlToValidate="txtNumProcessoInsert" runat="server" ForeColor="Red" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl3 %>"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp3_02');">
                                            <asp:TextBox ID="txtNumProcessoInsert" Enabled="false" MaxLength="25" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblCodAuxInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_03 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp3_03');">
                                            <asp:TextBox ID="txtCodAuxInsert" Enabled="false" MaxLength="15" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblDtAquisiInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_04 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator11" ValidationGroup="InsertReq" ControlToValidate="txtDataSolic" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl6 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('grp3_04');">
                                            <dx:ASPxDateEdit ID="txtDataSolic" Enabled="false" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                    <div class="col-x2 p-0">
                                        <asp:Label ID="lblDescricaoInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_05 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator10" ValidationGroup="InsertReq" ControlToValidate="txtDescricaoInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl5 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp3_05');">
                                            <dx:ASPxTextBox ID="txtDescricaoInsert" Enabled="false" MaxLength="60" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <ValidationSettings ValidateOnLeave="true" RegularExpression-ValidationExpression="[^']*" ErrorDisplayMode="None"></ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblHrAquisiInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_06 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator12" ValidationGroup="InsertReq" ControlToValidate="txtValorCont" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('grp3_06');">
                                            <dx:ASPxTextBox ID="txtValorCont" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%">
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
                                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_07 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="InsertReq" ControlToValidate="dropAgenteFinanceiroInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp2_lbl1 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp3_07');">
                                            <dx:ASPxComboBox ID="dropAgenteFinanceiroInsert2" Enabled="false" ClientInstanceName="dropAgenteFinanceiroInsert2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlAgenteFinanceiro" TextField="FONMFORN" ValueField="FOIDFORN">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <asp:SqlDataSource runat="server" ID="sqlAgenteFinanceiro" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT FOIDFORN,FONMFORN FROM FOFORNEC FO where FOTPIDTP=8 ORDER BY 2"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblEstruturaInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_08 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator14" ValidationGroup="InsertReq" ControlToValidate="dropEstruturaInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl8 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('grp3_08');">
                                            <dx:ASPxComboBox ID="dropEstruturaInsert2" Enabled="false" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropEstruturaInsert2" CssClass="drop-down" runat="server" DataSourceID="sqlEstruturaInsert"
                                                TextField="cmtpdscm" ValueField="cmtpidcm" Theme="Material" Width="100%">
                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCountryChanged(s); }"></ClientSideEvents>
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <asp:SqlDataSource runat="server" ID="sqlEstruturaInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="select cmtpdscm, cmtpidcm from cmtpcmcl where paidpais = ? and CMTPDSCM in ('Contrato Aluguel','Contrato') order by cmtpidcm">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblClasseProdutoInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_09 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator15" ValidationGroup="InsertReq" ControlToValidate="dropClasseProdutoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl9 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('grp3_09');">
                                            <dx:ASPxComboBox ID="dropClasseProdutoInsert2" Enabled="false" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropClasseProdutoInsert2" runat="server" CssClass="drop-down" DataSourceID="sqlClasseProdutosInsert"
                                                TextField="PRTPNMOP" ValueField="PRTPIDOP" Theme="Material" Width="100%" OnCallback="dropClasseProdutoInsert2_Callback">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="3px" />
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
                                        <asp:Label ID="lblTipoInsert" runat="server" Text="<%$ Resources:RequisitaContrato, label_grp3_10 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto drop-down-div" style="padding-left: 2px" onmouseover="QuickGuide('grp3_10');">
                                            <dx:ASPxComboBox ID="dropTipoInsert2" ClientEnabled="false" ForeColor="dimgray" ClientInstanceName="dropTipoInsert2" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                DataSourceID="sqlTipoInsert" ValueField="optptpid" TextField="optptpds" OnCallback="dropTipoInsert2_Callback">
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxComboBox>
                                            <asp:SqlDataSource runat="server" ID="sqlTipoInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="select optptpid, optptpds
            from optptipo
            where cmtpidcm = ?
            and paidpais = ?
            order by optptpid">
                                                <SelectParameters>
                                                    <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                    <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" Name="?" DbType="Int32"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <br />
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('13');">
                                            <asp:TextBox ID="TextBox2" Width="100%" Enabled="false" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            <asp:SqlDataSource runat="server" ID="sqlResponsavel" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="select USNMPRUS,USIDUSUA from TUSUSUARI 
WHERE USIDUSUA NOT IN (SELECT CONVERT(CHAR,TBIDUSER) FROM TBTBUSER)
and USIDUSUA IN (SELECT USIDUSUA FROM VIFSFUSU WHERE TVIDESTR=?)
UNION
SELECT TBFNUSER,convert(char,TBIDUSER) FROM TBTBUSER
WHERE CONVERT(CHAR,TBIDUSER) IN (SELECT USIDUSUA FROM VIFSFUSU WHERE TVIDESTR=?)">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </div>
                                    </div>


                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('grp4');">
                            <%--                            <asp:Button ID="myLinkTagBtn" ClientIDMode="Static" ValidationGroup="InsertReq" Style="display: none" OnClick="myLinkTagBtn_Click" runat="server" Text="Button" />--%>
                            <a id="myLinkTag" class="card-link" data-toggle="collapse" href="#collapseInsertBases">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label9" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, aquisição_grp3_titulo %>"></asp:Label></h5>
                            </a>
                        </div>
                        <div class="card-body bg-transparent pb-0 pt-1">
                            <div id="collapseInsertBases" class="collapse" data-parent="#cardContrato">
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
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('grp5');">
                            <a class="card-link" data-toggle="collapse" href="#collapsecontratoWorkFlow">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label5" runat="server" CssClass="labels" Text="WorkFlow"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapsecontratoWorkFlow" class="collapse show" data-parent="#cardContrato">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <dx:ASPxGridView ID="gridWWF" ClientInstanceName="gridWWF" Enabled="false" KeyFieldName="WFIDTASK" ClientIDMode="Static" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlWWF"
                                    OnCustomButtonCallback="gridWWF_CustomButtonCallback" OnDetailRowGetButtonVisibility="gridWWF_DetailRowGetButtonVisibility" OnCustomButtonInitialize="gridWWF_CustomButtonInitialize">
                                    <ClientSideEvents EndCallback="function(s, e) {
                                        var element = document.getElementById('lblMsgException');
	                                    if (s.cp_origem == 'alterar') {
                                            dropResponsavel2.SetValue((s.cp_responsavel));
                                            dropPriori.SetValue((s.cp_prioridade));
                                            txtDataPrazo.SetText((s.cp_prazo));
                                            document.getElementById('hfIndexGridWF').value = s.cp_visibleIndex;
                                            popupAlterarWF.Show();
                                            delete(s.cp_visibleIndex);
                                            delete(s.cp_origem);
                                            delete(s.cp_responsavel);
                                            delete(s.cp_prioridade);
                                            delete(s.cp_prazo);
                                     } 
                                        else if (s.cp_origem == 'aprovar') {
                                            if(s.cp_ok=='OK')
                                            {
                                                s.Refresh();
                                                if(s.cp_final=='sim')
                                        {
                                        delete(s.cp_final);
                                                document.getElementById('hfIndexGridWF').value = s.cp_visibleIndex;
                                                dropTipologia2.PerformCallback();
                                                popupFinalWF.Show();
                                        }
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                        else if (s.cp_origem == 'recusar') {
                                            if(s.cp_ok=='OK')
                                            {
                                                element.classList.add('text-sucess');
                                                element.innerHTML = 'Notificação enviada por SMS / E-mail.';
                                                openModal();
                                                s.Refresh();
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                    }"></ClientSideEvents>
                                    <SettingsPopup>
                                        <HeaderFilter MinHeight="140px">
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <SettingsPager NumericButtonCount="20" PageSize="20">
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
                                    <SettingsDetail AllowOnlyOneMasterRowExpanded="true" ShowDetailButtons="true" ShowDetailRow="true" />
                                    <Images>
                                        <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                        <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                    </Images>
                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="100px" Caption="Contrato" VisibleIndex="0" EditFormSettings-Visible="False">
                                            <CellStyle HorizontalAlign="Center"></CellStyle>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="OPNMCONT" Width="200px" Caption="Descrição" VisibleIndex="1" EditFormSettings-Visible="False">
                                            <CellStyle Wrap="True"></CellStyle>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataDateColumn FieldName="WFDTTASK" Width="100px" Caption="Prazo" VisibleIndex="5" EditFormSettings-Visible="False"></dx:GridViewDataDateColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="USIDUSUA" Width="100px" Caption="Endereçado" VisibleIndex="2">
                                            <PropertiesComboBox DataSourceID="sqlResponsavel" TextField="USNMPRUS" ValueField="USIDUSUA" ValueType="System.String"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="WFIDPRIO" Width="70px" Caption="Prioridade" VisibleIndex="3">
                                            <PropertiesComboBox DataSourceID="sqlPriori" TextField="WFNMPRIO" ValueField="WFIDPRIO" ValueType="System.String"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="WFIDFLOW" Width="100px" Caption="Modo" VisibleIndex="4">
                                            <PropertiesComboBox DataSourceID="sqlModo" TextField="WFDSFLOW" ValueField="WFIDFLOW" ValueType="System.String"></PropertiesComboBox>
                                            <EditFormSettings Visible="False"></EditFormSettings>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="WFSTTASK" Width="100px" Caption="Status" VisibleIndex="6">
                                            <PropertiesComboBox DataSourceID="sqlStatus" TextField="WFDSSTAT" ValueField="WFIDSTAT"></PropertiesComboBox>
                                            <PropertiesComboBox>
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewCommandColumn Caption=" " VisibleIndex="7" Width="150px" ButtonRenderMode="Image">
                                            <CellStyle Paddings-Padding="2px"></CellStyle>
                                            <CustomButtons>
                                                <dx:GridViewCommandColumnCustomButton ID="alterar" Text="Alterar">
                                                    <Image Url="icons/grid_alterar.png" Height="20px"></Image>
                                                </dx:GridViewCommandColumnCustomButton>
                                                <dx:GridViewCommandColumnCustomButton ID="aprovar" Text="Aprovar">
                                                    <Image Url="icons/grid_aprova.png" Width="20px"></Image>
                                                </dx:GridViewCommandColumnCustomButton>
                                                <dx:GridViewCommandColumnCustomButton ID="recusar" Text="Recusar">
                                                    <Image Url="icons/grid_recusa.png" Width="20px"></Image>
                                                </dx:GridViewCommandColumnCustomButton>
                                            </CustomButtons>
                                        </dx:GridViewCommandColumn>
                                    </Columns>
                                    <Templates>
                                        <DetailRow>
                                            <dx:ASPxGridView ID="gridDetailWF" ClientInstanceName="gridDetailWF" KeyFieldName="WFIDALTT" ClientIDMode="Static" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                DataSourceID="sqlDetailWf" OnBeforePerformDataSelect="gridDetailWF_BeforePerformDataSelect">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <Settings VerticalScrollableHeight="100" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                <SettingsPager NumericButtonCount="20" PageSize="20">
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
                                                    <dx:GridViewDataTextColumn FieldName="WFJUSTTK" Width="200px" Caption="Justificativa" VisibleIndex="0">
                                                        <CellStyle Wrap="True"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataDateColumn FieldName="WFDTALTT" Width="70px" Caption="Data" VisibleIndex="1"></dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataDateColumn FieldName="WFDTDATA" Width="70px" Caption="Prazo" VisibleIndex="6"></dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="USIDUSUA" Width="120px" Caption="Alterado por" VisibleIndex="2">
                                                        <PropertiesComboBox DataSourceID="sqlResponsavel" TextField="USNMPRUS" ValueField="USIDUSUA"></PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="USIDUS02" Width="120px" Caption="Endere&#231;ado" VisibleIndex="3">
                                                        <PropertiesComboBox DataSourceID="sqlResponsavel" TextField="USNMPRUS" ValueField="USIDUSUA"></PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="WFIDPRIO" Width="100px" Caption="Prioridade" VisibleIndex="5">
                                                        <PropertiesComboBox DataSourceID="sqlPriori" TextField="WFNMPRIO" ValueField="WFIDPRIO"></PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                </Columns>
                                                <Images>
                                                    <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                                    <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                                </Images>
                                                <Columns>
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
                                                    <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                    <InlineEditCell ForeColor="Red"></InlineEditCell>
                                                    <EditForm Paddings-Padding="0px" Font-Size="8pt"></EditForm>
                                                    <EditFormCell Paddings-Padding="0px" Font-Size="8pt"></EditFormCell>
                                                    <Table>
                                                    </Table>
                                                    <CommandColumn Paddings-Padding="0px"></CommandColumn>
                                                    <Cell Paddings-Padding="5px" Font-Size="8pt"></Cell>
                                                    <CommandColumn Paddings-Padding="0px"></CommandColumn>
                                                </Styles>
                                            </dx:ASPxGridView>
                                        </DetailRow>
                                    </Templates>
                                    <Styles>
                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                        <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="1px">
                                        </Header>
                                        <Row Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                                        </Row>
                                        <AlternatingRow Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                        <BatchEditCell Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                                            <Paddings Padding="0px" />
                                        </BatchEditCell>
                                        <DetailButton Paddings-Padding="0px"></DetailButton>
                                        <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                        <EditForm Paddings-Padding="0px"></EditForm>
                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                        <Table></Table>
                                        <Cell Paddings-Padding="2px"></Cell>
                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                    </Styles>
                                </dx:ASPxGridView>
                                <asp:SqlDataSource runat="server" ID="sqlPriori" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                    SelectCommand="select WFNMPRIO,WFIDPRIO from WFPRIORI"></asp:SqlDataSource>
                                <asp:SqlDataSource runat="server" ID="sqlStatus" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                    SelectCommand="SELECT WFIDSTAT,WFDSSTAT FROM WFSTATUS"></asp:SqlDataSource>
                                <asp:SqlDataSource runat="server" ID="sqlWWF" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                    SelectCommand="select WFIDTASK,OPIDCONT,OPNMCONT,USIDUSUA,WFIDPRIO,WFIDFLOW,WFDTTASK,WFSTTASK from wftaskop
where opidcont=?">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource runat="server" ID="sqlModo" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                    SelectCommand="SELECT WFDSFLOW,WFIDFLOW FROM WORKFLOW order by 2"></asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource runat="server" ID="sqlDetailWf" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select WFIDALTT, WFJUSTTK,WFDTALTT,USIDUSUA,USIDUS02,WFIDPRIO,WFDTDATA from WFALTTSK where WFIDTASK=? order by WFDTALTT">
        <SelectParameters>
            <asp:Parameter Name="?"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <dx:ASPxPopupControl ID="popupBasesInsert" CloseAction="CloseButton" CloseOnEscape="false" Modal="true"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="true"
        PopupAnimationType="None" AutoUpdatePosition="true" runat="server">
        <ContentStyle Paddings-PaddingBottom="20px"></ContentStyle>
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <asp:MultiView ID="MultiViewInsert" runat="server">
                    <asp:View ID="viewDataI" runat="server">
                        <asp:HiddenField ID="hfTipoData" runat="server" />
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInserirData" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-3">
                                        <ajaxToolkit:CalendarExtender ID="CalendarInserirData" PopupButtonID="txtInserirData" TargetControlID="txtInserirData" ClientIDMode="Static" Enabled="true" runat="server" />
                                        <asp:TextBox ID="txtInserirData" CssClass="text-boxes" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnInserirData" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirData_Click" />

                                </td>
                            </tr>
                        </table>
                    </asp:View>
                    <asp:View ID="viewMoedaI" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInserirMoeda" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-3">
                                        <dx:ASPxTextBox ID="txtInserirMoeda" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                            <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                            <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxTextBox>
                                        <%--<asp:TextBox ID="txtInserirMoeda" CssClass="text-boxes valor" runat="server"></asp:TextBox>--%>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnInserirMoeda" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirMoeda_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:View>
                    <asp:View ID="viewInteiroI" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInserirInteiro" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtInserirInteiro" CssClass="text-boxes" runat="server" TextMode="Number"></asp:TextBox>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnInserirInteiro" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirInteiro_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:View>
                    <asp:View ID="viewFlutuanteI" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInserirFlutuante" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-3">
                                        <dx:ASPxTextBox ID="txtInserirFlutuante" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                            <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                            <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxTextBox>
                                        <%--<asp:TextBox ID="txtInserirFlutuante" CssClass="text-boxes valor" runat="server"></asp:TextBox>--%>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnInserirFlutuante" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirFlutuante_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:View>
                    <asp:View ID="viewFormulaI" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInserirFormula" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:DropDownList ID="dropInserirFormula" CssClass="text-boxes" runat="server"></asp:DropDownList>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnInserirFormula" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirFormula_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:View>
                    <asp:View ID="viewIndiceI" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInserirIndice" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtInserirIndice" CssClass="text-boxes" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnInserirIndice" CssClass="btn-using ok" runat="server" OnClick="btnInserirIndice_Click" Text="<%$ Resources:GlobalResource, btn_inserir %>" />
                                </td>
                            </tr>
                        </table>
                    </asp:View>
                    <asp:View ID="viewSQLI" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInserirSql" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:DropDownList ID="dropInserirSql" CssClass="text-boxes" runat="server"></asp:DropDownList>
                                        <div class="input-group-append">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="btnInserirSql" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirSql_Click" />
                                </td>
                            </tr>
                        </table>
                    </asp:View>
                    <asp:View ID="viewDeAteI" runat="server">
                        <div class="row">
                            <div class="col-12">
                                <dx:ASPxGridView ID="gridDeAteInsert" Theme="DevEx" runat="server" KeyFieldName="ID;De;Ate;Valor" Width="100%" AutoGenerateColumns="False">
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
                                        <dx:GridViewDataDateColumn FieldName="De" VisibleIndex="1"></dx:GridViewDataDateColumn>
                                        <dx:GridViewDataDateColumn FieldName="Ate" VisibleIndex="2"></dx:GridViewDataDateColumn>
                                        <dx:GridViewDataTextColumn FieldName="Valor" VisibleIndex="3">
                                            <PropertiesTextEdit DisplayFormatString="n2">
                                                <ValidationSettings Display="Dynamic"></ValidationSettings>
                                            </PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <Settings VerticalScrollableHeight="150" />
                                    <SettingsEditing Mode="Batch" />
                                    <Styles>
                                        <StatusBar HorizontalAlign="Left"></StatusBar>
                                        <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                                        </Header>
                                        <Row Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                                        </Row>
                                        <AlternatingRow Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                        <BatchEditCell Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray"></BatchEditCell>
                                    </Styles>
                                </dx:ASPxGridView>
                            </div>
                        </div>
                    </asp:View>
                </asp:MultiView>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
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
                                                    <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
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
                                                    <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
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
                                        <dx:ASPxGridView ID="gridRptDeAte" Theme="Material" runat="server" KeyFieldName="ID;De;Ate;Valor" Width="100%" AutoGenerateColumns="False">
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
                                                    <PropertiesTextEdit DisplayFormatString="N2" DisplayFormatInEditMode="true">
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
                        </asp:MultiView>
                    </asp:Panel>

                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupAlterarWF" ClientInstanceName="popupAlterarWF" runat="server" Theme="Material"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ShowHeader="false" Modal="true" Width="600px" Height="300px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="card p-0">
                    <div class="card-header">
                        <h6>
                            <asp:Label ID="Label8" runat="server" Text="Avaliar as alterações necessárias e inserir a justifica para prosseguir." CssClass="labels text-left"></asp:Label></h6>
                    </div>
                    <div class="card-body">
                        <div class="row p-0 m-0 mb-1">
                            <div class="col-x2 p-0">
                                <asp:Label ID="Label29" runat="server" Text="Responsável" CssClass="labels text-left"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="dropResponsavel2" ValidationGroup="AlteraWWF" ForeColor="Red" runat="server" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto">
                                    <dx:ASPxComboBox ID="dropResponsavel2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropResponsavel2" CssClass="drop-down" runat="server" DataSourceID="sqlResponsavel"
                                        TextField="USNMPRUS" ValueField="USIDUSUA" Theme="Material" Width="100%">
                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        </ButtonStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                            <div class="col-x0 p-0"></div>
                            <div class="col-x2 p-0">
                                <asp:Label ID="Label2" runat="server" Text="Prioridade" CssClass="labels text-left"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="dropPriori" ValidationGroup="AlteraWWF" ForeColor="Red" runat="server" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto">
                                    <dx:ASPxComboBox ID="dropPriori" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropPriori" CssClass="drop-down" runat="server" DataSourceID="sqlPriori"
                                        TextField="WFNMPRIO" ValueField="WFIDPRIO" Theme="Material" Width="100%">
                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        </ButtonStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                            <div class="col-x0 p-0"></div>
                        </div>
                        <div class="row p-0 m-0 mb-1">
                            <div class="col-x2 p-0">
                                <asp:Label ID="Label4" runat="server" Text="Prazo" CssClass="labels text-left"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="txtDataPrazo" ValidationGroup="AlteraWWF" ForeColor="Red" runat="server" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto">
                                    <dx:ASPxDateEdit ID="txtDataPrazo" ClientInstanceName="txtDataPrazo" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                            <div class="col-x0 p-0"></div>
                            <div class="col-x2 p-0">
                                <asp:Label ID="Label6" runat="server" Text="Justificativa" CssClass="labels text-left"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ControlToValidate="txtJusti" ValidationGroup="AlteraWWF" ForeColor="Red" runat="server" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtJusti" ClientIDMode="Static" TextMode="MultiLine" Rows="3" CssClass="text-boxes" Width="100%" Height="60px" runat="server" MaxLength="255"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-x0 p-0"></div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="row p-0 m-0 mb-1">
                            <div class="col-lg-3 pl-0" style="text-align: center;">
                                <asp:Button ID="Button1" runat="server" CssClass="btn-using" ValidationGroup="AlteraWWF" Text="<%$ Resources:GlobalResource, btn_ok %>" OnClick="Button1_Click" Style="background-color: #FFCC66;" />
                            </div>
                            <div class="col-lg-3 pl-1" style="text-align: center;">
                                <asp:Button ID="Button2" CausesValidation="false" runat="server" CssClass="btn-using" OnClientClick="popupAlterarWF.Hide();return false;" Text="<%$ Resources:GlobalResource, btn_cancelar %>" Style="background-color: #CC9999;" />
                            </div>
                        </div>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupTimeLine" ClientInstanceName="popupTimeLine" runat="server" Theme="Material"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Time Line Workflow" Modal="true" Width="600px" Height="300px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row p-0 m-0">
                    <div class="p-0 col-x2">
                        <asp:Label ID="Label38" runat="server" Text="Data Recebimento Chaves"></asp:Label>
                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                            <asp:Label ID="lblDtRecebePopup" ClientIDMode="Static" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="col-x0"></div>
                    <div class="p-0 col-x2">
                        <asp:Label ID="Label39" runat="server" Text="Prazo Timeline"></asp:Label>
                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                            <asp:Label ID="lblDtSomaPopup" ClientIDMode="Static" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="col-x0"></div>
                </div>
                <asp:Repeater ID="rptTimeLine" runat="server" DataSourceID="sqlTimeLine">

                    <ItemTemplate>
                        <div class="row p-0 m-0">
                            <div class="p-0 col-x1">
                                <asp:Label ID="Label36" runat="server" Text="Endereçado"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator18" ControlToValidate="dropResponsavel3" ValidationGroup="InsertReq" ForeColor="Red" runat="server" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>

                                <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                    <dx:ASPxComboBox ID="dropResponsavel3" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropResponsavel3" CssClass="drop-down" runat="server" DataSourceID="sqlResponsavel"
                                        TextField="USNMPRUS" ValueField="USIDUSUA" Theme="Material" Width="100%">
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
                            <div class="p-0 col-x1">
                                <asp:Label ID="Label2" runat="server" Text="Prioridade" CssClass="labels text-left"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="dropPriori2" ValidationGroup="InsertReq" ForeColor="Red" runat="server" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto">
                                    <dx:ASPxComboBox ID="dropPriori2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropPriori2" CssClass="drop-down" runat="server" DataSourceID="sqlPriori"
                                        TextField="WFNMPRIO" ValueField="WFIDPRIO" Theme="Material" Width="100%">
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
                            <div class="p-0 col-x1">
                                <asp:Label ID="Label35" runat="server" Text="Tarefa"></asp:Label>
                                <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                    <asp:TextBox ID="txtTarefa" CssClass="text-boxes" Width="100%" Enabled="false" runat="server" Text='<%# string.Format("{0}", Eval("wfdsflow").ToString())%>'></asp:TextBox>
                                    <asp:HiddenField ID="hfIdTarefa" Value='<%# string.Format("{0}",Eval("wfidflow").ToString())%>' runat="server" />
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="p-0 col-x1">
                                <asp:Label ID="Label37" runat="server" Text="Dias"></asp:Label>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator32" ControlToValidate="txtQtdDias" ValidationGroup="InsertReq" ForeColor="Red" runat="server" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>

                                <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                    <dx:ASPxTextBox ID="txtQtdDias" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                        <ClientSideEvents TextChanged="function (s,e) {
                                            var elementDt1 = document.getElementById('lblDtRecebePopup').innerText;
                                            var elementDt2 = document.getElementById('lblDtSomaPopup').innerText;
                                            if(elementDt2=='')
                                            {
                                                var today = new Date();
                                                var date = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds(), today.getMilliseconds());
                                                date.setDate(date.getDate() + parseInt(s.GetText()));
                                                elementDt2 = date.toLocaleString();
                                            }
                                            else
                                            {
                                                var parts = elementDt2.split('/');
                                                var date = new Date(parseInt(parts[2], 10),
                                                                  parseInt(parts[1], 10) - 1,
                                                                  parseInt(parts[0], 10));
                                            date.setDate(date.getDate() + parseInt(s.GetText()));
                                                elementDt2 = date.toLocaleString();
                                            }
                                            elementDt2 = elementDt2.split(' ')[0];
                                                var partsDt1 = elementDt1.split('/');
                                                var dateDt1 = new Date(parseInt(partsDt1[2], 10),
                                                                  parseInt(partsDt1[1], 10) - 1,
                                                                  parseInt(partsDt1[0], 10));
                                                var partsDt2 = elementDt2.split('/');
                                                var dateDt2 = new Date(parseInt(partsDt2[2], 10),
                                                                  parseInt(partsDt2[1], 10) - 1,
                                                                  parseInt(partsDt2[0], 10));
                                            if(dateDt2 &gt; dateDt1)
                                            {
                                                document.getElementById('lblDtSomaPopup').style.color = 'red';
                                            }
                                            document.getElementById('lblDtSomaPopup').innerText = elementDt2;
                        }" />
                                        <MaskSettings Mask="<0..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                        <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*">
                                            <RequiredField IsRequired="true" ErrorText="*" />
                                        </ValidationSettings>
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        <RootStyle CssClass="margin_TextBox"></RootStyle>
                                    </dx:ASPxTextBox>
                                </div>
                            </div>

                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:SqlDataSource runat="server" ID="sqlTimeLine" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select wfidflow,wfidnext,wfdsflow from workflow order by 1"></asp:SqlDataSource>
                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ForeColor="Red" ErrorMessage="CustomValidator" ValidationGroup="InsertReq" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                <div class="row" style="margin: 0 auto; margin-top: 7px">
                    <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                        <asp:Button ID="btnOK" Enabled="false" runat="server" ValidationGroup="InsertReq" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_ok %>" Style="background-color: #FFCC66;" OnClick="btnOK_Click" />
                    </div>
                    <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                        <asp:Button ID="btnCancelar" Enabled="false" CausesValidation="false" runat="server" CssClass="Loading btn-using" Text="<%$ Resources:GlobalResource, btn_cancelar %>" OnClick="btnCancelar_Click1" Style="background-color: #CC9999;" />
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupFinalWF" ClientInstanceName="popupFinalWF" runat="server" Theme="Material"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Emitir Contrato" Modal="true" Width="600px" Height="200px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container">
                    <div class="row">
                        <div class="col-x2 p-0">
                            <asp:Label ID="lblProdutoInsert" runat="server" Text="Tipologia Contrato" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="dropTipologia2" ValidationGroup="Tipologia2" runat="server" ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                <dx:ASPxComboBox ID="dropTipologia2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropTipologia2" runat="server" OnCallback="dropTipologia2_Callback"
                                    CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlProdutoInsert" TextField="prprodes" ValueField="value">
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                </dx:ASPxComboBox>
                                <%--<asp:DropDownList ID="dropProdutoInsert" Width="100%" CssClass="drop-down2" runat="server" AutoPostBack="False" OnSelectedIndexChanged="dropProdutoInsert_SelectedIndexChanged"></asp:DropDownList>--%>
                                <asp:SqlDataSource runat="server" ID="sqlProdutoInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' 
SelectCommand="select CONCAT(pr.prprodid,'|',pr.chidcodi) value, pr.prprodes
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
                        </div><div class="col-x0"></div>
                        <div class="col-x2 p-0">
                            <asp:Label ID="Label1" runat="server" Text="Data Encerramento" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator16" ControlToValidate="txtDataEncerra" ValidationGroup="Tipologia2" runat="server" ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                <dx:ASPxDateEdit ID="txtDataEncerra" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                    <div class="row mt-1">
                        <div class="col-x2 p-0">
                            <asp:Label ID="Label40" runat="server" Text="Inicio Pagamento" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator33" ControlToValidate="txtPag1" ValidationGroup="Tipologia2" runat="server" ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                                                <dx:ASPxDateEdit ID="txtPag1" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                        </div><div class="col-x0"></div>
                        <div class="col-x2 p-0">
                            <asp:Label ID="Label41" runat="server" Text="Final Pagamento" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator34" ControlToValidate="txtPag2" ValidationGroup="Tipologia2" runat="server" ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                <dx:ASPxDateEdit ID="txtPag2" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                    <div class="row mt-3">
                        <div class="col-12 p-0">
                            <asp:Button ID="btn_EmitirContrato" Width="120px" runat="server" ValidationGroup="Tipologia2" CssClass="btn-using float-right" Text="Emitir Contrato" OnClick="btn_EmitirContrato_Click" />
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
                    <asp:Label ID="Label33" runat="server" Text="Requisição de Contrato" CssClass="labels text-left" Font-Size="15pt"></asp:Label></h5>
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
                                SelectCommand="SELECT OP.OPCDCONT, TV.TVDSESTR, OP.OPNMCONT, OP.PRPRODID,OP.OPIDCONT 
FROM OPCONTRA OP 
INNER JOIN TVESTRUT TV   ON(OP.TVIDESTR = TV.TVIDESTR) 
AND OP.OPIDAACC IS NULL 
AND OP.OPTPTPID =99
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
                                        <dx:GridViewDataComboBoxColumn Caption="Número Processo" Width="70px" MaxWidth="70" FieldName="OPCDCONT" VisibleIndex="0">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" ValueField="OPCDCONT" TextField="OPCDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <EditFormSettings VisibleIndex="0" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="Loja" Width="120px" MaxWidth="120" FieldName="TVDSESTR" VisibleIndex="2">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="TVDSESTR" ValueField="TVDSESTR" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="1" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="Descrição" Width="170px" MaxWidth="170" FieldName="OPNMCONT" VisibleIndex="1">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPNMCONT" ValueField="OPNMCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="2" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:Aquisicao, aquisição_right_grid_col5 %>' Width="50px" MaxWidth="50" Visible="false" FieldName="PRPRODID" VisibleIndex="5">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="3" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:Aquisicao, aquisição_right_grid_col6 %>' Width="60px" MaxWidth="60" Visible="false" FieldName="OPIDCONT" VisibleIndex="6">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="4" />
                                        </dx:GridViewDataComboBoxColumn>
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
                <asp:Button ID="btnCancelar1" Enabled="false" CausesValidation="false" runat="server" CssClass="Loading btn-using" Text="<%$ Resources:GlobalResource, btn_cancelar %>" Style="background-color: #CC9999;" OnClick="btnCancelar_Click" />
            </div>
        </div>

    </div>
</asp:Content>
