namespace Mee.Net
{
	public abstract class Auth : GLib.Object
	{
		public signal void authorization_requested (Message message);
		
		public abstract string name { owned get; }
	}
	
	public class AuthBasic : Auth
	{
		string raw;
		
		public AuthBasic(string user, string password){
			Object(user: user, password: password);
		}
		
		construct {
			raw = Base64.encode((user+":"+password).data);
			authorization_requested.connect (message => {
				message.request_headers["Authorization"] = "Basic "+raw;
			});
		}
		
		public string? get_password (string name){
			string b64 = raw.substring(6+raw.index_of("Basic "));
			b64 = (string)Base64.decode(b64);
			string[] array = b64.split(":");
			if(array[0] == name)
				return array[1];
			return null;
		}
		
		public string user { private get; construct; }
		public string password { private get; construct; }
		
		public override string name { owned get{ return "Basic"; } }
	}
	
	public class OAuth : Auth
	{
		construct {
			authorization_requested.connect (message => {
				message.request_headers["Authorization"] = """OAuth realm="%s", oauth_consumer_key="%s", oauth_token="%s", oauth_signature_method="%s", oauth_signature="%s", oauth_timestamp="%ld", oauth_nonce="%ld", version="%s"""".printf(
					realm,
					consumer_key,
					token,
					signature_method,
					signature,
					timestamp,
					nonce,
					version
				);
			});
		}
		
		public OAuth (string realm, string consumer_key, string token, string signature_method, string signature, long timestamp, long nonce, string version)
		{
			GLib.Object (
				realm: realm,
				consumer_key: consumer_key,
				token: token,
				signature_method: signature_method,
				signature: signature,
				timestamp: timestamp,
				nonce: nonce,
				version: version
			);
		}
		
		public string realm { private get; set construct; }
		public string consumer_key { private get; set construct; }
		public string token { private get; set construct; }
		public string signature_method { private get; set construct; }
		public string signature { private get; set construct; }
		public long timestamp { private get; set construct; }
		public long nonce { private get; set construct; }
		public string version { private get; set construct; }
		
		public override string name { owned get { return "OAuth"; } }
	}
}
