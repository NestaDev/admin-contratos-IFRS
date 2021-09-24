<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Translate.aspx.cs" Inherits="WebNesta_IRFS_16.Translate" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfPRPRODID" runat="server" />
    <asp:HiddenField ID="hfPFIDDEBI" runat="server" />
    <asp:HiddenField ID="hfPFIDCRED" runat="server" />
    <div class="container-fluid card">
        <div class="row card-header">
            <table style="width: 100%">
                <tr>
                    <td style="width: 25%">
                        <asp:Label ID="Label1" runat="server" CssClass="form-control-sm " Text="Produto" meta:resourcekey="Label1Resource1"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:DropDownList ID="dropProduto" Width="95%" CssClass="form-control-sm" AutoPostBack="True" runat="server" OnSelectedIndexChanged="dropProduto_SelectedIndexChanged" meta:resourcekey="dropProdutoResource1"></asp:DropDownList>
                        </div>
                    </td>
                    <td style="width: 50%">
                        <asp:Label ID="Label2" runat="server" CssClass="form-control-sm " Text="Descrição" meta:resourcekey="Label2Resource1"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtDescri" Width="95%" runat="server" CssClass="form-control-sm " Enabled="False" meta:resourcekey="txtDescriResource1"></asp:TextBox>
                        </div>
                    </td>
                    <td style="width: 25%">
                        
                    </td>
                </tr>
            </table>
        </div>
        <div class="row card-body">
            <asp:MultiView ID="MultiView1" runat="server">
                <asp:View ID="ViewClasseContabil" runat="server">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-6 card">
                                <div class="card-header">
                                    <h4>
                                        <asp:Label ID="Label7" runat="server" Text="Contas a débito" meta:resourcekey="Label7Resource1"></asp:Label></h4>
                                </div>
                                <div class="card-body">
                                    <dx:ASPxGridView ID="gridContaDebit_2" Theme="Moderno" runat="server" KeyFieldName="MOIDMODA" EnableRowsCache="False" Width="100%" AutoGenerateColumns="False" DataSourceID="sqlContaDebit_2" OnBatchUpdate="gridContaDebit_2_BatchUpdate" meta:resourcekey="gridContaDebit_2Resource1">
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsEditing Mode="Batch" />
                                        <Settings VerticalScrollableHeight="594" />
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <Columns>
                                            <dx:GridViewDataComboBoxColumn Caption="Descrição" FieldName="MOIDMODA" meta:resourcekey="GridViewDataComboBoxColumnResource1" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                <PropertiesComboBox DataSourceID="sqlMODALIDA" TextField="MODSMODA" ValueField="MOIDMODA" ValueType="System.Int32">
                                                </PropertiesComboBox>
                                                <Settings ShowEditorInBatchEditMode="False" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn Caption="Conta" FieldName="PFCDPLNC" meta:resourcekey="GridViewDataTextColumnResource1" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                <Settings ShowEditorInBatchEditMode="False" />
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="Descrição Contábil" FieldName="PFIDDEBI" meta:resourcekey="GridViewDataComboBoxColumnResource2" ShowInCustomizationForm="True" VisibleIndex="2">
                                                <PropertiesComboBox DataSourceID="sqlCredDebit" TextField="pfdsplnc" ValueField="pfidplnc" ValueType="System.Int32">
                                                    <Style Font-Size="Medium">
                                                    </Style>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
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
                            <asp:SqlDataSource ID="sqlContaDebit_2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                SelectCommand="SELECT T1.MOIDMODA,T2.PFCDPLNC,t1.PFIDDEBI
                                                    FROM VIPRESCT T1,PFPLNCTA T2
                                                    WHERE T1.PFIDDEBI = T2.PFIDPLNC
                                                    AND   T1.PRPRODID = ?
                                                    ORDER BY T1.MOIDMODA"
                                UpdateCommand="UPDATE VIPRESCT SET PFIDDEBI=? WHERE PRPRODID =? and MOIDMODA=? ">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfPRPRODID" Name="PRPRODID" PropertyName="Value" Type="Int32" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:ControlParameter ControlID="hfPRPRODID" Name="PRPRODID" PropertyName="Value" Type="String" />
                                    <asp:Parameter Name="MOIDMODA" Type="String" />
                                    <asp:Parameter Name="PFIDDEBI" Type="String" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                                </div>
                            </div>
                            <div class="col-6 card">
                                <div class="card-header">
                                    <h4>
                                        <asp:Label ID="Label3" runat="server" Text="Contas a crédito" meta:resourcekey="Label3Resource1"></asp:Label></h4>
                                </div>
                                <div class="card-body">
                                    <dx:ASPxGridView ID="gridContaCred_2" Theme="Moderno" runat="server" KeyFieldName="MOIDMODA" EnableRowsCache="False" Width="100%" AutoGenerateColumns="False" DataSourceID="sqlContaCred_2" OnBatchUpdate="gridContaCred_2_BatchUpdate" meta:resourcekey="gridContaCred_2Resource1">
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsEditing Mode="Batch" />
                                        <Settings VerticalScrollableHeight="594" />
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <Columns>
                                            <dx:GridViewDataComboBoxColumn Caption="Descrição" FieldName="MOIDMODA" meta:resourcekey="GridViewDataComboBoxColumnResource3" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="0">
                                                <PropertiesComboBox DataSourceID="sqlMODALIDA" TextField="MODSMODA" ValueField="MOIDMODA" ValueType="System.Int32">
                                                </PropertiesComboBox>
                                                <Settings ShowEditorInBatchEditMode="False" />
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn Caption="Conta" FieldName="PFCDPLNC" meta:resourcekey="GridViewDataTextColumnResource2" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="1">
                                                <Settings ShowEditorInBatchEditMode="False" />
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="Descrição Contábil" FieldName="PFIDCRED" meta:resourcekey="GridViewDataComboBoxColumnResource4" ShowInCustomizationForm="True" VisibleIndex="2">
                                                <PropertiesComboBox DataSourceID="sqlCredDebit" TextField="pfdsplnc" ValueField="pfidplnc" ValueType="System.Int32">
                                                    <Style Font-Size="Medium">
                                                    </Style>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                <Styles>
                                    <Header Font-Size="Medium" >
                                    </Header>
                                    <Row Font-Size="Small">
                                    </Row>
                                    <AlternatingRow Font-Size="Small" BackColor="LightGray"></AlternatingRow>
                                    <StatusBar Font-Size="Medium">
                                    </StatusBar>
                                    <BatchEditCell Font-Size="Small">
                                    </BatchEditCell>
                                </Styles>
                            </dx:ASPxGridView>
                            <asp:SqlDataSource ID="sqlContaCred_2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                SelectCommand="SELECT T1.MOIDMODA,T2.PFCDPLNC,t1.PFIDCRED
                                                    FROM VIPRESCT T1,PFPLNCTA T2
                                                    WHERE T1.PFIDDEBI = T2.PFIDPLNC
                                                    AND   T1.PRPRODID = ?
                                                    ORDER BY T1.MOIDMODA"
                                UpdateCommand="UPDATE VIPRESCT SET PFIDCRED=? WHERE PRPRODID =? and MOIDMODA=? ">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfPRPRODID" Name="PRPRODID" PropertyName="Value" Type="Int32" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:ControlParameter ControlID="hfPRPRODID" Name="PRPRODID" PropertyName="Value" Type="String" />
                                    <asp:Parameter Name="MOIDMODA" Type="String" />
                                    <asp:Parameter Name="PFIDCRED" Type="String" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                                </div>
                            </div>
                        </div>
                    </div>
                    <asp:SqlDataSource ID="sqlCredDebit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="select pfidplnc,pfdsplnc from PFPLNCTA order by 1"></asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlMODALIDA" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT [MOIDMODA], [MODSMODA] FROM [MODALIDA]"></asp:SqlDataSource>
                </asp:View>
                
            </asp:MultiView>
        </div>
    </div>
</asp:Content>
