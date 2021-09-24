<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Workflow.aspx.cs" Inherits="WebNesta_IRFS_16.Workflow" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'opcao':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Workflow.workflow_opcao_guide %>';
                    break;
                case 'opcao1':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Workflow.workflow_opcao1_guide %>';
                    break;
                case 'opcao2':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Workflow.workflow_opcao2_guide %>';
                    break;
                case 'opcao3':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Workflow.workflow_opcao3_guide %>';
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
    <asp:HiddenField ID="hfUser" runat="server" />
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Workflow, workflow_content_tutorial %>" />
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
            <asp:Button ID="btnPostBack" ClientIDMode="Static" CssClass="Loading d-none" runat="server" Text="Button" />
            <div class="col-sm-10 pl-4 pr-0">
                <div class="row pt-0 mt-0 pl-2">
                    <div class="card bg-transparent w-100">
                        <div class="card-header bg-transparent border-0 p-0">
                            <div class="container">
                                <div class="row p-0">
                                    <div class="col-2">
                                        <h5>
                                            <asp:Label ID="Label7" runat="server" Text="Workflow"></asp:Label>
                                        </h5>
                                    </div>
                                    <div class="col-8 p-0" onmouseover="QuickGuide('opcao');">
                                        <dx:ASPxRadioButtonList ID="radioExibir" RepeatDirection="Horizontal" CssClass="m-0 p-0 border-0" AutoPostBack="true" runat="server" ValueType="System.Int32"
                                            Font-Size="10pt" Theme="Office365" Paddings-Padding="0px" OnLoad="radioExibir_Load" OnSelectedIndexChanged="radioExibir_SelectedIndexChanged">
                                            <Items>
                                                <dx:ListEditItem Text="<%$Resources:Workflow, workflow_opcao1 %>" Value="1" />
                                                <dx:ListEditItem Text="<%$Resources:Workflow, workflow_opcao2 %>" Value="2" />
                                                <dx:ListEditItem Text="<%$Resources:Workflow, workflow_opcao3 %>" Value="3" />
                                            </Items>
                                        </dx:ASPxRadioButtonList>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body bg-transparent p-0">
                            <asp:MultiView ID="mvWflow" runat="server" OnLoad="mvWflow_Load">
                                <asp:View ID="v_emissao" runat="server">
                                    <div onmouseover="QuickGuide('opcao1');">
                                    <dx:ASPxGridView ID="gridWF" CssClass="bg-transparent" ClientInstanceName="gridWF" EnableViewState="false" ClientIDMode="Static" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                        DataSourceID="sqlWF" OnHtmlRowPrepared="gridWF_HtmlRowPrepared" OnCustomButtonCallback="gridWF_CustomButtonCallback">
                                        <ClientSideEvents EndCallback="function(s, e) {
                                        var element = document.getElementById('lblMsgException');
	                                    if (s.cp_origem == 'notify') {
                                            if(s.cp_ok=='OK')
                                            {
                                                s.Refresh();
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                         
                                    if (s.cp_origem == 'analitico') {
                                            if(s.cp_ok=='OK')
                                            {
                            document.getElementById('hfOPIDCONTGridAnalitico').value = s.cp_opidcont;
                            gridWfAnalitico.Refresh();
                                                popupWFAnalitico.Show();
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                    }"></ClientSideEvents>
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings VerticalScrollableHeight="350" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
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
                                            <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="80px" Caption="Contrato" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="OPNMCONT" Width="200px" Caption="Descrição Contrato" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="WFDSFLOW" Width="150px" Caption="Modo" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="USNMPRUS" Width="120px" Caption="Endereçado" VisibleIndex="3"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="WFDTTASK" Width="120px" Caption="Prazo" VisibleIndex="4"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn FieldName="REDTRECH" Width="120px" Caption="Chaves" VisibleIndex="5"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="WFDSSTAT" Width="100px" Caption="Situação" VisibleIndex="6"></dx:GridViewDataTextColumn>
                                            <dx:GridViewCommandColumn VisibleIndex="7" Caption=" " Width="80px" ButtonRenderMode="Image">
                                                <CustomButtons>
                                                    <dx:GridViewCommandColumnCustomButton ID="analitico" Text="Analitico">
                                                        <Image Url="icons/grid_analitico.png" Width="30px" ToolTip="Analítico"></Image>
                                                    </dx:GridViewCommandColumnCustomButton>
                                                    <dx:GridViewCommandColumnCustomButton ID="notify" Text="Notificar">
                                                        <Image Url="icons/grid_notify.png" Width="30px" ToolTip="Notificar"></Image>
                                                    </dx:GridViewCommandColumnCustomButton>
                                                </CustomButtons>
                                            </dx:GridViewCommandColumn>
                                            <dx:GridViewDataTextColumn FieldName="USIDUSUA" Width="120px" VisibleIndex="8" Visible="false"></dx:GridViewDataTextColumn>
                                        </Columns>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <Header Font-Names="Arial" Font-Size="10pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                                            </Row>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource runat="server" ID="sqlWF" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="SELECT O.OPIDCONT, O.OPNMCONT, WF.WFDSFLOW, U.USNMPRUS, W.WFDTTASK, convert(datetime,R.REDTRECH) REDTRECH, S.WFDSSTAT,W.USIDUSUA
FROM dbo.OPCONTRA AS O INNER JOIN
dbo.WFTASKOP AS W ON O.OPIDCONT = W.OPIDCONT INNER JOIN
dbo.TUSUSUARI AS U ON W.USIDUSUA = U.USIDUSUA INNER JOIN
dbo.WFPRIORI AS P ON W.WFIDPRIO = P.WFIDPRIO INNER JOIN
dbo.WORKFLOW AS WF ON WF.WFIDFLOW = W.WFIDFLOW INNER JOIN
dbo.WFSTATUS AS S ON W.WFSTTASK = S.WFIDSTAT INNER JOIN
dbo.REVIOPIM AS V ON V.OPIDCONT=O.OPIDCONT INNER JOIN
dbo.REPOSSES AS R ON V.REIDIMOV=R.REIDIMOV
WHERE (W.WFSTTASK = 0)
and O.USIDUSUA=?">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
</div>
                                </asp:View>
                                <asp:View ID="v_administra" runat="server">
                                    <div onmouseover="QuickGuide('opcao2');">
                                    <dx:ASPxGridView ID="gridWFAdmin" CssClass="bg-transparent" KeyFieldName="ALIDALSQ" ClientInstanceName="gridWFAdmin" EnableViewState="false" ClientIDMode="Static" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                        DataSourceID="sqlWFAdmin" OnHtmlRowPrepared="gridWFAdmin_HtmlRowPrepared" OnCustomButtonCallback="gridWFAdmin_CustomButtonCallback" OnCustomButtonInitialize="gridWFAdmin_CustomButtonInitialize">
                                        <ClientSideEvents EndCallback="function(s, e) {
	                                    if (s.cp_origem == 'notify2') {
                                                if(s.cp_ok=='OK')
                                                {                                            
                                                    s.Refresh();
                                                    delete(s.cp_origem);
                                                    delete(s.cp_ok);
                                            document.getElementById('btnPostBack').click();
                                                }
                                     }
                                            else if (s.cp_origem == 'aprovar2') {
                                                if(s.cp_ok=='OK')
                                                {
                                                    s.Refresh();
                                                    delete(s.cp_origem);
                                                    delete(s.cp_ok);
                                                }
                                            }
                                            else if (s.cp_origem == 'recusar2') {
                                                if(s.cp_ok=='OK')
                                                {
                                                    s.Refresh();
                                                    delete(s.cp_origem);
                                                    delete(s.cp_ok);
                                                }
                                     }
                                    }"></ClientSideEvents>
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings VerticalScrollableHeight="350" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
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
                                            <dx:GridViewDataTextColumn FieldName="USIDUSUA" Visible="false" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="120px" Caption="Contrato" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataDateColumn FieldName="ALDTEXPI" Width="120px" Caption="Prazo" VisibleIndex="3"></dx:GridViewDataDateColumn>
                                            <dx:GridViewCommandColumn VisibleIndex="6" Caption=" " Width="120px" ButtonRenderMode="Image">
                                                <CustomButtons>
                                                    <dx:GridViewCommandColumnCustomButton ID="aprovar2" Text="Aprovar">
                                                        <Image Url="icons/grid_aprova.png" Width="20px" ToolTip="Aprovar"></Image>
                                                    </dx:GridViewCommandColumnCustomButton>
                                                    <dx:GridViewCommandColumnCustomButton ID="recusar2" Text="Recusar">
                                                        <Image Url="icons/grid_recusa.png" Width="20px" ToolTip="Recusar"></Image>
                                                    </dx:GridViewCommandColumnCustomButton>
                                                    <dx:GridViewCommandColumnCustomButton ID="notify2" Text="Notificar">
                                                        <Image Url="icons/grid_notify.png" Width="30px" ToolTip="Notificar"></Image>
                                                    </dx:GridViewCommandColumnCustomButton>
                                                </CustomButtons>
                                            </dx:GridViewCommandColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="ALRENOVA" Width="120px" Caption="Recorrente" VisibleIndex="4">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Sim" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="N&#227;o" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="ALSTATUS" Width="120px" Caption="Situa&#231;&#227;o" VisibleIndex="5">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Conclu&#237;do" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="Recusado" Value="-1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="Em Andamento" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="DNIDDENU" Width="180px" Caption="Den&#250;ncia" VisibleIndex="0">
                                                <PropertiesComboBox DataSourceID="sqlDen" TextField="DNDNDECR" ValueField="DNIDDENU"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="REIDIMOV" Width="180px" Caption="Im&#243;vel" VisibleIndex="1">
                                                <PropertiesComboBox DataSourceID="sqlImov" TextField="REREGIAO" ValueField="REIDIMOV"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <Header Font-Names="Arial" Font-Size="10pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                                            </Row>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource runat="server" ID="sqlWFAdmin" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select DNIDDENU,REIDIMOV,OPIDCONT,convert(datetime,A.ALDTEXPI) as ALDTEXPI,ALRENOVA,ALSTATUS,A.ALIDALSQ,USIDUSUA from DNALERTA A
where A.USIDUSUA=?
  AND A.ALSTATUS &lt; 1
  AND ALDTINIC &lt; GETDATE()">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource runat="server" ID="sqlImov" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select REIDIMOV,REREGIAO from REIMOVEL ORDER BY 2">
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource runat="server" ID="sqlDen" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select DNIDDENU,DNDNDECR from DENUNCIA order by 2">
                                    </asp:SqlDataSource>
                                        </div>
                                </asp:View>
                                <asp:View ID="v_acoes" runat="server">
                                    <div onmouseover="QuickGuide('opcao3');">
                                    <dx:ASPxGridView ID="gridAcoes" CssClass="bg-transparent" ClientInstanceName="gridAcoes" EnableViewState="false" ClientIDMode="Static" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                        DataSourceID="sqlAcoes" KeyFieldName="ALIDALSQ" OnBatchUpdate="gridAcoes_BatchUpdate" >
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings VerticalScrollableHeight="320" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
                                        <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                        </SettingsPager>
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
                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowDeleteButton="True" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataDateColumn FieldName="ALDTINIC" Caption="Início Tarefa" Width="120px" VisibleIndex="4">
                                                <PropertiesDateEdit>
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                </PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn FieldName="ALDTEXPI" Caption="Prazo" Width="120px" VisibleIndex="5">
                                                <PropertiesDateEdit>
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                </PropertiesDateEdit>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="DNIDDENU" Caption="Denúncia" Width="120px" VisibleIndex="1">
                                                <PropertiesComboBox DataSourceID="sqlDenuncias" TextField="DNDNDECR" ValueField="DNIDDENU">
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="REIDIMOV" Caption="Imóvel" Width="180px" VisibleIndex="2">
                                                <PropertiesComboBox DataSourceID="sqlImov" TextField="REREGIAO" ValueField="REIDIMOV"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="OPIDCONT" Caption="Contrato" Width="180px" VisibleIndex="3">
                                                <PropertiesComboBox DataSourceID="sqlOPCONTRA" TextField="OPNMCONT" ValueField="OPIDCONT"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="ALRENOVA" Caption="Recorrente" Width="120px" VisibleIndex="6">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Sim" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="N&#227;o" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                    <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic"></ValidationSettings>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>

                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <Header Font-Names="Arial" Font-Size="10pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                                            </Row>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource runat="server" ID="sqlAcoes" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="SELECT ALIDALSQ,DNIDDENU,REIDIMOV,OPIDCONT,ALDTINIC,ALDTEXPI,ALRENOVA FROM DNALERTA
WHERE USIDUSUA=? AND DNIDDENU IN (SELECT DNIDDENU FROM DENUNCIA WHERE DNVIENCE=0 AND DNVIIPTU=0 AND DNVISEGU=0)
AND ALSTATUS &lt; 1">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource runat="server" ID="sqlOPCONTRA" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select OPNMCONT,OPIDCONT from OPCONTRA where OPTPTPID=1 and USIDUSUA=?">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource runat="server" ID="sqlDenuncias" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="SELECT DNIDDENU,DNDNDECR FROM DENUNCIA WHERE DNVIENCE=0 AND DNVIIPTU=0 AND DNVISEGU=0">
                                    </asp:SqlDataSource>
                                        </div>
                                </asp:View>
                            </asp:MultiView>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <dx:ASPxPopupControl ID="popupWFAnalitico" ClientInstanceName="popupWFAnalitico" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Visão Analítica" Modal="true" Width="500px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <asp:HiddenField ID="hfOPIDCONTGridAnalitico" ClientIDMode="Static" runat="server" />
                <dx:ASPxGridView ID="gridWfAnalitico" ClientInstanceName="gridWfAnalitico" KeyFieldName="WFIDTASK" ClientIDMode="Static" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlWWF"
                    OnCustomButtonCallback="gridWfAnalitico_CustomButtonCallback" OnCustomButtonInitialize="gridWfAnalitico_CustomButtonInitialize">
                    <ClientSideEvents EndCallback="function(s, e) {
                                        var element = document.getElementById('lblMsgException');
	                                    if (s.cp_origem == 'alterar') {
                                            dropResponsavel2.SetValue((s.cp_responsavel));
                                            dropPriori.SetValue((s.cp_prioridade));
                                            txtDataPrazo.SetText((s.cp_prazo));
                                            document.getElementById('hfIndexGridWF').value = s.cp_visibleIndex;
                                            popupAlterarWF.Show();
                                            delete(s.cp_visibleIndex);
                                            delete(s.cp_origem);
                                            delete(s.cp_responsavel);
                                            delete(s.cp_prioridade);
                                            delete(s.cp_prazo);
                                     } 
                                        else if (s.cp_origem == 'aprovar') {
                                            if(s.cp_ok=='OK')
                                            {
                                                element.classList.add('text-sucess');
                                                element.innerHTML = 'Notificação enviada por SMS / E-mail.';
                                                openModal();
                                                s.Refresh();
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                        else if (s.cp_origem == 'recusar') {
                                            if(s.cp_ok=='OK')
                                            {
                                                element.classList.add('text-sucess');
                                                element.innerHTML = 'Notificação enviada por SMS / E-mail.';
                                                openModal();
                                                s.Refresh();
                                                delete(s.cp_origem);
                                                delete(s.cp_ok);
                                            }
                                     } 
                                    }"></ClientSideEvents>
                    <SettingsPopup>
                        <HeaderFilter MinHeight="140px">
                        </HeaderFilter>
                    </SettingsPopup>
                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                    <SettingsPager NumericButtonCount="20" PageSize="20">
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
                        <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="100px" Caption="Contrato" VisibleIndex="0" EditFormSettings-Visible="False">
                            <CellStyle HorizontalAlign="Center"></CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="OPNMCONT" Width="200px" Caption="Descrição" VisibleIndex="1" EditFormSettings-Visible="False">
                            <CellStyle Wrap="True"></CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="WFDTTASK" Width="100px" Caption="Prazo" VisibleIndex="5" EditFormSettings-Visible="False"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="USIDUSUA" Width="100px" Caption="Endereçado" VisibleIndex="2">
                            <PropertiesComboBox DataSourceID="sqlResponsavel" TextField="USNMPRUS" ValueField="USIDUSUA" ValueType="System.String"></PropertiesComboBox>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="WFIDPRIO" Width="70px" Caption="Prioridade" VisibleIndex="3">
                            <PropertiesComboBox DataSourceID="sqlPriori" TextField="WFNMPRIO" ValueField="WFIDPRIO" ValueType="System.String"></PropertiesComboBox>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="WFIDFLOW" Width="100px" Caption="Modo" VisibleIndex="4">
                            <PropertiesComboBox DataSourceID="sqlModo" TextField="WFDSFLOW" ValueField="WFIDFLOW" ValueType="System.String"></PropertiesComboBox>
                            <EditFormSettings Visible="False"></EditFormSettings>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="WFSTTASK" Width="100px" Caption="Status" VisibleIndex="6">
                            <PropertiesComboBox DataSourceID="sqlStatus" TextField="WFDSSTAT" ValueField="WFIDSTAT"></PropertiesComboBox>
                            <PropertiesComboBox>
                            </PropertiesComboBox>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewCommandColumn Caption=" " VisibleIndex="7" Width="150px" ButtonRenderMode="Image">
                            <CellStyle Paddings-Padding="2px"></CellStyle>
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="aprovar" Text="Aprovar">
                                    <Image Url="icons/grid_aprova.png" Width="20px" ToolTip="Aprovar"></Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="recusar" Text="Recusar">
                                    <Image Url="icons/grid_recusa.png" Width="20px" ToolTip="Recusar"></Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                    </Columns>
                    <Styles>
                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                        <Header Font-Names="Arial" Font-Size="12pt" BackColor="#669999" ForeColor="White" Paddings-Padding="1px">
                        </Header>
                        <Row Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                        </Row>
                        <AlternatingRow Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                        <BatchEditCell Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                            <Paddings Padding="0px" />
                        </BatchEditCell>
                        <DetailButton Paddings-Padding="0px"></DetailButton>
                        <FocusedCell Font-Names="Arial" Font-Size="11pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                        <EditForm Paddings-Padding="0px"></EditForm>
                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                        <Table></Table>
                        <Cell Paddings-Padding="2px"></Cell>
                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                    </Styles>
                </dx:ASPxGridView>
                <asp:SqlDataSource runat="server" ID="sqlPriori" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="select WFNMPRIO,WFIDPRIO from WFPRIORI"></asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="sqlStatus" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="SELECT WFIDSTAT,WFDSSTAT FROM WFSTATUS"></asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="sqlWWF" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="select WFIDTASK,OPIDCONT,OPNMCONT,USIDUSUA,WFIDPRIO,WFIDFLOW,WFDTTASK,WFSTTASK from wftaskop
where opidcont=?">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfOPIDCONTGridAnalitico" PropertyName="Value" Name="?"></asp:ControlParameter>


                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="sqlModo" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="SELECT WFDSFLOW,WFIDFLOW FROM WORKFLOW order by 2"></asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="sqlResponsavel" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                    SelectCommand="select USNMPRUS,USIDUSUA from TUSUSUARI 
WHERE USIDUSUA NOT IN (SELECT CONVERT(CHAR,TBIDUSER) FROM TBTBUSER)
UNION
SELECT TBFNUSER,convert(char,TBIDUSER) FROM TBTBUSER"></asp:SqlDataSource>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
