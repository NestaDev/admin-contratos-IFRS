<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="JurosETTJ.aspx.cs" Inherits="WebNesta_IRFS_16.JurosETTJ" %>

<%@ Register Assembly="DevExpress.XtraCharts.v20.1.Web, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.XtraCharts.v20.1.Web, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraCharts.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<%@ Register TagPrefix="dx" Namespace="DevExpress.XtraCharts" Assembly="DevExpress.XtraCharts.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'guia1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia1_guide%>';
                    break;
                case 'lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia1_lbl1_guide%>';
                    break;
                case 'lbl2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia1_lbl2_guide%>';
                    break;
                case 'lbl3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia1_lbl3_guide%>';
                    break;
                case 'lbl4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia1_lbl4_guide%>';
                    break;
                case 'guia2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia2_guide%>';
                    break;
                case 'guia2_btn1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia2_btn1_guide%>';
                    break;
                case 'guia3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.ETTJ.ettj_guia3_guide%>';
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfOpcao" runat="server" />
    <div class="container" style="overflow-y: auto;height: 470px;">
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:ETTJ, ettj_content_tutorial %>" />
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
                <div class="container-fluid">
                    <div class="row card border-0 bg-transparent p-0">
                        <div class="card-header bg-transparent ">
                            <h5 style="text-align: left; float: left;">
                                <asp:Label ID="Label24" runat="server" CssClass="labels" Text="<%$Resources:ETTJ, ettj_guia1 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                        </div>
                        <div class="card-body p-0 pl-3 ">
                            <div class="row p-0 m-0">
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label7" runat="server" Text="<%$Resources:ETTJ, ettj_guia1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('lbl1');">
                                        <dx:ASPxComboBox ID="dropBook" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" AutoPostBack="true"
                                            Theme="Material" Width="100%" DataSourceID="sqlBook" TextField="BODSBOOK" ValueField="BOIDBOOK">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxComboBox>
                                        <asp:SqlDataSource runat="server" ID="sqlBook" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                            SelectCommand="select BODSBOOK,BOIDBOOK from BOBOBOOK ORDER BY 1
"></asp:SqlDataSource>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label9" runat="server" Text="<%$Resources:ETTJ, ettj_guia1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('lbl2');">
                                        <asp:TextBox ID="txtCenario" ClientIDMode="Static" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label4" runat="server" Text="<%$Resources:ETTJ, ettj_guia1_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('lbl3');">
                                        <dx:ASPxComboBox ID="dropCriterio" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" AutoPostBack="true"
                                            Theme="Material" Width="100%" DataSourceID="sqlCriterio" TextField="CRDSCCRI" ValueField="CRDSCCRI">
                                            <Border BorderStyle="Solid" BorderWidth="1px" />
                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            </ButtonStyle>
                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                        </dx:ASPxComboBox>
                                        <asp:SqlDataSource runat="server" ID="sqlCriterio" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                            SelectCommand="select CRDSCCRI from CRITETTJ ORDER BY 1
