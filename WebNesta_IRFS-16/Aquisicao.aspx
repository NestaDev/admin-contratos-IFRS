<%@ Page Title="" Language="C#" MaintainScrollPositionOnPostback="true" EnableEventValidation="false" MasterPageFile="~/Site.Master" AutoEventWireup="True" CodeBehind="Aquisicao.aspx.cs" Inherits="WebNesta_IRFS_16.Aquisicao1" %>
<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<%@ MasterType VirtualPath="~/Site.Master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
    <script type="text/javascript">
        var btnValidarTexto = '<%= Resources.GlobalResource.btn_grid_batch_preview%>';
        var btnSalvarTexto = '<%= Resources.GlobalResource.btn_grid_batch_save%>';
        function OnUpdateControlValue(s, e, btn, textbox) {
            btn.SetEnabled(textbox.GetIsValid());
        }
        function openModalContratos() {
            $('#ModalContratos').modal('show');
        }
        function openModalEstrutura() {
            $('#ModalEstrutura').modal('show');
        }
        function closeModalEstrutura() {
            $('#ModalEstrutura').modal('hide');
        }
        function openModalBasesInsert() {
            $('#ModalBasesInsert').modal('show');
        }
        function openModalBasesAlterar() {
            $('#ModalBasesAlterar').modal('show');
        }
        //jQuery(document).ready(function ($) {
        //    $(".valor").maskMoney({ decimal: ',', thousands: '.', allowZero: true });
        //});
        function InIEvent($) {
            $(".valor").maskMoney({ decimal: ',', thousands: '.', allowZero: true });
        }
        jQuery(document).ready(InIEvent);
        //jQuery(document).ready(function ($) {
        //    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(InIEvent);
        //    function InIEvent(sender, e) {
        //        $(".valor").maskMoney({ decimal: ',', thousands: '.', allowZero: true });
        //    }
        //});
        function OnCountryChanged(cmbCountry) {
            dropClasseProdutoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
            //dropFormatoOperacaoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
            dropTipoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
        }
        function OnClasseInsertChanged(dropClasseProdutoInsert2) {
            dropProdutoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString().concat('#', dropClasseProdutoInsert2.GetSelectedItem().value.toString(), '#', document.getElementById('hfDropEstr').value));
        }
    </script>
    <style>
        .modal .modal-dialog {
            width: 60%;
        }
    </style>
    <script type="text/javascript">
        function ClearSelection() {
            TreeList.SetFocusedNodeKey("");
            UpdateControls(null, "");
            document.getElementById('hfDropEstr').value = "";
        }
        function UpdateSelection() {
            var employeeName = "";
            var focusedNodeKey = TreeList.GetFocusedNodeKey();
            document.getElementById('hfDropEstr').value = TreeList.GetFocusedNodeKey();
            dropCarteiraInsert2.PerformCallback(document.getElementById('hfDropEstr').value);
            dropAgenteFinanceiroInsert2.PerformCallback(document.getElementById('hfDropEstr').value);
            dropBenefIns.PerformCallback(document.getElementById('hfDropEstr').value);
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

        function OnBatchEditEndEditing(s, e) {
            CalculateSummary(s, e.rowValues, e.visibleIndex, false);
        }
        var savedValue;
        function OnEndCallback(s, e) {
            if (!savedValue) return;
            labelSum.SetValue(savedValue);
        }
        function CalculateSummary(grid, rowValues, visibleIndex, isDeleting) {
            var originalValue2 = grid.batchEditApi.GetCellValue(visibleIndex, "percentual");
            var originalValue = originalValue2 == null ? parseFloat("0") : parseFloat(originalValue2.toString().replace(",", "."));
            var newValue2 = rowValues[(grid.GetColumnByField("percentual").index)].value;
            var newValue = newValue2 == null ? parseFloat("0") : parseFloat(newValue2.toString().replace(",", "."));
            var dif = isDeleting ? -newValue : newValue - originalValue;
            var sum = (parseFloat(labelSum.GetValue()) + dif).toFixed(0);
            savedValue = sum;
            labelSum.SetValue(sum);
        }
        function OnBatchEditRowDeleting(s, e) {
            CalculateSummary(s, e.rowValues, e.visibleIndex, true);
        }
        function OnChangesCanceling(s, e) {
            if (s.batchEditApi.HasChanges())
                setTimeout(function () {
                    savedValue = null;
                    s.Refresh();
                }, 0);
        }
        function gedShow() {
            var teste = document.getElementById('hfOPIDCONT').value;
            if (teste.length > 0)
                popupFileManager.Show();
        }
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfMsgException" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_exception %>" />
    <asp:HiddenField ID="hfMsgSuccess" runat="server" Value="<%$ Resources:GlobalResource, msg_alert_success %>" />
    <asp:Button ID="Button10gridDeAte" ClientIDMode="Static" CausesValidation="false" CssClass="Loading" OnClick="Button10_Click" Style="display: none" runat="server" Text="Button" />
    <script type="text/javascript">
        $(function () {
            var paneName1 = $("[id*=panelActive1]").val() != "" ? $("[id*=panelActive1]").val() : "collapseAlterarInfo";
            var paneName2 = $("[id*=panelActive2]").val() != "" ? $("[id*=panelActive2]").val() : "collapseInsertInfo";
            //Remove the previous selected Pane.
            $("#cardAlterar .show").removeClass("show");
            $("#cardInsert .show").removeClass("show");
            //Set the selected Pane.
            $("#" + paneName1).collapse("show");
            $("#" + paneName2).collapse("show");
            //When Pane is clicked, save the ID to the Hidden Field.
            $(".card-header a").click(function () {
                $("[id*=panelActive1]").val($(this).attr("href").replace("#", ""));
                $("[id*=panelActive2]").val($(this).attr("href").replace("#", ""));
            });
            $("#myLinkTag").on('click', function () {
                $("#myLinkTagBtn").click();

            });
            $("#linkReplicar").on('click', function () {
                var replicar = document.getElementById('hfReplicar').value;
                if (replicar == '1') {
                    $("#linkReplicarBtn").click();
                }
            });
            $('#bologna-list a').on('click', function (e) {
                e.preventDefault()
                $(this).tab('show')
            })
        });

        function QuickGuide(guide) {
            switch (guide) {
                case 'aba1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_titulo1_quickguide%>';
                    break;
                case 'aba2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_titulo1_quickguide%>';
                    break;
                case 'aba3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp3_titulo1_quickguide%>';
                    break;
                case 'aba4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp4_titulo1_quickguide%>';
                    break;
                case 'aba5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp5_titulo1_quickguide%>';
                    break;
                case '1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl1_guide%>';
                    break;
                case '2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl2_guide%>';
                    break;
                case '3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl3_guide%>';
                    break;
                case '31':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl31_guide%>';
                    break;
                case '4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl4_guide%>';
                    break;
                case '5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl5_guide%>';
                    break;
                case '6':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl6_guide%>';
                    break;
                case '7':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl7_guide%>';
                    break;
                case '8':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl8_guide%>';
                    break;
                case '9':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl9_guide%>';
                    break;
                case '10':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl10_guide%>';
                    break;
                case '11':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl11_guide%>';
                    break;
                case '12':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl12_guide%>';
                    break;
                case '13':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl13_guide%>';
                    break;
                case '14':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl14_guide%>';
                    break;
                case '15':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl15_guide%>';
                    break;
                case '16':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp1_lbl16_guide%>';
                    break;
                case '17':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl1_guide%>';
                    break;
                case '18':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl2_guide%>';
                    break;
                case '19':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl3_guide%>';
                    break;
                case '20':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl4_guide%>';
                    break;
                case '21':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl5_guide%>';
                    break;
                case '22':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_grp2_lbl6_guide%>';
                    break;
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Aquisicao.aquisição_right_titulo_guide%>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.quickguide_inicial %>';
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
                case 'historico':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Aquisicao.aquisição_btn_historico_guide %>';
                    break;
                case 'replicar':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Aquisicao.aquisição_btn_replicar_guide %>';
                    break;
                case 'aditamento':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.Aquisicao.aquisição_btn_aditamento_guide %>';
                    break;
            }

        }
    </script>
    <asp:HiddenField ID="hfTituloPag" Value="Lista Contratos" runat="server" />
    <asp:HiddenField ID="panelActive1" runat="server" />
    <asp:HiddenField ID="panelActive2" runat="server" />
    <asp:HiddenField ID="hfInsertOK" runat="server" />
    <asp:HiddenField ID="hfIndexGrid" runat="server" />
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfqueryRpt" runat="server" />
    <asp:HiddenField ID="hfcontRpt" runat="server" />
    <asp:HiddenField ID="hfEstruturaCorporativa" runat="server" />
    <asp:HiddenField ID="hfProduto" runat="server" />
    <asp:HiddenField ID="hfPaisUser" runat="server" />
    <asp:HiddenField ID="hfSqlInsert" runat="server" />
    <asp:HiddenField ID="hfCodInterno" runat="server" />
    <asp:HiddenField ID="hfPostBack" runat="server" />
    <asp:HiddenField ID="hfOPCDCONT" runat="server" />
    <asp:HiddenField ID="hfTVDSESTR" runat="server" />
    <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfPRPRODES" runat="server" />
    <asp:HiddenField ID="hfOPVLCONT" runat="server" />
    <asp:HiddenField ID="hfPRPRODID" runat="server" />
    <asp:HiddenField ID="hfOPIDCONT" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfCHIDCODI" runat="server" />
    <asp:HiddenField ID="hfCJIDCODI" runat="server" />
    <asp:HiddenField ID="hfCJTPIDTP" runat="server" />
    <asp:HiddenField ID="hfReplicar" ClientIDMode="Static" Value="0" runat="server" />
    <asp:SqlDataSource ID="sqlContasCredDeb" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select PFIDPLNC,concat(PFCDPLNC,' - ', PFDSPLNC) conta from PFPLNCTA order by 2"></asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ID="sqlFileContratos" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
        SelectCommand="SELECT [OPIDCONT], [FILENAME], [FILEPATH],[FILEIDFI] FROM [FILEOPOP] WHERE ([OPIDCONT] = ?)"
        DeleteCommand="DELETE FILEOPOP WHERE FILEIDFI=?">
        <SelectParameters>
            <asp:SessionParameter SessionField="ID" Name="OPIDCONT" Type="Decimal"></asp:SessionParameter>
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="FILEIDFI" Type="String" />
        </DeleteParameters>
    </asp:SqlDataSource>
    <div class="container">
        <div class="row">
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Aquisicao, aquisicao_content_tutorial %>" />
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
            <div class="col-sm-10 pl-4">
                <asp:Panel ID="pnlConsulta" Visible="true" runat="server">
                    <%--Painel com as informações de Consulta--%>
                    <div id="cardConsulta">
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('aba1');">
                                <a class="card-link" data-toggle="collapse" href="#collapseConsultaInfo" aria-expanded="true">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label2" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp1_titulo1 %>"></asp:Label>
                                        <asp:Label ID="lbltxtInt" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp1_subtitulo1 %>"></asp:Label>
                                        <asp:Label ID="lblcodInt" runat="server" CssClass="labels" Text=""></asp:Label>
                                    </h5>
                                </a>
                            </div>
                            <div id="collapseConsultaInfo" class="collapse show" data-parent="#cardConsulta">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblEstCorpo" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('1');">
                                                <asp:TextBox ID="txtEstCorpo" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label65" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('2');">
                                                <asp:TextBox ID="txtImoveis" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblCodInterno" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('3');">
                                                <asp:TextBox ID="txtCodInterno" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblNumProc" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('4');">
                                                <asp:TextBox ID="txtNumProc" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblDesc" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl5 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('5');">
                                                <asp:TextBox ID="txtDesc" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblCodAuxiliar" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('6');">
                                                <asp:TextBox ID="txtCodAuxiliar" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblDataAquisi" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('7');">
                                                <asp:TextBox ID="txtDataAquisi" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblHoraAquisi" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl8 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('8');">
                                                <asp:TextBox ID="txtDtAss" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>

                                    </div>
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label40" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl9 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('9');">
                                                <asp:TextBox ID="txtDtEncerra" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label34" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl10 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('10');">
                                                <dx:ASPxTextBox ID="txtValorAquisi" ForeColor="dimgray" Enabled="false" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <MaskSettings Mask="<0..9999999999g>.<00..99999>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                    <ValidationSettings ErrorDisplayMode="Text" SetFocusOnError="true" CausesValidation="true" ErrorText="*">
                                                        <RequiredField IsRequired="true" ErrorText="*" />
                                                    </ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label57" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl11 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('11');">
                                                <asp:TextBox ID="txtIniPag" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <asp:Label ID="Label58" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl12 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('12');">
                                                <asp:TextBox ID="txtFimPag" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblEstrut" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl13 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('13');">
                                                <asp:TextBox ID="txtEstrut" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblClasseProduto" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl14 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('14');">
                                                <asp:TextBox ID="txtClasseProduto" CssClass="text-boxes" Enabled="false" Width="100%" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblProduto" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl15 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                                <asp:TextBox ID="txtProd" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblCarteira" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl16 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('16');">
                                                <asp:TextBox ID="txtCarteira" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba2');">
                                <a class="card-link" data-toggle="collapse" href="#collapseConsultaClass">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label5" CssClass="labels" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseConsultaClass" class="collapse" data-parent="#cardConsulta">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblAgntFinanc" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('17');">
                                                <asp:TextBox ID="txtAgntFinanc" Width="100%" CssClass="text-boxes" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label55" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('18');">
                                                <asp:TextBox ID="txtBenef" Width="100%" CssClass="text-boxes" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="lblTipo" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('19');">
                                                <asp:TextBox ID="txtTipo" Width="100%" CssClass="text-boxes" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto" style="margin-top: 1px">
                                                <asp:TextBox ID="TextBox2" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label48" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator29" ValidationGroup="InsertReq" ControlToValidate="dropTipoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp2_lbl3 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('20');">
                                                <dx:ASPxComboBox ID="dropParc" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.1 %>" Value="1" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.2 %>" Value="0" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label49" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator30" ValidationGroup="InsertReq" ControlToValidate="dropTipoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp2_lbl3 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('21');">
                                                <dx:ASPxComboBox ID="dropCare" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.1 %>" Value="1" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.2 %>" Value="0" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label50" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator31" ValidationGroup="InsertReq" ControlToValidate="dropTipoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp2_lbl3 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('22');">
                                                <dx:ASPxComboBox ID="dropSaldo" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.1 %>" Value="1" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.2 %>" Value="0" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto" style="margin-top: 1px">
                                                <asp:TextBox ID="TextBox8" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba3');">
                                <a class="card-link" data-toggle="collapse" href="#collapseConsultaBases">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label6" CssClass="labels" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp3_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseConsultaBases" class="collapse" data-parent="#cardConsulta">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <asp:Panel ID="pnlBases" runat="server" Height="200px" ScrollBars="Vertical" Width="100%">
                                        <div class="container">
                                            <div class="row">
                                                <div class="col-12">
                                                    <asp:Repeater ID="rptBases" runat="server" OnPreRender="rptBases_PreRender" OnItemDataBound="rptBases_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <div class="row">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <div class="col-x1">

                                                                <asp:Label ID="Label29" runat="server" CssClass="labels text-left" Text='<%#DataBinder.Eval(Container.DataItem, "CJDSDECR")%>'></asp:Label>
                                                                <div class="input-group mb-auto">
                                                                    <table style="width: 100%">
                                                                        <tr>
                                                                            <td style="text-align: right; padding-right: 10px" class=" tblRptControl">
                                                                                <asp:HiddenField ID="hfName" runat="server" Value='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>' />
                                                                                <asp:HiddenField ID="hfArgument" runat="server" Value='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>' />
                                                                                <asp:HiddenField ID="hfTexto" runat="server" Value='<%#DataBinder.Eval(Container.DataItem, "CJTPCTTX")%>' />
                                                                                <asp:HiddenField ID="hfTipo" runat="server" Value='<%#DataBinder.Eval(Container.DataItem, "CJTPIDTP")%>' />

                                                                                <asp:LinkButton ID="lnkRptBasesEdit" CausesValidation="false" Visible="true" Font-Size="Small" ForeColor="DimGray" ClientIDMode="Static" runat="server" OnCommand="BasesEdit"
                                                                                    CommandName='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>'
                                                                                    CommandArgument='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>' Style="padding-bottom: 3px">
                                                 <%# Eval("CJTPIDTP").ToString()=="10"||Eval("CJTPIDTP").ToString()=="6" ? Eval("CJVLPROP").ToString()=="0" ? Eval("CJVLPROP").ToString() : DataBinder.Eval(Container.DataItem, "CJVLPROP", "{0:N2}") : Eval("CJTPCTTX").ToString() %>                                                                                    
                                                                                </asp:LinkButton>

                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <asp:Literal ID="ltrlRepeaterBasesEdit" runat="server"></asp:Literal>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </div>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba4');">
                                <a class="card-link" data-toggle="collapse" href="#collapseConsultaVerbas">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label52" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, aquisição_grp5_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseConsultaVerbas" class="collapse" data-parent="#cardConsulta">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <dx:ASPxGridView ID="gridVerbasCons" ClientInstanceName="gridVerbasCons" KeyFieldName="VIIDMODA" ClientIDMode="Static" Width="800px" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVerbasCons">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />

                                        <Settings VerticalScrollableHeight="594" HorizontalScrollBarMode="Auto" />
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
                                            <dx:GridViewDataComboBoxColumn FieldName="MOIDMODA" MaxWidth="135" Width="135px" VisibleIndex="0" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col1 %>">
                                                <PropertiesComboBox DataSourceID="sqlVerbas" ValueType="System.Int32" TextField="MODSMODA" ValueField="MOIDMODA"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="ID" VisibleIndex="2" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col2 %>">
                                                <PropertiesComboBox ValueField="ID" TextField="CJDSDECR" ValueType="System.String" ConvertEmptyStringToNull="true">
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="VITPPGTO" VisibleIndex="3" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col3 %>">
                                                <PropertiesComboBox ValueType="System.Int32">
                                                    <Items>
                                                        <dx:ListEditItem Text="Boleto" Value="1" />
                                                        <dx:ListEditItem Text="Transferência" Value="2" />
                                                        <dx:ListEditItem Text="Débito Conta" Value="3" />
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="VIDIAMOD" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col4 %>" VisibleIndex="1">
                                                <PropertiesTextEdit>
                                                    <MaskSettings Mask="<1..31>" IncludeLiterals="None" />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PFIDCRED" MaxWidth="180" Width="180px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col5 %>" VisibleIndex="4">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PFIDDEBI" MaxWidth="180" Width="180px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col6 %>" VisibleIndex="5">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                            <Header Font-Names="Arial" Font-Size="9pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
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
                                    <asp:SqlDataSource ID="sqlBasesCons" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="SELECT CJ.CJDSDECR,concat(CJ.CHIDCODI,'#',CJ.CJIDCODI) AS ID FROM CJCLPROP CJ,OPCONTRA OP, PRPRODUT PR, VIPROEVE VI
WHERE OP.OPIDCONT=?
  AND PR.prprodid=OP.PRPRODID
  AND CJ.CHIDCODI=PR.chidcodi
  AND CJ.CJTPIDTP=6
  AND VI.CHIDCODI=PR.chidcodi
  AND VI.CJIDCODI=CJ.CJIDCODI
  AND VI.CHTPIDEV=1">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource runat="server" ID="sqlVerbasCons" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select m.MOIDMODA,v.VIIDMODA, case when V.CHIDCODI is null then '' else CONCAT(V.CHIDCODI,'#',V.CJIDCODI) end AS ID,convert(int,v.VIDIAMOD) as VIDIAMOD,convert(int,v.VITPPGTO) as VITPPGTO,PFIDCRED,PFIDDEBI from VIOPMODA v, MODALIDA m where m.MOIDMODA=v.MOIDMODA and m.MOTPIDCA=10 and v.OPIDCONT=?">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba5');">
                                <a class="card-link " data-toggle="collapse" onclick="gedShow()" style="cursor: pointer">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label37" CssClass="labels" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp4_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseConsultaArqs" class="collapse" data-parent="#cardConsulta">
                                <div class="card-body bg-transparent pb-0 pt-1 row">
                                    <dx:ASPxGridView ID="ASPxGridView2" Width="500px" runat="server" KeyFieldName="FILEIDFI" Theme="Material" DataSourceID="sqlFileContratos" AutoGenerateColumns="False">
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
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
                                            <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="30px" MaxWidth="30" EditFormSettings-Visible="False" VisibleIndex="1" Caption="<%$Resources:Aquisicao, aquisição_grp4_grid_col1 %>"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="FILENAME" Width="400px" MaxWidth="400" CellStyle-Wrap="False" EditFormSettings-Visible="False" VisibleIndex="2" Caption="<%$Resources:Aquisicao, aquisição_grp4_grid_col2 %>"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataHyperLinkColumn FieldName="FILEPATH" CellStyle-CssClass="text-center" Width="50px" MaxWidth="50" EditFormSettings-Visible="False" Caption=" " VisibleIndex="3">
                                                <PropertiesHyperLinkEdit Target="_blank" ImageUrl="~/icons/icons8-open-view-20.png"></PropertiesHyperLinkEdit>
                                            </dx:GridViewDataHyperLinkColumn>
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
                                        <StylesPager CurrentPageNumber-BackColor="#669999"></StylesPager>
                                    </dx:ASPxGridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlExclusao" Visible="false" runat="server">
                    <br />
                    <div class="row text-center">
                        <br />
                        <div class="col-2"></div>
                        <div class="col-lg-8 card bg-transparent align-items-center">
                            <div class="card-header bg-transparent">
                                <h3>
                                    <asp:Label ID="Label27" runat="server" CssClass=" text-danger" Text="<%$Resources:Aquisicao, aquisição_delete_titulo %>"></asp:Label></h3>
                            </div>
                            <div class="card-body bg-transparent">
                                <table>
                                    <tr>
                                        <td colspan="2" class="text-left">
                                            <h6>
                                                <asp:Label ID="Label28" runat="server" CssClass="text-left" Text="<%$Resources:Aquisicao, aquisição_delete_texto %>"></asp:Label></h6>
                                        </td>
                                    </tr>
                                </table>

                            </div>
                        </div>
                        <div class="col-2"></div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlAlteracao" Visible="false" runat="server">
                    <%--Painel com as informações de Alteração--%>
                    <div id="cardAlterar">
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" onmouseover="QuickGuide('aba1');">
                                <a class="card-link" data-toggle="collapse" href="#collapseAlterarInfo" aria-expanded="true">
                                    <h5>
                                        <i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label11" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp1_titulo1 %>"></asp:Label>
                                        <asp:Label ID="Label32" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp1_subtitulo1 %>"></asp:Label>
                                        <asp:Label ID="lblcodInt2" runat="server" CssClass="labels" Text=""></asp:Label>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" ControlToValidate="txtValorAquisicaoEdit" InitialValue="0,00" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" ControlToValidate="txtDataAquisicaoEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                    </h5>
                                </a>
                            </div>
                            <div id="collapseAlterarInfo" class="collapse show" data-parent="#cardAlterar">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('1');">
                                                <asp:TextBox ID="txtEstruturaCorporativaEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label66" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('2');">
                                                <asp:TextBox ID="txtImoveisEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('3');">
                                                <asp:TextBox ID="txtCodInternoEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('4');">
                                                <asp:TextBox ID="txtNumProcessoEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl5 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('5');">
                                                <asp:TextBox ID="txtDescricaoEdit" MaxLength="60" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('6');">
                                                <asp:TextBox ID="txtCodAuxiliarEdit" Width="100%" MaxLength="15" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtDataAquisicaoEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('7');">
                                                <dx:ASPxDateEdit ID="txtDataAquisicaoEdit" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label18" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl8 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator21" Enabled="false" ControlToValidate="txtdtAssEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('8');">
                                                <dx:ASPxDateEdit ID="txtdtAssEdit" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days"
                                                    PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
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
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label41" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl9 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator22" Enable="false" ControlToValidate="txtdtEncerraEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('9');">
                                                <dx:ASPxDateEdit ID="txtdtEncerraEdit" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label36" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl10 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtValorAquisicaoEdit" InitialValue="0,00" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('10');">
                                                <dx:ASPxTextBox ID="txtValorAquisicaoEdit" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                    CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                    <MaskSettings Mask="<0..9999999999g>.<00..99999>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                    <ValidationSettings ErrorDisplayMode="Text" Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*">
                                                        <RequiredField IsRequired="true" ErrorText="*" />
                                                    </ValidationSettings>
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label59" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl11 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('11');">
                                                <dx:ASPxDateEdit ID="txtIniPagEdit" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label60" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl12 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('12');">
                                                <dx:ASPxDateEdit ID="txtFimPagEdit" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
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
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl13 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('13');">
                                                <asp:TextBox ID="txtEstruturaEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label23" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl14 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('14');">
                                                <asp:TextBox ID="txtClasseProdEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl15 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                                <asp:TextBox ID="txtProdutoEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label35" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl16 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('16');">
                                                <dx:ASPxComboBox ID="dropCarteiraEdit" ForeColor="dimgray" AllowInputUser="false" CssClass="drop-down" runat="server"
                                                    Theme="Material" Width="100%" ValueType="System.String">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba2');">
                                <a class="card-link" data-toggle="collapse" href="#collapseAlterarClass">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label19" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp2_titulo %>"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="txtAgntFinancEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator35" ControlToValidate="dropParcEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator36" ControlToValidate="dropCareEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator37" ControlToValidate="dropSaldoEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator></h5>
                                </a>
                            </div>
                            <div id="collapseAlterarClass" class="collapse" data-parent="#cardAlterar">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl1 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtAgntFinancEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('17');">
                                                <%--<asp:TextBox ID="txtAgntFinancEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>--%>
                                                <dx:ASPxComboBox ID="txtAgntFinancEdit" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" TextField="FONMAB20" ValueField="FOIDFORN">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label56" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px" onmouseover="QuickGuide('18');">
                                                <%--<asp:TextBox ID="txtAgntFinancEdit" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>--%>
                                                <dx:ASPxComboBox ID="dropBenefAlter" ForeColor="dimgray" Enabled="false" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" TextField="FONMAB20" ValueField="FOIDFORN">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label24" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                            <div class="input-group mb-auto drop-down-div" style="padding-left: 2px" onmouseover="QuickGuide('19');">
                                                <dx:ASPxComboBox ID="dropTipoEdit" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" ValueType="System.String">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                <asp:TextBox ID="TextBox4" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row p-0 m-0">
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label45" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator8" ControlToValidate="dropParcEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto drop-down-div" style="padding-left: 2px" onmouseover="QuickGuide('20');">
                                                <dx:ASPxComboBox ID="dropParcEdit" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.1 %>" Value="1" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.2 %>" Value="0" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label46" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator27" ControlToValidate="dropCareEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto drop-down-div" style="padding-left: 2px" onmouseover="QuickGuide('21');">
                                                <dx:ASPxComboBox ID="dropCareEdit" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.1 %>" Value="1" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.2 %>" Value="0" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <asp:Label ID="Label47" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator34" ControlToValidate="dropSaldoEdit" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                            <div class="input-group mb-auto drop-down-div" style="padding-left: 2px" onmouseover="QuickGuide('22');">
                                                <dx:ASPxComboBox ID="dropSaldoEdit" Enabled="false" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    </ButtonStyle>
                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.1 %>" Value="1" />
                                                        <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.2 %>" Value="0" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="col-x1 p-0">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                <asp:TextBox ID="TextBox3" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba3');">
                                <asp:Button ID="linkReplicarBtn" ClientIDMode="Static" OnClick="linkReplicar_Click" runat="server" CssClass="d-none" Text="Button" />
                                <a id="linkReplicar" class="card-link" data-toggle="collapse" href="#collapseAlterarBases">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label25" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp3_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseAlterarBases" class="collapse" data-parent="#cardAlterar">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <asp:Panel ID="Panel1" runat="server" Height="200px" ScrollBars="Vertical" Width="100%" GroupingText="">
                                        <div class="container">
                                            <div class="row">
                                                <div class="col-12">
                                                    <asp:Repeater ID="rptBasesEdit" runat="server" OnPreRender="rptBasesEdit_PreRender" OnItemDataBound="rptBasesEdit_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <div class="row">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <div class="col-x1 p-0">

                                                                <asp:Label ID="Label29" runat="server" CssClass="labels text-left" Text='<%#DataBinder.Eval(Container.DataItem, "CJDSDECR")%>'></asp:Label>
                                                                <div class="input-group mb-auto" style="padding-left: 2px">
                                                                    <table style="width: 100%; padding-left: 2px">
                                                                        <tr>
                                                                            <td style="text-align: right; padding-right: 10px" class=" tblRptControl">
                                                                                <asp:HiddenField ID="hfName" runat="server" Value='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>' />
                                                                                <asp:HiddenField ID="hfArgument" runat="server" Value='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>' />
                                                                                <asp:HiddenField ID="hfTexto" runat="server" Value='<%#DataBinder.Eval(Container.DataItem, "CJTPCTTX")%>' />
                                                                                <asp:LinkButton ID="lnkRptBasesEdit" CausesValidation="false" Visible="true" Font-Size="Small" ForeColor="DimGray" ClientIDMode="Static" runat="server" OnCommand="BasesEdit"
                                                                                    CommandName='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>'
                                                                                    CommandArgument='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>' Style="padding-bottom: 3px">
                                                                                                <%# Eval("CJTPIDTP").ToString()=="10"||Eval("CJTPIDTP").ToString()=="6" ? Eval("CJVLPROP").ToString()=="0" ? Eval("CJVLPROP").ToString() : DataBinder.Eval(Container.DataItem, "CJVLPROP", "{0:N2}") : Eval("CJTPCTTX").ToString() %>

                                                                                </asp:LinkButton>

                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                            <div class="col-x0"></div>
                                                            <asp:Literal ID="ltrlRepeaterBasesEdit" runat="server"></asp:Literal>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </div>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba4');">
                                <a class="card-link" data-toggle="collapse" href="#collapseAlterarVerbas">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label53" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, aquisição_grp5_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseAlterarVerbas" class="collapse" data-parent="#cardAlterar">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <dx:ASPxGridView ID="gridVerbasAlt" ClientInstanceName="gridVerbasAlt" KeyFieldName="VIIDMODA" ClientIDMode="Static" Width="800px" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVerbasAlt"
                                        OnCellEditorInitialize="gridVerbasAlt_CellEditorInitialize" OnRowValidating="gridVerbasAlt_RowValidating" OnBatchUpdate="gridVerbasAlt_BatchUpdate">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings VerticalScrollableHeight="594" HorizontalScrollBarMode="Auto" />
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
                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" MaxWidth="50" Width="50px" Caption="  " ShowDeleteButton="true" ButtonRenderMode="Image" VisibleIndex="0"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="MOIDMODA" VisibleIndex="0" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col1 %>">
                                                <PropertiesComboBox DataSourceID="sqlVerbas" ValueType="System.Int32" TextField="MODSMODA" ValueField="MOIDMODA"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="ID" VisibleIndex="2" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col2 %>">
                                                <PropertiesComboBox DataSourceID="sqlBaseNegociada" ValueField="ID" TextField="CJDSDECR" ValueType="System.String" ConvertEmptyStringToNull="true">
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="VITPPGTO" VisibleIndex="3" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col3 %>">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Boleto" Value="1" />
                                                        <dx:ListEditItem Text="Transferência" Value="2" />
                                                        <dx:ListEditItem Text="Débito Conta" Value="3" />
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="VIDIAMOD" MaxWidth="110" Width="110px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col4 %>" VisibleIndex="1">
                                                <PropertiesTextEdit>
                                                    <MaskSettings Mask="<1..31>" IncludeLiterals="None" />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PFIDCRED" MaxWidth="170" Width="170px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col5 %>" VisibleIndex="4">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PFIDDEBI" MaxWidth="170" Width="170px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col6 %>" VisibleIndex="5">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                            <Header Font-Names="Arial" Font-Size="9pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
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
                                    <asp:SqlDataSource ID="sqlBaseNegociada" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="SELECT CJ.CJDSDECR,concat(CJ.CHIDCODI,'#',CJ.CJIDCODI) AS ID FROM CJCLPROP CJ,OPCONTRA OP, PRPRODUT PR, VIPROEVE VI
WHERE OP.OPIDCONT=?
  AND PR.prprodid=OP.PRPRODID
  AND CJ.CHIDCODI=PR.chidcodi
  AND CJ.CJTPIDTP=6
  AND VI.CHIDCODI=PR.chidcodi
  AND VI.CJIDCODI=CJ.CJIDCODI
  AND VI.CHTPIDEV=45">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource runat="server" ID="sqlVerbasAlt" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select m.MOIDMODA,v.VIIDMODA, case when V.CHIDCODI is null then '' else CONCAT(V.CHIDCODI,'#',V.CJIDCODI) end AS ID,convert(int,v.VIDIAMOD) as VIDIAMOD,convert(int,v.VITPPGTO) as VITPPGTO,PFIDCRED,PFIDDEBI from VIOPMODA v, MODALIDA m where m.MOIDMODA=v.MOIDMODA and m.MOTPIDCA=10 and v.OPIDCONT=?">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba5');">
                                <a class="card-link" data-toggle="collapse" onclick="gedShow()" style="cursor: pointer">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label38" CssClass="labels" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp4_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseAlterarArqs" class="collapse" data-parent="#cardAlterar">
                                <div class="card-body bg-transparent pb-0 pt-2 ml-2">
                                    <asp:UpdatePanel ID="updFilesAlterar" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="filesAlterar" />
                                            <asp:AsyncPostBackTrigger ControlID="gridFilesAlterar" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <div class="row p-0 ">
                                                <dx:ASPxUploadControl Enabled="false" ID="filesAlterar" AutoStartUpload="true" runat="server" UploadMode="Advanced" Theme="Material" Width="500px"
                                                    OnFileUploadComplete="filesAlterar_FileUploadComplete" BrowseButton-Text="<%$Resources:Aquisicao, aquisição_grp4_btn %>">
                                                    <ClientSideEvents FilesUploadComplete="function(s,e){ gridFilesAlterar.Refresh(); }" />
                                                    <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                                    <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.pdf,.doc,.docx">
                                                    </ValidationSettings>
                                                </dx:ASPxUploadControl>
                                            </div>
                                            <div class="row p-0 mt-2">
                                                <dx:ASPxGridView ID="gridFilesAlterar" ClientIDMode="Static" ClientInstanceName="gridFilesAlterar" Width="500px" runat="server" KeyFieldName="FILEIDFI" OnBatchUpdate="gridFilesAlterar_BatchUpdate" Theme="Material" DataSourceID="sqlFileContratos" AutoGenerateColumns="False">
                                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                    <SettingsEditing Mode="Batch"></SettingsEditing>
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
                                                        <dx:GridViewCommandColumn ShowDeleteButton="True" Width="20px" MaxWidth="20" ButtonRenderMode="Image" Caption=" " VisibleIndex="0"></dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="30px" MaxWidth="30" EditFormSettings-Visible="False" VisibleIndex="1" Caption="<%$Resources:Aquisicao, aquisição_grp4_grid_col1 %>"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="FILENAME" Width="400px" MaxWidth="400" CellStyle-Wrap="False" EditFormSettings-Visible="False" VisibleIndex="2" Caption="<%$Resources:Aquisicao, aquisição_grp4_grid_col2 %>"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataHyperLinkColumn FieldName="FILEPATH" CellStyle-CssClass="text-center" Width="50px" MaxWidth="50" EditFormSettings-Visible="False" Caption=" " VisibleIndex="3">
                                                            <PropertiesHyperLinkEdit Target="_blank" ImageUrl="~/icons/icons8-open-view-20.png"></PropertiesHyperLinkEdit>
                                                        </dx:GridViewDataHyperLinkColumn>
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
                                                    <StylesPager CurrentPageNumber-BackColor="#669999"></StylesPager>
                                                </dx:ASPxGridView>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                    </div>

                </asp:Panel>
                <asp:Panel ID="pnlInsert" Visible="false" runat="server">
                    <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
                    <div id="cardInsert">
                        <%--Painel com campos para Insert--%>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 pt-0 mr-2 ml-2" style="height: 40px" onmouseover="QuickGuide('aba1');">
                                <a class="card-link" data-toggle="collapse" href="#collapseInsertInfo" aria-expanded="true">
                                    <h5 style="text-align: left; float: left;"><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label7" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp1_titulo1 %>"></asp:Label></h5>
                                    <asp:Panel ID="pnlHeaderInsert" runat="server">
                                        <h5 style="text-align: right; float: left; padding-left: 5px">
                                            <asp:Label ID="Label71" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp1_subtitulo1 %> "></asp:Label>
                                            <asp:Label ID="txtCodInternoInsert" runat="server" CssClass="labels" Text=""></asp:Label></h5>
                                    </asp:Panel>

                                    <asp:Panel ID="pnlHeaderRequest" runat="server">
                                        <h5 style="text-align: right; float: left; padding-left: 5px">
                                            <asp:Label ID="lblMsgModoReq" runat="server" CssClass="labels" Text="Requisição de Contrato" ForeColor="DarkRed"></asp:Label></h5>
                                    </asp:Panel>

                                </a>
                            </div>
                            <div id="collapseInsertInfo" class="collapse show" data-parent="#cardInsert">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <asp:Panel ID="pnlGeraisInsert" runat="server" GroupingText="" Width="100%">
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblEstruturaCorporativaInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" style="margin-top: 2px" onmouseover="QuickGuide('1');">
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
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator19" ValidationGroup="InsertReq" ControlToValidate="ddeEstruturaInsert" runat="server" ForeColor="Red" Display="None" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl1 %>"></asp:RequiredFieldValidator>
                                                                <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass=" drop-down" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                                                    Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
                                                                    <ClientSideEvents Init="UpdateSelection" DropDown="OnDropDown" />
                                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                    </ButtonStyle>
                                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    <DropDownWindowTemplate>
                                                                        <div>
                                                                            <dx:ASPxTreeList ID="TreeList" DataSourceID="SqlDataSource1" ClientInstanceName="TreeList" runat="server"
                                                                                Width="350px" OnCustomJSProperties="TreeList_CustomJSProperties" Theme="Material"
                                                                                KeyFieldName="TVIDESTR" ParentFieldName="TVCDPAIE" OnLoad="TreeList_Load">
                                                                                <Settings VerticalScrollBarMode="Auto" ScrollableHeight="150" />
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
                                                                                        <ClientSideEvents Click="function(s,e) {
                                                            UpdateSelection();
                                                            if (document.getElementById('hfDropEstr').value != '') {
                                                                document.getElementById('btnSelEmp').click();
                                                            }
                                                            }" />
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
                                                    <asp:TextBox ID="txtEstruturaCorporativaInsert" Visible="false" Width="95%" CssClass="text-boxes" AutoPostBack="True" runat="server"></asp:TextBox>
                                                    <div class="input-group-append">
                                                        <asp:ImageButton ID="btnEstruturaCorpInsert" Visible="false" CausesValidation="false" Style="position: absolute; right: 5%" runat="server" ImageUrl="~/icons/lupa.png" OnClick="btnEstruturaCorpInsert_Click" />
                                                    </div>
                                                </div>
                                                <div id="ModalEstrutura" class="modal fade" role="dialog">
                                                    <div class="modal-dialog modal-lg">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <asp:Button ID="Button1" runat="server" CssClass="close btn btn-sm btn-outline-light" Text="X" Font-Size="Small" />
                                                            </div>
                                                            <div class="modal-body">
                                                                <asp:Panel ID="pnlEstruturaCorpInsert" runat="server" Visible="false">
                                                                    <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Selecionar" OnClick="ASPxButton1_Click1"></dx:ASPxButton>
                                                                    <dx:ASPxTreeList ID="treeEstrutura" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
                                                                        KeyFieldName="TVIDESTR" EnableViewState="false" ParentFieldName="TVCDPAIE" OnSelectionChanged="treeEstrutura_SelectionChanged">
                                                                        <Columns>
                                                                            <dx:TreeListTextColumn FieldName="TVDSESTR" Caption="Descrição" AutoFilterCondition="Default" ShowInFilterControl="Default" VisibleIndex="1"></dx:TreeListTextColumn>
                                                                        </Columns>
                                                                        <SettingsBehavior ExpandCollapseAction="Button" ProcessSelectionChangedOnServer="true" />
                                                                        <SettingsSelection Recursive="false" Enabled="True"></SettingsSelection>

                                                                    </dx:ASPxTreeList>
                                                                    <asp:TreeView ID="TreeView1" runat="server" Visible="false" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged">
                                                                    </asp:TreeView>
                                                                </asp:Panel>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label64" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('2');">
                                                    <dx:ASPxDropDownEdit ID="ddeImovelLoja" Visible="true" CssClass="drop-down" ClientIDMode="Static" ClientInstanceName="ddeImovelLoja" Theme="Material"
                                                        Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <DropDownWindowTemplate>
                                                            <div>
                                                                <dx:ASPxCheckBoxList ID="checkListImoveis" runat="server" DataSourceID="sqlImovelLoja" TextField="REREGIAO" ValueField="REIDIMOV" ValueType="System.Int32" Theme="Material">
                                                                    <ClientSideEvents SelectedIndexChanged="function (s,e)
                                                                    {
                                                                        ddeImovelLoja
                                                                        var items = s.GetSelectedItems();
                                                                        var texto = '';
                                                                        for (var i = 0; i &lt; items.length; i++) {  
                                                                                texto += items[i].text;
                                                                                texto += '; ';
                                                                            }
                                                                        ddeImovelLoja.SetText(texto);
                                                                    }" />

                                                                </dx:ASPxCheckBoxList>
                                                            </div>
                                                        </DropDownWindowTemplate>
                                                    </dx:ASPxDropDownEdit>
                                                    <asp:SqlDataSource runat="server" ID="sqlImovelLoja" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                        
