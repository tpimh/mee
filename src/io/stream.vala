namespace Mee.IO
{
	public class Stream : GLib.Object
	{
		internal Posix.FILE file;
		
		~Stream(){
			if(info != null)
				info.attributes = attributes;
		}
		
		public void copy_to (Stream destination)
		{
			var pos = position;
			seek (0);
			uint8[] buffer = read (1024);
			while (buffer.length != 0)
			{
				destination.write (buffer);
				buffer = read (1024);
			}
			position = pos;
		}
		
		public void load_contents (out uint8[] data)
		{
			var list = new Gee.ArrayList<uint8> ();
			var buffer = read (512);
			while (buffer.length > 0)
			{
				list.add_all_array (buffer);
				buffer = read (512);
			}
			data = list.to_array ();
		}
		
		public int flush (){
			return file.flush ();
		}
		
		public uint8[] read (long length){
			uint8[] buffer = new uint8[length];
			var br = fread (buffer,1,file);
			if (br != length)
				buffer.resize ((int)br);
			return buffer;
		}
		public int read_byte (){
			var buffer = new uint8[1];
			var res = fread (buffer,1,file);
			if (res == 0)
				return -1;
			return (int)buffer[0];
		}
		public Gee.List<uint8> read_list (long length){
			return new Gee.ArrayList<uint8>.wrap(read(length));
		}
		public void write (uint8[] buffer){
			fwrite (buffer,1,file);
		}
		
		public void write_byte (uint8 byte){
			write (new uint8[]{byte});
		}
		public void write_list (Gee.List<uint8> list){
			write (list.to_array());
		}
		
		public void seek (long offset, SeekMode seek_mode = Mee.IO.SeekMode.Set){
			file.seek (offset, (int)seek_mode);
		}
		public void truncate(long offset)
		{
			seek (0, SeekMode.Set);
			var buffer = read(offset - 1);
			if (path != null)
				file = Posix.FILE.open(path,"w");
			else
				file = Posix.FILE.fdopen (fd, "w");
			fwrite(buffer,1,file);
			if (path != null)
				file = Posix.FILE.open (path,"r+");
			else
				file = Posix.FILE.fdopen (fd, "r+");
		}
				public long find (uint8[] array, long start = 0){
			long l = position;
			for(long i=start; i<size-array.length; i++){
				var buffer = read(array.length);
				seek(position-array.length+1);
				bool exact = true;
				for (var j = 0; j < buffer.length; j++)
					if(buffer[j] != array[j]){
						exact = false; break;
					}
				if(exact == true)return i;
						
			}
			position = l;
			return -1;
		}
		public void remove(long start = 0, long length = -1){
			int buffer_length = 1024;
			long _length = (length == -1) ? (long)size : length;
			long read_position = start + _length;
			long write_position = start;
			uint8[] buffer;
			while(true){
				if(read_position>=size)break;
				position = read_position;
				buffer = read(buffer_length);
				read_position += buffer.length;
				position = write_position;
				write(buffer);
				write_position += buffer.length;
			}
			truncate((int)write_position);
		}
		public bool insert(uint8[] data, long start = 0, long replace = -1){
			if(replace == -1 || data.length == replace){
				seek(start);
				write(data);
				return true;
			}else if(data.length < replace){
				seek(start);
				write(data);
				remove(start+data.length,replace-data.length);
				return true;
			}
			seek(start);
			for(long i=start; i<replace-start; i++)
				read(1);
			uint8[] last = read((int)(size-position));
			seek(start);
			write(data);
			write(last);
			return true;
		}
		
		
		public long tell (){
			return file.tell ();
		}
		
		public bool eof {
			get {
				return file.eof ();
			}
		}
		
		public void write_line (string? line = null){
			if(line == null)
				write ("\r\n".data);
			else
				write ((line+"\r\n").data);
		}
		
		public string? read_line () {
			int c;
			StringBuilder? ret = null;
			while ((c = file.getc ()) != Posix.FILE.EOF) {
				if (ret == null) {
					ret = new StringBuilder ();
				}
				if (c == '\n') {
					break;
				}
				((!)(ret)).append_c ((char) c);
			}
			if (ret == null) {
				return null;
			} else {
				return ((!)(ret)).str;
			}
		}
		
		public string? read_rline (){
			string? s = read_line ();
			if(s == null)
				return s;
			return s.split("\r")[0];
		}
		
		public long     position {
			get { return tell (); }
			set { seek (value, SeekMode.Current); }
		}
		public string         path       { get; construct; }
		public int            fd         { get; protected set construct; }
		public FileMode       mode       { get; construct; }
		public FileInfo       info       { get; construct; }
		public FileAttributes attributes { get; set; }
		public size_t         size {
			get { return (info != null) ? info.size : -1; }
		}
	}
	
	public class FileStream : Stream
	{
		public FileStream (string path, FileMode mode = Mee.IO.FileMode.ReadUpdate){
			Object(path: path, mode: mode);
		}
		
		construct {
			file = Posix.FILE.open (path, mode.get_mode ());
			try{
				info = new FileInfo (path);
			}catch{}
		}
	}
	
	public class FdStream : Stream
	{
		public FdStream(int fildes, FileMode mode = Mee.IO.FileMode.ReadUpdate){
			Object(fd: fildes, mode: mode);
		}
		
		construct {
			file = Posix.FILE.fdopen (fd, mode.get_mode ());
		}
	}
	
	public class SocketStream : Stream
	{
		Mee.Net.Socket socket;
		
		~SocketStream (){
			socket.close ();
		}
		
		public SocketStream (string uri, FileMode mode = Mee.IO.FileMode.ReadUpdate){
			Object (uri: uri, mode: mode);
		}
		
		construct {
			socket = new Mee.Net.Socket (Mee.Net.AddressFamily.IPV6);
			var _uri = new Mee.Net.Uri (uri);
			var host = new Mee.Net.Host (_uri.domain);
			if(host.ipv6_supported){
				var addr = new Mee.Net.IPV6Address.uri (_uri);
				socket.connect_ipv6_address (addr);
			}else {
				socket = new Mee.Net.Socket ();
				var addr = new Mee.Net.IPV4Address.uri (_uri);
				socket.connect_ipv4_address (addr);	
			}		
			file = Posix.FILE.fdopen (socket.descriptor, mode.get_mode ());
		}
		
		public int descriptor {
			get {
				return socket.descriptor;
			}
		}
		public string uri { get; construct; }
	}
	
	public class NetStream : Stream
	{
		Mee.Net.Socket socket;
		
		~NetStream(){
			socket.close ();
		}
		
		public NetStream(string uri, FileMode mode = Mee.IO.FileMode.ReadUpdate){
			Object (uri: uri, mode: mode);
		}
		
		construct {
			socket = new Mee.Net.Socket (Mee.Net.AddressFamily.IPV6);
			var _uri = new Mee.Net.Uri (uri);
			var host = new Mee.Net.Host (_uri.domain);
			if(host.ipv6_supported){
				var addr = new Mee.Net.IPV6Address.uri (_uri);
				socket.connect_ipv6_address (addr);
			}else {
				socket = new Mee.Net.Socket ();
				var addr = new Mee.Net.IPV4Address.uri (_uri);
				socket.connect_ipv4_address (addr);	
			}		
			file = Posix.FILE.fdopen (socket.descriptor, mode.get_mode ());
			var message = new Mee.Net.Message (uri,"GET");
			message.request_headers["Host"] = _uri.domain;
			message.request_headers["Accept"] = "*/*";
			message.request_headers["Connection"] = "Keep-Alive";
			if(_uri.authentication != null)
				_uri.authentication.authorization_requested (message);
			string s = "%s %s %s".printf(message.method,message.uri.path,message.http_version);
			write_line (s);
			message.request_headers.foreach ((key, value) => {
				write_line ("%s: %s".printf(key,value));
			});
			write_line ();
			s = read_rline();
			message.status_code = int.parse(s.split(" ")[1]);
			s = read_rline();
			while(s.length > 1){
				string k = s.substring(0,s.index_of(":")).down();
				string v = s.substring(1+s.index_of(":")).chug();
				message.got_headers(k,v);
				message.response_headers[k] = v;
				s = read_rline();
			}
			while (message.status_code == 302)
			{
				_uri = new Mee.Net.Uri (message.response_headers["location"]);
				socket = new Mee.Net.Socket (Mee.Net.AddressFamily.IPV6);
				host = new Mee.Net.Host (_uri.domain);
				if(host.ipv6_supported){
					var addr = new Mee.Net.IPV6Address.uri (_uri);
					socket.connect_ipv6_address (addr);
				}else {
					socket = new Mee.Net.Socket ();
					var addr = new Mee.Net.IPV4Address.uri (_uri);
					socket.connect_ipv4_address (addr);	
				}
				file = Posix.FILE.fdopen (socket.descriptor, mode.get_mode ());
				message = new Mee.Net.Message (message.response_headers["location"],"GET");
				message.request_headers["Host"] = _uri.domain;
				message.request_headers["Accept"] = "*/*";
				message.request_headers["Connection"] = "Keep-Alive";
				if(_uri.authentication != null)
					_uri.authentication.authorization_requested (message);
				s = "%s %s %s".printf(message.method,message.uri.path,message.http_version);
				write_line (s);
				message.request_headers.foreach ((key, value) => {
					write_line ("%s: %s".printf(key,value));
				});
				write_line ();
				s = read_rline();
				message.status_code = int.parse(s.split(" ")[1]);
				s = read_rline();
				while(s.length > 1){
					string k = s.substring(0,s.index_of(":")).down();
					string v = s.substring(1+s.index_of(":")).chug();
					message.got_headers(k,v);
					message.response_headers[k] = v;
					s = read_rline();
				}
			}
			chunked = message.response_headers["transfer-encoding"] == "chunked" ? true : false;
			if(chunked){
					int64 cs = Mee.try_parse_hex (read_rline ());
					chunked_data = new Gee.ArrayList<uint8>();
					chunked_pos = 0;
					while (cs > 0){
						chunked_data.add_all_array (base.read ((long)cs));
						base.read(2);
						cs = Mee.try_parse_hex (read_rline ());
					}
			}
		}
		
		Gee.ArrayList<uint8> chunked_data;
		long chunked_pos;
		public new void write (uint8[] buffer)
		{
			if (chunked)
			{
				foreach(uint8 u in buffer)
				{
					if (chunked_pos < chunked_data.size)
						chunked_data[(int)chunked_pos] = u;
					else
						chunked_data.add (u);
					chunked_pos++;
				}
			}
			else
				base.write (buffer);
		}
		public new uint8[] read (long length)
		{
			if (chunked)
			{
				if (chunked_pos >= chunked_data.size)
					return null;
				long len = length;
				if (chunked_pos + len >= chunked_data.size)
					len = chunked_data.size - chunked_pos;
				var buffer = chunked_data.slice ((int)chunked_pos, (int)(chunked_pos + len)).to_array();
				chunked_pos += len;
				return buffer;
			}
			return base.read (length);
		}
		
		public new void load_contents (out uint8[] data)
		{
			if (chunked)
				data = chunked_data.to_array ();
			else
				base.load_contents (out data);
		}
		
		public new int read_byte ()
		{
			if (chunked)
			{
				var buffer = read (1);
				if (buffer == null)
					return -1;
				return (int)buffer[0];
			}
			return base.read_byte ();
		}
		
		public new long tell ()
		{
			if (chunked)
				return chunked_pos;
			return base.tell ();
		}
		
		public new void seek (long offset, SeekMode mode = Mee.IO.SeekMode.Current)
		{
			if (chunked)
				chunked_pos += offset;
			else
				base.seek (offset, mode);
		}
		
		public bool chunked { get; private set; }
		public string uri { get; construct; }
		public new bool eof {
			get {
				if (chunked)
					return chunked_pos < chunked_data.size;
				return file.eof ();
			}
		}
	}
}
