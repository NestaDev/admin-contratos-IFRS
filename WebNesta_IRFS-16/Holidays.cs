using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebNesta_IRFS_16
{
    public class Holidays
    {
        public class Rootobject
        {
            public Item[] itens { get; set; }
        }

        public class Item
        {
            public string date { get; set; }
            public string name { get; set; }
            public string link { get; set; }
            public string type { get; set; }
            public string description { get; set; }
            public string type_code { get; set; }
        }
    }
}