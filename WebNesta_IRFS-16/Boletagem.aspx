<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Boletagem.aspx.cs" Inherits="WebNesta_IRFS_16.Boletagem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function DataCallback(result) {
            var results = result.split("#");
            if (results[0].toString() == 'valor') {
                gridVerbas.batchEditApi.EndEdit();
                gridVerbas.batchEditApi.SetCellValue(startIndex, results[0].toString(), results[1]);
                var keyIndex = gridVerbas.GetColumnByField(results[0].toString()).index;
                gridVerbas.batchEditApi.StartEdit(startIndex, keyIndex);
                var editor = gridVerbas.GetEditor('valor');
                if (results[2].toString() == '25700' || results[2].toString() == '25702' || results[2].toString() == '25703') {
                    editor.SetReadOnly(true);
                }
            }
            else if (results[0].toString() == 'data_venc') {
                gridVerbas.batchEditApi.EndEdit();
                var d = new Date(results[1].toString());
                gridVerbas.batchEditApi.SetCellValue(startIndex, results[0].toString(), d);
                var keyIndex = gridVerbas.GetColumnByField(results[0].toString()).index;
                gridVerbas.batchEditApi.StartEdit(startIndex, keyIndex);
                var editor = gridVerbas.GetEditor('data_venc');
                editor.SetReadOnly(true);
            }
            else if (results[0].toString() == 'valor2') {
                gridEntry.batchEditApi.EndEdit();
                gridEntry.batchEditApi.SetCellValue(startIndex2, 'valor', results[1]);
                var keyIndex = gridEntry.GetColumnByField('valor').index;
                gridEntry.batchEditApi.StartEdit(startIndex2, keyIndex);
                var editor = gridEntry.GetEditor('valor');
                //if (results[2].toString() == '25700' || results[2].toString() == '25702' || results[2].toString() == '25703') {
                //    editor.SetReadOnly(true);
                //}
            }
        }
        function DataCallback2(result) {
            var results = result.split("#");
            if (results[0].toString() == 'item') {
                gridMedicao.batchEditApi.EndEdit();
                gridMedicao.batchEditApi.SetCellValue(startIndexgridMedicao, 'contratada', results[1]);
                gridMedicao.batchEditApi.SetCellValue(startIndexgridMedicao, 'saldo', results[2]);
                gridMedicao.batchEditApi.SetCellValue(startIndexgridMedicao, 'preco', results[3]);
                var contratada = gridMedicao.GetEditor('contratada');
                contratada.SetReadOnly(true);
                var saldo = gridMedicao.GetEditor('saldo');
                saldo.SetReadOnly(true);
                var preco = gridMedicao.GetEditor('preco');
                preco.SetReadOnly(true);
            }
            else if (results[0].toString() == 'quantidade') {
                gridMedicao.batchEditApi.EndEdit();
                gridMedicao.batchEditApi.SetCellValue(startIndexgridMedicao, 'total', results[1]);
                var total = gridMedicao.GetEditor('total');
                total.SetReadOnly(true);

            }
        }
        function onKeyPress(s, e) {
            if (e.htmlEvent.keyCode == 13)
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
        }
        function GetBoleto(s, e) {
            var layout = listLayout.GetValue();
            var leitura = listLeitura.GetValue();
            if (leitura == 2) {//digitado
                if (layout == 1) {//arrecadacao
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var today = new Date();
                    var date = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds(), today.getMilliseconds());
                    date.setDate(date.getDate() + parseInt(0));
                    txtDtVenc.SetDate(date);
                    var teste = barra.replace(/ /g, '').replace(/-/g, '');
                    teste = teste.substring(4, 16);
                    var teste2 = teste.substring(0, 6) + teste.substring(8, 16);
                    var valor = parseFloat(teste2).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
                else if (layout == 2) {//bancario
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var date = new Date('10/07/1997');
                    date.setDate(date.getDate() + parseInt(vencimento));
                    txtDtVenc.SetDate(date);
                    var valor = parseFloat(barra.substring(barra.length - 10, barra.length)).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
            }
            else if (leitura == 1) {//leitor
                if (layout == 1) { //Arrecadacao
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var today = new Date();
                    var date = new Date(today.getFullYear(), today.getMonth(), today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds(), today.getMilliseconds());
                    date.setDate(date.getDate() + parseInt(0));
                    txtDtVenc.SetDate(date);
                    var valor = parseFloat(barra.substring(4, 15)).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
                else if (layout == 2) {//bancario
                    var barra = s.GetText();
                    var vencimento = barra.slice(40, 44); // captura 6075 
                    var date = new Date('10/07/1997');
                    date.setDate(date.getDate() + parseInt(vencimento));
                    txtDtVenc.SetDate(date);
                    var valor = parseFloat(barra.substring(barra.length - 10, barra.length)).toString(); // uso parseFloat parar retirar os zeros e toString para converter novamente em string
                    if (valor.length == 2) { // verifica se linha tem apenas 2 caracteres
                        var valor_final = "0," + valor; // coloca o zero na frente
                    } else if (valor.length == 1) { // verifica se linha tem apenas 1 caractere
                        var valor_final = "0,0" + valor; // coloca o 0,0 na frente
                    } else {
                        // qualquer outro valor ganha a mesma formatação
                        var valor_final = valor.substring(0, valor.length - 2) + "," + valor.substring(valor.length - 2, valor.length);
                    }
                    txtBoletoTotal.SetText(valor_final.toString());
                }
            }
            document.getElementById('hfBoleto').value = s.GetText();
        }
    </script>
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'menu':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Boletagem.boletagem_opcoes_1_guide%>';
                    break;
                case 'menu1_grid':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Boletagem.boletagem_grid1_guide%>';
                    break;
                case 'menu2_lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Boletagem.boletagem_opcoes_2_lbl1_guide%>';
                    break;
                case 'menu2_grid':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Boletagem.boletagem_grid2_guide%>';
                    break;
                case 'menu3_lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Boletagem.boletagem_opcoes_3_lbl1_guide%>';
                    break;
                case 'menu3_lbl2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Boletagem.boletagem_opcoes_3_lbl2_guide%>';
                    break;
                case 'menu3_grid':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Boletagem.boletagem_grid3_guide%>';
                    break;
            }

        }
        function OnAllCheckedChanged(s, e) {
            document.getElementById('hfAllRows').value = s.GetChecked();
            gridToday.PerformCallback("AllRows");
        }
        function OnAllCheckedChanged2(s, e) {
            document.getElementById('hfAllRows').value = s.GetChecked();
            gridDebiAuto.PerformCallback("AllRows");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfAllRows" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfMoidmoda" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfLoja" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfOpidcont" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfBoleto" ClientIDMode="Static" runat="server" />
    <asp:SqlDataSource ID="sqlLoja" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select TV.TVIDESTR,FO.FONMAB20 from TVESTRUT TV, FOFORNEC FO
WHERE TV.TVIDESTR = FO.TVIDESTR
  AND FOTPIDTP=6
ORDER BY 2"></asp:SqlDataSource>
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Boletagem, boletagem_content_tutorial %>" />
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
                            <div class="row">
                                <div class="col-2">
                                    <h4>
                                        <asp:Label ID="Label1" runat="server" CssClass="labels text-left" Text="<%$Resources:Boletagem, boletagem_titulo %>"></asp:Label></h4>
                                </div>
                                <div class="col-10" onmouseover="QuickGuide('menu');">
                                    <dx:ASPxRadioButtonList ID="radioExibir" Caption="<%$Resources:Boletagem, boletagem_opcoes_1 %>" RepeatDirection="Horizontal" CssClass="m-0 p-0 border-0" runat="server" ValueType="System.Int32"
                                        AutoPostBack="true" OnSelectedIndexChanged="radioExibir_SelectedIndexChanged">
                                        <Items>
                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_opcoes_2 %>" Value="1" />
                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_opcoes_3 %>" Value="2" />
                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_opcoes_4 %>" Value="3" />
                                        </Items>
                                        <CaptionStyle Font-Size="10pt"></CaptionStyle>
                                    </dx:ASPxRadioButtonList>
                                </div>
                            </div>
                        </div>
                        <div class="card-body bg-transparent pt-1">
                            <asp:MultiView ID="mvBoletagem" runat="server">
                                <asp:View ID="vw_dataentry" runat="server">
                                    <div onmouseover="QuickGuide('menu1_grid')">
                                        <dx:ASPxGridView ID="gridVerbas" CssClass="bg-transparent " KeyFieldName="idseq" ClientInstanceName="gridVerbas" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                            DataSourceID="sqlDataEntry" OnBatchUpdate="gridVerbas_BatchUpdate" OnCustomButtonInitialize="gridVerbas_CustomButtonInitialize" OnCustomDataCallback="gridVerbas_CustomDataCallback" OnCustomButtonCallback="gridVerbas_CustomButtonCallback" OnLoad="gridVerbas_Load">
                                            <ClientSideEvents BatchEditStartEditing=" function(s,e) {
                                                    startIndex = e.visibleIndex; }"
                                                EndCallback="function(s,e) { 
                                            if (s.cpIsCustomCallback=='CustomCallbackFluxo')
                                            {
                                                gridFaturamento.Refresh();
                                                popupFluxoComplemento.Show();
                                            }
                                            } " />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsText Title="<%$Resources:Boletagem, boletagem_grid1 %>" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Settings VerticalScrollableHeight="180" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />

                                            <SettingsBehavior AllowFocusedRow="true" />
                                            <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                            </SettingsPager>
                                            <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="false" />
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
                                                <dx:GridViewCommandColumn Caption=" " ShowNewButtonInHeader="False" VisibleIndex="0" ShowDeleteButton="False" ButtonRenderMode="Image">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="fluxo" Text="Faturamento">
                                                            <Image ToolTip="Faturamento" Url="icons/icons8-profit-report-40.png" Width="15px"></Image>
                                                        </dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn FieldName="usidusua" ReadOnly="True" EditFormSettings-Visible="False" VisibleIndex="7" Caption="Usu&#225;rio"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="valor" VisibleIndex="8" Caption="Valor">
                                                    <PropertiesTextEdit DisplayFormatString="{0:N2}" DisplayFormatInEditMode="true">
                                                        <MaskSettings Mask="&lt;0..99999g&gt;.&lt;00..99&gt;" IncludeLiterals="DecimalSymbol" />
                                                    </PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="bolidbol" ReadOnly="True" EditFormSettings-Visible="False" Caption="Origem" VisibleIndex="3">
                                                    <PropertiesComboBox DataSourceID="sqlBoletos" TextField="bolnmbol" ValueField="bolidbol">
                                                        <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            var newValueOfComboBox = 'bolidbol#'+s.GetValue();                                    
            gridVerbas.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataDateColumn FieldName="data" ReadOnly="True" EditFormSettings-Visible="False" Caption="Compet&#234;ncia" VisibleIndex="5">
                                                    <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                        <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                            <MonthGridPaddings Padding="0px" />
                                                            <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                        </CalendarProperties>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataDateColumn FieldName="data_venc" ReadOnly="True" EditFormSettings-Visible="False" Caption="Vencimento" VisibleIndex="6">
                                                    <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                        <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                            <MonthGridPaddings Padding="0px" />
                                                            <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                        </CalendarProperties>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="moidmoda" ReadOnly="True" EditFormSettings-Visible="False" Caption="Verbas" VisibleIndex="4">
                                                    <PropertiesComboBox DataSourceID="sqlVerbas" TextField="MODSMODA" ValueField="MOIDMODA">
                                                        <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            document.getElementById('hfMoidmoda').value = s.GetValue();
        }" />
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="opidcont" ReadOnly="True" EditFormSettings-Visible="False" Caption="Contrato" VisibleIndex="2">
                                                    <PropertiesComboBox DataSourceID="sqlContratos" TextField="opcdcont" ValueField="opidcont">
                                                        <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
            var newValueOfComboBox = 'moidmoda#'+document.getElementById('hfMoidmoda').value+'#'+s.GetValue();                                    
            gridVerbas.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="TVIDESTR" EditFormSettings-Visible="False" Caption="Loja" VisibleIndex="1">
                                                    <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR"></PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
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
                                                        <dx:ASPxButton ID="btnNovaVerba" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:Boletagem, boletagem_grid1_btn1 %>" ClientSideEvents-Click="function(s, e){ popupNovaVerba.Show(); }">

                                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                        <dx:ASPxButton ID="btnNovoBoleto" runat="server" AutoPostBack="false" Width="100px" CssClass="btn-using" Text="<%$Resources:Boletagem, boletagem_grid1_btn2 %>" ClientSideEvents-Click="function(s, e){ popupNovoBoleto.Show(); }">
                                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                        <dx:ASPxButton ID="btnDebitoAuto" runat="server" AutoPostBack="false" Width="120px" Paddings-Padding="0px" CssClass="btn-using" Text="Débito em Conta" ClientSideEvents-Click="function(s, e){ popupDebitoAuto.Show(); }">
                                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                        <%
                                                            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["tutorial"]))
                                                            {%>


                                                        <dx:ASPxButton ID="btnMedicao" runat="server" AutoPostBack="false" Width="120px" Paddings-Padding="0px" CssClass="btn-using" Text="Medição" ClientSideEvents-Click="function(s, e){ popupMedicao.Show(); }">
                                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                        </dx:ASPxButton>
                                                        <% } %>
                                                        <dx:ASPxButton ID="btnLeitura" runat="server" Visible="false" Width="80px" CssClass="btn-using" Text="Leitura" AutoPostBack="false" ClientSideEvents-Click="function(s, e){ popupLeitura.Show(); }">
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
                                                <EditFormCell Font-Size="8pt"></EditFormCell>
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
                                    </div>
                                </asp:View>
                                <asp:View ID="vw_auditoria" runat="server">
                                    <asp:Label ID="Label9" runat="server" Text="<%$Resources:Boletagem, boletagem_opcoes_3_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                    <div class="input-group" onmouseover="QuickGuide('menu2_lbl1')">
                                        <dx:ASPxDateEdit ID="txtCompet" ForeColor="dimgray" AutoPostBack="true" OnValueChanged="txtCompet_ValueChanged" Theme="Material" Width="50%" runat="server" PickerType="Months">
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
                                    <div onmouseover="QuickGuide('menu2_grid')">
                                        <dx:ASPxGridView ID="gridAuditoria" CssClass="bg-transparent" KeyFieldName="idseq" ClientInstanceName="gridAuditoria" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                            DataSourceID="sqlAuditoria" OnCustomButtonInitialize="gridAuditoria_CustomButtonInitialize" OnCustomButtonCallback="gridAuditoria_CustomButtonCallback" OnHtmlRowPrepared="gridAuditoria_HtmlRowPrepared" OnLoad="gridAuditoria_Load">
                                            <ClientSideEvents BatchEditStartEditing=" function(s,e) {
                                                    startIndex = e.visibleIndex; }"
                                                EndCallback="function(s,e) { 
                                            if (s.cpIsCustomCallback=='CustomCallbackFluxo')
                                            {
                                                popupFluxoComplemento.Show();
                                            }
                                            } " />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px">
                                                </HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsText Title="<%$Resources:Boletagem, boletagem_grid2 %>" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                            <Settings VerticalScrollableHeight="180" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
                                            <SettingsBehavior AllowFocusedRow="true" />
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
                                            <SettingsDataSecurity AllowDelete="False" AllowInsert="False" AllowEdit="False"></SettingsDataSecurity>
                                            <Columns>
                                                <dx:GridViewCommandColumn Caption="A&#231;&#227;o" VisibleIndex="0">
                                                    <CustomButtons>
                                                        <dx:GridViewCommandColumnCustomButton ID="aprovar" Text="<%$Resources:Boletagem, boletagem_grid2_acao2 %>"></dx:GridViewCommandColumnCustomButton>
                                                        <dx:GridViewCommandColumnCustomButton ID="rejeitar" Text="<%$Resources:Boletagem, boletagem_grid2_acao1 %>"></dx:GridViewCommandColumnCustomButton>
                                                    </CustomButtons>
                                                </dx:GridViewCommandColumn>
                                                <dx:GridViewDataTextColumn FieldName="usidusua" ReadOnly="True" EditFormSettings-Visible="False" VisibleIndex="7" Caption="Usu&#225;rio"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="valor" VisibleIndex="8" Caption="Valor">
                                                    <PropertiesTextEdit DisplayFormatString="{0:N2}"></PropertiesTextEdit>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="bolidbol" MaxWidth="100" Width="100px" Caption="Origem" VisibleIndex="3">
                                                    <PropertiesComboBox DataSourceID="sqlBoletos" TextField="bolnmbol" ValueField="bolidbol"></PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataDateColumn FieldName="data" ReadOnly="True" EditFormSettings-Visible="False" Caption="Compet&#234;ncia" VisibleIndex="5">
                                                    <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                        <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                            <MonthGridPaddings Padding="0px" />
                                                            <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                        </CalendarProperties>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataDateColumn FieldName="data_venc" Caption="Vencimento" VisibleIndex="6">
                                                    <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                        <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                            <MonthGridPaddings Padding="0px" />
                                                            <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                        </CalendarProperties>
                                                    </PropertiesDateEdit>
                                                </dx:GridViewDataDateColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="moidmoda" Caption="Verbas" VisibleIndex="4">
                                                    <PropertiesComboBox DataSourceID="sqlVerbas" TextField="MODSMODA" ValueField="MOIDMODA"></PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="opidcont" Caption="Contrato" VisibleIndex="2">
                                                    <PropertiesComboBox DataSourceID="sqlContratos" TextField="opcdcont" ValueField="opidcont"></PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="valida" ReadOnly="True" EditFormSettings-Visible="False" VisibleIndex="9" Caption="Status">
                                                    <PropertiesComboBox>
                                                        <Items>
                                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid2_status2 %>" Value="1" />
                                                            <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid2_status1 %>" Value="0" />
                                                        </Items>
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="TVIDESTR" Caption="Loja" VisibleIndex="1">
                                                    <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR"></PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                            </Columns>
                                            <Styles>
                                                <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                                </Header>
                                                <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="White">
                                                </Row>
                                                <EditFormCell Font-Size="8pt"></EditFormCell>
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
                                    </div>
                                </asp:View>
                                <asp:View ID="vw_today" runat="server">
                                    <div class="card w-100 bg-transparent p-0">
                                        <div class="card-header bg-transparent p-0 border-0">
                                            <div class="row p-0">
                                                <div class="col-lg-4">
                                                    <h6>
                                                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl3 %>" CssClass="labels text-left"></asp:Label></h6>
                                                    <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('menu3_lbl1');">
                                                        <dx:ASPxDateEdit ID="txtDtInicial" Enabled="true" ClientInstanceName="txtDtInicial" UseMaskBehavior="True" ForeColor="dimgray" CssClass="drop-down" Theme="Material"
                                                            Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
                                                            <ClientSideEvents ValueChanged="function(s,e) { gridToday.Refresh(); } " />
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
                                                <div class="col-lg-4">
                                                    <h6>
                                                        <asp:Label ID="Label18" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl4 %>" CssClass="labels text-left"></asp:Label></h6>
                                                    <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('menu3_lbl2');">
                                                        <dx:ASPxDateEdit ID="txtDtFinal" Enabled="true" ClientInstanceName="txtDtFinal" ForeColor="dimgray" UseMaskBehavior="True" CssClass="drop-down" Theme="Material"
                                                            Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
                                                            <ClientSideEvents ValueChanged="function(s,e) { gridToday.Refresh(); } " />
                                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                            </ButtonStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            <DateRangeSettings StartDateEditID="txtDtInicial"></DateRangeSettings>
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
                                                <div class="col-lg-4"></div>
                                            </div>
                                        </div>
                                        <div class="card-body bg-transparent p-0 pt-1">
                                            <div onmouseover="QuickGuide('menu3_grid')">
                                                <dx:ASPxGridView ID="gridToday" CssClass="bg-transparent" KeyFieldName="idseq" ClientInstanceName="gridToday" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                                    DataSourceID="sqlToday" OnLoad="gridToday_Load" OnBatchUpdate="gridToday_BatchUpdate" OnCustomCallback="gridToday_CustomCallback">
                                                    <ClientSideEvents SelectionChanged="function (s,e) {
                                        btnConfirmar.SetEnabled(gridToday.GetSelectedRowCount() &gt; 0);
                                    }" />
                                                    <SettingsPopup>
                                                        <HeaderFilter MinHeight="140px">
                                                        </HeaderFilter>
                                                    </SettingsPopup>
                                                    <SettingsText Title="<%$Resources:Boletagem, boletagem_grid3 %>" BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                    <Settings VerticalScrollableHeight="155" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
                                                    <SettingsBehavior AllowFocusedRow="true" />
                                                    <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                                    </SettingsPager>
                                                    <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Cell" BatchEditSettings-ShowConfirmOnLosingChanges="false" />
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
                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" ShowDeleteButton="True" VisibleIndex="0" Caption=" " Width="70px" ButtonRenderMode="Image">
                                                            <HeaderTemplate>
                                                                <dx:ASPxCheckBox ID="cbAll" runat="server" ClientInstanceName="cbAll" ToolTip="Select all rows" Theme="Material"
                                                                    BackColor="White" OnLoad="cbAll_Load">
                                                                    <ClientSideEvents CheckedChanged="OnAllCheckedChanged" />
                                                                </dx:ASPxCheckBox>
                                                            </HeaderTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                        </dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="usidusua" ReadOnly="True" EditFormSettings-Visible="False" VisibleIndex="6" Caption="Usu&#225;rio"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="valor" Caption="Valor" VisibleIndex="7">
                                                            <PropertiesTextEdit DisplayFormatString="{0:N2}"></PropertiesTextEdit>
                                                        </dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataDateColumn FieldName="data" ReadOnly="True" EditFormSettings-Visible="False" Caption="Compet&#234;ncia" VisibleIndex="4">
                                                            <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                                <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                                    <MonthGridPaddings Padding="0px" />
                                                                    <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                                </CalendarProperties>
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataDateColumn FieldName="data_venc" Caption="Vencimento" VisibleIndex="5">
                                                            <PropertiesDateEdit DisplayFormatString="{0:d}">
                                                                <CalendarProperties ShowClearButton="false" ShowDayHeaders="false" ShowTodayButton="false" ShowWeekNumbers="false">
                                                                    <MonthGridPaddings Padding="0px" />
                                                                    <DayStyle Font-Size="11pt" Paddings-Padding="0px" />
                                                                </CalendarProperties>
                                                            </PropertiesDateEdit>
                                                        </dx:GridViewDataDateColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="moidmoda" ReadOnly="True" EditFormSettings-Visible="False" Caption="Verbas" VisibleIndex="3">
                                                            <PropertiesComboBox DataSourceID="sqlVerbas" TextField="MODSMODA" ValueField="MOIDMODA">
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="opidcont" ReadOnly="True" EditFormSettings-Visible="False" Caption="Contrato" VisibleIndex="2">
                                                            <PropertiesComboBox DataSourceID="sqlContratos" TextField="opcdcont" ValueField="opidcont">
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="TVIDESTR" ReadOnly="True" EditFormSettings-Visible="False" Caption="Loja" VisibleIndex="1">
                                                            <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR"></PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                        <dx:GridViewDataComboBoxColumn FieldName="VITPPGTO" ReadOnly="True" EditFormSettings-Visible="False" Caption="Forma Pagamento" VisibleIndex="8">
                                                            <PropertiesComboBox ValueType="System.Int32">
                                                                <Items>
                                                                    <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item1 %>" Value="1" />
                                                                    <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item2 %>" Value="2" />
                                                                    <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item3 %>" Value="3" />
                                                                </Items>
                                                            </PropertiesComboBox>
                                                        </dx:GridViewDataComboBoxColumn>
                                                    </Columns>
                                                    <Templates>
                                                        <StatusBar>
                                                            <div style="text-align: left">
                                                                <br />
                                                                <dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridToday.UpdateEdit(); }">
                                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                </dx:ASPxButton>
                                                                <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridToday.CancelEdit(); }">
                                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                </dx:ASPxButton>
                                                                <dx:ASPxButton ID="btnConfirmar" ClientInstanceName="btnConfirmar" runat="server" AutoPostBack="true" ClientEnabled="false" Width="120px" CssClass="btn-using" Text="<%$Resources:Boletagem, boletagem_grid3_btn1 %>" OnClick="btnConfirmar_Click">
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
                                                        <EditFormCell Font-Size="8pt"></EditFormCell>
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
                                            </div>
                                        </div>
                                    </div>
                                </asp:View>
                            </asp:MultiView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:SqlDataSource ID="sqlAuditoria" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select bolidbol,moidmoda,convert(datetime,BVDTTRAN) as data,convert(datetime,BVDTVENC) as data_venc,f.opidcont,f.usidusua,BVVLVERB as valor,BVIDSEQU as idseq,BVVALIDA as valida,op.TVIDESTR
