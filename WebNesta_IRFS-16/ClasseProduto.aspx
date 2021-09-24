<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClasseProduto.aspx.cs" Inherits="WebNesta_IRFS_16.ClasseProduto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <asp:HiddenField ID="hfOperacao" runat="server" />
    <asp:HiddenField ID="hfCMTPIDCM" runat="server" />
    <asp:HiddenField ID="hfPaisUser" runat="server" />
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
                                    <dx:ASPxButton ID="btnAjuda" runat="server" AutoPostBack="false" CssClass="btn-saiba-mais" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_readmore %>">
                                    </dx:ASPxButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-10 pl-4 pr-0">
                <div class="row w-100 m-0">
                    <div class="card w-100">
                        <div class="card-header">
                            <div class="row">
                                <div class="col-lg-12" style="margin: 0 auto">
                                    <h4>
                                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:ClasseProduto, classeproduto_tituloPag %>" CssClass="labels text-left"></asp:Label></h4>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row p-0" style="margin: 0 auto">
                                <div class="col-lg-5" style="margin: 0 auto">
                                    <div class="row">
                                        <div class="p-0 col-x2">
                                            <asp:Label ID="Label2" runat="server" CssClass="labels text-left" Text="<%$ Resources:ClasseProduto, classeproduto_lbl1 %>"></asp:Label>
                                            <div class="input-group mb-auto" style="padding-left: 2px;">
                                                <asp:TextBox ID="txtDescri" Width="100%" runat="server" CssClass="text-boxes" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                <asp:TextBox ID="TextBox1" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-x0"></div>
                                        <div class="p-0 col-x1">
                                            <br />
                                            <div class="input-group mb-auto" style="padding-left: 2px; margin-top: 1px">
                                                <asp:TextBox ID="TextBox2" CssClass="text-boxes" Width="100%" Enabled="false" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-7" style="margin: 0 auto">
                                    <dx:ASPxGridView ID="gridClasseProduto" ClientInstanceName="gridClasseProduto" ClientIDMode="Static" Width="100%" Settings-ShowTitlePanel="true" Theme="Material" runat="server" EnableRowsCache="False" AutoGenerateColumns="False" DataSourceID="sqlClasseProduto" OnBatchUpdate="gridClasseProduto_BatchUpdate" KeyFieldName="CMTPIDCM;PRTPIDOP;PAIDPAIS">
                                        <SettingsPopup>
                                            <HeaderFilter MinHeight="140px">
                                            </HeaderFilter>
                                        </SettingsPopup>
                                        <SettingsText BatchEditChangesPreviewUpdatedValues="<%$Resources:GlobalResource, btn_grid_batch_updatevalues %>" BatchEditChangesPreviewInsertedValues="<%$Resources:GlobalResource, btn_grid_batch_insertvalues %>" BatchEditChangesPreviewDeletedValues="<%$Resources:GlobalResource, btn_grid_batch_deletevalues %>" CommandBatchEditUpdate="<%$Resources:GlobalResource, btn_grid_batch_save %>" CommandBatchEditCancel="<%$Resources:GlobalResource, btn_grid_batch_cancel %>" CommandBatchEditHidePreview="<%$Resources:GlobalResource, btn_grid_batch_hide %>" CommandBatchEditPreviewChanges="<%$Resources:GlobalResource, btn_grid_batch_preview %>" />
                                        <Columns>
                                            <dx:GridViewCommandColumn Name="CommandColumn" Visible="false" ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0"></dx:GridViewCommandColumn>
                                            <dx:GridViewDataTextColumn FieldName="PRTPIDOP" EditFormSettings-Visible="False" ReadOnly="True" VisibleIndex="1" Caption="<%$ Resources:ClasseProduto, classeproduto_grid_col1 %>"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="CMTPIDCM" EditFormSettings-Visible="False" ReadOnly="True" VisibleIndex="2" Caption="<%$ Resources:ClasseProduto, classeproduto_grid_col2 %>">
                                                <PropertiesComboBox DataSourceID="sqlGridCol2" TextField="CMTPDSCM" ValueField="CMTPIDCM"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PAIDPAIS" EditFormSettings-Visible="False" ReadOnly="True" VisibleIndex="3" Caption="<%$ Resources:ClasseProduto, classeproduto_grid_col3 %>">
                                                <PropertiesComboBox DataSourceID="sqlGridCol1" TextField="PANMPAIS" ValueField="PAIDPAIS"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="PRTPNMOP" VisibleIndex="4" Caption="<%$ Resources:ClasseProduto, classeproduto_grid_col4 %>">
                                                <PropertiesTextEdit>
                                                    <ValidationSettings Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="PRFLSMPR" Caption="<%$ Resources:ClasseProduto, classeproduto_grid_col5 %>" VisibleIndex="5">
                                                <PropertiesComboBox>
                                                    <ValidationSettings Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                    <Items>
                                                        <dx:ListEditItem Selected="True" Text="N&#227;o" Value="N"></dx:ListEditItem>
                                                        <dx:ListEditItem Text="Sim" Value="S"></dx:ListEditItem>
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>

                                        </Columns>
                                        <Settings VerticalScrollableHeight="594" />
                                        <SettingsPager NumericButtonCount="20" PageSize="20">
                                        </SettingsPager>
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
                                    <asp:SqlDataSource runat="server" ID="sqlClasseProduto" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>'
                                        SelectCommand="select po.CMTPIDCM,po.PRTPIDOP,po.PAIDPAIS, po.PRTPNMOP,po.PRFLSMPR from prtpoper po, cmtpcmcl cm
                                                        where cm.cmtpidcm = ?
                                                        and cm.paidpais = ?
                                                        and po.cmtpidcm = cm.cmtpidcm
                                                        and po.paidpais = cm.paidpais
                                                        order by po.prtpnmop"
                                        UpdateCommand="update prtpoper set PRTPNMOP=?,PRFLSMPR=? where PRTPIDOP=? and CMTPIDCM=? and PAIDPAIS=?" UpdateCommandType="Text"
                                        InsertCommand="select * from prtpoper">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfCMTPIDCM" PropertyName="Value" Name="?"></asp:ControlParameter>
                                            <asp:CookieParameter CookieName="PAIDPAIS" DefaultValue="1" Name="?"></asp:CookieParameter>
                                        </SelectParameters>
                                        <UpdateParameters>
                                            <asp:Parameter Name="PRTPNMOP" Type="String" />
                                            <asp:Parameter Name="PRFLSMPR" Type="String" />
                                            <asp:Parameter Name="PRTPIDOP" Type="String" />
                                            <asp:Parameter Name="CMTPIDCM" Type="String" />
                                            <asp:Parameter Name="PAIDPAIS" Type="String" />
                                        </UpdateParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlGridCol2" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select CMTPIDCM,CMTPDSCM from cmtpcmcl where paidpais=?">
                                        <SelectParameters>
                                            <asp:CookieParameter CookieName="PAIDPAIS" DefaultValue="1" Name="?"></asp:CookieParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="sqlGridCol1" runat="server" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select PAIDPAIS,PANMPAIS from PAPAPAIS WHERE PAIDPAIS=?">
                                        <SelectParameters>
                                            <asp:CookieParameter CookieName="PAIDPAIS" DefaultValue="1" Name="?"></asp:CookieParameter>
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
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContentSide" runat="server">
    <div class="container p-0">
        <div class="row mt-3 card" style="margin: 0 auto">
            <div class="card-header p-1 text-left">
                <h5>
                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:ClasseProduto, classeproduto_right_titulo1 %>" CssClass="labels text-left"></asp:Label></h5>
            </div>
        </div>
        <div class="row mt-3" style="margin: 0 auto">
            <h6>
                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:ClasseProduto, classeproduto_right_titulo2 %>" onclick="QuickGuide('Selecione:');"></asp:Label></h6>
            <div class="input-group mb-auto drop-down-div" onmouseover="QuickGuide('Selecione:');">
                <dx:ASPxComboBox ID="dropProposito" ClientIDMode="Static" ClientInstanceName="dropProposito" ForeColor="dimgray" AllowInputUser="false" runat="server" CssClass="drop-down2" AutoPostBack="true" OnSelectedIndexChanged="dropProposito_SelectedIndexChanged" Theme="Material" Width="100%" TextField="cmtpdscm" ValueField="cmtpidcm" DataSourceID="SqlDataSource1">

                    <Border BorderColor="#669999" BorderStyle="Solid" BorderWidth="1px" />
                    <ButtonStyle Border-BorderStyle="Solid" Border-BorderWidth="0" Border-BorderColor="#669999">
                        <HoverStyle BackColor="#669999"></HoverStyle>
                        <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    </ButtonStyle>
                    <Paddings PaddingBottom="4px" PaddingTop="4px" />
                    <DisabledStyle BackColor="#E1DFDF"></DisabledStyle>
                </dx:ASPxComboBox>
                <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' SelectCommand="select cmtpdscm, cmtpidcm from cmtpcmcl where paidpais = ? order by cmtpidcm">
                    <SelectParameters>
                        <asp:CookieParameter CookieName="PAIDPAIS" DefaultValue="1" Name="?"></asp:CookieParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
        <asp:Panel ID="pnlBotoes" runat="server">
            <div class="row" style="margin: 0 auto; margin-top: 10px">
                <div class="col-lg-6 pl-0" style="text-align: center;">
                    <dx:ASPxButton ID="btnInserir" runat="server" CssClass="btn-using" AutoPostBack="false" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_inserir %>">
                        <ClientSideEvents Click="function(s, e){gridClasseProduto.AddNewRow();}" />
                        <Paddings PaddingBottom="0px" PaddingTop="0px" />
                        <Border BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px" />
                    </dx:ASPxButton>
                </div>
                <div class="col-lg-6 pl-0" style="text-align: center;">
                    <asp:Button ID="btnexcluir" OnClick="btnexcluir_Click" runat="server" CssClass="Loading btn-using" Text="<%$ Resources:GlobalResource, btn_excluir %>" />
                </div>
            </div>
            <div class="row" style="margin: 0 auto; margin-top: 2px">
                <div class="col-lg-6 pl-0" style="text-align: center;">
                    <asp:Button ID="btnOK" OnClick="btnOK_Click" Enabled="false" runat="server" CssClass="Loading btn-using ok" Text="<%$ Resources:GlobalResource, btn_ok %>" />
                </div>
                <div class="col-lg-6 pl-0" style="text-align: center;">
                    <asp:Button ID="btnCancelar" OnClick="btnCancelar_Click" Enabled="false" runat="server" CssClass="Loading btn-using cancelar" Text="<%$ Resources:GlobalResource, btn_cancelar %>" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
