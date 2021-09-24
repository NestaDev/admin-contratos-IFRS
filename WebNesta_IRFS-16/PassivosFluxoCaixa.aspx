<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="PassivosAquisicao.aspx.cs" Inherits="WebNesta_IRFS_16.PassivosAquisicao" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid card">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
        <div class="row card-header">
            <table style="width: 100%">
                <tr>
                    <td style="width: 25%">
                        <asp:Label ID="Label1" runat="server" CssClass="form-control-sm " Text="Operação"></asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="txtOper" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                    <td style="width: 25%">
                        <asp:Label ID="Label2" runat="server" CssClass="form-control-sm " Text="Índice"></asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="txtIndice" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 25%">
                        <asp:Label ID="Label3" runat="server" CssClass="form-control-sm " Text="Descrição"></asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                    <td style="width: 25%">
                        <asp:Label ID="Label4" runat="server" CssClass="form-control-sm " Text="Contraparte"></asp:Label>
                    </td>
                    <td style="width: 25%">
                        <asp:TextBox ID="txtContra" runat="server" CssClass="form-control-sm "></asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
        <div class="row card-body">
            <table>
                <tr>
                    <td style="width: 100%">
                                <asp:Panel ID="pnlGrid" runat="server" Height="700px" ScrollBars="Both" Width="1024px">
                                    <asp:GridView ID="GridView1" runat="server" CssClass="table table-dark" OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound" AutoGenerateColumns="False" >
                                        <Columns>
                                            <asp:ButtonField Text="DoubleClick" CommandName="DoubleClick" Visible="False" />
                                            <asp:BoundField DataField="opidcont" HeaderText="Código operação" />
                                            <asp:BoundField DataField="opcdcont" HeaderText="Código contrato" />
                                            <asp:BoundField DataField="opnmcont" HeaderText="Descrição operação" />
                                            <asp:BoundField DataField="fonmab20" HeaderText="Contraparte" />
                                            <asp:BoundField DataField="ienminec" HeaderText="Índice" />
                                        </Columns>
                                        <HeaderStyle Font-Size="10pt" />
                                        <RowStyle Font-Size="9pt" CssClass="table table-light" />
                                    </asp:GridView>
                                </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
                            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="GridView1" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>