from BOLVERBA f
inner join opcontra op on f.opidcont=op.OPIDCONT
where f.opidcont in (select opidcont from opcontra where tvidestr in (select TVIDESTR from VIFSFUSU where USIDUSUA=?))
  and BVDTTRAN between convert(date,?,103) and dateadd(day,-1, dateadd(month,1,convert(date,?,103))) and BVAPROVA=0 and BVFLFLAG=15 order by 4,5,2">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
            <asp:Parameter Name="?"></asp:Parameter>
            <asp:Parameter Name="?"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlDataEntry" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select bolidbol,moidmoda,convert(datetime,BVDTTRAN) as data,convert(datetime,BVDTVENC) as data_venc,f.opidcont,f.usidusua,BVVLVERB as valor,BVIDSEQU as idseq,op.TVIDESTR
from BOLVERBA f
inner join opcontra op on f.opidcont=op.OPIDCONT
where BVVALIDA=0
and f.opidcont in (select opidcont from opcontra where tvidestr in (select TVIDESTR from VIFSFUSU where USIDUSUA=?)) and BVFLFLAG=15 order by 4,5,2">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlToday" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select bolidbol,v.moidmoda,convert(datetime,BVDTTRAN) as data,convert(datetime,BVDTVENC) as data_venc,f.opidcont,f.usidusua,BVVLVERB as valor,BVIDSEQU as idseq,op.TVIDESTR,v.VITPPGTO
from BOLVERBA f
inner join opcontra op on f.opidcont=op.OPIDCONT
inner join VIOPMODA v on f.MOIDMODA=v.MOIDMODA  and OP.OPIDCONT=V.OPIDCONT
where BVVALIDA=0 and bolidbol is null
and f.opidcont in (select opidcont from opcontra where tvidestr in (select TVIDESTR from VIFSFUSU where USIDUSUA=?)) and BVFLFLAG=16 and BVDTVENC BETWEEN ? and ?
order by 4">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
            <asp:ControlParameter ControlID="txtDtInicial" PropertyName="Value" Name="?"></asp:ControlParameter>
            <asp:ControlParameter ControlID="txtDtFinal" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlContratos" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select opcdcont,opidcont from opcontra where tvidestr in (select TVIDESTR from VIFSFUSU where USIDUSUA=?)">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlContratos2" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select opcdcont,opidcont from opcontra where tvidestr =?">
        <SelectParameters>
            <asp:Parameter Name="?"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVerbas" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select distinct m.MOIDMODA,m.MODSMODA from VIOPMODA v, modalida m where v.MOIDMODA=m.MOIDMODA and OPIDCONT in 
