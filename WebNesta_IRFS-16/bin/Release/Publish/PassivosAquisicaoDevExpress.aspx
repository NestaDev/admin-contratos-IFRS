<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PassivosAquisicaoDevExpress.aspx.cs" Inherits="WebNesta_IRFS_16.PassivosAquisicaoDevExpress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfOPIDCONT" runat="server" />
    <div class="container-fluid card">
        <div class="row card-header">
            <table style="width: 100%">
                <tr>
                    <td style="width: 25%">
                        <asp:Label ID="Label1" runat="server" CssClass="form-control-sm " Text="Operação"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtOper" runat="server" Width="95%" CssClass="form-control-sm " Enabled="false"></asp:TextBox>
                        </div>

                    </td>
                    <td style="width: 25%">
                        <asp:Label ID="Label2" runat="server" CssClass="form-control-sm " Text="Índice"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtIndice" runat="server" Width="95%" CssClass="form-control-sm " Enabled="false"></asp:TextBox>
                        </div>
                    </td>
                    <td style="width: 25%">
                        <asp:Label ID="Label3" runat="server" CssClass="form-control-sm " Text="Descrição"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtDesc" runat="server" Width="95%" CssClass="form-control-sm " Enabled="false"></asp:TextBox>
                        </div>
                    </td>
                    <td style="width: 25%">
                        <asp:Label ID="Label4" runat="server" CssClass="form-control-sm " Text="Contraparte"></asp:Label>
                        <div class="input-group mb-auto">
                            <asp:TextBox ID="txtContra" Width="95%" runat="server" CssClass="form-control-sm " Enabled="false"></asp:TextBox>
                        </div>
                    </td>
                </tr>

            </table>



        </div>
        <div class="row card-body">
            <asp:MultiView ID="MultiView1" runat="server">
                <asp:View ID="ViewContratos" runat="server">
                    <div class="card w-100">
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label7" runat="server" Text="Contratos"></asp:Label></h4>
                        </div>
                        <div class="card-body-center">
                            <dx:ASPxGridView ID="ASPxGridView1" Width="90%" ClientInstanceName="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" Theme="Moderno" OnCustomButtonCallback="ASPxGridView1_CustomButtonCallback" EnableCallBacks="False">
                                <Settings ShowFilterRow="True" />
                                <SettingsBehavior AllowFocusedRow="True" />
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Columns>
                                    <dx:GridViewCommandColumn VisibleIndex="0" ButtonRenderMode="Image" ShowClearFilterButton="True">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="Select">
                                                <Image ToolTip="Select" Url="icons/ok.png" />
                                            </dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Código operação" FieldName="OPIDCONT" VisibleIndex="1">
                                        <PropertiesComboBox DataSourceID="sqlComboFilter" ValueField="OPIDCONT" TextField="OPIDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                        <Settings AllowAutoFilter="True" />
                                        <EditFormSettings VisibleIndex="0" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Código contrato" FieldName="OPCDCONT" VisibleIndex="2">
                                        <Settings AllowAutoFilter="True" />
                                        <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPCDCONT" ValueField="OPCDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                        </PropertiesComboBox>
                                        <EditFormSettings VisibleIndex="1" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Descrição contrato" FieldName="OPNMCONT" VisibleIndex="3">
                                        <Settings AllowAutoFilter="True" />
                                        <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="OPNMCONT" ValueField="OPNMCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                        <EditFormSettings VisibleIndex="2" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Contraparte" FieldName="FONMAB20" VisibleIndex="4">
                                        <Settings AllowAutoFilter="True" />
                                        <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="FONMAB20" ValueField="FONMAB20" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                        </PropertiesComboBox>
                                        <EditFormSettings VisibleIndex="3" />
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn Caption="Índice" FieldName="IENMINEC" VisibleIndex="5">
                                        <Settings AllowAutoFilter="True" />
                                        <PropertiesComboBox DataSourceID="sqlComboFilter" TextField="IENMINEC" ValueField="IENMINEC" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                        </PropertiesComboBox>
                                        <EditFormSettings VisibleIndex="4" />
                                    </dx:GridViewDataComboBoxColumn>

                                </Columns>
                            </dx:ASPxGridView>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, IE.IENMINEC 
                    FROM OPCONTRA OP, CACTEIRA CA, OPTPFRCO FR, 
                         TPSIMNAO SN, OPTPRGCO RG, OPTPTIPO TP, 
                         PRPRODUT PR, PRTPOPER PE, IEINDECO IE, 
                         FOFORNEC FO, TVESTRUT TV 
                    WHERE OP.CAIDCTRA = CA.CAIDCTRA 
                    AND OP.PRTPIDOP IN(1, 7, 8, 17)  
                    AND OP.OPTPFRID = FR.OPTPFRID 
                    AND OP.TPIDSINA = SN.TPIDSINA 
                    AND OP.OPTPTPID = TP.OPTPTPID 
                    AND OP.PRPRODID = PR.PRPRODID 
                    AND OP.OPTPRGID = RG.OPTPRGID 
                    AND OP.PRTPIDOP = PE.PRTPIDOP 
                    AND PR.IEIDINEC = IE.IEIDINEC 
                    AND OP.FOIDFORN = FO.FOIDFORN 
                    AND OP.TVIDESTR = TV.TVIDESTR 
                    AND PE.CMTPIDCM = FR.CMTPIDCM 
                    AND PE.CMTPIDCM = RG.CMTPIDCM 
                    AND PE.CMTPIDCM = TP.CMTPIDCM 
                    AND PE.CMTPIDCM IN(1, 8)  
                    AND PE.PAIDPAIS = 1 
                    AND FR.CMTPIDCM IN(1, 8) 
                    AND FR.PAIDPAIS = 1 
                    AND SN.PAIDPAIS = 1 
                    AND RG.CMTPIDCM IN(1, 8) 
                    AND RG.PAIDPAIS = 1 
                    AND TP.CMTPIDCM IN(1, 8)  
                    AND TP.PAIDPAIS = 1 "></asp:SqlDataSource>
                            <asp:SqlDataSource ID="sqlComboFilter" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT OP.OPIDCONT, OP.OPCDCONT, OP.OPNMCONT, FO.FONMAB20, IE.IENMINEC 
                    FROM OPCONTRA OP, CACTEIRA CA, OPTPFRCO FR, 
                         TPSIMNAO SN, OPTPRGCO RG, OPTPTIPO TP, 
                         PRPRODUT PR, PRTPOPER PE, IEINDECO IE, 
                         FOFORNEC FO, TVESTRUT TV 
                    WHERE OP.CAIDCTRA = CA.CAIDCTRA 
                    AND OP.PRTPIDOP IN(1, 7, 8, 17)  
                    AND OP.OPTPFRID = FR.OPTPFRID 
                    AND OP.TPIDSINA = SN.TPIDSINA 
                    AND OP.OPTPTPID = TP.OPTPTPID 
                    AND OP.PRPRODID = PR.PRPRODID 
                    AND OP.OPTPRGID = RG.OPTPRGID 
                    AND OP.PRTPIDOP = PE.PRTPIDOP 
                    AND PR.IEIDINEC = IE.IEIDINEC 
                    AND OP.FOIDFORN = FO.FOIDFORN 
                    AND OP.TVIDESTR = TV.TVIDESTR 
                    AND PE.CMTPIDCM = FR.CMTPIDCM 
                    AND PE.CMTPIDCM = RG.CMTPIDCM 
                    AND PE.CMTPIDCM = TP.CMTPIDCM 
                    AND PE.CMTPIDCM IN(1, 8)  
                    AND PE.PAIDPAIS = 1 
                    AND FR.CMTPIDCM IN(1, 8) 
                    AND FR.PAIDPAIS = 1 
                    AND SN.PAIDPAIS = 1 
                    AND RG.CMTPIDCM IN(1, 8) 
                    AND RG.PAIDPAIS = 1 
                    AND TP.CMTPIDCM IN(1, 8)  
                    AND TP.PAIDPAIS = 1"></asp:SqlDataSource>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="ViewFluxoCaixa" runat="server">
                    <div class="card w-100">
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label5" runat="server" Text="Fluxo caixa"></asp:Label></h4>
                        </div>
                        <div class=" card-body-center">

                            <asp:SqlDataSource ID="sqlFluxoCaixa" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT [PHDTEVEN], [PHDTPAGT], [PHNMSEQU], [PHNRPARC], [PHNRDIAS], [PHVLDEVE], [PHVLAMOR], [PHVLJURO], [PHVLCOMI], [PHVLSPRE], [PHVLENC1], [PHVLENC2], [PHVLIPRE], [PHVLTOTA] FROM [PHPLANIF] WHERE ([OPIDCONT] = ?) ORDER BY [PHNRPARC], [PHDTEVEN]">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfOPIDCONT" Name="OPIDCONT" PropertyName="Value" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            
                            <dx:ASPxGridView ID="gridFluxoCaixa"  DataSourceID="sqlFluxoCaixa" runat="server" AutoGenerateColumns="False" Theme="Moderno">
                                <Toolbars>
                                    <dx:GridViewToolbar>
                                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                        <Items>
                                            <dx:GridViewToolbarItem Command="ExportToXlsx" DisplayMode="Image" />
                                            <dx:GridViewToolbarItem Command="ExportToCsv" DisplayMode="Image" />
                                        </Items>
                                    </dx:GridViewToolbar>
                                </Toolbars>
                                <Settings VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" />
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG">
                                </SettingsExport>
                                <Columns>
                                    <dx:GridViewDataDateColumn Caption="Evento" Width="90px" FieldName="PHDTEVEN" VisibleIndex="0">
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataDateColumn Caption="Pagamento" Width="90px" FieldName="PHDTPAGT" VisibleIndex="1">
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn Caption="Parc" FieldName="PHNMSEQU" VisibleIndex="2">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Seq" FieldName="PHNRPARC" VisibleIndex="3">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Dias" FieldName="PHNRDIAS" VisibleIndex="4">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Devedor" Width="70px" FieldName="PHVLDEVE" VisibleIndex="5">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Amortizado" Width="75px" FieldName="PHVLAMOR" VisibleIndex="6">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Juros" FieldName="PHVLJURO" VisibleIndex="7">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Comissões" FieldName="PHVLCOMI" VisibleIndex="8">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Spread" FieldName="PHVLSPRE" VisibleIndex="9">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Enc1" FieldName="PHVLENC1" VisibleIndex="10">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Enc2" FieldName="PHVLENC2" VisibleIndex="11">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Taxas" FieldName="PHVLIPRE" VisibleIndex="12">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Total" FieldName="PHVLTOTA" VisibleIndex="13">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="OPIDCONT" Visible="False" VisibleIndex="14">
                                        <PropertiesTextEdit DisplayFormatString="{0:n2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Styles>
                                    <Row Font-Size="Smaller" CssClass="mb-0">
                                    </Row>
                                    <AlternatingRow CssClass="mb-0" BackColor="#CCCCCC" Font-Size="Smaller">
                                    </AlternatingRow>
                                </Styles>
                            </dx:ASPxGridView>
                            <dx:ASPxGridViewExporter ID="ASPxGridViewExporter1" GridViewID="gridFluxoCaixa" runat="server"></dx:ASPxGridViewExporter>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="ViewExtratoFinanceiro" runat="server">
                    <div class="card w-100">
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label6" runat="server" Text="Extrato financeiro"></asp:Label></h4>
                        </div>
                        <div class="card-body-center">
                            <asp:SqlDataSource ID="sqlExtratoFinanc" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT T1.RZDTDATA, T2.MODSMODA RZDSHIST, T1.RZVLDEBI,
       T1.RZVLCRED, T1.RZVLSALD, T1.RZVLPRIN, T1.RZVLCOTA, T1.OPIDCONT
