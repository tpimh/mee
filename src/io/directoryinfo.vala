using Gee;

namespace Mee.IO
{
	public class DirectoryInfo : FileInfo
	{
		Posix.Dir dir;
		ArrayList<FileInfo> _files;
		ArrayList<DirectoryInfo> _directories;
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
			_files = new ArrayList<FileInfo>();
			_directories = new ArrayList<DirectoryInfo>();
			unowned Posix.DirEnt? entry = null;
			int i = 0;
			entry = Posix.readdir(dir);
			while(entry != null){
				Posix.Dir cdir = Posix.opendir(path+"/"+(string)entry.d_name);
				if(cdir != null){
					var file = new FileInfo(path+"/"+(string)entry.d_name);
					_size += file.size;
					_files.add(file);
				}
				else{
					if((string)entry.d_name == ".")
						_root = ".";
					else if((string)entry.d_name == "..")
						_parent = (string)entry.d_name;
					else{
						var di = new DirectoryInfo(path+"/"+(string)entry.d_name);
						_directories.add(di);
						_size += di.size;
					}
				}
				entry = Posix.readdir(dir);
			}
		}
		
		public DirectoryInfo[] directories {
			owned get { return _directories.to_array(); }
		}
		public FileInfo[] files {
			owned get { return _files.to_array(); }
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
		
		public FileInfoIterator iterator(){ return new FileInfoIterator(this); }
		
		public class FileInfoIterator
		{
			FileInfo[] array;
			int index;
			
			public FileInfoIterator(DirectoryInfo di){
				array = di.files;
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
