namespace Mee.IO
{
	public class Stream : GLib.Object
	{
		Posix.FILE file;
		
		~Stream(){
			if(info != null);
			info.attributes = attributes;
		}
		
		
		
		construct {
			if(path != null){
				try{
					info = new FileInfo (path);
				}catch{}
				file = Posix.FILE.open (path, mode.get_mode ());
			}
			else{
				file = Posix.FILE.fdopen (fd, mode.get_mode ());
				try{
					info = new FileInfo.fd (fd);
				}catch{}
			}
		}
		
		public uint8[] read (long length){
			uint8[] buffer = new uint8[length];
			fread (buffer,1,file);
			return buffer;
		}
		public uint8 read_byte (){
			return read(1)[0];
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
		public void truncate(long offset){
			seek (0, SeekMode.Set);
			var buffer = read(offset - 1);
			file = Posix.FILE.open(_path,"w");
			fwrite(buffer,1,file);
			file = Posix.FILE.open(_path,"r+");
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
		
		public long     position {
			get { return tell (); }
			set { seek (value, SeekMode.Current); }
		}
		public string         path       { get; construct; }
		public int            fd         { get; construct; }
		public FileMode       mode       { get; construct; }
		public FileInfo       info       { get; construct; }
		public FileAttributes attributes { get; set; }
		public size_t         size {
			get { return (info != null) ? info.size : -1; }
		}
	}
	
	public class FileStream : Stream
	{
		public FileStream (string path, FileMode mode){
			Object(path: path, mode: mode);
		}
	}
	
	public class FdStream : Stream
	{
		public FdStream(int fildes, FileMode mode){
			Object(fd: fildes, mode: mode);
		}
	}
}
