<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" MaintainScrollPositionOnPostback="true" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="Aquisicao.aspx.cs" Inherits="WebNesta_IRFS_16.Aquisicao" %>

<%@ MasterType VirtualPath="~/Site.Master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
    <script type="text/javascript">
        function openModalContratos() {
            $('#ModalContratos').modal('show');
        }
        function openModalEstrutura() {
            $('#ModalEstrutura').modal('show');
        }
        function openModalBasesInsert() {
            $('#ModalBasesInsert').modal('show');
        }
        function openModalBasesAlterar() {
            $('#ModalBasesAlterar').modal('show');
        }
    </script>
    <style>
        .modal .modal-dialog {
            width: 60%;
        }
    </style>

</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:HiddenField ID="hfEstruturaCorporativa" runat="server" />
    <asp:HiddenField ID="hfProduto" runat="server" />
    <asp:HiddenField ID="hfSqlInsert" runat="server" />
    <asp:HiddenField ID="hfCodInterno" runat="server" />
    <asp:HiddenField ID="hfPostBack" runat="server" />
    <asp:HiddenField ID="hfOPCDCONT" runat="server" />
    <asp:HiddenField ID="hfTVDSESTR" runat="server" />
    <asp:HiddenField ID="hfPRPRODES" runat="server" />
    <asp:HiddenField ID="hfOPVLCONT" runat="server" />
    <asp:HiddenField ID="hfPRPRODID" runat="server" />
    <!--Bootstrap Modal (Dialog Box / Pop-up window) Example-->
    <div id="ModalContratos" class="modal fade" role="dialog">
        <div class="modal-dialog modal-lg w-100">
            <div class="modal-content">
                <div class="modal-header">

                    <asp:Button ID="btnClose" runat="server" CssClass="close btn btn-sm btn-outline-light" Text="X" Font-Size="Small" />
                </div>
                <div class="modal-body">
                    <asp:SqlDataSource ID="sqlProcessos" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
                        SelectCommand="SELECT OP.OPCDCONT, TV.TVDSESTR, PR.PRPRODES, OP.OPVLCONT,OP.PRPRODID,OP.OPIDCONT 
