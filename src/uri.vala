namespace Mee {
	public class Uri : GLib.Object {
		public Uri (string str) {
			parameters = new HashTable<string, string>(str_hash, str_equal);
			uri = str;
			if (uri.index_of ("://") == -1) {
				path = str;
				uri = "file://" + path;
			}
			else {
				path = uri.substring (3 + uri.index_of ("://"));
				if (path.index_of (":") != -1) {
					int j = path.index_of ("/");
					int k = path.index_of ("?");
					if (k == -1 && j == -1)
						j = path.length;
					else if (k < j && k != -1 || k > j && j == -1)
						j = k;
					int i = 1 + path.index_of (":");
					port = (uint)int64.parse (path[i:j]);
				}
			}
			if ("?" in str) {
				var array = str.substring (1 + str.index_of ("?")).split ("&");
				foreach (var a in array) {
					if ("=" in a) {
						parameters[a.substring (0, a.index_of ("="))] = a.substring (1 + a.index_of ("="));
					}
				}
			}
		}
		
		public HashTable<string, string> parameters { get; private set; }
		
		public uint port { get; private set; }
		
		public string path { get; private set; }
		
		public string scheme {
			owned get {
				return uri.substring (0, uri.index_of (":"));
			}
		}
		
		public string[] segments {
			owned get {
				return path.split ("/");
			}
		}
		
		public string uri { get; private set; }
		
		public string to_string() {
			return uri;
		}
	}
}
