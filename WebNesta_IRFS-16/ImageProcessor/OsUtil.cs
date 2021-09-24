using System;

namespace Clock.ImageProcessing
{
	public class OsUtil
	{

		protected static bool IsLinux
		{
			get
			{
				int p = (int) Environment.OSVersion.Platform;
				return (p == 4) || (p == 6) || (p == 128);
			}
		}

		public OsUtil ()
		{
		}
	}
}