(select opidcont from opcontra where tvidestr in (select TVIDESTR from VIFSFUSU where USIDUSUA=?))">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVerbas2" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select distinct m.MOIDMODA,m.MODSMODA from VIOPMODA v, modalida m where v.MOIDMODA=m.MOIDMODA and OPIDCONT = ?">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfOpidcont" PropertyName="Value" Name="?"></asp:ControlParameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlBoletos" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select bolnmbol,bolidbol from boltotbo"></asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlItensMedicaoGrid" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select E.ENDSITEM,F.FRIDITEM from FRFITENS F, ENGENHAR E
WHERE F.OPIDCONT=? AND F.TVIDITEM=E.TVIDITEM AND F.ENCDITEM=E.ENCDITEM">
        <SelectParameters>
            <asp:Parameter Name="?"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="sqlVerbaMedicaoGrid" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="select distinct m.MOIDMODA,m.MODSMODA from VIOPMODA v, modalida m where v.MOIDMODA=m.MOIDMODA and OPIDCONT = ?">
        <SelectParameters>
            <asp:Parameter Name="?"></asp:Parameter>
        </SelectParameters>
    </asp:SqlDataSource>
    <dx:ASPxPopupControl ID="popupNovaVerba" ClientInstanceName="popupNovaVerba" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="<%$Resources:Boletagem, boletagem_grid1_popup1_titulo %>" Modal="true" Width="500px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12 p-0">
                            <asp:Label ID="Label15" Font-Size="12pt" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label14" Font-Size="12pt" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                            <dx:ASPxComboBox ID="dropLoja" ClientInstanceName="dropLoja" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" ValueType="System.Int32" AutoPostBack="true" OnSelectedIndexChanged="dropLoja_SelectedIndexChanged">

                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            </dx:ASPxComboBox>
                        </div>
                        <div class="p-0 col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ValidationGroup="NovaVerba" ControlToValidate="dropContratos" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:Label ID="Label13" Font-Size="12pt" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl3 %>" CssClass="labels text-left"></asp:Label>
                            <dx:ASPxComboBox ID="dropContratos" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                DataSourceID="sqlContratos2" ValueField="opidcont" TextField="opcdcont">
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="lblCpf" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl4 %>" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqDesc" ControlToValidate="txtDesc" ValidationGroup="NovaVerba" runat="server" ErrorMessage="*" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="reqDesc2" ControlToValidate="txtDesc" runat="server" ValidationGroup="NovaVerba" ErrorMessage="Nome já existe" ForeColor="Red" Display="Dynamic" OnServerValidate="reqDesc2_ServerValidate"></asp:CustomValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <asp:TextBox ID="txtDesc" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="lblDesc" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl5 %>" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqIFRS" InitialValue="-1" ValidationGroup="NovaVerba" ControlToValidate="dropIFRS" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropIFRS" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Items>
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo1_item1 %>" Value="-1" Selected="true" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo1_item2 %>" Value="1" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo1_item3 %>" Value="0" />
                                    </Items>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label4" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl6 %>" CssClass="labels text-left"></asp:Label>
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
                            <asp:Label ID="Label6" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl7 %>" CssClass="labels text-left"></asp:Label>
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
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo3_item1 %>" Value="1" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo3_item2 %>" Value="0" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label10" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl8 %>" CssClass="labels text-left"></asp:Label>
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
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo4_item1 %>" Value="1" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo4_item2 %>" Value="0" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label11" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl9 %>" CssClass="labels text-left"></asp:Label>
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
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo5_item1 %>" Value="1" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo5_item2 %>" Value="0" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label12" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_lbl10 %>" CssClass="labels text-left"></asp:Label>
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
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item1 %>" Value="M" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item2 %>" Value="B" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item3 %>" Value="T" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item4 %>" Value="Q" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item5 %>" Value="s" />
                                        <dx:ListEditItem Text="<%$Resources:Verbas, verbas_combo6_item6 %>" Value="A" />
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
                            <dx:ASPxButton ID="btnNovaVerba" runat="server" ValidationGroup="NovaVerba" CssClass="btn-using" Text="<%$Resources:Boletagem, boletagem_grid1_popup1_btn %>" OnClick="btnNovaVerba_Click">
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
                <dx:ASPxGridView ID="gridFaturamento" ClientInstanceName="gridFaturamento" Width="500px" runat="server" Theme="Material" AutoGenerateColumns="False">
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
                <asp:SqlDataSource runat="server" ID="sqlFaturamento" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'></asp:SqlDataSource>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupNovoBoleto" ClientInstanceName="popupNovoBoleto" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="<%$Resources:Boletagem, boletagem_grid1_popup2_titulo %>" Modal="true" Width="500px" Height="650px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label7" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl1 %>" CssClass="labels text-left"></asp:Label>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropFormPagt" ForeColor="dimgray" AllowInputUser="false" runat="server" ValueType="System.String" CssClass="drop-down" Theme="Material" Width="100%"
                                    AutoPostBack="true" OnSelectedIndexChanged="dropFormPagt_SelectedIndexChanged">
                                    <Items>
                                        <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item1 %>" Value="B" />
                                        <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item2 %>" Value="T" />
                                        <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_combo1_item3 %>" Value="D" />
                                    </Items>
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    <ValidationSettings RequiredField-IsRequired="true" RequiredField-ErrorText="*" ErrorFrameStyle-ForeColor="Red" Display="Dynamic"></ValidationSettings>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x2 p-0">
                            <asp:Label ID="Label16" Font-Size="12pt" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl2 %>" CssClass="labels text-left"></asp:Label>
                            <dx:ASPxComboBox ID="dropLoja2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" ValueType="System.Int32" AutoPostBack="true" OnSelectedIndexChanged="dropLoja2_SelectedIndexChanged">

                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label8" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl3 %>" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator11" ValidationGroup="NovoBoleto" ControlToValidate="dropContratosBoleto" runat="server" ForeColor="Red" ErrorMessage="*" Display="Dynamic"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropContratosBoleto" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                    DataSourceID="sqlContratos2" ValueField="opidcont" TextField="opcdcont" AutoPostBack="true" OnSelectedIndexChanged="dropContratosBoleto_SelectedIndexChanged">
                                    <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
                                    document.getElementById('hfOpidcont').value = s.GetValue();
        }" />
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                </dx:ASPxComboBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label3" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl4 %>" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="*" ValidationGroup="NovoBoleto" ControlToValidate="txtNomeBoleto" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator1" runat="server" ValidationGroup="NovoBoleto" ControlToValidate="txtNomeBoleto" Display="Dynamic" ForeColor="Red" ErrorMessage="Nome já existente" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <asp:TextBox ID="txtNomeBoleto" CssClass="text-boxes" ValidationGroup="NovoBoleto" Width="100%" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-xx">
                            <dx:ASPxRadioButtonList ID="listLeitura" Enabled="false" ClientInstanceName="listLeitura" Caption="<%$Resources:Boletagem, boletagem_grid1_popup2_opcoes1 %>" RepeatDirection="Horizontal" CssClass=" labels text-left m-0 p-0 border-0" runat="server" ValueType="System.Int32">
                                <ClientSideEvents SelectedIndexChanged="function (s,e) {
                                                    callbackMask.PerformCallback(s.GetValue()+'#'+'listLeitura');
                                                    }" />
                                <Items>
                                    <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_opcoes2 %>" Value="1" />
                                    <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_opcoes3 %>" Value="2" />
                                </Items>
                            </dx:ASPxRadioButtonList>
                            <dx:ASPxRadioButtonList ID="listLayout" Enabled="false" ClientInstanceName="listLayout" Caption="<%$Resources:Boletagem, boletagem_grid1_popup2_opcoes4 %>" RepeatDirection="Horizontal" CssClass=" labels text-left m-0 p-0 border-0" runat="server" ValueType="System.Int32">
                                <ClientSideEvents SelectedIndexChanged="function (s,e) {
                                                    callbackMask.PerformCallback(s.GetValue()+'#'+'listLayout');
                                                    }" />
                                <Items>
                                    <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_opcoes5 %>" Value="1" />
                                    <dx:ListEditItem Text="<%$Resources:Boletagem, boletagem_grid1_popup2_opcoes6 %>" Value="2" />
                                </Items>
                            </dx:ASPxRadioButtonList>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxCallbackPanel ID="callbackMask" ClientInstanceName="callbackMask" runat="server" Width="100%" OnCallback="callbackMask_Callback1">
                                    <PanelCollection>
                                        <dx:PanelContent>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="*" ValidationGroup="NovoBoleto" ControlToValidate="txtCodBarras" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <dx:ASPxTextBox ID="txtCodBarras" Enabled="false" ForeColor="dimgray" CssClass="text-boxes" runat="server" Width="100%" Theme="Material">
                                                <ClientSideEvents LostFocus="GetBoleto" KeyPress="onKeyPress" />
                                                <ValidationSettings ValidationGroup="NovoBoleto" ErrorDisplayMode="None" Display="None" ErrorFrameStyle-Paddings-Padding="0px"></ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                <MaskHintStyle Paddings-Padding="0px"></MaskHintStyle>
                                                <CaptionCellStyle Paddings-Padding="0px"></CaptionCellStyle>
                                                <RootStyle Paddings-Padding="0px"></RootStyle>
                                                <Paddings Padding="0px" />
                                            </dx:ASPxTextBox>
                                        </dx:PanelContent>
                                    </PanelCollection>
                                </dx:ASPxCallbackPanel>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label5" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl5 %>" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="*" ValidationGroup="NovoBoleto" ControlToValidate="txtBoletoTotal" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxTextBox ID="txtBoletoTotal" ClientInstanceName="txtBoletoTotal" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%">
                                    <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                    <MaskHintStyle Paddings-Padding="0px"></MaskHintStyle>
                                    <CaptionCellStyle Paddings-Padding="0px"></CaptionCellStyle>
                                    <RootStyle Paddings-Padding="0px"></RootStyle>
                                    <Paddings Padding="0px" />
                                    <ValidationSettings ErrorDisplayMode="None" Display="None" ErrorFrameStyle-Paddings-Padding="0px"></ValidationSettings>
                                </dx:ASPxTextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label2" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl6 %>" CssClass="labels text-left"></asp:Label>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="*" ValidationGroup="NovoBoleto" ControlToValidate="txtDtVenc" Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxDateEdit ID="txtDtVenc" ClientInstanceName="txtDtVenc" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days">
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
                                    </CalendarProperties>
                                    <ValidationSettings ValidationGroup="NovoBoleto"></ValidationSettings>
                                </dx:ASPxDateEdit>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x1">
                            <dx:ASPxButton ID="btnNextBoleto" runat="server" ValidationGroup="NovoBoleto" CssClass="btn-using" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn1 %>" OnClick="btnNextBoleto_Click">
                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                            </dx:ASPxButton>
                        </div>
                        <div class="p-0 col-x0"></div>
                        <div class="p-0 col-x1">
                        </div>
                        <div class="p-0 col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="lblErroTotal" runat="server" Text="" ForeColor="Red" CssClass="labels text-left"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <dx:ASPxGridView ID="gridEntry" CssClass="bg-transparent" EnableCallBacks="false" KeyFieldName="ID" ClientInstanceName="gridEntry" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                            OnBatchUpdate="gridEntry_BatchUpdate" OnCustomDataCallback="gridEntry_CustomDataCallback">
                            <ClientSideEvents BatchEditStartEditing=" function(s,e) {
                                                    startIndex2 = e.visibleIndex; }" />
                            <SettingsPopup>
                                <HeaderFilter MinHeight="140px">
                                </HeaderFilter>
                            </SettingsPopup>
                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                            <Settings ShowFooter="true" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                            <SettingsBehavior AllowFocusedRow="true" />
                            <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="false" />
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
                                <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowDeleteButton="True" ButtonRenderMode="Image">
                                </dx:GridViewCommandColumn>
                                <dx:GridViewDataTextColumn FieldName="valor" VisibleIndex="2" Caption="<%$Resources:Boletagem, boletagem_grid1_popup2_grid_col1 %>" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true">
                                    <PropertiesTextEdit DisplayFormatString="{0:N2}"></PropertiesTextEdit>

                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="moidmoda" Caption="<%$Resources:Boletagem, boletagem_grid1_popup2_grid_col2 %>" VisibleIndex="1" PropertiesComboBox-ValidationSettings-RequiredField-IsRequired="true">
                                    <PropertiesComboBox DataSourceID="sqlVerbas2" TextField="MODSMODA" ValueField="MOIDMODA">
                                        <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
                                                                    var newValueOfComboBox = 'moidmoda#'+s.GetValue();                                    
                                                                    gridEntry.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback);
        }" />
                                    </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                            </Columns>
                            <TotalSummary>
                                <dx:ASPxSummaryItem FieldName="valor" DisplayFormat="{0:N2}" SummaryType="Sum" Visible="true" ShowInColumn="valor" />
                            </TotalSummary>
                            <Templates>
                                <StatusBar>
                                    <div style="text-align: left">
                                        <br />
                                        <dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridEntry.UpdateEdit(); }">
                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                        </dx:ASPxButton>
                                        <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridEntry.CancelEdit(); }">
                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                        </dx:ASPxButton>
                                        <dx:ASPxButton ID="btnGravarBoleto" runat="server" ValidationGroup="NovoBoleto" CssClass="btn-using ok" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn2 %>" OnClick="btnGravarBoleto_Click1">
                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                        </dx:ASPxButton>
                                        <dx:ASPxButton ID="btnLimparBoleto" runat="server" CausesValidation="false" CssClass="btn-using cancelar" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn3 %>" OnClick="btnLimparBoleto_Click">
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
                                <EditFormCell Font-Size="8pt"></EditFormCell>
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
                    </div>

                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupLeitura" ClientInstanceName="popupLeitura" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Leitura XML" Modal="true" Width="500px" Height="550px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxGridView ID="gridLeitura" CssClass="bg-transparent" ClientInstanceName="gridLeitura" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" AutoGenerateColumns="False"
                    KeyFieldName="ID" OnCustomCallback="gridLeitura_CustomCallback" OnDataBinding="gridLeitura_DataBinding">
                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                    <SettingsPopup>
                        <HeaderFilter MinHeight="140px">
                        </HeaderFilter>
                    </SettingsPopup>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                    <Settings VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" ShowHeaderFilterButton="true" />
                    <SettingsBehavior AllowFocusedRow="true" />
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
                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0"></dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Nome" VisibleIndex="1" Caption="Nome"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Data" Caption="Data" VisibleIndex="2"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="KB" Caption="KB" VisibleIndex="3"></dx:GridViewDataTextColumn>
                    </Columns>
                    <Templates>
                        <StatusBar>
                            <div style="text-align: left">
                                <br />
                                <dx:ASPxButton ID="btnLeituraGridLeitura" runat="server" AutoPostBack="false" CssClass="btn-using" Text="Processar" ClientSideEvents-Click="function(s, e){ gridLeitura.PerformCallback('processar'); }">
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
                        <EditFormCell Font-Size="8pt"></EditFormCell>
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
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupDebitoAuto" ClientInstanceName="popupDebitoAuto" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Extrato Débito Automático" Modal="true" Width="650px" Height="500px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label20" Font-Size="12pt" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl2 %>" CssClass="labels text-left"></asp:Label>
                            <dx:ASPxComboBox ID="dropLoja3" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                DataSourceID="sqlLoja" TextField="FONMAB20" ValueField="TVIDESTR" ValueType="System.Int32" AutoPostBack="true" OnSelectedIndexChanged="dropLoja3_SelectedIndexChanged">
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            </dx:ASPxComboBox>
                        </div>
                        <div class="col-x0"></div>
                        <div class="col-x2 p-0">
                            <asp:Label ID="Label21" Font-Size="12pt" runat="server" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_lbl3 %>" CssClass="labels text-left"></asp:Label>
                            <dx:ASPxComboBox ID="dropContratos3" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                DataSourceID="sqlContratos2" ValueField="opidcont" TextField="opcdcont">
                                <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
                                    document.getElementById('hfOpidcont').value = s.GetValue(); }" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label19" Font-Size="12pt" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl3 %>" CssClass="labels text-left"></asp:Label>
                            <dx:ASPxDateEdit ID="txtDtInicial3" Enabled="true" UseMaskBehavior="True" ForeColor="dimgray" CssClass="drop-down" Theme="Material"
                                Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" AutoResizeWithContainer="false">
                                <ClientSideEvents ValueChanged="function(s,e) { gridDebiAuto.Refresh(); } " />
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />

                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="3px" />
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
                        <div class="col-x0"></div>
                        <div class="p-0 col-x2">
                            <asp:Label ID="Label22" Font-Size="12pt" runat="server" Text="<%$ Resources:Monitoramento, monitoramento_lbl4 %>" CssClass="labels text-left"></asp:Label>
                            <dx:ASPxDateEdit ID="txtDtFinal3" Enabled="true" ForeColor="dimgray" UseMaskBehavior="True" CssClass="drop-down" Theme="Material"
                                Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" AutoResizeWithContainer="false">
                                <ClientSideEvents ValueChanged="function(s,e) { gridDebiAuto.Refresh(); } " />
                                <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                    <HoverStyle BackColor="#669999"></HoverStyle>
                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                </ButtonStyle>
                                <Paddings PaddingBottom="3px" PaddingTop="3px" />
                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                <DateRangeSettings StartDateEditID="txtDtInicial3"></DateRangeSettings>
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
                    <div class="row">
                        <div class="col-lg-12">
                            <dx:ASPxGridView ID="gridDebiAuto" CssClass="bg-transparent" KeyFieldName="DAIDDEBI" ClientInstanceName="gridDebiAuto" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                DataSourceID="sqlDebiAuto" OnCustomCallback="gridDebiAuto_CustomCallback" OnLoad="gridDebiAuto_Load">
                                <ClientSideEvents SelectionChanged="function (s,e) {
                                        btnConfirmar2.SetEnabled(gridDebiAuto.GetSelectedRowCount() &gt; 0);
                                        btnRecusar2.SetEnabled(gridDebiAuto.GetSelectedRowCount() &gt; 0);
                                    }" />
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                <Settings VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
                                <SettingsBehavior AllowFocusedRow="true" />
                                <SettingsPager NumericButtonCount="20" PageSize="20" Mode="ShowAllRecords">
                                </SettingsPager>
                                <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Cell" BatchEditSettings-ShowConfirmOnLosingChanges="false" />
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
                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Caption=" " Width="40px" ButtonRenderMode="Image">
                                        <HeaderTemplate>
                                            <dx:ASPxCheckBox ID="cbAll2" runat="server" ClientInstanceName="cbAll2" ToolTip="Select all rows" Theme="Material"
                                                BackColor="White" OnLoad="cbAll2_Load">
                                                <ClientSideEvents CheckedChanged="OnAllCheckedChanged2" />
                                            </dx:ASPxCheckBox>
                                        </HeaderTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataDateColumn FieldName="DADTLANC" ReadOnly="True" EditFormSettings-Visible="False" Caption="Data Lançamento" VisibleIndex="1"></dx:GridViewDataDateColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="MOIDMODA" ReadOnly="True" EditFormSettings-Visible="False" Caption="Verbas" VisibleIndex="3">
                                        <PropertiesComboBox DataSourceID="sqlVerbas" TextField="MODSMODA" ValueField="MOIDMODA">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataTextColumn FieldName="DACODCLI" ReadOnly="True" EditFormSettings-Visible="False" Caption="Código Cliente" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="DAVALODA" ReadOnly="True" EditFormSettings-Visible="False" Caption="Valor" VisibleIndex="6" PropertiesTextEdit-DisplayFormatString="N2"></dx:GridViewDataTextColumn>
                                </Columns>
                                <Templates>
                                    <StatusBar>
                                        <div style="text-align: left">
                                            <br />
                                            <dx:ASPxButton ID="btnConfirmar2" ClientInstanceName="btnConfirmar2" runat="server" AutoPostBack="true" ClientEnabled="false" Width="130px" CssClass="btn-using" Text="<%$Resources:Boletagem, boletagem_grid3_btn1 %>" OnClick="btnConfirmar2_Click">
                                                <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                            </dx:ASPxButton>
                                            <dx:ASPxButton ID="btnRecusar2" Visible="false" ClientInstanceName="btnRecusar2" runat="server" AutoPostBack="true" ClientEnabled="false" Width="100px" CssClass="btn-using" Text="Recusar" OnClick="btnRecusar2_Click">
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
                                    <EditFormCell Font-Size="8pt"></EditFormCell>
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
                            <asp:SqlDataSource runat="server" ID="sqlDebiAuto" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select * from DEBIAUTO
