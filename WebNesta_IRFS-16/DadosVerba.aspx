<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DadosVerba.aspx.cs" Inherits="WebNesta_IRFS_16.DadosVerba" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function DataCallback(result) {
            var results = result.split("#");
            gridVerbas.batchEditApi.EndEdit();
            gridVerbas.batchEditApi.SetCellValue(startIndex, results[0].toString(), results[1]);
            var keyIndex = gridVerbas.GetColumnByField(results[0].toString()).index;
            gridVerbas.batchEditApi.StartEdit(startIndex, keyIndex);
            var editor = gridVerbas.GetEditor('valor_atual');
            if (results[2].toString() == '25700' || results[2].toString() == '25702' || results[2].toString() == '25703') {
                editor.SetReadOnly(true);
            }
        }
        function ClearSelection() {
            TreeList.SetFocusedNodeKey("");
            UpdateControls(null, "");
            document.getElementById('hfDropEstr').value = "";
        }
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropEstr').value = TreeList.GetFocusedNodeKey();
            if (focusedNodeKey != "")
                employeeName = TreeList.cpEmployeeNames[focusedNodeKey];
            UpdateControls(focusedNodeKey, employeeName);
        }
        function UpdateControls(key, text) {
            DropDownEdit.SetText(text);
            DropDownEdit.SetKeyValue(key);
            DropDownEdit.HideDropDown();
            UpdateButtons();
        }
        function UpdateButtons() {
            clearButton.SetEnabled(DropDownEdit.GetText() != "");
            selectButton.SetEnabled(TreeList.GetFocusedNodeKey() != "");

        }
        function OnDropDown() {
            TreeList.SetFocusedNodeKey(DropDownEdit.GetKeyValue());
            TreeList.MakeNodeVisible(TreeList.GetFocusedNodeKey());
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row ml-0 mr-0 mt-0 w-100">
            <div class="col-sm-2">
                <div class="container-fluid">
                    <div class="row mt-2">
                        <div class="col-12 text-left p-0">
                            <div class="card pr-2 pl-2 quickGuide">
                                <div class="card-header quickGuide-header">
                                    <label>Quick Guide</label>
                                </div>
                                <div class="card-body p-0 pt-2 quickGuide-body">
                                    <label id="lblquickGuide"><%=Resources.DadosVerba.dadosverba_guide_ini %></label>
                                </div>
                                <div class="card-footer bg-transparent quickGuide-footer">
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Fornecedores, fornecedor_content_tutorial %>" />
                                    <dx:ASPxButton ID="btnAjuda" runat="server" AutoPostBack="false" CssClass="btn-saiba-mais" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_readmore %>">
                                        <ClientSideEvents Click="function (s,e){
                                            popupSaibaMais.RefreshContentUrl();
                                            popupSaibaMais.SetContentUrl(document.getElementById('hfContentPage').value);
                                            setTimeout('popupSaibaMais.Show();', 500);
                                            }" />
                                    </dx:ASPxButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-10 pl-4 pr-0">
                <div class="row w-100 m-0">
                    <div class="card w-100 bg-transparent">
                        <div class="card-header bg-transparent">
                            <h4>
                                <asp:Label ID="Label1" runat="server" onmouseover="QuickGuide('titulo');" onmouseout="QuickGuide('ini');" Text="<%$Resources:DadosVerba, dadosverba_tituloPag %>"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent">
                            <div class="row w-100 mb-1 pl-3">
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label5" runat="server" Text="Número Processo" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Apelido');" onmouseout="QuickGuide('ini');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtNum" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label3" runat="server" Text="Tipologia" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Apelido');" onmouseout="QuickGuide('ini');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtTipologia" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1">
                                    <asp:Label ID="Label7" runat="server" Text="Empresa" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Apelido');" onmouseout="QuickGuide('ini');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtEmpresa" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1">
                                    <asp:Label ID="Label8" runat="server" Text="Valor" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('Apelido');" onmouseout="QuickGuide('ini');" style="padding-left: 2px">
                                        <asp:TextBox ID="txtValor" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>

                                    </div>
                                </div>
                            </div>
                            <div class="row w-100 card bg-transparent">
                                <div class="card-header bg-transparent">
                                    <h5>
                                        <asp:Label ID="lblCompet1" Visible="false" runat="server" Text="Verbas Competência: "></asp:Label>
                                        <asp:Label ID="lblCompet" Visible="false" runat="server" Text="Verbas Competência: "></asp:Label>
                                    </h5>
                                </div>
                                <div class="card-body bg-transparent">
                                    <asp:MultiView ID="mvBoletagem" runat="server">
                                        <asp:View ID="vw_dataentry" runat="server">
                                            <dx:ASPxGridView ID="gridVerbas" CssClass="bg-transparent" ClientInstanceName="gridVerbas" KeyFieldName="verba;valor_media;valor_atual" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                                DataSourceID="sqlVerbasFluxo" OnInit="gridVerbas_Init" OnBatchUpdate="gridVerbas_BatchUpdate" OnCustomButtonCallback="gridVerbas_CustomButtonCallback" OnCustomButtonInitialize="gridVerbas_CustomButtonInitialize" OnCommandButtonInitialize="gridVerbas_CommandButtonInitialize"
                                                OnRowValidating="gridVerbas_RowValidating" OnCustomDataCallback="gridVerbas_CustomDataCallback">
                                                <ClientSideEvents BatchEditStartEditing=" function(s,e) {
                                                    startIndex = e.visibleIndex;
                                                var verba = s.batchEditApi.GetCellValue(e.visibleIndex, 'verba',false);
                                                var valor_media = s.batchEditApi.GetCellValue(e.visibleIndex, 'valor_media',false);
                                                var valor_atual = s.batchEditApi.GetCellValue(e.visibleIndex, 'valor_atual',false);
                                                var conta = verba + valor_media + valor_atual;
                                                if(conta == 0)
                                                {
                                        
                                                }
                                                else
                                                {                                                    
                                                    if(e.focusedColumn.fieldName == 'verba' || e.focusedColumn.fieldName == 'valor_media')
                                                    {
                                                        editor = s.GetEditor(e.focusedColumn.fieldName);  
                                                        editor.SetReadOnly(true);
                                                    }
                                                }                                                    
                                            } "
                                                    CustomButtonClick="function OnClick(s, e) {  
                                                       if (e.buttonID == 'fluxo') {  
                                                           popupFluxoComplemento.Show();  
                                                       }  
                                                    } " />
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsText Title="Data Entry" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Settings VerticalScrollableHeight="594" />
                                                <SettingsBehavior AllowFocusedRow="true" />
                                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                                </SettingsPager>
                                                <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="true" />
                                                <SettingsCommandButton>
                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                                                        </Image>
                                                    </NewButton>
                                                    <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                                                        <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                                                        </Image>
                                                    </DeleteButton>
                                                    <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                                                        <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                                                        </Image>
                                                    </RecoverButton>
                                                </SettingsCommandButton>
                                                <Columns>
                                                    <dx:GridViewCommandColumn ShowNewButtonInHeader="True" ShowDeleteButton="true" VisibleIndex="0" ButtonRenderMode="Image">
                                                        <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="duplicar" Text="Duplicar">
                                                                <Image ToolTip="Duplicar" Url="img/icons8-duplicate-40.png" Width="15px"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                            <dx:GridViewCommandColumnCustomButton ID="fluxo" Text="Faturamento">
                                                                <Image ToolTip="Faturamento" Url="icons/icons8-profit-report-40.png" Width="15px"></Image>
                                                            </dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                    </dx:GridViewCommandColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="verba" Caption="Plano de Verbas" VisibleIndex="2">
                                                        <PropertiesComboBox DataSourceID="sqlModalida" TextField="MODSMODA" ValueField="MOIDMODA">
                                                            <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            var newValueOfComboBox = 'verba#'+s.GetValue();                                    
            gridVerbas.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="tipo" Caption="Tipo de Verba" EditFormSettings-Visible="False" ReadOnly="true" VisibleIndex="3">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="Contratada" Value="1" />
                                                                <dx:ListEditItem Text="Acessória" Value="0" />
                                                            </Items>
                                                        </PropertiesComboBox>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataTextColumn FieldName="valor_media" Caption="Valor de Referência" VisibleIndex="4" ReadOnly="True" EditFormSettings-Visible="False">
                                                        <PropertiesTextEdit DisplayFormatString="{0:N2}"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="valor_atual" Caption="Valor Atual" VisibleIndex="5">
                                                        <PropertiesTextEdit DisplayFormatString="{0:N2}"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>

                                                </Columns>
                                                <Templates>
                                                    <StatusBar>
                                                        <div style="text-align: left">
                                                            <br />
                                                            <dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridVerbas.UpdateEdit(); }">
                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                            </dx:ASPxButton>
                                                            <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridVerbas.CancelEdit(); }">
                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                            </dx:ASPxButton>
                                                            <dx:ASPxButton ID="btnNovaVerba" runat="server" AutoPostBack="false" CssClass="btn-using" Text="Nova Verba" ClientSideEvents-Click="function(s, e){ popupNovaVerba.Show(); }">
                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                            </dx:ASPxButton>
                                                        </div>
                                                    </StatusBar>
                                                </Templates>
                                                <Styles>
                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                    <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                                    </Header>
                                                    <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                    </Row>
                                                    <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                    <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                        <Paddings Padding="0px" />
                                                    </BatchEditCell>
                                                    <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                    <FocusedRow BackColor="#99bbbb"></FocusedRow>
                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                    <Table></Table>
                                                    <Cell Paddings-Padding="5px"></Cell>
                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                </Styles>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="sqlVerbasFluxo" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                SelectCommand="select z.verba,z.tipo,sum(z.valor_media) as valor_media,sum(z.valor_atual) as valor_atual from
