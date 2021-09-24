<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Fornecedores.aspx.cs" Inherits="WebNesta_IRFS_16.Fornecedores" %>

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
                case 'Contato':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_label_13_guide%>';
                    break;
                case 'Email':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_label_14_guide%>';
                    break;
                case 'Whats':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_label_15_guide%>';
                    break;
                case 'Pix':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_label_16_guide%>';
                    break;
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_guide_titulo%>';
                    break;
                case 'ID':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_guide_id%>';
                    break;
                case 'Nome':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_guide_nome%>';
                    break;
                case 'Apelido':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_guide_apelido%>';
                    break;
                case 'Remessa':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_label_12_guide%>';
                    break;
                case 'Pais':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Fornecedores.fornecedor_guide_pais%>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Fornecedores.fornecedor_guide_ini %>';
                    break;
                case 'acao':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Fornecedores.fornecedor_guide_acao %>';
                    break;
                case 'Banco':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Fornecedores.fornecedor_guide_banco %>';
                    break;
                case 'agencia':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Fornecedores.fornecedor_guide_agencia %>';
                    break;
                case 'dv1':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Fornecedores.fornecedor_guide_dv1 %>';
                    break;
                case 'contac':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Fornecedores.fornecedor_guide_contac %>';
                    break;
                case 'dv2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Fornecedores.fornecedor_guide_dv2 %>';
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
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfTVIDESTR" runat="server" />
    <asp:HiddenField ID="hfMsgException" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_exception %>" />
    <asp:HiddenField ID="hfMsgSuccess" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_success %>" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfCPF" runat="server" />
    <asp:HiddenField ID="hfNome" runat="server" />
    <asp:HiddenField ID="hfApelido" runat="server" />
    <asp:HiddenField ID="hfPais" runat="server" />
    <asp:HiddenField ID="hfId" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfTituloPag" Value="Fornecedores" runat="server" />
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
                        <div class="card-header bg-transparent">
                            <h4>
                                <asp:Label ID="Label1" runat="server" onmouseover="QuickGuide('titulo');" onmouseout="QuickGuide('ini');" Text="<%$Resources:Fornecedores, fornecedor_tituloPag %>"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent">
                            <div class="row w-100 mb-1 pl-3">
                                <div class="p-0 col-x1" onclick="clicando('id_fornecedores')">
                                    <asp:Label ID="lblCpf" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_1 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqCpf" Enabled="false" ControlToValidate="txtCpf" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('ID');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtCpf" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                            <asp:ImageButton ID="btnCpf" Style="position: absolute; right: 5%" Visible="false" runat="server" ImageUrl="~/icons/lupa.png" OnClick="btnCpf_Click" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x2" onclick="clicando('razão_fornecedores')">
                                    <asp:Label ID="lblDesc" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_2 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqDesc" Enabled="false" ControlToValidate="txtDesc" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Nome');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtDesc" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label9" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_12 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqRemessa" InitialValue="Selecione" Enabled="false" ControlToValidate="dropRemessa" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Remessa');" style="padding-left: 2px">
                                        <dx:ASPxComboBox ID="dropRemessa" ForeColor="dimgray" AllowInputUser="false" ValueType="System.String" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Fornecedores, fornecedor_label_12-opt1 %>" Value="Selecione" Selected="true" />
                                                <dx:ListEditItem Text="<%$Resources:Fornecedores, fornecedor_label_12-opt2 %>" Value="B" />
                                                <dx:ListEditItem Text="<%$Resources:Fornecedores, fornecedor_label_12-opt3 %>" Value="E" />
                                            </Items>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxComboBox>

                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 mb-1 pl-3">
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label2" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_4 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Enabled="false" ControlToValidate="txtDesc" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Apelido');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtApelido" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:Label ID="lblPais" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_3 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqPais" InitialValue="Selecione" Enabled="false" ControlToValidate="dropPais" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Pais');" style="padding-left: 2px">
                                        <dx:ASPxComboBox ID="dropPais" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>

                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label4" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_7 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqBanco" Enabled="false" InitialValue="Selecione" ControlToValidate="dropBanco" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Banco');" style="padding-left: 2px">
                                        <dx:ASPxComboBox ID="dropBanco" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxComboBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <br />
                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                        <asp:TextBox ID="TextBox9" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 mb-1 pl-3">
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label5" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_8 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqAG" Enabled="false" ControlToValidate="txtAG" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('agencia');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtAG" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1">
                                    <asp:Label ID="Label6" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_9 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('dv1');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtDAG" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1">
                                    <asp:Label ID="Label7" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_10 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqCC" Enabled="false" ControlToValidate="txtCC" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('contac');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtCC" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1">
                                    <asp:Label ID="Label8" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_11 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('dv2');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtDCC" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 mb-1 pl-3">
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label10" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_13 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqNomeContato" Enabled="false" ControlToValidate="txtNomeContato" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Contato');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtNomeContato" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label11" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_14 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqEmailContato" Enabled="false" ControlToValidate="txtEmailContato" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Email');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtEmailContato" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="reqEmailContato2" Enabled="false" ControlToValidate="txtEmailContato" CssClass="labels text-left" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" runat="server" ErrorMessage="E-mail Inválido" ForeColor="Red" Display="Static"></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:RequiredFieldValidator ID="reqNumWhats" Enabled="false" ControlToValidate="txtNumWhats" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:Label ID="Label12" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_15 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Whats');" style="padding-left: 2px">
                                        <dx:ASPxTextBox ID="txtNumWhats" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                            <MaskSettings Mask="(99) <99999>-<9999>" ShowHints="false" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <RootStyle CssClass="margin_TextBox"></RootStyle>
                                            <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="Imovel" ErrorFrameStyle-ForeColor="Red">
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label13" runat="server" Text="<%$Resources:Fornecedores, fornecedor_label_16 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Enabled="false" ControlToValidate="txtChavePix" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Pix');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtChavePix" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

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
    <asp:HiddenField ID="hfUser2" runat="server" />
    <asp:HiddenField ID="hfTVIDESTR2" runat="server" />
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" onmouseout="QuickGuide('ini');" Text="<%$ Resources:Fornecedores, fornecedor_label_5 %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3 tutorial" style="margin: 0 auto">
            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Fornecedores, fornecedor_label_6 %>" CssClass="labels text-left"></asp:Label>
            <div class="input-group mb-auto" onmouseover="QuickGuide('ID');">
                <dx:ASPxDropDownEdit ID="dropDownEdit" Width="100%" runat="server" Theme="Material" AllowUserInput="false">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                    <DropDownWindowTemplate>
                        <div class="container-fluid p-0">
                            <div class="row " style="display: none">
                                <div class="col-12 text-right">
                                    <asp:Button ID="btnselecionar" ClientIDMode="Static" runat="server" CssClass="Loading btn mt-1 mb-1 btn-act" OnClick="btnselecionar_Click" Text="<%$Resources:GlobalResource, btn_selecionar %>" />
                                </div>
                            </div>
                            <div class="row m-1">
                                <asp:SqlDataSource ID="sqlFornecedores" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                    SelectCommand="SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN,TVIDESTR,F.FONMAB20 FROM FOFORNEC F WHERE FOTPIDTP=8 
