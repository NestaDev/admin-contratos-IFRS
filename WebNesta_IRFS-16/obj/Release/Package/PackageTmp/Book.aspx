<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Book.aspx.cs" Inherits="WebNesta_IRFS_16.Book" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Book.book_guia1_lbl1_guide %>';
                    break;
                case 'lbl2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Book.book_guia1_lbl2_guide %>';
                    break;
                case 'grid1':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Book.book_guia2_grid1_guide %>';
                    break;
                case 'grid2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Book.book_guia2_grid2_guide %>';
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
    <asp:HiddenField ID="hfBOIDBOOK" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
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
                                    <label id="lblquickGuide"><%=Resources.GlobalResource.quickguide_inicial %></label>
                                </div>
                                <div class="card-footer bg-transparent quickGuide-footer">
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Book, book_content_tutorial %>" />
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
                                <asp:Label ID="Label24" runat="server" CssClass="labels" Text="<%$Resources:Book, book_guia1 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                        </div>
                        <div class="card-body p-0 pl-3">
                            <div class="row p-0 m-0">
                                <div class="col-x2 p-0">
                                    <asp:Label ID="Label9" runat="server" Text="<%$Resources:Book, book_guia1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px" onmouseover="QuickGuide('lbl1');">
                                        <asp:TextBox ID="txtNome" ClientIDMode="Static" MaxLength="40" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <asp:Label ID="Label4" runat="server" Text="<%$Resources:Book, book_guia1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px" onmouseover="QuickGuide('lbl2');">
                                        <asp:TextBox ID="txtNome20" ClientIDMode="Static" MaxLength="20" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                                <div class="col-x1 p-0">
                                    <br />
                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                        <asp:TextBox ID="TextBox2" ClientIDMode="Static" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-x0"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row card border-0 bg-transparent p-0">
                        <div class="card-header bg-transparent ">
                            <h5 style="text-align: left; float: left;">
                                <asp:Label ID="Label1" runat="server" CssClass="labels" Text="<%$Resources:Book, book_guia2 %>" Style="color: #666666; font-size: 16pt"></asp:Label></h5>
                        </div>
                        <div class="card-body p-0 pl-3">
                            <div class="row p-0">
                                <div class="col-lg-6 card bg-transparent">
                                    <div class="card-body bg-transparent p-0 " onmouseover="QuickGuide('grid1');">
                                        <dx:ASPxGridView ID="gridAssociadas" Enabled="false" CssClass="mt-1" ClientInstanceName="gridAssociadas" Theme="Material" runat="server" AutoGenerateColumns="False"
                                            Width="100%" DataSourceID="sqlAssociadas" KeyFieldName="CAIDCTRA" OnCustomCallback="gridAssociadas_CustomCallback" OnLoad="gridAssociadas_Load">
                                            <ClientSideEvents RowDblClick="function (s,e) {
                                                gridAssociadas.PerformCallback('delete#'+e.visibleIndex);
                                                }"
                                                EndCallback="function (s,e) { 
                                                if(s.cp_ok=='OK'){
                                                s.Refresh(); 
                                                gridDisponiveis.Refresh(); 
                                                delete(s.cp_ok);
                                                }
                                                }"/>
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
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
                                                <dx:GridViewDataTextColumn FieldName="CADSAB20" Width="100%" VisibleIndex="0" Caption="<%$Resources:Book, book_guia2_grid1 %>"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CAIDCTRA" Visible="false" VisibleIndex="1"></dx:GridViewDataTextColumn>
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
                                        <asp:SqlDataSource runat="server" ID="sqlAssociadas" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select C.CADSAB20,C.CAIDCTRA from CACTEIRA C
INNER JOIN VIBOOCAR V ON C.CAIDCTRA=V.CAIDCTRA AND V.BOIDBOOK=?">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfBOIDBOOK" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </div>
                                <div class="col-lg-6 card bg-transparent">
                                    <div class="card-body bg-transparent p-0" onmouseover="QuickGuide('grid2');">
                                        <dx:ASPxGridView ID="gridDisponiveis" Enabled="false" CssClass="mt-1" ClientInstanceName="gridDisponiveis" Theme="Material" runat="server" AutoGenerateColumns="False"
                                            Width="100%" DataSourceID="sqlDisponiveis" KeyFieldName="CAIDCTRA" OnCustomCallback="gridDisponiveis_CustomCallback" OnLoad="gridDisponiveis_Load">
                                            <ClientSideEvents RowDblClick="function (s,e) {
                                                gridDisponiveis.PerformCallback('assoc#'+e.visibleIndex);
                                                }"
                                                EndCallback="function (s,e) { 
                                                if(s.cp_ok=='OK'){
                                                s.Refresh(); 
                                                gridAssociadas.Refresh(); 
                                                delete(s.cp_ok);
                                                }
                                                }" />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Settings VerticalScrollableHeight="150" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" HorizontalScrollBarMode="Auto" />
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
                                                <dx:GridViewDataTextColumn FieldName="CADSAB20" Width="100%" Caption="<%$Resources:Book, book_guia2_grid2 %>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CAIDCTRA" Visible="false" ReadOnly="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
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
                                        <asp:SqlDataSource runat="server" ID="sqlDisponiveis" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select C.CADSAB20,C.CAIDCTRA from CACTEIRA C
WHERE C.CAIDCTRA NOT in (SELECT v.CAIDCTRA FROM VIBOOCAR V )">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfBOIDBOOK" PropertyName="Value" Name="?"></asp:ControlParameter>
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
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="Cadastro Book" CssClass="labels text-left"></asp:Label></h5>
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
                    SelectCommand="select BODSBOOK,C.BOIDBOOK from BOBOBOOK C ORDER BY 1
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
                <asp:Button ID="btnExcluir" Enabled="false" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" CommandArgument="excluir" OnCommand="BotoesOperacao" OnLoad="btnExcluir_Load"/>

            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 7px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnAlterar" Enabled="false" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" CommandArgument="alterar" OnCommand="BotoesOperacao" OnLoad="btnAlterar_Load"/>

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
