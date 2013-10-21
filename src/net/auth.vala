namespace Mee.Net
{
	public abstract class Auth : GLib.Object
	{
		internal string raw;
		
		public abstract string get_password (string name);
		
		public abstract string scheme_name { owned get; }
	}
	
	public class AuthBasic : Auth
	{
		public AuthBasic(string user, string password){
			Object(user: user, password: password);
		}
		
		construct {
			raw = "Basic "+Base64.encode((user+":"+password).data);
		}
		
		public override string get_password (string name){
			string b64 = raw.substring(6+raw.index_of("Basic "));
			b64 = (string)Base64.decode(b64);
			string[] array = b64.split(":");
			if(array[0] == name)
				return array[1];
			return null;
		}
		
		public string user { private get; construct; }
		public string password { private get; construct; }
		
		public override string scheme_name { owned get{ return "Basic"; } }
	}
}
