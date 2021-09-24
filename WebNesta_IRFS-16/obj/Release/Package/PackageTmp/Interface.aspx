<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Interface.aspx.cs" Inherits="WebNesta_IRFS_16.Interface" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfTituloPag" Value="Interface" runat="server" />
    <asp:HiddenField ID="hfOPIDCONT" runat="server" />
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="SELECT opidcont ,contrato ,nauxiliar ,descontrato ,codcredor,nomecredor ,dtassinatura ,dataliberacao ,dataencerramento ,opvlcont
      ,codcarteira ,empresa ,nomeempresa,diaaniversario ,valoroperacao ,valormensal ,data1parcela ,nparcelas ,taxajuros ,contarazao
      ,descindexador ,forreajuste ,perreajuste ,pessoafj ,aliqpis ,aliqcofins ,dtreajuste ,AluguelExtra
      ,MesExtra ,Percentual ,ParcRemanes ,chidcodi ,prprodid ,dataliberifrs ,Country ,Loaded ,ATR
      ,IntervaloDias,CarenciaDias,NParcCarencia,optptpid,opdtlqop,EscalaParcela,EscalaTaxaJuros,Moeda,Reajuste
  FROM CARGA_IFRS
  where Loaded &lt; 1"
        UpdateCommand="UPDATE CARGA_IFRS
   SET contrato = ?,nauxiliar = ?,descontrato = ?,codcredor = ?,dtassinatura= ?,dataliberacao=?,dataencerramento=?,opvlcont=?,codcarteira=?,empresa=?,diaaniversario=?
        ,valoroperacao=?,valormensal=?,data1parcela=?,nparcelas=?,taxajuros=?,contarazao=?,descindexador=?,forreajuste=?,perreajuste=?,pessoafj=?,aliqpis=?,aliqcofins=?
        ,dtreajuste=?,AluguelExtra=?,MesExtra=?,Percentual=?,ParcRemanes=?,chidcodi=?,prprodid=?,dataliberifrs=?,Country=?,ATR=?,IntervaloDias=?,nomecredor=?,nomeempresa=?
        ,CarenciaDias=?,NParcCarencia=?,optptpid=?,opdtlqop=?,EscalaParcela=?,EscalaTaxaJuros=?,Moeda=?,Reajuste=?
 WHERE opidcont=?"
        UpdateCommandType="Text">
        <UpdateParameters>
            <asp:Parameter Name="contrato" Type="String" />
            <asp:Parameter Name="nauxiliar" Type="String" />
            <asp:Parameter Name="descontrato" Type="String" />
            <asp:Parameter Name="codcredor" Type="String" />
            <asp:Parameter Name="dtassinatura" Type="DateTime" />
            <asp:Parameter Name="dataliberacao" Type="DateTime" />
            <asp:Parameter Name="dataencerramento" Type="DateTime" />
            <asp:Parameter Name="opvlcont" Type="Decimal" />
            <asp:Parameter Name="codcarteira" Type="String" />
            <asp:Parameter Name="empresa" Type="String" />
            <asp:Parameter Name="diaaniversario" Type="Int32" />
            <asp:Parameter Name="valoroperacao" Type="Decimal" />
            <asp:Parameter Name="valormensal" Type="Decimal" />
            <asp:Parameter Name="data1parcela" Type="DateTime" />
            <asp:Parameter Name="nparcelas" Type="Int32" />
            <asp:Parameter Name="taxajuros" Type="Decimal" />
            <asp:Parameter Name="contarazao" Type="String" />
            <asp:Parameter Name="descindexador" Type="String" />
            <asp:Parameter Name="forreajuste" Type="String" />
            <asp:Parameter Name="perreajuste" Type="String" />
            <asp:Parameter Name="pessoafj" Type="Int32" />
            <asp:Parameter Name="aliqpis" Type="Decimal" />
            <asp:Parameter Name="aliqcofins" Type="Decimal" />
            <asp:Parameter Name="dtreajuste" Type="DateTime" />
            <asp:Parameter Name="AluguelExtra" Type="String" />
            <asp:Parameter Name="MesExtra" Type="String" />
            <asp:Parameter Name="Percentual" Type="Decimal" />
            <asp:Parameter Name="ParcRemanes" Type="Decimal" />
            <asp:Parameter Name="chidcodi" Type="Int32" />
            <asp:Parameter Name="prprodid" Type="Int32" />
            <asp:Parameter Name="dataliberifrs" Type="DateTime" />
            <asp:Parameter Name="Country" Type="String" />
            <asp:Parameter Name="ATR" Type="Decimal" />
            <asp:Parameter Name="IntervaloDias" Type="Int32" />
            <asp:Parameter Name="nomecredor" Type="String" />
            <asp:Parameter Name="nomeempresa" Type="String" />
            <asp:Parameter Name="CarenciaDias" Type="Int32" />
            <asp:Parameter Name="NParcCarencia" Type="Int32" />
            <asp:Parameter Name="optptpid" Type="Int32" />
            <asp:Parameter Name="opdtlqop" Type="DateTime" />
            <asp:Parameter Name="EscalaParcela" Type="String" />
            <asp:Parameter Name="EscalaTaxaJuros" Type="String" />
            <asp:Parameter Name="Moeda" Type="String" />
            <asp:Parameter Name="Reajuste" Type="String" />
            <asp:Parameter Name="opidcont" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>


    <asp:SqlDataSource ID="sqlLogErrorContract" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="SELECT Log_Erros
  FROM CARGA_IFRS
  where opidcont=?">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <div class="container">
        <div class="row card">
            <div class="card-header">
                <h5>
                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:GlobalResource, interface_titulo1 %>"></asp:Label>
                </h5>
            </div>
            <div class="card-body">
                <dx:ASPxGridView ID="gridContractPend" KeyFieldName="opidcont" ClientInstanceName="gridView" Theme="DevEx" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1">
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <Images>
                        <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                        <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                    </Images>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" ShowClearFilterButton="True" SelectAllCheckboxMode="Page" ShowSelectCheckbox="True" MaxWidth="25" MinWidth="25" Width="25px">
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="contrato" VisibleIndex="1" Caption="Contract Number"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="nauxiliar" VisibleIndex="2" Caption="Auxiliar Number"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="descontrato" VisibleIndex="3" Caption="Contract Description"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="codcredor" VisibleIndex="4" Caption="Supplier ID"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="nomecredor" VisibleIndex="5" Caption="Supplier Name"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="dtassinatura" VisibleIndex="6" Caption="Signature Date"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataDateColumn FieldName="dataliberacao" VisibleIndex="7" Caption="Release Date"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataDateColumn FieldName="dataencerramento" VisibleIndex="8" Caption="Closing Date"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="opvlcont" VisibleIndex="9" Caption="Agreement Value"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="codcarteira" VisibleIndex="10" Caption="Portfolio"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="empresa" VisibleIndex="11" Caption="Business Unit ID"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="nomeempresa" VisibleIndex="12" Caption="Business Unit Name"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="diaaniversario" VisibleIndex="13" Caption="Birthday"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="valoroperacao" VisibleIndex="14" Caption="Contract Value"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="valormensal" VisibleIndex="15" Caption="Installment Value"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="data1parcela" VisibleIndex="16" Caption="1st Installment Pmt"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="nparcelas" VisibleIndex="17" Caption="Number of Installments"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="taxajuros" VisibleIndex="19" Caption="Annual Interest Rate"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="contarazao" VisibleIndex="21" Caption="Account #"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="descindexador" VisibleIndex="22" Caption="Indexer"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="forreajuste" VisibleIndex="23" Caption="Parametric Formula"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="perreajuste" VisibleIndex="24" Caption="Readjustment Period"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="pessoafj" VisibleIndex="25" Caption="Beneficiary"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="aliqpis" VisibleIndex="26" Caption="%PIS Recovery"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="aliqcofins" VisibleIndex="27" Caption="%COFINS Recoveries"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="dtreajuste" VisibleIndex="29" Caption="Readjustment Month"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="AluguelExtra" VisibleIndex="31" Caption="Extra Rental"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="MesExtra" VisibleIndex="32" Caption="Extra Month"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Percentual" VisibleIndex="30" Caption="%Extra Month"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ParcRemanes" VisibleIndex="44" Caption="Remain Installment"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="chidcodi" VisibleIndex="40" Caption="Component ID"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="prprodid" VisibleIndex="41" Caption="Product ID"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="dataliberifrs" VisibleIndex="33" Caption="Date"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="Country" VisibleIndex="39" Caption="Country"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ATR" VisibleIndex="34" Caption="ATR"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="IntervaloDias" VisibleIndex="18" Caption="Interval in Days"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="opdtlqop" VisibleIndex="43" Caption="Settelment Date"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="CarenciaDias" VisibleIndex="35" Caption="Grace Period in Days"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NParcCarencia" VisibleIndex="36" Caption="Grace Period Installments"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="optptpid" VisibleIndex="42" Caption="Contract Status"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="EscalaParcela" VisibleIndex="37" Caption="Scalling Installments"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="EscalaTaxaJuros" VisibleIndex="38" Caption="Scalling Interest Rate"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Moeda" VisibleIndex="20" Caption="Currency"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Reajuste" VisibleIndex="28" Caption="Readjustment"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                    <Templates>
                        <DetailRow>
                            <dx:ASPxGridView ID="gridContractPend_detail" Width="400px" OnBeforePerformDataSelect="ASPxGridView1_BeforePerformDataSelect" runat="server" AutoGenerateColumns="False" DataSourceID="sqlLogErrorContract" Theme="Office365">
                                <SettingsPager Visible="False"></SettingsPager>
                                <SettingsDataSecurity AllowEdit="False" AllowInsert="False"></SettingsDataSecurity>
                                <Columns>
                                    <dx:GridViewDataTextColumn MaxWidth="400" Width="400px" CellStyle-Wrap="True" FieldName="Log_Erros" Caption="Warnings Report:" VisibleIndex="0">
                                        <DataItemTemplate>
                                            <asp:TextBox ID="TextBox1" runat="server" ReadOnly="true" TextMode="MultiLine" Text='<%# Eval("Log_Erros").ToString().Replace("!clf?",Environment.NewLine) %>' Width="400px" Height="200px"></asp:TextBox>
                                        </DataItemTemplate>
                                    </dx:GridViewDataTextColumn>
                                </Columns>
                                <Styles>
                                    <Header Font-Names="Arial" Font-Size="11pt" ForeColor="DarkOrange" Font-Bold="true">
                                    </Header>
                                    <Row CssClass=" table-warning" Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                                    </Row>
                                </Styles>
                            </dx:ASPxGridView>
                        </DetailRow>
                        <StatusBar>
                            <div style="text-align: left">
                                <br />
                                <dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" Font-Size="12pt" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridView.UpdateEdit(); }">
                                    <HoverStyle Border-BorderColor="LightBlue" BackColor="LightBlue" ForeColor="DimGray" Font-Size="12pt"></HoverStyle>

                                </dx:ASPxButton>
                                <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" Font-Size="12pt" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridView.CancelEdit(); }">
                                    <HoverStyle Border-BorderColor="LightBlue" BackColor="LightBlue" ForeColor="DimGray" Font-Size="12pt"></HoverStyle>
                                </dx:ASPxButton>
                            </div>
                        </StatusBar>
                    </Templates>
                    <SettingsDetail AllowOnlyOneMasterRowExpanded="true" ShowDetailButtons="true" ShowDetailRow="true" />
                    <StylesPager>
                        <PageNumber Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray"></PageNumber>
                    </StylesPager>
                    <Styles>

                        <StatusBar HorizontalAlign="Left" CssClass="myBatchButtons"></StatusBar>
                        <Header Wrap="True" Font-Names="Arial" Font-Size="10pt" HorizontalAlign="Center">
                        </Header>
                        <Row Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                        </Row>
                        <AlternatingRow Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                    </Styles>
                </dx:ASPxGridView>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container">
        <div class="card row mt-1" style="margin: 0 auto">
            <div class="card-header pb-0 pt-0">
                <h6>
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:GlobalResource, interface_right_titulo %>"></asp:Label></h6>
            </div>
            <div class="card-body p-0 mt-2">
                <div class="row" style="margin: 0 auto; margin-top: 2px">
                <div class="col-lg-6 pl-0" style="text-align: center;">
                    <asp:Button ID="btnOK" runat="server" CssClass="btn-using ok" Text="<%$ Resources:GlobalResource, btn_ok %>" OnClick="btnOK_Click" />
                </div>
                <div class="col-lg-6 pl-0" style="text-align: center;">
                    <asp:Button ID="btnCancelar" runat="server" CssClass="btn-using cancelar" Text="<%$ Resources:GlobalResource, btn_cancelar %>" OnClick="btnCancelar_Click" />
                </div>
                    </div>
            </div>
        </div>
    </div>
</asp:Content>
