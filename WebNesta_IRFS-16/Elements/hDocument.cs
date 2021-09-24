using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Clock.Util;

namespace Clock.Hocr
{
    public class hDocument : HOcrClass
    {
        public IList<hPage> Pages { get; set; }

        public hDocument()
        {
            Pages = new List<hPage>();
    
        }

        public void AddFile(string hocr_file)
        {
            Parser.ParseHOCR(this, hocr_file, true);

            //File.Delete(hocr_file);

        }
    }
}