FROM RZRAZCTB T1, MODALIDA T2
WHERE T1.MOIDMODA = T2.MOIDMODA AND
      T2.MOTPIDCA &lt;&gt; 1
ORDER BY T1.RZDTDATA, T1.RZNRREGI"
                                EnableCaching="true" FilterExpression="OPIDCONT='{0}'">
                                <FilterParameters>
                                    <asp:ControlParameter Name="OPIDCONT" ControlID="hfOPIDCONT" PropertyName="Value" />
                                </FilterParameters>
                            </asp:SqlDataSource>
                            <dx:ASPxGridView ID="gridExtratoFinanc" DataSourceID="sqlExtratoFinanc" Width="100%" runat="server" AutoGenerateColumns="False" Theme="Moderno">
                                <Columns>
                                    <dx:GridViewDataDateColumn FieldName="RZDTDATA" VisibleIndex="0" Width="10%" Caption="Evento">
                                        <PropertiesDateEdit DisplayFormatString="{0:d}">
                                        </PropertiesDateEdit>
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="RZDSHIST" VisibleIndex="1" Width="40%" Caption="Descrição">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="RZVLDEBI" VisibleIndex="2" Width="10%" Caption="Débito">
                                        <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="RZVLCRED" VisibleIndex="3" Width="10%" Caption="Crédito">
                                        <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="RZVLSALD" VisibleIndex="4" Width="10%" Caption="Saldo devedor">
                                        <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="RZVLPRIN" VisibleIndex="5" Width="10%" Caption="Saldo principal">
                                        <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="RZVLCOTA" VisibleIndex="6" Width="10%" Caption="Cotação">
                                        <PropertiesTextEdit DisplayFormatString="{0:N6}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Styles>
                                    <Row Font-Size="Smaller" CssClass="mb-0">
                                    </Row>
                                    <AlternatingRow CssClass="mb-0" BackColor="#CCCCCC" Font-Size="Smaller">
                                    </AlternatingRow>
                                </Styles>
                                <Toolbars>
                                    <dx:GridViewToolbar>
                                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                        <Items>
                                            <dx:GridViewToolbarItem Command="ExportToXlsx" DisplayMode="Image" />
                                            <dx:GridViewToolbarItem Command="ExportToCsv" DisplayMode="Image" />
                                        </Items>
                                    </dx:GridViewToolbar>
                                </Toolbars>
                                <SettingsPager EnableAdaptivity="true" NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG">
                                </SettingsExport>
                            </dx:ASPxGridView>
                            <dx:ASPxGridViewExporter ID="ASPxGridViewExporter2" GridViewID="gridExtratoFinanc" runat="server"></dx:ASPxGridViewExporter>
                        </div>
                    </div>
                </asp:View>
                <asp:View ID="ViewContabil" runat="server">
                    <div class="card w-100">
                        <div class="card-header">
                            <h4>
                                <asp:Label ID="Label9" runat="server" Text="Contábil"></asp:Label></h4>
                        </div>
                        <div class="card-body-center">
                            <asp:SqlDataSource ID="sqlContabil" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                SelectCommand="SELECT T1.LBDTLANC, T1.LBTPLANC, T2.PFCDPLNC,
                                                       T2.PFDSPLNC, T3.MODSMODA, T1.LBVLLANC
                                                FROM LBLCTCTB T1
                                                 LEFT OUTER JOIN  PFPLNCTA T2 ON (T1.PFIDPLNC = T2.PFIDPLNC) 
                                                 INNER JOIN MODALIDA T3 ON (T1.MOIDMODA = T3.MOIDMODA) 
                                                WHERE   T1.MOIDMODA = T3.MOIDMODA
                                                  AND T1.OPIDCONT = ?
                                                ORDER BY LBDTLANC, T3.MOIDMODA, T1.LBTPLANC,
                                                         T2.PFCDPLNC">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfOPIDCONT" Name="OPIDCONT" PropertyName="Value" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <dx:ASPxGridView ID="gridContabil" Width="90%" runat="server" AutoGenerateColumns="False" Theme="Moderno" DataSourceID="sqlContabil">

                                <Styles>
                                    <Row Font-Size="Smaller" CssClass="mb-0">
                                    </Row>
                                    <AlternatingRow CssClass="mb-0" BackColor="#CCCCCC" Font-Size="Smaller">
                                    </AlternatingRow>
                                </Styles>
                                <Columns>

                                    <dx:GridViewDataDateColumn Caption="Data" FieldName="LBDTLANC" VisibleIndex="0">
                                    </dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn Caption="D/C" FieldName="LBTPLANC" VisibleIndex="1" Width="50px">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Conta contábil" FieldName="PFCDPLNC" VisibleIndex="2">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Descrição" FieldName="PFDSPLNC" VisibleIndex="3">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Modalidade" FieldName="MODSMODA" VisibleIndex="4">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn Caption="Valor lançamento" FieldName="LBVLLANC" VisibleIndex="5">
                                        <PropertiesTextEdit DisplayFormatString="{0:N2}">
                                        </PropertiesTextEdit>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Toolbars>
                                    <dx:GridViewToolbar>
                                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                        <Items>
                                            <dx:GridViewToolbarItem Command="ExportToXlsx" DisplayMode="Image" />
                                            <dx:GridViewToolbarItem Command="ExportToCsv" DisplayMode="Image" />
                                        </Items>
                                    </dx:GridViewToolbar>
                                </Toolbars>
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>

                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG">
                                </SettingsExport>
                            </dx:ASPxGridView>
                        </div>
                    </div>
                </asp:View>
            </asp:MultiView>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <table>
        <tr>
            <td style="width: 100%">
                <asp:Panel ID="pnlNavegacao" runat="server" Visible="false">
                    <asp:Label ID="Label8" runat="server" CssClass="form-control-sm " Text="Navegação"></asp:Label>
                    <div class="input-group mb-auto">
                        <asp:DropDownList ID="dropMultiView" Width="100%" CssClass="form-control-sm" runat="server" AutoPostBack="True" OnSelectedIndexChanged="dropMultiView_SelectedIndexChanged">
                            <asp:ListItem Text="Contratos" Value="0" />
                            <asp:ListItem Text="Fluxo caixa" Value="1" />
                            <asp:ListItem Text="Extrato financeiro" Value="2" />
                            <asp:ListItem Text="Contábil" Value="3" />
                        </asp:DropDownList>
                    </div>
                </asp:Panel>
            </td>
        </tr>
    </table>
    <table>
        <asp:Panel ID="pnlProcFluxo" Visible="false" runat="server">
            <tr>
                <td style="width: 95%">
                    <asp:Label ID="Label10" runat="server" CssClass="form-control-sm " Text=""></asp:Label>
                    <div class="input-group mb-auto">
                        <asp:Button ID="btnProcFluxo" CssClass="btn btn-secondary btn-sm form-control-sm" runat="server" Text="Processar" OnClick="btnProcFluxo_Click" />
                    </div>
                </td>
            </tr>
        </asp:Panel>
        <asp:Panel ID="pnlProcExtrato" Visible="false" runat="server">
            <tr>
                <td style="width: 95%">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="ASPxRadioButtonList1" runat="server" ForeColor="Red" ErrorMessage="Filtro Obrigatório"></asp:RequiredFieldValidator>
                    <dx:ASPxRadioButtonList ID="ASPxRadioButtonList1" Width="95%" CssClass="form-control-sm" Theme="Moderno" runat="server" ValueType="System.String" AutoPostBack="True" OnSelectedIndexChanged="ASPxRadioButtonList1_SelectedIndexChanged" RepeatDirection="Horizontal" Border-BorderStyle="None" FocusedStyle-Wrap="Default">
                        <Items>
                            <dx:ListEditItem Text="Saldo" Value="2" />
                            <dx:ListEditItem Text="Extrato" Value="1" />
                        </Items>
                    </dx:ASPxRadioButtonList>
                </td>
            </tr>
            <tr>
                <td style="width: 95%; text-align: left">
                    <asp:Label ID="lblDataExtrato" runat="server" CssClass="form-control-sm text-left" Visible="false" Text="Data:"></asp:Label>
                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" TargetControlID="txtDataExtrato" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Enabled="false" runat="server" ControlToValidate="txtDataExtrato" ForeColor="Red" ErrorMessage="Campo obrigatório"></asp:RequiredFieldValidator>
                    <div class="input-group mb-auto">
                        <asp:TextBox ID="txtDataExtrato" Width="95%" Visible="false" runat="server"></asp:TextBox>
                    </div>
                </td>
            </tr>
            <tr>
                <td style="width: 95%">
                    <asp:Label ID="Label12" runat="server" CssClass="form-control-sm " Text=""></asp:Label>
                    <div class="input-group mb-auto">
                        <asp:Button ID="btnProcExtrato" CssClass="btn btn-secondary btn-sm form-control-sm" runat="server" Text="Processar" OnClick="btnProcExtrato_Click" />
                    </div>
                </td>
            </tr>
        </asp:Panel>
        <asp:Panel ID="pnlProcContab" Visible="false" runat="server">
            <tr>
            <td style="width: 95%">
                <asp:Label ID="lblDataConta" runat="server" CssClass="form-control-sm text-left" Text="Data:"></asp:Label>
                <ajaxToolkit:CalendarExtender ID="CalendarExtender2" TargetControlID="txtDataConta" runat="server" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDataConta" ForeColor="Red" ErrorMessage="Campo obrigatório"></asp:RequiredFieldValidator>
                <div class="input-group mb-auto">
                    <asp:TextBox ID="txtDataConta" Width="95%" runat="server"></asp:TextBox>
                </div>
            </td></tr><tr>
            <td style="width: 95%">
                <asp:Label ID="Label11" runat="server" CssClass="form-control-sm " Text=""></asp:Label>
                <div class="input-group mb-auto">
                    <asp:Button ID="btnProcContab" CssClass="btn btn-secondary btn-sm form-control-sm" runat="server" Text="Processar" OnClick="btnProcContab_Click" />
                </div>
            </td></tr>
        </asp:Panel>
    </table>
</asp:Content>
