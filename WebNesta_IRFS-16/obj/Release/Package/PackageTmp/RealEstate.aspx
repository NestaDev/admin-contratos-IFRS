<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RealEstate.aspx.cs" Inherits="WebNesta_IRFS_16.RealEstate" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<%@ Register TagPrefix="dx" Namespace="DevExpress.Web.ASPxSpellChecker" Assembly="DevExpress.Web.ASPxSpellChecker.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
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
            clearButton.SetEnabled(DropDownEdit.GetText() != "");
            selectButton.SetEnabled(TreeList.GetFocusedNodeKey() != "");
        }
        function OnDropDown() {
            TreeList.SetFocusedNodeKey(DropDownEdit.GetKeyValue());
            TreeList.MakeNodeVisible(TreeList.GetFocusedNodeKey());
        }
        function ClearSelection2() {
            TreeList2.SetFocusedNodeKey("");
            UpdateControls2(null, "");
            document.getElementById('hfDropEstr2').value = "";
        }
        function UpdateSelection2() {
            var employeeName = "";
            var focusedNodeKey = TreeList2.GetFocusedNodeKey();
            document.getElementById('hfDropEstr2').value = TreeList2.GetFocusedNodeKey();
            if (focusedNodeKey != "")
                employeeName = TreeList2.cpEmployeeNames[focusedNodeKey];
            UpdateControls2(focusedNodeKey, employeeName);
        }
        function UpdateControls2(key, text) {
            DropDownEdit2.SetText(text);
            DropDownEdit2.SetKeyValue(key);
            DropDownEdit2.HideDropDown();
            UpdateButtons2();
        }
        function UpdateButtons2() {
            clearButton2.SetEnabled(DropDownEdit2.GetText() != "");
            selectButton2.SetEnabled(TreeList2.GetFocusedNodeKey() != "");
        }
        function OnDropDown2() {
            TreeList2.SetFocusedNodeKey(DropDownEdit2.GetKeyValue());
            TreeList2.MakeNodeVisible(TreeList2.GetFocusedNodeKey());
        }
        function gedShow() {
            var teste = document.getElementById('hfIDImovel').value;
            if (teste.length > 0)
                popupFileManager.Show();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfIDImovel" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />

    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case '1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_01_guide%>';
                    break;
                case '2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_02_guide%>';
                    break;
                case '3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_03_guide%>';
                    break;
                case '4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_04_guide%>';
                    break;
                case '5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_05_guide%>';
                    break;
                case '7':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_07_guide%>';
                    break;
                case '8':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_08_guide%>';
                    break;
                case '9':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_09_guide%>';
                    break;
                case '10':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_10_guide%>';
                    break;
                case '11':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_11_guide%>';
                    break;
                case '12':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_12_guide%>';
                    break;
                case '13':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_13_guide%>';
                    break;
                case '14':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_14_guide%>';
                    break;
                case '15':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_15_guide%>';
                    break;
                case '16':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_16_guide%>';
                    break;
                case '17':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_17_guide%>';
                    break;
                case '18':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp1_18_guide%>';
                    break;
                case '2-1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp2_01_guide%>';
                    break;
                case '2-2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp2_02_guide%>';
                    break;
                case '2-3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp2_03_guide%>';
                    break;
                case '2-3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.label_grp2_04_guide%>';
                    break;
                case 'grp1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.titulo_grp1_guide%>';
                    break;
                case 'grp2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.titulo_grp2_guide%>';
                    break;
                case 'grp3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.titulo_grp3_guide%>';
                    break;
                case 'grp4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.titulo_grp4_guide%>';
                    break;
                case 'grp5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.RealEstate.titulo_grp5_guide%>';
                    break;
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_guide_titulo%>';
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
                case 'sel_loja':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.sel_loja_guide %>';
                    break;
                case 'sel_imovel':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.sel_imovel_guide %>';
                    break;
            }
        }
    </script>
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
                                    <label id="lblquickGuide"><%= Resources.GlobalResource.quickguide_inicial %></label>
                                </div>
                                <div class="card-footer bg-transparent quickGuide-footer">
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:RealEstate, realestate_content_tutorial %>" />
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
                <div id="card">
                    <%--Dados Cadastrais--%>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('grp1');">
                            <a class="card-link" data-toggle="collapse" href="#collapseInfo" aria-expanded="true">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label2" runat="server" CssClass="labels" Text="<%$ Resources:RealEstate, titulo_grp1 %>"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapseInfo" class="collapse show" data-parent="#card">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="lblEstCorpo" runat="server" Text="<%$ Resources:RealEstate, label_grp1_01 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:Label ID="lblEstCorpoErro" runat="server" Visible="false" Text="*" ForeColor="Red" CssClass="labels text-left"></asp:Label>

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
                                                        <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass=" drop-down" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                                            Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
                                                            <ClientSideEvents Init="UpdateSelection" DropDown="OnDropDown" />
                                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
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
                                                                        KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE" OnLoad="TreeList_Load" AutoGenerateColumns="False">
                                                                        <Columns>
                                                                            <dx:TreeListTextColumn FieldName="TVDSESTR" AllowHeaderFilter="True" AutoFilterCondition="Default" ShowInFilterControl="Default" ShowInCustomizationForm="True" Caption="Descri&#231;&#227;o" VisibleIndex="0"></dx:TreeListTextColumn>
                                                                        </Columns>
                                                                        <Images>
                                                                            <ExpandedButton Url="icons/icons8-seta-para-recolher-30.png" Width="25px"></ExpandedButton>
                                                                            <CollapsedButton Url="icons/icons8-seta-para-expandir-30.png" Width="25px"></CollapsedButton>
                                                                        </Images>
                                                                        <Settings VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                                                        <ClientSideEvents FocusedNodeChanged="function(s,e){ selectButton.SetEnabled(true); }" />
                                                                        <BorderBottom BorderStyle="Solid" />
                                                                        <SettingsBehavior AllowFocusedNode="true" AutoExpandAllNodes="false" FocusNodeOnLoad="false" />
                                                                        <SettingsPager Mode="ShowAllNodes">
                                                                        </SettingsPager>
                                                                        <Styles>
                                                                            <SelectedNode BackColor="#669999"></SelectedNode>
                                                                            <FocusedNode BackColor="#669999"></FocusedNode>
                                                                            <Node Cursor="pointer">
                                                                            </Node>
                                                                            <Indent Cursor="default">
                                                                            </Indent>
                                                                        </Styles>

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
                                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:RealEstate, label_grp1_02 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="dropTipoImov" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('2');">
                                            <dx:ASPxComboBox ID="dropTipoImov" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlTipoImovel"
                                                ValueType="System.String" ValueField="TPIDIMOV" TextField="TPDSIMOV">
                                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                </ButtonStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <ValidationSettings RequiredField-IsRequired="true" RequiredField-ErrorText="*" ErrorFrameStyle-ForeColor="Red" Display="Dynamic" ValidationGroup="Imovel"></ValidationSettings>
                                            </dx:ASPxComboBox>

                                            <asp:SqlDataSource runat="server" ID="sqlTipoImovel" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="SELECT TPIDIMOV,TPDSIMOV FROM TPIMOVEL order by 2"></asp:SqlDataSource>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:RealEstate, label_grp1_03 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtRegAdmin" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('3');">
                                            <asp:TextBox ID="txtRegAdmin" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:RealEstate, label_grp1_04 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtNoContribu" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('4');">
                                            <asp:TextBox ID="txtNoContribu" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:RealEstate, label_grp1_07 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ControlToValidate="txtCep" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('7');">
                                            <dx:ASPxTextBox ID="txtCep" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <ClientSideEvents TextChanged="function(s,e) { callBackGeoLocal.PerformCallback(s.GetText()); } " />
                                                <MaskSettings Mask="<99999>-<999>" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="Imovel">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x2 p-0">
                                        <asp:Label ID="Label9" runat="server" Text="<%$ Resources:RealEstate, label_grp1_05 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="margin-top: 2px" onmouseover="QuickGuide('5');">
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
                                                            Width="100%" AnimationType="Slide" AllowUserInput="false">
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
                                    <div class="col-x0"></div>

                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label11" runat="server" Text="<%$ Resources:RealEstate, label_grp1_08 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" ControlToValidate="dropLogradoura" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('8');">
                                            <dx:ASPxComboBox ID="dropLogradoura" ForeColor="dimgray" AllowInputUser="false" CssClass="drop-down" runat="server"
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
                                </div>
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label12" runat="server" Text="<%$ Resources:RealEstate, label_grp1_09 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" ControlToValidate="txtAnoConst" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('9');">
                                            <dx:ASPxDateEdit ID="txtAnoConst" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Years" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                                                <ValidationSettings RequiredField-IsRequired="true" ValidationGroup="Imovel" Display="Dynamic" ErrorFrameStyle-ForeColor="Red" RequiredField-ErrorText="*"></ValidationSettings>
                                            </dx:ASPxDateEdit>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label13" runat="server" Text="<%$ Resources:RealEstate, label_grp1_10 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" ControlToValidate="dropSituacao" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('10');">
                                            <dx:ASPxComboBox ID="dropSituacao" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlSituacao"
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
                                        <asp:Label ID="Label14" runat="server" Text="<%$ Resources:RealEstate, label_grp1_11 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" ControlToValidate="txtNoProcRegis" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('11');">
                                            <asp:TextBox ID="txtNoProcRegis" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:RealEstate, label_grp1_12 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" InitialValue="0,00" ControlToValidate="txtTestadaPrinc" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('12');">
                                            <dx:ASPxTextBox ID="txtTestadaPrinc" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="Imovel">
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
                                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:RealEstate, label_grp1_13 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator12" InitialValue="0,00" ControlToValidate="txtAreaTerreno" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('13');">
                                            <dx:ASPxTextBox ID="txtAreaTerreno" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="Imovel" CausesValidation="true" ErrorText="*">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:RealEstate, label_grp1_14 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" InitialValue="0,00" ControlToValidate="txtAreaEdificada" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('14');">
                                            <dx:ASPxTextBox ID="txtAreaEdificada" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="Imovel" CausesValidation="true" ErrorText="*">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label18" runat="server" Text="<%$ Resources:RealEstate, label_grp1_15 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator14" InitialValue="0,00" ControlToValidate="txtAreaComum" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                            <dx:ASPxTextBox ID="txtAreaComum" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="Imovel" CausesValidation="true" ErrorText="*">
                                                    <RequiredField IsRequired="true" ErrorText="*" />
                                                </ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            </dx:ASPxTextBox>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label19" runat="server" Text="<%$ Resources:RealEstate, label_grp1_16 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator15" InitialValue="0,00" ControlToValidate="txtFracIdeal" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('16');">
                                            <dx:ASPxTextBox ID="txtFracIdeal" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" ValidationGroup="Imovel" CausesValidation="true" ErrorText="*">
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
                                        <asp:Label ID="Label20" runat="server" Text="<%$ Resources:RealEstate, label_grp1_17 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator16" ControlToValidate="txtDataRegis" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('17');">
                                            <dx:ASPxDateEdit ID="txtDataRegis" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                                                <ValidationSettings RequiredField-IsRequired="true" ValidationGroup="Imovel" Display="Dynamic" ErrorFrameStyle-ForeColor="Red" RequiredField-ErrorText="*"></ValidationSettings>
                                            </dx:ASPxDateEdit>
                                        </div>
                                    </div>
                                    <div class="col-x0"></div>
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label21" runat="server" Text="<%$ Resources:RealEstate, label_grp1_18 %>" CssClass="labels text-left"></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator17" InitialValue="0,00" ControlToValidate="txtValorVenal" ValidationGroup="Imovel" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('18');">
                                            <dx:ASPxTextBox ID="txtValorVenal" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="Imovel">
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
                                            <asp:TextBox ID="TextBox13" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
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
                            </div>
                        </div>
                    </div>
                    <%--Posse do Imóvel--%>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('grp2');">
                            <a class="card-link" data-toggle="collapse" href="#collapsePosse" aria-expanded="false">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label4" runat="server" CssClass="labels" Text="<%$ Resources:RealEstate, titulo_grp2 %>"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapsePosse" class="collapse" data-parent="#card">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <div class="row p-0 m-0">
                                    <div class="col-x1 p-0">
                                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:RealEstate, label_grp2_01 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('2-1');">
                                            <dx:ASPxDateEdit ID="txtDataVistoria" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                                        <asp:Label ID="Label23" runat="server" Text="<%$ Resources:RealEstate, label_grp2_02 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" onmouseover="QuickGuide('2-2');">
                                            <dx:ASPxDateEdit ID="txtDataReceb" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                                        <asp:Label ID="Label24" runat="server" Text="<%$ Resources:RealEstate, label_grp2_03 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px" onmouseover="QuickGuide('2-3');">
                                            <dx:ASPxDateEdit ID="txtDataDevol" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                                        <asp:Label ID="Label25" runat="server" Text="<%$ Resources:RealEstate, label_grp2_04 %>" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px" onmouseover="QuickGuide('2-4');">
                                            <dx:ASPxDateEdit ID="txtDataInaug" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="Center">
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
                    <%--Propriedade do Imóvel--%>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('grp3');">
                            <a class="card-link" data-toggle="collapse" href="#collapseProp" aria-expanded="false">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label5" runat="server" CssClass="labels" Text="<%$ Resources:RealEstate, titulo_grp3 %>"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapseProp" class="collapse" data-parent="#card">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <dx:ASPxGridView ID="gridPropri" ClientInstanceName="gridPropri" KeyFieldName="REIDVIFO" ClientIDMode="Static" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlPropri"
                                    OnBatchUpdate="gridPropri_BatchUpdate" OnCustomButtonInitialize="gridPropri_CustomButtonInitialize" OnCustomButtonCallback="gridPropri_CustomButtonCallback">
                                    <ClientSideEvents EndCallback="function(s, e) {
	                                    if (s.cp_origem == 'btn_whatsapp_grid') {
                                        txtNumWhats.SetText(s.cp_whatsnumber);
                                        document.getElementById('txtContato').value = s.cp_contato;
                                        document.getElementById('txtMsgWhats').value = '';
                                     popupWhatsapp.Show();
                                    delete (s.cp_origem);
                                    delete (s.cp_whatsnumber);
                                    delete (s.cp_contato);
                                     } 
                                        else if (s.cp_origem == 'btn_email_grid') {
                                     popupMail.Show();
                                    delete (s.cp_origem);
                                    delete (s.cp_whatsnumber);
                                    delete (s.cp_contato);
                                     } 
                                    }"></ClientSideEvents>
                                    <SettingsPopup>
                                        <HeaderFilter MinHeight="140px">
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Settings VerticalScrollableHeight="594" />
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
                                        <dx:GridViewCommandColumn ShowDeleteButton="True" VisibleIndex="0" ShowNewButtonInHeader="True" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                        <dx:GridViewDataDateColumn FieldName="REDTVINC" Width="130px" VisibleIndex="3" Caption="Data">
                                            <PropertiesDateEdit>
                                                <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                    <MonthGridPaddings Padding="0px" />
                                                    <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                    <HeaderStyle BackColor="#669999" />
                                                    <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                                    <FastNavProperties DisplayMode="Inline" />
                                                </CalendarProperties>
                                            </PropertiesDateEdit>
                                        </dx:GridViewDataDateColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="FOIDFORN" Width="130px" VisibleIndex="1" Caption="Fornecedor">
                                            <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlFornecedores" TextField="FONMAB20" ValueField="FOIDFORN"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="TPIDPROP" Width="130px" VisibleIndex="2" Caption="Tipo">
                                            <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlTipoPropri" TextField="TPNMAB20" ValueField="TPIDFORN"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataTextColumn FieldName="FONMCOTT" Caption="Contato" VisibleIndex="4" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>
                                        <dx:GridViewCommandColumn VisibleIndex="5" Caption="Ações" ButtonRenderMode="Image">
                                            <CustomButtons>
                                                <dx:GridViewCommandColumnCustomButton ID="btn_email_grid" Text="Email">
                                                    <Image ToolTip="Envio de Email" Url="img/icons8-email-64.png" Width="25px"></Image>
                                                </dx:GridViewCommandColumnCustomButton>
                                                <dx:GridViewCommandColumnCustomButton ID="btn_whatsapp_grid" Text="WhatsApp">
                                                    <Image ToolTip="Envio de WhatsApp" Url="img/icons8-whatsapp-64.png" Width="25px"></Image>
                                                </dx:GridViewCommandColumnCustomButton>
                                            </CustomButtons>
                                        </dx:GridViewCommandColumn>
                                        <dx:GridViewDataTextColumn FieldName="FOMAILFO" Visible="False" VisibleIndex="6"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="FOWHATFO" Visible="False" VisibleIndex="7"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="REPERCVL" Caption="Participa&#231;&#227;o" VisibleIndex="8">
                                            <PropertiesTextEdit DisplayFormatString="{0:N2}%">
                                                <MaskSettings Mask="&lt;0..100&gt;.&lt;00..99&gt;"></MaskSettings>
                                                <ValidationSettings Display="None" ErrorDisplayMode="ImageWithTooltip" RequiredField-IsRequired="true" RequiredField-ErrorText="Valor Obrigatório"></ValidationSettings>
                                            </PropertiesTextEdit>
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
                                <asp:SqlDataSource runat="server" ID="sqlPropri" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                    SelectCommand="SELECT REIDVIFO
                                                  ,REIDIMOV
                                                  ,R.FOIDFORN
                                                  ,TPIDPROP
                                                  ,REDTVINC
	                                              ,F.FONMCOTT
	                                              ,F.FOMAILFO
	                                              ,F.FOWHATFO,R.REPERCVL
                                              FROM REVIFORN R
                                              INNER JOIN FOFORNEC F ON R.FOIDFORN=F.FOIDFORN
                                              where REIDIMOV=?">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfIDImovel" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                    <%--Impostos e Taxas--%>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('grp4');">
                            <a class="card-link" data-toggle="collapse" href="#collapseImpostos" aria-expanded="false">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label1" runat="server" CssClass="labels mt-2" Text="<%$ Resources:RealEstate, titulo_grp4 %>"></asp:Label>
                                </h5>
                            </a>
                        </div>
                        <div id="collapseImpostos" class="collapse" data-parent="#card">
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <dx:ASPxGridView ID="gridImpostos" ClientInstanceName="gridImpostos" KeyFieldName="REIDVITI" ClientIDMode="Static" Width="500px" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlImpTaxas"
                                    OnBatchUpdate="gridImpostos_BatchUpdate" OnDetailRowGetButtonVisibility="gridImpostos_DetailRowGetButtonVisibility">
                                    <SettingsPopup>
                                        <HeaderFilter MinHeight="140px">
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Settings VerticalScrollableHeight="594" />
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
                                    <SettingsDetail AllowOnlyOneMasterRowExpanded="true" ShowDetailButtons="true" ShowDetailRow="true" />
                                    <Images>
                                        <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                        <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                    </Images>
                                    <Columns>
                                        <dx:GridViewCommandColumn ShowNewButtonInHeader="True" Caption=" " VisibleIndex="0" ShowDeleteButton="True" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="REISENTO" Caption="Isento?" VisibleIndex="2">
                                            <PropertiesComboBox>
                                                <Items>
                                                    <dx:ListEditItem Text="Sim" Value="S"></dx:ListEditItem>
                                                    <dx:ListEditItem Text="N&#227;o" Value="N"></dx:ListEditItem>
                                                </Items>
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn FieldName="REIDTAXA" Caption="Imposto/Taxa/Seguro" VisibleIndex="1">
                                            <PropertiesComboBox DataSourceID="sqlTipoImposta" TextField="REDSTAXA" ValueField="REIDTAXA"></PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>

                                    </Columns>
                                    <Templates>
                                        <DetailRow>
                                            <dx:ASPxGridView ID="gridImpIncidencia" ClientInstanceName="gridImpIncidencia" KeyFieldName="REIDINCI" ClientIDMode="Static" Theme="Material" Width="100%" runat="server" AutoGenerateColumns="False"
                                                DataSourceID="sqlREINCIDE" OnBeforePerformDataSelect="gridImpIncidencia_BeforePerformDataSelect" OnBatchUpdate="gridImpIncidencia_BatchUpdate" OnLoad="gridImpIncidencia_Load"
                                                OnRowValidating="gridImpIncidencia_RowValidating">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>

                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Settings VerticalScrollableHeight="100" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Visible" />
                                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                                </SettingsPager>
                                                <SettingsEditing Mode="Batch" BatchEditSettings-ShowConfirmOnLosingChanges="true" />
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
                                                    <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                                    <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                                </Images>
                                                <Columns>
                                                    <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowDeleteButton="True" Caption=" " Width="30px" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                                    <dx:GridViewDataTextColumn FieldName="REDSINCI" Width="80px" Caption="Descrição" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataDateColumn FieldName="REANOFIS" Width="70px" Caption="Ano" VisibleIndex="2">
                                                        <PropertiesDateEdit PickerType="Years" DisplayFormatString="yyyy">
                                                            <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                                <MonthGridPaddings Padding="0px" />
                                                                <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                                <HeaderStyle BackColor="#669999" />
                                                                <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                                                <FastNavProperties DisplayMode="Inline" />
                                                            </CalendarProperties>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="REVLTOTA" Width="60px" Caption="Valor Total" EditFormSettings-Visible="True" VisibleIndex="3">
                                                        <PropertiesTextEdit DisplayFormatInEditMode="True" DisplayFormatString="N">
                                                            <MaskSettings AllowMouseWheel="False" Mask="&lt;0..99999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>
                                                            <ValidationSettings Display="Dynamic"></ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="RENRPARC" Width="40px" Caption="Qtd" VisibleIndex="4">
                                                        <PropertiesTextEdit DisplayFormatInEditMode="True" DisplayFormatString="N0">
                                                            <MaskSettings AllowMouseWheel="False" Mask="&lt;0..999&gt;" IncludeLiterals="None"></MaskSettings>
                                                            <ValidationSettings Display="Dynamic"></ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataDateColumn FieldName="REDTVCPP" Width="70px" Caption="1a Parcela" VisibleIndex="5">
                                                        <PropertiesDateEdit>
                                                            <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                                <MonthGridPaddings Padding="0px" />
                                                                <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                                <HeaderStyle BackColor="#669999" />
                                                                <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                                                <FastNavProperties DisplayMode="Inline" />
                                                            </CalendarProperties>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="REVLPPAR" Width="60px" Caption="1a Parcela" VisibleIndex="6">
                                                        <PropertiesTextEdit DisplayFormatInEditMode="True" DisplayFormatString="N">
                                                            <MaskSettings AllowMouseWheel="False" Mask="&lt;0..99999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>
                                                            <ValidationSettings Display="Dynamic"></ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="REVLPARC" Width="60px" Caption="Valor Mensal" VisibleIndex="7">
                                                        <PropertiesTextEdit DisplayFormatInEditMode="True" DisplayFormatString="N">
                                                            <MaskSettings AllowMouseWheel="False" Mask="&lt;0..99999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>
                                                            <ValidationSettings Display="Dynamic"></ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataDateColumn FieldName="REDTBOLE" Width="70px" Caption="Boletos" VisibleIndex="8">
                                                        <PropertiesDateEdit>
                                                            <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                                <MonthGridPaddings Padding="0px" />
                                                                <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                                <HeaderStyle BackColor="#669999" />
                                                                <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                                                <FastNavProperties DisplayMode="Inline" />
                                                            </CalendarProperties>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="REMAILBO" Width="90px" Caption="Coleta Boleto" VisibleIndex="9"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="RESITEPM" Width="90px" Caption="Consulta" VisibleIndex="10"></dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataDateColumn FieldName="REDTVCPD" Width="70px" Caption="Data Parcela Únca" VisibleIndex="11">
                                                        <PropertiesDateEdit>
                                                            <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                                <MonthGridPaddings Padding="0px" />
                                                                <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                                <HeaderStyle BackColor="#669999" />
                                                                <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                                                <FastNavProperties DisplayMode="Inline" />
                                                            </CalendarProperties>
                                                            <ValidationSettings RequiredField-ErrorText="*" Display="Dynamic" RequiredField-IsRequired="true"></ValidationSettings>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="REVLPAUN" Width="60px" Caption="Valor" VisibleIndex="12">
                                                        <PropertiesTextEdit DisplayFormatInEditMode="True" DisplayFormatString="N">
                                                            <MaskSettings AllowMouseWheel="False" Mask="&lt;0..99999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol"></MaskSettings>
                                                            <ValidationSettings Display="Dynamic"></ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="REPARUNI" Width="60px" Caption="Parcela &#218;nica" VisibleIndex="13">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="Sim" Value="S"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="N&#227;o" Value="N"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>

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

                                                    <Cell Paddings-Padding="5px" Font-Size="8pt"></Cell>
                                                    <CommandColumn Paddings-Padding="0px"></CommandColumn>
                                                </Styles>
                                            </dx:ASPxGridView>
                                        </DetailRow>
                                    </Templates>
                                    <Styles>
                                        <DetailButton Paddings-Padding="0px"></DetailButton>
                                        <DetailRow BackColor="#f1f1f1">
                                        </DetailRow>
                                        <DetailCell Paddings-Padding="3px"></DetailCell>
                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                        <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-PaddingBottom="0px" Paddings-PaddingTop="0px" Paddings-Padding="3px">
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
                                <asp:SqlDataSource runat="server" ID="sqlTipoImposta" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT REIDTAXA,REDSTAXA FROM REIMPTAX order by 2"></asp:SqlDataSource>
                                <asp:SqlDataSource runat="server" ID="sqlImpTaxas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT REIDVITI,REIDIMOV,REIDTAXA,REISENTO FROM REVITXIM
