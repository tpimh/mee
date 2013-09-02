namespace Mee.IO
{
	public class File : Object
	{
		FileStream fs;
		string _path;
		
		internal File(string path, string mode = "r+"){
			_path = path;
			fs = FileStream.open(path,mode);
			info = new FileInfo(path);
		}
		internal File.fd(int fildes, string mode = "r+"){
			fs = FileStream.fdopen(fildes,mode);
			info = new FileInfo.fd(fildes);
		}
		
		public FileInfo info { get; private set; }
		
		public string mime_type {
			owned get {
				return MimeType.from_extension(_path);
			}
		}
		
		public static new uint8[] get_data(string path){
			var file = new File(path,"r");
			var buffer = file.read((int)file.size);
			return buffer;
		}
		public static string get_contents(string path){
			return (string)get_data(path);
		}
		public static new void set_data(string path, uint8[] data){
			var file = new File(path,"w");
			file.write(data);
		}
		public static void set_contents(string path, string contents){
			set_data(path,contents.data);
		}
		
		public static File open(string path, string mode = "r+"){
			return new File(path,mode);
		}
		public static File fdopen(int fildes, string mode = "r+"){
			return new File.fd(fildes,mode);
		}
		
		public long size {
			get {
				long l = fs.tell();
				fs.seek(0,FileSeek.END);
				long _size = fs.tell();
				fs.seek(l,FileSeek.SET);
				return _size;
			}
		}
		
		public uint8[] read(int length){
			uint8[] buffer = new uint8[length];
			fs.read(buffer);
			return buffer;
		}
		
		public void write (uint8[] buffer){
			fs.write(buffer);
		}
		public int seek (long offset, GLib.FileSeek seektype = GLib.FileSeek.SET){
			return fs.seek(offset,seektype);
		}
		public void truncate(int offset){
			seek (0, FileSeek.SET);
			var buffer = read(offset - 1);
			fs = FileStream.open(_path,"w");
			fs.write(buffer);
			fs = FileStream.open(_path,"r+");
		}
		
		public long position {
			get { return fs.tell(); }
			set { seek(value,FileSeek.SET); }
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
			long _length = (length == -1) ? size : length;
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
			new File(new_path,"w").write(read((int)size));
			return true;
		}
		
		public File copy (string new_path, bool overwrite = true){
			if(FileUtils.test(new_path,FileTest.EXISTS) && overwrite == false)
				return null;
			var file = new File(new_path,"w");
			file.write(read((int)size));
			return file;
		}
		
		public bool eof(){ return fs.eof(); }
		
		public void delete(){ FileUtils.unlink(_path); }
		
		public string read_line() { return fs.read_line(); }
	}
}
