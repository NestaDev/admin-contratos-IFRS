<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Indice.aspx.cs" Inherits="WebNesta_IRFS_16.Indice1" %>
<%@ Register Assembly="DevExpress.XtraCharts.v20.1.Web, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts.Web" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<%@ Register TagPrefix="dx" Namespace="DevExpress.XtraCharts" Assembly="DevExpress.XtraCharts.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            height: 33px;
        }
    </style>
    <script type="text/javascript">
        function onBatchEditStartEditing(s, e) {
            var editor = s.GetEditor("CVDTCOIE");
            editor.SetReadOnly(e.visibleIndex == 0);
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
            btnInserir.SetEnabled(document.getElementById('hfDropEstr').value != "");
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
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'Descrição':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_descrição%>';
                    break;
                case 'Sigla':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_sigla%>';
                    break;
                case 'Rótulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_rotulo%>';
                    break;
                case 'Tipo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_tipo%>';
                    break;
                case 'Frequência':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_freq%>';
                    break;
                case 'Detalhes':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_detalhes%>';
                    break;
                case 'Cotação':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_cotacao%>';
                    break;
                case 'Selecione':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_selecione%>';
                    break;
                case 'Modelo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_modelo%>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.quickguide_inicial %>';
                    break;
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_titulo%>';
                    break;
                case 'acao':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_acao%>';
                    break;
                case 'pesquisa':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Indice.indice_pesquisa%>';
                    break;
                case 'inserir':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_inserir_qg %>';
                    break;
                case 'excluir':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_excluir_qg %>';
                    break;
                case 'ok':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_ok_qg %>';
                    break;
                case 'cancelar':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_cancelar_qg %>';
                    break;
                case 'alterar':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.btn_alterar_qg %>';
                    break;
            }

        }
    </script>

    <asp:HiddenField ID="hfTituloPag" Value="Indexadores" runat="server" />
    <div class="container-fluid">
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
                                    <label id="lblquickGuide"><%=Resources.GlobalResource.quickguide_inicial %></label>
                                </div>
                                <div class="card-footer bg-transparent quickGuide-footer">
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Indice, indice_content_tutorial %>" />
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
            <div class="col-sm-6 pl-4 pr-0">
                <asp:HiddenField ID="hfMsgException" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_exception %>" />
                <asp:HiddenField ID="hfMsgSuccess" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_success %>" />
                <asp:HiddenField ID="hfCodIndice" runat="server" />
                <asp:HiddenField ID="hfOperacao" runat="server" />
                <asp:SqlDataSource ID="sqlCombos" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                    SelectCommand="SELECT IEIDINEC, IESGBCAS, IENMINEC FROM IEINDECO WHERE IETPINDC = 'U'"></asp:SqlDataSource>
                <div class="card w-100 bg-transparent">
                    <div class="card-header bg-transparent">
                        <h5>
                            <asp:Label ID="Label5" runat="server" onmouseover="QuickGuide('titulo');" onmouseout="QuickGuide('ini');" Text="<%$ Resources:Indice, indexador_tituloPag %>" onclick="QuickGuide('Detalhes');"></asp:Label></h5>
                    </div>
                    <div class="card-body bg-transparent">
                        <div class="row mb-1">
                            <div class="p-0 col-x2">
                                <asp:Label ID="Label10" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_modelo %>"></asp:Label>
                                <div class="input-group mb-auto" onmouseover="QuickGuide('Modelo');" onmouseout="QuickGuide('ini');">
                                    <dx:ASPxComboBox ID="dropModelo" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        </ButtonStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        <Items>
                                            <dx:ListEditItem Text="Global" Value="0" />
                                            <dx:ListEditItem Text="Local" Value="1" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="p-0 col-x2">
                                <asp:Label ID="Label2" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_lbl1 %>" onclick="QuickGuide('Descrição');"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqDescri" Enabled="false" ControlToValidate="txtDescri" ForeColor="Red" runat="server" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto" onmouseover="QuickGuide('Descrição');">
                                    <asp:TextBox ID="txtDescri" MaxLength="30" Width="100%" runat="server" Enabled="false" CssClass="text-boxes"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-1">
                            <div class="p-0 col-x2">
                                <asp:Label ID="Label6" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_lbl4 %>"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqTipoIndic" Enabled="false" InitialValue="0" ControlToValidate="dropTipoIndic" runat="server" ForeColor="Red" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('Tipo');">
                                    <dx:ASPxComboBox ID="dropTipoIndic" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" AutoPostBack="true" OnSelectedIndexChanged="dropTipoIndic_SelectedIndexChanged1" Theme="Material" Width="100%">
                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        </ButtonStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        <Items>
                                            <dx:ListEditItem Text="  " Value="0" Selected="true" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo1_item1 %>" Value="T" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo1_item2 %>" Value="I" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo1_item3 %>" Value="M" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo1_item4 %>" Value="F" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo1_item5 %>" Value="P" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo1_item6 %>" Value="C" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="p-0 col-x2">
                                <asp:Label ID="Label7" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_lbl5 %>"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqFreqIndic" Enabled="false" InitialValue="0" ControlToValidate="dropFreqIndic" runat="server" ForeColor="Red" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('Frequência');">
                                    <dx:ASPxComboBox ID="dropFreqIndic" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        </ButtonStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        <Items>
                                            <dx:ListEditItem Text="  " Value="0" Selected="true" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo2_item1 %>" Value="D" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_combo2_item2 %>" Value="M" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                        </div>
                        <div class="row mb-1">
                            <div class="p-0 col-x1">
                                <asp:Label ID="Label1" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_lbl2 %>"></asp:Label>
                                <asp:RequiredFieldValidator ID="reqSig" Enabled="false" ControlToValidate="txtSig" ForeColor="Red" runat="server" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                <div class="input-group mb-auto" onmouseover="QuickGuide('Sigla');">
                                    <asp:TextBox ID="txtSig" MaxLength="20" Width="100%" runat="server" Enabled="false" CssClass="text-boxes"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class=" p-0 col-x1">
                                <asp:Label ID="Label3" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_lbl3 %>"></asp:Label>
                                <div class="input-group mb-auto" onmouseover="QuickGuide('Rótulo');">
                                    <asp:TextBox ID="txtRot" MaxLength="10" Width="100%" runat="server" Enabled="false" CssClass="text-boxes"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="p-0 col-x1">
                                <asp:Label ID="Label11" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_lbl6 %>"></asp:Label>
                                <div class="input-group mb-auto" style="margin-top: 1px">
                                    <dx:ASPxComboBox ID="dropValor" ForeColor="dimgray" AllowInputUser="false" ValueType="System.String" Enabled="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        </ButtonStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        <Items>
                                            <dx:ListEditItem Text="  " Value="" Selected="true" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_lbl6.1 %>" Value="0" />
                                            <dx:ListEditItem Text="<%$ Resources:Indice, indexador_lbl6.2 %>" Value="1" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                            <div class="col-x0"></div>
                            <div class="p-0 col-x1">
                                <asp:Label ID="Label12" runat="server" CssClass="labels text-left" Text="<%$ Resources:Indice, indexador_lbl7 %>"></asp:Label>
                                <div class="input-group mb-auto" style="margin-top: 1px">
                                    <asp:TextBox ID="txtFeeder" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-1">
                            <dx:WebChartControl ID="chartCotacao" runat="server"
                                ClientInstanceName="chartCotacao"
                                ToolTipEnabled="False" CrosshairEnabled="True" RenderFormat="Svg" AppearanceNameSerializable="Chameleon"
                                BackColor="Transparent" Width="480px" Height="240px" PaletteName="Chameleon">
                                <DiagramSerializable>
                                    <dx:XYDiagram>
                                        <AxisX Interlaced="True" VisibleInPanesSerializable="-1">
                                            <WholeRange />
                                            <GridLines Visible="True"></GridLines>
                                            <Label>
                                            </Label>
                                        </AxisX>
                                        <AxisY Title-Visibility="False" VisibleInPanesSerializable="-1">
                                            <WholeRange AlwaysShowZeroLevel="False" />
                                            <Label>
                                            </Label>
                                        </AxisY>
                                    </dx:XYDiagram>
                                </DiagramSerializable>
                                <BorderOptions Visibility="False" />
                                <Legend Visibility="False"></Legend>
                            </dx:WebChartControl>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-4 pl-4 pr-0">
                <div class="card w-100 bg-transparent">
                    <div class="card-header bg-transparent">
                        <div class="row">
                            <h5>
                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Indice, indexador_titulo2 %>"></asp:Label></h5>
                            <dx:ASPxCheckBox ID="ASPxCheckBox1" ClientEnabled="false" runat="server" CssClass="ml-3 labels" Font-Size="12pt" Text="<%$ Resources:Indice, indexador_titulo2-1 %>" AutoPostBack="true" OnCheckedChanged="ASPxCheckBox1_CheckedChanged" OnLoad="ASPxCheckBox1_Load"></dx:ASPxCheckBox>
                        </div>
                    </div>
                    <div class="card-body bg-transparent pl-0 pt-2" style="margin: 0 auto" onmouseover="QuickGuide('Cotação');">
                        <asp:MultiView ID="multiviewCotacoes" runat="server">
                            <asp:View ID="vw_oficial" runat="server">
                                <dx:ASPxGridView ID="gridCotacao" ClientInstanceName="gridCotacao" CssClass="gridFiltro bg-transparent" Theme="Material" runat="server" KeyFieldName="CVDTCOIE" EnableRowsCache="False" AutoGenerateColumns="False" DataSourceID="sqlCotacao" OnBatchUpdate="gridCotacao_BatchUpdate" SettingsPager-Visible="False">
                                    <SettingsPopup>
                                        <FilterControl HorizontalAlign="WindowCenter"></FilterControl>
                                        <CustomizationWindow HorizontalAlign="WindowCenter" />
                                        <EditForm HorizontalAlign="WindowCenter"></EditForm>
                                        <HeaderFilter Height="200">

                                            <SettingsAdaptivity Mode="OnWindowInnerWidth" HorizontalAlign="WindowCenter" SwitchAtWindowInnerWidth="768" MinHeight="300" />
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <Settings VerticalScrollableHeight="100" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" ShowFilterRow="false" ShowHeaderFilterButton="true" />
                                    <Images>
                                        <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                    </Images>
                                    <SettingsEditing Mode="Batch"></SettingsEditing>
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
                                        <dx:GridViewCommandColumn ShowDeleteButton="false" ButtonRenderMode="Image" ShowNewButtonInHeader="True" Width="30px" VisibleIndex="0"></dx:GridViewCommandColumn>
                                        <dx:GridViewDataDateColumn Caption="<%$ Resources:Indice, indexador_grid_col1 %>" FieldName="CVDTCOIE" Width="100px" Name="CVDTCOIE" VisibleIndex="1">
                                            <DataItemTemplate>
                                                <div style="width: 120px; overflow: hidden"><%#Container.Text%></div>
                                            </DataItemTemplate>
                                            <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                    <MonthGridPaddings Padding="0px" />
                                                    <DayStyle Font-Size="11pt" Paddings-Padding="0px" />

                                                </CalendarProperties>
                                                <ValidationSettings Display="Dynamic">
                                                </ValidationSettings>
                                            </PropertiesDateEdit>
                                        </dx:GridViewDataDateColumn>
                                        <dx:GridViewDataTextColumn Caption="<%$ Resources:Indice, indexador_grid_col2 %>" FieldName="CVVLCOID" Width="100px" Name="CVVLCOID" VisibleIndex="2">
                                            <DataItemTemplate>
                                                <div style="width: 100px; overflow: hidden"><%#Container.Text%></div>
                                            </DataItemTemplate>
                                            <PropertiesTextEdit DisplayFormatString="0.0000">
                                                <ValidationSettings Display="Dynamic" RequiredField-IsRequired="true">
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <Templates>
                                        <StatusBar>
                                            <div style="text-align: left">
                                                <br />
                                                <dx:ASPxButton ID="btnSave" runat="server" CssClass="btn-using" AutoPostBack="false" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridCotacao.UpdateEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="btnCancel" runat="server" CssClass="btn-using" AutoPostBack="false" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridCotacao.CancelEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </div>
                                        </StatusBar>
                                    </Templates>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Settings VerticalScrollableHeight="280" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" />
                                    <ClientSideEvents BatchEditStartEditing="onBatchEditStartEditing" />
                                    <StylesFilterControl ActiveTab-HorizontalAlign="Left"></StylesFilterControl>
                                    <StylesPager>
                                        <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                    </StylesPager>
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
                                <asp:SqlDataSource ID="sqlCotacao" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                    SelectCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID
                                                FROM CVCOTIEC
                                                WHERE IEIDINEC = ? and cvflplan=0
                                                ORDER BY CVDTCOIE DESC"
                                    UpdateCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID FROM CVCOTIEC"
                                    InsertCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID FROM CVCOTIEC"
                                    DeleteCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID FROM CVCOTIEC">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfCodIndice" Name="IEIDINEC" PropertyName="Value" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </asp:View>
                            <asp:View ID="vw_previsao" runat="server">
                                <dx:ASPxGridView ID="gridCotacaoPrevisao" ClientInstanceName="gridCotacaoPrevisao" CssClass="gridFiltro bg-transparent" Theme="Material" runat="server" KeyFieldName="CVDTCOIE" EnableRowsCache="False" AutoGenerateColumns="False" DataSourceID="sqlCotacaoPrevisao" OnBatchUpdate="gridCotacaoPrevisao_BatchUpdate" SettingsPager-Visible="False">
                                    <SettingsPopup>
                                        <FilterControl HorizontalAlign="WindowCenter"></FilterControl>
                                        <CustomizationWindow HorizontalAlign="WindowCenter" />
                                        <EditForm HorizontalAlign="WindowCenter"></EditForm>
                                        <HeaderFilter Height="200">

                                            <SettingsAdaptivity Mode="OnWindowInnerWidth" HorizontalAlign="WindowCenter" SwitchAtWindowInnerWidth="768" MinHeight="300" />
                                        </HeaderFilter>
                                    </SettingsPopup>
                                    <Settings VerticalScrollableHeight="100" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" ShowFilterRow="false" ShowHeaderFilterButton="true" />
                                    <Images>
                                        <HeaderFilter Url="icons/icons8-filter-20.png" Width="20px"></HeaderFilter>
                                    </Images>
                                    <SettingsEditing Mode="Batch"></SettingsEditing>
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
                                        <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonRenderMode="Image" ShowNewButtonInHeader="True" Width="30px" VisibleIndex="0"></dx:GridViewCommandColumn>
                                        <dx:GridViewDataDateColumn Caption="<%$ Resources:Indice, indexador_grid_col1 %>" FieldName="CVDTCOIE" Width="100px" Name="CVDTCOIE" VisibleIndex="1">
                                            <DataItemTemplate>
                                                <div style="width: 120px; overflow: hidden"><%#Container.Text%></div>
                                            </DataItemTemplate>
                                            <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                    <MonthGridPaddings Padding="0px" />
                                                    <DayStyle Font-Size="11pt" Paddings-Padding="0px" />

                                                </CalendarProperties>
                                                <ValidationSettings Display="Dynamic">
                                                </ValidationSettings>
                                            </PropertiesDateEdit>
                                        </dx:GridViewDataDateColumn>
                                        <dx:GridViewDataTextColumn Caption="<%$ Resources:Indice, indexador_grid_col2 %>" FieldName="CVVLCOID" Width="80px" Name="CVVLCOID" VisibleIndex="2">
                                            <DataItemTemplate>
                                                <div style="width: 100px; overflow: hidden"><%#Container.Text%></div>
                                            </DataItemTemplate>
                                            <PropertiesTextEdit DisplayFormatInEditMode="true" DisplayFormatString="0.0000" NullDisplayText="0">
                                            </PropertiesTextEdit>
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <Templates>
                                        <StatusBar>
                                            <div style="text-align: left">
                                                <br />
                                                <dx:ASPxButton ID="btnSave" runat="server" CssClass="btn-using" AutoPostBack="false" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridCotacaoPrevisao.UpdateEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="btnCancel" runat="server" CssClass="btn-using" AutoPostBack="false" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridCotacaoPrevisao.CancelEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </div>
                                        </StatusBar>
                                    </Templates>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Settings VerticalScrollableHeight="280" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" />
                                    <ClientSideEvents BatchEditStartEditing="onBatchEditStartEditing" />
                                    <StylesFilterControl ActiveTab-HorizontalAlign="Left"></StylesFilterControl>
                                    <StylesPager>
                                        <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                    </StylesPager>
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
                                <asp:SqlDataSource ID="sqlCotacaoPrevisao" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                                    SelectCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID
                                                FROM CVCOTIEC
                                                WHERE IEIDINEC = ? and cvflplan=1
                                                ORDER BY CVDTCOIE DESC"
                                    UpdateCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID FROM CVCOTIEC"
                                    InsertCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID FROM CVCOTIEC"
                                    DeleteCommand="SELECT IEIDINEC,CVDTCOIE, CVVLCOID FROM CVCOTIEC">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfCodIndice" Name="IEIDINEC" PropertyName="Value" Type="Int32" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </asp:View>
                        </asp:MultiView>


                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
    <div class="container p-0" style="display: block">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" onmouseover="QuickGuide('acao');" Text="<%$ Resources:Indice, indexador_right_titulo1 %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
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
                                            <Settings ShowHeaderFilterButton="true" VerticalScrollBarMode="Auto" ScrollableHeight="150" />
                                            <ClientSideEvents FocusedNodeChanged="function(s,e){ selectButton.SetEnabled(true); }" />
                                            <BorderBottom BorderStyle="Solid" />
                                            <SettingsBehavior AllowFocusedNode="true" AutoExpandAllNodes="false" FocusNodeOnLoad="false" />
                                            <SettingsPager Mode="ShowAllNodes">
                                            </SettingsPager>
                                            <Images>
                                                <ExpandedButton Url="icons/icons8-seta-para-recolher-30.png" Width="25px"></ExpandedButton>
                                                <CollapsedButton Url="icons/icons8-seta-para-expandir-30.png" Width="25px"></CollapsedButton>
                                            </Images>
                                            <Styles>
                                                <SelectedNode BackColor="#669999"></SelectedNode>
                                                <FocusedNode BackColor="#669999"></FocusedNode>
                                                <Header Paddings-PaddingBottom="4px" Paddings-PaddingTop="4px"></Header>
                                                <Node Cursor="pointer">
                                                </Node>
                                                <Indent Cursor="default">
                                                </Indent>
                                            </Styles>
                                            <Columns>
                                                <dx:TreeListTextColumn FieldName="TVDSESTR" Caption="<%$ Resources:GlobalResource, geral_selecione_loja_header %>" AutoFilterCondition="Default" ShowInFilterControl="Default" VisibleIndex="0"></dx:TreeListTextColumn>
                                            </Columns>
                                        </dx:ASPxTreeList>
                                    </div>
                                    <table style="background-color: White; width: 100%;">
                                        <tr>
                                            <td style="padding: 10px;">
                                                <dx:ASPxButton ID="clearButton" ClientEnabled="false" Theme="Material" ClientInstanceName="clearButton"
                                                    runat="server" AutoPostBack="false" Text="<%$ Resources:GlobalResource, btn_selecione_loja_limpar %>" BackColor="#669999">
                                                    <ClientSideEvents Click="ClearSelection" />
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </td>
                                            <td style="text-align: right; padding: 10px;">
                                                <dx:ASPxButton ID="selectButton" ClientEnabled="false" Theme="Material" ClientInstanceName="selectButton"
                                                    runat="server" AutoPostBack="false" Text="<%$ Resources:GlobalResource, btn_selecione_loja_selecione %>" BackColor="#669999">
                                                    <ClientSideEvents Click=" function(s,e) {
                                                            UpdateSelection();
                                                            if (document.getElementById('hfDropEstr').value != '') {
                                                                document.getElementById('btnSelEmp').click();
                                                            }
                                                            } " />
                                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                                    <DisabledStyle BackColor="White"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="closeButton" runat="server" Theme="Material" AutoPostBack="false" Text="<%$ Resources:GlobalResource, btn_selecione_loja_fechar %>" BackColor="#669999">
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
        <div class="row mt-3" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:Indice, indexador_right_titulo3 %>"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('pesquisa');">
                <dx:ASPxComboBox ID="dropListagemIndices" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" AutoPostBack="true" OnSelectedIndexChanged="dropListagemIndices_SelectedIndexChanged"
                    Theme="Material" Width="100%" DataSourceID="sqlIndexadores" TextField="IENMINEC" ValueField="IEIDINEC">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
                <asp:SqlDataSource runat="server" ID="sqlIndexadores" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="WITH n(tvidestr) AS 
                               (SELECT tvidestr 
                               FROM tvestrut 
                               WHERE (tvidestr = ? or tvidestr = 1)
                                    UNION ALL 
                                SELECT nplus1.tvidestr 
                                FROM tvestrut as nplus1, n 
                               WHERE n.tvidestr = nplus1.tvcdpaie) 
                            SELECT I.IEIDINEC,I.IENMINEC,I.IEINFLAG FROM n,IEINDECO I 
                            WHERE I.IEINFLAG = 1 AND I.TVIDESTR = n.tvidestr 
                            union all 
                            select I.IEIDINEC,I.IENMINEC,I.IEINFLAG FROM IEINDECO I 
                            where I.IEINFLAG = 0 
                            order by I.IEINFLAG">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto;">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <dx:ASPxButton ID="btnInserir" ClientInstanceName="btnInserir" runat="server" CssClass="btn-using" OnClick="btnInserir_Click" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnLoad="btnInserir_Load">
                    <Paddings PaddingBottom="1px" PaddingTop="1px" PaddingLeft="6px" PaddingRight="6px" />
                </dx:ASPxButton>
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_excluir %>" OnClick="btnExcluir_Click" CausesValidation="false" OnLoad="btnExcluir_Load" />

            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_alterar %>" OnClick="btnAlterar_Click" CausesValidation="false" OnLoad="btnAlterar_Load" />

            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;">
                <asp:TextBox ID="TextBox15" Enabled="false" runat="server" CssClass="btn-using field_empty"></asp:TextBox>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                <asp:Button ID="btnOK" Enabled="false" runat="server" CssClass="btn-using ok" Text="<%$ Resources:GlobalResource, btn_ok %>" OnClick="btnOK_Click" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="btn-using cancelar" Text="<%$ Resources:GlobalResource, btn_cancelar %>" CausesValidation="false" OnClick="btnCancelar_Click" />
            </div>
        </div>
    </div>
</asp:Content>
