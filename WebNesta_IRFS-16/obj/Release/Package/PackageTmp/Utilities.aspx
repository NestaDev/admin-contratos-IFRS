<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Utilities.aspx.cs" Inherits="WebNesta_IRFS_16.Utilities" %>

<%@ Register Assembly="DevExpress.Web.ASPxRichEdit.v20.1, Version=20.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxRichEdit" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <script type="text/javascript">  
        function QuickGuide(guide) {
            switch (guide) {
                case 'lbl1':
                    document.getElementById('lblquickGuide').innerHTML = '<%= Resources.Utilities.utilities_lbl1_guide%>';
                    break;
            }
        }
        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfUser" runat="server" />
    <div class="container-fluid">
        <div class="row ">
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
                                    <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Utilities, utilities_content_tutorial %>" />
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
            <div class="col-sm-10 pl-2 pr-0">
                <div class="row  m-0">
                    <div class="card  bg-transparent">
                        <div class="card-header bg-transparent p-0">
                            <h4>
                                <asp:Label ID="Label1" runat="server" onmouseover="QuickGuide('lbl1');" Text="<%$Resources:Utilities, utilities_lbl1 %>"></asp:Label></h4>
                        </div>
                        <div class="card-body bg-transparent" onmouseover="QuickGuide('lbl1');">
                            <dx:ASPxFileManager ID="fileManager" ClientInstanceName="fileManager" Theme="MaterialCompact" runat="server" Height="330px" Width="930px" OnCustomThumbnail="fileManager_CustomThumbnail" OnLoad="fileManager_Load">
                                <ClientSideEvents CustomCommand="function(s, e) {
	                                    switch(e.commandName) {
                                                                case &#39;ChangeView-Thumbnails&#39;:
                                                                    fileManager.PerformCallback(&#39;Thumbnails&#39;);
                                                                    break;
                                                                case &#39;ChangeView-Details&#39;:
                                                                    fileManager.PerformCallback(&#39;Details&#39;);
                                                                    break;
                                                                case &#39;Editar&#39;:
                                                                    DemoRichEdit.PerformCallback(fileManager.GetSelectedFile().GetFullName());
                                                                    popupRichText.Show();
                                                                    break;
                                                            }
                                    }"
                                    ToolbarUpdating="function(s, e) {
                                    if(fileManager.GetSelectedFile())
                                    {
                                        var ext = fileManager.GetSelectedFile().name.split('.')[fileManager.GetSelectedFile().name.split('.').length-1].toUpperCase();
	                                    var enabled = (ext == 'DOC' || ext == 'DOCX' || ext == 'TXT' || ext == 'RTF');
                                        fileManager.GetToolbarItemByCommandName(&#39;Editar&#39;).SetEnabled(enabled);
                                        fileManager.GetContextMenuItemByCommandName(&#39;Editar&#39;).SetEnabled(enabled);
                                    }
                                    else
                                    {
                                        fileManager.GetToolbarItemByCommandName(&#39;Editar&#39;).SetEnabled(false);
                                        fileManager.GetContextMenuItemByCommandName(&#39;Editar&#39;).SetEnabled(false);
                                    }
                                        }"></ClientSideEvents>
                                <Settings RootFolder="~/GED/Arquivos" ThumbnailFolder="~/GED/Icones"
                                    AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.doc,.docx,.pdf"
                                    InitialFolder="GED/Arquivos" EnableMultiSelect="true"  />
                                <SettingsFileList View="Details" >
                                    <DetailsViewSettings AllowColumnResize="true" AllowColumnDragDrop="true" AllowColumnSort="true" ShowHeaderFilterButton="false" />
                                </SettingsFileList>
                                <SettingsFiltering FilteredFileListView="FilterView" FilterBoxMode="Subfolders" />
                                <SettingsEditing AllowCreate="true" AllowDelete="true" AllowMove="true" AllowRename="true" AllowCopy="true" AllowDownload="true" />
                                <SettingsToolbar>
                                    <Items>
                                        <dx:FileManagerToolbarCreateButton ToolTip="Criar"></dx:FileManagerToolbarCreateButton>
                                        <dx:FileManagerToolbarRenameButton ToolTip="Renomear"></dx:FileManagerToolbarRenameButton>
                                        <dx:FileManagerToolbarMoveButton ToolTip="Mover"></dx:FileManagerToolbarMoveButton>
                                        <dx:FileManagerToolbarCopyButton ToolTip="Copiar"></dx:FileManagerToolbarCopyButton>
                                        <dx:FileManagerToolbarDeleteButton ToolTip="Excluir"></dx:FileManagerToolbarDeleteButton>
                                        <dx:FileManagerToolbarRefreshButton ToolTip="Atualizar"></dx:FileManagerToolbarRefreshButton>
                                        <dx:FileManagerToolbarDownloadButton ToolTip="Download"></dx:FileManagerToolbarDownloadButton>
                                        <dx:FileManagerToolbarCustomButton CommandName="Editar" ToolTip="Editar">
                                            <Image IconID="setup_properties_16x16" />
                                        </dx:FileManagerToolbarCustomButton>
                                    </Items>
                                </SettingsToolbar>
                                <SettingsPermissions>
                                    <AccessRules>
                                        <dx:FileManagerFolderAccessRule Path="System" Edit="Deny" />
                                        <dx:FileManagerFileAccessRule Path="System\*" Download="Deny" />
                                    </AccessRules>
                                </SettingsPermissions>
                                <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                                <SettingsUpload UseAdvancedUploadMode="true">
                                    <AdvancedModeSettings EnableMultiSelect="true" />
                                </SettingsUpload>
                                <SettingsAdaptivity Enabled="true" />
                                <SettingsContextMenu Enabled="true" >
                                    <Items>
                                        <dx:FileManagerToolbarMoveButton />
                                        <dx:FileManagerToolbarCopyButton />
                                        <dx:FileManagerToolbarRenameButton BeginGroup="true" />
                                        <dx:FileManagerToolbarDeleteButton />
                                        <dx:FileManagerToolbarRefreshButton BeginGroup="false" />
                                        <dx:FileManagerToolbarCustomButton Text="Editar" CommandName="Editar" BeginGroup="true">
                                            <Image IconID="setup_properties_16x16" />
                                        </dx:FileManagerToolbarCustomButton>
                                    </Items>
                                </SettingsContextMenu>
                            </dx:ASPxFileManager>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl ID="popupRichText" ClientInstanceName="popupRichText" runat="server" Theme="Material"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Editor de Texto" Modal="true" Width="600px" Height="550px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxRichEdit ID="DemoRichEdit" ClientInstanceName="DemoRichEdit" Theme="Material" runat="server" Width="100%" Height="700px"
                    ActiveTabIndex="1" RibbonMode="Ribbon" WorkDirectory="~\App_Data\WorkDirectory" OnCallback="DemoRichEdit_Callback">
                    <SettingsDocumentSelector FileListSettings-View="Details"></SettingsDocumentSelector>
                    <RibbonTabs>
                        <dx:RERFileTab>
                            <Groups>
                                <dx:RERFileCommonGroup>
                                    <Items>
                                        <dx:RERSaveCommand Size="Large"></dx:RERSaveCommand>
                                        <dx:RERPrintCommand Size="Large"></dx:RERPrintCommand>
                                    </Items>
                                </dx:RERFileCommonGroup>
                            </Groups>
                        </dx:RERFileTab>
                        <dx:RERHomeTab>
                            <Groups>
                                <dx:RERUndoGroup>
                                    <Items>
                                        <dx:RERUndoCommand></dx:RERUndoCommand>
                                        <dx:RERRedoCommand></dx:RERRedoCommand>
                                    </Items>
                                </dx:RERUndoGroup>
                                <dx:RERClipboardGroup>
                                    <Items>
                                        <dx:RERPasteCommand Size="Large"></dx:RERPasteCommand>
                                        <dx:RERCutCommand></dx:RERCutCommand>
                                        <dx:RERCopyCommand></dx:RERCopyCommand>
                                    </Items>
                                </dx:RERClipboardGroup>
                                <dx:RERFontGroup>
                                    <Items>
                                        <dx:RERFontNameCommand>
                                            <PropertiesComboBox ValueType="System.Object" DropDownStyle="DropDown"></PropertiesComboBox>
                                        </dx:RERFontNameCommand>
                                        <dx:RERFontSizeCommand>
                                            <PropertiesComboBox ValueType="System.Double" DropDownStyle="DropDown"></PropertiesComboBox>
                                        </dx:RERFontSizeCommand>
                                        <dx:RERIncreaseFontSizeCommand></dx:RERIncreaseFontSizeCommand>
                                        <dx:RERDecreaseFontSizeCommand></dx:RERDecreaseFontSizeCommand>
                                        <dx:RERChangeCaseCommand DropDownMode="False">
                                            <Items>
                                                <dx:RERSentenceCaseCommand></dx:RERSentenceCaseCommand>
                                                <dx:RERUpperCaseCommand></dx:RERUpperCaseCommand>
                                                <dx:RERLowerCaseCommand></dx:RERLowerCaseCommand>
                                                <dx:RERCapitalizeEachWordCommand></dx:RERCapitalizeEachWordCommand>
                                                <dx:RERToggleCaseCommand></dx:RERToggleCaseCommand>
                                            </Items>
                                        </dx:RERChangeCaseCommand>
                                        <dx:RERFontBoldCommand></dx:RERFontBoldCommand>
                                        <dx:RERFontItalicCommand></dx:RERFontItalicCommand>
                                        <dx:RERFontUnderlineCommand></dx:RERFontUnderlineCommand>
                                        <dx:RERFontStrikeoutCommand></dx:RERFontStrikeoutCommand>
                                        <dx:RERFontSuperscriptCommand></dx:RERFontSuperscriptCommand>
                                        <dx:RERFontSubscriptCommand></dx:RERFontSubscriptCommand>
                                        <dx:RERFontColorCommand EnableCustomColors="True" EnableAutomaticColorItem="True" AutomaticColorItemValue="0" Color="Black"></dx:RERFontColorCommand>
                                        <dx:RERFontBackColorCommand EnableCustomColors="True" EnableAutomaticColorItem="True" AutomaticColor="" AutomaticColorItemValue="16777215"></dx:RERFontBackColorCommand>
                                        <dx:RERClearFormattingCommand></dx:RERClearFormattingCommand>
                                    </Items>
                                </dx:RERFontGroup>
                                <dx:RERParagraphGroup>
                                    <Items>
                                        <dx:RERBulletedListCommand></dx:RERBulletedListCommand>
                                        <dx:RERNumberingListCommand></dx:RERNumberingListCommand>
                                        <dx:RERMultilevelListCommand></dx:RERMultilevelListCommand>
                                        <dx:RERDecreaseIndentCommand></dx:RERDecreaseIndentCommand>
                                        <dx:RERIncreaseIndentCommand></dx:RERIncreaseIndentCommand>
                                        <dx:RERShowWhitespaceCommand></dx:RERShowWhitespaceCommand>
                                        <dx:RERAlignLeftCommand></dx:RERAlignLeftCommand>
                                        <dx:RERAlignCenterCommand></dx:RERAlignCenterCommand>
                                        <dx:RERAlignRightCommand></dx:RERAlignRightCommand>
                                        <dx:RERAlignJustifyCommand></dx:RERAlignJustifyCommand>
                                        <dx:RERParagraphLineSpacingCommand DropDownMode="False">
                                            <Items>
                                                <dx:RERSetSingleParagraphSpacingCommand></dx:RERSetSingleParagraphSpacingCommand>
                                                <dx:RERSetSesquialteralParagraphSpacingCommand></dx:RERSetSesquialteralParagraphSpacingCommand>
                                                <dx:RERSetDoubleParagraphSpacingCommand></dx:RERSetDoubleParagraphSpacingCommand>
                                                <dx:RERAddSpacingBeforeParagraphCommand></dx:RERAddSpacingBeforeParagraphCommand>
                                                <dx:RERAddSpacingAfterParagraphCommand></dx:RERAddSpacingAfterParagraphCommand>
                                                <dx:RERRemoveSpacingBeforeParagraphCommand></dx:RERRemoveSpacingBeforeParagraphCommand>
                                                <dx:RERRemoveSpacingAfterParagraphCommand></dx:RERRemoveSpacingAfterParagraphCommand>
                                            </Items>
                                        </dx:RERParagraphLineSpacingCommand>
                                        <dx:RERParagraphBackColorCommand EnableCustomColors="True" EnableAutomaticColorItem="True" AutomaticColor="" AutomaticColorItemValue="16777215"></dx:RERParagraphBackColorCommand>
                                    </Items>
                                </dx:RERParagraphGroup>
                                <dx:RERStylesGroup>
                                    <Items>
                                        <dx:RERChangeStyleCommand MaxColumnCount="10" MinColumnCount="2" ImageWidth="60px" MaxTextWidth="65px">
                                            <PropertiesDropDownGallery RowCount="5" MinColumnCount="3"></PropertiesDropDownGallery>
                                        </dx:RERChangeStyleCommand>
                                    </Items>
                                </dx:RERStylesGroup>
                                <dx:REREditingGroup>
                                    <Items>
                                        <dx:RERFindCommand></dx:RERFindCommand>
                                        <dx:RERReplaceCommand></dx:RERReplaceCommand>
                                        <dx:RERSelectAllCommand></dx:RERSelectAllCommand>
                                    </Items>
                                </dx:REREditingGroup>
                            </Groups>
                        </dx:RERHomeTab>
                        <dx:RERInsertTab>
                            <Groups>
                                <dx:RERPagesGroup>
                                    <Items>
                                        <dx:RERInsertPageBreakCommand Size="Large"></dx:RERInsertPageBreakCommand>
                                    </Items>
                                </dx:RERPagesGroup>
                                <dx:RERTablesGroup>
                                    <Items>
                                        <dx:RERInsertTableCommand Size="Large">
                                            <Items>
                                                <dx:RERInsertTableByGridHighlightingCommand></dx:RERInsertTableByGridHighlightingCommand>
                                            </Items>
                                        </dx:RERInsertTableCommand>
                                    </Items>
                                </dx:RERTablesGroup>
                                <dx:RERIllustrationsGroup>
                                    <Items>
                                        <dx:RERInsertPictureCommand Size="Large"></dx:RERInsertPictureCommand>
                                    </Items>
                                </dx:RERIllustrationsGroup>
                                <dx:RERLinksGroup>
                                    <Items>
                                        <dx:RERShowBookmarksFormCommand Size="Large"></dx:RERShowBookmarksFormCommand>
                                        <dx:RERShowHyperlinkFormCommand Size="Large"></dx:RERShowHyperlinkFormCommand>
                                    </Items>
                                </dx:RERLinksGroup>
                                <dx:RERHeaderAndFooterGroup>
                                    <Items>
                                        <dx:REREditPageHeaderCommand Size="Large"></dx:REREditPageHeaderCommand>
                                        <dx:REREditPageFooterCommand Size="Large"></dx:REREditPageFooterCommand>
                                        <dx:RERInsertPageNumberFieldCommand Size="Large"></dx:RERInsertPageNumberFieldCommand>
                                        <dx:RERInsertPageCountFieldCommand Size="Large"></dx:RERInsertPageCountFieldCommand>
                                    </Items>
                                </dx:RERHeaderAndFooterGroup>
                                <dx:RERTextGroup>
                                    <Items>
                                        <dx:RERInsertTextBoxCommand Size="Large"></dx:RERInsertTextBoxCommand>
                                    </Items>
                                </dx:RERTextGroup>
                                <dx:RERSymbolsGroup>
                                    <Items>
                                        <dx:RERShowSymbolFormCommand Size="Large"></dx:RERShowSymbolFormCommand>
                                    </Items>
                                </dx:RERSymbolsGroup>
                            </Groups>
                        </dx:RERInsertTab>
                        <dx:RERPageLayoutTab>
                            <Groups>
                                <dx:RERPageSetupGroup>
                                    <Items>
                                        <dx:RERPageMarginsCommand DropDownMode="False" Size="Large">
                                            <Items>
                                                <dx:RERSetNormalSectionPageMarginsCommand></dx:RERSetNormalSectionPageMarginsCommand>
                                                <dx:RERSetNarrowSectionPageMarginsCommand></dx:RERSetNarrowSectionPageMarginsCommand>
                                                <dx:RERSetModerateSectionPageMarginsCommand></dx:RERSetModerateSectionPageMarginsCommand>
                                                <dx:RERSetWideSectionPageMarginsCommand></dx:RERSetWideSectionPageMarginsCommand>
                                                <dx:RERShowPageMarginsSetupFormCommand BeginGroup="True"></dx:RERShowPageMarginsSetupFormCommand>
                                            </Items>
                                        </dx:RERPageMarginsCommand>
                                        <dx:RERChangeSectionPageOrientationCommand DropDownMode="False" Size="Large">
                                            <Items>
                                                <dx:RERSetPortraitPageOrientationCommand></dx:RERSetPortraitPageOrientationCommand>
                                                <dx:RERSetLandscapePageOrientationCommand></dx:RERSetLandscapePageOrientationCommand>
                                            </Items>
                                        </dx:RERChangeSectionPageOrientationCommand>
                                        <dx:RERChangeSectionPaperKindCommand DropDownMode="False" Size="Large">
                                            <Items>
                                                <dx:RERSectionLetterPaperKind></dx:RERSectionLetterPaperKind>
                                                <dx:RERSectionLegalPaperKind></dx:RERSectionLegalPaperKind>
                                                <dx:RERSectionFolioPaperKind></dx:RERSectionFolioPaperKind>
                                                <dx:RERSectionA4PaperKind></dx:RERSectionA4PaperKind>
                                                <dx:RERSectionB5PaperKind></dx:RERSectionB5PaperKind>
                                                <dx:RERSectionExecutivePaperKind></dx:RERSectionExecutivePaperKind>
                                                <dx:RERSectionA5PaperKind></dx:RERSectionA5PaperKind>
                                                <dx:RERSectionA6PaperKind></dx:RERSectionA6PaperKind>
                                                <dx:RERShowPagePaperSetupFormCommand BeginGroup="True"></dx:RERShowPagePaperSetupFormCommand>
                                            </Items>
                                        </dx:RERChangeSectionPaperKindCommand>
                                        <dx:RERSetSectionColumnsCommand DropDownMode="False" Size="Large">
                                            <Items>
                                                <dx:RERSetSectionOneColumnCommand></dx:RERSetSectionOneColumnCommand>
                                                <dx:RERSetSectionTwoColumnsCommand></dx:RERSetSectionTwoColumnsCommand>
                                                <dx:RERSetSectionThreeColumnsCommand></dx:RERSetSectionThreeColumnsCommand>
                                                <dx:RERShowColumnsSetupFormCommand BeginGroup="True"></dx:RERShowColumnsSetupFormCommand>
                                            </Items>
                                        </dx:RERSetSectionColumnsCommand>
                                        <dx:RERInsertBreakCommand DropDownMode="False" Size="Large">
                                            <Items>
                                                <dx:RERInsertPageBreak2Command></dx:RERInsertPageBreak2Command>
                                                <dx:RERInsertColumnBreakCommand></dx:RERInsertColumnBreakCommand>
                                                <dx:RERInsertSectionBreakNextPageCommand></dx:RERInsertSectionBreakNextPageCommand>
                                                <dx:RERInsertSectionBreakEvenPageCommand></dx:RERInsertSectionBreakEvenPageCommand>
                                                <dx:RERInsertSectionBreakOddPageCommand></dx:RERInsertSectionBreakOddPageCommand>
                                            </Items>
                                        </dx:RERInsertBreakCommand>
                                    </Items>
                                </dx:RERPageSetupGroup>
                                <dx:RERBackgroundGroup>
                                    <Items>
                                        <dx:RERChangePageColorCommand EnableCustomColors="True" EnableAutomaticColorItem="True" AutomaticColor="Transparent" AutomaticColorItemValue="16777215" DropDownMode="False" Color="Transparent" Size="Large"></dx:RERChangePageColorCommand>
                                    </Items>
                                </dx:RERBackgroundGroup>
                            </Groups>
                        </dx:RERPageLayoutTab>
                    </RibbonTabs>
                </dx:ASPxRichEdit>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>
