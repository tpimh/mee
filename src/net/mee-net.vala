using Mee.Collections;
using Mee.IO;

namespace Mee.Net
{
	public enum SocketOptions
	{
		Reception,
		Transmission,
		Both
	}
	
	public class Socket : GLib.Object
	{
		int socket_fd;
		
		public Socket(){
			socket_fd = Posix.socket(Posix.AF_INET,Posix.SOCK_STREAM,0);
		}
		
		public int close(SocketOptions options = Mee.Net.SocketOptions.Both){
			return Posix.shutdown(socket_fd,(int)options);
		}
		
		public void connect_address(Address address){
			Posix.connect(socket_fd,&address.server,sizeof(Posix.SockAddrIn));
		}
		
		public size_t send(string message){
			return Posix.send(socket_fd,message,message.length,0);
		}
		
		public int descriptor { get{ return socket_fd; } }
	}
	
	public class Host : GLib.Object
	{
		Posix.Host *host;
		
		public Host(string? uri = null){
			if(uri != null)
				resolve(uri);
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
	
	public class Session : Socket
	{
		public signal void data_start(int fd);
		
		public signal void abort();
		
		~Session(){ close(); }
		
		public void send_message(Message message){
			connect_address(message.address);
			send(message.raw);
			file = new File.fd(descriptor,FileMode.Read);
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
			if(message.response_headers["x-xss-protection"] != null){
				var data = file.read((int)message.response_headers.content_length);
				message.got_chunk(data);
				message.response_body.append(data);
			}else
			while(!file.eof()){
				var data = file.read(1024);
				message.got_chunk(data);
				message.response_body.append(data);				
			}
		}
		
		public File file { get; private set; }
	}
	
	public class Message {
		
		internal string raw;
		
		public signal void got_chunk(uint8[] buffer);
		public signal void got_headers(string key, string value);
		public signal void got_body();
		
		public Message.from_uri(Uri _uri, string uri_method = "GET"){
			uri = _uri;
			method = uri_method;
			request_body = new MessageBody();
			request_headers = new MessageHeaders();
		//	request_headers["Host"] = uri.domain;
			response_body = new MessageBody();
			response_headers = new MessageHeaders();
			raw = method+" "+uri.path+" HTTP/1.1\r\n";
			request_headers.foreach((key,value) => {
				raw += "%s: %s\r\n".printf((string)key,(string)value);
			});
			raw += "\r\n";
			host = new Host(uri.domain);
			address = new Address();
			address.open(host.addresses[0],uri.port);
		}
		
		public Message(string _uri, string _method = "GET")
		{
			this.from_uri(new Uri(_uri),_method);
		}
		
		public int status_code { get; set; }
		public string method { get; private set; }
		public Uri uri { get; private set; }
		public Host host { get; private set; }
		public Address address { get; private set; }
		public MessageHeaders request_headers { get; set; }
		public MessageBody request_body { get; set; }
		public MessageHeaders response_headers { get; set; }
		public MessageBody response_body { get; set; }
	}
	
	public class MessageHeaders : Dictionary<string,string>
	{
		public int64 content_length {
			get {
				return int64.parse(this["content-length"]);
			}
		}
		public string get_content_type(out Dictionary<string,string> prms){
			prms = new Dictionary<string,string>();
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
		public void append(uint8[] buffer){
			add_array(buffer);
		}
		
		public uint8[] data {
			owned get {
				return to_array();
			}
		}
	}
	
	public class Uri
	{
		public Uri(string str) throws Mee.Error
		{
			if(str.index_of("://") < 1)
				throw new Mee.Error.Type("it isn't an uri");
			uri = str;
		}
		
		public string to_filepath(){
			return GLib.Uri.unescape_string(uri.substring(uri.index_of("://")+3));
		}
		
		public static Uri? from_path(string path){
			if(path.index_of("/") != 0)
				return null;
			return new Uri("file://"+GLib.Uri.escape_string(path));
		}
		
		public string uri { get; private set; }
		public string domain {
			owned get {
				return uri.split("/")[2].substring(0,uri.split("/")[2].index_of(":"));
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
