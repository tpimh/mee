using Gee;
using Mee.IO;

namespace Mee.Net
{
	public static uint8[] download_data (string uri){
		var message = new Message(uri);
		var session = new Session();
		session.send_message (message);
		return message.response_body.data;
	}
	public static void download_file (string uri, string path){
		Mee.IO.File.write_all_bytes (path, download_data (uri));
	}
	public static string download_string (string uri){
		return (string)download_data (uri);
	}
	
	public enum SocketOptions
	{
		Reception,
		Transmission,
		Both
	}
	
	public class Socket : GLib.Object
	{
		public Socket(){
			Object(descriptor: Posix.socket(Posix.AF_INET,Posix.SOCK_STREAM,0));
		}
		public int accept(out Address address){
			address = new Address();
			size_t s = sizeof(Posix.SockAddrIn);
			return Posix.accept(descriptor,&address.server,&s);
		}
		
		public int close(SocketOptions options = Mee.Net.SocketOptions.Both){
			return Posix.shutdown(descriptor,(int)options);
		}
		
		public void connect_address(Address address){
			Posix.connect(descriptor,&address.server,sizeof(Posix.SockAddrIn));
		}
		
		public int bind(Address address){
			return Posix.bind(descriptor,&address.server,sizeof(Posix.SockAddrIn));
		}
		
		public int listen(int log = 0){
			return Posix.listen(descriptor,log);
		}
		
		public size_t send(string message){
			return Posix.send(descriptor,message,message.length,0);
		}
		
		public int descriptor { get; construct; }
	}
	
	public class Host : GLib.Object
	{
		Posix.Host *host;
		
		public Host(string? uri = null){
			Object (uri: uri);
		}
		
		construct {
			if(uri != null)
			resolve (uri);
		}
		
		public void resolve(string uri){
			host = Posix.Host.by_name(uri);
			var list = new ArrayList<string>();
			for(var i = 0; host->h_addr_list[i] != null; i++)
				list.add(Posix.inet_ntoa(*host->h_addr_list[i]));
			addresses = list.to_array();		
		}
		
		public string name {
			owned get {
				return host->h_name;
			}
		}
		public int address_type { get { return host->h_addrtype; } }
		public string[] addresses { get; private set; }
		public string[] aliases { get { return host->h_aliases; } }
		public string uri { get; construct; }
	}
	
	public class Address : GLib.Object
	{
		internal Posix.SockAddrIn server;
		
		public Address(){
			server = Posix.SockAddrIn();
		}
		
		public void open_uri(Uri uri){
			var host = new Host(uri.domain);
			server.sin_addr.s_addr = Posix.inet_addr(host.addresses[0]);
			server.sin_family = Posix.AF_INET;
			server.sin_port = Posix.htons(uri.port);			
		}
		
		public void open(string uri,uint16 port = 80){
			server.sin_addr.s_addr = Posix.inet_addr(uri);
			server.sin_family = Posix.AF_INET;
			server.sin_port = Posix.htons(port);
		}
	}
	
	public class ServerAddress : Address
	{
		public ServerAddress(uint16 port = 80){
			base();
			server.sin_addr.s_addr = 0;
			server.sin_family = Posix.AF_INET;
			server.sin_port = Posix.htons(port);
		}
	}
	
	public delegate void HandlerFunc(Message message);
	
	public class Server : Socket
	{
		HashMap<string, Handler*> handlers;
		
		struct Handler
		{
			HandlerFunc func;
		}
		
		public Server(uint16 port = 80){
			base();
			handlers = new HashMap<string, Handler*>();
			bind(new ServerAddress(port));
			listen(5);
		}
		
		public void add_handler(string path, HandlerFunc func){
			Handler *h = malloc(sizeof(Handler));
			h->func = func;
			handlers[path] = h;
		}
		
		public void run(){
			while(true){
				Address addr;
				int fd = accept(out addr);
				Posix.pid_t pid = Posix.fork();
				if(pid == 0){
					var file = new FdStream(fd,FileMode.Read);
					string s = file.read_line();
					var path = s.split(" ")[1];
					Message message = new Message.empty();
					message.method = s.split(" ")[0];
					s = file.read_line();
					while(s.length > 1){
						string key = s.substring(0,s.index_of(": "));
						string val = s.substring(2+s.index_of(": "));
						message.request_headers[key] = val;
						s = file.read_line();
					}
					if(handlers[path] != null){
						Posix.write(fd,"HTTP/1.1 200 OK\r\n".data,"HTTP/1.1 200 OK\r\n".data.length);
						Handler *h = handlers[path];
						message.status_code = 200;
						message.response_headers.value_changed.connect((k,v)=>{
							s = "%s: %s\r\n\r\n".printf(k,v);
							Posix.write(fd,s.data,s.data.length);
						});
						message.response_body.got_data.connect(data => {
							Posix.write(fd, data, data.length);
						});
						h->func(message);
					}
				}else{
					Posix.close(fd);
				}
			}
		}
	}
	
	public class Session : Socket
	{
		public signal void data_start(int fd);
		
		public void abort(){ aborted = true; }
		
		~Session(){ close(); }
		
		int br = 0;
		int mi = 0;
		int btr = 128;
		