where REIDIMOV=?">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfIDImovel" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                    <asp:SqlDataSource runat="server" ID="sqlREINCIDE" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                        SelectCommand="SELECT REIDINCI,REIDVITI,REDSINCI,REVLTOTA,RENRPARC,convert(datetime,REDTVCPP) as REDTVCPP,REVLPARC,convert(datetime,REDTBOLE) as REDTBOLE,REMAILBO,RESITEPM,convert(datetime,REDTVCPD) as REDTVCPD,REVLPAUN,REPARUNI,convert(datetime,DATEFROMPARTS(REANOFIS,01,01)) as REANOFIS,REVLPPAR
  FROM REINCIDE
  where REIDVITI=?">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="" Name="?"></asp:Parameter>
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <%--Doc e Arqs--%>
                    <div class="row card bg-transparent">
                        <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('grp5');">
                            <asp:LinkButton ID="linkGED" runat="server" data-toggle="collapse" aria-expanded="false" OnClientClick="gedShow();return false;">
                                <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label3" runat="server" CssClass="labels mt-2" Text="<%$ Resources:RealEstate, titulo_grp5 %>"></asp:Label>
                                </h5>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl ID="popupFileManager" ClientInstanceName="popupFileManager" runat="server" Theme="Material"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Documentos e Arquivos" Modal="true" Width="600px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxFileManager ID="fileManager" Visible="false" ClientInstanceName="fileManager" Theme="Material" runat="server" Width="800px">
                    <Settings AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.doc,.docx,.pdf,.eml" />
                    <SettingsToolbar>
                        <Items>
                            <dx:FileManagerToolbarCreateButton ToolTip="Criar"></dx:FileManagerToolbarCreateButton>
                            <dx:FileManagerToolbarRenameButton ToolTip="Renomear"></dx:FileManagerToolbarRenameButton>
                            <dx:FileManagerToolbarMoveButton ToolTip="Mover"></dx:FileManagerToolbarMoveButton>
                            <dx:FileManagerToolbarCopyButton ToolTip="Copiar"></dx:FileManagerToolbarCopyButton>
                            <dx:FileManagerToolbarDeleteButton ToolTip="Excluir"></dx:FileManagerToolbarDeleteButton>
                            <dx:FileManagerToolbarRefreshButton ToolTip="Atualizar"></dx:FileManagerToolbarRefreshButton>
                            <dx:FileManagerToolbarDownloadButton ToolTip="Download"></dx:FileManagerToolbarDownloadButton>
                        </Items>
                    </SettingsToolbar>
                    <SettingsPermissions>
                        <AccessRules>
                            <dx:FileManagerFolderAccessRule Path="System" Edit="Deny" />
                            <dx:FileManagerFileAccessRule Path="System\*" Download="Deny" />
                        </AccessRules>
                    </SettingsPermissions>
                    <SettingsFiltering FilteredFileListView="FilterView" FilterBoxMode="Subfolders" />
                    <SettingsFileList ThumbnailsViewSettings-ThumbnailHeight="30px" ThumbnailsViewSettings-ThumbnailWidth="30px" ShowFolders="true" ShowParentFolder="true" />
                    <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                    <SettingsUpload UseAdvancedUploadMode="true">
                        <AdvancedModeSettings EnableMultiSelect="true" />
                    </SettingsUpload>
                    <SettingsAdaptivity Enabled="true" />
                    <SettingsContextMenu Enabled="true">
                        <Items>
                            <dx:FileManagerToolbarMoveButton />
                            <dx:FileManagerToolbarCopyButton />
                            <dx:FileManagerToolbarRenameButton BeginGroup="true" />
                            <dx:FileManagerToolbarDeleteButton />
                            <dx:FileManagerToolbarRefreshButton BeginGroup="false" />
                        </Items>
                    </SettingsContextMenu>
                    <Styles>
                        <Item Font-Size="9pt"></Item>
                    </Styles>
                </dx:ASPxFileManager>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupMail" ClientInstanceName="popupMail" runat="server" Theme="Material"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Envio de Email" Modal="true" Width="750px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxHtmlEditor ID="htmlEditor" runat="server" Theme="Material" Width="100%" OnInit="htmlEditor_Init">
                    <settingsimageupload validationsettings-allowedfileextensions=".jpg"></settingsimageupload>
                </dx:ASPxHtmlEditor>
                <dx:ASPxButton ID="ASPxButton1" runat="server" CssClass="Loading btn-using" Text="ENVIAR" OnClick="ASPxButton1_Click"></dx:ASPxButton>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupWhatsapp" ClientInstanceName="popupWhatsapp" runat="server" Theme="Material"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Envio de Whatsapp" Modal="true" Width="750px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row p-0 m-0 mb-1">
                    <div class="col-x1 p-0">
                        <asp:Label ID="Label29" runat="server" Text="Contato" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtContato" ClientIDMode="Static" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-x0 p-0"></div>
                    <div class="col-x1 p-0">
                        <asp:Label ID="Label30" runat="server" Text="WhatsApp" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-auto">
                            <dx:ASPxTextBox ID="txtNumWhats" ClientInstanceName="txtNumWhats" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                <MaskSettings Mask="(99) <99999>-<9999>" ShowHints="false" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                <RootStyle CssClass="margin_TextBox"></RootStyle>
                                <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="Imovel">
                                    <RequiredField IsRequired="true" ErrorText="*" />
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="col-x0 p-0"></div>
                    <div class="p-0 col-x1">
                        <br />
                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                            <asp:TextBox ID="TextBox2" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-x0 p-0"></div>
                    <div class="p-0 col-x1">
                        <br />
                        <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                            <asp:TextBox ID="TextBox3" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="row p-0 m-0 mb-3">
                    <div class="col-x2 p-0">
                        <asp:Label ID="Label28" runat="server" Text="Mensagem (max 255)" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtMsgWhats" ClientIDMode="Static" TextMode="MultiLine" Rows="3" CssClass="text-boxes" Width="100%" Height="60px" runat="server" MaxLength="255"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-x0 p-0"></div>
                </div>
                <dx:ASPxButton ID="btnEnviarWhats" runat="server" CssClass="Loading btn-using" Text="ENVIAR" OnClick="btnEnviarWhats_Click">
                </dx:ASPxButton>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <asp:SqlDataSource ID="sqlFornecedores" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR,F.FONMAB20 FROM FOFORNEC F WHERE FOTPIDTP=8 