(select f.moidmoda as verba,m.motipovalo as tipo, avg(valor) as valor_media, 0 as valor_atual from fluxo_oper_jesse f
inner join modalida m on m.MOIDMODA=f.moidmoda
where
(m.motipovalo=1 and data between dateadd(month,-1,?) and dateadd(month,-1,?)
and opidcont=? and f.valida=1)
and m.MOIDMODA not in (select fl.moidmoda from fluxo_oper_jesse fl where fl.data between ? and dateadd(month,1,?) and fl.opidcont=? and fl.valida=1)
and m.MOIDMODA not in (select vi.moidmoda from viopmoda vi where vi.OPIDCONT=? and vi.CHIDCODI is not null and vi.CJIDCODI is not null)
or
(m.motipovalo=0 and data between dateadd(month,-3,?) and dateadd(month,-1,?)
and opidcont=? and f.valida=1)
and m.MOIDMODA not in (select fl.moidmoda from fluxo_oper_jesse fl where fl.data between ? and dateadd(month,1,?) and fl.opidcont=? and fl.valida=1)
and m.MOIDMODA not in (select vi.moidmoda from viopmoda vi where vi.OPIDCONT=? and vi.CHIDCODI is not null and vi.CJIDCODI is not null)
group by f.moidmoda,m.motipovalo
union
select m.moidmoda as verba,m.motipovalo as tipo, 0 as valor_media, valor as valor_atual from fluxo_oper_jesse f
inner join modalida m on m.MOIDMODA=f.moidmoda
where data between ? and dateadd(month,1,?)
and opidcont=? and f.valida=0) as z
group by z.verba,z.tipo"
                                                InsertCommand="select * from fluxo_oper_jesse">
                                                <SelectParameters>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </asp:View>
                                        <asp:View ID="vw_auditoria" runat="server">
                                            <dx:ASPxGridView ID="gridAuditar" CssClass="bg-transparent" ClientInstanceName="gridAuditar" KeyFieldName="idseq" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                                DataSourceID="sqlAuditoria" OnCustomButtonCallback="gridAuditar_CustomButtonCallback" OnCustomButtonInitialize="gridAuditar_CustomButtonInitialize">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsText Title="Auditoria" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Settings VerticalScrollableHeight="594" />
                                                <SettingsBehavior AllowFocusedRow="true" />
                                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                                </SettingsPager>
                                                <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="true" />
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="valor" Caption="Valor" VisibleIndex="4" EditFormSettings-Visible="False">
                                                        <PropertiesTextEdit DisplayFormatString="{0:N2}"></PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="moidmoda" Caption="Verba" VisibleIndex="3">
                                                        <PropertiesComboBox DataSourceID="sqlModalida" TextField="MODSMODA" ValueField="MOIDMODA"></PropertiesComboBox>
                                                        <EditFormSettings Visible="False"></EditFormSettings>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewDataComboBoxColumn FieldName="valida" Caption="Status" VisibleIndex="5">
                                                        <PropertiesComboBox>
                                                            <Items>
                                                                <dx:ListEditItem Text="Pendente" Value="0"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="Aprovado" Value="1"></dx:ListEditItem>
                                                            </Items>
                                                        </PropertiesComboBox>
                                                        <EditFormSettings Visible="False"></EditFormSettings>
                                                    </dx:GridViewDataComboBoxColumn>
                                                    <dx:GridViewCommandColumn Caption="A&#231;&#227;o" VisibleIndex="0">
                                                        <CustomButtons>
                                                            <dx:GridViewCommandColumnCustomButton ID="aprovar" Text="Aprovar"></dx:GridViewCommandColumnCustomButton>
                                                            <dx:GridViewCommandColumnCustomButton ID="rejeitar" Text="Rejeitar"></dx:GridViewCommandColumnCustomButton>
                                                        </CustomButtons>
                                                    </dx:GridViewCommandColumn>
                                                    <dx:GridViewDataDateColumn FieldName="data_venc" Caption="Vencimento" VisibleIndex="2">
                                                        <PropertiesDateEdit DisplayFormatString="{0:d}"></PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataDateColumn FieldName="data" Caption="Compet&#234;ncia" VisibleIndex="1">
                                                        <PropertiesDateEdit DisplayFormatString="{0:d}"></PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                </Columns>
                                                <Templates>
                                                    <StatusBar>
                                                        <div style="text-align: left">
                                                            <br />
                                                            <dx:ASPxButton ID="btnSave" runat="server" Font-Size="12pt" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridAuditar.UpdateEdit(); }">
                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                            </dx:ASPxButton>
                                                            <dx:ASPxButton ID="btnCancel" runat="server" Font-Size="12pt" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridAuditar.CancelEdit(); }">
                                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                            </dx:ASPxButton>
                                                        </div>
                                                    </StatusBar>
                                                </Templates>
                                                <Styles>
                                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                    <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                                    </Header>
                                                    <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                    </Row>
                                                    <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                    <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                        <Paddings Padding="0px" />
                                                    </BatchEditCell>
                                                    <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                    <FocusedRow BackColor="#99bbbb"></FocusedRow>
                                                    <EditForm Paddings-Padding="0px"></EditForm>
                                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                    <Table></Table>
                                                    <Cell Paddings-Padding="5px"></Cell>
                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                </Styles>
                                            </dx:ASPxGridView>
                                            <asp:SqlDataSource runat="server" ID="sqlAuditoria" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' 
                                                SelectCommand="select convert(date,data) as data,convert(date,data_venc) as data_venc,moidmoda,valor,valida,idseq from fluxo_oper_jesse
