using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;

namespace BasePage
{
    public class BasePage:System.Web.UI.Page
    {
        protected override void InitializeCulture()
        {
            try
            {
                CultureInfo newCulture = new CultureInfo(Session["langSession"].ToString());
                System.Threading.Thread.CurrentThread.CurrentCulture = newCulture;
                System.Threading.Thread.CurrentThread.CurrentUICulture = newCulture;
                switch (Session["langSession"].ToString())
                {
                    case "pt-BR":
                        Session["LandID"] = 1;
                        break;
                    case "en-US":
                        Session["LandID"] = 2;
                        break;
                    case "en-GB":
                        Session["LandID"] = 2;
                        break;
                    case "es-ES":
                        Session["LandID"] = 3;
                        break;
                    default:
                        Session["LandID"] = 1;
                        break;
                }
            }
            catch
            {
                CultureInfo newCulture = new CultureInfo(System.Configuration.ConfigurationManager.AppSettings["langDefault"]);
                System.Threading.Thread.CurrentThread.CurrentCulture = newCulture;
                System.Threading.Thread.CurrentThread.CurrentUICulture = newCulture;
                switch (System.Configuration.ConfigurationManager.AppSettings["langDefault"])
                {
                    case "pt-BR":
                        Session["LandID"] = 1;
                        break;
                    case "en-US":
                        Session["LandID"] = 2;
                        break;
                    case "en-GB":
                        Session["LandID"] = 2;
                        break;
                    case "es-ES":
                        Session["LandID"] = 3;
                        break;
                    default:
                        Session["LandID"] = 1;
                        break;
                }
            }
        }
    }
}