where OPIDCONT=?
  and MOIDMODA IN (SELECT MOIDMODA FROM VIOPMODA WHERE OPIDCONT=? AND VITPPGTO=3)
  AND DADTLANC BETWEEN ? AND ? AND DAFLFLAG=0">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfOpidcont" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="hfOpidcont" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtDtInicial3" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="txtDtFinal3" PropertyName="Value" Name="?"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupMedicao" ClientInstanceName="popupMedicao" runat="server"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Medição de Contrato" Modal="true" Width="850px" Height="350px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row">
                        <div class="p-0 col-x1">
                            <asp:Label ID="Label23" runat="server" Text="Contrato" CssClass="labels text-left"></asp:Label>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxComboBox ID="dropMedContr" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                    DataSourceID="sqlMedContr" ValueField="opidcont" ValueType="System.Int32" TextField="texto" AutoPostBack="true" OnSelectedIndexChanged="dropMedContr_SelectedIndexChanged">
                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    </ButtonStyle>
                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                </dx:ASPxComboBox>
                                <asp:SqlDataSource runat="server" ID="sqlMedContr" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select opidcont,CONCAT(OPCDCONT,'-',OPNMCONT) texto from opcontra o, PRPRODUT p
where o.prprodid=p.prprodid and p.prmedngt=1 order by 2"></asp:SqlDataSource>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x1">
                            <asp:Label ID="Label24" runat="server" Text="Descrição" CssClass="labels text-left"></asp:Label>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <asp:TextBox ID="txtMedDesc" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x1">
                            <asp:Label ID="Label25" runat="server" Text="Nr Contrato" CssClass="labels text-left"></asp:Label>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <asp:TextBox ID="txtMedContr" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                        <div class="p-0 col-x1">
                            <asp:Label ID="Label26" runat="server" Text="Vencimento" CssClass="labels text-left"></asp:Label>
                            <div class="input-group mb-auto" style="padding-left: 2px">
                                <dx:ASPxDateEdit ID="txtDtVencMedi" ForeColor="dimgray" CssClass="drop-down" UseMaskBehavior="True" Theme="Material" Width="100%" runat="server" PickerType="Days">
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
                                    </CalendarProperties>

                                </dx:ASPxDateEdit>
                            </div>
                        </div>
                        <div class="col-x0"></div>
                    </div>
                    <div class="row mt-3">

                        <dx:ASPxGridView ID="gridMedicao" CssClass="bg-transparent" KeyFieldName="ID" ClientInstanceName="gridMedicao" EnableViewState="false" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                            OnBatchUpdate="gridMedicao_BatchUpdate" OnCustomDataCallback="gridMedicao_CustomDataCallback">
                            <ClientSideEvents BatchEditStartEditing=" function(s,e) {
                                                    startIndexgridMedicao = e.visibleIndex; }"
                                BatchEditRowValidating="function(s,e)
                                {
                                    var grid = ASPxClientGridView.Cast(s);
                                    var cellInfo1 = e.validationInfo[grid.GetColumnByField('saldo').index];
                                    var cellInfo2 = e.validationInfo[grid.GetColumnByField('quantidade').index];
                                    if(cellInfo2.value &gt; cellInfo1.value)
                                    {
                                        cellInfo2.isValid = false;
                                        cellInfo2.errorText = 'Quantidade inserida não pode ser maior que Saldo atual.';
                                    }
                                }" />
                            <SettingsPopup>
                                <HeaderFilter MinHeight="140px">
                                </HeaderFilter>
                            </SettingsPopup>
                            <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                            <Settings ShowFooter="true" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard" />
                            <SettingsBehavior AllowFocusedRow="true" />
                            <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Row" BatchEditSettings-ShowConfirmOnLosingChanges="false" />
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
                                <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" ShowDeleteButton="True" ButtonRenderMode="Image">
                                </dx:GridViewCommandColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="verba" Caption="Verba" VisibleIndex="1">
                                    <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlVerbaMedicaoGrid" TextField="MODSMODA" ValueField="MOIDMODA">
                                    </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="item" Caption="Item" VisibleIndex="1">
                                    <PropertiesComboBox ClientInstanceName="ItemMedicaoDrop" ValueType="System.Int32" DataSourceID="sqlItensMedicaoGrid" TextField="ENDSITEM" ValueField="FRIDITEM">
                                        <ClientSideEvents SelectedIndexChanged="function onSelectedIndexChanged(s, e) {
                                                                    var newValueOfComboBox = 'item#'+s.GetValue();                                    
                                                                    gridMedicao.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback2);
        }" />
                                    </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataDateColumn FieldName="inicio" Caption="In&#237;cio" VisibleIndex="2"></dx:GridViewDataDateColumn>
                                <dx:GridViewDataDateColumn FieldName="fim" Caption="Fim" VisibleIndex="3"></dx:GridViewDataDateColumn>
                                <dx:GridViewDataTextColumn FieldName="contratada" ReadOnly="True" Caption="Contratada" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="saldo" ReadOnly="True" Caption="Saldo" VisibleIndex="5"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="preco" ReadOnly="True" Caption="Pre&#231;o" VisibleIndex="6" PropertiesTextEdit-DisplayFormatString="{0:N2}"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="quantidade" Caption="Quantidade" VisibleIndex="7">
                                    <PropertiesTextEdit>
                                        <ClientSideEvents TextChanged="function onSelectedIndexChanged(s, e) {
                                                                    var newValueOfComboBox = 'quantidade#'+s.GetValue()+'#'+ItemMedicaoDrop.GetValue();                                    
                                                                    gridMedicao.GetValuesOnCustomCallback(newValueOfComboBox, DataCallback2);
        }" />
                                    </PropertiesTextEdit>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="total" Caption="Total" VisibleIndex="8" ReadOnly="True" PropertiesTextEdit-DisplayFormatString="{0:N2}"></dx:GridViewDataTextColumn>
                            </Columns>
                            <TotalSummary>
                                <dx:ASPxSummaryItem FieldName="total" DisplayFormat="{0:N2}" SummaryType="Sum" Visible="true" ShowInColumn="total" />
                            </TotalSummary>
                            <Templates>
                                <StatusBar>
                                    <div style="text-align: left">
                                        <br />
                                        <dx:ASPxButton ID="btnSave" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridMedicao.UpdateEdit(); }">
                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                        </dx:ASPxButton>
                                        <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridMedicao.CancelEdit(); }">
                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                        </dx:ASPxButton>
                                        <dx:ASPxButton ID="btnGravarMedicao" runat="server" ClientInstanceName="btnGravarMedicao" ClientEnabled="false" CssClass="btn-using ok" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn2 %>" OnClick="btnGravarMedicao_Click" OnLoad="btnGravarMedicao_Load">
                                            <DisabledStyle CssClass="btn-using"></DisabledStyle>

                                        </dx:ASPxButton>
                                        <dx:ASPxButton ID="btnLimparMedicao" runat="server" ClientInstanceName="btnLimparMedicao" ClientEnabled="false" CssClass="btn-using cancelar" Text="<%$Resources:Boletagem, boletagem_grid1_popup2_btn3 %>" OnClick="btnLimparMedicao_Click" OnLoad="btnLimparMedicao_Load">
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
                                <EditFormCell Font-Size="8pt"></EditFormCell>
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
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
