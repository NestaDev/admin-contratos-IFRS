<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TesteReport.aspx.cs" Inherits="WebNesta_IRFS_16.TesteReport" %>

<%@ Register Assembly="DevExpress.XtraReports.v20.1.Web.WebForms, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <dx:ASPxReportDesigner runat="server" SettingsWizard-EnableSqlDataSource="true"  ID="ASPxReportDesigner1">

    </dx:ASPxReportDesigner>
</asp:Content>
