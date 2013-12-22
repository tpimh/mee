namespace Mee.Net
{
	public class Session : GLib.Object
	{
		int br;
		int mi;
		int btr;
		bool aborted;
		
		construct {
			br = 0; mi = 0; btr = 128; aborted = false;
			abort.connect(() => { aborted = true; });
		}
		
		public signal void abort ();
		
		public void send_message (Message message){
			stream = new Mee.IO.SocketStream (message.uri.uri, Mee.IO.FileMode.ReadUpdate);
			message.request_headers["Host"] = message.uri.domain;
			if(message.authentication != null)
				message.authentication.authorization_requested (message);
			else if(message.uri.authentication != null)
				message.uri.authentication.authorization_requested (message);
			stream.write_line ("%s %s %s".printf(message.method,message.uri.path,message.http_version));
			message.request_headers.foreach ((key, value) => {
				stream.write_line ("%s: %s".printf(key,value));
			});
			stream.write_line ();
			if (message.request_body.data.length > 0){
				stream.write (message.request_body.data);
				stream.write_line ();
			}
			string s = stream.read_line();
			message.status_code = int.parse(s.split(" ")[1]);
			s = stream.read_rline();
			while(s.length > 1){
				string k = s.substring(0,s.index_of(":")).down();
				string v = s.substring(1+s.index_of(":")).chug();
				message.got_headers(k,v);
				message.response_headers[k] = v;
				s = stream.read_rline();
			}
			while (message.status_code > 299 && message.status_code < 400)
			{
				message.uri = new Mee.Net.Uri (message.response_headers["location"]);
				message.request_headers["Host"] = message.uri.domain;
				if(message.authentication != null)
					message.authentication.authorization_requested (message);
				else if(message.uri.authentication != null)
					message.uri.authentication.authorization_requested (message);
				stream = new Mee.IO.SocketStream (message.uri.uri, Mee.IO.FileMode.ReadUpdate);
				stream.write_line ("%s %s %s".printf(message.method,message.uri.path,message.http_version));
				message.request_headers.foreach ((key, value) => {
					stream.write_line ("%s: %s".printf(key,value));
				});
				stream.write_line ();
				if (message.request_body.data.length > 0){
					stream.write (message.request_body.data);
					stream.write_line ();
				}
				s = stream.read_line();
				message.status_code = int.parse(s.split(" ")[1]);
				s = stream.read_rline();
				while(s.length > 1){
					string k = s.substring(0,s.index_of(":")).down();
					string v = s.substring(1+s.index_of(":")).chug();
					message.got_headers(k,v);
					message.response_headers[k] = v;
					s = stream.read_rline();
				}
			}
			message.got_body();
			if(message.response_headers["icy-metaint"] != null){
				mi = int.parse(message.response_headers["icy-metaint"]);
			}
			if(message.response_headers["transfer-encoding"] == "chunked"){
					int64 cs = Mee.try_parse_hex (stream.read_rline ());
					int offset = 0;
					Gee.ArrayList<uint8> cdata = new Gee.ArrayList<uint8>();
					while (cs > 0){
						if (aborted)
							break;
						offset = cdata.size;
						cdata.add_all_array (stream.read ((long)cs));
						stream.read(2);
						cs = Mee.try_parse_hex (stream.read_rline ());
					}
					message.got_chunk(cdata.to_array());
					message.response_body.append (cdata.to_array());
			}
			else
			{
				while (true)
				{
					if(stream.eof || aborted)
						break;
					uint8[] data;
					if(mi > 0){
						int btm = mi - br;
						if(btm == 0){
							int ts = (int)(stream.read(1)[0]*16);
							message.got_extra_data(stream.read(ts));
						}
					}
					data = stream.read(btr);
					br += btr;
					message.got_chunk(data);
					message.response_body.append(data);	
				}
			}
		}
		
		public Mee.IO.Stream stream { get; private set; }
	}
}
