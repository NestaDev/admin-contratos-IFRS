<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="PassivosAquisicao.aspx.cs" Inherits="WebNesta_IRFS_16.PassivosAquisicao" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid card">
        <div class="row card-header">
            <table style="width: 100%">
                <tr>
                    <td style="width: 20%">
                        <asp:Label ID="Label1" runat="server" CssClass="form-control-sm " Text="Operação"></asp:Label>
                    </td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtOper" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                    <td style="width: 20%">
                        <asp:Label ID="Label2" runat="server" CssClass="form-control-sm " Text="Índice"></asp:Label>
                    </td>
                    <td style="width: 20%" colspan="2">
                        <asp:TextBox ID="txtIndice" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%">
                        <asp:Label ID="Label3" runat="server" CssClass="form-control-sm " Text="Descrição"></asp:Label>
                    </td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                    <td style="width: 20%">
                        <asp:Label ID="Label4" runat="server" CssClass="form-control-sm " Text="Contraparte"></asp:Label>
                    </td>
                    <td style="width: 20%">
                        <asp:TextBox ID="txtContra" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                    <td style="width: 20%">
                        <asp:DropDownList ID="dropMultiView" Visible="false" CssClass="form-control-sm" runat="server" AutoPostBack="True" OnSelectedIndexChanged="dropMultiView_SelectedIndexChanged">
                            <asp:ListItem Text="Contratos" Value="0" />
                            <asp:ListItem Text="Fluxo caixa" Value="1" />
                            <asp:ListItem Text="Extrato financeiro" Value="2" />
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="row card-body">
            <asp:MultiView ID="MultiView1" runat="server">
                <asp:View ID="ViewContratos" runat="server">
                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label7" runat="server" Text="Aquisição"></asp:Label></h4>
                        </div>
                        <div class="card-body">
                            <asp:Panel ID="pnlGrid" runat="server" Height="700px" ScrollBars="Both" Width="1024px">
                                <asp:GridView ID="GridView1" runat="server" CssClass="table table-dark" OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:ButtonField Text="DoubleClick" CommandName="DoubleClick" Visible="False" />
                                        <asp:BoundField DataField="opidcont" HeaderText="Código operação" />
                                        <asp:BoundField DataField="opcdcont" HeaderText="Código contrato" />
                                        <asp:BoundField DataField="opnmcont" HeaderText="Descrição operação" />
                                        <asp:BoundField DataField="fonmab20" HeaderText="Contraparte" />
                                        <asp:BoundField DataField="ienminec" HeaderText="Índice" />
                                    </Columns>
                                    <HeaderStyle Font-Size="8pt" />
                                    <RowStyle Font-Size="8pt" CssClass="table table-light table-borderless" />
                                    <AlternatingRowStyle Font-Size="8pt" CssClass="table table-info table-borderless" />
                                </asp:GridView>
                            </asp:Panel>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="ViewFluxoCaixa" runat="server">


                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label5" runat="server" Text="Fluxo caixa"></asp:Label></h4>
                        </div>
                        <div class="card-body">
                            <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click">Exportar</asp:LinkButton>
                            <asp:Panel ID="pnlFluxo" runat="server" Height="500px" ScrollBars="Auto" Width="1024px">
                                <asp:GridView ID="gridFluxoCaixa" runat="server" CssClass="table table-dark" AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="PHDTEVEN" HeaderText="Evento" HtmlEncode="false" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="PHDTPAGT" HeaderText="Pagamento" HtmlEncode="false" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="PHNMSEQU" HeaderText="Parc" />
                                        <asp:BoundField DataField="PHNRPARC" HeaderText="Seq" />
                                        <asp:BoundField DataField="PHNRDIAS" HeaderText="Dias" />
                                        <asp:BoundField DataField="PHVLDEVE" HeaderText="Devedor" DataFormatString="{0,2:n}" />
                                        <asp:BoundField DataField="PHVLAMOR" HeaderText="Amortizado" DataFormatString="{0,2:n}" />
                                        <asp:BoundField DataField="PHVLJURO" HeaderText="Juros" DataFormatString="{0,2:n}" />
                                        <asp:BoundField DataField="PHVLCOMI" HeaderText="Comissões" />
                                        <asp:BoundField DataField="PHVLSPRE" HeaderText="Spread" />
                                        <asp:BoundField DataField="PHVLENC1" HeaderText="Enc1" />
                                        <asp:BoundField DataField="PHVLENC2" HeaderText="Enc2" />
                                        <asp:BoundField DataField="PHVLIPRE" HeaderText="Taxas" />
                                        <asp:BoundField DataField="PHVLTOTA" HeaderText="Total" DataFormatString="{0,2:n}" />
                                    </Columns>
                                    <HeaderStyle Font-Size="8pt" />
                                    <RowStyle Font-Size="8pt" CssClass="table table-light table-borderless" />
                                    <AlternatingRowStyle Font-Size="8pt" CssClass="table table-info table-borderless" />
                                </asp:GridView>
                            </asp:Panel>
                        </div>
                    </div>

                </asp:View>
                <asp:View ID="ViewExtratoFinanceiro" runat="server">
                    <div class="card">
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label6" runat="server" Text="Extrato financeiro"></asp:Label></h4>
                        </div>
                        <div class="card-body">
                            <asp:LinkButton ID="btnExpExtrato" runat="server" OnClick="btnExpExtrato_Click">Exportar</asp:LinkButton>
                            <asp:Panel ID="Panel1" runat="server" Height="500px" ScrollBars="Auto" Width="1024px">
                                <asp:GridView ID="gridExtratoFinanceiro" runat="server" CssClass="table table-dark" AutoGenerateColumns="false">
                                    <Columns>
                                        <asp:BoundField DataField="RZDTDATA" HeaderText="Evento" DataFormatString="{0:d}" />
                                        <asp:BoundField DataField="RZDSHIST" HeaderText="Descrição" />
                                        <asp:BoundField DataField="RZVLDEBI" HeaderText="Débito" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="RZVLCRED" HeaderText="Crédito" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="RZVLSALD" HeaderText="Saldo devedor" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="RZVLPRIN" HeaderText="Saldo principal" DataFormatString="{0:N2}" />
                                        <asp:BoundField DataField="RZVLCOTA" HeaderText="Cotação" DataFormatString="{0:N6}" />
                                    </Columns>
                                    <HeaderStyle Font-Size="8pt" />
                                    <RowStyle Font-Size="8pt" CssClass="table table-light table-borderless" />
                                    <AlternatingRowStyle Font-Size="8pt" CssClass="table table-info table-borderless" />
                                </asp:GridView>
                            </asp:Panel>
                        </div>
                    </div>
                </asp:View>
            </asp:MultiView>
        </div>
    </div>
</asp:Content>
