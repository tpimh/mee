using Mee.Collections;

namespace Mee.IO
{
	public enum FileAttributes
	{
		None,
		ReadOnly,
		Hidden,
		Directory,
		Archive
	}
	
	public class FileInfo : Object
	{
		Posix.Stat st;
		
		public FileInfo(string filename){
			string path = filename;
			if(path == ".")
				path = Environment.get_current_dir();
			exists = FileUtils.test(path,FileTest.EXISTS);
			Posix.stat(path, out st);
			name = Path.get_filename(path);
			directory_name = Path.get_directoryname(path);
			attrs = FileAttributes.None;
			if(Posix.S_ISDIR(st.st_mode))
				attrs |= FileAttributes.Directory;
			else{
				string ext = Path.get_extension(path);
				if(ext == ".7z" || ext == ".rar" || ext == ".zip" || ext == ".tar.gz" ||
					ext == ".tar.xz" || ext == ".tgz" || ext == ".tar.bz2" || ext == ".tar.lz" ||
					 ext == ".tar.lzma" || ext == ".ar" || ext == ".iso" || ext == ".jar")
				attrs |= FileAttributes.Archive;
			}
			if((st.st_mode & Posix.S_IWUSR) == 0)
				attrs |= FileAttributes.ReadOnly;
			if(name[0] == '.')
				attrs |= FileAttributes.Hidden;
		}
		public FileInfo.fd(int fildes){
			Posix.fstat(fildes, out st);
		}
		
		FileAttributes attrs;
		
		public string directory_name { get; protected set; }
		public string name { get; protected set; }
		public FileAttributes attributes {
			get { return attrs; }
			set {
				if(0 != (value & FileAttributes.ReadOnly)){
					Posix.chmod(directory_name+"/"+name,33060);	
				}else
					Posix.chmod(directory_name+"/"+name,33188);	
				if(0 != (value & FileAttributes.Hidden)){
					if(name[0] != '.'){
						FileUtils.rename(directory_name+"/"+name,directory_name+"/."+name);
					}
				}else if(name[0] == '.'){
					FileUtils.rename(directory_name+"/"+name,directory_name+"/"+name.substring(1));
				}
				attrs = value;
			}
		}
		public bool exists { get; protected set; }
		public bool is_read_only { get { return 0 != (attributes & FileAttributes.ReadOnly); } }
		public bool hidden { get { return 0 != (attributes & FileAttributes.Hidden); } }
		
		public size_t size {
			get { return st.st_size; }
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
				Posix.Dir cdir = Posix.opendir(path+"/"+(string)entry.d_name);
				if(cdir != null){
					var file = new FileInfo(path+"/"+(string)entry.d_name);
					_size += file.size;
					files.add(file);
				}
				else{
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
