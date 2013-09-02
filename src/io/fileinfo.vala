using Mee.Collections;

namespace Mee.IO
{
	public class FileInfo : Object
	{
		Posix.Stat st;
		
		public FileInfo(string filename){
			string path = filename;
			if(path == ".")
				path = Environment.get_current_dir();
			Posix.stat(path, out st);
			name = Path.get_filename(path);
			directory_name = Path.get_directoryname(path);
		}
		public FileInfo.fd(int fildes){
			Posix.fstat(fildes, out st);
		}
		
		public string directory_name { get; protected set; }
		public string name { get; protected set; }
		
		public size_t size {
			get { return st.st_size; }
		}
		public Mee.Date last_access_date {
			owned get { return new Mee.Date.from_time_t(st.st_atime); }
		}
		public Mee.Date last_modification_date {
			owned get { return new Mee.Date.from_time_t(st.st_mtime); }
		}
		public Mee.Date creation_date {
			owned get { return new Mee.Date.from_time_t(st.st_ctime); }
		}
	}
	
	public class DirectoryInfo : FileInfo, Iterable<FileInfo>
	{
		Posix.Dir dir;
		ArrayList<FileInfo> files;
		ArrayList<DirectoryInfo> directories;
		string _parent;
		string _root;
		size_t _size;
		
		public DirectoryInfo(string d){
			base(d);
			string path = d;
			if(d == ".")
				path = Environment.get_current_dir();
			else if(d == ".."){
				Posix.chdir("..");
				path = Environment.get_current_dir();
			}
			_size = 0;
			dir = Posix.opendir(path);
			files = new ArrayList<FileInfo>();
			directories = new ArrayList<DirectoryInfo>();
			unowned Posix.DirEnt? entry = null;
			int i = 0;
			entry = Posix.readdir(dir);
			while(entry != null){
				if((int)entry.d_type == 8){
					var file = new FileInfo(path+"/"+(string)entry.d_name);
					_size += file.size;
					files.add(file);
				}
				else if((int)entry.d_type == 4){
					if((string)entry.d_name == ".")
						_root = ".";
					else if((string)entry.d_name == "..")
						_parent = (string)entry.d_name;
					else{
						var di = new DirectoryInfo(path+"/"+(string)entry.d_name);
						directories.add(di);
						_size += di.size;
					}
				}
				entry = Posix.readdir(dir);
			}
		}
		
		public DirectoryInfo[] get_directories(){
			return directories.to_array();
		}
		public FileInfo[] get_files(){
			return files.to_array();
		}
		public DirectoryInfo parent {
			owned get { return new DirectoryInfo(_parent); }
		}
		public DirectoryInfo root {
			owned get { return new DirectoryInfo(_root); }
		}
		
		public new size_t size {
			get {
				return _size;
			}
		}
		
		public Iterator<FileInfo> iterator(){ return new FileInfoIterator(this); }
		
		class FileInfoIterator : Iterator<FileInfo>, Mee.Object
		{
			FileInfo[] array;
			int index;
			
			public FileInfoIterator(DirectoryInfo di){
				array = di.get_files();
				index = 0;
			}
			
			public FileInfo get(){ return array[index-1]; }
			public bool next(){
				if(index == array.length)
					return false;
				index++;
				return true;
			}
			public void reset(){ index = 0; }
		}
	}
}