SelectCommand="select R.REREGIAO,R.REIDIMOV from REIMOVEL R
WHERE R.TVIDESTR=?">
                                                        <SelectParameters>
                                                            <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl31 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('31');">
                                                    <asp:TextBox ID="txtOperadorInsert" Width="100%" Enabled="false" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblNumProcessoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl4 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator9" ValidationGroup="InsertReq" ControlToValidate="txtNumProcessoInsert" runat="server" ForeColor="Red" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl3 %>"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('4');">
                                                    <asp:TextBox ID="txtNumProcessoInsert" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblDescricaoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator10" ValidationGroup="InsertReq" ControlToValidate="txtDescricaoInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl5 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('5');">
                                                    <dx:ASPxTextBox ID="txtDescricaoInsert" MaxLength="60" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                        <ValidationSettings ValidateOnLeave="true" RegularExpression-ValidationExpression="[^']*" ErrorDisplayMode="None"></ValidationSettings>
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxTextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblCodAuxInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('6');">
                                                    <asp:TextBox ID="txtCodAuxInsert" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblDtAquisiInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator11" ValidationGroup="InsertReq" ControlToValidate="txtDtAquisiInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl6 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('7');">
                                                    <dx:ASPxDateEdit ID="txtDtAquisiInsert" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblHrAquisiInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl8 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator12" ValidationGroup="InsertReq" ControlToValidate="txtDtAssInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('8');">
                                                    <dx:ASPxDateEdit ID="txtDtAssInsert" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
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
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label31" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl9 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator20" ValidationGroup="InsertReq" ControlToValidate="txtDtEncerraInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto " style="margin-top: 1px" onmouseover="QuickGuide('9');">
                                                    <dx:ASPxDateEdit ID="txtDtEncerraInsert" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblValorContInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl10 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator13" ValidationGroup="InsertReq" ControlToValidate="txtValorContInsert2" InitialValue="0,00" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl13 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('10');">
                                                    <dx:ASPxTextBox ID="txtValorContInsert2" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%">
                                                        <MaskSettings Mask="<0..9999999999g>.<00..999999>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
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
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label62" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl11 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator32" ValidationGroup="InsertReq" ControlToValidate="txtIniPagInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto " style="margin-top: 1px" onmouseover="QuickGuide('11');">
                                                    <dx:ASPxDateEdit ID="txtIniPagInsert" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below">
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
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label61" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl12 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator28" ValidationGroup="InsertReq" ControlToValidate="txtFimPagInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto " style="margin-top: 1px" onmouseover="QuickGuide('12');">
                                                    <dx:ASPxDateEdit ID="txtFimPagInsert" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
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
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblEstruturaInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl13 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator14" ValidationGroup="InsertReq" ControlToValidate="dropEstruturaInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl8 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('13');">
                                                    <dx:ASPxComboBox ID="dropEstruturaInsert2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropEstruturaInsert2" CssClass="drop-down" runat="server" DataSourceID="sqlEstruturaInsert"
                                                        TextField="cmtpdscm" ValueField="cmtpidcm" Theme="Material" Width="100%">
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCountryChanged(s); }"></ClientSideEvents>
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlEstruturaInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                        SelectCommand="select cmtpdscm, cmtpidcm from cmtpcmcl where paidpais = ? order by cmtpidcm">
                                                        <SelectParameters>
                                                            <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblClasseProdutoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl14 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator15" ValidationGroup="InsertReq" ControlToValidate="dropClasseProdutoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl9 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('14');">
                                                    <dx:ASPxComboBox ID="dropClasseProdutoInsert2" ForeColor="dimgray" AllowInputUser="false" OnCallback="dropClasseProdutoInsert2_Callback" ClientInstanceName="dropClasseProdutoInsert2" runat="server" CssClass="drop-down" DataSourceID="sqlClasseProdutosInsert"
                                                        TextField="PRTPNMOP" ValueField="PRTPIDOP" Theme="Material" Width="100%">
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { OnClasseInsertChanged(s); }"></ClientSideEvents>
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlClasseProdutosInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select PRTPNMOP,PRTPIDOP from prtpoper po, cmtpcmcl cm
            where cm.cmtpidcm = ?
            and cm.paidpais = ?
            and po.cmtpidcm = cm.cmtpidcm
            and po.paidpais = cm.paidpais
            order by po.prtpnmop">
                                                        <SelectParameters>
                                                            <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                            <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblProdutoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl15 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator16" ValidationGroup="InsertReq" ControlToValidate="dropProdutoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl10 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <dx:ASPxImage ID="ASPxImage1" runat="server" ShowLoadingImage="true" ImageUrl="~/icons/icons8-question-mark-40.png" Width="10px">
                                                    <ClientSideEvents Click="function (s,e) { popupTipologia.Show(); }" />
                                                </dx:ASPxImage>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('15');">
                                                    <dx:ASPxComboBox ID="dropProdutoInsert2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropProdutoInsert2" OnCallback="dropProdutoInsert2_Callback" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlProdutoInsert" TextField="prprodes" ValueField="value">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <%--<asp:DropDownList ID="dropProdutoInsert" Width="100%" CssClass="drop-down2" runat="server" AutoPostBack="False" OnSelectedIndexChanged="dropProdutoInsert_SelectedIndexChanged"></asp:DropDownList>--%>
                                                    <asp:SqlDataSource runat="server" ID="sqlProdutoInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select CONCAT(pr.prprodid,'|',pr.chidcodi) value, pr.prprodes
            from prprodut pr, prtpoper po, cmtpcmcl cm,TPESTRPR T 
            where cm.cmtpidcm = ?
            and po.PRTPIDOP = ?
            and cm.paidpais = ?
            and t.TVIDESTR=?
            and t.PRPRODID = pr.prprodid
            and po.cmtpidcm = cm.cmtpidcm
            and po.paidpais = cm.paidpais            
            and pr.prtpidop = po.PRTPIDOP
            and pr.cmtpidcm = po.cmtpidcm
            order by 2">
                                                        <SelectParameters>
                                                            <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                            <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                            <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                            <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblCarteiraInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp1_lbl16 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator17" ValidationGroup="InsertReq" ControlToValidate="dropCarteiraInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp1_lbl11 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('16');">
                                                    <dx:ASPxComboBox ID="dropCarteiraInsert2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropCarteiraInsert2" runat="server" OnCallback="dropCarteiraInsert2_Callback" CssClass="drop-down" Theme="Material" Width="100%" TextField="CADSCTRA" ValueField="CAIDCTRA">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>

                                        </div>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                        <dx:ASPxPopupControl ID="popupTipologia" ClientInstanceName="popupTipologia" runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                            HeaderText="<%$Resources:Tipologia, tipologia_label2 %>" AllowDragging="true">
                            <ContentCollection>
                                <dx:PopupControlContentControl>
                                    <asp:Button ID="btnGridDisponiveisDuploClick" ClientIDMode="Static" OnClick="btnGridDisponiveisDuploClick_Click" CssClass="Loading d-none" runat="server" Text="Button" />
                                    <dx:ASPxGridView ID="gridDisponiveis" ClientInstanceName="gridDisponiveis" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False" SettingsPager-Visible="False" DataSourceID="sqlDisponiveis"
                                        OnDataBound="gridDisponiveis_DataBound" OnCustomCallback="gridDisponiveis_CustomCallback">
                                        <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />
                                        <ClientSideEvents RowDblClick=" function(s,e) {
                                                    gridDisponiveis.PerformCallback(s.GetFocusedRowIndex());
                                                    popupTipologia.Hide();
                                                    document.getElementById('btnGridDisponiveisDuploClick').click();
                                                            } " />
                                        <SettingsPopup>
                                            <FilterControl HorizontalAlign="WindowCenter"></FilterControl>
                                            <CustomizationWindow HorizontalAlign="WindowCenter" />
                                            <EditForm HorizontalAlign="WindowCenter"></EditForm>
                                            <HeaderFilter Height="200">
                                                <SettingsAdaptivity Mode="OnWindowInnerWidth" HorizontalAlign="WindowCenter" SwitchAtWindowInnerWidth="768" MinHeight="300" />
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsBehavior AllowFocusedRow="true" />
                                        <Settings ShowFilterRow="true" ShowHeaderFilterButton="false" />
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
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings VerticalScrollableHeight="230" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="VirtualSmooth" />

                                        <StylesFilterControl ActiveTab-HorizontalAlign="Left"></StylesFilterControl>
                                        <StylesPager>
                                            <PageNumber Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray"></PageNumber>
                                        </StylesPager>
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="prprodes" Settings-AllowAutoFilter="False" Width="75px" MaxWidth="75" Caption="<%$Resources:Tipologia, tipologia_grid1_col1 %>" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="prprodid" Visible="false" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="origem" Width="80px" MaxWidth="80" Caption="<%$Resources:Tipologia, tipologia_grid1_col2 %>" ReadOnly="true" VisibleIndex="2">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_1-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_1-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="capital" Width="80px" MaxWidth="80" Caption="<%$Resources:Tipologia, tipologia_grid1_col3 %>" VisibleIndex="3">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_2-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_2-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="usgaap" Width="80px" MaxWidth="80" Caption="<%$Resources:Tipologia, tipologia_grid1_col4 %>" VisibleIndex="4">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_3-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_3-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="impostos" Width="90px" MaxWidth="90" Caption="<%$Resources:Tipologia, tipologia_grid1_col5 %>" VisibleIndex="5">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_4-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_4-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="reajustes" Width="80px" MaxWidth="80" Caption="<%$Resources:Tipologia, tipologia_grid1_col6 %>" VisibleIndex="6">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_5-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_5-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="carencia" Width="80px" MaxWidth="80" Caption="<%$Resources:Tipologia, tipologia_grid1_col7 %>" VisibleIndex="7">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_6-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_6-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="fluxo" Width="70px" MaxWidth="70" Caption="<%$Resources:Tipologia, tipologia_grid1_col8 %>" VisibleIndex="8">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_7-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_7-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="calculo" Width="80px" MaxWidth="80" Caption="<%$Resources:Tipologia, tipologia_grid1_col9 %>" VisibleIndex="9">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_8-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_8-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="depreciacao" Width="70px" MaxWidth="70" Caption="<%$Resources:Tipologia, tipologia_grid1_col10 %>" VisibleIndex="10">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_9-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_9-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="remensuracao" Width="70px" MaxWidth="70" Caption="<%$Resources:Tipologia, tipologia_grid1_col11 %>" VisibleIndex="11">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_10-1 %>" Value="1"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="<%$Resources:Tipologia, tipologia_quiz_10-2 %>" Value="0"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                            <Header Paddings-PaddingLeft="0px" Paddings-PaddingRight="0px" Wrap="True" HorizontalAlign="Center" VerticalAlign="Middle" Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            </Row>
                                            <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                            <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                <Paddings Padding="0px" />
                                            </BatchEditCell>
                                            <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                            <FocusedRow BackColor="LightGreen"></FocusedRow>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource ID="sqlDisponiveis" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT p.prprodes,p.prprodid,origem,capital,usgaap,impostos,reajustes,carencia,fluxo,calculo,depreciacao,remensuracao FROM PRPRODUT P
