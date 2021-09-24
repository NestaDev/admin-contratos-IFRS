<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contrato.aspx.cs" Inherits="WebNesta_IRFS_16.Contrato" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            dropCarteiraInsert2.PerformCallback(TreeList.GetFocusedNodeKey());
            dropAgenteFinanceiroInsert2.PerformCallback(TreeList.GetFocusedNodeKey());
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
        function OnCountryChanged(cmbCountry) {
            dropClasseProdutoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
            dropFormatoOperacaoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
            dropTipoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString());
        }
        function OnClasseInsertChanged(dropClasseProdutoInsert2) {
            dropProdutoInsert2.PerformCallback(dropEstruturaInsert2.GetSelectedItem().value.toString().concat('#', dropClasseProdutoInsert2.GetSelectedItem().value.toString(), '#', document.getElementById('hfDropEstr').value));
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


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
                                    <dx:ASPxButton ID="btnAjuda" runat="server" AutoPostBack="false" CssClass="btn-saiba-mais" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_readmore %>">
                                    </dx:ASPxButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-10 pl-4">
                <asp:UpdatePanel ID="updPanelGeral" runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="panelActive2" runat="server" />
                        <asp:HiddenField ID="hfUser" runat="server" />
                        <asp:HiddenField ID="hfDropEstr" ClientIDMode="Static" runat="server" />
                        <asp:HiddenField ID="hfPaisUser" runat="server" />
                        <asp:HiddenField ID="hfOPCDCONT" runat="server" />
                        <asp:HiddenField ID="hfCodInterno" runat="server" />
                        <asp:HiddenField ID="hfTVDSESTR" runat="server" />
                        <asp:HiddenField ID="hfPRPRODES" runat="server" />
                        <asp:HiddenField ID="hfOPVLCONT" runat="server" />
                        <asp:HiddenField ID="hfPRPRODID" runat="server" />
                        <asp:HiddenField ID="hfOPIDCONT" runat="server" />
                        <asp:HiddenField ID="hfCHIDCODI" runat="server" />
                        <asp:HiddenField ID="hfCJIDCODI" runat="server" />
                        <asp:HiddenField ID="hfCJTPIDTP" runat="server" />
                        <asp:HiddenField ID="hfIndexGrid" runat="server" />
                        <asp:Button ID="btnSelEmp" runat="server" CssClass="d-none" ClientIDMode="Static" OnClick="btnSelEmp_Click" Text="Button" />
                        <div id="cardInsert">
                            <%--Painel com campos para Insert--%>
                            <div class="row card">
                                <div class="card-header pb-0 pt-0 mr-2 ml-2">
                                    <a class="card-link" data-toggle="collapse" href="#collapseInsertInfo" aria-expanded="true">
                                        <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                            <asp:Label ID="Label7" runat="server" CssClass="labels" Text="<%$ Resources:GlobalResource, aquisição_grp1_titulo1 %>"></asp:Label>
                                        </h5>
                                    </a>
                                </div>
                                <div id="collapseInsertInfo" class="collapse show" data-parent="#cardInsert">
                                    <div class="card-body pb-0 pt-1">
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblEstruturaCorporativaInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('1');">
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
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator19" ValidationGroup="InsertReq" Enabled="false" ControlToValidate="ddeEstruturaInsert" runat="server" ForeColor="Red" Display="None" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl1 %>"></asp:RequiredFieldValidator>
                                                                <dx:ASPxDropDownEdit ID="ddeEstruturaInsert" Visible="true" CssClass=" drop-down" ClientIDMode="Static" ClientInstanceName="DropDownEdit" Theme="Material"
                                                                    Width="100%" runat="server" AnimationType="Slide" AllowUserInput="false">
                                                                    <ClientSideEvents Init="UpdateSelection" DropDown="OnDropDown" />
                                                                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                        <HoverStyle BackColor="#669999"></HoverStyle>
                                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                    </ButtonStyle>
                                                                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
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
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblCodInternoInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('2');">
                                                    <asp:TextBox ID="txtCodInternoInsert" Width="100%" Enabled="false" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblNumProcessoInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl3 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqNumProcessoInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="txtNumProcessoInsert" runat="server" ForeColor="Red" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl3 %>"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('3');">
                                                    <asp:TextBox ID="txtNumProcessoInsert" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblCodAuxInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl4 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('4');">
                                                    <asp:TextBox ID="txtCodAuxInsert" CssClass="text-boxes" Width="100%" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row p-0 m-0">
                                            <div class="col-x2 p-0">
                                                <asp:Label ID="lblDescricaoInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqDescricaoInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="txtDescricaoInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl5 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('5');">
                                                    <dx:ASPxTextBox ID="txtDescricaoInsert" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                        <ValidationSettings ValidateOnLeave="true" RegularExpression-ValidationExpression="[^']*" ErrorDisplayMode="None"></ValidationSettings>
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>

                                                    </dx:ASPxTextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl12 %>" CssClass="labels text-left"></asp:Label>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('12');">
                                                    <asp:TextBox ID="txtOperadorInsert" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblDtAquisiInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl6 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqDtAquisiInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="txtDtAquisiInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl6 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('6');">
                                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" Enabled="true" TargetControlID="txtDtAquisiInsert" runat="server" ClientIDMode="Static" PopupButtonID="txtDtAquisiInsert" />
                                                    <asp:TextBox ID="txtDtAquisiInsert" AutoCompleteType="Disabled" Width="100%" ClientIDMode="Static" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblHrAquisiInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl7 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqDtAssInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="txtDtAssInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" style="margin-top: 1px" onmouseover="QuickGuide('7');">
                                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender5" Enabled="true" TargetControlID="txtDtAssInsert" runat="server" ClientIDMode="Static" PopupButtonID="txtDtAssInsert" />
                                                    <asp:TextBox ID="txtDtAssInsert" AutoCompleteType="Disabled" Width="100%" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label31" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl14 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqDtEncerraInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="txtDtEncerraInsert" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl7 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto " style="margin-top: 1px" onmouseover="QuickGuide('14');">
                                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender4" Enabled="true" TargetControlID="txtDtEncerraInsert" runat="server" ClientIDMode="Static" PopupButtonID="txtDtEncerraInsert" />
                                                    <asp:TextBox ID="txtDtEncerraInsert" AutoCompleteType="Disabled" Width="100%" ClientIDMode="Static" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblValorContInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl13 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqValorContInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="txtValorContInsert2" InitialValue="0,00" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl13 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('13');">
                                                    <dx:ASPxTextBox ID="txtValorContInsert2" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%">
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
                                            <div class="col-x1 p-0">
                                                <br />
                                                <div class="input-group mb-auto" style="margin-top: 1px">
                                                    <asp:TextBox ID="TextBox11" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblEstruturaInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl8 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqEstruturaInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropEstruturaInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl8 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('8');">
                                                    <dx:ASPxComboBox ID="dropEstruturaInsert2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropEstruturaInsert2" CssClass="drop-down" runat="server" DataSourceID="sqlEstruturaInsert"
                                                        TextField="cmtpdscm" ValueField="cmtpidcm" Theme="Material" Width="100%">
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { OnCountryChanged(s); }"></ClientSideEvents>
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlEstruturaInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select cmtpdscm, cmtpidcm from cmtpcmcl where paidpais = ? and CMTPDSCM='IRFS16' order by cmtpidcm">
                                                        <SelectParameters>
                                                            <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" DbType="Int32" Name="?"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblClasseProdutoInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl9 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqClasseProdutoInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropClasseProdutoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl9 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('9');">
                                                    <dx:ASPxComboBox ID="dropClasseProdutoInsert2" ForeColor="dimgray" AllowInputUser="false" OnCallback="dropClasseProdutoInsert2_Callback" ClientInstanceName="dropClasseProdutoInsert2" runat="server" CssClass="drop-down" DataSourceID="sqlClasseProdutosInsert"
                                                        TextField="PRTPNMOP" ValueField="PRTPIDOP" Theme="Material" Width="100%">
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { OnClasseInsertChanged(s); }"></ClientSideEvents>
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
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
                                                <asp:Label ID="lblProdutoInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl10 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqProdutoInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropProdutoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl10 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('10');">
                                                    <dx:ASPxComboBox ID="dropProdutoInsert2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropProdutoInsert2" OnCallback="dropProdutoInsert2_Callback" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlProdutoInsert" TextField="prprodes" ValueField="value">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
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
                                                <asp:Label ID="lblCarteiraInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp1_lbl11 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqCarteiraInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropCarteiraInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp1_lbl11 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('11');">
                                                    <dx:ASPxComboBox ID="dropCarteiraInsert2" ForeColor="dimgray" AllowInputUser="false" ClientInstanceName="dropCarteiraInsert2" runat="server" OnCallback="dropCarteiraInsert2_Callback" CssClass="drop-down" Theme="Material" Width="100%" TextField="CADSCTRA" ValueField="CAIDCTRA">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row card">
                                <div class="card-header pb-0 mr-2 ml-2">
                                    <a class="card-link" data-toggle="collapse" href="#collapseInsertClass">
                                        <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                            <asp:Label ID="Label8" runat="server" CssClass="labels" Text="<%$ Resources:GlobalResource, aquisição_grp2_titulo %>"></asp:Label></h5>
                                    </a>
                                </div>
                                <div class="card-body pb-0 pt-1">
                                    <div id="collapseInsertClass" class="collapse" data-parent="#cardInsert">
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblFormatoOperacaoInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp2_lbl1 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqFormatoOperacaoInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropFormatoOperacaoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp2_lbl1 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('15');">
                                                    <dx:ASPxComboBox ID="dropFormatoOperacaoInsert2" ForeColor="dimgray" ClientInstanceName="dropFormatoOperacaoInsert2" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" OnCallback="dropFormatoOperacaoInsert2_Callback" Width="100%" DataSourceID="sqlFormatoInsert" ValueField="optpfrid" TextField="optpfrds">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlFormatoInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select optpfrid, optpfrds from optpfrco
            where cmtpidcm = ?
            and paidpais = ?
            order by optpfrds">
                                                        <SelectParameters>
                                                            <asp:Parameter Name="?" DbType="Int32"></asp:Parameter>
                                                            <asp:ControlParameter ControlID="hfPaisUser" PropertyName="Value" Name="?" DbType="Int32"></asp:ControlParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label10" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp2_lbl2 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqAgenteFinanceiroInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropAgenteFinanceiroInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp2_lbl2 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto" onmouseover="QuickGuide('16');">
                                                    <dx:ASPxComboBox ID="dropAgenteFinanceiroInsert2" ClientInstanceName="dropAgenteFinanceiroInsert2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" OnCallback="dropAgenteFinanceiroInsert2_Callback" TextField="FONMFORN" ValueField="FOIDFORN">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlAgenteFinanceiro" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="SELECT FOIDFORN,FONMFORN FROM FOFORNEC FO where TVIDESTR IS NULL ORDER BY 2"></asp:SqlDataSource>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="lblTipoInsert" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp2_lbl3 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqTipoInsert2" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropTipoInsert2" runat="server" Text="*" ErrorMessage="<%$ Resources:GlobalResource, aquisição_grp2_lbl3 %>" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" style="padding-left: 2px" onmouseover="QuickGuide('17');">
                                                    <dx:ASPxComboBox ID="dropTipoInsert2" ForeColor="dimgray" ClientInstanceName="dropTipoInsert2" OnCallback="dropTipoInsert2_Callback" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%" DataSourceID="sqlTipoInsert" ValueField="optptpid" TextField="optptpds">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                    </dx:ASPxComboBox>
                                                    <asp:SqlDataSource runat="server" ID="sqlTipoInsert" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select optptpid, optptpds
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
                                                    <asp:TextBox ID="TextBox7" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row p-0 m-0">
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label42" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp2_lbl4 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqParcInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropParcInsert" runat="server" Text="*" ErrorMessage="Parcela Uniforme" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('18');">
                                                    <dx:ASPxComboBox ID="dropParcInsert" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <Items>
                                                            <dx:ListEditItem Text="Sim" Value="1" Selected="true" />
                                                            <dx:ListEditItem Text="Não" Value="0" />
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label43" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp2_lbl5 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqCareInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropCareInsert" runat="server" Text="*" ErrorMessage="Carência" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('19');">
                                                    <dx:ASPxComboBox ID="dropCareInsert" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <Items>
                                                            <dx:ListEditItem Text="Sim" Value="1" />
                                                            <dx:ListEditItem Text="Não" Value="0" Selected="true" />
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </div>
                                            </div>
                                            <div class="col-x0"></div>
                                            <div class="col-x1 p-0">
                                                <asp:Label ID="Label44" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp2_lbl6 %>" CssClass="labels text-left"></asp:Label><asp:RequiredFieldValidator ID="reqSaldoInsert" Enabled="false" ValidationGroup="InsertReq" ControlToValidate="dropSaldoInsert" runat="server" Text="*" ErrorMessage="Saldo Implantado" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('20');">
                                                    <dx:ASPxComboBox ID="dropSaldoInsert" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        </ButtonStyle>
                                                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                        <Items>
                                                            <dx:ListEditItem Text="Total" Value="1" Selected="true" />
                                                            <dx:ListEditItem Text="Parcial" Value="0" />
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
                                    </div>
                                </div>
                            </div>
                            <div class="row card">
                                <div class="card-header pb-0 mr-2 ml-2">
                                    <asp:Button ID="myLinkTagBtn" ClientIDMode="Static" ValidationGroup="InsertReq" Style="display: none" OnClick="myLinkTagBtn_Click" runat="server" Text="Button" />
                                    <a id="myLinkTag" class="card-link" data-toggle="collapse" href="#collapseInsertBases">
                                        <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                            <asp:Label ID="Label9" runat="server" CssClass="labels" Visible="true" Text="<%$ Resources:GlobalResource, aquisição_grp3_titulo %>"></asp:Label></h5>
                                    </a>
                                </div>
                                <div class="card-body pb-0 pt-1">
                                    <div id="collapseInsertBases" class="collapse" data-parent="#cardInsert">
                                        <asp:Repeater ID="rptBases" runat="server" OnItemDataBound="rptBasesInserir_ItemDataBound" OnPreRender="rptBasesInserir_PreRender">
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
                                                                    <asp:LinkButton ID="lnkRptBasesInsert" ClientIDMode="Static" runat="server" OnCommand="lnkRptBasesInsert_Command"
                                                                        CommandName='<%# string.Format("{0}#{1}#{2}#{3}", Eval("CJTPIDTP").ToString(),Eval("CJDSDECR").ToString(),Eval("COMBO").ToString(),Eval("cjtpcttx").ToString())%>'
                                                                        CommandArgument='<%# string.Format("{0}#{1}",Eval("CJIDCODI").ToString(),Eval("CHIDCODI").ToString()) %>'>
                                                <%# Eval("CJTPIDTP").ToString()=="10" ? Eval("CJVLPROP").ToString()=="0" ? Eval("CJTPCTTX").ToString() : DataBinder.Eval(Container.DataItem, "CJVLPROP", "{0:N2}") : Eval("CJTPCTTX").ToString() %>
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
                            <div class="row card">
                                <div class="card-header pb-0 mr-2 ml-2">
                                    <a class="card-link" data-toggle="collapse" href="#collapseInsertArqs">
                                        <h5><i class="fas fa-angle-down" style="margin-right: 5px"></i>
                                            <asp:Label ID="Label39" CssClass="labels" runat="server" Text="<%$ Resources:GlobalResource, aquisição_grp4_titulo %>"></asp:Label></h5>
                                    </a>
                                </div>
                                <div id="collapseInsertArqs" class="collapse" data-parent="#cardInsert">
                                    <div class="card-body pb-0 pt-1">
                                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                            <Triggers>
                                                <asp:AsyncPostBackTrigger ControlID="gridFilesInsert" />
                                                <asp:AsyncPostBackTrigger ControlID="fileInsert" />
                                            </Triggers>
                                            <ContentTemplate>
                                                <div class="row p-0">
                                                    <dx:ASPxUploadControl Visible="true" Enabled="false" ID="fileInsert" AutoStartUpload="true" runat="server" UploadMode="Advanced" Theme="Material" Width="500px"
                                                        OnFileUploadComplete="fileInsert_FileUploadComplete" BrowseButton-Text="<%$Resources:GlobalResource, aquisição_grp4_btn %>">
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
                                                            <dx:GridViewDataTextColumn FieldName="OPIDCONT" Width="30px" MaxWidth="30" EditFormSettings-Visible="False" VisibleIndex="1" Caption="<%$Resources:GlobalResource, aquisição_grp4_grid_col1 %>"></dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="FILENAME" Width="400px" MaxWidth="400" CellStyle-Wrap="False" EditFormSettings-Visible="False" VisibleIndex="2" Caption="<%$Resources:GlobalResource, aquisição_grp4_grid_col2 %>"></dx:GridViewDataTextColumn>
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
                        <dx:ASPxPopupControl ID="popupBasesAlterar" ClientInstanceName="popupBasesAlterar" ClientIDMode="Static" Width="350" Height="200" CloseAction="CloseButton" CloseOnEscape="false" Modal="true"
                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="true"
                            PopupAnimationType="None" AutoUpdatePosition="true" runat="server">
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
                                                                    <ajaxToolkit:CalendarExtender ID="CalendarExtender2" TargetControlID="txtEditarData" Enabled="true" runat="server" BehaviorID="CalendarExtender2" />
                                                                    <asp:TextBox ID="txtEditarData" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                                    <div class="input-group-append">
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnEditarData" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" OnClick="btnEditarData_Click" />
                                                            </td>
                                                            <td>
                                                                <asp:Button ID="btnEditarDataDel" CssClass="btn btn-danger" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" OnCommand="DelBasesEdit" />
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
                                                                    <dx:ASPxTextBox ID="txtEditarMoeda" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                                        <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                                        <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxTextBox>
                                                                    <div class="input-group-append">
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnEditarMoeda" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" />
                                                            </td>
                                                            <td>
                                                                <asp:Button ID="Button4" CssClass="btn btn-danger" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:View>
                                                <asp:View ID="viewInteiro" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:CustomValidator ID="CustomValidator1" EnableClientScript="false" Display="Dynamic" ControlToValidate="txtEditarInteiro" runat="server" ValidationGroup="grpInteiro" ValidateEmptyText="true" OnServerValidate="CustomValidator1_ServerValidate" ErrorMessage="CustomValidator"></asp:CustomValidator>
                                                                <asp:Label ID="lblEditarInteiro" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                                <div class="input-group mb-3">
                                                                    <dx:ASPxTextBox ID="txtEditarInteiro" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                                        <ValidationSettings CausesValidation="true" ValidationGroup="grpInteiro" ErrorDisplayMode="None"></ValidationSettings>
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxTextBox>
                                                                    <div class="input-group-append">
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnEditarInteiro" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="true" ValidationGroup="grpInteiro" />
                                                            </td>
                                                            <td>
                                                                <asp:Button ID="Button5" CssClass="btn btn-danger" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" />
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
                                                                    <dx:ASPxTextBox ID="txtEditarFlutuante" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                                        CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                                        <MaskSettings Mask="<0..9999999999g>.<00..99>" IncludeLiterals="DecimalSymbol" ShowHints="false" />
                                                                        <ValidationSettings ErrorDisplayMode="None"></ValidationSettings>
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxTextBox>
                                                                    <div class="input-group-append">
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnEditarFlutuante" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" />
                                                            </td>
                                                            <td>
                                                                <asp:Button ID="Button6" CssClass="btn btn-danger" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:View>
                                                <asp:View ID="viewFormula" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblEditarFormula" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                                <div class="input-group mb-3">
                                                                    <asp:DropDownList ID="dropEditarFormula" CssClass="text-boxes" runat="server"></asp:DropDownList>
                                                                    <div class="input-group-append">
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnEditarFormula" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" />
                                                            </td>
                                                            <td>
                                                                <asp:Button ID="Button7" CssClass="btn btn-danger" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" />
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
                                                                    <asp:TextBox ID="txtEditarIndice" CssClass="text-boxes" runat="server"></asp:TextBox>
                                                                    <div class="input-group-append">
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnEditarIndice" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" />
                                                            </td>
                                                            <td>
                                                                <asp:Button ID="Button8" CssClass="btn btn-danger" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:View>
                                                <asp:View ID="viewSql" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td colspan="2">
                                                                <asp:Label ID="lblEditarSql" Visible="false" runat="server" Text="" CssClass="labels text-left"></asp:Label>
                                                                <div class="input-group mb-3">
                                                                    <dx:ASPxComboBox ID="dropEditarSql2" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" Theme="Material" Width="100%">
                                                                        <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                                        <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                            <HoverStyle BackColor="#669999"></HoverStyle>
                                                                            <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                                        </ButtonStyle>
                                                                        <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                                        <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                                    </dx:ASPxComboBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Button ID="btnEditarSql" CssClass="btn btn-primary" runat="server" Text="<%$ Resources:GlobalResource, btn_alterar %>" CausesValidation="false" />
                                                            </td>
                                                            <td>
                                                                <asp:Button ID="Button9" CssClass="btn btn-danger" runat="server" Text="<%$ Resources:GlobalResource, btn_excluir %>" CausesValidation="false" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </asp:View>
                                                <asp:View ID="viewDeAte" runat="server">
                                                    <div class="row">
                                                        <div class="col-sm-12">
                                                            <asp:HiddenField ID="hfqueryRpt" runat="server" />
                                                            <dx:ASPxGridView ID="gridRptDeAte" Theme="Material" runat="server" KeyFieldName="ID;De;Ate;Valor" Width="100%" OnInitNewRow="gridRptDeAte_InitNewRow" OnBatchUpdate="gridRptDeAte_BatchUpdate" AutoGenerateColumns="False">
                                                                <ClientSideEvents BatchEditChangesSaving="function(s,e){ popupBasesAlterar.Hide(); }"
                                                                    EndCallback="function(s,e) { document.getElementById('Button10').click(); } " />
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
                                                                    <dx:GridViewDataDateColumn FieldName="De" Caption="<%$ Resources:GlobalResource, aquisição_grid_de %>" VisibleIndex="1">
                                                                        <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                                            <ValidationSettings Display="Dynamic">
                                                                            </ValidationSettings>
                                                                        </PropertiesDateEdit>
                                                                    </dx:GridViewDataDateColumn>
                                                                    <dx:GridViewDataDateColumn FieldName="Ate" Caption="<%$ Resources:GlobalResource, aquisição_grid_ate %>" VisibleIndex="2">
                                                                        <PropertiesDateEdit DisplayFormatInEditMode="true" DisplayFormatString="d" ValidationSettings-RequiredField-IsRequired="true">
                                                                            <ValidationSettings Display="Dynamic">
                                                                            </ValidationSettings>
                                                                        </PropertiesDateEdit>
                                                                    </dx:GridViewDataDateColumn>
                                                                    <dx:GridViewDataTextColumn FieldName="Valor" Caption="<%$ Resources:GlobalResource, aquisição_grid_valor %>" VisibleIndex="3" ShowInCustomizationForm="true">
                                                                        <PropertiesTextEdit DisplayFormatString="N2" DisplayFormatInEditMode="true">
                                                                            <ValidationSettings Display="Dynamic">
                                                                            </ValidationSettings>
                                                                        </PropertiesTextEdit>
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>
                                                                <Settings VerticalScrollableHeight="150" />
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
                                        </asp:Panel>

                                    </div>
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                        </dx:ASPxPopupControl>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>


    <script type="text/javascript">
        $(function () {
            var paneName2 = $("[id*=panelActive2]").val() != "" ? $("[id*=panelActive2]").val() : "collapseInsertInfo";
            //Remove the previous selected Pane.
            $("#cardInsert .show").removeClass("show");
            //Set the selected Pane.
            $("#" + paneName2).collapse("show");
            //When Pane is clicked, save the ID to the Hidden Field.
            $(".card-header a").click(function () {
                $("[id*=panelActive2]").val($(this).attr("href").replace("#", ""));
            });
            $("#myLinkTag").on('click', function () {
                $("#myLinkTagBtn").click();

            });
        });
        function QuickGuide(guide) {
            switch (guide) {
                case '1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl1_guide%>';
                    break;
                case '2':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl2_guide%>';
                    break;
                case '3':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl3_guide%>';
                    break;
                case '4':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl4_guide%>';
                    break;
                case '5':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl5_guide%>';
                    break;
                case '6':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl6_guide%>';
                    break;
                case '7':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl7_guide%>';
                    break;
                case '8':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl8_guide%>';
                    break;
                case '9':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl9_guide%>';
                    break;
                case '10':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl10_guide%>';
                    break;
                case '11':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl11_guide%>';
                    break;
                case '12':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl12_guide%>';
                    break;
                case '13':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl13_guide%>';
                    break;
                case '14':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp1_lbl14_guide%>';
                    break;
                case '15':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp2_lbl1_guide%>';
                    break;
                case '16':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp2_lbl2_guide%>';
                    break;
                case '17':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp2_lbl3_guide%>';
                    break;
                case '18':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp2_lbl4_guide%>';
                    break;
                case '19':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp2_lbl5_guide%>';
                    break;
                case '20':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_grp2_lbl6_guide%>';
                    break;
                case 'titulo':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.GlobalResource.aquisição_right_titulo_guide%>';
                    break;
                case 'ini':
                    document.getElementById('lblquickGuide').innerHTML = '<%=Resources.GlobalResource.quickguide_inicial %>';
                    break;
            }

        }
    </script>

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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <asp:HiddenField ID="hfUser2" runat="server" />
    <div class="container p-0">
        <div class="row card" style="margin: 0 auto">
            <div class="card-header p-0 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:GlobalResource, aquisição_tituloPag %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <asp:Button ID="btnselecionar" CausesValidation="false" ClientIDMode="Static" runat="server" CssClass="d-none" OnClick="btnselecionar_Click" Text="<%$Resources:GlobalResource, btn_selecionar %>" />
            <asp:Label ID="Label30" runat="server" Text="<%$ Resources:GlobalResource, aquisição_right_titulo %>" CssClass="labels text-left"></asp:Label>
            <div class="input-group mb-auto" onmouseover="QuickGuide('titulo');">
                <dx:ASPxDropDownEdit ID="ddePesqContrato" ClientInstanceName="ddePesqContrato" ClientIDMode="Static" Width="100%" runat="server" Theme="Material" AllowUserInput="false">
                    <ClientSideEvents CloseUp="function(s, e) {  
                                s.ShowDropDown();
                                }" />
                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
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
                                    <asp:ControlParameter ControlID="hfUser2" PropertyName="Value" Name="?"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="hfUser2" PropertyName="Value" Name="?"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>


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
        <div class="row mt-3" style="margin: 0 auto">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnInsert" CausesValidation="false" CssClass="btn-using" runat="server" OnClick="btnInsert_Click" Text="<%$ Resources:GlobalResource, btn_inserir %>" />
            </div>
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnDelete" CausesValidation="false" CssClass="btn-using" runat="server" OnClick="btnDelete_Click" Text="<%$ Resources:GlobalResource, btn_excluir %>" />

            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 2px">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnEdit" CausesValidation="false" CssClass="btn-using" runat="server" OnClick="btnEdit_Click" Text="<%$ Resources:GlobalResource, btn_alterar %>" />
            </div>
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnReplicar" CausesValidation="false" CssClass="btn-using" runat="server" OnClick="btnReplicar_Click" Text="<%$ Resources:GlobalResource, btn_replicar %>" />
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 2px">
            <div class="col-lg-6 pl-0">
                <dx:ASPxButton ID="btnHistorico" runat="server" Enabled="false" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_historico %>">
                    <ClientSideEvents Click="function(s,e){pupLog.Show();}" />
                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                </dx:ASPxButton>
                <dx:ASPxPopupControl ID="pupLog" ClientIDMode="Static" ClientInstanceName="pupLog" Width="800px" Height="200px"
                    PopupHorizontalAlign="WindowCenter" ShowHeader="true" PopupVerticalAlign="WindowCenter" runat="server" EnableViewState="false"
                    EnableHierarchyRecreation="true" CloseAction="OuterMouseClick" CssClass="rounding" ShowCloseButton="true" CloseOnEscape="false" PopupAnimationType="Fade"
                    Modal="false">
                    <HeaderContentTemplate>
                        <h5>
                            <asp:Label ID="Label1" runat="server" Text="Histórico de Alterações" CssClass="labels text-left"></asp:Label></h5>
                    </HeaderContentTemplate>
                    <ContentCollection>
                        <dx:PopupControlContentControl>
                            <dx:ASPxGridView ID="gridPopup" ClientIDMode="Static" Width="100%" runat="server" AutoGenerateColumns="False"
                                DataSourceID="sqlHistLog" Theme="Material">
                                <Settings VerticalScrollableHeight="180" VerticalScrollBarMode="Visible" VerticalScrollBarStyle="Virtual" HorizontalScrollBarMode="Visible" />
                                <SettingsPager Visible="false"></SettingsPager>
                                <SettingsBehavior AllowFocusedRow="True" />
                                <SettingsPopup>
                                    <HeaderFilter MinHeight="140px">
                                    </HeaderFilter>
                                </SettingsPopup>
                                <Columns>
                                    <dx:GridViewDataDateColumn FieldName="Data" VisibleIndex="0"></dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="CodAuxiAnt" VisibleIndex="5" Caption="Cod Auxiliar Alterado"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="CodAuxiNovo" VisibleIndex="4" Caption="Cod Auxiliar"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ValAnt" VisibleIndex="6" Caption="Valor"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="ValAtual" VisibleIndex="7" Caption="Valor Alterado"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Tipo" VisibleIndex="3" Caption="Tipo"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Carteira" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Encerramento" VisibleIndex="8"></dx:GridViewDataTextColumn>


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
                            <asp:SqlDataSource runat="server" ID="sqlHistLog" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                SelectCommand="select O.OPDTADIT Data,O.USIDUSUA Usuario,c.CADSCTRA Carteira,OP.OPTPTPDS Tipo,O.OPCDAUXI CodAuxiAnt, O.OPCDAUXA CodAuxiNovo,O.OPVLCONT ValAnt,O.OPVLCONT2 ValAtual,O.OPDTENCO Encerramento