where data between ? and dateadd(month,1,?)
  and opidcont=?">
                                                <SelectParameters>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                    <asp:Parameter Name="?"></asp:Parameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </asp:View>
                                    </asp:MultiView>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="sqlModalida" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select m.MODSMODA,m.MOIDMODA from modalida m
inner join VIOPMODA vi on m.MOIDMODA=vi.MOIDMODA
where MOTPIDCA=10
and vi.opidcont=?">
        <SelectParameters>
            <asp:Parameter Name="?"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <dx:ASPxPopupControl ID="popupNovaVerba" ClientInstanceName="popupNovaVerba" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Cadastro Nova Verba" Modal="true" Width="500px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12 p-0">
                            <asp:Label ID="Label13" Font-Size="12pt" runat="server" Text="A Verba será associada ao contrato Número Processo: " CssClass="labels text-left"></asp:Label>
                            <asp:Label ID="lblOPIDCONTVerba" Font-Size="12pt" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="lblCpf" runat="server" Text="Descrição" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqDesc" ControlToValidate="txtDesc" ValidationGroup="NovaVerba" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="reqDesc2" ControlToValidate="txtDesc" runat="server" ValidationGroup="NovaVerba" ErrorMessage="Nome já existe" ForeColor="Red" Display="Dynamic" OnServerValidate="reqDesc2_ServerValidate"></asp:CustomValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <asp:TextBox ID="txtDesc" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="lblDesc" runat="server" Text="Calcula IFRS?" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqIFRS" InitialValue="-1" ValidationGroup="NovaVerba" ControlToValidate="dropIFRS" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropIFRS" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Items>
                                        <dx:ListEditItem Text="Selecione" Value="-1" Selected="true" />
                                        <dx:ListEditItem Text="Sim" Value="1" />
                                        <dx:ListEditItem Text="Não" Value="0" />
                                    </Items>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label4" runat="server" Text="Classificador" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="NovaVerba" ControlToValidate="dropClass" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropClass" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlClassificador"
                                    ValueField="LAYIDCLA" TextField="LAYNMCLA">
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                </dx:ASPxComboBox>
                                <asp:SqlDataSource runat="server" ID="sqlClassificador" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT LAYIDCLA ,LAYNMCLA FROM LAYPDFCL where LAYIDENT=0"></asp:SqlDataSource>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label6" runat="server" Text="Tipo Receita" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="NovaVerba" ControlToValidate="dropTipo" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropTipo" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    <Items>
                                        <dx:ListEditItem Text="Contratado" Value="1" />
                                        <dx:ListEditItem Text="Acessória" Value="0" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label10" runat="server" Text="Periodicidade" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="NovaVerba" ControlToValidate="dropTempo" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropTempo" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    <Items>
                                        <dx:ListEditItem Text="Permanente" Value="1" />
                                        <dx:ListEditItem Text="Eventual" Value="0" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label11" runat="server" Text="Recuperação de Impostos" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="NovaVerba" ControlToValidate="dropRecupera" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropRecupera" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    <Items>
                                        <dx:ListEditItem Text="Sim" Value="1" />
                                        <dx:ListEditItem Text="Não" Value="0" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label12" runat="server" Text="Intervalo" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ValidationGroup="NovaVerba" ControlToValidate="dropPeriodi" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropPeriodi" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    <Items>
                                        <dx:ListEditItem Text="Mensal" Value="M" />
                                        <dx:ListEditItem Text="Bimestral" Value="B" />
                                        <dx:ListEditItem Text="Trimestral" Value="T" />
                                        <dx:ListEditItem Text="Quadrimestral" Value="Q" />
                                        <dx:ListEditItem Text="Semestral" Value="s" />
                                        <dx:ListEditItem Text="Anual" Value="A" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <br />
                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                <asp:TextBox ID="TextBox4" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x1">
                            <dx:ASPxButton ID="btnNovaVerba" runat="server" ValidationGroup="NovaVerba" CssClass="btn-using" Text="Gravar" OnClick="Button1_Click">
                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                            </dx:ASPxButton>
                        </div>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupFluxoComplemento" ClientInstanceName="popupFluxoComplemento" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Faturamento" Modal="true" Width="500px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxGridView ID="gridFaturamento" Width="500px" runat="server" Theme="Material" AutoGenerateColumns="False" DataSourceID="sqlFaturamento">
                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                    <Settings ShowFooter="true" VerticalScrollableHeight="315" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                    <Images>
                        <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                    </Images>
                    <SettingsCommandButton>
                        <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="15px">
                            <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="15px">
                            </Image>
                        </NewButton>
                        <DeleteButton Image-ToolTip="Delete" Image-Url="img/icons8-delete-bin-32.png" Image-Width="15px">
                            <Image ToolTip="Delete" Url="img/icons8-delete-bin-32.png" Width="15px">
                            </Image>
                        </DeleteButton>
                        <RecoverButton Image-ToolTip="Cancel" Image-Url="img/icons8-recyle-32.png" Image-Width="15px">
                            <Image ToolTip="Cancel" Url="img/icons8-recyle-32.png" Width="15px">
                            </Image>
                        </RecoverButton>
                    </SettingsCommandButton>
                    <Columns>
                        <dx:GridViewDataDateColumn FieldName="FLDTAFLX" Caption="Data" VisibleIndex="0">
                            <PropertiesDateEdit DisplayFormatString="d"></PropertiesDateEdit>
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="FLVALBRT" ShowInCustomizationForm="True" Caption="Valor Bruto" VisibleIndex="1">
                            <PropertiesTextEdit DisplayFormatString="n2"></PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="FLVALLIQ" ShowInCustomizationForm="True" Caption="Valor L&#237;quido" VisibleIndex="2">
                            <PropertiesTextEdit DisplayFormatString="n2"></PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    <TotalSummary>
                        <dx:ASPxSummaryItem DisplayFormat="n2" FieldName="FLVALBRT" SummaryType="Sum" />
                        <dx:ASPxSummaryItem DisplayFormat="n2" FieldName="FLVALLIQ" SummaryType="Sum" />
                    </TotalSummary>
                    <Styles>
                        <Footer Paddings-PaddingTop="3px" Paddings-PaddingBottom="3px"></Footer>
                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                        <Header Font-Names="Arial" Font-Size="12pt" ForeColor="White" BackColor="#669999" Paddings-Padding="3px">
                        </Header>
                        <Row Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                        </Row>
                        <AlternatingRow Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                        <BatchEditCell Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                            <Paddings Padding="0px" />
                        </BatchEditCell>
                        <FocusedRow BackColor="#669999" ForeColor="White"></FocusedRow>
                        <FocusedCell Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                        <EditForm Paddings-Padding="0px"></EditForm>
                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                        <Table></Table>
                        <Cell Wrap="False" Paddings-Padding="5px"></Cell>
                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                    </Styles>
                    <StylesPager CurrentPageNumber-BackColor="#669999"></StylesPager>
                </dx:ASPxGridView>
                <asp:SqlDataSource runat="server" ID="sqlFaturamento" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select convert(datetime,FLDTAFLX) AS FLDTAFLX,FLVALBRT,FLVALLIQ from FLDIAFLX where opidcont=?
