namespace Mee.Net
{
	public class ServerAddress : IPV4Address
	{
		public ServerAddress(uint16 port = 80){
			base();
			addr.sin_addr.s_addr = 0;
			addr.sin_port = Posix.htons(port);
		}
	}
	
	public delegate void HandlerFunc(Message message);
	
	public class Server : Socket
	{
		Gee.HashMap<string, Handler*> handlers;
		
		struct Handler
		{
			HandlerFunc func;
		}
		
		public uint16 server_port { get; private set; }
		
		public Server(uint16 port = 80){
			server_port = port;
			Object(address_family: AddressFamily.IPV4, socket_type: SocketType.STREAM);
		}
		
		construct {
			handlers = new Gee.HashMap<string, Handler*>();
			bind(new ServerAddress(server_port));
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
					var file = new Mee.IO.FdStream(fd,Mee.IO.FileMode.Read);
					string s = file.read_line();
					var path = s.split(" ")[1];
					Message message = new Message.empty(s.split(" ")[0]);
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
	
}
