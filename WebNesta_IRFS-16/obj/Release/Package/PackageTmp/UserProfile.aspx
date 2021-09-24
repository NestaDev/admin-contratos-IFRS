<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="WebNesta_IRFS_16.UserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'user_menu':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu%>';
                    break;
                case 'user_menu1_lbl1_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu1_lbl1_guide%>';
                    break;
                case 'user_menu1_lbl2_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu1_lbl2_guide%>';
                    break;
                case 'user_menu1_lbl3_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu1_lbl3_guide%>';
                    break;
                case 'user_menu1_lbl4_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu1_lbl4_guide%>';
                    break;
                case 'user_menu1_lbl5_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu1_lbl5_guide%>';
                    break;
                case 'user_menu1_lbl6_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu1_lbl6_guide%>';
                    break;
                case 'user_menu2_lbl1_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu2_lbl1_guide%>';
                    break;
                case 'user_menu2_lbl2_guide':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.UserProfile.user_menu2_lbl2_guide%>';
                    break;
            }

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:Button ID="btnPostback" ClientIDMode="Static" CssClass="d-none" runat="server" Text="Button" />
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:UserProfile, userprofile_content_tutorial %>" />
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
                <div class="row" onmouseover="QuickGuide('user_menu')">
                    <dx:ASPxMenu ID="menuUserProfile" ClientInstanceName="ASPxMenu1" runat="server" ItemLinkMode="ContentBounds" Theme="Moderno"
                        ItemAutoWidth="true" ShowPopOutImages="True" AllowSelectItem="true" OnItemClick="menuUserProfile_ItemClick"
                        ItemStyle-SelectedStyle-BackColor="#669999" ItemStyle-SelectedStyle-ForeColor="White"
                        ItemStyle-HoverStyle-BackColor="#669999"
                        SubMenuItemStyle-SelectedStyle-BackColor="#669999">
                        <RootItemSubMenuOffset LastItemX="8" />
                        <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="true"
                            EnableCollapseToSideMenu="true" CollapseToSideMenuAtWindowInnerWidth="300"
                            EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="700" />
                        <Items>
                            <dx:MenuItem Name="0" Text="<%$Resources:UserProfile, menu1 %>">
                            </dx:MenuItem>
                            <dx:MenuItem Name="1">
                                <TextTemplate>
                                    <span class="dx-vam dxm-contentText"><%=Resources.UserProfile.menu2 %>
                                <asp:Label ID="lblNotifiesQtd" runat="server" CssClass="badge badge-danger rounded-circle" Text=""></asp:Label></span>
                                </TextTemplate>
                            </dx:MenuItem>
                        </Items>
                    </dx:ASPxMenu>
                </div>
                <div class="row">
                    <asp:MultiView ID="PanelView" runat="server">
                        <asp:View ID="pv_PerfilUsuario" runat="server">
                            <div class="container-fluid">
                                <div class="row p-0">
                                    <div class="col-lg-6 card bg-transparent">
                                        <div class="card-header bg-transparent">
                                            <h5><%=Resources.UserProfile.menu1_titulo1 %></h5>
                                        </div>
                                        <div class="card-body bg-transparent">
                                            <div class="row">
                                                <div class="col-x2 p-0" onmouseover="QuickGuide('user_menu1_lbl1_guide')">
                                                    <asp:Label ID="Label9" runat="server" Text="<%$Resources:UserProfile, menu1_lbl1 %>" CssClass="labels text-left"></asp:Label>
                                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                        <dx:ASPxTextBox ID="txtPwd" ClientInstanceName="txtPwd" ClientEnabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px" Password="True">
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            <RootStyle CssClass="margin_TextBox"></RootStyle>
                                                            <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="SenhaNova">
                                                                <RequiredField IsRequired="true" ErrorText="*" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </div>
                                                </div>
                                                <div class="col-x0"></div>
                                                <div class="col-x2 p-0">
                                                    <br />
                                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 2px">
                                                        <asp:TextBox ID="TextBox1" TextMode="Password" MaxLength="40" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="col-x0"></div>
                                            </div>
                                            <div class="row">
                                                <div class="col-x2 p-0" onmouseover="QuickGuide('user_menu1_lbl2_guide')">
                                                    <asp:Label ID="Label1" runat="server" Text="<%$Resources:UserProfile, menu1_lbl2 %>" CssClass="labels text-left"></asp:Label>
                                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                        <dx:ASPxTextBox ID="txtPwd1" ClientInstanceName="txtPwd1" ClientEnabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px" Password="True">
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            <RootStyle CssClass="margin_TextBox"></RootStyle>
                                                            <ValidationSettings Display="Dynamic" ErrorTextPosition="Bottom" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="SenhaNova">
                                                                <ErrorFrameStyle Wrap="True"></ErrorFrameStyle>
                                                                <RequiredField IsRequired="true" ErrorText="*" />
                                                                <RegularExpression ValidationExpression="^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$" ErrorText="<%$Resources:UserProfile, user_password_error %>" />
                                                            </ValidationSettings>
                                                            
                                                        </dx:ASPxTextBox>
                                                    </div>
                                                </div>
                                                <div class="col-x0"></div>
                                                <div class="col-x2 p-0" onmouseover="QuickGuide('user_menu1_lbl3_guide')">
                                                    <asp:Label ID="Label2" runat="server" Text="<%$Resources:UserProfile, menu1_lbl3 %>" CssClass="labels text-left"></asp:Label>
                                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                        <dx:ASPxTextBox ID="txtPwd2" ClientInstanceName="txtPwd2" ClientEnabled="false" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px" Password="True">
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            <RootStyle CssClass="margin_TextBox"></RootStyle>
                                                            <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="SenhaNova">
                                                                <RequiredField IsRequired="true" ErrorText="*" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </div>
                                                </div>
                                                <div class="col-x0"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-6 card bg-transparent">
                                        <div class="card-header bg-transparent">
                                            <h5><%=Resources.UserProfile.menu1_titulo2 %></h5>
                                        </div>
                                        <div class="card-body bg-transparent">
                                            <div class="row">
                                                <div class="col-x2 p-0" onmouseover="QuickGuide('user_menu1_lbl5_guide')">
                                                    <asp:Label ID="Label3" runat="server" Text="<%$Resources:UserProfile, menu1_lbl5 %>" CssClass="labels text-left"></asp:Label>
                                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                        <dx:ASPxComboBox ID="dropIdioma" ForeColor="dimgray" AllowInputUser="false" ValueType="System.String" runat="server" CssClass="drop-down" Theme="Material" Width="100%">
                                                            <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                                                            <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                                                                <HoverStyle BackColor="#669999"></HoverStyle>
                                                                <Paddings PaddingBottom="4px" PaddingTop="4px" />
                                                            </ButtonStyle>
                                                            <Items>
                                                                <dx:ListEditItem Text="pt-BR" Value="pt-BR"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="en-US" Value="en-US"></dx:ListEditItem>
                                                                <dx:ListEditItem Text="es-ES" Value="es-ES"></dx:ListEditItem>
                                                            </Items>
                                                            <Paddings PaddingBottom="3px" PaddingTop="4px" />
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
<ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="SenhaNova">
                                                                <RequiredField IsRequired="true" ErrorText="*" />
                                                            </ValidationSettings>
                                                        </dx:ASPxComboBox>
                                                    </div>
                                                </div>
                                                <div class="col-x0"></div>
                                                <div class="col-x2 p-0" onmouseover="QuickGuide('user_menu1_lbl6_guide')">
                                                    <asp:Label ID="Label4" runat="server" Text="<%$Resources:UserProfile, menu1_lbl6 %>" CssClass="labels text-left"></asp:Label>
                                                    <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                        <dx:ASPxTextBox ID="txtNumWhats" ForeColor="dimgray" CssClass="text-boxes" Theme="Material" runat="server" Width="100%"
                                                            CaptionCellStyle-Paddings-Padding="0px" Paddings-Padding="0px" MaskHintStyle-Paddings-Padding="0px" RootStyle-Paddings-Padding="0px" ValidationSettings-ErrorFrameStyle-Paddings-Padding="0px">
                                                            <MaskSettings Mask="+099 (099) <99000>-<9990>" IncludeLiterals="None" PromptChar=" " />
                                                            <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                                                            <RootStyle CssClass="margin_TextBox"></RootStyle>
                                                            <ValidationSettings Display="Dynamic" SetFocusOnError="true" CausesValidation="true" ErrorText="*" ValidationGroup="SenhaNova">
                                                                <RequiredField IsRequired="false" ErrorText="*" />
                                                            </ValidationSettings>
                                                        </dx:ASPxTextBox>
                                                    </div>
                                                </div>
                                                <div class="col-x0"></div>
                                            </div>
                                            <div class="row">
                                                <div class="col-12 pt-3">
                                                    <h5><asp:Label ID="lblSenhaValida" runat="server" CssClass="labels" Text=""></asp:Label>
                                                    <asp:CustomValidator ID="CustomValidator1" runat="server" ValidationGroup="SenhaNova" ErrorMessage="" ForeColor="Red" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                                                </h5>
                                                        </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row d-flex justify-content-center">
                                    <div class="col-2 pl-3 float-left" onmouseover="QuickGuide('user_menu1_lbl4_guide')">                                        
                                        <dx:ASPxCheckBox ID="checkSenha" Theme="MaterialCompact" Text="<%$Resources:UserProfile, menu1_lbl4 %>" TextAlign="Right" runat="server">
                                            <ClientSideEvents CheckedChanged="function(s,e)
                                                {
                                                    txtPwd.SetEnabled(s.GetChecked());
                                                    txtPwd1.SetEnabled(s.GetChecked());
                                                    txtPwd2.SetEnabled(s.GetChecked());
                                                }" />
                                        </dx:ASPxCheckBox>
                                        <asp:Label ID="lblSenhaPadrao" Visible="false" ForeColor="Red" runat="server" Text="Senha Padrão detectada, necessária alteração!"></asp:Label>
                                        <asp:Label ID="lblMsgErro" Visible="false" ForeColor="Red" runat="server" Text="Label"></asp:Label>
                                    </div>
                                    <div class="col-6"></div>
                                    <div class="col-2 float-right">
                                        <asp:Button ID="btnOKSenha" ValidationGroup="SenhaNova" runat="server" CssClass="btn-using ok" Text="OK" OnCommand="AcaoSenhaNova" CommandArgument="ok" />
                                    </div>
                                    <div class="col-2 float-right">
                                        <asp:Button ID="btnCancelarSenha" runat="server" CssClass="btn-using cancelar" Text="Cancelar" OnCommand="AcaoSenhaNova" CommandArgument="cancelar" />
                                    </div>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="pv_Notify" runat="server">
                            <div class="col-lg-6 p-0 pl-1 card bg-transparent border-1">
                                <div class="card-header p-0 bg-transparent">
                                    <%=Resources.UserProfile.menu2_titulo1 %>
                                </div>
                                <div class="card-body p-0 bg-transparent" onmouseover="QuickGuide('user_menu2_lbl1_guide')">

                                    <dx:ASPxGridView ID="gridNotifies" CssClass="bg-transparent" ClientInstanceName="gridNotifies" EnableViewState="false" ClientIDMode="Static" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                        DataSourceID="sqlNotifies" KeyFieldName="WFIDCHAT" OnCustomCallback="gridNotifies_CustomCallback" OnHtmlRowPrepared="gridNotifies_HtmlRowPrepared">

                                        <ClientSideEvents RowDblClick="function(s, e) {
	s.PerformCallback(e.visibleIndex);
                                    document.getElementById('btnPostback').click();
}"
                                            EndCallback="function(s, e) {
	s.Refresh();
}"></ClientSideEvents>

                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings VerticalScrollableHeight="330" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
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
                                            <dx:GridViewDataTextColumn FieldName="WFDTCHAT" Caption="<%$Resources:UserProfile, menu2_grid1_col1 %>" Width="100px" VisibleIndex="0">
                                                <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy HH:mm:ss"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="USNMPRUS" Caption="<%$Resources:UserProfile, menu2_grid1_col2 %>" Width="100px" ShowInCustomizationForm="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="WFBBCHAT" Caption="<%$Resources:UserProfile, menu2_grid1_col3 %>" Width="180px" ShowInCustomizationForm="True" VisibleIndex="2">
                                                <CellStyle Wrap="True"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="WFDTDATA" Caption="<%$Resources:UserProfile, menu2_grid1_col4 %>" Width="100px" VisibleIndex="3">
                                                <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy HH:mm"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>

                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <Header Font-Names="Arial" Font-Size="9pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            </Row>
                                            <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource runat="server" ID="sqlNotifies" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select WFIDCHAT,convert(datetime,WFDTCHAT) as WFDTCHAT,T.USNMPRUS,WFBBCHAT,convert(datetime,WFDTDATA) as WFDTDATA 