and FLDTAFLX &gt;= ?
and FLDTAFLX &lt;= ?">
                    <SelectParameters>
                        <asp:Parameter Name="?"></asp:Parameter>
                        <asp:Parameter Name="?"></asp:Parameter>
                        <asp:Parameter Name="?"></asp:Parameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />

    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" onmouseout="QuickGuide('ini');" Text="<%$ Resources:DadosVerba, dadosverba_tituloRight %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" UpdateMode="Conditional" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hfIndexGridOper" runat="server" />
                <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
                <div class="row mt-3" style="margin: 0 auto">
                    <h6>
                        <asp:Label ID="Label9" runat="server" Text="<%$ Resources:Indice, indexador_right_titulo2 %>" CssClass="labels text-left"></asp:Label></h6>
                    <div class="input-group mb-auto drop-down-div">
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT B.TVIDESTR, B.TVDSESTR, B.TVCDPAIE, B.TVNVESTR,
                                   A.FOCDXCGC, A.FOCDLICE
                            FROM TVESTRUT B, FOFORNEC A
                            WHERE B.TVIDESTR = A.TVIDESTR
                            AND A.FOTPIDTP = 6
                            AND A.FOCDLICE IS NOT NULL
                            AND B.TVIDESTR IN(SELECT DISTINCT TVIDESTR 
                                               FROM VIFSFUSU 
                                               WHERE USIDUSUA = ?)