from OPCONADI O,CACTEIRA c, OPTPTIPO OP where O.opidcont=? AND C.CAIDCTRA=O.CAIDCTRA
and OP.CMTPIDCM in (select pr.cmtpidcm from PRPRODUT pr where o.PRPRODID=pr.prprodid)
and OP.OPTPTPID = O.OPTPTPID
and op.PAIDPAIS in (1)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="ID" Name="opidcont"></asp:SessionParameter>

                                </SelectParameters>
                            </asp:SqlDataSource>
                        </dx:PopupControlContentControl>
                    </ContentCollection>

                </dx:ASPxPopupControl>
            </div>
            <div class="col-lg-6 pl-0">
                <dx:ASPxButton ID="ASPxButton2" runat="server" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_consultar %>">
                    <ClientSideEvents Click="function(s,e){ddePesqContrato.ShowDropDown();}" />
                    <DisabledStyle CssClass="btn-using"></DisabledStyle>
                </dx:ASPxButton>
            </div>
        </div>
        <div class="row" style="margin: 0 auto; margin-top: 2px">
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnOK" runat="server" CssClass="btn-using" Text="<%$ Resources:GlobalResource, btn_ok %>" Style="background-color: #FFCC66;" />
            </div>
            <div class="col-lg-6 pl-0" style="text-align: center;">
                <asp:Button ID="btnCancelar" CausesValidation="false" runat="server" CssClass="Loading btn-using" Text="<%$ Resources:GlobalResource, btn_cancelar %>" Style="background-color: #CC9999;" />
            </div>
        </div>

    </div>
</asp:Content>
