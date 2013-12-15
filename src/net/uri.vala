namespace Mee.Net
{
	public class Uri : GLib.Object
	{
		public Uri(string str) throws Error
		{
			if(str.index_of("://") < 1)
				throw new Error.TYPE("it isn't an uri");
			uri = str;
			string d = uri.split("/")[2];
			if(d.contains("@")){
				string s = d.substring(0,d.index_of("@"));
				if(!s.contains(":"))
					throw new Error.TYPE("it isn't an uri");
				authentication = new AuthBasic(s.split(":")[0],s.split(":")[1]);
				s = uri.substring(0,uri.index_of(domain));
				uri = s+uri.substring(uri.index_of("@")+1);
			}
		}
		
		public string to_filepath(){
			return GLib.Uri.unescape_string(uri.substring(uri.index_of("://")+3));
		}
		
		public static Uri from_path(string path){
			return new Uri (Filename.to_uri (path));
		}
		
		public Auth authentication { get; set; }
		public string uri { get; private set; }
		public string domain {
			owned get {
				string d = uri.split("/")[2];
				if(!d.contains(":"))
					return d;
				return d.split(":")[d.split(":").length-2];
			}
		}
		public string path {
			owned get {
				string d = uri.split("/")[2];
				d = uri.substring(uri.index_of(d)+d.length);
				return (d.length == 0) ? "/" : d;
			}
		}
		public string basename {
			owned get {
				string[] a = uri.split("/");
				return a.length < 1 ? "" : a[a.length - 1];
			}
		}
		public uint16 port {
			get { 
				string d = uri.split("/")[2];
				if(!d.contains(":"))
					return 80;
				int i = int.parse(d.split(":")[1]); 
				return (i < 0) ? 0 : (uint16)i;
			}
		}	
	}
}
