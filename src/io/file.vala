using Mee.Collections;

namespace Mee.IO
{
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
	
	public enum SeekType
	{
		Set,
		Current,
		End,
		Data,
		Hole
	}
	
	public class File : Object
	{
		Posix.FILE fs;
		string _path;
		int _fd;
		
		~File(){
			info.attributes = attributes;
		}
		
		public File(string path, FileMode mode = FileMode.ReadUpdate){
			_path = path;
			_fd = -1;
			fs = Posix.FILE.open(path,mode.get_mode());
			info = new FileInfo(path);
			attributes = info.attributes;
		}
		public File.fd(int fildes, FileMode mode = FileMode.ReadUpdate){
			fs = Posix.FILE.fdopen(fildes,mode.get_mode());
			_fd = fildes;
			info = new FileInfo.fd(fildes);
			attributes = info.attributes;
		}
		
		public FileInfo info { get; private set; }
		
		public string mime_type {
			owned get {
				return MimeType.from_extension(_path);
			}
		}
		
		public FileAttributes attributes { get; set; }
		
		public static void delete(string path){ FileUtils.remove(path); }
		
		public static new uint8[] get_data(string path){
			var file = new File(path,FileMode.ReadBinary);
			var buffer = file.read((int)file.size);
			return buffer;
		}
		public static string get_contents(string path){
			return (string)get_data(path);
		}
		public static ArrayList<string> get_all_lines(string path){
			var file = new File(path,FileMode.Read);
			var list = new ArrayList<string>();
			string s = file.read_line();
			while(s != null){
				list.add(s);
				s = file.read_line();
			}
			return list;
		}
		public static new void set_data(string path, uint8[] data){
			var file = new File(path,FileMode.WriteBinary);
			file.write(data);
		}
		public static void set_contents(string path, string contents){
			set_data(path,contents.data);
		}
		public static void set_all_lines(string path, Iterable<string> iterable){
			var file = new File(path,FileMode.Write);
			foreach(string str in iterable)
				file.write((str+"\n").data);
		}
		
		public size_t size {
			get {
				return info.size;
			}
		}
		
		public uint8[] read(int length){
			uint8[] buffer = new uint8[length];
			fread(buffer,1,fs);
			return buffer;
		}
		
		public void write (uint8[] buffer){
			fwrite(buffer,1,fs);
		}
		public int seek (long offset, SeekType seektype = SeekType.Set){
			return fs.seek(offset,seektype);
		}
		public void truncate(int offset){
			seek (0, SeekType.Set);
			var buffer = read(offset - 1);
			fs = Posix.FILE.open(_path,"w");
			fwrite(buffer,1,fs);
			fs = Posix.FILE.open(_path,"r+");
		}
		
		public long position {
			get { return fs.tell(); }
			set { seek(value,SeekType.Set); }
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
		
		public bool copy_to(string new_path, bool overwrite = true){
			if(FileUtils.test(new_path,FileTest.EXISTS) && overwrite == false)
				return false;
			new File(new_path,FileMode.WriteBinary).write(read((int)size));
			return true;
		}
		
		public File copy (string new_path, bool overwrite = true){
			if(FileUtils.test(new_path,FileTest.EXISTS) && overwrite == false)
				return null;
			var file = new File(new_path,FileMode.WriteBinary);
			file.write(read((int)size));
			return file;
		}
		
		public bool eof(){ return fs.eof(); }
		
		public string? read_line () {
			int c;
			StringBuilder? ret = null;
			while ((c = fs.getc ()) != Posix.FILE.EOF) {
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
	}
}
