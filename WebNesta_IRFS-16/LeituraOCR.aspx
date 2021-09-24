<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="True" CodeBehind="LeituraOCR.aspx.cs" Inherits="WebNesta_IRFS_16.LeituraOCR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'guia1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools2_guia1_guide%>';
                    break;
                case 'guia2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools2_guia2_guide%>';
                    break;
                case 'guia3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools2_guia3_guide%>';
                    break;
                case 'guia2_btn1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools2_guia2_btn1_guide%>';
                    break;
                case 'btn1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools2_btn1_guide%>';
                    break;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:OCRTools, ocrtools_content_tutorial %>" />
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
                <div class="row">
                    <div class="col-4">
                        <asp:Label ID="Label35" runat="server" Text="Selecione o Layout" CssClass="labels text-left"></asp:Label>
                        <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('16');">
                            <dx:ASPxComboBox ID="dropLayout" ForeColor="dimgray" CssClass="drop-down" runat="server" DataSourceID="SqlDataSource1" ValueType="System.String" ValueField="LAYIDPAI" TextField="LAYNMPAI"
OnSelectedIndexChanged="dropLayout_SelectedIndexChanged" AutoPostBack="true">
<Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <ValidationSettings ValidationGroup="ValidateGrp"></ValidationSettings></dx:ASPxComboBox>

                            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT LAYNMPAI, LAYIDPAI FROM LAYPDFPA order by 1"></asp:SqlDataSource>
                        </div>
                    </div>
                    <div class="col-4">
                        <asp:Button ID="btnSel" ClientIDMode="Static" CssClass="Loading d-none" OnClick="btnSel_Click" runat="server" Text="Button" />
                        <asp:Label ID="Label5" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_lbl1 %>"></asp:Label>
                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('lbl1');">
                            <dx:ASPxUploadControl ID="fileInsert" runat="server" Theme="Material" Width="400px" ClientInstanceName="fileInsert"
                                OnFileUploadComplete="fileInsert_FileUploadComplete" BrowseButton-Text="Procurar" Enabled="false"
                                UploadMode="Advanced" AutoStartUpload="true" ShowUploadButton="false" ShowProgressPanel="True">
                                <ClientSideEvents FilesUploadComplete="function (s,e) { document.getElementById('btnSel').click(); }" />
                                <AdvancedModeSettings EnableMultiSelect="true" EnableFileList="True" EnableDragAndDrop="False" />
                                <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".pdf">
                                </ValidationSettings>
                                <ButtonStyle CssClass="btn-using" ForeColor="White" Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></ButtonStyle>
                                <DisabledButtonStyle ForeColor="LightGray"></DisabledButtonStyle>
                            </dx:ASPxUploadControl>
                        </div>
                    </div>
                    <div class="col-4">
                        <br />
                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('btn1');">
                            <asp:Button ID="Button1" runat="server" CssClass="Loading btn-using float-right" Text="<%$Resources:OCRTools, ocrtools2_btn1 %>" OnClick="Button1_Click" Style="height: 30px" />
                        </div>
                    </div>
                </div>
                <div id="gridBoletos" class="container-fluid">
                    <div class="row d-none card border-0 bg-transparent p-0">
                        <div class="card-header bg-transparent pb-0">

                            <div onmouseover="QuickGuide('guia1');">
                                <a class="card-link" data-toggle="collapse" href="#collapseSemLayout" aria-expanded="true">
                                    <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>

                                        <asp:Label ID="Label24" runat="server" CssClass="labels" Text="<%$Resources:OCRTools, ocrtools2_guia1 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                                </a>
                            </div>

                        </div>
                        <div id="collapseSemLayout" class="collapse show" data-parent="#gridBoletos">
                            <div class="card-body p-0 ">
                                <dx:ASPxGridView ID="gridInventario" KeyFieldName="PDF" ClientInstanceName="gridInventario" Theme="Material" runat="server" AutoGenerateColumns="False"
                                    OnDataBinding="gridInventario_DataBinding" OnBatchUpdate="gridInventario_BatchUpdate" OnCustomButtonInitialize="gridInventario_CustomButtonInitialize"
                                    OnCustomButtonCallback="gridInventario_CustomButtonCallback" Width="950px" OnLoad="gridInventario_Load">
                                    <SettingsEditing Mode="Batch"></SettingsEditing>
                                    <Settings VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" VerticalScrollableHeight="150" HorizontalScrollBarMode="Auto" />
                                    <Images>
                                        <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                        <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                    </Images>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Templates>
                                        <StatusBar>
                                            <div style="text-align: left">
                                                <br />
                                                <dx:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="false" CssClass="btn-using" Font-Size="12pt" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridInventario.UpdateEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>

                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="false" CssClass="btn-using" Font-Size="12pt" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridInventario.CancelEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </div>
                                        </StatusBar>
                                    </Templates>
                                    <StylesFilterControl ActiveTab-HorizontalAlign="Left">
                                        <ActiveTab HorizontalAlign="Left"></ActiveTab>
                                    </StylesFilterControl>
                                    <StylesPager>
                                        <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                    </StylesPager>
                                    <Styles>
                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                        <Header BackColor="#669999" Font-Names="Arial" Font-Size="10pt" ForeColor="White" Paddings-Padding="3px"></Header>
                                        <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></Row>
                                        <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="#DB9C99"></AlternatingRow>
                                        <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            <Paddings Padding="0px" />
                                        </BatchEditCell>
                                        <FocusedRow BackColor="#669999" ForeColor="White"></FocusedRow>
                                        <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                        <EditForm Paddings-Padding="0px"></EditForm>
                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                        <Cell Wrap="False" Paddings-Padding="5px"></Cell>
                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                    </Styles>
                                </dx:ASPxGridView>
                            </div>
                        </div>
                    </div>
                    <div class="row card border-0 bg-transparent p-0">
                        <div class="card-header bg-transparent pb-0" onmouseover="QuickGuide('guia2');">
                            <a class="card-link" data-toggle="collapse" href="#collapseLidos" aria-expanded="false">
                                <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label25" runat="server" CssClass="labels" Text="<%$Resources:OCRTools, ocrtools2_guia2 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                            </a>
                        </div>
                        <div id="collapseLidos" class="collapse" data-parent="#gridBoletos">
                            <div class="card-body p-0 " style="width:1000px; overflow:auto">
                                <dx:ASPxGridView ID="gridLidos" KeyFieldName="PDF" ClientInstanceName="gridLidos" runat="server" AutoGenerateColumns="false" OnDataBinding="gridLidos_DataBinding" OnBatchUpdate="gridLidos_BatchUpdate"
                                    OnHtmlRowPrepared="gridLidos_HtmlRowPrepared" OnCommandButtonInitialize="gridLidos_CommandButtonInitialize" Theme="Material" OnCustomCallback="gridLidos_CustomCallback" OnLoad="gridLidos_Load">
                                    <Settings VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" VerticalScrollableHeight="150" />
                                    <Images>
                                        <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                        <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                    </Images>
                                    <SettingsEditing Mode="Batch"></SettingsEditing>
                                    <StylesFilterControl ActiveTab-HorizontalAlign="Left">
                                        <ActiveTab HorizontalAlign="Left"></ActiveTab>
                                    </StylesFilterControl>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Templates>
                                        <StatusBar>
                                            <div style="text-align: left">
                                                <br />
                                                <dx:ASPxButton ID="ASPxButton3" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridLidos.UpdateEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="ASPxButton4" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridLidos.CancelEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="ASPxButton7" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:OCRTools, ocrtools2_guia2_btn1 %>" ClientSideEvents-Click="function(s, e){ gridLidos.PerformCallback('processar'); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </div>
                                        </StatusBar>
                                    </Templates>
                                    <StylesPager>
                                        <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                    </StylesPager>
                                    <Styles>
                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                        <Header BackColor="#669999" Font-Names="Arial" Font-Size="10pt" ForeColor="White" Paddings-Padding="3px"></Header>
                                        <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></Row>
                                        <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="#DB9C99"></AlternatingRow>
                                        <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            <Paddings Padding="0px" />
                                        </BatchEditCell>
                                        <FocusedRow BackColor="#669999" ForeColor="White"></FocusedRow>
                                        <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                        <EditForm Paddings-Padding="0px"></EditForm>
                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                        <Cell Wrap="False" Paddings-Padding="5px"></Cell>
                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                    </Styles>
                                </dx:ASPxGridView>
                            </div>
                        </div>
                    </div>
                    <div class="row card border-0 bg-transparent p-0">
                        <div class="card-header bg-transparent pb-0" onmouseover="QuickGuide('guia3');">
                            <a class="card-link" data-toggle="collapse" href="#collapseNaoLidos" aria-expanded="false">
                                <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                    <asp:Label ID="Label15" runat="server" CssClass="labels" Text="<%$Resources:OCRTools, ocrtools2_guia3 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                            </a>
                        </div>
                        <div id="collapseNaoLidos" class="collapse" data-parent="#gridBoletos">
                            <div class="card-body p-0 " style="width:1000px; overflow:auto">
                                <dx:ASPxGridView ID="gridNaoLidos" KeyFieldName="PDF" ClientInstanceName="gridNaoLidos" runat="server" AutoGenerateColumns="false" OnDataBinding="gridNaoLidos_DataBinding" OnBatchUpdate="gridNaoLidos_BatchUpdate"
                                    OnHtmlRowPrepared="gridNaoLidos_HtmlRowPrepared" OnCommandButtonInitialize="gridNaoLidos_CommandButtonInitialize" Theme="Material" OnCustomCallback="gridNaoLidos_CustomCallback" OnLoad="gridNaoLidos_Load">
                                    <Settings VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" VerticalScrollableHeight="150" />
                                    <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />
                                    <Images>
                                        <DetailExpandedButton Url="icons/icons8-seta-para-recolher-30.png"></DetailExpandedButton>
                                        <DetailCollapsedButton Url="icons/icons8-seta-para-expandir-30.png"></DetailCollapsedButton>
                                    </Images>
                                    <SettingsEditing Mode="Batch"></SettingsEditing>
                                    <StylesFilterControl ActiveTab-HorizontalAlign="Left">
                                        <ActiveTab HorizontalAlign="Left"></ActiveTab>
                                    </StylesFilterControl>
                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                    <Templates>
                                        <StatusBar>
                                            <div style="text-align: left">
                                                <br />
                                                <dx:ASPxButton ID="ASPxButton5" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridNaoLidos.UpdateEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="ASPxButton6" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridNaoLidos.CancelEdit(); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="ASPxButton7" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:OCRTools, ocrtools2_guia2_btn1 %>" ClientSideEvents-Click="function(s, e){ gridNaoLidos.PerformCallback('processar'); }">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                            </div>
                                        </StatusBar>
                                    </Templates>
                                    <StylesPager>
                                        <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                    </StylesPager>
                                    <Styles>
                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                        <Header BackColor="#669999" Font-Names="Arial" Font-Size="10pt" ForeColor="White" Paddings-Padding="3px"></Header>
                                        <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></Row>
                                        <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="#DB9C99"></AlternatingRow>
                                        <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            <Paddings Padding="0px" />
                                        </BatchEditCell>
                                        <FocusedRow BackColor="#669999" ForeColor="White"></FocusedRow>
                                        <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                        <EditForm Paddings-Padding="0px"></EditForm>
                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                        <Cell Wrap="False" Paddings-Padding="5px"></Cell>
                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                    </Styles>
                                </dx:ASPxGridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
