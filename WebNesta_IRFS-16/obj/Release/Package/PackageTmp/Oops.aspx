<%@ Page Language="C#" MasterPageFile="~/Error.Master" AutoEventWireup="true" CodeBehind="Oops.aspx.cs" Inherits="WebNesta_IRFS_16.Oops" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfTitulo" Value="Oops..." runat="server" />
    <div class="container p-0" style="width:800px;height:400px;white-space:normal; ">

        <div class="row pt-1" style="height: 300px;white-space:normal;">

            <div class="col-4 p-0 card" style="background-color: transparent">
                <div class="card-header border-bottom-0" style="background-color: transparent">

                    <asp:Label ID="Label6" runat="server" Font-Names="Calibri" ForeColor="#4E01D4" Font-Size="14pt" CssClass="labels" Text="Alerta"></asp:Label>
                </div>
                <div class="card-body" style="background-color: transparent">
                    <asp:Label ID="Label7" runat="server" Font-Names="Calibri" ForeColor="#4E01D4" Font-Size="14pt" CssClass="labels" Text="Oops, ocorreu um erro inesperado. Caso necessário, entre em contato com o Suporte Nesta."></asp:Label>
                </div>
                <div class="card-footer" style="background-color: transparent">
                    <table style="width: 100%">
                            <tr>
                                <td style="width: 60%"></td>
                                <td style="width: 10%; text-align: center"></td>
                                <td style="width: 30%; text-align: center">
                                    <asp:Button ID="btnClose" runat="server" CssClass="btn-using cancelar" Text="Página Inicial" OnClick="btnClose_Click" /></td>
                            </tr>
                        </table>
                </div>
            </div>
            <div class="col-8 pl-2 p-0" style="background-color: transparent; ">
                <p>
                    <asp:Label ID="Label2" runat="server" Text="Mensagem de Erro: "></asp:Label><asp:Label ID="lblErrorMsg" runat="server" Text="Label"></asp:Label></p>
                <p>
                    <asp:Label ID="Label3" runat="server" Text="Origem: "></asp:Label><asp:Label ID="lblSource" runat="server" Text="Label"></asp:Label></p>
                <p>
                    <asp:Label ID="Label5" runat="server" Text="Rastreamento: "></asp:Label><asp:Label Visible="false" ID="lblStackTrace" runat="server" Text="Label"></asp:Label></p>
            </div>
        </div>
    </div>
</asp:Content>