WHERE cmtpidcm is not NULL and not exists (select null from TPESTRPR T WHERE T.TVIDESTR = ? AND P.PRPRODID=T.PRPRODID)">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfDropEstr" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </dx:PopupControlContentControl>
                            </ContentCollection>

                        </dx:ASPxPopupControl>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba2');">
                                <a class="card-link" data-toggle="collapse" href="#collapseInsertClass">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label8" runat="server" CssClass="labels" Text="<%$ Resources:Aquisicao, aquisição_grp2_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <div id="collapseInsertClass" class="collapse" data-parent="#cardInsert">
                                    <asp:Panel ID="pnlClassificacaoInsert" runat="server" Width="100%">
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl1 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="InsertReq" ControlToValidate="dropAgenteFinanceiroInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp2_lbl1 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('17');">
                                                    <dx:ASPxComboBox ID="dropAgenteFinanceiroInsert2" ClientInstanceName="dropAgenteFinanceiroInsert2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" OnCallback="dropAgenteFinanceiroInsert2_Callback" TextField="FONMAB20" ValueField="FOIDFORN">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlAgenteFinanceiro" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT FOIDFORN,FONMAB20 FROM FOFORNEC FO where TVIDESTR IS NULL ORDER BY 2"></asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label54" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('18');">
                                                    <dx:ASPxComboBox ID="dropBenefIns" ClientInstanceName="dropBenefIns" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" OnCallback="dropBenefIns_Callback" TextField="FONMAB20" ValueField="FOIDFORN">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblTipoInsert" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl3 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator18" ValidationGroup="InsertReq" ControlToValidate="dropTipoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:Aquisicao, aquisição_grp2_lbl3 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" style="padding-left: 2px" onmouseover="QuickGuide('19');">
                                                    <dx:ASPxComboBox ID="dropTipoInsert2" ForeColor="dimgray" ClientInstanceName="dropTipoInsert2" OnCallback="dropTipoInsert2_Callback" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlTipoInsert" ValueField="optptpid" TextField="optptpds">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlTipoInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                        SelectCommand="select optptpid, optptpds
            from optptipo
            where cmtpidcm = ?
            and paidpais = ?
            order by optptpid">
                                                        <SelectParameters>
                                                            <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                            <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" Name="?" DbType="Int32"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <br />
                                                <div class="input-group mb-auto" style="margin-top: 1px">
                                                    <asp:TextBox ID="TextBox5" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label42" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator23" ValidationGroup="InsertReq" ControlToValidate="dropParcInsert" runat="server" Text="*" ErrorMessage="Parcela Uniforme" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('20');">
                                                    <dx:ASPxComboBox ID="dropParcInsert" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <Items>
                                                            <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.1 %>" Value="1" Selected="true" />
                                                            <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl4.2 %>" Value="0" />
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label43" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator24" ValidationGroup="InsertReq" ControlToValidate="dropCareInsert" runat="server" Text="*" ErrorMessage="Carência" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('21');">
                                                    <dx:ASPxComboBox ID="dropCareInsert" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <Items>
                                                            <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.1 %>" Value="1" />
                                                            <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl5.2%>" Value="0" Selected="true" />
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label44" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="RequiredFieldValidator25" ValidationGroup="InsertReq" ControlToValidate="dropSaldoInsert" runat="server" Text="*" ErrorMessage="Saldo Implantado" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('22');">
                                                    <dx:ASPxComboBox ID="dropSaldoInsert" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <Items>
                                                            <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.1 %>" Value="1" Selected="true" />
                                                            <dx:ListEditItem Text="<%$ Resources:Aquisicao, aquisição_grp2_lbl6.2 %>" Value="0" />
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <br />
                                                <div class="input-group mb-auto" style="margin-top: 1px">
                                                    <asp:TextBox ID="TextBox1" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba1');">
                                <asp:Button ID="myLinkTagBtn" ClientIDMode="Static" ValidationGroup="InsertReq" Style="display: none" OnClick="myLinkTagBtn_Click" runat="server" Text="Button" />
                                <a id="myLinkTag" class="card-link" data-toggle="collapse" href="#collapseInsertBases">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label9" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, aquisição_grp3_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div class="card-body bg-transparent pb-0 pt-1">
                                <div id="collapseInsertBases" class="collapse" data-parent="#cardInsert">
                                    <asp:Panel ID="pnlBasesInsert_Father" Height="200px" ScrollBars="Vertical" runat="server" Width="100%" GroupingText="">
                                        <div class="container">
                                            <div class="row">
                                                <div class="col-12">
                                        <asp:Repeater ID="rptBasesInserir" runat="server" OnItemDataBound="rptBasesInserir_ItemDataBound" OnPreRender="rptBasesInserir_PreRender">
                                            <HeaderTemplate>
                                                <div class="row">
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div class="col-x1 p-0">
                                                    <asp:Label ID="Label29" runat="server" CssClass="labels text-left" Text='<%#DataBinder.Eval(Container.DataItem, "CJDSDECR") %>'></asp:Label>
                                                    <div class="input-group mb-auto" style="padding-left: 2px">
                                                        <table style="width: 100%; padding-left: 2px">
                                                            <tr>
                                                                <td style="text-align: right; padding-right: 10px" class="tblRptControl">
                                                                    <asp:LinkButton ID="lnkRptBasesInsert" ClientIDMode="Static" runat="server" OnCommand="BasesEdit"
                                                                        CommandName='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>'
                                                                        CommandArgument='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>'>
                                                <%# Eval("CJTPIDTP").ToString()=="10"||Eval("CJTPIDTP").ToString()=="6" ? Eval("CJVLPROP").ToString()=="0" ? Eval("CJVLPROP").ToString() : DataBinder.Eval(Container.DataItem, "CJVLPROP", "{0:N2}") : Eval("CJTPCTTX").ToString() %>
                                                                    </asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                                <div class="col-x0"></div>

                                                <asp:Literal ID="ltrlRepeaterBasesInserir" runat="server"></asp:Literal>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </div>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>

                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba4');">
                                <a class="card-link" data-toggle="collapse" href="#collapseInsertVerbas">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label51" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:Aquisicao, aquisição_grp5_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseInsertVerbas" class="collapse" data-parent="#cardInsert">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <dx:ASPxGridView ID="gridVerbasIns" ClientInstanceName="gridVerbasIns" KeyFieldName="VIIDMODA" ClientIDMode="Static" Width="800px" Theme="Material" runat="server" AutoGenerateColumns="False" DataSourceID="sqlVerbasIns"
                                        OnCellEditorInitialize="gridVerbasIns_CellEditorInitialize" OnRowValidating="gridVerbasIns_RowValidating" OnInit="gridVerbasIns_Init" OnBatchUpdate="gridVerbasIns_BatchUpdate">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />

                                        <Settings VerticalScrollableHeight="594" HorizontalScrollBarMode="Auto" />
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
                                            <dx:GridViewCommandColumn ShowNewButtonInHeader="True" MaxWidth="50" Width="50px" Caption="  " ShowDeleteButton="true" ButtonRenderMode="Image" VisibleIndex="0"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="MOIDMODA" VisibleIndex="0" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col1 %>">
                                                <PropertiesComboBox DataSourceID="sqlVerbas" ValueType="System.Int32" TextField="MODSMODA" ValueField="MOIDMODA"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="ID" VisibleIndex="2" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col2 %>">
                                                <PropertiesComboBox DataSourceID="sqlBaseNegociada" ValueField="ID" TextField="CJDSDECR" ValueType="System.String" ConvertEmptyStringToNull="true">
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="VITPPGTO" VisibleIndex="3" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col3 %>">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Boleto" Value="1" />
                                                        <dx:ListEditItem Text="Transferência" Value="2" />
                                                        <dx:ListEditItem Text="Débito Conta" Value="3" />
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="VIDIAMOD" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col4 %>" VisibleIndex="1">
                                                <PropertiesTextEdit>
                                                    <MaskSettings Mask="<1..31>" IncludeLiterals="None" />
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PFIDCRED" MaxWidth="160" Width="160px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col5 %>" VisibleIndex="4">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PFIDDEBI" MaxWidth="160" Width="160px" Caption="<%$ Resources:Aquisicao, aquisição_grp5_col6 %>" VisibleIndex="5">
                                                <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlContasCredDeb" TextField="conta" ValueField="PFIDPLNC"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                        </Columns>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                            <Header Font-Names="Arial" Font-Size="9pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
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
                                    <asp:SqlDataSource runat="server" ID="sqlVerbasIns" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select m.MOIDMODA,v.VIIDMODA, case when V.CHIDCODI is null then '' else CONCAT(V.CHIDCODI,'#',V.CJIDCODI) end AS ID,convert(int,v.VIDIAMOD) as VIDIAMOD,convert(int,v.VITPPGTO) as VITPPGTO,PFIDCRED,PFIDDEBI from VIOPMODA v, MODALIDA m where m.MOIDMODA=v.MOIDMODA and m.MOTPIDCA=10 and v.OPIDCONT=?">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfCodInterno" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlVerbas" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select m.MODSMODA,m.moidmoda from  modalida m where m.motpidca=10 order by 1"></asp:SqlDataSource>
                                </div>
                            </div>
                        </div>
                        <div class="row card bg-transparent">
                            <div class="card-header bg-transparent pb-0 mr-2 ml-2" onmouseover="QuickGuide('aba5');">
                                <a class="card-link" data-toggle="collapse" onclick="gedShow()" style="cursor: pointer">
                                    <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                        <asp:Label ID="Label39" CssClass="labels" runat="server" Text="<%$ Resources:Aquisicao, aquisição_grp4_titulo %>"></asp:Label></h5>
                                </a>
                            </div>
                            <div id="collapseInsertArqs" class="collapse" data-parent="#cardInsert">
                                <div class="card-body bg-transparent pb-0 pt-1">
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="gridFilesInsert" />
                                            <asp:AsyncPostBackTrigger ControlID="fileInsert" />
                                        </Triggers>
                                        <ContentTemplate>
                                            <div class="row p-0">
                                                <dx:ASPxUploadControl Visible="true" Enabled="false" ID="fileInsert" AutoStartUpload="true" runat="server" UploadMode="Advanced" Theme="Material" Width="500px"
                                                    OnFileUploadComplete="fileInsert_FileUploadComplete" BrowseButton-Text="<%$Resources:Aquisicao, aquisição_grp4_btn %>">
                                                    <ClientSideEvents FilesUploadComplete="function(s,e){ gridFilesInsert.Refresh(); }" />
                                                    <AdvancedModeSettings EnableMultiSelect="false" EnableFileList="True" EnableDragAndDrop="False" />
                                                    <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.pdf,.doc,.docx">
                                                    </ValidationSettings>
                                                </dx:ASPxUploadControl>
                                            </div>
                                            <div class="row p-0">
                                                <dx:ASPxGridView ID="gridFilesInsert" ClientIDMode="Static" ClientInstanceName="gridFilesInsert" Width="500px" runat="server" KeyFieldName="FILEIDFI" Theme="Material" DataSourceID="sqlFileContratos" OnBatchUpdate="gridFilesInsert_BatchUpdate" AutoGenerateColumns="False">
                                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                    <SettingsEditing Mode="Batch"></SettingsEditing>
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
                                                        <dx:GridViewCommandColumn ShowDeleteButton="True" Width="20px" MaxWidth="20" ButtonRenderMode="Image" Caption=" " VisibleIndex="0"></dx:GridViewCommandColumn>
                                                        <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="30px" MaxWidth="30" EditFormSettings-Visible="False" VisibleIndex="1" Caption="<%$Resources:Aquisicao, aquisição_grp4_grid_col1 %>"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataTextColumn FieldName="FILENAME" Width="400px" MaxWidth="400" CellStyle-Wrap="False" EditFormSettings-Visible="False" VisibleIndex="2" Caption="<%$Resources:Aquisicao, aquisição_grp4_grid_col2 %>"></dx:GridViewDataTextColumn>
                                                        <dx:GridViewDataHyperLinkColumn CellStyle-CssClass="text-center" FieldName="FILEPATH" Width="50px" MaxWidth="50" EditFormSettings-Visible="False" Caption=" " VisibleIndex="3">
                                                            <PropertiesHyperLinkEdit Target="_blank" ImageUrl="~/icons/icons8-open-view-20.png"></PropertiesHyperLinkEdit>
                                                        </dx:GridViewDataHyperLinkColumn>
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
                                                    <StylesPager CurrentPageNumber-BackColor="#669999"></StylesPager>
                                                </dx:ASPxGridView>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <asp:ValidationSummary ID="ValidationSummary1" CssClass="labels list_required" ForeColor="Red" ValidationGroup="InsertReq" ShowSummary="true" HeaderText="<%$ Resources:GlobalResource, required %>" DisplayMode="BulletList" runat="server" Style="display: inline-table" />
                        </div>
                    </div>
                </asp:Panel>

            </div>
        </div>
        <dx:ASPxPopupControl ID="popupBasesInsert" CloseAction="CloseButton" CloseOnEscape="false" Modal="true"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="true"
            PopupAnimationType="None" AutoUpdatePosition="true" runat="server">
            <ContentStyle Paddings-PaddingBottom="20px"></ContentStyle>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <asp:MultiView ID="MultiViewInsert" runat="server">
                        <asp:View ID="viewDataI" runat="server">
                            <asp:HiddenField ID="hfTipoData" runat="server" />
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirData" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <%--<ajaxToolkit:CalendarExtender ID="CalendarInserirData" PopupButtonID="txtInserirData" TargetControlID="txtInserirData" ClientIDMode="Static" Enabled="true" runat="server" />
                                            <asp:TextBox ID="" CssClass="text-boxes" runat="server"></asp:TextBox>--%>
                                            <dx:ASPxDateEdit ID="txtInserirData" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
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
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirData" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirData_Click" />

                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                        <asp:View ID="viewMoedaI" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirMoeda" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <dx:ASPxTextBox ID="txtInserirMoeda" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<-9999999..9999999g>.<00..99>" PromptChar="0" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxTextBox>
                                            <%--<asp:TextBox ID="txtInserirMoeda" CssClass="text-boxes valor" runat="server"></asp:TextBox>--%>
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirMoeda" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirMoeda_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                        <asp:View ID="viewInteiroI" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirInteiro" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <asp:TextBox ID="txtInserirInteiro" CssClass="text-boxes" runat="server" TextMode="Number"></asp:TextBox>
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirInteiro" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirInteiro_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                        <asp:View ID="viewFlutuanteI" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirFlutuante" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <dx:ASPxTextBox ID="txtInserirFlutuante" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                <MaskSettings Mask="<-9999999..9999999g>.<00..99>" PromptChar="0" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                                <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                            </dx:ASPxTextBox>
                                            <%--<asp:TextBox ID="txtInserirFlutuante" CssClass="text-boxes valor" runat="server"></asp:TextBox>--%>
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirFlutuante" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirFlutuante_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                        <asp:View ID="viewFormulaI" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirFormula" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <asp:DropDownList ID="dropInserirFormula" CssClass="text-boxes" runat="server"></asp:DropDownList>
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirFormula" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirFormula_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                        <asp:View ID="viewIndiceI" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirIndice" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <asp:TextBox ID="txtInserirIndice" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirIndice" CssClass="btn-using ok" runat="server" OnClick="btnInserirIndice_Click" Text="<%$ Resources:GlobalResource, btn_inserir %>" />
                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                        <asp:View ID="viewSQLI" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirSql" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <asp:DropDownList ID="dropInserirSql" CssClass="text-boxes" runat="server"></asp:DropDownList>
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirSql" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirSql_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                        <asp:View ID="viewDeAteI" runat="server">
                            <div class="row">
                                <div class="col-12">
                                    <dx:ASPxGridView ID="gridDeAteInsert" Theme="DevEx" runat="server" KeyFieldName="ID;De;Ate;Valor" Width="100%" OnBatchUpdate="gridDeAteInsert_BatchUpdate" AutoGenerateColumns="False">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>

                                        <SettingsCommandButton>
                                            <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="20px">
                                                <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="20px">
                                                </Image>
                                            </NewButton>
                                            <DeleteButton Image-ToolTip="Excluir" Image-Url="img/icons8-delete-bin-32.png" Image-Width="20px">
                                                <Image ToolTip="Excluir" Url="img/icons8-delete-bin-32.png" Width="20px">
                                                </Image>
                                            </DeleteButton>
                                            <RecoverButton Image-ToolTip="Cancelar" Image-Url="img/icons8-recyle-32.png" Image-Width="20px">
                                                <Image ToolTip="Cancelar" Url="img/icons8-recyle-32.png" Width="20px">
                                                </Image>
                                            </RecoverButton>
                                        </SettingsCommandButton>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Columns>
                                            <dx:GridViewCommandColumn MaxWidth="8" Width="8" ButtonRenderMode="Image" ButtonType="Image" ShowDeleteButton="true" ShowNewButtonInHeader="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataDateColumn FieldName="De" VisibleIndex="1"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn FieldName="Ate" VisibleIndex="2"></dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="Valor" VisibleIndex="3">
                                                <PropertiesTextEdit DisplayFormatString="n8">
                                                    <MaskSettings Mask="<-9999999..9999999g>.<00..99999999>" PromptChar="0" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                    <ValidationSettings Display="Dynamic"></ValidationSettings>
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <Settings VerticalScrollableHeight="150" />
                                        <SettingsEditing Mode="Batch" />
                                        <Styles>
                                            <StatusBar HorizontalAlign="Left"></StatusBar>
                                            <Header Font-Names="Arial" Font-Size="10pt" ForeColor="DimGray">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray">
                                            </Row>
                                            <AlternatingRow Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                            <BatchEditCell Font-Names="Arial" Font-Size="9pt" ForeColor="DimGray"></BatchEditCell>
                                        </Styles>
                                    </dx:ASPxGridView>
                                </div>
                                <asp:Panel ID="Panel3" Visible="false" runat="server">
                                    <div class="col-sm-3">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblInserirDeAte" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label4" runat="server" Text="Itens: " CssClass="labels text-left"></asp:Label><br />
                                                    <div class="input-group mb-3">
                                                        <asp:TextBox ID="txtqtdItensDeAte" Width="30%" CssClass="text-boxes" TextMode="Number" Text="0" runat="server"></asp:TextBox>
                                                        <div class="input-group-append">
                                                            <asp:Button ID="btnInserirDeAte" CssClass="btn btn-secondary" runat="server" Text="+" OnClick="btnInserirDeAte_Click" />
                                                        </div>
                                                    </div>

                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-sm-9">
                                        <table>
                                            <tr>
                                                <td>
                                                    <table class="table table-hover">
                                                        <thead class="thead-dark">
                                                            <tr>
                                                                <th class="text-center" style="font-family: Arial; font-size: 10px">De</th>
                                                                <th class="text-center" style="font-family: Arial; font-size: 10px">Ate</th>
                                                                <th class="text-center" style="font-family: Arial; font-size: 10px">Valor</th>
                                                            </tr>
                                                        </thead>
                                                        <asp:Repeater ID="rptDeAte" runat="server" ClientIDMode="AutoID">
                                                            <ItemTemplate>
                                                                <tbody>
                                                                    <tr>
                                                                        <td>
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarDt1" Enabled="true" PopupButtonID="txtDt1" ClientIDMode="Static" TargetControlID="txtDt1" runat="server" />
                                                                            <asp:TextBox Font-Names="Arial" Font-Size="10px" ID="txtDt1" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "De")%>'></asp:TextBox></td>
                                                                        <td>
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarDt2" Enabled="true" PopupButtonID="txtDt2" TargetControlID="txtDt2" runat="server" />
                                                                            <asp:TextBox Font-Names="Arial" Font-Size="10px" ID="txtDt2" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Ate")%>'></asp:TextBox></td>
                                                                        <td>
                                                                            <asp:TextBox Font-Names="Arial" Font-Size="10px" ID="txtVl" CssClass="border-1 form-control-sm valor" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Valor")%>'></asp:TextBox></td>
                                                                    </tr>
                                                                </tbody>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnInsertDeAte" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInsertDeAte_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </asp:Panel>
                            </div>
                        </asp:View>
                        <asp:View ID="viewTextoI" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblInserirTexto" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                        <div class="input-group mb-3">
                                            <asp:TextBox ID="txtInserirTexto" CssClass="text-boxes" runat="server"></asp:TextBox>
                                            <div class="input-group-append">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="btnInserirTexto" CssClass="btn-using ok" runat="server" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInserirTexto_Click" />
                                    </td>
                                </tr>
                            </table>
                        </asp:View>
                    </asp:MultiView>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="popupBasesAlterar" ClientInstanceName="popupBasesAlterar" ClientIDMode="Static" CloseAction="CloseButton" CloseOnEscape="false" Modal="true"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="true"
            PopupAnimationType="None" AutoUpdatePosition="true" runat="server" OnLoad="popupBasesAlterar_Load">
            <ClientSideEvents Closing="function(s,e) { document.getElementById('Button10gridDeAte').click(); }" 
                CloseButtonClick="function(s,e) { document.getElementById('Button10gridDeAte').click(); }"
                CloseUp="function(s,e) { document.getElementById('Button10gridDeAte').click(); }"/>
            <ContentStyle Paddings-PaddingBottom="20px"></ContentStyle>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <div class="text-center">
                        <asp:Panel ID="pnlGridEdit" runat="server">
                            <asp:HiddenField ID="hfOPIDCONT2" runat="server" />
                            <asp:HiddenField ID="hfCHIDCODI2" runat="server" />
                            <asp:HiddenField ID="hfCJIDCODI2" runat="server" />
                            <asp:HiddenField ID="hfCJTPIDTP2" runat="server" />
                            <asp:MultiView ID="MultiView1" runat="server">
                                <asp:View ID="viewData" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblEditarData" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxCallback ID="callData" ClientInstanceName="callData" runat="server" OnCallback="callData_Callback">
                                                        <ClientSideEvents CallbackComplete="function(s, e) { 
        validatedOnServer = true;
        if (e.result == 'valid') {
            txtEditarData.SetIsValid(true); 
            try{btnEditarData.SetText(btnSalvarTexto);btnDeleteData.SetEnabled(true);}catch{}
        }
        else {
            txtEditarData.SetIsValid(false); 
                                                            if(e.result.indexOf('[DELETE]')&gt;=0)
                                                                {
                                                                    txtEditarData.SetErrorText(e.result.replace('[DELETE]',''));
                                                                    try{btnDeleteData.SetEnabled(false);btnEditarData.SetText(btnValidarTexto);}catch{}
                                                                }
                                                                else
                                                                {
                                                                    txtEditarData.SetErrorText(e.result);
                                                                }
            
        }
        OnUpdateControlValue(s, e,btnEditarData,txtEditarData); 
    }" />
                                                    </dx:ASPxCallback>
                                                    <dx:ASPxDateEdit ID="txtEditarData" ClientInstanceName="txtEditarData" ForeColor="dimgray" CssClass="drop-down" Theme="Material" AllowUserInput="true" UseMaskBehavior="True" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Below" PopupHorizontalAlign="RightSides">
                                                        <ClientSideEvents Init="function(s,e) { btnEditarData.SetText(btnValidarTexto); }"
                                                            Validation="function(s, e,) {
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            OnUpdateControlValue(s, e,btnEditarData,txtEditarData);
            callData.PerformCallback('');
        
    }" />
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
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic">
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                    </dx:ASPxDateEdit>
                                                    <div class="input-group-append">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarData" ClientInstanceName="btnEditarData" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false" OnClick="btnEditarData_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarData" CssClass="btn-using ok p-2" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarData_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarDataDel" ClientInstanceName="btnDeleteData" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarDataDel" CssClass="ml-3 btn-using cancelar p-2" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewMoeda" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblEditarMoeda" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxCallback ID="callMoeda" ClientInstanceName="callMoeda" runat="server" OnCallback="callMoeda_Callback">
                                                        <ClientSideEvents CallbackComplete="function(s, e) { 
        validatedOnServer = true;
        if (e.result == 'valid') {
            txtEditarMoeda.SetIsValid(true); 
            try{btnEditarMoeda.SetText(btnSalvarTexto);btnDeleteMoeda.SetEnabled(true);}catch{}
        }
        else {
            txtEditarMoeda.SetIsValid(false); 
                                                            if(e.result.indexOf('[DELETE]')&gt;=0)
                                                                {
                                                                    txtEditarMoeda.SetErrorText(e.result.replace('[DELETE]',''));
                                                                    try{btnDeleteMoeda.SetEnabled(false);btnEditarMoeda.SetText(btnValidarTexto);}catch{}
                                                                }
                                                                else
                                                                {
                                                                    txtEditarMoeda.SetErrorText(e.result);
                                                                }
            
        }
        OnUpdateControlValue(s, e,btnEditarMoeda,txtEditarMoeda); 
    }" />
                                                    </dx:ASPxCallback>
                                                    <dx:ASPxTextBox ID="txtEditarMoeda" ClientInstanceName="txtEditarMoeda" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                        <ClientSideEvents Init="function(s,e) { btnEditarMoeda.SetText(btnValidarTexto); if(s.GetText()=='__________') s.SetText(''); } "
                                                            KeyPress="function(s, e) { OnUpdateControlValue(s, e,btnEditarMoeda,txtEditarMoeda); }" 
                                                            TextChanged="function(s, e) { OnUpdateControlValue(s, e,btnEditarMoeda,txtEditarMoeda); }"
                                                            Validation="function(s, e,) {
        if(e.isValid && !validatedOnServer) {
            var value = parseFloat(e.value);
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            callMoeda.PerformCallback('');
        }
    }"
                                                            KeyDown="function(s, e) { validatedOnServer = false; }" />
                                                        <MaskSettings Mask="<-9999999..9999999g>.<00..99999>" PromptChar="0" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic">
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxTextBox>
                                                    <div class="input-group-append">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarMoeda" ClientInstanceName="btnEditarMoeda" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false" OnClick="btnEditarMoeda_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarMoeda" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarMoeda_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="Button4" ClientInstanceName="btnDeleteMoeda" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="Button4" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewInteiro" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <%--<asp:CustomValidator ID="CustomValidator1" EnableClientScript="false" Display="Dynamic" ControlToValidate="txtEditarInteiro" runat="server" ValidationGroup="grpInteiro" ValidateEmptyText="true" OnServerValidate="CustomValidator1_ServerValidate" ErrorMessage="CustomValidator"></asp:CustomValidator>--%>
                                                <asp:Label ID="lblEditarInteiro" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxCallback ID="callInteiro" ClientInstanceName="callInteiro" runat="server" OnCallback="ASPxCallback1_Callback">
                                                        <ClientSideEvents CallbackComplete="function(s, e) { 
        validatedOnServer = true;
        if (e.result == 'valid') {
            txtEditarInteiro.SetIsValid(true); 
            try{btnEditarInteiro.SetText(btnSalvarTexto);btnDeleteInteiro.SetEnabled(true);}catch{}
        }
        else {
            txtEditarInteiro.SetIsValid(false); 
            if(e.result.indexOf('[DELETE]')&gt;=0)
                {
                    txtEditarInteiro.SetErrorText(e.result.replace('[DELETE]',''));
                    try{btnDeleteInteiro.SetEnabled(false);btnEditarInteiro.SetText(btnValidarTexto);}catch{}
                }
                else
                {
                    txtEditarInteiro.SetErrorText(e.result);
                }
            
        }
        OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); 
    }" />
                                                    </dx:ASPxCallback>
                                                    <dx:ASPxTextBox ID="txtEditarInteiro" ClientInstanceName="txtEditarInteiro" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                        <ClientSideEvents 
                                                           Init="function(s,e) { btnEditarInteiro.SetText(btnValidarTexto); if(s.GetText()=='__________') s.SetText(''); } "
                                                         ValueChanged="function(s, e) { OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); }"
                                                         UserInput="function(s, e) { OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); }"
                                                           KeyUp="function(s, e) { OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); }" 
                                                           LostFocus="function(s, e) { OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); }" 
                                                           GotFocus="function(s, e) { OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); }" 
                                                            KeyPress="function(s, e) { OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); }" 
                                                            TextChanged="function(s, e) { OnUpdateControlValue(s, e,btnEditarInteiro,txtEditarInteiro); }"
                                                            Validation="function(s, e,) {
        if(e.isValid && !validatedOnServer) {
            var value = parseFloat(e.value);
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            callInteiro.PerformCallback('');
        }
    }"
                                                            KeyDown="function(s, e) { validatedOnServer = false; }" />
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic" >
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxTextBox>

                                                    <div class="input-group-append">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarInteiro" ClientInstanceName="btnEditarInteiro" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false"  OnClick="btnEditarInteiro_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" OnClick="btnEditarInteiro_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="Button5" ClientInstanceName="btnDeleteInteiro" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="Button5" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewFlutuante" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">

                                                <asp:Label ID="lblEditarFlutuante" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxCallback ID="callFlutuante" ClientInstanceName="callFlutuante" runat="server" OnCallback="callFlutuante_Callback">
                                                        <ClientSideEvents CallbackComplete="function(s, e) { 
        validatedOnServer = true;
        if (e.result == 'valid') {
            txtEditarFlutuante.SetIsValid(true);
            try{btnEditarFlutuante.SetText(btnSalvarTexto);btnDeleteFlutuante.SetEnabled(true);}catch{}
        }
        else {
            txtEditarFlutuante.SetIsValid(false);
            if(e.result.indexOf('[DELETE]')&gt;=0)
                {
                    txtEditarFlutuante.SetErrorText(e.result.replace('[DELETE]',''));
                    try{btnEditarFlutuante.SetText(btnValidarTexto);btnDeleteFlutuante.SetEnabled(false);}catch{}
                }
                else
                {
                    txtEditarFlutuante.SetErrorText(e.result);
                }
            
        }
        OnUpdateControlValue(s, e,btnEditarFlutuante,txtEditarFlutuante); 
    }" />
                                                    </dx:ASPxCallback>
                                                    <dx:ASPxTextBox ID="txtEditarFlutuante" ClientInstanceName="txtEditarFlutuante" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                        <ClientSideEvents Init="function(s,e) { btnEditarFlutuante.SetText(btnSalvarTexto); if(s.GetText()=='__________') s.SetText(''); } "
                                                            KeyPress="function(s, e) { OnUpdateControlValue(s, e,btnEditarFlutuante,txtEditarFlutuante); }" TextChanged="function(s, e) { OnUpdateControlValue(s, e,btnEditarFlutuante,txtEditarFlutuante); }"
                                                            Validation="function(s, e,) {
        if(e.isValid && !validatedOnServer) {
            var value = parseFloat(e.value);
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            callFlutuante.PerformCallback('');
        }
    }"
                                                            KeyDown="function(s, e) { validatedOnServer = false; }" />
                                                        <MaskSettings Mask="<-9999999..9999999g>.<00..999999>" PromptChar="0" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic">
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxTextBox>
                                                    <%--<asp:TextBox ID="txtEditarFlutuante" CssClass="text-boxes valor" runat="server"></asp:TextBox>--%>
                                                    <div class="input-group-append">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarFlutuante" ClientInstanceName="btnEditarFlutuante" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false" OnClick="btnEditarFlutuante_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarFlutuante" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarFlutuante_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="Button6" ClientInstanceName="btnDeleteFlutuante" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="Button6" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewFormula" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblEditarFormula" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <dx:ASPxCallback ID="callFormula" ClientInstanceName="callFormula" runat="server" OnCallback="callFormula_Callback">
                                                    <ClientSideEvents CallbackComplete="function(s, e) { 
                                                        if (e.result == 'valid') {
                                                            dropEditarFormula.SetIsValid(true); 
                                                            try{btnEditarFormula.SetText(btnSalvarTexto);btnDeleteFormula.SetEnabled(true); }catch{}
                                                        }
                                                        else {
                                                                dropEditarFormula.SetIsValid(false);
                                                                if(e.result.indexOf('[DELETE]')&gt;=0)
                                                                {
                                                                    dropEditarFormula.SetErrorText(e.result.replace('[DELETE]',''));
                                                                    try{btnEditarFormula.SetText(btnValidarTexto);btnDeleteFormula.SetEnabled(false); }catch{}
                                                                }
                                                                else
                                                                {
                                                                    dropEditarFormula.SetErrorText(e.result);
                                                                }
                                                            }
                                                            OnUpdateControlValue(s, e,btnEditarFormula,dropEditarFormula);
                                                           
                                                            }" />
                                                </dx:ASPxCallback>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxComboBox ID="dropEditarFormula" ClientInstanceName="dropEditarFormula" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                        ValueType="System.Int32">
                                                        <ClientSideEvents Init="function(s,e) { btnEditarFormula.SetText(btnValidarTexto); }"
                                                            Validation="function(s, e,) {
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            OnUpdateControlValue(s, e,btnEditarFormula,dropEditarFormula);
            callFormula.PerformCallback('');
        
    }" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic">
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                    </dx:ASPxComboBox>
                                                    <%--<asp:DropDownList ID="dropEditarFormula" CssClass="text-boxes" runat="server"></asp:DropDownList>--%>
                                                    <div class="input-group-append">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarFormula" ClientInstanceName="btnEditarFormula" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false" OnClick="btnEditarFormula_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarFormula" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarFormula_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="Button7" ClientInstanceName="btnDeleteFormula" ClientEnabled="false" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="Button7" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewIndice" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblEditarIndice" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxCallback ID="callIndice" ClientInstanceName="callIndice" runat="server" OnCallback="callIndice_Callback">
                                                        <ClientSideEvents CallbackComplete="function(s, e) { 
        validatedOnServer = true;
        if (e.result == 'valid') {
            txtEditarIndice.SetIsValid(true); 
            try{btnEditarIndice.SetText(btnSalvarTexto);
            btnDeleteIndice.SetEnabled(true); 
            }catch{}
        }
        else {
            txtEditarIndice.SetIsValid(false); 
            if(e.result.indexOf('[DELETE]')&gt;=0)
                {
                    txtEditarIndice.SetErrorText(e.result.replace('[DELETE]',''));
                    try{
                                                           btnEditarIndice.SetText(btnValidarTexto); btnDeleteIndice.SetEnabled(false); 
                                                            }catch{}
                }
                else
                {
                    txtEditarIndice.SetErrorText(e.result);
                }
            
        }
        OnUpdateControlValue(s, e,btnEditarIndice,txtEditarIndice); 
    }" />
                                                    </dx:ASPxCallback>
                                                    <dx:ASPxTextBox ID="txtEditarIndice" ClientInstanceName="txtEditarIndice" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                        <ClientSideEvents Init="function(s,e) { btnEditarIndice.SetText(btnValidarTexto); if(s.GetText()=='__________') s.SetText(''); } "
                                                            KeyPress="function(s, e) { OnUpdateControlValue(s, e,btnEditarIndice,txtEditarIndice); }" TextChanged="function(s, e) { OnUpdateControlValue(s, e,btnEditarIndice,txtEditarIndice); }"
                                                            Validation="function(s, e,) {
        if(e.isValid && !validatedOnServer) {
            var value = parseFloat(e.value);
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            callIndice.PerformCallback('');
        }
    }"
                                                            KeyDown="function(s, e) { validatedOnServer = false; }" />
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic" ValidationGroup="validacaoInteiro">
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxTextBox>
                                                    <%--<asp:TextBox ID="txtEditarIndice" CssClass="text-boxes" runat="server"></asp:TextBox>--%>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarIndice" ClientInstanceName="btnEditarIndice" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false" OnClick="btnEditarIndice_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarIndice" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarIndice_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="Button8" ClientInstanceName="btnDeleteIndice" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="Button8" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewSql" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblEditarSql" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <dx:ASPxCallback ID="callSQL" ClientInstanceName="callSQL" runat="server" OnCallback="callSQL_Callback">
                                                    <ClientSideEvents CallbackComplete="function(s, e) { 
        if (e.result == 'valid') {
            dropEditarSql2.SetIsValid(true);
            try{btnEditarSql.SetText(btnSalvarTexto);btnDeleteSql.SetEnabled(true);}catch{}
        }
        else {
            dropEditarSql2.SetIsValid(false); 
            if(e.result.indexOf('[DELETE]')&gt;=0)
            {
                dropEditarSql2.SetErrorText(e.result.replace('[DELETE]',''));
                try{btnEditarSql.SetText(btnValidarTexto);btnDeleteSql.SetEnabled(false);}catch{}
            }
            else
            {
                dropEditarSql2.SetErrorText(e.result);
            }
            
        }
        OnUpdateControlValue(s, e,btnEditarSql,dropEditarSql2); 
    }" />
                                                </dx:ASPxCallback>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxComboBox ID="dropEditarSql2" ClientInstanceName="dropEditarSql2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" Theme="Material" Width="100%">
                                                        <ClientSideEvents Init="function(s,e) { btnEditarSql.SetText(btnValidarTexto); }"
                                                            Validation="function(s, e,) {
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            OnUpdateControlValue(s, e,btnEditarSql,dropEditarSql2);
            callSQL.PerformCallback('');
        
    }" />
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic">
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarSql" ClientInstanceName="btnEditarSql" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false" OnClick="btnEditarSql_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarSql" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarSql_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="Button9" ClientInstanceName="btnDeleteSql" ClientEnabled="false" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="Button9" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewDeAte" runat="server">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <dx:ASPxGridView ID="gridRptDeAte" Theme="Material" runat="server" KeyFieldName="ID" Width="420px"  OnRowValidating="gridRptDeAte_RowValidating" OnInitNewRow="gridRptDeAte_InitNewRow" OnBatchUpdate="gridRptDeAte_BatchUpdate" AutoGenerateColumns="False">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsCommandButton>
                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="20px">
                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="20px">
                                                        </Image>
                                                    </NewButton>
                                                    <DeleteButton Image-ToolTip="Excluir" Image-Url="img/icons8-delete-bin-32.png" Image-Width="20px">
                                                        <Image ToolTip="Excluir" Url="img/icons8-delete-bin-32.png" Width="20px">
                                                        </Image>
                                                    </DeleteButton>
                                                    <RecoverButton Image-ToolTip="Cancelar" Image-Url="img/icons8-recyle-32.png" Image-Width="20px">
                                                        <Image ToolTip="Cancelar" Url="img/icons8-recyle-32.png" Width="20px">
                                                        </Image>
                                                    </RecoverButton>
                                                </SettingsCommandButton>
                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Columns>
                                                    <dx:GridViewCommandColumn MaxWidth="30" Width="30" ButtonRenderMode="Image" ButtonType="Image" ShowDeleteButton="true" ShowNewButtonInHeader="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                    <dx:GridViewDataDateColumn FieldName="De" MaxWidth="100" Width="100" Caption="<%$ Resources:Aquisicao, aquisição_grid_de %>" VisibleIndex="1">
                                                        <PropertiesDateEdit DisplayFormatInEditMode="true" UseMaskBehavior="True" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                            <ValidationSettings Display="Dynamic">
                                                            </ValidationSettings>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataDateColumn FieldName="Ate" MaxWidth="100" Width="100" Caption="<%$ Resources:Aquisicao, aquisição_grid_ate %>" VisibleIndex="2">
                                                        <PropertiesDateEdit DisplayFormatInEditMode="true" UseMaskBehavior="True" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                            <ValidationSettings Display="Dynamic">
                                                            </ValidationSettings>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="Valor" MaxWidth="170" Width="140" Caption="<%$ Resources:Aquisicao, aquisição_grid_valor %>" VisibleIndex="3" ShowInCustomizationForm="true">
                                                        <PropertiesTextEdit DisplayFormatString="N8" DisplayFormatInEditMode="true">
                                                            <ValidationSettings Display="Dynamic">
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                </Columns>
                                                <Settings VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard"/>
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
                                                    <EditForm Paddings-Padding="0px" Font-Names="Arial" Font-Size="8pt"></EditForm>
                                                    <EditFormCell Paddings-Padding="0px" Font-Names="Arial" Font-Size="8pt"></EditFormCell>
                                                    <Table></Table>
                                                    <Cell Paddings-Padding="5px" Font-Names="Arial" Font-Size="8pt"></Cell>
                                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                </Styles>
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>
                                    <asp:Panel ID="Panel2" runat="server" Visible="false">
                                        <table style="width: 100%">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblEditarDeAte" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="input-group mb-3">
                                                        <asp:Label ID="Label26" runat="server" CssClass="labels text-left" Text="Itens: "></asp:Label>
                                                        <asp:TextBox ID="txtEditarDeAte" Width="30%" CssClass="text-boxes" TextMode="Number" runat="server"></asp:TextBox>
                                                        <div class="input-group-append">
                                                            <asp:Button ID="btnqtdEditarDeAte" CssClass="btn btn-secondary" runat="server" Text="+" OnClick="btnqtdEditarDeAte_Click" />
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                        <table style="width: 100%">
                                            <tr>
                                                <td>
                                                    <table class="table table-hover">
                                                        <thead class="thead-dark">
                                                            <tr>
                                                                <th class="text-center" style="font-family: Arial; font-size: 10px; width: 15%">De</th>
                                                                <th class="text-center" style="font-family: Arial; font-size: 10px; width: 15%">Ate</th>
                                                                <th class="text-center" style="font-family: Arial; font-size: 10px; width: 15%">Valor</th>
                                                            </tr>
                                                        </thead>
                                                        <asp:Repeater ID="rptDeAteEdit" runat="server">
                                                            <ItemTemplate>
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="width: 15%">
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarDtEdit1" Enabled="true" TargetControlID="txtDt1Edit" PopupButtonID="txtDt1Edit" runat="server" />
                                                                            <asp:TextBox Font-Names="Arial" Font-Size="10px" Width="100px" ID="txtDt1Edit" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "De","{0:d}")%>'></asp:TextBox></td>
                                                                        <td style="width: 15%">
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarDtEdit2" Enabled="true" TargetControlID="txtDt2Edit" PopupButtonID="txtDt2Edit" runat="server" />
                                                                            <asp:TextBox Font-Names="Arial" Font-Size="10px" Width="100px" ID="txtDt2Edit" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Ate","{0:d}")%>'></asp:TextBox></td>
                                                                        <td style="width: 15%">
                                                                            <asp:TextBox Font-Names="Arial" Font-Size="10px" Width="100px" ID="txtVlEdit" CssClass="border-1 valor form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Valor")%>'></asp:TextBox></td>
                                                                    </tr>
                                                                </tbody>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnEditarDeAte" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" OnClick="btnEditarDeAte_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </asp:View>
                                <asp:View ID="viewTexto" runat="server">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblEditarTexto" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-3">
                                                    <dx:ASPxCallback ID="callTexto" ClientInstanceName="callTexto" runat="server" OnCallback="callTexto_Callback">
                                                        <ClientSideEvents CallbackComplete="function(s, e) { 
        validatedOnServer = true;
        if (e.result == 'valid') {
            txtEditarTexto.SetIsValid(true); 
            try{btnEditarTexto.SetText(btnSalvarTexto);btnDeleteTexto.SetEnabled(true);}catch{}
        }
        else {
            txtEditarTexto.SetIsValid(false); 
            if(e.result.indexOf('[DELETE]')&gt;=0)
                {
                    txtEditarTexto.SetErrorText(e.result.replace('[DELETE]',''));
                    try{btnEditarTexto.SetText(btnValidarTexto);btnDeleteTexto.SetEnabled(false);}catch{}
                }
                else
                {
                    txtEditarTexto.SetErrorText(e.result);
                }
            
        }
        OnUpdateControlValue(s, e,btnEditarTexto,txtEditarTexto); 
    }" />
                                                    </dx:ASPxCallback>
                                                    <dx:ASPxTextBox ID="txtEditarTexto" ClientInstanceName="txtEditarTexto" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                        <ClientSideEvents Init="function(s,e) { btnEditarTexto.SetText(btnValidarTexto); if(s.GetText()=='__________') s.SetText(''); } "
                                                            KeyPress="function(s, e) { OnUpdateControlValue(s, e,btnEditarTexto,txtEditarTexto); }" TextChanged="function(s, e) { OnUpdateControlValue(s, e,btnEditarTexto,txtEditarTexto); }"
                                                            Validation="function(s, e,) {
        if(e.isValid && !validatedOnServer) {
            var value = parseFloat(e.value);
            e.isValid = false;
            e.errorText = 'Server-side validation...';
            callTexto.PerformCallback('');
        }
    }"
                                                            KeyDown="function(s, e) { validatedOnServer = false; }" />
                                                        <ValidationSettings ValidateOnLeave="true" ErrorTextPosition="Bottom" EnableCustomValidation="true" ErrorFrameStyle-ForeColor="Red" ErrorFrameStyle-Wrap="True"
                                                            ErrorDisplayMode="ImageWithText" Display="Dynamic" ValidationGroup="validacaoInteiro">
                                                            <ErrorFrameStyle CssClass="text-left" ForeColor="Red" Wrap="True"></ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxTextBox>
                                                    <%--<asp:TextBox ID="txtEditarTexto" CssClass="text-boxes" runat="server"></asp:TextBox>--%>
                                                    <div class="input-group-append">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <dx:ASPxButton ID="btnEditarTexto" ClientInstanceName="btnEditarTexto" ClientEnabled="false" runat="server" CssClass="btn-using ok" CausesValidation="false" OnClick="btnEditarTexto_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="btnEditarTexto" CssClass="btn-using ok" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarTexto_Click" />--%>
                                            </td>
                                            <td>
                                                <dx:ASPxButton ID="Button3" ClientInstanceName="btnDeleteTexto" runat="server" CssClass="ml-3 btn-using cancelar" CausesValidation="false" OnCommand="DelBasesEdit" Text="<%$ Resources:GlobalResource, btn_excluir %>">
                                                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                </dx:ASPxButton>
                                                <%--<asp:Button ID="Button3" CssClass="ml-3 btn-using cancelar" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />--%>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:View>
                                <asp:View ID="viewDeAteData" runat="server">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <dx:ASPxGridView ID="gridRptDeAteData" Theme="Material" runat="server" KeyFieldName="ID" Width="510px" OnInitNewRow="gridRptDeAteData_InitNewRow" OnRowValidating="gridRptDeAteData_RowValidating" OnBatchUpdate="gridRptDeAteData_BatchUpdate" AutoGenerateColumns="False">
                                                <SettingsPopup>
                                                    <HeaderFilter MinHeight="140px">
                                                    </HeaderFilter>
                                                </SettingsPopup>
                                                <SettingsCommandButton>
                                                    <NewButton Image-ToolTip="New" Image-Url="img/icons8-plus-20.png" Image-Width="20px">
                                                        <Image ToolTip="New" Url="img/icons8-plus-20.png" Width="20px">
                                                        </Image>
                                                    </NewButton>
                                                    <DeleteButton Image-ToolTip="Excluir" Image-Url="img/icons8-delete-bin-32.png" Image-Width="20px">
                                                        <Image ToolTip="Excluir" Url="img/icons8-delete-bin-32.png" Width="20px">
                                                        </Image>
                                                    </DeleteButton>
                                                    <RecoverButton Image-ToolTip="Cancelar" Image-Url="img/icons8-recyle-32.png" Image-Width="20px">
                                                        <Image ToolTip="Cancelar" Url="img/icons8-recyle-32.png" Width="20px">
                                                        </Image>
                                                    </RecoverButton>
                                                </SettingsCommandButton>
                                                <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                <Columns>
                                                    <dx:GridViewCommandColumn MaxWidth="30" Width="30" ButtonRenderMode="Image" ButtonType="Image" ShowDeleteButton="true" ShowNewButtonInHeader="true" VisibleIndex="0"></dx:GridViewCommandColumn>
                                                    <dx:GridViewDataDateColumn FieldName="De" MaxWidth="100" Width="100" Caption="<%$ Resources:Aquisicao, aquisição_grid_de %>" VisibleIndex="1">
                                                        <PropertiesDateEdit DisplayFormatInEditMode="true" UseMaskBehavior="True" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                            <ValidationSettings Display="Dynamic">
                                                            </ValidationSettings>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataDateColumn FieldName="Ate" MaxWidth="100" Width="100" Caption="<%$ Resources:Aquisicao, aquisição_grid_ate %>" VisibleIndex="2">
                                                        <PropertiesDateEdit DisplayFormatInEditMode="true" UseMaskBehavior="True" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                            <ValidationSettings Display="Dynamic">
                                                            </ValidationSettings>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                    <dx:GridViewDataTextColumn FieldName="Valor" MaxWidth="170" Width="170" Caption="<%$ Resources:Aquisicao, aquisição_grid_valor %>" VisibleIndex="3" ShowInCustomizationForm="true">
                                                        <PropertiesTextEdit DisplayFormatString="N8" DisplayFormatInEditMode="true">
                                                            <ValidationSettings Display="Dynamic">
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataDateColumn FieldName="Data" MaxWidth="100" Width="100" Caption="<%$ Resources:Aquisicao, aquisição_grid_data %>" VisibleIndex="4">
                                                        <PropertiesDateEdit DisplayFormatInEditMode="true" UseMaskBehavior="True" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                            <ValidationSettings Display="Dynamic">
                                                            </ValidationSettings>
                                                        </PropertiesDateEdit>
                                                    </dx:GridViewDataDateColumn>
                                                </Columns>
                                                <Settings VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Standard"/>
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
                                        </div>
                                    </div>
                                </asp:View>
                            </asp:MultiView>
                            <asp:Panel ID="pnlGridDataEdit" runat="server">
                            </asp:Panel>
                            <asp:Panel ID="pnlGridMoedaEdit" runat="server">
                            </asp:Panel>
                            <asp:Panel ID="pnlGridInteiroEdit" runat="server">
                            </asp:Panel>
                            <asp:Panel ID="pnlEditarFlutuante" runat="server">
                            </asp:Panel>
                            <asp:Panel ID="pnlGridFormulaEdit" runat="server">
                            </asp:Panel>
                            <asp:Panel ID="pnlGridIndiceEdit" runat="server">
                            </asp:Panel>
                            <asp:Panel ID="pnlGridSQLEdit" runat="server">
                            </asp:Panel>
                            <asp:Panel ID="pnlGridDeAteEdit" runat="server">
                            </asp:Panel>
                        </asp:Panel>

                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="popupAditamento" ClientInstanceName="popupAditamento" ClientIDMode="Static" CloseAction="CloseButton" CloseOnEscape="false" Modal="true"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="<%$ Resources:Aquisicao, aquisicao_aditamento_titulo %>" AllowDragging="true" Height="600px" Width="500px"
            PopupAnimationType="None" AutoUpdatePosition="true" runat="server">
            <ContentStyle Paddings-Padding="0px"></ContentStyle>
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div class="container-fluid">
                        <div class="row p-0">
                            <div class="col-12 p-0">
                                <div class="card">
                                    <div class="card-header">
                                        <ul class="nav nav-tabs card-header-tabs" id="bologna-list" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" href="#eventos" role="tab" aria-controls="eventos" aria-selected="true"><%= Resources.Aquisicao.aquisicao_aditamento_aba1%></a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" href="#desmembrar" role="tab" aria-controls="desmembrar" aria-selected="false"><%= Resources.Aquisicao.aquisicao_aditamento_aba2%></a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card-body pt-0 pb-3 pr-3 pl-3">
                                        <div class="tab-content mt-3">
                                            <div class="tab-pane active" id="eventos" role="tabpanel">
                                                <div class="card" style="margin: 0 auto">
                                                    <div class="card-header border-0 p-0 text-left">
                                                        <h6>
                                                            <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Aquisicao, aquisicao_aditamento_lbl1 %>" CssClass="labels text-left"></asp:Label></h6>
                                                    </div>
                                                    <div class="card-body p-0 text-left">
                                                        <div class="row p-0">
                                                            <div class="col-5">
                                                                <dx:ASPxDateEdit ID="txtDtAdit" ForeColor="dimgray" UseMaskBehavior="true" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above">
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
                                                            <div class="col-7">
                                                                <dx:ASPxComboBox ID="dropEventoAditamento" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%"
                                                                    TextField="CHTPDSEV" ValueField="CHTPIDEV" ValueType="System.Int32" DataSourceID="sqlAditamento2">
                                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                    </ButtonStyle>
                                                                    <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                </dx:ASPxComboBox>
                                                                <asp:SqlDataSource runat="server" ID="sqlAditamento2" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                    SelectCommand="select CHTPIDEV,CHTPDSEV from CMTPEVEN E, CHCOMPOT C
                                                                    where E.CMIDCODI=C.cmidcodi
                                                                    AND C.chidcodi=?
                                                                    and e.PAIDPAIS = ?
                                                                    union 
                                                                    select CHTPIDEV,CHTPDSEV from CMTPEVEN E, CHCOMPOT C
                                                                    where E.CMIDCODI=C.cmidcodi
                                                                    AND C.chidcodi=?
                                                                    and e.PAIDPAIS = 1
                                                                    and e.CMIDCODI not in (select distinct D.CMIDCODI 
						                                                                     from CMTPEVEN D 
						                                                                     where D.paidpais=?
						                                                                       AND D.CMIDCODI = E.CMIDCODI
						                                                                       AND D.PAIDPAIS &lt;&gt; E.PAIDPAIS
						                                                                       AND D.CHTPIDEV = E.CHTPIDEV)">
                                                                    <SelectParameters>
                                                                        <asp:ControlParameter ControlID="hfCHIDCODI" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                        <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                        <asp:ControlParameter ControlID="hfCHIDCODI" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                        <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>
                                                            </div>
                                                        </div>


                                                    </div>
                                                </div>
                                                <div class="card" style="margin: 0 auto">
                                                    <div class="card-header p-0 text-left">
                                                        <h6>
                                                            <asp:Label ID="Label63" runat="server" Text="<%$ Resources:Aquisicao, aquisicao_aditamento_lbl2 %>" CssClass="labels text-left"></asp:Label></h6>
                                                    </div>
                                                    <div class="card-body p-0 text-left">

                                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ValidationGroup="justifica" ControlToValidate="txtJustifica" CssClass="labels text-left" ForeColor="Red" ValidationExpression="^[\s\S]{20,255}$" runat="server" ErrorMessage="<%$ Resources:Aquisicao, aquisicao_aditamento_lbl4 %>"></asp:RegularExpressionValidator>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator33" ValidationGroup="justifica" ControlToValidate="txtJustifica" CssClass="labels text-left" ForeColor="Red" runat="server" ErrorMessage="Texto justificativo obrigatório."></asp:RequiredFieldValidator>
                                                        <asp:RequiredFieldValidator ID="reqEventoAditamento" ValidationGroup="justifica" ControlToValidate="dropEventoAditamento" CssClass="labels text-left" ForeColor="Red" runat="server" ErrorMessage="Evento aditamento obrigatório."></asp:RequiredFieldValidator>
                                                        <dx:ASPxMemo ID="txtJustifica" ClientInstanceName="txtJustifica" runat="server" CssClass="text-boxes" MaxLength="255" Rows="15" Height="100px" Width="100%">
                                                            <ClientSideEvents KeyUp="function(s, e) {  
    var editText = s.GetText();  
    ASPxLabel2.SetText('Caracteres: ' + (255 - editText.length));  
}" />
                                                        </dx:ASPxMemo>
                                                        <dx:ASPxLabel ClientInstanceName="ASPxLabel2" ID="ASPxLabel2" runat="server" Text="<%$ Resources:Aquisicao, aquisicao_aditamento_lbl3 %>"></dx:ASPxLabel>
                                                        <div class="input-group">
                                                            <asp:Button ID="btnAdt" runat="server" ValidationGroup="justifica" CssClass="btn-using ok" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnAditamento_Click" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="desmembrar" role="tabpanel" aria-labelledby="desmembrar-tab">
                                                <div class="card" style="margin: 0 auto">
                                                    <div class="card-header border-0 p-0 text-left">
                                                        <h6>
                                                            <asp:Label ID="Label67" runat="server" Text="<%$ Resources:Aquisicao, aquisicao_aditamento_lbl5 %>" CssClass="labels text-left"></asp:Label></h6>
                                                    </div>
                                                    <div class="card-body p-0 text-left">
                                                        <div class="row p-0">
                                                            <div class="col-12">
                                                                <dx:ASPxDateEdit ID="dateDesmembra" UseMaskBehavior="true" ForeColor="dimgray" CssClass="drop-down" Theme="Material" Width="100%" runat="server" PickerType="Days" PopupVerticalAlign="Above">
                                                                    <ClientSideEvents
                                                                        DateChanged="function(s, e) {
	                                                                    var date = s.GetDate();
                                                                        var date2 = new Date(100,0,1);
	                                                                    var today = new Date();
                                                                        document.getElementById(&#39;hfDateDesmembra&#39;).text=null;
	                                                                    if(date&gt;=today)
                                                                        {
	                                                                        document.getElementById(&#39;hfDateDesmembra&#39;).text=&#39;OK&#39;;
                                                                        }
                                                                        try{
                                                                        var checking = date.setHours(0,0,0,0)!=date2.setHours(0,0,0,0);
                                                                        checkSalvarDesmembra.SetEnabled(checking);
                                                                        gridDesmembramentos1.PerformCallback(date.toISOString());
                                                                        }
                                                                        catch{
                                                                        checkSalvarDesmembra.SetEnabled(False);
                                                                        gridDesmembramentos1.PerformCallback();
                                                                        }
                                                                        }"></ClientSideEvents>

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
                                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" EnableCustomValidation="true" ValidationGroup="desmembrar">
                                                                        <RequiredField IsRequired="true" ErrorText="*" />
                                                                    </ValidationSettings>
                                                                </dx:ASPxDateEdit>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator26" ValidationGroup="desmembrar" ControlToValidate="hfDateDesmembra" runat="server" ErrorMessage="Data Inválida" ForeColor="Red"></asp:RequiredFieldValidator>
                                                            </div>
                                                        </div>
                                                        <div class="row p-0">
                                                            <div class="col-12">
                                                                <dx:ASPxGridView ID="gridDesmembramentos1" ClientInstanceName="gridDesmembramentos1" Theme="Material" runat="server" AutoGenerateColumns="False"
                                                                    Width="100%" DataSourceID="sqlDesmembramentos1" KeyFieldName="opidcont" OnBatchUpdate="gridDesmembramentos1_BatchUpdate" OnCustomCallback="gridDesmembramentos1_CustomCallback">
                                                                    <ClientSideEvents EndCallback="OnEndCallback" BatchEditChangesCanceling="OnChangesCanceling" BatchEditRowDeleting="OnBatchEditRowDeleting" BatchEditEndEditing="OnBatchEditEndEditing"
                                                                        BatchEditRowInserting="function(s,e){
                                                                        var sum = parseFloat(labelSum.GetText());
                                                                        if(sum==1000)
                                                                            e.cancel = true;
                                                                        }"
                                                                        BatchEditStartEditing="function(s,e){
                                                                        var teste = s.batchEditApi.IsNewRow(e.visibleIndex);
                                                                            if ((e.focusedColumn.fieldName == 'percentual') && (teste==false))
                                                                                e.cancel = true;
                                                                        
                                                                        }" />
                                                                    <SettingsPopup>
                                                                        <HeaderFilter MinHeight="140px">
                                                                        </HeaderFilter>
                                                                    </SettingsPopup>
                                                                    <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                                                    <Settings ShowFooter="true" VerticalScrollableHeight="200" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" />
                                                                    <SettingsPager Mode="ShowAllRecords">
                                                                    </SettingsPager>
                                                                    <SettingsBehavior AllowFocusedRow="true" />
                                                                    <SettingsEditing Mode="Batch" BatchEditSettings-ShowConfirmOnLosingChanges="false" BatchEditSettings-HighlightDeletedRows="false"></SettingsEditing>
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
                                                                        <UpdateButton RenderMode="Image">
                                                                            <Image ToolTip="Save changes and close Edit Form" Url="img/ok.png" Width="50px" />
                                                                        </UpdateButton>
                                                                        <CancelButton RenderMode="Image">
                                                                            <Image ToolTip="Close Edit Form without saving changes" Url="img/cancel.png" Width="50px" />
                                                                        </CancelButton>
                                                                    </SettingsCommandButton>
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowNewButtonInHeader="True" VisibleIndex="0" Width="50px" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="percentual" Caption="%" VisibleIndex="4" Width="70px">
                                                                            <PropertiesTextEdit DisplayFormatString="N0" DisplayFormatInEditMode="true">
                                                                                <MaskSettings Mask="<0..100>" IncludeLiterals="DecimalSymbol" />
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None"></ValidationSettings>
                                                                            </PropertiesTextEdit>
                                                                            <FooterTemplate>
                                                                                Totalizando 
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" ClientInstanceName="labelSum" Text='<%# GetTotalSummaryValue() %>'>
                    </dx:ASPxLabel>
                                                                                %
                                                                            </FooterTemplate>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="OPTPTPDS" Caption="Tipo" VisibleIndex="5" Width="90px">
                                                                            <EditFormSettings Visible="False" />
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataComboBoxColumn FieldName="FOIDFORN2" Caption="Benefici&#225;rio" Width="125px" VisibleIndex="3">
                                                                            <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlFornecedores" TextField="FONMAB20" ValueField="FOIDFORN">
                                                                            </PropertiesComboBox>
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                        <dx:GridViewDataComboBoxColumn FieldName="FOIDFORN" Caption="Favorecido" VisibleIndex="2" Width="125px">
                                                                            <PropertiesComboBox ValueType="System.Int32" DataSourceID="sqlFornecedores" TextField="FONMAB20" ValueField="FOIDFORN">
                                                                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="None"></ValidationSettings>
                                                                            </PropertiesComboBox>
                                                                        </dx:GridViewDataComboBoxColumn>
                                                                    </Columns>
                                                                    <TotalSummary>
                                                                        <dx:ASPxSummaryItem DisplayFormat="N0" SummaryType="Sum" FieldName="percentual" Tag="percentual_Sum" />
                                                                    </TotalSummary>
                                                                    <Styles>
                                                                        <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                                                        <StatusBar CssClass="batchBtn" Paddings-Padding="3px" HorizontalAlign="Left"></StatusBar>
                                                                        <Header Font-Names="Arial" Font-Size="9pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                                                        </Header>
                                                                        <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                                        </Row>
                                                                        <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                                                        <BatchEditCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                                                            <Paddings Padding="0px" />
                                                                        </BatchEditCell>
                                                                        <FocusedCell Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" Paddings-Padding="0px"></FocusedCell>
                                                                        <FocusedRow BackColor="Transparent"></FocusedRow>
                                                                        <EditForm Paddings-Padding="0px"></EditForm>
                                                                        <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                                                        <Table></Table>
                                                                        <Cell Paddings-Padding="5px"></Cell>
                                                                        <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                                                    </Styles>
                                                                    <Templates>
                                                                        <StatusBar>
                                                                            <div class="row p-0">
                                                                                <dx:ASPxCheckBox ID="checkSalvarDesmembra" ClientEnabled="false" ClientInstanceName="checkSalvarDesmembra" runat="server"
                                                                                    Text="Necessário selecionar a data para confirmar operação.">
                                                                                    <CheckedImage Url="icons/checked.png" Height="30px" Width="30px"></CheckedImage>
                                                                                    <UncheckedImage Url="icons/unchecked.png" Height="30px" Width="30px"></UncheckedImage>
                                                                                    <ClientSideEvents CheckedChanged="function(s,e) { btnSaveDesmembra.SetEnabled(s.GetChecked()); }" />
                                                                                </dx:ASPxCheckBox>
                                                                            </div>
                                                                            <div class="row p-0 mt-2">
                                                                                <div style="text-align: left">
                                                                                    <dx:ASPxButton ID="btnSave" runat="server" ClientInstanceName="btnSaveDesmembra" ClientEnabled="false" ValidationGroup="desmembrar" AutoPostBack="false" CssClass="btn-using ok" Text="<%$Resources:GlobalResource, btn_grid_batch_save %>" ClientSideEvents-Click="function(s, e){ gridDesmembramentos1.UpdateEdit(); }">
                                                                                        <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                                    </dx:ASPxButton>
                                                                                    <dx:ASPxButton ID="btnCancel" runat="server" AutoPostBack="false" CssClass="btn-using cancelar" Text="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" ClientSideEvents-Click="function(s, e){ gridDesmembramentos1.CancelEdit(); }">
                                                                                        <DisabledStyle CssClass="btn-using"></DisabledStyle>
                                                                                    </dx:ASPxButton>
                                                                                </div>
                                                                            </div>
                                                                        </StatusBar>
                                                                    </Templates>
                                                                </dx:ASPxGridView>
                                                                <asp:SqlDataSource runat="server" ID="sqlDesmembramentos1" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select opidcont,FOIDFORN,FOIDFORN2,(select (o.OPVLCONT/o2.OPVLCONT)*100 from OPCONTRA o2 where o2.OPIDCONT=?) percentual,t.OPTPTPDS