ORDER BY B.TVNVESTR, B.TVCDPAIE, B.TVIDESTR">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <dx:ASPxCallbackPanel ID="ASPxCallbackPanel1" runat="server" Width="350px">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass="dropDownEdit text-left" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                        Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
                                        <ClientSideEvents
                                            Init="UpdateSelection"
                                            DropDown="OnDropDown" />
                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                        </ButtonStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        <DropDownWindowTemplate>
                                            <div>
                                                <dx:ASPxTreeList ID="TreeList" CssClass="text-left" DataSourceID="SqlDataSource1" ClientInstanceName="TreeList" runat="server"
                                                    Width="350px" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                                    KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE">
                                                    <Settings VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                                    <ClientSideEvents FocusedNodeChanged="function(s,e){ selectButton.SetEnabled(true); }" />
                                                    <BorderBottom BorderStyle="Solid" />
                                                    <SettingsBehavior AllowFocusedNode="true" AutoExpandAllNodes="false" FocusNodeOnLoad="false" />
                                                    <SettingsPager Mode="ShowAllNodes">
                                                    </SettingsPager>
                                                    <Styles>
                                                        <SelectedNode BackColor="#669999"></SelectedNode>
                                                        <FocusedNode BackColor="#669999"></FocusedNode>
                                                        <Node Cursor="pointer">
                                                        </Node>
                                                        <Indent Cursor="default">
                                                        </Indent>
                                                    </Styles>
                                                    <Columns>
                                                        <dx:TreeListTextColumn FieldName="TVDSESTR" Caption="Descrição" AutoFilterCondition="Default" ShowInFilterControl="Default" VisibleIndex="0"></dx:TreeListTextColumn>
                                                    </Columns>
                                                </dx:ASPxTreeList>
                                            </div>
                                            <table style="background-color: White; width: 100%;">
                                                <tr>
                                                    <td style="padding: 10px;">
                                                        <dx:ASPxButton ID="clearButton" ClientEnabled="false" Theme="Material" ClientInstanceName="clearButton"
                                                            runat="server" AutoPostBack="false" Text="Clear" BackColor="#669999">
                                                            <ClientSideEvents Click="ClearSelection" />
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <DisabledStyle BackColor="White"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                    </td>
                                                    <td style="text-align: right; padding: 10px;">
                                                        <dx:ASPxButton ID="selectButton" ClientEnabled="false" Theme="Material" ClientInstanceName="selectButton"
                                                            runat="server" AutoPostBack="false" Text="Select" BackColor="#669999">
                                                            <ClientSideEvents Click=" function(s,e) {
                                                            UpdateSelection();
                                                            if (document.getElementById('hfDropEstr').value != '') {
                                                                document.getElementById('btnSelEmp').click();
                                                            }
                                                            } " />
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <DisabledStyle BackColor="White"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                        <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" Text="Close" BackColor="#669999">
                                                            <ClientSideEvents Click="function(s,e) { DropDownEdit.HideDropDown(); }" />
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <DisabledStyle BackColor="White"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </DropDownWindowTemplate>
                                    </dx:ASPxDropDownEdit>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </div>
                </div>
                <div class="row" style="margin: 0 auto">
                    <asp:Label ID="Label30" runat="server" Text="<%$ Resources:GlobalResource, aquisição_right_titulo %>" CssClass="labels mb-0 text-left"></asp:Label>
                    <div class="input-group mb-0">
                        <asp:Button ID="btnselecionar" CausesValidation="false" ClientIDMode="Static" runat="server" CssClass="d-none" OnClick="btnselecionar_Click" Text="<%$Resources:GlobalResource, btn_selecionar %>" />
                        <dx:ASPxDropDownEdit ID="ddePesqContrato" Enabled="false" ClientInstanceName="ddePesqContrato" ClientIDMode="Static" Width="100%" runat="server" Theme="Material" AllowUserInput="false">
                            <ClientSideEvents CloseUp="function(s, e) {  
                                s.ShowDropDown();
                                }" />
                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                <HoverStyle BackColor="#669999"></HoverStyle>
                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                            </ButtonStyle>
                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                            <DropDownWindowTemplate>
                                <div class="container-fluid p-0">
                                    <asp:SqlDataSource ID="sqlProcessos" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                        SelectCommand="SELECT OP.OPCDCONT, TV.TVDSESTR, PR.PRPRODES, OP.OPVLCONT,OP.PRPRODID,OP.OPIDCONT 
