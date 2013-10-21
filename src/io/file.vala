namespace Mee.IO
{
	namespace File
	{
		public static uint8[] read_all_bytes (string path){
			var fs = new FileStream(path,FileMode.Read);
			return fs.read ((long)fs.size);
		}
		public static string read_all_text (string path){
			return (string)read_all_bytes(path);
		}
		public static string[] read_all_lines (string path){
			var list = new Gee.ArrayList<string>();
			var fs = open (path, FileMode.Read);
			string line = fs.read_line ();
			while (line != null){
				list.add (line);
				line = fs.read_line ();
			}
			return list.to_array();
		}
		
		public static uint8[] download_data (string uri){
			if(uri.index_of("file://") == 0)
				return read_all_bytes (Filename.from_uri (uri));
			var session = new Mee.Net.Session ();
			var message = new Mee.Net.Message (uri);
			message.request_headers["Connection"] = "Keep-Alive";
			message.request_headers["Accept"] = "*/*";
			message.request_headers["Host"] = message.uri.domain;
			session.send_message (message);
			return message.response_body.data;
		}
		
		public static string download_string (string uri){
			return (string)download_data (uri);
		}
		
		public static void download_file (string uri, string path){
			FileUtils.set_data (path, download_data (uri));
		}
		
		public static void write_all_bytes (string path, uint8[] buffer){
			var fs = new FileStream(path,FileMode.Write);
			fs.write (buffer);
		}
		public static void write_all_text (string path, string text){
			write_all_bytes (path, text.data);
		}
		public static void write_all_lines (string path, string[] lines){
			var fs = new FileStream(path,FileMode.Write);
			foreach (string line in lines)
				fs.write ((line+"\n").data);
		}
		public static void append_all_bytes (string path, uint8[] buffer){
			var fs = new FileStream(path, FileMode.Append);
			fs.write (buffer);
		}
		public static void append_all_text (string path, string text){
			append_all_bytes (path, text.data);
		}
		public static void append_all_lines (string path, string[] lines){
			var fs = new FileStream(path, FileMode.Append);
			foreach(string line in lines)
				fs.write ((line+"\n").data);
		}
		
		public static Stream open (string path, FileMode mode){
			return new FileStream(path, mode);
		}
		public static Stream open_uri (string uri, FileMode mode){
			if(uri.index_of("file://") == 0)
				return new FileStream (Filename.from_uri (uri), mode);
			return new NetStream (uri, mode);
		}
		public static Stream fdopen (int fildes, FileMode mode){
			return new FdStream (fildes, mode);
		}
		public static Stream create (string path, bool overwrite = false) throws Mee.Error
		{
			if(FileUtils.test(path,FileTest.EXISTS) && !overwrite)
				throw new Error.Content("file can't be overwrite");
			return new FileStream (path, FileMode.Write);
		}
	}
	
	public enum FileMode
	{
		Read,
		Write,
		Append,
		ReadBinary,
		WriteBinary,
		AppendBinary,
		ReadUpdate,
		WriteUpdate,
		AppendUpdate,
		ReadBinaryUpdate,
		WriteBinaryUpdate,
		AppendBinaryUpdate;
		
		internal string get_mode(){
			string[] array = {"r","w","a","rb","wb","ab","r+","w+","a+","rb+","wb+","ab+"};
			return array[(int)this];
		}
	}
	
	public enum SeekMode
	{
		Set,
		Current,
		End,
		Data,
		Hole
	}
}
