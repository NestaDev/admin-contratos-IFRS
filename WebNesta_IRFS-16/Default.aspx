<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebNesta_IRFS_16.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function funDoc() {
            if (document.getElementById('divDoc').style.display == "block") {
                document.getElementById('aBtnPlus').innerHTML = "+";
                document.getElementById('divDoc').style.display = "none";
                document.getElementById('col2').style.display = "block";
                document.getElementById('col2').classList.remove("col-lg-6");
                document.getElementById('col1').classList.remove("col-lg-12");
                document.getElementById('col1').classList.add("col-lg-6");
            }
            else if (document.getElementById('divDoc').style.display == "none") {
                document.getElementById('aBtnPlus').innerHTML = "-";
                document.getElementById('divDoc').style.display = "block";
                document.getElementById('col2').style.display = "none";
                document.getElementById('col2').classList.remove("col-lg-6");
                document.getElementById('col1').classList.remove("col-lg-6");
                document.getElementById('col1').classList.add("col-lg-12");
            }

        }

        function createCookie(name, value, days) {
            var expires;

            if (days) {
                var date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                expires = "; expires=" + date.toGMTString();
            }

            else {
                expires = "";
            }

            document.cookie = escape(name) + "=" +
                escape(value) + expires + "; path=/";
        }
    </script>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfTituloPag" Value="HomePage" runat="server" />
    <div class="row ml-0 mr-0 mt-0 w-100">
        <div class="col-sm-2">
            <div class="container-fluid">
                <div class="row mt-2">
                    <div class="col-12 text-left p-0">
                        <div class="card pr-2 pl-2 quickGuide" style="background-color: #4d9287 !important;">
                            <div class="card-header quickGuide-header border-light">
                                <label style="color: #fff !important">Quick Guide</label>
                            </div>
                            <div class="card-body p-0 pt-2 quickGuide-body" style="color: #fff !important">
                                <asp:MultiView ID="mvGuide" runat="server">
                                    <asp:View ID="v_PrimeiroAcesso" runat="server">
                                        <asp:Label ID="Label17" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto11 %>" Style="font-size: 12pt; font-weight: 100; color: #fff !important"></asp:Label>
                                        <ul style="list-style-type: none; font-size: 12pt; padding-left: 0px; margin-bottom: 11px; margin-top: 5px; margin-left: 0px; font-weight: 100;">
                                            <li>
                                                <asp:Label ID="Label19" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto21 %>" Style="color: #fff !important"></asp:Label></li>
                                            <li style="margin-top: 5px;">
                                                <asp:HyperLink ID="HyperLink1" CssClass="labels" NavigateUrl="<%$Resources:GlobalResource, inicial_guide_texto41 %>" runat="server" Style="color: #fff !important; font-size: 12pt; font-weight: 100"><%=Resources.GlobalResource.inicial_guide_texto31 %></asp:HyperLink></li>
                                        </ul>

                                    </asp:View>
                                    <asp:View ID="v_DemaisAcessos" runat="server">
                                        <asp:Label ID="Label2" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto1 %>" Style="font-size: 12pt; font-weight: 100; color: #fff !important"></asp:Label>
                                        <br />
                                        <ul style="list-style-type: none; font-size: 12pt; padding-left: 0px; margin-bottom: 30px; margin-top: 10px; margin-left: 0px; font-weight: 100; color: #fff !important">
                                            <li>
                                                <asp:Label ID="Label3" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto2 %>" Style="color: #fff !important"></asp:Label></li>
                                            <li>
                                                <asp:Label ID="Label4" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto3 %>" Style="color: #fff !important"></asp:Label></li>
                                            <li>
                                                <asp:Label ID="Label5" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto4 %>" Style="color: #fff !important"></asp:Label></li>
                                            <li>
                                                <asp:Label ID="Label6" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto5 %>" Style="color: #fff !important"></asp:Label></li>
                                            <li>
                                                <asp:Label ID="Label7" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto6 %>" Style="color: #fff !important"></asp:Label></li>
                                            <li>
                                                <asp:Label ID="Label8" CssClass="labels" runat="server" Text="<%$Resources:GlobalResource, inicial_guide_texto7 %>" Style="color: #fff !important"></asp:Label></li>
                                        </ul>
                                    </asp:View>
                                </asp:MultiView>
                            </div>
                            <div class="card-footer bg-transparent quickGuide-footer border-light">
                                <asp:HiddenField ID="hfContentPage" ClientIDMode="Static" runat="server" Value="<%$Resources:Fornecedores, fornecedor_content_tutorial %>" />
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
        <div class="col-lg-10 p-0" style="">
            <div class="container-fluid mt-3">
                <div class="row card bg-transparent p-0">
                    <div class="card-body bg-transparent p-0">
                        <div class="row m-0">
                            <div class="col-lg-8 p-0" style="word-break: normal; line-height: 25px">
                                <asp:Label ID="Label50" runat="server" Text="<%$Resources:GlobalResource, inicial_card_1_texto1 %>" CssClass="labels" Style="color: #999999; font-size: 22pt; margin-right: 5px"></asp:Label><asp:Label ID="lblUsuario" runat="server" CssClass="labels detailLabel" Style="font-size: 22pt; color: #4D9287 !important"></asp:Label><asp:Label ID="Label52" runat="server" Text="<%$Resources:GlobalResource, inicial_card_1_texto2 %>" CssClass="labels" Style="color: #999999; font-size: 22pt"></asp:Label>
                                <p style="margin-top: 8px">
                                    <asp:Label ID="Label53" runat="server" Text="<%$Resources:GlobalResource, inicial_card_1_texto3 %>" CssClass="labels" Style="color: #999999; font-size: 14pt"></asp:Label>
                                </p>
                            </div>
                            <div class="col-lg-4" style="word-break: normal; line-height: 25px; background-image: url(icons/usuarios2.png); background-size: 50px; background-position: left center; background-repeat: no-repeat; padding-left: 60px">
                                <p class="col-10 p-0 m-0 mb-1" style="line-height: 18px;">
                                    <asp:Label ID="Label40" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, login_user %>"></asp:Label>
                                    <asp:Label ID="lblUsuarioLogado" runat="server" CssClass="labels ml-1 detailLabel" Text="MASTER"></asp:Label>
                                </p>
                                <p class="col-10 p-0 m-0 mb-1" style="line-height: 18px;">
                                    <asp:Label ID="Label47" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, login_date %>"></asp:Label>
                                    <asp:Label ID="lblLogadoDesde" runat="server" CssClass="labels ml-1 detailLabel" Text="MASTER"></asp:Label>
                                </p>
                                <p class="col-10 p-0 m-0 mb-1" style="line-height: 18px;">
                                    <asp:Label ID="Label51" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, login_language %>"></asp:Label>
                                    <asp:Label ID="lblIdiomaCorrente" runat="server" CssClass="labels ml-1 detailLabel" Text="MASTER"></asp:Label>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row p-0">
                    <div class="col-8">
                        <div class="row p-0 mt-2">
                            <div id="Home1" class="card bg-transparent col-12 tutorial">
                                <div class="card-header bg-transparent p-0">
                                    <asp:Label ID="Label1" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_6_titulo %>" Style="color: #666666; font-size: 16pt"></asp:Label>
                                </div>
                                <div class="card-body bg-transparent p-0">
                                    <div class="row p-0 m-0 d-flex justify-content-center">
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label20" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_6_texto1 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblEmissElabo" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt" Text="05"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label24" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_6_texto2 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblEmissConfe" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt" Text="12"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label30" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_6_texto3 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblEmissAprov" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt" Text="06"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label32" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_6_texto4 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblEmissAssina" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt" Text="04"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label37" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_6_texto5 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblEmissCadas" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt" Text="08"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label41" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_6_texto6 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblEmissContra" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt" Text="620"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row p-0 mt-2">
                            <div class="card bg-transparent col-12">
                                <div class="card-header bg-transparent p-0">
                                    <asp:Label ID="Label34" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_2_titulo %>" Style="color: #666666; font-size: 16pt"></asp:Label>
                                </div>
                                <div id="Home2" class="card-body bg-transparent p-0 tutorial">
                                    <div class="row p-0 m-0 d-flex justify-content-center">
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label42" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_2_texto2 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblContratosAtivos" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label48" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_2_texto5 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblContratosSuspensos" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label46" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_2_texto4 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblContratosVencendo" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label44" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_2_texto3 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblContratosEncerrados" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                        </div>

                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label39" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_2_texto6 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblContratosJudiciario" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt" Text="0"></asp:Label>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <asp:Label ID="Label25" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_2_texto1 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblTotalContratos" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row p-0" style="margin-top: 11px">
                            <div id="col1" class="col-lg-12 bg-transparent p-0 card">
                                <div class="card-header bg-transparent border-bottom-0 p-0">
                                    <asp:Label ID="Label35" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_3_titulo %>" Style="color: #666666; font-size: 16pt"></asp:Label>
                                </div>
                                <div class="card-body bg-transparent p-0">
                                    <div class="row m-0 p-0" style="overflow-x: auto;">
                                        <asp:Repeater ID="rptDocumentos" OnPreRender="rptDocumentos_PreRender" OnItemDataBound="rptDocumentos_ItemDataBound" runat="server">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hfID" runat="server" Value='<%# string.Format("{0}",Eval("ID").ToString()) %>' />
                                                <div class="card text-center" style="background-color: #4d9287; width: 80px; border-radius: 0; margin-right: 15px; padding: 0px">
                                                    <div class="card-header border-bottom-0 mb-0 p-0">
                                                        <asp:Label ID="Label26" CssClass="labels" Style="font-size: 11pt; color: #fff" runat="server" Text='<%# string.Format("{0}",Eval("nome").ToString()) %>'></asp:Label>
                                                    </div>
                                                    <div class="card-body mb-0 p-0">
                                                        <asp:Label ID="Label27" runat="server" CssClass="labels" Style="font-size: 20pt; color: #fff" Text='<%# string.Format("{0}",Eval("qtd").ToString()) %>'></asp:Label>
                                                    </div>
                                                    <div class="card-footer p-1 text-left bg-transparent" style="border-top: 1px solid #fff; margin-left: 10px; margin-right: 10px;">
                                                        <dx:ASPxPopupControl ID="ASPxPopupControl1" PopupElementID="lblArrow" CssClass="popupRelatorios" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Above" runat="server"
                                                            ShowHeader="false" Width="300px" Height="70px" ScrollBars="Vertical">
                                                            <ContentCollection>
                                                                <dx:PopupControlContentControl>
                                                                    <asp:Repeater ID="innerRepeater" runat="server">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="LinkButton1" CssClass="Loading labels" OnCommand="LinkButton1_Command" CommandArgument='<%# string.Format("{0}",Eval("ID").ToString()) %>' Text='<%# string.Format("{0}",Eval("NOME").ToString()) %>' runat="server"></asp:LinkButton>
                                                                            <br />
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:ConnectionString %>' ProviderName='<%$ ConnectionStrings:ConnectionString.ProviderName %>' 
SelectCommand="SELECT Q.QUENMPVT NOME, Q.QUEIDPVT ID FROM QUERYPVT Q, TPTPVIEW T WHERE Q.QUETPPVT=T.TPIDVIEW AND T.PAIDPAIS=? AND Q.USIDUSUA in (select USIDUSUA from VIFSFUSU WHERE TVIDESTR=?) AND T.TPIDVIEW=? order by 1">
                                                                        <SelectParameters>
                                                                                <asp:SessionParameter Name="?" SessionField="LandID" DefaultValue="1" />
                                                                            <asp:SessionParameter SessionField="TVIDESTR_grupo" Name="?" Type="String"></asp:SessionParameter>
                                                                            <asp:ControlParameter ControlID="hfID" PropertyName="Value" Name="?" Type="Int32"></asp:ControlParameter>
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>
                                                                </dx:PopupControlContentControl>
                                                            </ContentCollection>
                                                        </dx:ASPxPopupControl>
                                                        <asp:Label ID="lblArrow" CssClass="labels" Style="font-size: 13pt !important; color: #fff !important; margin-left: 10px; cursor: pointer;" runat="server" Text=">"></asp:Label>
                                                    </div>
                                                </div>
                                                <asp:Literal ID="ltrbr" runat="server"></asp:Literal>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:Literal ID="ltrfooter" runat="server"></asp:Literal>
                                                <div>
                                                    <div style="margin: 30px 0px 0px 0px;">
                                                        <a id="aBtnPlus" class="labels btn" onclick="funDoc(); return false;" style="font-size: 20pt !important; color: #fff !important; background-color: #4d9287; border-radius: 0px; height: 50px; width: 50px; line-height: 35px; cursor: pointer">+</a>
                                                    </div>
                                                </div>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                            <div id="col2" class="col-lg-5 d-none bg-transparent p-0 card">
                                <div class="card-header bg-transparent border-bottom-0 p-0">
                                    <asp:Label ID="Label36" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_4_titulo %>" Style="color: #666666; font-size: 16pt"></asp:Label>
                                </div>
                                <div class="card-body bg-transparent p-0">
                                    <div class="row m-0 p-0">
                                        <div class="card text-center" style="background-color: #666699; width: 80px; border-radius: 0; margin-right: 15px; padding: 0px">

                                            <div class="card-header border-bottom-0 mb-0 p-0">
                                                <asp:Label ID="Label9" CssClass="labels" Style="font-size: 11pt; color: #fff" runat="server" Text="Contábeis"></asp:Label>
                                            </div>
                                            <div class="card-body mb-0 p-0">
                                                <asp:Label ID="Label14" runat="server" CssClass="labels" Style="font-size: 20pt; color: #fff" Text="2"></asp:Label>
                                            </div>
                                            <div class="card-footer p-1 text-left" style="border-top: 1px solid #fff; margin-left: 10px; margin-right: 10px; background-color: #666699">
                                                <asp:Label ID="lblArrow2" CssClass="labels" Style="font-size: 13pt !important; color: #fff !important; margin-left: 10px; cursor: pointer;" runat="server" Text=">"></asp:Label>
                                            </div>
                                            <dx:ASPxPopupControl ID="ASPxPopupControl1" PopupElementID="lblArrow2" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Above" runat="server"
                                                ShowHeader="false" Width="350px">
                                                <ContentCollection>
                                                    <dx:PopupControlContentControl>
                                                        <div class="text-left">
                                                            <asp:LinkButton ID="LinkButton1" Enabled="false" CssClass="Loading labels" Text="Integração ERP" runat="server"></asp:LinkButton>
                                                            <br />
                                                            <asp:LinkButton ID="LinkButton2" Enabled="false" CssClass="Loading labels" Text="Contabilidade US$/FASB" runat="server"></asp:LinkButton>
                                                        </div>
                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>
                                        </div>
                                        <div class="card text-center" style="background-color: #666699; width: 80px; border-radius: 0; margin-right: 15px; padding: 0px">
                                            <div class="card-header border-bottom-0 mb-0 p-0">
                                                <asp:Label ID="Label15" CssClass="labels" Style="font-size: 11pt; color: #fff" runat="server" Text="Orçamento"></asp:Label>
                                            </div>
                                            <div class="card-body mb-0 p-0">
                                                <asp:Label ID="Label16" runat="server" CssClass="labels" Style="font-size: 20pt; color: #fff" Text="1"></asp:Label>
                                            </div>
                                            <div class="card-footer p-1 text-left" style="border-top: 1px solid #fff; margin-left: 10px; margin-right: 10px; background-color: #666699">
                                                <asp:Label ID="Label18" CssClass="labels" Style="font-size: 13pt !important; color: #fff !important; margin-left: 10px; cursor: pointer;" runat="server" Text=">"></asp:Label>
                                            </div>
                                            <dx:ASPxPopupControl ID="ASPxPopupControl2" PopupElementID="Label18" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Above" runat="server"
                                                ShowHeader="false">
                                                <ContentCollection>
                                                    <dx:PopupControlContentControl>
                                                        <div class="text-left">
                                                            <asp:LinkButton ID="LinkButton3" Enabled="false" CssClass="Loading labels" Text="Orçamento Empresarial" runat="server"></asp:LinkButton>
                                                        </div>
                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>
                                        </div>
                                        <div>
                                            <div style="margin: 30px 0px 0px 0px;">
                                                <asp:LinkButton ID="LinkButton8" Enabled="false" CssClass="labels btn" Style="font-size: 20pt !important; color: #fff !important; background-color: #666699; border-radius: 0px; height: 50px; width: 50px; line-height: 35px;" runat="server">+</asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="row p-0 mt-2">
                            <div class="col-lg-5">
                                <div class="card bg-transparent border-0 ">
                                    <div class="card-header bg-transparent mb-1 p-0">
                                        <asp:Label ID="Label10" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_7_texto1 %>" Style="color: #666666; font-size: 16pt"></asp:Label>
                                    </div>
                                    <div class="card-body bg-transparent p-2 mt-2 text-center">
                                        <div class="row card bg-transparent">
                                            <div class="card-header bg-transparent p-0 border-bottom-0">
                                                <asp:Label ID="Label21" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_7_texto2 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            </div>
                                            <div class="card-body p-0 bg-transparent">
                                                <asp:Label ID="lblFechMensal" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="row card bg-transparent">
                                            <div class="card-header p-0 border-bottom-0 bg-transparent">
                                                <asp:Label ID="Label23" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_7_texto3 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            </div>
                                            <div class="card-body p-0 bg-transparent">
                                                <asp:Label ID="lblAtuaDiaria" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="row card bg-transparent">
                                            <div class="card-header p-0 border-bottom-0 bg-transparent">
                                                <asp:Label ID="Label28" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_7_texto4 %>" Style="color: #666666; font-size: 10pt"></asp:Label>
                                            </div>
                                            <div class="card-body p-0">
                                                <asp:Label ID="lblAtuaCota" runat="server" CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-5">
                                <div class="row p-0">
                                </div>
                                <div class="row p-0">
                                    <div class="card bg-transparent border-0 ">
                                        <div class="card-header bg-transparent mb-1 pb-1 p-0">
                                            <asp:Label ID="Label11" runat="server" CssClass="labels" Text="<%$Resources:GlobalResource, inicial_card_5_titulo %>" Style="color: #666666; font-size: 14pt"></asp:Label>
                                            <asp:Button ID="Button1" runat="server" CssClass="d-none" Text="Cotações" OnClick="Button1_Click" />
                                        </div>
                                        <div class="card-body bg-transparent p-2 mt-2 text-center" style="height: 300px;overflow-y: auto;overflow-x: hidden;">
                                            <asp:Repeater ID="rptIndices" runat="server">
                                                <ItemTemplate>
                                                    <div class="row card bg-transparent">
                                                        <div class="card-header p-0 border-bottom-0 bg-transparent">
                                                            <asp:Label ID="Label12" runat="server" CssClass="labels" Text='<%# string.Format("{0}",Eval("NOME").ToString()) %>' Style="color: #666666; font-size: 10pt"></asp:Label>
                                                        </div>
                                                        <div class="card-body p-0">
                                                            <asp:Label ID="Label13" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "VALOR", "{0:N4}") %>' CssClass="labels detailLabel" Style="font-weight: 500; font-size: 20pt"></asp:Label>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
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
    <asp:HiddenField ID="hfQueryID" runat="server" />
        <dx:ASPxPopupControl ID="popupParametro" ClientInstanceName="popupParametro" runat="server" Theme="Material" AllowDragging="True" CloseAction="None" ShowCloseButton="false"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="<%$ Resources:Relatorios, relatorio_popup2_titulo %>" Modal="True" Width="400px" Height="500px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-12">
                            <asp:Panel ID="pnlParametros" runat="server"></asp:Panel>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6">
                            <dx:ASPxButton ID="btnProcReport" Width="100%" AutoPostBack="true" CssClass="btn-using" ValidationGroup="ValidateProcessa" runat="server" Text="<%$ Resources:GlobalResource, btn_processar %>" OnClick="btnProcReport_Click"></dx:ASPxButton>
                        </div>
                        <div class="col-6">
                            <asp:Button ID="Button2" Width="100%" runat="server" CssClass="btn-using cancelar Loading" CausesValidation="false" Text="<%$ Resources:GlobalResource, btn_cancelar %>" OnClick="Button2_Click" />
                        </div>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="popupTermoAceite" ClientInstanceName="popupTermoAceite" runat="server" CloseAction="CloseButton" OnLoad="popupTermoAceite_Load"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Termos e Condições" Modal="true" Width="700px" Height="550px">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row p-1">
                        <div class="col-12">
                            <asp:Label ID="Label212" runat="server" Text="Publicado em: " CssClass="text-left labels font-weight-bold" Font-Size="12pt"></asp:Label>
                            <asp:Label ID="lblDataTermo" runat="server" Text="dd/MM/yyyy" CssClass="text-left labels" Font-Size="12pt"></asp:Label>
                            <asp:Panel ID="Panel1" runat="server" ScrollBars="Auto" Width="690px" Height="520px">
                                <asp:Literal ID="ltrClausu" runat="server"></asp:Literal>
                            </asp:Panel>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <dx:ASPxCheckBox ID="chkLeitura" Theme="Material" Text="Li e Aceito os termos acima." AutoPostBack="true" runat="server" OnCheckedChanged="chkLeitura_CheckedChanged"></dx:ASPxCheckBox>
                        </div>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <script type="text/javascript">
        function TextSpeech(elemento) {
            switch (elemento) {
                case 'Home1':
                    var texto = '<%= Resources.SpeechTexts.home_emissao_contratos%>';
                        callTextSpeech.PerformCallback(texto);
                        break;
                    case 'Home2':
                        var texto = '<%= Resources.SpeechTexts.home_admin_contratos%>';
                    callTextSpeech.PerformCallback(texto);
                    break;
            }
        }
    </script>
</asp:Content>
