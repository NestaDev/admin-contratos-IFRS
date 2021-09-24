<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebNesta_IRFS_16._Default" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1><asp:Label ID="Label1" runat="server" Text="Introdução" meta:resourcekey="Label1Resource1"></asp:Label></h1>
        <p><asp:Label ID="Label2" runat="server" Text="WebNesta Tecnologia - Projeto IRFS" meta:resourcekey="Label2Resource1"></asp:Label><br />
        <asp:Label ID="Label5" runat="server" Text="Idima atual: " meta:resourcekey="Label5Resource1"></asp:Label>
            <asp:Label ID="lblIdioma" runat="server" meta:resourcekey="lblIdiomaResource1"></asp:Label>
        </p>
        <asp:Button ID="Button1" CssClass="btn btn-primary" runat="server" Text="" meta:resourcekey="Button1Resource1" />
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2><asp:Label ID="Label3" runat="server" Text="Data" meta:resourcekey="Label3Resource1"></asp:Label></h2>
            <p><asp:TextBox ID="txtData" runat="server" meta:resourcekey="txtDataResource1"></asp:TextBox></p>
        </div>
        <div class="col-md-4">
            <h2><asp:Label ID="Label4" runat="server" Text="Moeda" meta:resourcekey="Label4Resource1"></asp:Label></h2>
            <p><asp:TextBox ID="txtMoeda" runat="server" meta:resourcekey="txtMoedaResource1"></asp:TextBox></p>
            <asp:Button ID="Button2" runat="server" Text="Button" OnClick="Button2_Click" />
        </div>
    </div>

</asp:Content>
