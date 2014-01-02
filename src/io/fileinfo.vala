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
	
	public class FileInfo : GLib.Object
	{
		Posix.Stat stat;
		FileAttributes attrs;
		
		public FileInfo (string path) throws GLib.Error
		{
			if(!FileUtils.test(path,FileTest.EXISTS))
				throw new MeeError.NULL ("file doesn't exist");
			
			Posix.stat (path, out stat);
			creation_date = new Date.from_time(stat.st_ctime);
			modification_date = new Date.from_time(stat.st_mtime);
			access_date = new Date.from_time(stat.st_atime);
			attrs = FileAttributes.None;
			name = Mee.IO.Path.get_filename(path);
			directory_name = Mee.IO.Path.get_directoryname(path);
			if(Posix.S_ISDIR(stat.st_mode))
				attrs |= FileAttributes.Directory;
			else{
				string ext = Mee.IO.Path.get_extension(path);
				if(ext == ".7z" || ext == ".rar" || ext == ".zip" || ext == ".tar.gz" ||
					ext == ".tar.xz" || ext == ".tgz" || ext == ".tar.bz2" || ext == ".tar.lz" ||
					 ext == ".tar.lzma" || ext == ".ar" || ext == ".iso" || ext == ".jar")
				attrs |= FileAttributes.Archive;
			}
			if((stat.st_mode & Posix.S_IWUSR) == 0)
				attrs |= FileAttributes.ReadOnly;
			if(name[0] == '.')
				attrs |= FileAttributes.Hidden;
		}
		public FileInfo.fd (int fildes){
			Posix.fstat (fildes, out stat);
		}
		
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
		public Date creation_date { get; protected set; }
		public Date modification_date { get; protected set; }
		public Date access_date { get; protected set; }
		public string directory_name { get; protected set; }
		public string name { get; protected set; }
		public bool read_only { get { return 0 != (attributes & FileAttributes.ReadOnly); } }
		public bool hidden { get { return 0 != (attributes & FileAttributes.Hidden); } }
		public size_t size { get { return stat.st_size; } }
	}
}
