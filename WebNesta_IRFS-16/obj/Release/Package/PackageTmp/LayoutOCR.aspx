<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LayoutOCR.aspx.cs" Inherits="WebNesta_IRFS_16.LayoutOCR" %>

<%@ Register Assembly="PdfViewer" Namespace="PdfViewer" TagPrefix="cc1" %>
<%@ Register Assembly="DevExpress.Web.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_lbl1_guide%>';
                    break;
                case 'lbl2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_lbl2_guide%>';
                    break;
                case 'lbl3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_lbl3_guide%>';
                    break;
                case 'lbl4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_lbl4_guide%>';
                    break;
                case 'guia1_lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl1_guide%>';
                    break;
                case 'guia1_lbl2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl2_guide%>';
                    break;
                case 'guia1_lbl3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl3_guide%>';
                    break;
                case 'guia1_lbl4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl4_guide%>';
                    break;
                case 'guia1_lbl5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl5_guide%>';
                    break;
                case 'guia1_lbl6':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl6_guide%>';
                    break;
                case 'guia1_lbl7':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl7_guide%>';
                    break;
                case 'guia1_lbl8':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl8_guide%>';
                    break;
                case 'guia1_lbl9':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl9_guide%>';
                    break;
                case 'guia1_lbl10':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl10_guide%>';
                    break;
                case 'guia1_lbl11':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl11_guide%>';
                    break;
                case 'guia1_lbl12':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl12_guide%>';
                    break;
                case 'guia1_lbl13':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_lbl13_guide%>';
                    break;
                case 'guia1_btn1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_btn1_guide%>';
                    break;
                case 'guia1_btn2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_btn2_guide%>';
                    break;
                case 'guia1_btn3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.OCRTools.ocrtools_guia1_btn3_guide%>';
                    break;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfPDF" runat="server" />
    <asp:HiddenField ID="hfPDFURL" runat="server" />
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
                <div class="row pl-2 pr-2 mb-0">
                    <asp:Button ID="btnSel" ClientIDMode="Static" CssClass="Loading d-none" OnClick="btnSel_Click" runat="server" Text="Button" />
                    <div class="col-5 p-0">
                        <asp:Label ID="Label5" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_lbl1 %>"></asp:Label>
                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('lbl1');">
                            <dx:ASPxUploadControl ID="fileInsert" runat="server" Theme="Material" Width="400px"
                                OnFileUploadComplete="fileInsert_FileUploadComplete" BrowseButton-Text="Procurar"
                                UploadMode="Advanced" AutoStartUpload="true" ShowUploadButton="false" ShowProgressPanel="True">
                                <ClientSideEvents FilesUploadComplete="function (s,e) { document.getElementById('btnSel').click(); }" />
                                <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".pdf">
                                </ValidationSettings>
                                <ButtonStyle CssClass="btn-using" ForeColor="White" Paddings-PaddingTop="2px" Paddings-PaddingBottom="2px"></ButtonStyle>
                                <DisabledButtonStyle ForeColor="LightGray"></DisabledButtonStyle>
                            </dx:ASPxUploadControl>
                        </div>
                    </div>
                    <div class="col-6 p-0">
                        <asp:Label ID="Label4" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_lbl2 %>"></asp:Label>
                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('lbl2');">
                            <asp:TextBox ID="txtPdf" Width="80%" runat="server" CssClass="text-boxes"></asp:TextBox>
                            <dx:ASPxButton ID="btnViewPDF" CssClass="btn-using" runat="server" AutoPostBack="false" Width="80px" Height="20px" Font-Size="10pt" CausesValidation="false" Text="Visualizar">
                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                <ClientSideEvents Click="function(s,e){popupPDF.Show();}" />

                            </dx:ASPxButton>
                        </div>
                    </div>
                </div>
                <div class="row pl-2 pr-2">
                    <div class="col-12">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:HiddenField ID="hfPDF2" runat="server" />
                                <asp:HiddenField ID="hfPDFURL2" runat="server" />
                                <asp:HiddenField ID="hfLayoutID" runat="server" />
                                <asp:HiddenField ID="hfLayoutIDFilho" runat="server" />
                                <asp:HiddenField ID="hfOpercao" runat="server" />
                                <asp:HiddenField ID="hfClass" runat="server" />
                                <div class="container-fluid">
                                    <div class="row p-0">
                                        <div class="col-lg-3 p-0">
                                            <asp:Label ID="Label1" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_lbl3 %>"></asp:Label>
                                            <asp:Label ID="lblErrorLayout" ForeColor="Red" runat="server" CssClass="labels text-left" Text=""></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('lbl3');">
                                                <asp:TextBox ID="txtNomeLayout" Enabled="false" Width="100%" runat="server" CssClass="text-boxes"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 p-0">
                                            <asp:Label ID="Label13" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <dx:ASPxComboBox ID="dropFormPagt" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" 
                                                    CssClass="drop-down" Theme="Material" Width="100%" ValueType="System.String">
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item1 %>" Value="B" />
                                                        <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item2 %>" Value="T" />
                                                        <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item3 %>" Value="D" />
                                                    </Items>
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <ValidationSettings RequiredField-IsRequired="true" RequiredField-ErrorText="*" ErrorFrameStyle-ForeColor="Red" Display="Dynamic"></ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 p-0">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px">
                                                <asp:Button ID="btnSalvarLayout" Enabled="false" OnClick="btnSalvarLayout_Click" CssClass="btn-using" Height="28px" runat="server" Text="<%$Resources:OCRTools, ocrtools_btn1 %>" OnLoad="btnSalvarLayout_Load" />
                                            </div>
                                        </div>
                                        <div class="col-lg-3 p-0">
                                            <asp:Label ID="Label9" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_lbl4 %>"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('lbl4');">
                                                <dx:ASPxComboBox ID="dropLayouts" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" ValueType="System.Int32"
                                                    Theme="Material" Width="100%" AutoPostBack="true" DataSourceID="sqlLayouts" ValueField="LAYIDPAI" TextField="LAYNMPAI" OnSelectedIndexChanged="dropLayouts_SelectedIndexChanged">
                                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <ValidationSettings ValidationGroup="ValidateGrp"></ValidationSettings>
                                                </dx:ASPxComboBox>
                                                <asp:SqlDataSource runat="server" ID="sqlLayouts" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT LAYNMPAI,LAYIDPAI from LAYPDFPA order by 2"></asp:SqlDataSource>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="pdfLayout">
                                        <div class="row card border-0 bg-transparent p-0">
                                            <div class="card-header bg-transparent p-0">
                                                <a class="card-link" data-toggle="collapse" href="#collapseParam" aria-expanded="true">
                                                    <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                                        <asp:Label ID="Label24" runat="server" CssClass="labels" Text="<%$Resources:OCRTools, ocrtools_guia1 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                                                </a>
                                            </div>
                                            <div id="collapseParam" class="collapse show" data-parent="#pdfLayout">
                                                <div class="card-body p-0 ">
                                                    <div class="container-fluid">
                                                        <div class="row">
                                                            <div class="col-4 p-0">
                                                                <asp:Label ID="Label2" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl1 %>"></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl1');">
                                                                    <dx:ASPxTextBox ID="txtPesquisa" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px"
                                                                        RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px"
                                                                        EnableClientSideAPI="True" EncodeHtml="false">
                                                                        <ValidationSettings ValidateOnLeave="true" ValidationGroup="ValidateGrp" SetFocusOnError="True" Display="Dynamic">
                                                                            <RequiredField IsRequired="True" ErrorText="*" />
                                                                        </ValidationSettings>
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxTextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-2 p-0">
                                                                <asp:Label ID="Label11" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl2 %>"></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl2');">
                                                                    <dx:ASPxTextBox ID="txtOcorrencia" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px"
                                                                        RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px"
                                                                        EnableClientSideAPI="True" EncodeHtml="false">
                                                                        <ValidationSettings ValidateOnLeave="true" ValidationGroup="ValidateGrp" SetFocusOnError="True" Display="Dynamic">
                                                                            <RequiredField IsRequired="True" ErrorText="*" />
                                                                        </ValidationSettings>
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxTextBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-3 p-0">
                                                                <asp:Label ID="Label6" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl3 %>"></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl3');">
                                                                    <dx:ASPxComboBox ID="dropPosition" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" ValueType="System.Int32"
                                                                        Theme="Material" Width="100%" AutoPostBack="true" OnSelectedIndexChanged="dropPosition_SelectedIndexChanged">
                                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                        <Items>
                                                                            <dx:ListEditItem Text="Selecionar" Value="0" Selected="true" />
                                                                            <dx:ListEditItem Text="Acima" Value="1" />
                                                                            <dx:ListEditItem Text="Direita" Value="2" />
                                                                            <dx:ListEditItem Text="Esquerda" Value="3" />
                                                                            <dx:ListEditItem Text="Abaixo" Value="4" />
                                                                        </Items>
                                                                        <ValidationSettings ValidationGroup="ValidateGrp"></ValidationSettings>
                                                                    </dx:ASPxComboBox>
                                                                </div>
                                                            </div>
                                                            <div class="col-3 p-0">
                                                                <asp:Label ID="Label3" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl4 %>"></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl4');">
                                                                    <dx:ASPxComboBox ID="dropApenasCord" ForeColor="dimgray" AllowInputUser="false" Enabled="false" runat="server" CssClass="drop-down" ValueType="System.Int32"
                                                                        Theme="Material" Width="100%">
                                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                        <Items>
                                                                            <dx:ListEditItem Text="Sim" Value="1" Selected="true" />
                                                                            <dx:ListEditItem Text="Não" Value="0" />
                                                                        </Items>
                                                                        <ValidationSettings ValidationGroup="ValidateGrp"></ValidationSettings>
                                                                    </dx:ASPxComboBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row mt-1">
                                                            <div class="col-8 p-0">
                                                                <div class="row p-0">
                                                                    <div class="col-6 p-0">
                                                                        <asp:Label ID="Label15" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl5 %>"></asp:Label>
                                                                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl5');">
                                                                            <dx:ASPxTrackBar runat="server" Enabled="false" ID="txtTop" MinValue="0" MaxValue="800" PositionStart="0" PositionEnd="800" Step="1" LargeTickInterval="200" SmallTickFrequency="5"
                                                                                AllowRangeSelection="false" Orientation="Horizontal" ShowChangeButtons="true" ShowDragHandles="true" Theme="Material" ScalePosition="LeftOrTop" CssClass="center" Width="90%">
                                                                            </dx:ASPxTrackBar>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-6 p-0">
                                                                        <asp:Label ID="Label16" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl6 %>"></asp:Label>
                                                                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl6');">
                                                                            <dx:ASPxTrackBar runat="server" Enabled="false" ID="txtLeft" MinValue="0" MaxValue="800" PositionStart="0" PositionEnd="800" Step="1" LargeTickInterval="200" SmallTickFrequency="5"
                                                                                AllowRangeSelection="false" Orientation="Horizontal" ShowChangeButtons="true" ShowDragHandles="true" Theme="Material" ScalePosition="LeftOrTop" CssClass="center" Width="90%">
                                                                            </dx:ASPxTrackBar>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row p-0">
                                                                    <div class="col-6 p-0">
                                                                        <asp:Label ID="Label17" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl7 %>"></asp:Label>
                                                                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl7');">
                                                                            <dx:ASPxTrackBar runat="server" Enabled="false" ID="txtRight" MinValue="0" MaxValue="800" PositionStart="0" PositionEnd="800" Step="1" LargeTickInterval="200" SmallTickFrequency="5"
                                                                                AllowRangeSelection="false" Orientation="Horizontal" ShowChangeButtons="true" ShowDragHandles="true" Theme="Material" ScalePosition="LeftOrTop" CssClass="center" Width="90%">
                                                                            </dx:ASPxTrackBar>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-6 p-0">
                                                                        <asp:Label ID="Label18" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl8 %>"></asp:Label>
                                                                        <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl8');">
                                                                            <dx:ASPxTrackBar runat="server" Enabled="false" ID="txtBottom" MinValue="0" MaxValue="800" PositionStart="0" PositionEnd="800" Step="1" LargeTickInterval="200" SmallTickFrequency="5"
                                                                                AllowRangeSelection="false" Orientation="Horizontal" ShowChangeButtons="true" ShowDragHandles="true" Theme="Material" ScalePosition="LeftOrTop" CssClass="center" Width="90%">
                                                                            </dx:ASPxTrackBar>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-4">
                                                                <div class="row">
                                                                    <asp:Label ID="Label7" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl9 %>"></asp:Label>
                                                                    <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl9');">
                                                                        <asp:TextBox ID="txtResultado" Enabled="false" Width="100%" runat="server" CssClass="text-boxes"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <dx:ASPxCheckBox ID="checkVerba" runat="server" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl10 %>" AutoPostBack="true" Theme="Material" OnCheckedChanged="ASPxCheckBox1_CheckedChanged"></dx:ASPxCheckBox>
                                                                </div>
                                                                <asp:MultiView ID="mvVerba" runat="server">
                                                                    <asp:View ID="vw_Verba" runat="server">
                                                                        <div class="row">
                                                                            <div class="col-12 p-0">
                                                                                <asp:Label ID="Label10" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl13 %>"></asp:Label>
                                                                                <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl13');">
                                                                                    <dx:ASPxComboBox ID="dropVerba" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" ValueType="System.Int32"
                                                                                        Theme="Material" Width="100%" DataSourceID="sqlVerba" ValueField="MOIDMODA" TextField="MODSMODA">
                                                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                                        </ButtonStyle>
                                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                                        <ValidationSettings ValidationGroup="ValidateGrp"></ValidationSettings>
                                                                                    </dx:ASPxComboBox>
                                                                                    <asp:SqlDataSource runat="server" ID="sqlVerba" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select MODSMODA,MOIDMODA from modalida where MOTPIDCA=10 order by 1"></asp:SqlDataSource>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </asp:View>
                                                                    <asp:View ID="vw_Class" runat="server">
                                                                        <div class="row">
                                                                            <div class="col-6 p-0">
                                                                                <asp:Label ID="Label8" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl11 %>"></asp:Label>
                                                                                <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl11');">
                                                                                    <dx:ASPxComboBox ID="dropClassificador" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" ValueType="System.Int32"
                                                                                        Theme="Material" Width="100%" DataSourceID="sqlClassificador" ValueField="LAYIDCLA" TextField="LAYNMCLA">
                                                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                                        </ButtonStyle>
                                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                                        <ValidationSettings ValidationGroup="ValidateGrp"></ValidationSettings>
                                                                                    </dx:ASPxComboBox>
                                                                                    <asp:SqlDataSource runat="server" ID="sqlClassificador" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT LAYIDCLA,LAYNMCLA FROM LAYPDFCL WHERE LAYIDENT=1 order by 2"></asp:SqlDataSource>
                                                                                </div>
                                                                            </div>
                                                                            <div class="col-6 p-0">
                                                                                <asp:Label ID="Label12" runat="server" CssClass="labels text-left" Text="<%$Resources:OCRTools, ocrtools_guia1_lbl12 %>"></asp:Label>
                                                                                <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('guia1_lbl12');">
                                                                                    <dx:ASPxComboBox ID="dropTipo" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" ValueType="System.String"
                                                                                        Theme="Material" Width="100%">
                                                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                                        </ButtonStyle>
                                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="Texto" Value="String" />
                                                                                            <dx:ListEditItem Text="Data" Value="Date" />
                                                                                            <dx:ListEditItem Text="Número" Value="Int" />
                                                                                        </Items>
                                                                                        <ValidationSettings ValidationGroup="ValidateGrp"></ValidationSettings>
                                                                                    </dx:ASPxComboBox>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </asp:View>
                                                                </asp:MultiView>
                                                                <div class="row mt-2">
                                                                    <div class="col-12">
                                                                        <asp:Label ID="lblClassificadorErro" ForeColor="Red" runat="server" CssClass="labels text-left" Text=""></asp:Label>
                                                                    </div>
                                                                    <div class="col-6" onmouseover="QuickGuide('btn1');">
                                                                        <asp:Button ID="btnAjustar" Enabled="false" OnClick="btnAjustar_Click" CssClass="btn-using" Height="28px" runat="server" Text="<%$Resources:OCRTools, ocrtools_guia1_btn1 %>" />
                                                                    </div>
                                                                    <div class="col-6" onmouseover="QuickGuide('btn2');">
                                                                        <asp:Button ID="btnGravar" Enabled="false" OnClick="btnGravar_Click" CssClass="btn-using" Height="28px" runat="server" Text="<%$Resources:OCRTools, ocrtools_guia1_btn2 %>" />
                                                                    </div>
                                                                </div>
                                                                <div class="row mt-1">
                                                                    <div class="col-6" onmouseover="QuickGuide('btn3');">
                                                                        <asp:Button ID="btnDelete" Enabled="false" OnClick="btnDelete_Click" CssClass="btn-using" Height="28px" runat="server" Text="<%$Resources:OCRTools, ocrtools_guia1_btn3 %>" />
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <asp:Button ID="btnVoltar" Visible="false" OnClick="btnVoltar_Click" CssClass="btn-using" Height="28px" runat="server" Text="Voltar" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row card border-0 bg-transparent p-0">
                                            <div class="card-header bg-transparent p-0">
                                                <a class="card-link" data-toggle="collapse" href="#collapseVerbas" aria-expanded="false">
                                                    <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                                        <asp:Label ID="Label14" runat="server" CssClass="labels" Text="<%$Resources:OCRTools, ocrtools_guia2 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                                                </a>
                                            </div>
                                            <div id="collapseVerbas" class="collapse" data-parent="#pdfLayout">
                                                <div class="card-body p-0 ">
                                                    <div class="container-fluid">
                                                        <div class="row">
                                                            <div class="col-lg-12 p-0">
                                                                <dx:ASPxLabel ID="lblIdentidade" Wrap="True" Width="100%" ForeColor="Red" Font-Size="10pt" runat="server" Text=""></dx:ASPxLabel>
                                                                <asp:Button ID="btn_selGrid" ClientIDMode="Static" CssClass="d-none" OnClick="btn_selGrid_Click" runat="server" Text="Button" />
                                                                <dx:ASPxGridView ID="gridCordenadas" runat="server" AutoGenerateColumns="False" DataSourceID="sqlCordenadas" Theme="Material"
                                                                    OnDataBound="gridCordenadas_DataBound">
                                                                    <ClientSideEvents RowDblClick="function(s, e) {  
                                                document.getElementById('btn_selGrid').click();
                                            }" />
                                                                    <SettingsBehavior AllowFocusedRow="true" />
                                                                    <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYNMFIL" Width="180px" Caption="<%$Resources:OCRTools, ocrtools_guia2_grid_col1 %>" VisibleIndex="0">
                                                                            <CellStyle Wrap="True"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYTPFIL" Visible="false" Caption="Top" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYLFFIL" Visible="false" Caption="Left" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYRGFIL" Visible="false" Caption="Right" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYBTFIL" Visible="false" Caption="Bottom" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataComboBoxColumn FieldName="LAYIDCLA" Width="140px" Caption="<%$Resources:OCRTools, ocrtools_guia2_grid_col2 %>" VisibleIndex="5">
                                                                            <PropertiesComboBox DataSourceID="sqlClassificador" ValueField="LAYIDCLA" TextField="LAYNMCLA" ValueType="System.Int32"></PropertiesComboBox>
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYIDFIL" Visible="false" VisibleIndex="6"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataComboBoxColumn FieldName="MOIDMODA" Width="140px" Caption="<%$Resources:OCRTools, ocrtools_guia2_grid_col3 %>" VisibleIndex="7">
                                                                            <PropertiesComboBox DataSourceID="sqlVerba" ValueField="MOIDMODA" TextField="MODSMODA" ValueType="System.Int32"></PropertiesComboBox>
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYCORFL" Visible="false" VisibleIndex="8"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYQTFIL" Visible="false" VisibleIndex="9"></dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="LAYTIPOF" Visible="false" VisibleIndex="10"></dx:GridViewDataTextColumn>
                                                                    </Columns>
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
                                                                <asp:SqlDataSource runat="server" ID="sqlCordenadas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                    SelectCommand="SELECT LAYNMFIL,LAYLFFIL,LAYRGFIL,LAYTPFIL,LAYBTFIL, LAYIDCLA,LAYIDFIL,MOIDMODA,LAYCORFL,LAYQTFIL,LAYTIPOF FROM LAYPDFFI where LAYIDPAI=?">
                                                                    <SelectParameters>
                                                                        <asp:ControlParameter ControlID="hfLayoutID" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnSalvarLayout" />
                                <asp:AsyncPostBackTrigger ControlID="checkVerba" />
                                <asp:PostBackTrigger ControlID="dropPosition" />
                                <asp:AsyncPostBackTrigger ControlID="btnAjustar" />
                                <asp:AsyncPostBackTrigger ControlID="btnGravar" />
                                <asp:AsyncPostBackTrigger ControlID="btn_selGrid" />
                                <asp:AsyncPostBackTrigger ControlID="dropLayouts" />
                                <asp:AsyncPostBackTrigger ControlID="btnDelete" />
                            </Triggers>
                        </asp:UpdatePanel>
                        <asp:UpdateProgress ID="UpdateProgress1" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>
                                <div class="lockUpatePanel">
                                </div>

                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl ID="ASPxPopupControl1" ClientInstanceName="popupPDF" PopupElementID="btnViewPDF" runat="server" CloseOnEscape="true"
        ShowHeader="true" HeaderText="Visualização" PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter" PopupAnimationType="Fade" Theme="Material" Width="900px" Height="600px"
        AllowResize="true" AllowDragging="true">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <cc1:ShowPdf ID="ShowPdf1" runat="server" BorderStyle="Inset" BorderWidth="2px" FilePath=""
                    Height="500px" Width="100%" />
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
