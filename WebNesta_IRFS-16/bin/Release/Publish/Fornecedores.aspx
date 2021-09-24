<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Fornecedores.aspx.cs" Inherits="WebNesta_IRFS_16.Fornecedores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfCPF" runat="server" />
    <asp:HiddenField ID="hfNome" runat="server" />
    <asp:HiddenField ID="hfPais" runat="server" />
    <asp:HiddenField ID="hfId" runat="server" />
    <div class="container">
        <div class="row card">
            <div class="card-header">
                <h4>
                    <asp:Label ID="Label1" runat="server" Text="Fornecedores"></asp:Label></h4>
            </div>
            <div class="card-body">
                <table style="width: 100%">
                    <tr>
                        <td style="width: 25%">
                            <asp:Label ID="lblCpf" runat="server" Text="CNPJ/CPF" CssClass="form-control-sm"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqCpf" Enabled="false" ControlToValidate="txtCpf" runat="server" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtCpf" CssClass="form-control-sm" ReadOnly="true" Width="60%" runat="server"></asp:TextBox>
                                <div class="input-group-append">
                                    <asp:ImageButton ID="btnCpf" CssClass="btn btn-outline-lupa" Width="90%" Height="90%" runat="server" ImageUrl="~/icons/lupa.png" OnClick="btnCpf_Click" />
                                </div>
                            </div>
                        </td>
                        <td style="width: 25%" colspan="2">
                            <asp:Label ID="lblDesc" runat="server" Text="Nome" CssClass="form-control-sm"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqDesc" Enabled="false" ControlToValidate="txtDesc" runat="server" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto">
                                <asp:TextBox ID="txtDesc" CssClass="border-1 form-control-sm" Width="95%" Enabled="false" runat="server"></asp:TextBox>

                            </div>
                        </td>
                        <td style="width: 25%">
                            <asp:Label ID="lblPais" runat="server" Text="País" CssClass="form-control-sm"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqPais" InitialValue="Selecione" Enabled="false" ControlToValidate="dropPais" runat="server" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto">
                                <asp:DropDownList ID="dropPais" runat="server" Enabled="false" CssClass="border-1 form-control-sm"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="row">
            <asp:Panel ID="pnlGrid" Visible="false" runat="server">
                <asp:SqlDataSource ID="sqlFornecedores" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                    SelectCommand="SELECT F.FOCDXCGC, F.FONMFORN, F.PAIDPAIS,F.FOIDFORN FROM FOFORNEC F"></asp:SqlDataSource>
                <asp:SqlDataSource ID="sqlPais" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                    SelectCommand="select PANMPAIS,PAIDPAIS from PAPAPAIS order by PANMPAIS"></asp:SqlDataSource>
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: right">

                            <dx:ASPxButton ID="btnPesquisar" Theme="Moderno" CssClass="form-control-md" runat="server" Text="Selecionar" OnClick="btnPesquisar_Click" ></dx:ASPxButton>


                        </td>
                    </tr>

                    <tr>
                        <td>
                            <dx:ASPxGridView ID="gridFornecedores" ClientInstanceName="gridFornecedores" runat="server" AutoGenerateColumns="False" DataSourceID="sqlFornecedores" Theme="Moderno">
                                <Settings VerticalScrollableHeight="400" ShowFilterRow="True" />
                                <SettingsBehavior AllowFocusedRow="True" />
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Columns>
                                    <dx:GridViewDataComboBoxColumn Caption="CPF / CNPJ" FieldName="FOCDXCGC" VisibleIndex="1">
                                        <PropertiesComboBox DataSourceID="sqlFornecedores" ValueField="FOCDXCGC" TextField="FOCDXCGC" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                        <Settings AllowAutoFilter="True" />
                                        <EditFormSettings VisibleIndex="0" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Nome" FieldName="FONMFORN" VisibleIndex="2">
                                        <Settings AllowAutoFilter="True" />
                                        <PropertiesComboBox DataSourceID="sqlFornecedores" TextField="FONMFORN" ValueField="FONMFORN" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                        </PropertiesComboBox>
                                        <EditFormSettings VisibleIndex="1" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="País" FieldName="PAIDPAIS" VisibleIndex="3">
                                        <Settings AllowAutoFilter="True" />
                                        <PropertiesComboBox DataSourceID="sqlPais" TextField="PANMPAIS" ValueField="PAIDPAIS" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                        <EditFormSettings VisibleIndex="2" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataTextColumn Caption="ID" FieldName="FOIDFORN" Name="FOIDFORN" ReadOnly="True" Visible="False" VisibleIndex="0">
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Styles>
                                    <Row Font-Size="Small"></Row>
                                    <Header Font-Size="Small"></Header>
                                    <FilterRow Font-Size="Small"></FilterRow>
                                </Styles>
                            </dx:ASPxGridView>

                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container">
        <div class="row">
            <table style="width: 100%; margin-top: 20%">
                <tr>
                    <td>
                        <asp:Button ID="btnInserir" runat="server" CssClass="btn mb-3 btn-act" Text="Inserir" OnClick="btnInserir_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="btn btn-act mb-3" Text="Alterar" OnClick="btnAlterar_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="btn btn-act mb-3" Text="Excluir" OnClick="btnExcluir_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnOK" Enabled="false" runat="server" CssClass="btn btn-ok mb-3" Text="OK" OnClick="btnOK_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="btn btn-cancelar mb-3" Text="Cancelar" OnClick="btnCancelar_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