and TVIDESTR IN (SELECT DISTINCT TVIDESTR FROM VIFSFUSU  WHERE USIDUSUA = ?) order by fonmforn">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlTipoPropri" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT TPIDFORN ,TPNMAB20 FROM TIPOFORN order by 2"></asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfUser2" runat="server" />
    <asp:HiddenField ID="hfDropEstr2" ClientIDMode="Static" runat="server" />
    <div class="container p-0">
        <div class="row card" style="margin: 0 auto">
            <div class="card-header p-0 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="Ação do Usuário" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label26" runat="server" Text="Selecione a Loja" CssClass="labels text-left"></asp:Label></h6>
            <asp:Button ID="btnSelectRE" ClientIDMode="Static" OnClick="btnSelectRE_Click" runat="server" CssClass="d-none" Text="Button" />
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('sel_loja');">
                <asp:SqlDataSource ID="sqlLojas" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT B.TVIDESTR, B.TVDSESTR, B.TVCDPAIE, B.TVNVESTR,
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
                        <asp:ControlParameter ControlID="hfUser2" PropertyName="Value" Name="?"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
                <dx:ASPxCallbackPanel ID="ASPxCallbackPanel2" runat="server" Width="350px">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxDropDownEdit ID="ASPxDropDownEdit1" Visible="true" ClientIDMode="Static" ClientInstanceName="DropDownEdit2" CssClass="dropDownEdit text-left" Theme="Material"
                                Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
                                <ClientSideEvents
                                    Init="UpdateSelection2"
                                    DropDown="OnDropDown2" />
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                <DropDownWindowTemplate>
                                    <div>
                                        <dx:ASPxTreeList ID="TreeList" CssClass="text-left" DataSourceID="sqlLojas" ClientInstanceName="TreeList2" runat="server"
                                            Width="350px" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material" OnLoad="TreeList_Load1"
                                            KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE">
                                            <Settings VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                            <ClientSideEvents FocusedNodeChanged="function(s,e){ selectButton2.SetEnabled(true); }" />
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
                                                <dx:ASPxButton ID="clearButton" ClientEnabled="false" Theme="Material" ClientInstanceName="clearButton2"
                                                    runat="server" AutoPostBack="false" Text="Clear" BackColor="#669999">
                                                    <ClientSideEvents Click="ClearSelection2" />
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </td>
                                            <td style="text-align: right; padding: 10px;">
                                                <dx:ASPxButton ID="selectButton" ClientEnabled="false" Theme="Material" ClientInstanceName="selectButton2"
                                                    runat="server" AutoPostBack="false" Text="Select" BackColor="#669999">
                                                    <ClientSideEvents Click=" function(s,e) {
                                                            UpdateSelection2();
                                                            if (document.getElementById('hfDropEstr2').value != '') {
                                                                document.getElementById('btnSelectRE').click();
                                                            }
                                                            } " />
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" Text="Close" BackColor="#669999">
                                                    <ClientSideEvents Click="function(s,e) { DropDownEdit2.HideDropDown(); }" />
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
            <h6>
                <asp:Label ID="Label27" runat="server" Text="Selecione o Imóvel" CssClass="labels text-left"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('sel_imovel');">
                <dx:ASPxComboBox ID="dropImoveis" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" AutoPostBack="true" OnSelectedIndexChanged="dropImoveis_SelectedIndexChanged"
                    Theme="Material" Width="100%" DataSourceID="sqlImoveis" TextField="REREGIAO" ValueField="REIDIMOV">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
                <asp:SqlDataSource runat="server" ID="sqlImoveis" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="SELECT REIDIMOV,REREGIAO FROM REIMOVEL where TVIDESTR=? and REIDIMOV NOT IN  (select R.REIDIMOV from REVIOPIM R, OPCONTRA O WHERE R.OPIDCONT=O.OPIDCONT AND O.OPTPTPID=99) order by 2">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfDropEstr2" PropertyName="Value" Name="?"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <asp:Button ID="btnInsert" Enabled="true" CausesValidation="false" CssClass="Loading btn-using" runat="server" CommandArgument="inserir" OnCommand="btnInsert_Command" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnLoad="btnInsert_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnDelete" Enabled="false" CausesValidation="false" CssClass="Loading btn-using" runat="server" CommandArgument="deletar" OnCommand="btnInsert_Command" Text="<%$ Resources:GlobalResource, btn_excluir %>" OnLoad="btnDelete_Load" />

            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 8px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnEdit" Enabled="false" CausesValidation="false" CssClass="Loading btn-using" runat="server" CommandArgument="alterar" OnCommand="btnInsert_Command" Text="<%$ Resources:GlobalResource, btn_alterar %>" OnLoad="btnEdit_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;">
                <asp:TextBox ID="TextBox10" CssClass="btn-using field_empty" Enabled="false" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 8px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                <asp:Button ID="btnOK" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_ok %>" Style="background-color: #FFCC66;" OnClick="btnOK_Click" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                <asp:Button ID="btnCancelar" Enabled="false" CausesValidation="false" runat="server" CssClass="Loading btn-using" OnClick="btnCancelar_Click" Text="<%$ Resources:GlobalResource, btn_cancelar %>" Style="background-color: #CC9999;" />
            </div>
        </div>
    </div>
</asp:Content>