FROM OPCONTRA OP 
LEFT OUTER JOIN CACTEIRA CA ON(OP.CAIDCTRA = CA.CAIDCTRA) 
LEFT OUTER JOIN OPTPFRCO FR ON(OP.OPTPFRID = FR.OPTPFRID) 
INNER JOIN PRPRODUT PR   ON(PR.CMTPIDCM = FR.CMTPIDCM AND OP.PRPRODID = PR.PRPRODID) 
INNER JOIN TPSIMNAO SN   ON(OP.TPIDSINA = SN.TPIDSINA) 
INNER JOIN OPTPTIPO TP   ON(OP.OPTPTPID = TP.OPTPTPID AND PR.CMTPIDCM = TP.CMTPIDCM) 
INNER JOIN PRTPOPER PE   ON(OP.PRTPIDOP = PE.PRTPIDOP AND PR.CMTPIDCM = PE.CMTPIDCM) 
INNER JOIN OPTPRGCO RG   ON(OP.OPTPRGID = RG.OPTPRGID AND PR.CMTPIDCM = RG.CMTPIDCM) 
INNER JOIN IEINDECO IE   ON(PR.IEIDINEC = IE.IEIDINEC) 
INNER JOIN FOFORNEC FO   ON(OP.FOIDFORN = FO.FOIDFORN) 
INNER JOIN TVESTRUT TV   ON(OP.TVIDESTR = TV.TVIDESTR) 
AND FR.PAIDPAIS = 1 
AND SN.PAIDPAIS = 1 
AND TP.PAIDPAIS = 1 
AND PE.PAIDPAIS = 1 
AND RG.PAIDPAIS = 1 
AND PR.CMTPIDCM NOT IN(2, 4, 5) 
AND OP.OPIDAACC IS NULL 
AND   OP.PRTPIDOP NOT IN(5) 
UNION 
SELECT OP.OPCDCONT, TV.TVDSESTR, PR.PRPRODES, OP.OPVLCONT,OP.PRPRODID,OP.OPIDCONT 
FROM OPCONTRA OP 
LEFT OUTER JOIN CACTEIRA CA ON(OP.CAIDCTRA = CA.CAIDCTRA) 
LEFT OUTER JOIN OPTPFRCO FR ON(OP.OPTPFRID = FR.OPTPFRID) 
INNER JOIN PRPRODUT PR  ON(PR.CMTPIDCM = FR.CMTPIDCM AND OP.PRPRODID = PR.PRPRODID) 
INNER JOIN TPSIMNAO SN  ON(OP.TPIDSINA = SN.TPIDSINA) 
INNER JOIN OPTPTIPO TP  ON(OP.OPTPTPID = TP.OPTPTPID AND PR.CMTPIDCM = TP.CMTPIDCM) 
INNER JOIN PRTPOPER PE  ON(OP.PRTPIDOP = PE.PRTPIDOP AND PR.CMTPIDCM = PE.CMTPIDCM) 
INNER JOIN OPTPRGCO RG  ON(OP.OPTPRGID = RG.OPTPRGID AND PR.CMTPIDCM = RG.CMTPIDCM) 
INNER JOIN IEINDECO IE  ON(PR.IEIDINEC = IE.IEIDINEC) 
INNER JOIN FOFORNEC FO  ON(OP.FOIDFORN = FO.FOIDFORN) 
INNER JOIN TVESTRUT TV  ON(OP.TVIDESTR = TV.TVIDESTR) 
AND FR.PAIDPAIS = 1 
AND SN.PAIDPAIS = 1 
AND TP.PAIDPAIS = 1 
AND PE.PAIDPAIS = 1 
AND RG.PAIDPAIS = 1 
AND PR.CMTPIDCM NOT IN(2, 4, 5) 
AND OP.PRTPIDOP IN(5) 
ORDER BY OPCDCONT"></asp:SqlDataSource>
                    <table style="width: 100%">
                        <tr>
                            <td style="text-align: right">

                                <dx:ASPxButton ID="ASPxButton2" Theme="Moderno" CssClass="form-control-md" runat="server" Text="Selecionar" OnClick="ASPxButton1_Click"></dx:ASPxButton>


                            </td>
                        </tr>

                        <tr>
                            <td>
                                <dx:ASPxGridView ID="ASPxGridView1" OnCustomButtonCallback="ASPxGridView1_CustomButtonCallback" ClientInstanceName="ASPxGridView1" runat="server" AutoGenerateColumns="False" DataSourceID="sqlProcessos" EnableCallBacks="true" Theme="Moderno">
                                    <Settings VerticalScrollableHeight="400" ShowFilterRow="True" />
                                    <SettingsBehavior AllowFocusedRow="True" />
                                    <SettingsPopup>
                                        <%--<HeaderFilter MinHeight="140px">
                                        </HeaderFilter>--%>
                                    </SettingsPopup>
                                    <Columns>
                                        <%--<dx:GridViewCommandColumn VisibleIndex="0" ButtonRenderMode="Image" ShowClearFilterButton="True">
                                            <CustomButtons>
                                                <dx:GridViewCommandColumnCustomButton ID="Select">
                                                    <Image ToolTip="Select" Url="icons/ok.png" />
                                                </dx:GridViewCommandColumnCustomButton>
                                            </CustomButtons>
                                        </dx:GridViewCommandColumn>--%>
                                        <dx:GridViewDataComboBoxColumn Caption="Número Processo" FieldName="OPCDCONT" VisibleIndex="1">
                                            <PropertiesComboBox DataSourceID="sqlProcessos" ValueField="OPCDCONT" TextField="OPCDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <Settings AllowAutoFilter="True" />
                                            <EditFormSettings VisibleIndex="0" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="Estrutura Corporativa" FieldName="TVDSESTR" VisibleIndex="2">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="TVDSESTR" ValueField="TVDSESTR" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="1" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="Produto" FieldName="PRPRODES" VisibleIndex="3">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODES" ValueField="PRPRODES" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList"></PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="2" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="Valor" FieldName="OPVLCONT" VisibleIndex="4">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPVLCONT" ValueField="OPVLCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="3" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="# Produto" FieldName="PRPRODID" VisibleIndex="5">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="PRPRODID" ValueField="PRPRODID" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="4" />
                                        </dx:GridViewDataComboBoxColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="# Contrato" FieldName="OPIDCONT" VisibleIndex="6">
                                            <Settings AllowAutoFilter="True" />
                                            <PropertiesComboBox DataSourceID="sqlProcessos" TextField="OPIDCONT" ValueField="OPIDCONT" IncrementalFilteringMode="StartsWith" DropDownStyle="DropDownList">
                                            </PropertiesComboBox>
                                            <EditFormSettings VisibleIndex="5" />
                                        </dx:GridViewDataComboBoxColumn>
                                    </Columns>
                                    <Styles>
                                        <Row Font-Size="Small"></Row>
                                        <Header Font-Size="Small"></Header>
                                        <FilterRow Font-Size="Small"></FilterRow>
                                    </Styles>
                                </dx:ASPxGridView>

                            </td>
                        </tr>
                    </table>

                </div>
            </div>
        </div>
    </div>
    <div class="container">

        <asp:Panel ID="pnlConsulta" Visible="true" runat="server">
            <%--Painel com as informações de Consulta--%>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label2" runat="server" Text="Informações Gerais"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 25%">
                                <asp:Label ID="lblEstCorpo" runat="server" Text="Estrutura Corporativa" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtEstCorpo" CssClass="form-control-sm" Width="95%" Enabled="false" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblCodInterno" runat="server" Text="Código Interno" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtCodInterno" CssClass="border-1 form-control-sm" Width="95%" Enabled="false" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblNumProc" runat="server" Text="Número Processo" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtNumProc" CssClass="form-control-sm" ReadOnly="true" Width="60%" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                        <asp:ImageButton ID="btnNumProc" CssClass="btn btn-outline-lupa" Width="90%" Height="90%" runat="server" ImageUrl="~/icons/lupa.png" OnClick="btnNumProc_Click" />
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblCodAuxiliar" runat="server" Text="Código Auxiliar" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtCodAuxiliar" CssClass="border-1 form-control-sm" Width="95%" Enabled="false" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%" colspan="2">
                                <asp:Label ID="lblDesc" runat="server" Text="Descrição" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtDesc" CssClass="border-1 form-control-sm" Width="97%" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblDataAquisi" runat="server" Text="Data Aquisição" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtDataAquisi" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblHoraAquisi" runat="server" Text="Hora Aquisição" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtHoraAquisi" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 25%">
                                <asp:Label ID="lblEstrut" runat="server" Text="Estrutura" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtEstrut" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblClasseProduto" runat="server" Text="Classe Produto" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtClasseProduto" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblProduto" runat="server" Text="Produto" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtProd" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblCarteira" runat="server" Text="Carteira" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtCarteira" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label5" runat="server" Text="Classificação Contrato"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 25%">
                                <asp:Label ID="lblFormatoOperacao" runat="server" Text="Formato operação" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-3">
                                    <asp:TextBox ID="txtFormatoOperacao" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblAgntFinanc" runat="server" Text="Contratado" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-3">
                                    <asp:TextBox ID="txtAgntFinanc" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="lblTipo" runat="server" Text="Tipo" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-3">
                                    <asp:TextBox ID="txtTipo" Width="95%" CssClass="border-1 form-control-sm" Enabled="true" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                                <%--                                    <asp:Label ID="lblEstruContra" runat="server" Text="Estrutura contratada" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtEstruContra" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                        </div>
                                    </div>--%>
                            </td>
                            <td style="width: 25%">
                                <%--                                    <asp:Label ID="lblRegistro" runat="server" Text="Registro" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtRegistro" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                        </div>
                                    </div>--%>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label6" runat="server" Text="Bases Negociação"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <asp:Panel ID="pnlBases" runat="server" Width="100%">
                    </asp:Panel>

                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlExclusao" Visible="false" runat="server">
            <br />
            <div class="row text-center">
                <br />
                <div class="col-2"></div>
                <div class="col-lg-8 card align-items-center">
                    <div class="card-header">
                        <h3>
                            <asp:Label ID="Label27" runat="server" CssClass=" text-danger" Text="Processo de Exclusão"></asp:Label></h3>
                    </div>
                    <div class="card-body">
                        <table>
                            <tr>
                                <td colspan="2">
                                    <h4>
                                        <asp:Label ID="Label28" runat="server" CssClass="" Text="Texto sobre processo de exclusão de um contrato"></asp:Label></h4>
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
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label11" runat="server" Text="Informações Gerais"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 25%">
                                <asp:Label ID="Label12" runat="server" Text="Estrutura Corporativa" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtEstruturaCorporativaEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label1" runat="server" Text="Código Interno" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtCodInternoEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label13" runat="server" Text="Número Processo" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtNumProcessoEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label22" runat="server" Text="Código Auxiliar" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtCodAuxiliarEdit" Width="95%" MaxLength="15" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%" colspan="2">
                                <asp:Label ID="Label14" runat="server" Text="Descrição" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtDescricaoEdit" Width="97%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label15" runat="server" Text="Estrutura" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtEstruturaEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label23" runat="server" Text="Classe Produto" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtClasseProdEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 25%">
                                <asp:Label ID="Label16" runat="server" Text="Produto" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtProdutoEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label35" runat="server" Text="Carteira" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:DropDownList ID="dropCarteiraEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label17" runat="server" Text="Data Aquisição" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtDataAquisicaoEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label18" runat="server" Text="Hora Aquisição" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtHoraAquisicaoEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label19" runat="server" Text="Classificação Contrato"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 25%">
                                <asp:Label ID="Label20" runat="server" Text="Formato operação" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtFormatoOperEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label21" runat="server" Text="Contratado" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:TextBox ID="txtAgntFinancEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                            </td>
                            <td style="width: 25%">
                                <asp:Label ID="Label24" runat="server" Text="Tipo" CssClass="form-control-sm"></asp:Label>
                                <div class="input-group mb-auto">
                                    <asp:DropDownList ID="dropTipoEdit" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                    <div class="input-group-append">
                                    </div>
                                </div>
                                <%--<asp:Label ID="Label22" runat="server" Text="Estrutura contratada" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtEstruturaContratadaEdit" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                        </div>
                                    </div>--%>
                            </td>
                            <td style="width: 25%">
                                <%--                                    <asp:Label ID="Label23" runat="server" Text="Registro" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtRegistroEdit" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                        </div>
                                    </div>--%>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label25" runat="server" Text="Bases Negociação"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <asp:Panel ID="Panel1" runat="server" Width="100%" GroupingText="">
                        <div class="container">
                            <div class="row">
                                <div class="col-12">
                                    <asp:Repeater ID="rptBasesEdit" runat="server" OnItemDataBound="rptBasesEdit_ItemDataBound">
                                        <HeaderTemplate>
                                            <table style="width: 100%">
                                                <tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <td style="width: 25%">

                                                <asp:Label ID="Label29" runat="server" CssClass="form-control-sm" Text='<%#DataBinder.Eval(Container.DataItem, "CJDSDECR")%>'></asp:Label>
                                                <div class="input-group mb-auto">
                                                    <table style="width: 95%;">
                                                        <tr>
                                                            <td style="text-align: left" class="tblRptControl">
                                                                <asp:LinkButton ID="lnkRptBasesEdit" ClientIDMode="Static" runat="server" OnCommand="BasesEdit"
                                                                    CommandName='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>'
                                                                    CommandArgument='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>'>
                                                <%#DataBinder.Eval(Container.DataItem, "CJTPCTTX")%>
                                                                </asp:LinkButton>

                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <asp:Literal ID="ltrlRepeaterBasesEdit" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </tr>
                                    </table>
                                        </FooterTemplate>
                                    </asp:Repeater>


                                    <div id="ModalBasesAlterar" class="modal fade" role="dialog">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <asp:Button ID="Button3" runat="server" CssClass="close btn btn-sm btn-outline-light" Text="X" Font-Size="Small" />
                                                </div>
                                                <div class="modal-body">
                                                    <asp:Panel ID="pnlGridEdit" runat="server">
                                                        <asp:HiddenField ID="hfOPIDCONT2" runat="server" />
                                                        <asp:HiddenField ID="hfCHIDCODI2" runat="server" />
                                                        <asp:HiddenField ID="hfCJIDCODI2" runat="server" />
                                                        <asp:HiddenField ID="hfCJTPIDTP2" runat="server" />
                                                        <asp:Panel ID="pnlGridDataEdit" runat="server" Visible="false">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="lblEditarData" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        <div class="input-group mb-3">
                                                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender2" TargetControlID="txtEditarData" Enabled="true" runat="server" />
                                                                            <asp:TextBox ID="txtEditarData" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                            <div class="input-group-append">
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button ID="btnEditarData" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarData_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlGridMoedaEdit" runat="server" Visible="false">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="lblEditarMoeda" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        <div class="input-group mb-3">
                                                                            <ajaxToolkit:MaskedEditExtender ID="MaskedVlEdit1" Enabled="true" runat="server" TargetControlID="txtEditarMoeda"
                                                                                Mask="999999999.99" InputDirection="LeftToRight"
                                                                                MaskType="Number" AutoComplete="False" ClipboardEnabled="False" />
                                                                            <asp:TextBox ID="txtEditarMoeda" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                            <div class="input-group-append">
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button ID="btnEditarMoeda" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarMoeda_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlGridInteiroEdit" runat="server" Visible="false">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="lblEditarInteiro" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        <div class="input-group mb-3">
                                                                            <asp:TextBox ID="txtEditarInteiro" CssClass="border-1 form-control-sm" runat="server" TextMode="Number"></asp:TextBox>
                                                                            <div class="input-group-append">
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button ID="btnEditarInteiro" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarInteiro_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlEditarFlutuante" runat="server" Visible="false">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" Enabled="true" runat="server" TargetControlID="txtEditarFlutuante"
                                                                            Mask="999999999.99" InputDirection="RightToLeft"
                                                                            MaskType="Number" AutoComplete="False" ClipboardEnabled="False" />
                                                                        <asp:Label ID="lblEditarFlutuante" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        <div class="input-group mb-3">
                                                                            <asp:TextBox ID="txtEditarFlutuante" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                            <div class="input-group-append">
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button ID="btnEditarFlutuante" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarFlutuante_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlGridFormulaEdit" runat="server" Visible="false">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="lblEditarFormula" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        <div class="input-group mb-3">
                                                                            <asp:DropDownList ID="dropEditarFormula" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                                                            <div class="input-group-append">
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button ID="btnEditarFormula" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarFormula_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlGridIndiceEdit" runat="server" Visible="false">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="lblEditarIndice" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        <div class="input-group mb-3">
                                                                            <asp:TextBox ID="txtEditarIndice" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                            <div class="input-group-append">
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button ID="btnEditarIndice" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarIndice_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlGridSQLEdit" runat="server" Visible="false">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label ID="lblEditarSql" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        <div class="input-group mb-3">
                                                                            <asp:DropDownList ID="dropEditarSql" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                                                            <div class="input-group-append">
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button ID="btnEditarSql" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarSql_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlGridDeAteEdit" runat="server" Visible="false">
                                                            <div class="row">
                                                                <div class="col-sm-12">
                                                                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                                                        <ContentTemplate>
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label ID="lblEditarDeAte" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div class="input-group mb-3">
                                                                                            <asp:Label ID="Label26" runat="server" Text="Itens: "></asp:Label>
                                                                                            <asp:TextBox ID="txtEditarDeAte" Width="30%" CssClass="btn badge-secondary border-0" TextMode="Number" runat="server"></asp:TextBox>
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
                                                                                                                <asp:TextBox Font-Names="Arial" Font-Size="10px" Width="100px" ID="txtDt1Edit" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "De")%>'></asp:TextBox></td>
                                                                                                            <td style="width: 15%">
                                                                                                                <ajaxToolkit:CalendarExtender ID="CalendarDtEdit2" Enabled="true" TargetControlID="txtDt2Edit" PopupButtonID="txtDt2Edit" runat="server" />
                                                                                                                <asp:TextBox Font-Names="Arial" Font-Size="10px" Width="100px" ID="txtDt2Edit" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Ate")%>'></asp:TextBox></td>
                                                                                                            <td style="width: 15%">
                                                                                                                <ajaxToolkit:MaskedEditExtender ID="MaskedVlEdit1" Enabled="true" runat="server" TargetControlID="txtVlEdit"
                                                                                                                    Mask="99999.99" InputDirection="LeftToRight"
                                                                                                                    MaskType="Number" AutoComplete="False" ClipboardEnabled="False" />
                                                                                                                <asp:TextBox Font-Names="Arial" Font-Size="10px" Width="100px" ID="txtVlEdit" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Valor")%>'></asp:TextBox></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </ItemTemplate>
                                                                                            </asp:Repeater>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Button ID="btnEditarDeAte" CssClass="btn btn-primary" runat="server" Text="Alterar" OnClick="btnEditarDeAte_Click" />
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </ContentTemplate>
                                                                        <Triggers>
                                                                            <asp:PostBackTrigger ControlID="btnEditarDeAte" />
                                                                        </Triggers>
                                                                    </asp:UpdatePanel>
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlInsert" Visible="false" runat="server">
            <%--Painel com campos para Insert--%>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label7" runat="server" Text="Informações gerais"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <asp:Panel ID="pnlGeraisInsert" runat="server" GroupingText="" Width="100%">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 25%">
                                    <asp:Label ID="lblEstruturaCorporativaInsert" runat="server" Text="Estrutura Corporativa" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtEstruturaCorporativaInsert" Width="60%" CssClass="form-control-sm" AutoPostBack="True" runat="server"></asp:TextBox>
                                        <div class="input-group-append">
                                            <asp:ImageButton ID="btnEstruturaCorpInsert" CssClass="btn btn-outline-lupa" Width="90%" Height="90%" runat="server" ImageUrl="~/icons/lupa.png" OnClick="btnEstruturaCorpInsert_Click" />
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
                                                        <asp:TreeView ID="TreeView1" runat="server" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged">
                                                        </asp:TreeView>
                                                    </asp:Panel>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblCodInternoInsert" runat="server" Text="Código Interno" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtCodInternoInsert" Width="95%" Enabled="false" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblNumProcessoInsert" runat="server" Text="Número Processo" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtNumProcessoInsert" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblCodAuxInsert" runat="server" Text="Código Auxiliar" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtCodAuxInsert" CssClass="border-1 form-control-sm" Width="95%" runat="server"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 50%" colspan="2">
                                    <asp:Label ID="lblDescricaoInsert" runat="server" Text="Descrição" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtDescricaoInsert" CssClass="border-1 form-control-sm" Width="97%" runat="server" AutoPostBack="True" OnTextChanged="txtDescricaoInsert_TextChanged"></asp:TextBox>
                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblEstruturaInsert" runat="server" Text="Estrutura" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:DropDownList ID="dropEstruturaInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server" OnSelectedIndexChanged="dropEstruturaInsert_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                                    </div>

                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblClasseProdutoInsert" runat="server" Text="Classe Produto" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:DropDownList ID="dropClasseProdutoInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server" AutoPostBack="True" OnSelectedIndexChanged="dropClasseProdutoInsert_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">
                                    <asp:Label ID="lblProdutoInsert" runat="server" Text="Produto" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:DropDownList ID="dropProdutoInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server" AutoPostBack="True" OnSelectedIndexChanged="dropProdutoInsert_SelectedIndexChanged"></asp:DropDownList>
                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblCarteiraInsert" runat="server" Text="Carteira" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:DropDownList ID="dropCarteiraInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender3" Enabled="true" runat="server" TargetControlID="txtValorContInsert"
                                        Mask="999999999.99" InputDirection="LeftToRight"
                                        MaskType="Number" AutoComplete="False" ClipboardEnabled="False" />
                                    <asp:Label ID="lblValorContInsert" runat="server" Text="Valor contrato" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtValorContInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server" ClientIDMode="Static"></asp:TextBox>
                                    </div>

                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="Label3" runat="server" Text="Operador" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtOperadorInsert" Width="95%" ReadOnly="true" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%">

                                    <asp:Label ID="lblDtAquisiInsert" runat="server" Text="Data Aquisição" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <ajaxToolkit:CalendarExtender ID="CalendarExtender1" Enabled="true" TargetControlID="txtDtAquisiInsert" runat="server" ClientIDMode="Static" PopupButtonID="txtDtAquisiInsert" />
                                        <asp:TextBox ID="txtDtAquisiInsert" Width="95%" ClientIDMode="Static" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    </div>

                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblHrAquisiInsert" runat="server" Text="Hora Aquisição" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:TextBox ID="txtHrAquisiInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25%"></td>
                                <td style="width: 25%"></td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label8" runat="server" Text="Classificação contrato"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <asp:Panel ID="pnlClassificacaoInsert" runat="server" Width="100%">
                        <table style="width: 100%">
                            <tr>
                                <td style="width: 25%">
                                    <asp:Label ID="lblFormatoOperacaoInsert" runat="server" Text="Formato operação" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:DropDownList ID="dropFormatoOperacaoInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="Label10" runat="server" Text="Contratado" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:DropDownList ID="dropAgenteFinanceiroInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>

                                    </div>
                                </td>
                                <td style="width: 25%">
                                    <asp:Label ID="lblTipoInsert" runat="server" Text="Tipo" CssClass="form-control-sm"></asp:Label>
                                    <div class="input-group mb-auto">
                                        <asp:DropDownList ID="dropTipoInsert" Width="95%" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                    </div>
                                    <%--                                        <asp:Label ID="lblEstruturaContratadaInsert" runat="server" Text="Estrutura contratada" CssClass="form-control-sm"></asp:Label>
                                        <div class="input-group mb-3">
                                            <asp:DropDownList ID="dropEstruturaContratadaInsert" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                        </div>--%>
                                </td>
                                <td style="width: 25%">
                                    <%--                                        <asp:Label ID="lblRegistroInsert" runat="server" Text="Registro" CssClass="form-control-sm"></asp:Label>
                                        <div class="input-group mb-3">
                                            <asp:DropDownList ID="dropRegistroInsert" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                        </div>--%>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>
            <div class="row card">
                <div class="card-header">
                    <h5>
                        <asp:Label ID="Label9" runat="server" Text="Bases negociação"></asp:Label></h5>
                </div>
                <div class="card-body">
                    <asp:Panel ID="pnlBasesInsert_Father" Visible="false" runat="server" Width="100%" GroupingText="">
                        <asp:Panel ID="pnlBasesInsert2" Visible="true" runat="server">
                        </asp:Panel>
                        <table></table>
                        <asp:Repeater ID="rptBasesInserir" runat="server" OnItemDataBound="rptBasesInserir_ItemDataBound" OnItemCreated="rptBasesInserir_ItemCreated">
                            <HeaderTemplate>
                                <table style="width: 100%">
                                    <tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <td style="width: 25%">

                                    <asp:Label ID="Label29" runat="server" CssClass="form-control-sm" Text='<%#DataBinder.Eval(Container.DataItem, "CJDSDECR")%>'></asp:Label>
                                    <div class="input-group mb-auto">
                                        <table style="width: 95%;">
                                            <tr>
                                                <td style="text-align: left" class="tblRptControl">
                                                    <asp:LinkButton ID="lnkRptBasesInsert" ClientIDMode="Static" runat="server" OnCommand="Button2_Command"
                                                        CommandName='<%# string.Format("{0}#{1}#{2}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString())%>'
                                                        CommandArgument='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>'>
                                                <%#DataBinder.Eval(Container.DataItem, "CJTPCTTX")%>
                                                    </asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                                <asp:Literal ID="ltrlRepeaterBasesInserir" runat="server"></asp:Literal>
                            </ItemTemplate>
                            <FooterTemplate>
                                </tr>
                                    </table>
                            </FooterTemplate>
                        </asp:Repeater>


                        <div id="ModalBasesInsert" class="modal fade" role="dialog">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <asp:Button ID="Button2" runat="server" CssClass="close btn btn-sm btn-outline-light" Text="X" Font-Size="Small" />
                                    </div>
                                    <div class="modal-body">
                                        <asp:Panel ID="pnlGrid" runat="server">
                                            <asp:HiddenField ID="hfOPIDCONT" runat="server" />
                                            <asp:HiddenField ID="hfCHIDCODI" runat="server" />
                                            <asp:HiddenField ID="hfCJIDCODI" runat="server" />
                                            <asp:HiddenField ID="hfCJTPIDTP" runat="server" />
                                            <asp:Panel ID="pnlGridData" runat="server" Visible="false">

                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblInserirData" runat="server" Text="" CssClass="form-control-sm "></asp:Label>
                                                            <div class="input-group mb-3">
                                                                <ajaxToolkit:CalendarExtender ID="CalendarInserirData" PopupButtonID="txtInserirData" TargetControlID="txtInserirData" ClientIDMode="Static" Enabled="true" runat="server" />
                                                                <asp:TextBox ID="txtInserirData" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                <div class="input-group-append">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="btnInserirData" CssClass="btn btn-primary" runat="server" Text="Inserir" OnClick="btnInserirData_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                            <asp:Panel ID="pnlGridMoeda" runat="server" Visible="false">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblInserirMoeda" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                            <div class="input-group mb-3">
                                                                <ajaxToolkit:MaskedEditExtender ID="MaskedVl1" Enabled="true" runat="server" TargetControlID="txtInserirMoeda"
                                                                    Mask="999999999.99" InputDirection="RightToLeft"
                                                                    MaskType="Number" />
                                                                <asp:TextBox ID="txtInserirMoeda" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                <div class="input-group-append">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="btnInserirMoeda" CssClass="btn btn-primary" runat="server" Text="Inserir" OnClick="btnInserirMoeda_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                            <asp:Panel ID="pnlGridInteiro" runat="server" Visible="false">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblInserirInteiro" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                            <div class="input-group mb-3">
                                                                <asp:TextBox ID="txtInserirInteiro" CssClass="border-1 form-control-sm" runat="server" TextMode="Number"></asp:TextBox>
                                                                <div class="input-group-append">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="btnInserirInteiro" CssClass="btn btn-primary" runat="server" Text="Inserir" OnClick="btnInserirInteiro_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                            <asp:Panel ID="pnlInserirFlutuante" runat="server" Visible="false">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender2" Enabled="true" runat="server" TargetControlID="txtInserirFlutuante"
                                                                Mask="999999999.99" InputDirection="LeftToRight"
                                                                MaskType="Number" AutoComplete="False" ClipboardEnabled="False" />
                                                            <asp:Label ID="lblInserirFlutuante" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                            <div class="input-group mb-3">
                                                                <asp:TextBox ID="txtInserirFlutuante" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                <div class="input-group-append">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="btnInserirFlutuante" CssClass="btn btn-primary" runat="server" Text="Inserir" OnClick="btnInserirFlutuante_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                            <asp:Panel ID="pnlGridFormula" runat="server" Visible="false">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblInserirFormula" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                            <div class="input-group mb-3">
                                                                <asp:DropDownList ID="dropInserirFormula" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                                                <div class="input-group-append">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="btnInserirFormula" CssClass="btn btn-primary" runat="server" Text="Inserir" OnClick="btnInserirFormula_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                            <asp:Panel ID="pnlGridIndice" runat="server" Visible="false">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblInserirIndice" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                            <div class="input-group mb-3">
                                                                <asp:TextBox ID="txtInserirIndice" CssClass="border-1 form-control-sm" runat="server"></asp:TextBox>
                                                                <div class="input-group-append">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="btnInserirIndice" CssClass="btn btn-primary" runat="server" Text="Inserir" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                            <asp:Panel ID="pnlGridSQL" runat="server" Visible="false">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblInserirSql" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                            <div class="input-group mb-3">
                                                                <asp:DropDownList ID="dropInserirSql" CssClass="border-1 form-control-sm" runat="server"></asp:DropDownList>
                                                                <div class="input-group-append">
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Button ID="btnInserirSql" CssClass="btn btn-primary" runat="server" Text="Inserir" OnClick="btnInserirSql_Click" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:Panel>
                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                <ContentTemplate>
                                                    <asp:Panel ID="pnlGridDeAte" runat="server" Visible="false">
                                                        <div class="row">
                                                            <div class="col-sm-3">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:Label ID="lblInserirDeAte" runat="server" Text="" CssClass="form-control-sm"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:Label ID="Label4" runat="server" Text="Itens: " CssClass="form-control-sm"></asp:Label><br />
                                                                            <div class="input-group mb-3">
                                                                                <asp:TextBox ID="txtqtdItensDeAte" Width="30%" CssClass="btn badge-secondary border-0" TextMode="Number" Text="0" runat="server"></asp:TextBox>
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
                                                                                                    <ajaxToolkit:MaskedEditExtender ID="MaskedVl1" Enabled="true" runat="server" TargetControlID="txtVl"
                                                                                                        Mask="999999999.99" InputDirection="RightToLeft"
                                                                                                        MaskType="Number" />
                                                                                                    <asp:TextBox Font-Names="Arial" Font-Size="10px" ID="txtVl" CssClass="border-1 form-control-sm" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "Valor")%>'></asp:TextBox></td>
                                                                                            </tr>
                                                                                        </tbody>
                                                                                    </ItemTemplate>
                                                                                </asp:Repeater>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <asp:Button ID="btnInsertDeAte" CssClass="btn btn-primary" runat="server" Text="Inserir" OnClick="btnInsertDeAte_Click" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </asp:Panel>
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:PostBackTrigger ControlID="btnInsertDeAte" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                        </asp:Panel>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </asp:Panel>
    </div>
    <script type="text/javascript" src="Scripts/jquery.maskMoney.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#txtValorContInsert").maskMoney();
            //$("#txtInserirMoeda").maskMoney();
            //$("#txtEditarMoeda").maskMoney();
            //$("#txtVl").maskMoney();
            //$("#txtVlEdit").maskMoney();
            //$("#.MaskedMoney").maskMoney();

        });
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container">
        <div class="row">
            <table style="width: 100%; margin-top: 20%">
                <tr>
                    <td>
                        <asp:Button ID="btnInsert" CssClass="btn btn-act mb-3" runat="server" Text="Inserir" OnClick="btnInsert_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnEdit" CssClass="btn btn-act mb-3" runat="server" Text="Alterar" OnClick="btnEdit_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnDelete" CssClass="btn btn-act mb-3" runat="server" Text="Excluir" OnClick="btnDelete_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnOK" runat="server" Enabled="false" CssClass="btn btn-ok mb-3" Text="OK" OnClick="btnOK_Click" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnCancelar" runat="server" Enabled="false" CssClass="btn btn-cancelar mb-3" Text="Cancelar" OnClick="btnCancelar_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