FROM OPCONTRA OP 
INNER JOIN PRPRODUT PR   ON(OP.PRPRODID = PR.PRPRODID) 
INNER JOIN TVESTRUT TV   ON(OP.TVIDESTR = TV.TVIDESTR) 
AND PR.CMTPIDCM NOT IN(2, 4, 5) 
AND OP.OPIDAACC IS NULL 
AND OP.PRTPIDOP NOT IN(5) 
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?)
UNION 
SELECT OP.OPCDCONT, TV.TVDSESTR, PR.PRPRODES, OP.OPVLCONT,OP.PRPRODID,OP.OPIDCONT 
FROM OPCONTRA OP 
INNER JOIN PRPRODUT PR  ON(OP.PRPRODID = PR.PRPRODID) 
INNER JOIN TVESTRUT TV  ON(OP.TVIDESTR = TV.TVIDESTR) 
AND PR.CMTPIDCM NOT IN(2, 4, 5) 
AND OP.PRTPIDOP IN(5) 
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?)
ORDER BY OPIDCONT DESC">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <div class="row" style="display: none">
                                        <div class="col-12 text-right">
                                        </div>
                                    </div>
                                    <div class="row m-1">

                                        <dx:ASPxGridView ID="ASPxGridView1" ClientIDMode="Static" Width="990px" ClientInstanceName="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="sqlProcessos" Theme="Material">
                                            <ClientSideEvents RowDblClick="function(s, e) {                                            
                                                ddePesqContrato.HideDropDown();
                                                document.getElementById('btnselecionar').click();
                                            }" />
                                            <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" ShowFilterRow="True" />
                                            <SettingsPager Visible="false"></SettingsPager>
                                            <SettingsBehavior AllowFocusedRow="True" />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <Columns>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:GlobalResource, aquisição_right_grid_col1 %>" Width="70px" MaxWidth="70" FieldName="OPCDCONT" VisibleIndex="0">
                                                    <PropertiesComboBox DataSourceID="sqlProcessos" ValueField="OPCDCONT" TextField="OPCDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                    <Settings AllowAutoFilter="True" />
                                                    <EditFormSettings VisibleIndex="0" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:GlobalResource, aquisição_right_grid_col2 %>" Width="170px" MaxWidth="170" FieldName="TVDSESTR" VisibleIndex="1">
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlProcessos" TextField="TVDSESTR" ValueField="TVDSESTR" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="1" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:GlobalResource, aquisição_right_grid_col3 %>" Width="120px" MaxWidth="120" FieldName="PRPRODES" VisibleIndex="2">
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODES" ValueField="PRPRODES" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="2" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:GlobalResource, aquisição_right_grid_col5 %>' Width="50px" MaxWidth="50" FieldName="PRPRODID" VisibleIndex="5">
                                                    <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID"></PropertiesComboBox>
                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="3" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:GlobalResource, aquisição_right_grid_col6 %>' Width="60px" MaxWidth="60" FieldName="OPIDCONT" VisibleIndex="6">
                                                    <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT"></PropertiesComboBox>

                                                    <Settings AllowAutoFilter="True" />
                                                    <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                                    </PropertiesComboBox>
                                                    <EditFormSettings VisibleIndex="4" />
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataTextColumn FieldName="OPVLCONT" MaxWidth="60" Width="60px" Caption="<%$ Resources:GlobalResource, aquisição_right_grid_col4 %>" VisibleIndex="4">
                                                    <PropertiesTextEdit DisplayFormatString="N2">
                                                        <MaskSettings Mask="&lt;0..99999g&gt;.&lt;00..99&gt;"></MaskSettings>
                                                    </PropertiesTextEdit>
                                                    <Settings AllowAutoFilter="True"></Settings>
                                                    <EditFormSettings VisibleIndex="5"></EditFormSettings>
                                                </dx:GridViewDataTextColumn>

                                            </Columns>
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
                                                <FocusedRow BackColor="#669999" ForeColor="White"></FocusedRow>
                                                <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                <EditForm Paddings-Padding="0px"></EditForm>
                                                <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                <Table></Table>
                                                <Cell Wrap="False" Paddings-Padding="5px"></Cell>
                                                <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                            </Styles>
                                        </dx:ASPxGridView>

                                    </div>
                                </div>

                            </DropDownWindowTemplate>
                        </dx:ASPxDropDownEdit>
                    </div>
                </div>
                <div class="row" style="margin: 0 auto">
                    <asp:Label ID="Label2" runat="server" Text="Competência" CssClass="labels text-left mb-0"></asp:Label>
                    <div class="input-group mb-0">
                        <dx:ASPxDateEdit ID="txtCompet" Enabled="false" ForeColor="dimgray" AutoPostBack="true" OnValueChanged="txtCompet_ValueChanged" Theme="Material" Width="100%" runat="server" PickerType="Months">
                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                <HoverStyle BackColor="#669999"></HoverStyle>
                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                            </ButtonStyle>
                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                            <CalendarProperties>
                                <HeaderStyle BackColor="#669999" />
                                <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                            </CalendarProperties>
                        </dx:ASPxDateEdit>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="txtCompet" />
                <asp:PostBackTrigger ControlID="btnselecionar" />
                <asp:AsyncPostBackTrigger ControlID="btnSelEmp" />
            </Triggers>
        </asp:UpdatePanel>
        <div class="row mt-3" style="margin: 0 auto;">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnAuditar" Enabled="false" runat="server" CssClass="Loading btn-using" Text="Auditoria" OnClick="btnAuditar_Click" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;">
                <asp:Button ID="btnEntrada" Enabled="false" runat="server" CssClass="Loading btn-using" Text="Data Entry" OnClick="btnEntrada_Click" />
            </div>
        </div>
        <%--       <div class="row" style="margin: 0 auto; margin-top: 3px">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="Loading btn-using" Text="<%$Resources:GlobalResource, btn_excluir %>" />
            </div>
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:TextBox ID="TextBox10" CssClass="btn-using field_empty" Enabled="false" runat="server"></asp:TextBox>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 3px">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnOK" Enabled="false" runat="server" CssClass="Loading btn-using ok" Text="<%$Resources:GlobalResource, btn_ok %>" />
            </div>
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="Loading btn-using cancelar" Text="<%$Resources:GlobalResource, btn_cancelar %>" CausesValidation="False" />
            </div>
        </div>--%>
    </div>
</asp:Content>
