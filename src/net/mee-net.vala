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
		
		public void open(string uri,uint16 port = 80){
			server.sin_addr.s_addr = Posix.inet_addr(uri);
			server.sin_family = Posix.AF_INET;
			server.sin_port = Posix.htons(port);
		}
	}
	
	public class Session : Socket
	{
		public void abort(){ this.close(); }
		public void send_message(Message message){
			connect_address(message.address);
			send(message.raw);
			file = File.fdopen(descriptor,"rb");
			string s = file.read_line();
			message.status_code = int.parse(s.split(" ")[1]);
			s = file.read_line();
			while(s.length > 1){
				string[] t = s.split(":");
				message.headers[t[0]] = t[1];
				s = file.read_line();
			}
			while(!file.eof()){
				var data = file.read(1024);
				message.got_chunk(data);
				message.body.append(data);
			}
		}
		
		public File file { get; private set; }
	}
	
	public class Message {
		
		internal string raw;
		
		public signal void got_chunk(uint8[] buffer);
		
		public Message(string _uri, string _method = "GET"){
			uri = _uri;
			method = _method;
			body = new MessageBody();
			headers = new MessageHeaders();
			string domain = uri.split("/")[2];
			uint16 port = -1;
			if(domain.contains(":")){
				port = (uint16)int.parse(domain.split(":")[1]);
				domain = domain.split(":")[0];
			}
			string path = uri.substring(uri.index_of(domain)+domain.length);
			if(port != -1)
				path = path.substring(0,path.index_of(":"));
			if(path[0] != '/')
				path = "/"+path;
			raw = method+" "+path+" HTTP/1.1\r\n\r\n";
			host = new Host(domain);
			address = new Address();
			print(host.addresses[0]+" "+port.to_string()+"\n");
			address.open(host.addresses[0],(port == -1) ? 80 : port);
		}
		
		public int status_code { get; set; }
		public string method { get; private set; }
		public string uri { get; private set; }
		public Host host { get; private set; }
		public Address address { get; private set; }
		public MessageHeaders headers { get; set; }
		public MessageBody body { get; set; }
	}
	
	public class MessageHeaders : Dictionary<string,string>
	{
		public int64 content_length {
			get {
				return int64.parse(this["Content-Length"]);
			}
		}
	}
	
	public class MessageBody : ArrayList<uint8>
	{
		public void append(uint8[] buffer){
			add_array(buffer);
		}
	}
}
