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
		
		public string? get_user_password (string name){
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
		static string get_base64_string (string str)
		{
			uint8[] data = new uint8[str.length / 2];
			for (int i = 0; i < data.length; i++)
			{
				data[i] = (uint8)Mee.try_parse_hex(str.substring (2*i,2));
			}
			return GLib.Base64.encode (data);
		}
		
		public OAuth (string consumer_key, string? realm = null, string version = "1.0")
		{
			GLib.Object (
				realm: realm,
				consumer_key: consumer_key,
				version: version
			);
			authorization_requested.connect (message => {
				message.request_headers["Authorization"] = "OAuth realm=\"%s\", oauth_consumer_key=\"%s\", oauth_nonce=\"%ld\", oauth_token=\"%s\", oauth_signature_method=\"%s\", oauth_signature=\"%s\", oauth_timestamp=\"%ld\", oauth_version=\"%s\"".printf(
					realm,
					consumer_key,
					nonce,
					token,
					signature_method,
					signature,
					timestamp,
					version
				);
			});
		}
		
		long _nonce;
		long _timestamp;
		
		public long timestamp {
			get {
				if (_timestamp > 0)
					return _timestamp;
				_timestamp = time_t ();
				return _timestamp;
			}
		}
		public long nonce {
			get {
				if (_nonce > 0)
					return _nonce;
				_nonce = (long)(new Rand ().next_int ());
				return _nonce;
			}
		}
		public string extra_data { get; set; }
		public string post_data { get; set; }
		public string realm { get; protected set construct; }
		public string uri { get; set; }
		public string consumer_key { get; protected set construct; }
		public string token { get; protected set construct; }
		public string signature_method { get; set; }
		public string signature { get; set; }
		public string version { get; protected set construct; }
		
		public override string name { owned get { return "OAuth"; } }
	}
}