		public void send_message(Message message){
			connect_address(message.address);
			if(message.authentication != null)
				message.request_headers["Authorization"] = message.authentication.raw;
			else if(message.uri.authentication != null)
				message.request_headers["Authorization"] = message.uri.authentication.raw;
			message.request_headers.foreach((key,value) => {
				message.raw += "%s: %s\r\n".printf(key,value);
			});
				message.raw += "\r\n";
			send(message.raw);
			file = new FdStream(descriptor,FileMode.Read);
			string s = file.read_line();
			message.status_code = int.parse(s.split(" ")[1]);
			s = file.read_line();
			while(s.length > 1){
				string k = s.substring(0,s.index_of(":")).down();
				string v = s.substring(1+s.index_of(":")).chug();
				message.got_headers(k,v);
				message.response_headers[k] = v;
				s = file.read_line();
			}
			message.got_body();
			if(message.response_headers["icy-metaint"] != null){
				mi = int.parse(message.response_headers["icy-metaint"]);
			}
			if(message.response_headers["x-xss-protection"] != null){
				var data = file.read((int)message.response_headers.content_length);
				message.got_chunk(data);
				message.response_body.append(data);
			}else
			while(!file.eof){
				uint8[] data;
				if(mi > 0){
					int btm = mi - br;
					if(btm == 0){
						int ts = (int)(file.read(1)[0]*16);
						message.got_extra_data(file.read(ts));
					}
				}
				data = file.read(btr);
				br += btr;
				message.got_chunk(data);
				message.response_body.append(data);	
				if(aborted)break;			
			}
		}
		
		public Stream file { get; private set; }
		public bool aborted { get; private set; }
	}
	
	public class Message : GLib.Object
	{
		
		internal string raw;
		
		public signal void got_chunk(uint8[] buffer);
		public signal void got_extra_data(uint8[] buffer);
		public signal void got_headers(string key, string value);
		public signal void got_body();
		
		public Message.empty(){
			request_body = new MessageBody();
			request_headers = new MessageHeaders();
			response_body = new MessageBody();
			response_headers = new MessageHeaders();
			address = new Address();
		}
		
		public Message.from_ip(string ip, uint16 port = 80, HttpVersion version = HttpVersion.V11, string uri_method = "GET"){
			method = uri_method;
			address.open(ip,port);
			http_version = version;
		}
		
		public Message.from_uri(Uri _uri, HttpVersion version = HttpVersion.V11, string uri_method = "GET"){
			this.empty();
			uri = _uri;
			method = uri_method;
			raw = method+" "+uri.path+" "+version.to_string()+"\r\n";
			host = new Host(uri.domain);
			address.open(host.addresses[0],uri.port);
		}
		
		public Message(string _uri, HttpVersion version = HttpVersion.V11, string uri_method = "GET")
		{
			this.from_uri(new Uri(_uri), version, uri_method);
		}
		
		public void set_response(string content_type, uint8[] data){
			response_headers["Content-Type"] = content_type;
			response_body.clear();
			response_body.append(data);
		}
		
		public HttpVersion http_version { get; set; }
		public int status_code { get; set; }
		public Auth authentication { get; set; }
		public string method { get; set; }
		public Uri uri { get; private set; }
		public Host host { get; private set; }
		public Address address { get; private set; }
		public MessageHeaders request_headers { get; set; }
		public MessageBody request_body { get; set; }
		public MessageHeaders response_headers { get; set; }
		public MessageBody response_body { get; set; }
	}
	
	public enum HttpVersion
	{
		V10,
		V11;
		
		public string to_string (){
			string[] array = new string[]{"HTTP/1.0","HTTP/1.1"};
			return array[(int)this];
		}
	}
	
	public delegate void HeadersFunc(string key, string value);
	
	public class MessageHeaders : HashMap<string,string>
	{
		public signal void value_changed(string key, string value);
		
		public void foreach(HeadersFunc func){
			for(var i = 0; i < size; i++)
				func(keys.to_array()[i],values.to_array()[i]);
		}
		
		public void set(string key, string value){
			value_changed(key,value);
			base.set(key,value);
		}
		
		public int64 content_length {
			get {
				return int64.parse(this["content-length"]);
			}
		}
		public string get_content_type(out HashMap<string,string> prms){
			prms = new HashMap<string,string>();
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
	}
	
	public class MessageBody : ArrayList<uint8>
	{
		public signal void got_data(uint8[] data);
		
		public void append(uint8[] buffer){
			int i = 0;
			for(i = 0; i < buffer.length-8; i+=8){
				var data = new uint8[]{buffer[i],buffer[i+1],buffer[i+2],buffer[i+3],
									buffer[i+4],buffer[i+5],buffer[i+6],buffer[i+7]};
				got_data(data);
				add_all_array(data);
			}
			for(var j = i; j < buffer.length; j++){
				var data = new uint8[]{buffer[j]};
				got_data(data);
				add_all_array(data);
			}
		}
		
		public uint8[] data {
			owned get {
				return to_array();
			}
			set {
				clear ();
				add_all_array (value);
			}
		}
	}
	
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
	
	public class Uri
	{
		public Uri(string str) throws Mee.Error
		{
			if(str.index_of("://") < 1)
				throw new Mee.Error.Type("it isn't an uri");
			uri = str;
			string d = uri.split("/")[2];
			if(d.contains("@")){
				string s = d.substring(0,d.index_of("@"));
				if(!s.contains(":"))
					throw new Mee.Error.Type("it isn't an uri");
				authentication = new AuthBasic(s.split(":")[0],s.split(":")[1]);
				s = uri.substring(0,uri.index_of(domain));
				uri = s+uri.substring(uri.index_of("@")+1);
			}
		}
		
		public string to_filepath(){
			return GLib.Uri.unescape_string(uri.substring(uri.index_of("://")+3));
		}
		
		public static Uri? from_path(string path){
			if(path.index_of("/") != 0)
				return null;
			return new Uri("file://"+GLib.Uri.escape_string(path));
		}
		
		public Auth authentication { get; private set; }
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
