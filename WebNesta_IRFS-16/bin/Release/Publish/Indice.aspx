<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Indice.aspx.cs" Inherits="WebNesta_IRFS_16.Indice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            height: 33px;
        }
    </style>
    <script type="text/javascript">
        function onBatchEditStartEditing(s, e) {
            var editor = s.GetEditor("CVDTCOIE");
            editor.SetReadOnly(e.visibleIndex == 0);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card">
        <div class="card-header">
            <h4>
                <asp:Label ID="Label8" runat="server" Text="Indexadores"></asp:Label></h4>
        </div>
        <div class="card-body">
    <asp:HiddenField ID="hfCodIndice" runat="server" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:DropDownList ID="dropListagemIndices" runat="server" AutoPostBack="True" OnSelectedIndexChanged="dropListagemIndices_SelectedIndexChanged">
    </asp:DropDownList>
    <asp:SqlDataSource ID="sqlCombos" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT IEIDINEC, IESGBCAS, IENMINEC FROM IEINDECO WHERE IETPINDC = 'U'"></asp:SqlDataSource>
    <table style="width: 100%">
        <tr>
            <td style="width: 25%">
                <asp:Label ID="Label2" runat="server" CssClass="form-control-sm " Text="Descrição"></asp:Label>
                <asp:RequiredFieldValidator ID="reqDescri" Enabled="false" ControlToValidate="txtDescri" ForeColor="Red" runat="server" ErrorMessage="Required"></asp:RequiredFieldValidator>

                <div class="input-group mb-auto">
                    <asp:TextBox ID="txtDescri" Width="95%" runat="server" Enabled="false" CssClass="form-control-sm "></asp:TextBox>
                </div>
            </td>
            <td style="width: 25%">
                <asp:Label ID="Label1" runat="server" CssClass="form-control-sm " Text="Sigla"></asp:Label>
                <asp:RequiredFieldValidator ID="reqSig" Enabled="false" ControlToValidate="txtSig" ForeColor="Red" runat="server" ErrorMessage="Required"></asp:RequiredFieldValidator>

                <div class="input-group mb-auto">
                    <asp:TextBox ID="txtSig" Width="95%" runat="server" Enabled="false" CssClass="form-control-sm "></asp:TextBox>
                </div>
            </td>
            <td style="width: 25%">
                <asp:Label ID="Label3" runat="server" CssClass="form-control-sm " Text="Rótulo"></asp:Label>
                <div class="input-group mb-auto">
                    <asp:TextBox ID="txtRot" Width="95%" runat="server" Enabled="false" CssClass="form-control-sm "></asp:TextBox>
                </div>
            </td>
            <td style="width: 25%"></td>
        </tr>
        <tr>
            <td style="width: 25%">
                <asp:Label ID="Label6" runat="server" CssClass="form-control-sm " Text="Tipo"></asp:Label>
                <asp:RequiredFieldValidator ID="reqTipoIndic" Enabled="false" InitialValue="0" ControlToValidate="dropTipoIndic" runat="server" ForeColor="Red" ErrorMessage="Required"></asp:RequiredFieldValidator>

                <div class="input-group mb-auto">
                    <asp:DropDownList ID="dropTipoIndic" Width="95%" Enabled="false" runat="server" CssClass="form-control-sm " OnSelectedIndexChanged="dropTipoIndic_SelectedIndexChanged" AutoPostBack="True">
                        <asp:ListItem Text="  " Value="0" Selected="True" />
                        <asp:ListItem Text="Taxa" Value="T" />
                        <asp:ListItem Text="Indexador" Value="I" />
                        <asp:ListItem Text="Paridade moeda" Value="M" />
                        <asp:ListItem Text="Futuro Bolsa" Value="F" />
                        <asp:ListItem Text="PUT Bolsa" Value="P" />
                        <asp:ListItem Text="CALL Bolsa" Value="C" />
                    </asp:DropDownList>
                </div>
            </td>
            <td style="width: 25%">
                <asp:Label ID="Label7" runat="server" CssClass="form-control-sm " Text="Frequência"></asp:Label>
                <asp:RequiredFieldValidator ID="reqFreqIndic" Enabled="false" InitialValue="0" ControlToValidate="dropFreqIndic" runat="server" ForeColor="Red" ErrorMessage="Required"></asp:RequiredFieldValidator>
                <div class="input-group mb-auto">
                    <asp:DropDownList ID="dropFreqIndic" Width="95%" Enabled="false" runat="server" CssClass="form-control-sm ">
                        <asp:ListItem Text=" " Value="0" Selected="True" />
                        <asp:ListItem Text="Diário" Value="D" />
                        <asp:ListItem Text="Mensal" Value="M" />
                    </asp:DropDownList>
                </div>
            </td>
            <td style="width: 25%">
                <%--<asp:Label ID="Label4" runat="server" CssClass="form-control-sm " Text="Moeda Origem"></asp:Label>
                <asp:RequiredFieldValidator ID="reqMoedaOrig" InitialValue=" " Enabled="false" ControlToValidate="dropMoedaOrig" runat="server" ForeColor="Red" ErrorMessage="Required"></asp:RequiredFieldValidator>
                <div class="input-group mb-auto">
                    <asp:DropDownList ID="dropMoedaOrig" Enabled="false" Width="95%" runat="server" CssClass="form-control-sm "></asp:DropDownList>

                </div>--%>
            </td>
            <td style="width: 25%">
                <%--<asp:Label ID="Label5" runat="server" CssClass="form-control-sm " Text="Moeda Cotação"></asp:Label>
                <asp:RequiredFieldValidator ID="reqMoedaCota" InitialValue=" " Enabled="false" ControlToValidate="dropMoedaCota" runat="server" ForeColor="Red" ErrorMessage="Required"></asp:RequiredFieldValidator>
                <div class="input-group mb-auto">
                    <asp:DropDownList ID="dropMoedaCota" Enabled="false" Width="95%" runat="server" CssClass="form-control-sm "></asp:DropDownList>

                </div>--%>
            </td>
        </tr>
    </table>
                    </div>
    </div>
    <asp:Panel ID="pnlCotacao" Visible="false" runat="server">
        <div class="row card">
            <div class="card-header">
                <h5>
                    <asp:Label ID="Label4" runat="server" Text="Cotação"></asp:Label></h5>
            </div>
            <div class="card-body">
                <dx:ASPxGridView ID="gridCotacao" Theme="Moderno" runat="server" KeyFieldName="CVDTCOIE" EnableRowsCache="False" Width="100%" AutoGenerateColumns="False" DataSourceID="sqlCotacao" OnBatchUpdate="gridCotacao_BatchUpdate"  >
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Columns>                                   
                                    <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="True" VisibleIndex="0">
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataDateColumn Caption="Data"  FieldName="CVDTCOIE" Name="CVDTCOIE" VisibleIndex="1">
                                        <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                            <ValidationSettings ValidateOnLeave="False">
                                            </ValidationSettings>
                                        </PropertiesDateEdit>
                                        <EditFormSettings VisibleIndex="0" />
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn Caption="Valor" FieldName="CVVLCOID" Name="CVVLCOID" VisibleIndex="2">
                                        <PropertiesTextEdit DisplayFormatString="0.0000" >
                                            <ValidationSettings ValidateOnLeave="False">
                                            </ValidationSettings>
                                        </PropertiesTextEdit>
                                        
                                        <EditFormSettings VisibleIndex="1" />
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Settings VerticalScrollableHeight="594" />
                                
                                <ClientSideEvents BatchEditStartEditing="onBatchEditStartEditing" />
                                
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsEditing Mode="Batch"  />
                                <Styles>
                                    <Header Font-Size="Medium" >
                                    </Header>
                                    <Row Font-Size="Small">
                                    </Row>
                                    <AlternatingRow Font-Size="Small" BackColor="LightGray"></AlternatingRow>
                                    <StatusBar Font-Size="Small">
                                    </StatusBar>
                                    <BatchEditCell Font-Size="Small">
                                    </BatchEditCell>
                                </Styles>
                            </dx:ASPxGridView>
                            <asp:SqlDataSource ID="sqlCotacao" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                SelectCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID
                                                FROM CVCOTIEC
                                                WHERE IEIDINEC = ?
                                                ORDER BY CVDTCOIE DESC"
                                UpdateCommand="UPDATE CVCOTIEC SET CVVLCOID=? WHERE IEIDINEC =? AND CVDTCOIE=? " UpdateCommandType="Text"
                                InsertCommand="INSERT INTO CVCOTIEC (IEIDINEC,CVDTCOIE,CVVLCOID,CVHRCOIE) VALUES (?,?,?,'00:00:00')" InsertCommandType="Text"
                                DeleteCommand="DELETE CVCOTIEC WHERE IEIDINEC =?  AND CVDTCOIE=?" >
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfCodIndice" Name="IEIDINEC" PropertyName="Value" Type="Int32" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:ControlParameter ControlID="hfCodIndice" Name="IEIDINEC" PropertyName="Value" Type="Int32" />
                                    <asp:Parameter Name="CVDTCOIE" Type="String" />
                                    <asp:Parameter Name="CVVLCOID" Type="Decimal" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <asp:ControlParameter ControlID="hfCodIndice" Name="IEIDINEC" PropertyName="Value" Type="Int32" />
                                    <asp:Parameter Name="CVDTCOIE" Type="String" />
                                    <asp:Parameter Name="CVVLCOID" Type="Decimal" />
                                </InsertParameters>
                                <DeleteParameters>
                                    <asp:ControlParameter ControlID="hfCodIndice" Name="IEIDINEC" PropertyName="Value" Type="Int32" />
                                    <asp:Parameter Name="CVDTCOIE" Type="String" />
                                </DeleteParameters>
                            </asp:SqlDataSource>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container">
        <div class="row">
            <table style="width: 100%; margin-top: 20%">
                <tr>
                    <td>
                        <asp:Button ID="btnInserir"  runat="server" CssClass="btn mb-3 btn-act" Text="Inserir" OnClick="btnInserir_Click" />
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
