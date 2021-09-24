<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Feriados.aspx.cs" Inherits="WebNesta_IRFS_16.Feriados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfPais" ClientIDMode="Static" runat="server" />
    <div class="container-fluid">
        <div class="row">
            <div class="col-sm-2 pl-1">
                <div class="container-fluid">
                    <div class="row mt-1" style="width: 170px;">
                        <table style="width: 170px; height: 90px; line-height: 90px; vertical-align: middle; white-space: normal; margin: 0 auto; display: table-cell; background-color: #679966">
                            <tr>
                                <td style="width: 40%; line-height: 20px; padding-left: 10px;">
                                    <label class="labels" style="font-size: 12pt; color: #99CC99; font-weight: 100">Quick Guide</label>
                                </td>
                                <td style="width: 50%;">
                                    <img src="img/Screenshot_1.jpg" style="width: 95%" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="row mt-2">
                        <div class="col-12 text-left p-0">
                            <table style="width: 170px; height: 303px; white-space: normal; display: block; border: 1px solid #c0c0c0;">
                                <tr style="height: 203px; display: table-cell; line-height: 203px; vertical-align: top;">
                                    <td style="width: 170px; line-height: 15px; padding-left: 5px; padding-right: 5px; padding-top: 15px">
                                        <label id="lblquickGuide" class="labels" style="font-size: 12pt; color: #c0c0c0; font-weight: 100"><%=Resources.GlobalResource.quickguide_inicial %></label>
                                    </td>
                                </tr>
                                <tr style="height: 100px; text-align: center">
                                    <td style="padding: 15px; vertical-align: bottom;">
                                        <asp:LinkButton ID="LinkButton1" CssClass="btn-help" runat="server">AJUDA</asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-10">
                <div class="row">
                    <div class="col-12 card p-0">
                        <div class="card-header border-bottom-0 pb-0">
                            <div class="row">
                                <div class="col-lg-12" style="margin: 0 auto">
                                    <h4>
                                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:GlobalResource, feriado_tituloPag %>" CssClass="labels text-left"></asp:Label></h4>
                                </div>
                            </div>
                        </div>
                        <div class="card-body pt-0">
                            <div class="row" style="margin: 0 auto">
                                <div class="col-lg-12" style="margin: 0 auto">
                                    <dx:ASPxGridView ID="gridFeriados" EnableCallBacks="true" ClientInstanceName="gridFeriados" KeyFieldName="TBIDFERI" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False" OnBatchUpdate="gridFeriados_BatchUpdate" OnCellEditorInitialize="gridFeriados_CellEditorInitialize" DataSourceID="sqlFeriado">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Columns>
                                            <dx:GridViewCommandColumn Name="CommandColumn" MaxWidth="50" Width="50px" Visible="false" ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataDateColumn FieldName="TBDTFERI" MaxWidth="100" Width="100px" Caption="<%$Resources:GlobalResource, feriado_grid_col1 %>" VisibleIndex="1"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="TBNMFERI" MaxWidth="200" Width="200px" Caption="<%$Resources:GlobalResource, feriado_grid_col2 %>" VisibleIndex="2">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PAIDPAIS" MaxWidth="200" Width="200px" Caption="<%$Resources:GlobalResource, feriado_grid_col3 %>" VisibleIndex="3">
                                                <PropertiesComboBox DataSourceID="sqlPais2" TextField="PANMPAIS" ValueField="PAIDPAIS"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>                                            
                                        </Columns>
                                        <Settings VerticalScrollableHeight="594" />
                                        <SettingsPager NumericButtonCount="20" PageSize="10">
                                        </SettingsPager>
                                        <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="true" />
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                            <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            </Row>
                                            <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                            <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                <Paddings Padding="0px" />
                                            </BatchEditCell>
                                            <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>

                                    </dx:ASPxGridView>

                                    <asp:SqlDataSource runat="server" ID="sqlFeriado" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select * from tbferiad where PAIDPAIS=? AND TBFLFERI=0 order by TBDTFERI"
                                        InsertCommand="select * from tbferiad"
                                        UpdateCommand="select * from tbferiad">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfPais" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource runat="server" ID="sqlPais2" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select PAIDPAIS,PANMPAIS from PAPAPAIS order by 2"></asp:SqlDataSource>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-0 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:GlobalResource, feriado_tituloPag %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
            <div class="card-body p-0 text-left">
                <h6>
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:GlobalResource, feriado_right_lbl1 %>" CssClass="labels text-left"></asp:Label></h6>
                <div class="input-group mb-auto">
                    <dx:ASPxComboBox ID="dropPais" ForeColor="dimgray" runat="server" CssClass="drop-down2" Theme="Material" Width="100%" DataSourceID="sqlPais" TextField="PANMPAIS" ValueField="PAIDPAIS" ValueType="System.Int32">
                        <ClientSideEvents SelectedIndexChanged="function(s,e){
                            document.getElementById('hfPais').value = s.GetValue();
                            gridFeriados.Refresh();}" />
                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                            <HoverStyle BackColor="#669999"></HoverStyle>
                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                        </ButtonStyle>
                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                    </dx:ASPxComboBox>
                    <asp:SqlDataSource runat="server" ID="sqlPais" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                        SelectCommand="select PAIDPAIS,PANMPAIS from PAPAPAIS order by 2"></asp:SqlDataSource>
                </div>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 2px">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <dx:ASPxButton ID="btnInserir" runat="server" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>">
                    <ClientSideEvents Click="function(s, e){gridFeriados.AddNewRow();}" />
                </dx:ASPxButton>
            </div>
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnexcluir" OnClick="btnexcluir_Click" runat="server" CssClass="Loading btn-using" Text="<%$ Resources:GlobalResource, btn_excluir %>" />
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 2px">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnOK" OnClick="btnOK_Click" Enabled="false" runat="server" CssClass="Loading btn-using ok" Text="<%$ Resources:GlobalResource, btn_ok %>" />
            </div>
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnCancelar" OnClick="btnCancelar_Click" Enabled="false" runat="server" CssClass="Loading btn-using cancelar" Text="<%$ Resources:GlobalResource, btn_cancelar %>" CausesValidation="false" />
            </div>
        </div>
    </div>
</asp:Content>