and (TVIDESTR IN (SELECT DISTINCT TVIDESTR FROM VIFSFUSU  WHERE USIDUSUA = ?) or TVIDESTR=1) order by fonmforn">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfUser2" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlPais" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                    SelectCommand="select PANMPAIS,PAIDPAIS from PAPAPAIS order by PANMPAIS"></asp:SqlDataSource>
                                <dx:ASPxGridView ID="gridFornecedores" Width="550px" ClientInstanceName="gridFornecedores" runat="server" OnCustomCallback="gridFornecedores_CustomCallback" AutoGenerateColumns="False" DataSourceID="sqlFornecedores" Theme="Material">
                                    <ClientSideEvents RowDblClick="function(s, e) { document.getElementById('btnselecionar').click(); }" />
                                    <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" ShowFilterRow="True" />
                                    <SettingsPager Visible="false"></SettingsPager>
                                    <SettingsBehavior AllowFocusedRow="True" />
                                    <SettingsPopup>
                                        <HeaderFilter MinHeight="140px">
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <Columns>
                                        <dx:GridViewDataComboBoxColumn Caption="<%$Resources:Fornecedores, fornecedor_label_1 %>" FieldName="FOCDXCGC" VisibleIndex="1">
                                            <PropertiesComboBox DataSourceID="sqlFornecedores" ValueField="FOCDXCGC" TextField="FOCDXCGC" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <EditFormSettings VisibleIndex="0" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="<%$Resources:Fornecedores, fornecedor_label_2 %>" FieldName="FONMFORN" VisibleIndex="2">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlFornecedores" TextField="FONMFORN" ValueField="FONMFORN" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="1" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="<%$Resources:Fornecedores, fornecedor_label_3 %>" FieldName="PAIDPAIS" VisibleIndex="3">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlPais" TextField="PANMPAIS" ValueField="PAIDPAIS" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="2" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataTextColumn Caption="ID" FieldName="FOIDFORN" Name="FOIDFORN" ReadOnly="True" Visible="False" VisibleIndex="0">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="TVIDESTR" Name="TVIDESTR" ReadOnly="True" Visible="False" VisibleIndex="4">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="FONMAB20" Name="FONMAB20" ReadOnly="True" Visible="False" VisibleIndex="5">
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
        <div class="row mt-3 tutorial" style="margin: 0 auto">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <asp:Button ID="btnInserir" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_inserir %>" OnClick="btnInserir_Click" OnLoad="btnInserir_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_excluir %>" OnClick="btnExcluir_Click" OnLoad="btnExcluir_Load" />
            </div>
        </div>
        <div class="row tutorial" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_alterar %>" OnClick="btnAlterar_Click" OnLoad="btnAlterar_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;">
                <asp:TextBox ID="TextBox10" CssClass="btn-using field_empty" Enabled="false" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row tutorial" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                <asp:Button ID="btnOK" Enabled="false" runat="server" CssClass="btn-using ok" Text="<%$Resources:GlobalResource, btn_ok %>" OnClick="btnOK_Click" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="btn-using cancelar" Text="<%$Resources:GlobalResource, btn_cancelar %>" OnClick="btnCancelar_Click" CausesValidation="False" />
            </div>
        </div>
    </div>
</asp:Content>
