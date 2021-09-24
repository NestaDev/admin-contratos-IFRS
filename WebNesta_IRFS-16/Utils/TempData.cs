using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Clock.Util
{
    public class TempData: IDisposable
    {
        static TempData instance;
        TempData()
        {
            TempPath = Path.GetTempPath();
          
        }

        public void CleanAll()
        {
            foreach(string d in Directory.GetDirectories(AppTempFolder))
                if(d != CurrentJobFolder)
                    Directory.Delete(d,true);
        }

        public static TempData Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new TempData();
                    instance.CreateJobFolder();
                }
                return instance;
            }
        }

        private string TempPath { get; set; }
		string jobFolder;
        public string CurrentJobFolder { 
			get {
				return jobFolder;
			}
			set{
				jobFolder = value;
			}
		}

        private string AppTempFolder
        {
            get
            {
                return Path.Combine(TempPath, "Clock.hocr");
            }
        }
        private void CreateJobFolder()
        {
            if (!Directory.Exists(AppTempFolder))
                Directory.CreateDirectory(AppTempFolder);

            jobFolder = Path.Combine(AppTempFolder, Path.GetRandomFileName());

            if (!Directory.Exists(jobFolder))
                Directory.CreateDirectory(jobFolder);

            CurrentJobFolder = jobFolder;
        }

        public string CreateTempFile(string ExtensionWithDot)
        {
            string newFile = Path.Combine(CurrentJobFolder, Path.GetRandomFileName() + ExtensionWithDot);
            return newFile;
        }


        public void Cleanup(string file)
        {
            try
            {
                if (File.Exists(file))
                    File.Delete(file);
            }
            catch (Exception) { }

        }

        public void Cleanup()
        {
            Directory.Delete(CurrentJobFolder, true);
        }


        #region IDisposable Members

        public void Dispose()
        {
            Directory.Delete(CurrentJobFolder, true);
        }

        #endregion
    }
}
