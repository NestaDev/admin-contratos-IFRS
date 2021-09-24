using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PdfViewer
{
    [DefaultProperty("FilePath")]
    [ToolboxData("<{0}:ShowPdf runat=server></{0}:ShowPdf>")]
    public class ShowPdf : WebControl
    {
        
#region "Declarations"

        private string mFilePath;

#endregion


        
#region "Properties"

        [Category("Source File")]
        [Browsable(true)]
        [Description("Set path to source file.")]
        [Editor(typeof(System.Web.UI.Design.UrlEditor), typeof(System.Drawing.Design.UITypeEditor))]
        public string FilePath
        {
            get
            {
                return mFilePath;
            }
            set
            {
                if (value == string.Empty)
                {
                    mFilePath = string.Empty;
                }
                else
                {
                    int tilde = -1;
                    tilde = value.IndexOf('~');
                    if (tilde != -1)
                    {
                        mFilePath = value.Substring((tilde + 2)).Trim();
                    }
                    else
                    {
                        mFilePath = value;
                    }
                }
            }
        }   // end FilePath property


#endregion


        
#region "Rendering"

        protected override void RenderContents(HtmlTextWriter writer)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("<iframe src=" + FilePath.ToString() + " ");
                sb.Append("width=" + Width.ToString() + " height=" + Height.ToString() + " ");
                sb.Append("<View PDF: <a href=" + FilePath.ToString() + "</a></p> ");
                sb.Append("</iframe>");

                writer.RenderBeginTag(HtmlTextWriterTag.Div);
                writer.Write(sb.ToString());
                writer.RenderEndTag();
            }
            catch
            {
                // with no properties set, this will render "Display PDF Control" in a
                // a box on the page
                writer.RenderBeginTag(HtmlTextWriterTag.Div);
                writer.Write("Display PDF Control");
                writer.RenderEndTag();
            }  // end try-catch
        }   // end RenderContents


        #endregion

    }   // end class
}       // end namespace