from WFWFCHAT W
INNER JOIN TUSUSUARI T on T.USIDUSUA=W.USIDUSUA1
WHERE USIDUSUA2=?
order by 2 desc">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                            <div class="col-lg-6 p-0 pr-1 card bg-transparent border-1">
                                <div class="card-header p-0 bg-transparent">
                                    <%=Resources.UserProfile.menu2_titulo2 %>
                                </div>
                                <div class="card-body p-0 bg-transparent" onmouseover="QuickGuide('user_menu2_lbl2_guide')">

                                    <dx:ASPxGridView ID="gridNotifies2" CssClass="bg-transparent" ClientInstanceName="gridNotifies2" EnableViewState="false" ClientIDMode="Static" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False"
                                        DataSourceID="sqlNotifies2" KeyFieldName="WFIDCHAT">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Settings VerticalScrollableHeight="330" VerticalScrollBarMode="Auto" VerticalScrollBarStyle="Virtual" ShowHeaderFilterButton="true" />
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
                                            <dx:GridViewDataTextColumn FieldName="WFDTCHAT" Caption="<%$Resources:UserProfile, menu2_grid2_col1 %>" Width="100px" VisibleIndex="0">
                                                <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy HH:mm"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="USNMPRUS" Caption="<%$Resources:UserProfile, menu2_grid2_col2 %>" Width="100px" ShowInCustomizationForm="True" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="WFBBCHAT" Caption="<%$Resources:UserProfile, menu2_grid2_col3 %>" Width="180px" ShowInCustomizationForm="True" VisibleIndex="2">
                                                <CellStyle Wrap="True"></CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="WFDTDATA" Caption="<%$Resources:UserProfile, menu2_grid2_col4 %>" Width="100px" VisibleIndex="3">
                                                <PropertiesTextEdit DisplayFormatString="dd/MM/yyyy HH:mm:ss"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <Styles>
                                            <TitlePanel HorizontalAlign="Left"></TitlePanel>
                                            <Header Font-Names="Arial" Font-Size="9pt" BackColor="#669999" ForeColor="White" Paddings-Padding="3px">
                                            </Header>
                                            <Row Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray">
                                            </Row>
                                            <AlternatingRow Font-Names="Arial" Font-Size="8pt" ForeColor="DimGray" BackColor="LightGray"></AlternatingRow>
                                            <EditForm Paddings-Padding="0px"></EditForm>
                                            <EditFormCell Paddings-Padding="0px"></EditFormCell>
                                            <Table></Table>
                                            <Cell Paddings-Padding="5px"></Cell>
                                            <CommandColumn Paddings-Padding="5px"></CommandColumn>
                                        </Styles>
                                    </dx:ASPxGridView>
                                    <asp:SqlDataSource runat="server" ID="sqlNotifies2" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select WFIDCHAT,convert(datetime,WFDTCHAT) as WFDTCHAT,T.USNMPRUS,WFBBCHAT,convert(datetime,WFDTDATA) as WFDTDATA 
from WFWFCHAT W
INNER JOIN TUSUSUARI T on T.USIDUSUA=W.USIDUSUA2
WHERE USIDUSUA1=?
order by 2 desc">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfUser" PropertyName="Value" Name="?"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </div>
                        </asp:View>
                    </asp:MultiView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