"></asp:SqlDataSource>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label13" runat="server" Text="<%$Resources:ETTJ, ettj_guia1_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" ControlToValidate="txtDescricao" ValidationGroup="ValidaEETJ" runat="server" ErrorMessage="*" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                    <div class="input-group mb-auto" onmouseover="QuickGuide('lbl4');">
                                        <asp:TextBox ID="txtDescricao" Enabled="false" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="row card border-0 bg-transparent p-0">
                        <div class="card-header bg-transparent ">
                            <h5 style="text-align: left; float: left;">
                                <asp:Label ID="Label1" runat="server" CssClass="labels" Text="<%$Resources:ETTJ, ettj_guia2 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                        </div>
                        <div class="card-body p-0 pl-3" onmouseover="QuickGuide('guia2');">
                            <asp:Button ID="btnDblClickCenarios" ClientIDMode="Static" CssClass="d-none" runat="server" Text="Button" OnClick="btnDblClickCenarios_Click" />
                            <asp:HiddenField ID="hfIndexCenarios" ClientIDMode="Static" runat="server" />
                            <dx:ASPxGridView ID="gridCenarios" CssClass="mt-1" ClientInstanceName="gridCenarios" KeyFieldName="CENAETTJ" Theme="Material" runat="server" AutoGenerateColumns="False"
                                Width="550px" DataSourceID="sqlCenarios" OnCustomButtonInitialize="gridCenarios_CustomButtonInitialize" OnCustomButtonCallback="gridCenarios_CustomButtonCallback" OnLoad="gridCenarios_Load">
                                <ClientSideEvents EndCallback="function(s, e) {
	                                    if (s.cp_origem == 'ativar') {
                                            if(s.cp_ok=='OK')
                                            {
                                                document.getElementById('txtCenario').value = s.cp_cenario;
                                                chartGeral.PerformCallback('atualizar');
                                                gridCenarios.Refresh();
                                                s.Refresh();
                                                delete(s.cp_cenario);
                                                delete(s.cp_intervalos);
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                    }"
                                    RowDblClick="function(s, e) {
                                    document.getElementById('hfIndexCenarios').value = e.visibleIndex;
                                    document.getElementById('btnDblClickCenarios').click();
                                    } "></ClientSideEvents>
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                <SettingsPager NumericButtonCount="20" PageSize="20">
                                </SettingsPager>
                                <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="FocusedCellClick"></SettingsEditing>
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
                                    <dx:GridViewDataTextColumn FieldName="CENAETTJ" Caption="<%$Resources:ETTJ, ettj_guia2_grid_col1 %>" VisibleIndex="0" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="DESCETTJ" Caption="<%$Resources:ETTJ, ettj_guia2_grid_col2 %>" VisibleIndex="1" EditFormSettings-Visible="False"></dx:GridViewDataTextColumn>

                                    <dx:GridViewDataComboBoxColumn FieldName="Status" Caption="<%$Resources:ETTJ, ettj_guia2_grid_col3 %>" VisibleIndex="4" EditFormSettings-Visible="False">
                                        <PropertiesComboBox>
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:ETTJ, ettj_guia2_grid_opt1 %>" Value="1"></dx:ListEditItem>
                                                <dx:ListEditItem Text="<%$Resources:ETTJ, ettj_guia2_grid_opt2 %>" Value="0"></dx:ListEditItem>
                                            </Items>
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>

                                    <dx:GridViewCommandColumn VisibleIndex="5" Caption="  ">
                                        <CustomButtons>
                                            <dx:GridViewCommandColumnCustomButton ID="ativar" Text="<%$Resources:ETTJ, ettj_guia2_grid_opt1 %>"></dx:GridViewCommandColumnCustomButton>
                                        </CustomButtons>
                                    </dx:GridViewCommandColumn>
                                </Columns>
                                <Templates>
                                    <StatusBar>
                                        <div style="text-align: left">
                                            <br />
                                            <dx:ASPxButton ID="btnNovoCenario" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:ETTJ, ettj_guia2_btn1 %>" ClientSideEvents-Click="function(s, e){ popupImportaExcel.Show(); }" OnLoad="btnNovoCenario_Load">
                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                            </dx:ASPxButton>
                                        </div>
                                    </StatusBar>
                                </Templates>
                                <Styles>
                                    <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                    <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                    <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                    </Header>
                                    <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                    </Row>
                                    <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                    <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                                        <Paddings Padding="0px" />
                                    </BatchEditCell>
                                    <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                    <EditForm Paddings-Padding="0px"></EditForm>
                                    <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                    <Table></Table>
                                    <Cell Paddings-Padding="5px"></Cell>
                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                </Styles>
                            </dx:ASPxGridView>
                            <asp:SqlDataSource runat="server" ID="sqlCenarios" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                SelectCommand="select case when E.CENAETTJ=I.CENAETTJ THEN 1 ELSE 0 END as Status,I.CENAETTJ,E.DESCETTJ
                                                from ETTJETTJ E, INTEETTJ I
                                                WHERE E.BOIDBOOK=I.BOIDBOOK
                                                AND E.BOIDBOOK=?
                                                GROUP BY case when E.CENAETTJ=I.CENAETTJ THEN 1 ELSE 0 END,I.CENAETTJ,E.DESCETTJ
                                    order by I.CENAETTJ">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="dropBook" PropertyName="Value" Name="?"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                    <div class="row card border-0 bg-transparent mt-1 p-0">
                        <div class="card-header bg-transparent " onmouseover="QuickGuide('guia3');">
                            <h5 style="text-align: left; float: left;">
                                <asp:Label ID="Label2" runat="server" CssClass="labels" Text="<%$Resources:ETTJ, ettj_guia3 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                        </div>
                        <div class="card-body p-0 ">
                            <dx:WebChartControl ID="chartGeral" runat="server"
                                ClientInstanceName="chartGeral" OnCustomCallback="chartGeral_CustomCallback"
                                ToolTipEnabled="False" CrosshairEnabled="True" RenderFormat="Svg" AppearanceNameSerializable="Chameleon"
                                BackColor="Transparent" Width="800px" Height="350px" PaletteName="Chameleon" OnCustomDrawSeriesPoint="chartGeral_CustomDrawSeriesPoint">

                                <BorderOptions Visibility="False" />
                                <Legend MarkerMode="CheckBox" AlignmentHorizontal="LeftOutside" AlignmentVertical="Center" Name="Default Legend"></Legend>
                                <DiagramSerializable>
                                    <dx:XYDiagram>
                                        <AxisX VisibleInPanesSerializable="-1" Alignment="Zero" MinorCount="1">
                                            <QualitativeScaleOptions AutoGrid="False" />
                                            <NumericScaleOptions AutoGrid="False" />

                                        </AxisX>

                                        <AxisY VisibleInPanesSerializable="-1"></AxisY>
                                    </dx:XYDiagram>

                                </DiagramSerializable>
                            </dx:WebChartControl>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl ID="popupShowETTJ" ClientInstanceName="popupShowETTJ" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Detalhes Cenário" Modal="true" Width="320px" Height="550px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxGridView ID="gridDetalheCenario" CssClass="mt-1" ClientInstanceName="gridDetalheCenario" Theme="Material" runat="server" AutoGenerateColumns="False"
                    Width="310px">
                    <SettingsPopup>
                        <HeaderFilter MinHeight="140px">
                        </HeaderFilter>
                    </SettingsPopup>
                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                    <Settings VerticalScrollableHeight="540" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
                    <SettingsPager Mode="ShowAllRecords">
                    </SettingsPager>
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
                        <dx:GridViewDataTextColumn FieldName="intervalo" Width="145px" Caption="Intervalo" VisibleIndex="0"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="taxa" Width="145px" Caption="Taxa" VisibleIndex="1">
                            <PropertiesTextEdit DisplayFormatString="N6"></PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                    </Columns>

                    <Styles>
                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                        <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                        </Header>
                        <Row Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                        </Row>
                        <AlternatingRow Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                        <BatchEditCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray">
                            <Paddings Padding="0px" />
                        </BatchEditCell>
                        <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                        <EditForm Paddings-Padding="0px"></EditForm>
                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                        <Table></Table>
                        <Cell Paddings-Padding="5px"></Cell>
                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                    </Styles>
                </dx:ASPxGridView>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupImportaExcel" ClientInstanceName="popupImportaExcel" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Importação Excel" Modal="true" Width="600px" Height="250px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row p-0">
                        <div class="col-8">
                            <h6>
                                <asp:Label ID="Label3" runat="server" Text="Data Aplicação" CssClass="labels text-left"></asp:Label></h6>
                            <div class="input-group mb-auto">
                                <dx:ASPxDateEdit ID="txtDtAplic" ClientInstanceName="txtDtAplic" ForeColor="dimgray" UseMaskBehavior="True" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above">
                                    <ClientSideEvents DateChanged=" function (s,e) { fileImport.SetEnabled(txtDtAplic.GetValue() != null); } " />
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                        <MonthGridPaddings Padding="0px" />
                                        <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                        <HeaderStyle BackColor="#669999" />
                                        <CellSelectedStyle BackColor="#669999"></CellSelectedStyle>
                                        <FastNavProperties DisplayMode="Inline" />
                                    </CalendarProperties>
                                </dx:ASPxDateEdit>
                            </div>
                        </div>
                    </div>
                    <div class="row p-0 mt-2">
                        <div class="col-8">
                            <asp:Button ID="btnSel" ClientIDMode="Static" CssClass="Loading d-none" OnClick="btnSel_Click" runat="server" Text="Button" />
                            <dx:ASPxUploadControl ID="fileImport" ClientInstanceName="fileImport" ClientEnabled="false" runat="server" Theme="Material" Width="100%"
                                OnFileUploadComplete="fileImport_FileUploadComplete" BrowseButton-Text="Procurar"
                                UploadMode="Advanced" AutoStartUpload="true" ShowUploadButton="false" ShowProgressPanel="True">
                                <ClientSideEvents FilesUploadComplete="function (s,e) { document.getElementById('btnSel').click(); }" />
                                <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".xls,.xlsx">
                                </ValidationSettings>
                                <ButtonStyle CssClass="btn-using" ForeColor="White" Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></ButtonStyle>
                                <DisabledButtonStyle ForeColor="LightGray"></DisabledButtonStyle>
                            </dx:ASPxUploadControl>
                        </div>
                        <div class="col-4">
                            <asp:Button ID="btnDownloadModelo" runat="server" CssClass="btn-using" Width="120px" Height="33px" Text="Planilha Modelo" OnClick="btnDownloadModelo_Click" />

                        </div>
                    </div>
                    <div class="row p-0">
                        <div class="col-12">
                            <asp:Label ID="lblErrorFileUpload" runat="server" Text="" CssClass="labels text-left text-danger"></asp:Label>
                        </div>
                    </div>
                </div>

            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:Button ID="btnSelEmp" runat="server" CssClass="Loading d-none" ClientIDMode="Static" Text="Button" />
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="Curva ETTJ" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label8" runat="server" Text="Selecione:"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('pesquisa');" onmouseout="QuickGuide('ini');">
                <dx:ASPxComboBox ID="dropListagemIndices" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" AutoPostBack="true"
                    Theme="Material" Width="100%" DataSourceID="sqlIndexadores" TextField="BODSBOOK" ValueField="BOIDBOOK" OnSelectedIndexChanged="dropListagemIndices_SelectedIndexChanged">
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
                <asp:SqlDataSource runat="server" ID="sqlIndexadores" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="select BODSBOOK,C.BOIDBOOK from BOBOBOOK C INNER JOIN ETTJETTJ E ON C.BOIDBOOK=E.BOIDBOOK ORDER BY 1
"></asp:SqlDataSource>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto;">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <dx:ASPxButton ID="btnInserir" ClientInstanceName="btnInserir" runat="server" CssClass="btn-using" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>" CommandArgument="inserir" OnCommand="BotoesOperacao" OnLoad="btnInserir_Load">
                    <Paddings PaddingBottom="1px" PaddingTop="1px" PaddingLeft="6px" PaddingRight="6px" />
                </dx:ASPxButton>
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" CommandArgument="excluir" OnCommand="BotoesOperacao" OnLoad="btnExcluir_Load" />

            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" CommandArgument="alterar" OnCommand="BotoesOperacao" OnLoad="btnAlterar_Load" />

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
                <asp:Button ID="btnCancelar" Enabled="false" runat="server" CssClass="btn-using cancelar" OnClick="btnCancelar_Click" Text="<%$ Resources:GlobalResource, btn_cancelar %>" CausesValidation="false" />
            </div>
        </div>
    </div>
</asp:Content>
