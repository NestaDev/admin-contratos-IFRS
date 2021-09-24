<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Verbas.aspx.cs" Inherits="WebNesta_IRFS_16.Verbas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {

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
                case 'selecione':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl1_direita_guide %>';
                    break;
                case '1':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl1_guide %>';
                    break;
                case '2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl2_guide %>';
                    break;
                case '3':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl3_guide %>';
                    break;
                case '4':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl4_guide %>';
                    break;
                case '5':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl5_guide %>';
                    break;
                case '6':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl6_guide %>';
                    break;
                case '7':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl7_guide %>';
                    break;
                case '8':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl8_guide %>';
                    break;
                case '9':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl9_guide %>';
                    break;
                case '10':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Verbas.verbas_lbl10_guide %>';
                    break;
            }

        }

    </script>
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfMOIDMODA" runat="server" />
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
                                    <label id="lblquickGuide"><%=Resources.GlobalResource.quickguide_inicial %></label>
                                </div>
                                <div class="card-footer bg-transparent quickGuide-footer">
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Verbas, verbas_content_tutorial %>" />
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
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label1" runat="server" Text="<%$Resources:Verbas, verbas_titulo_principal %>"></asp:Label></h4>
                        </div>
                        <div class="card-body">
                            <div class="row w-100 mb-1 pl-3">
                                <div class="p-0 col-x1">
                                    <asp:Label ID="lblCpf" runat="server" Text="<%$Resources:Verbas, verbas_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqDesc" Enabled="false" ControlToValidate="txtDesc" runat="server" ErrorMessage="*" Display="Dynamic" ValidationGroup="Valida" ForeColor="Red"></asp:RequiredFieldValidator>
                                    <asp:CustomValidator ID="reqDesc2" Enabled="false" CssClass="labels text-left" ControlToValidate="txtDesc" EnableClientScript="false" runat="server" Display="Dynamic" ValidationGroup="Valida" ForeColor="Red" OnServerValidate="CustomValidator1_ServerValidate" ErrorMessage="Nome já existe"></asp:CustomValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('1');">
                                        <asp:TextBox ID="txtDesc" CssClass="text-boxes" Width="100%" ValidationGroup="Valida" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="lblDesc" runat="server" Text="<%$Resources:Verbas, verbas_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqIFRS" InitialValue="-1" ValidationGroup="Valida" Enabled="false" ControlToValidate="dropIFRS" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('2');">
                                        <dx:ASPxComboBox ID="dropIFRS" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo1_item1 %>" Value="-1" Selected="true" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo1_item2 %>" Value="1" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo1_item3 %>" Value="0" />
                                            </Items>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label9" runat="server" Text="<%$Resources:Verbas, verbas_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqClass" Enabled="false" ValidationGroup="Valida" ControlToValidate="dropClass" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('3');">
                                        <dx:ASPxComboBox ID="dropClass" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlClassificador"
                                            ValueField="LAYIDCLA" TextField="LAYNMCLA">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxComboBox>

                                        <asp:SqlDataSource runat="server" ID="sqlClassificador" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT LAYIDCLA ,LAYNMCLA FROM LAYPDFCL where LAYIDENT=0"></asp:SqlDataSource>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label2" runat="server" Text="<%$Resources:Verbas, verbas_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqTipo" Enabled="false" ValidationGroup="Valida" ControlToValidate="dropTipo" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('4');">
                                        <dx:ASPxComboBox ID="dropTipo" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo3_item1 %>" Value="1" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo3_item2 %>" Value="0" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 mb-1 pl-3">
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label4" runat="server" Text="<%$Resources:Verbas, verbas_lbl5 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqTempo" Enabled="false" ValidationGroup="Valida" ControlToValidate="dropTempo" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('5');">
                                        <dx:ASPxComboBox ID="dropTempo" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo4_item1 %>" Value="1" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo4_item2 %>" Value="0" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label5" runat="server" Text="<%$Resources:Verbas, verbas_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqRecupera" Enabled="false" ValidationGroup="Valida" ControlToValidate="dropRecupera" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('6');">
                                        <dx:ASPxComboBox ID="dropRecupera" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo5_item1 %>" Value="1" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo5_item2 %>" Value="0" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label6" runat="server" Text="<%$Resources:Verbas, verbas_lbl7 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqPeriodi" Enabled="false" ValidationGroup="Valida" ControlToValidate="dropPeriodi" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('7');">
                                        <dx:ASPxComboBox ID="dropPeriodi" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item1 %>" Value="M" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item2 %>" Value="B" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item3 %>" Value="T" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item4 %>" Value="Q" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item5 %>" Value="s" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item6 %>" Value="A" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label7" runat="server" Text="<%$Resources:Verbas, verbas_lbl8 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqCalc" Enabled="false" ValidationGroup="Valida" ControlToValidate="dropCalc" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('8');">
                                        <dx:ASPxComboBox ID="dropCalc" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo7_item1 %>" Value="1" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo7_item2 %>" Value="0" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 mb-1 pl-3">
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label11" runat="server" Text="<%$Resources:Verbas, verbas_lbl11 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="reqImposto" Enabled="false" ValidationGroup="Valida" ControlToValidate="dropImposto" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                        <dx:ASPxComboBox ID="dropImposto" ForeColor="dimgray" ValidationGroup="Valida" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo8_item1 %>" Value="1" />
                                                <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo8_item2 %>" Value="0" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label8" runat="server" Text="<%$Resources:Verbas, verbas_lbl9 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('9');">
                                        <dx:ASPxTextBox ID="txtVaria" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                            <MaskSettings Mask="<0..100>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                            <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="Valida">
                                            </ValidationSettings>
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            <RootStyle CssClass="margin_TextBox"></RootStyle>
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="p-0 col-x1">
                                    <asp:Label ID="Label10" runat="server" Text="<%$Resources:Verbas, verbas_lbl10 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('10');">
                                        <dx:ASPxTextBox ID="txtPerVaria" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                            <MaskSettings Mask="<0..12>" ShowHints="false" />
                                            <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="Valida">
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
                                        <asp:TextBox ID="TextBox9" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="<%$Resources:Verbas, verbas_titulo_direita %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <asp:Label ID="Label3" runat="server" Text="<%$Resources:Verbas, verbas_lbl1_direita %>" CssClass="labels text-left"></asp:Label>
            <div class="input-group mb-auto" onmouseover="QuickGuide('selecione');">
                <dx:ASPxComboBox ID="dropVerbas" ForeColor="dimgray" AutoPostBack="true" OnSelectedIndexChanged="dropVerbas_SelectedIndexChanged" AllowInputUser="false" runat="server" Theme="Material" Width="100%"
                    ValueType="System.Int32" DataSourceID="sqlVerbas" ValueField="MOIDMODA" TextField="MODSMODA">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
                <asp:SqlDataSource runat="server" ID="sqlVerbas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select MODSMODA,MOIDMODA from modalida where MOTPIDCA=10 order by 1"></asp:SqlDataSource>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto;">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <asp:Button ID="btnInserir" runat="server" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_inserir %>" OnClick="btnInserir_Click" OnLoad="btnInserir_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_excluir %>" OnLoad="btnExcluir_Load" />
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_alterar %>" OnClick="btnAlterar_Click" OnLoad="btnAlterar_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;">
                <asp:TextBox ID="TextBox10" CssClass="btn-using field_empty" Enabled="false" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                <asp:Button ID="btnOK" Enabled="false" runat="server" CssClass="btn-using ok" ValidationGroup="Valida" Text="<%$Resources:GlobalResource, btn_ok %>" OnClick="btnOK_Click" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="Loading btn-using cancelar" Text="<%$Resources:GlobalResource, btn_cancelar %>" CausesValidation="False" OnClick="btnCancelar_Click" />
            </div>
        </div>
    </div>
</asp:Content>
