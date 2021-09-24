using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace Clock.Hocr
{
    public class hPage : HOcrClass
    {

        public IList<hParagraph> Paragraphs { get; set; }

        public string ImageFile { get; set; }
        public int ImageFrameNumber { get; set; }
        public hPage()
        {
            Paragraphs = new List<hParagraph>();

        }
        public int AverageWordCountPerLine { get; private set; }


        public IList<hLine> CombineSameRowLines()
        {
            IList<hLine> Lines = new List<hLine>();
            foreach (hParagraph p in Paragraphs)
            {
                foreach (var l in p.Lines)
                    if(Lines.Where(x=>x.Id == l.Id).Count() == 0)
                        Lines.Add(l);
            }
           
            IList<hLine> Results = new List<hLine>();

            var sortedLines = Lines.OrderBy(x => x.BBox.Top);
            foreach (var l in sortedLines)
            {
                l.CleanText();

                var LinesOnThisLine = 
                    Lines.Where(x=>Math.Abs(x.BBox.DefaultPointBBox.Top - l.BBox.DefaultPointBBox.Top) <= 2).OrderBy(x => x.BBox.Left).Distinct().ToList<hLine>();

                if(LinesOnThisLine.Select(x=>x.Id.Trim()).Distinct().Count() > 1)
                l.LinesInSameSentence = LinesOnThisLine;
           
                hLine c = l.CombineLinesInSentence();

                if(Results.Where(x=>x.Id == c.Id).Count() == 0)
                    Results.Add(c);
             
            }

            AverageWordCountPerLine = Convert.ToInt32(Math.Ceiling(Results.Select(x => x.Words.Count).Average()));
        //   return sortedLines.ToList<hLine>();
            return Results.OrderBy(x => x.BBox.Top).Distinct().ToList<hLine>();
        }

    }
}