from opcontra o, OPTPTIPO t where o.OPTPTPID=t.OPTPTPID and t.cmtpidcm=o.cmtpidcm and OPIDAACC=?  and t.PAIDPAIS=1">
                                                                    <SelectParameters>
                                                                        <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                        <asp:ControlParameter ControlID="hfOPIDCONT" PropertyName="Value" Name="?"></asp:ControlParameter>
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>
                                                                <asp:SqlDataSource runat="server" ID="sqlFornecedores" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                                                    SelectCommand="SELECT F.FONMAB20, F.FOIDFORN FROM FOFORNEC F 
WHERE FOTPIDTP=8  order by fonmforn"></asp:SqlDataSource>
                                                                <asp:TextBox ID="hfDateDesmembra" ClientIDMode="Static" ValidationGroup="desmembrar" CssClass="d-none" runat="server"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ID="popupFileManager" ClientInstanceName="popupFileManager" runat="server" Theme="Material"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Documentos e Arquivos" Modal="true" Width="600px" Height="350px">
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div class="row">
                        <div class="col-8">
                            <h3>
                                <asp:Label ID="lblFileManager" Visible="false" runat="server" Text="<%$ Resources:Aquisicao, aquisição_lbl_FileManager %>"></asp:Label></h3>
                        </div>
                        <div class="col-2">
                            <asp:Button ID="btnCriarDir" runat="server" CssClass="btn-using" Visible="false" Width="150px" Text="Criar Diretório" OnClick="CriarDirContratos" OnLoad="btnCriarDir_Load" /></div>
                    </div>


                    <dx:ASPxFileManager ID="fileManager" Visible="false" ClientInstanceName="fileManager" Theme="Material" runat="server" Width="800px">
                        <Settings AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.doc,.docx,.pdf,.eml" />
                        <SettingsToolbar>
                            <Items>
                                <dx:FileManagerToolbarCreateButton ToolTip="Criar"></dx:FileManagerToolbarCreateButton>
                                <dx:FileManagerToolbarRenameButton ToolTip="Renomear"></dx:FileManagerToolbarRenameButton>
                                <dx:FileManagerToolbarMoveButton ToolTip="Mover"></dx:FileManagerToolbarMoveButton>
                                <dx:FileManagerToolbarCopyButton ToolTip="Copiar"></dx:FileManagerToolbarCopyButton>
                                <dx:FileManagerToolbarDeleteButton ToolTip="Excluir"></dx:FileManagerToolbarDeleteButton>
                                <dx:FileManagerToolbarRefreshButton ToolTip="Atualizar"></dx:FileManagerToolbarRefreshButton>
                                <dx:FileManagerToolbarDownloadButton ToolTip="Download"></dx:FileManagerToolbarDownloadButton>
                            </Items>
                        </SettingsToolbar>
                        <SettingsPermissions>
                            <AccessRules>
                                <dx:FileManagerFolderAccessRule Path="System" Edit="Deny" />
                                <dx:FileManagerFileAccessRule Path="System\*" Download="Deny" />
                            </AccessRules>
                        </SettingsPermissions>
                        <SettingsFiltering FilteredFileListView="FilterView" FilterBoxMode="Subfolders" />
                        <SettingsFileList ThumbnailsViewSettings-ThumbnailHeight="30px" ThumbnailsViewSettings-ThumbnailWidth="30px" ShowFolders="true" ShowParentFolder="true" />
                        <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                        <SettingsUpload UseAdvancedUploadMode="true">
                            <AdvancedModeSettings EnableMultiSelect="true" />
                        </SettingsUpload>
                        <SettingsAdaptivity Enabled="true" />
                        <SettingsContextMenu Enabled="true">
                            <Items>
                                <dx:FileManagerToolbarMoveButton />
                                <dx:FileManagerToolbarCopyButton />
                                <dx:FileManagerToolbarRenameButton BeginGroup="true" />
                                <dx:FileManagerToolbarDeleteButton />
                                <dx:FileManagerToolbarRefreshButton BeginGroup="false" />
                            </Items>
                        </SettingsContextMenu>
                        <Styles>
                            <Item Font-Size="9pt"></Item>
                        </Styles>
                    </dx:ASPxFileManager>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
    </div>
    <script type="text/javascript" src="Scripts/jquery.maskMoney.js"></script>
    <script type="text/javascript">
        jQuery(function ($) {
            $(".valor").maskMoney({ allowZero: true });
        });
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfUser2" runat="server" />
    <div class="container p-0">
        <div class="row card" style="margin: 0 auto">
            <div class="card-header p-0 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:Aquisicao, aquisição_tituloPag %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <asp:Label ID="Label30" runat="server" Text="<%$ Resources:Aquisicao, aquisição_right_titulo %>" CssClass="labels text-left"></asp:Label>
            <div class="input-group mb-auto" onmouseover="QuickGuide('titulo');">
                <dx:ASPxDropDownEdit ID="ddePesqContrato" ClientInstanceName="ddePesqContrato" CssClass="drop-down" ClientIDMode="Static" Width="100%" runat="server" Theme="Material" AllowUserInput="false">
                    <ClientSideEvents CloseUp="function(s, e) {  
                                s.ShowDropDown();
                                }" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
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
AND OPTPTPID NOT IN (91,99) 
AND OP.TVIDESTR IN(SELECT DISTINCT TVIDESTR FROM VIFSFUSU WHERE USIDUSUA = ?)
ORDER BY OPIDCONT DESC">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfUser2" PropertyName="Value" Name="?"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <div class="row" style="display: none">
                                <div class="col-12 text-right">
                                    <asp:Button ID="btnselecionar" CausesValidation="false" ClientIDMode="Static" runat="server" CssClass="Loading btn mt-1 mb-1 btn-act" OnClick="btnselecionar_Click" Text="<%$Resources:GlobalResource, btn_selecionar %>" />
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
                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col1 %>" Width="70px" MaxWidth="70" FieldName="OPCDCONT" VisibleIndex="0">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" ValueField="OPCDCONT" TextField="OPCDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <EditFormSettings VisibleIndex="0" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col2 %>" Width="170px" MaxWidth="170" FieldName="TVDSESTR" VisibleIndex="1">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="TVDSESTR" ValueField="TVDSESTR" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="1" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col3 %>" Width="120px" MaxWidth="120" FieldName="PRPRODES" VisibleIndex="2">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODES" ValueField="PRPRODES" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="2" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:Aquisicao, aquisição_right_grid_col5 %>' Width="50px" MaxWidth="50" FieldName="PRPRODID" VisibleIndex="5">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="3" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption='<%$ Resources:Aquisicao, aquisição_right_grid_col6 %>' Width="60px" MaxWidth="60" FieldName="OPIDCONT" VisibleIndex="6">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT"></PropertiesComboBox>

                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT" IncrementalFilteringMode="Contains" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="4" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataTextColumn FieldName="OPVLCONT" MaxWidth="60" Width="60px" Caption="<%$ Resources:Aquisicao, aquisição_right_grid_col4 %>" VisibleIndex="4">
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
        <div class="row mt-3" style="margin: 0 auto">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('inserir');">
                <asp:Button ID="btnInsert" CausesValidation="false" CssClass="Loading btn-using" runat="server" Text="<%$ Resources:GlobalResource, btn_inserir %>" OnClick="btnInsert_Click" OnLoad="btnInsert_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('excluir');">
                <asp:Button ID="btnDelete" CausesValidation="false" CssClass="Loading btn-using" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" OnClick="btnDelete_Click" OnLoad="btnDelete_Load" />

            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 8px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('alterar');">
                <asp:Button ID="btnEdit" CausesValidation="false" CssClass="Loading btn-using" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" OnClick="btnEdit_Click" OnLoad="btnEdit_Load" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('replicar');">
                <asp:Button ID="btnReplicar" CausesValidation="false" CssClass="Loading btn-using" runat="server" Text="<%$ Resources:GlobalResource, btn_replicar %>" OnClick="btnReplicar_Click" OnLoad="btnReplicar_Load" />
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 8px">
            <div class="col-lg-6 pl-0" onmouseover="QuickGuide('historico');">
                <dx:ASPxButton ID="btnHistorico" runat="server" Enabled="false" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_historico %>" OnLoad="btnHistorico_Load">
                    <ClientSideEvents Click="function(s,e){pupLog.Show();}" />
                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                </dx:ASPxButton>
                <dx:ASPxPopupControl ID="pupLog" ClientIDMode="Static" ClientInstanceName="pupLog" Width="800px" Height="200px"
                    PopupHorizontalAlign="WindowCenter" ShowHeader="true" PopupVerticalAlign="WindowCenter" runat="server" EnableViewState="false"
                    EnableHierarchyRecreation="true" CloseAction="OuterMouseClick" CssClass="rounding" ShowCloseButton="true" CloseOnEscape="false" PopupAnimationType="Fade"
                    Modal="false">
                    <HeaderContentTemplate>
                        <h5>
                            <asp:Label ID="Label33" runat="server" Text="<%$ Resources:Aquisicao, aquisicao_historico_titulo %>" CssClass="labels text-left"></asp:Label></h5>
                    </HeaderContentTemplate>
                    <ContentCollection>
                        <dx:PopupControlContentControl>
                            <dx:ASPxGridView ID="gridPopup" ClientIDMode="Static" runat="server" AutoGenerateColumns="False"
                                DataSourceID="sqlHistLog" Theme="Material">
                                <Settings VerticalScrollableHeight="180" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Visible" />
                                <SettingsPager Visible="false"></SettingsPager>
                                <SettingsBehavior AllowFocusedRow="True" />
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Columns>
                                    <dx:GridViewDataDateColumn FieldName="Justificativa" Width="200px" VisibleIndex="0" Caption="<%$ Resources:Aquisicao, aquisicao_historico_col1 %>"></dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="Propriedade" Width="200px" VisibleIndex="1" Caption="<%$ Resources:Aquisicao, aquisicao_historico_col2 %>"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Valor Propriedade" Width="130px" VisibleIndex="2" Caption="<%$ Resources:Aquisicao, aquisicao_historico_col3 %>">
                                        <CellStyle HorizontalAlign="Center"></CellStyle>
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Aditamento" Width="200px" VisibleIndex="3" Caption="<%$ Resources:Aquisicao, aquisicao_historico_col4 %>"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Sequência" Width="130px" VisibleIndex="4" Caption="<%$ Resources:Aquisicao, aquisicao_historico_col5 %>">
                                        <CellStyle HorizontalAlign="Center"></CellStyle>
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
                                    <Cell Wrap="False" Paddings-Padding="5px" HorizontalAlign="Left"></Cell>
                                    <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                </Styles>
                            </dx:ASPxGridView>
                            <asp:SqlDataSource runat="server" ID="sqlHistLog" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                SelectCommand="select * from nesta_vw_aditamentos where [Id Interno]=? order by [Sequência]">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="ID" Name="opidcont"></asp:SessionParameter>

                                </SelectParameters>
                            </asp:SqlDataSource>
                        </dx:PopupControlContentControl>
                    </ContentCollection>

                </dx:ASPxPopupControl>
            </div>
            <div class="col-lg-6 pl-1" onmouseover="QuickGuide('aditamento');">
                <dx:ASPxButton ID="btnAditamento" runat="server" CssClass="btn-using pl-0 pr-0" Enabled="false" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:Aquisicao, aquisição_btn_aditamento %>" OnLoad="btnAditamento_Load">
                    <ClientSideEvents Click="function(s,e) { txtJustifica.SetText(); popupAditamento.Show(); } " />
                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                </dx:ASPxButton>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 8px">
            <div class="col-lg-6 pl-0" style="text-align: center;" onmouseover="QuickGuide('ok');">
                <asp:Button ID="btnOK" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_ok %>" OnClick="btnOK_Click" Style="background-color: #FFCC66;" />
            </div>
            <div class="col-lg-6 pl-1" style="text-align: center;" onmouseover="QuickGuide('cancelar');">
                <asp:Button ID="btnCancelar" CausesValidation="false" runat="server" CssClass="Loading btn-using" Text="<%$ Resources:GlobalResource, btn_cancelar %>" OnClick="btnCancelar_Click" Style="background-color: #CC9999;" />
            </div>
        </div>

    </div>
</asp:Content>
