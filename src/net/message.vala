namespace Mee.Net
{
	public delegate void HeadersFunc(string key, string value);
	
	public class MessageHeaders : GLib.Object
	{
		Gee.HashMap<string,string> map;
		
		construct {
			map = new Gee.HashMap<string,string> ();
		}
		
		public void foreach (HeadersFunc func){
			foreach(Gee.Map.Entry<string,string> entry in map.entries)
				func (entry.key,entry.value);
		}
		
		public void set (string key, string? value){
			value_changed (key,value);
			map[key] = value;
		}
		
		public string? get (string key){
			string val = null;
			this.foreach ((k,v) => {
				if (k.down() == key.down ())
					val = v;
			});
			return val;
		}
		
		public string get_content_type(out HashTable<string,string> prms = null){
			prms = new HashTable<string,string>(str_hash, str_equal);
			var s = this["content-type"];
			if(s == null)
				return s;
			var val = s.substring(0,s.index_of(";"));
			s = s.substring(1+s.index_of(";")).chug();
			while(s.length > 0){
				string k = s.substring(0,s.index_of("="));
				string v = s.substring(1+s.index_of("="));
				v = v.substring(0,v.index_of(";"));
				prms[k] = v;
				s = s.substring(1+s.index_of(";")).chug();
			}
			return val;
		}
		
		public signal void value_changed(string key, string value);
	}
	
	public class MessageBody : GLib.Object
	{
		Gee.ArrayList<uint8> list;
		
		construct {
			list = new Gee.ArrayList<uint8>();
		}
		
		public void append (uint8[] data){
			got_data (data);
			list.add_all_array (data);
		}
		
		public uint8[] data {
			owned get {
				return list.to_array ();
			}
			set {
				list.clear ();
				append (value);
			}
		}
		
		public signal void got_data(uint8[] data);
	}
	
	public class Message : GLib.Object
	{
		internal string http_version;
		
		construct {
			http_version = "HTTP/1.1";
			request_body = new MessageBody();
			request_headers = new MessageHeaders();
			response_body = new MessageBody();
			response_headers = new MessageHeaders();
		}
		
		public Message.empty (string method = "GET"){
			Object(method: method);
		}
		
		public Message (string uri, string method = "GET"){
			Object(uri: new Uri(uri), method: method);
		}
		public Message.from_uri (Uri uri, string method = "GET"){
			Object(uri: uri, method: method);
		}
		
		public string method { get; construct; }
		public Uri uri { get; set construct; }
		public int status_code { get; set; }
		public Auth authentication { get; set; }
		public MessageHeaders request_headers { get; private set; }
		public MessageBody request_body { get; private set; }
		public MessageHeaders response_headers { get; private set; }
		public MessageBody response_body { get; private set; }
		
		public signal void got_body ();
		public signal void got_chunk (uint8[] data);
		public signal void got_extra_data (uint8[] data);
		public signal void got_headers (string key, string value);
	}
}
