<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClasseContabil.aspx.cs" Inherits="WebNesta_IRFS_16.ClasseContabil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfPRPRODID" runat="server" />
    <asp:HiddenField ID="hfPFIDDEBI" runat="server" />
    <asp:HiddenField ID="hfPFIDCRED" runat="server" />
    <div class="container-fluid">

            <asp:MultiView ID="MultiView1" runat="server">
                <asp:View ID="ViewClasseContabil" runat="server">
                        <div class="row card">                            
                                <div class="card-header">
                                    <h5>
                                        <asp:Label ID="Label7" runat="server" Text="Contas a débito"></asp:Label></h5>
                                </div>
                                <div class="card-body">
                                    <dx:ASPxGridView ID="gridContaDebit_2" Theme="Moderno" runat="server" KeyFieldName="MOIDMODA" EnableRowsCache="False" Width="80%" AutoGenerateColumns="False" DataSourceID="sqlContaDebit_2" OnBatchUpdate="gridContaDebit_2_BatchUpdate">
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Columns>
                                    <dx:GridViewDataComboBoxColumn Caption="Descrição" ReadOnly="true" FieldName="MOIDMODA" VisibleIndex="0">
                                        <PropertiesComboBox DataSourceID="sqlMODALIDA" TextField="MODSMODA" ValueField="MOIDMODA" ValueType="System.Int32" />
                                        <Settings ShowEditorInBatchEditMode="False" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataTextColumn Caption="Conta" FieldName="PFCDPLNC" ReadOnly="true" VisibleIndex="1">
                                        <Settings ShowEditorInBatchEditMode="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Descrição Contábil" FieldName="PFIDDEBI" VisibleIndex="2">
                                        <PropertiesComboBox DataSourceID="sqlCredDebit" TextField="pfdsplnc" ValueField="pfidplnc" ValueType="System.Int32">
                                            <Style Font-Size="Medium">
                                                        </Style>
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>                                    
                                </Columns>
                                <Settings VerticalScrollableHeight="594" />
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsEditing Mode="Batch" />
                                <Styles>
                                    <Header Font-Size="Small" >
                                    </Header>
                                    <Row Font-Size="Smaller">
                                    </Row>
                                    <AlternatingRow Font-Size="Smaller" BackColor="LightGray"></AlternatingRow>
                                    <StatusBar Font-Size="Smaller">
                                    </StatusBar>
                                    <BatchEditCell Font-Size="Smaller">
                                    </BatchEditCell>
                                </Styles>
                            </dx:ASPxGridView>
                            <asp:SqlDataSource ID="sqlContaDebit_2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                SelectCommand="SELECT T1.MOIDMODA,T2.PFCDPLNC,t1.PFIDDEBI
                                                    FROM VIPRESCT T1,PFPLNCTA T2
                                                    WHERE T1.PFIDDEBI = T2.PFIDPLNC
                                                    AND   T1.PRPRODID = ?
                                                    ORDER BY T1.MOIDMODA"
                                UpdateCommand="UPDATE VIPRESCT SET PFIDDEBI=? WHERE PRPRODID =? and MOIDMODA=? " UpdateCommandType="Text">
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
                            <div class="row card">
                                <div class="card-header">
                                    <h5>
                                        <asp:Label ID="Label3" runat="server" Text="Contas a crédito"></asp:Label></h5>
                                </div>
                                <div class="card-body">
                                    <dx:ASPxGridView ID="gridContaCred_2" Theme="Moderno" runat="server" KeyFieldName="MOIDMODA" EnableRowsCache="False" Width="80%" AutoGenerateColumns="False" DataSourceID="sqlContaCred_2" OnBatchUpdate="gridContaCred_2_BatchUpdate">
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Columns>
                                    <dx:GridViewDataComboBoxColumn Caption="Descrição" ReadOnly="true" FieldName="MOIDMODA" VisibleIndex="0">
                                        <PropertiesComboBox DataSourceID="sqlMODALIDA" TextField="MODSMODA" ValueField="MOIDMODA" ValueType="System.Int32" />
                                        <Settings ShowEditorInBatchEditMode="False" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataTextColumn Caption="Conta" FieldName="PFCDPLNC" ReadOnly="true" VisibleIndex="1">
                                        <Settings ShowEditorInBatchEditMode="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Descrição Contábil" FieldName="PFIDCRED" VisibleIndex="2">
                                        <PropertiesComboBox DataSourceID="sqlCredDebit" TextField="pfdsplnc" ValueField="pfidplnc" ValueType="System.Int32">
                                            <Style Font-Size="Medium">
                                                        </Style>
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>                                    
                                </Columns>
                                <Settings VerticalScrollableHeight="594" />
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsEditing Mode="Batch" />
                                <Styles>
                                    <Header Font-Size="Small" >
                                    </Header>
                                    <Row Font-Size="Smaller">
                                    </Row>
                                    <AlternatingRow Font-Size="Smaller" BackColor="LightGray"></AlternatingRow>
                                    <StatusBar Font-Size="Smaller">
                                    </StatusBar>
                                    <BatchEditCell Font-Size="Smaller">
                                    </BatchEditCell>
                                </Styles>
                            </dx:ASPxGridView>
                            <asp:SqlDataSource ID="sqlContaCred_2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                SelectCommand="SELECT T1.MOIDMODA,T2.PFCDPLNC,t1.PFIDCRED
                                                    FROM VIPRESCT T1,PFPLNCTA T2
                                                    WHERE T1.PFIDCRED = T2.PFIDPLNC
                                                    AND   T1.PRPRODID = ?
                                                    ORDER BY T1.MOIDMODA"
                                UpdateCommand="UPDATE VIPRESCT SET PFIDCRED=? WHERE PRPRODID =? and MOIDMODA=? " UpdateCommandType="Text">
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
                    <asp:SqlDataSource ID="sqlCredDebit" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="select pfidplnc,pfdsplnc from PFPLNCTA order by 1"></asp:SqlDataSource>
                                <asp:SqlDataSource ID="sqlMODALIDA" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT [MOIDMODA], [MODSMODA] FROM [MODALIDA]"></asp:SqlDataSource>
                </asp:View>
                
            </asp:MultiView>
        
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <table style="width: 100%">
                <tr>
                    <td style="width: 100%">
                        <h6>
                            <asp:Label ID="Label4" runat="server" Text="Classe Contábil"></asp:Label></h6>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100%">
                        <asp:Label ID="Label1" runat="server" CssClass="form-control-sm " Text="Produto"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:DropDownList ID="dropProduto" Width="95%" CssClass="form-control-sm" AutoPostBack="true" runat="server" OnSelectedIndexChanged="dropProduto_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
        <tr>
                    <td style="width: 100%">
                        <asp:Label ID="Label2" runat="server" CssClass="form-control-sm " Text="Descrição"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtDescri" Width="95%" runat="server" CssClass="form-control-sm " Enabled="false"></asp:TextBox>
                        </div>
                    </td>
                </tr>
            </table>
</asp:Content>
